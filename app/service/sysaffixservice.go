package service

import (
	"context"
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/filehelper"
	"gin-fast/app/utils/goroutinehelper"
	"gin-fast/app/utils/gormhelper"
	"io"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/google/uuid"
	"go.uber.org/zap"
)

// SysAffixService 文件附件服务
type SysAffixService struct {
}

// NewSysAffixService 创建文件附件服务
func NewSysAffixService() *SysAffixService {
	return &SysAffixService{}
}

// ValidateChunkFile 验证分片上传的文件类型和大小
func (s *SysAffixService) ValidateChunkFile(fileName string, fileSize int64) error {
	uploadConfig := app.UploadService.GetUploadConfig()

	// 验证文件类型
	if len(uploadConfig.ChunkAllowedTypes) > 0 {
		ext := strings.ToLower(filepath.Ext(fileName))
		if ext == "" {
			return fmt.Errorf("无法识别文件类型")
		}
		allowed := false
		for _, allowedType := range uploadConfig.ChunkAllowedTypes {
			if strings.EqualFold(ext, allowedType) {
				allowed = true
				break
			}
		}
		if !allowed {
			return fmt.Errorf("文件类型不允许，允许的类型: %v", uploadConfig.ChunkAllowedTypes)
		}
	}

	// 验证文件大小
	maxSize := int64(uploadConfig.ChunkMaxSize * 1024 * 1024) // 转换为字节
	if maxSize > 0 && fileSize > maxSize {
		return fmt.Errorf("文件大小超过限制，最大允许 %d MB", uploadConfig.ChunkMaxSize)
	}

	return nil
}

// ValidateChunkSize 验证单个分片大小
func (s *SysAffixService) ValidateChunkSize(chunkSize int64) error {
	uploadConfig := app.UploadService.GetUploadConfig()
	maxChunkSize := int64(uploadConfig.MaxChunkSize * 1024 * 1024) // 转换为字节
	if maxChunkSize > 0 && chunkSize > maxChunkSize {
		return fmt.Errorf("分片大小超过限制，最大允许 %d MB", uploadConfig.MaxChunkSize)
	}
	return nil
}

// InitChunkUpload 初始化分片上传（秒传检测 + 断点续传）
func (s *SysAffixService) InitChunkUpload(ctx context.Context, req *models.ChunkInitRequest, tenantID uint) (*models.ChunkInitResult, error) {
	// 验证分片上传的文件类型和大小
	if err := s.ValidateChunkFile(req.FileName, req.FileSize); err != nil {
		return nil, err
	}

	// 校验分片总数不超过配置推导的上限（防恶意声明超大 TotalChunks 刷海量分片）
	uploadConfig := app.UploadService.GetUploadConfig()
	if req.TotalChunks < 1 || req.TotalChunks > maxTotalChunks(uploadConfig) {
		return nil, fmt.Errorf("分片总数超出允许范围(1~%d)", maxTotalChunks(uploadConfig))
	}

	// 秒传检测：根据MD5查找是否已有相同文件
	existAffix, _ := models.GetAffixByMd5(ctx, req.FileMd5, req.FileSize, tenantID)
	if existAffix != nil && existAffix.ID > 0 {
		// 服务端复核源文件实际MD5，防止凭伪造/脏MD5引用他人已上传文件；
		// 复核未通过（内容不符或磁盘文件缺失）时降级为正常分片上传
		actualMd5, md5Err := filehelper.CalculateFileMD5(existAffix.Path)
		if md5Err != nil || !strings.EqualFold(actualMd5, req.FileMd5) {
			app.ZapLog.Warn("秒传源文件MD5复核未通过，降级为分片上传",
				zap.Uint("affixId", existAffix.ID), zap.Error(md5Err))
		} else {
			return &models.ChunkInitResult{
				UploadId:       "",
				UploadedChunks: []int{},
				ExistFile:      existAffix,
			}, nil
		}
	}

	// 生成唯一uploadId
	uploadId := fmt.Sprintf("upload_%d_%s", time.Now().Unix(), uuid.New().String()[:8])

	// 查询该fileMd5是否已有上传中的分片（断点续传）
	uploadedChunks := []int{}
	existingChunks := models.NewSysAffixChunkList()
	if err := app.DB().WithContext(ctx).
		Where("file_md5 = ? AND status = 0 AND tenant_id = ?", req.FileMd5, tenantID).
		Find(existingChunks).Error; err == nil && len(*existingChunks) > 0 {
		// 找到已有分片，复用第一个uploadId
		first := (*existingChunks)[0]
		uploadId = first.UploadId
		for _, chunk := range *existingChunks {
			uploadedChunks = append(uploadedChunks, chunk.ChunkIndex)
		}
	}

	return &models.ChunkInitResult{
		UploadId:       uploadId,
		UploadedChunks: uploadedChunks,
		ExistFile:      nil,
	}, nil
}

// SaveChunk 保存单个分片（文件I/O + 数据库记录）
func (s *SysAffixService) SaveChunk(ctx context.Context, req *models.ChunkUploadRequest, userID, tenantID uint) error {
	// 验证单个分片大小
	if err := s.ValidateChunkSize(req.File.Size); err != nil {
		return err
	}

	// 获取上传配置
	uploadConfig := app.UploadService.GetUploadConfig()

	// 校验分片总数上限与分片序号范围（防越界/恶意刷分片）
	if req.TotalChunks < 1 || req.TotalChunks > maxTotalChunks(uploadConfig) {
		return fmt.Errorf("分片总数超出允许范围(1~%d)", maxTotalChunks(uploadConfig))
	}
	if req.ChunkIndex < 1 || req.ChunkIndex > req.TotalChunks {
		return fmt.Errorf("分片序号超出范围(1~%d)", req.TotalChunks)
	}

	localPath := uploadConfig.LocalPath

	// 创建临时分片目录
	tmpDir := filepath.Join(localPath, "tmp", req.UploadId)
	if err := os.MkdirAll(tmpDir, 0755); err != nil {
		return fmt.Errorf("创建临时目录失败: %v", err)
	}

	// 保存分片文件
	chunkPath := filepath.Join(tmpDir, fmt.Sprintf("chunk_%d", req.ChunkIndex))
	src, err := req.File.Open()
	if err != nil {
		return fmt.Errorf("打开分片文件失败: %v", err)
	}
	defer src.Close()

	dst, err := os.Create(chunkPath)
	if err != nil {
		return fmt.Errorf("创建分片文件失败: %v", err)
	}
	defer dst.Close()

	if _, err := io.Copy(dst, src); err != nil {
		return fmt.Errorf("保存分片文件失败: %v", err)
	}

	// 客户端声明分片MD5时校验分片实际内容（可选增强：当前前端未传该字段，非空才校验）
	if req.ChunkMd5 != "" {
		chunkActualMd5, md5Err := filehelper.CalculateFileMD5(chunkPath)
		if md5Err != nil {
			os.Remove(chunkPath)
			return fmt.Errorf("计算分片MD5失败: %v", md5Err)
		}
		if !strings.EqualFold(chunkActualMd5, req.ChunkMd5) {
			os.Remove(chunkPath)
			return fmt.Errorf("分片内容校验失败，请重新上传该分片")
		}
	}

	// 记录分片到数据库
	chunk := models.NewSysAffixChunk()
	chunk.UploadId = req.UploadId
	chunk.FileMd5 = req.FileMd5
	chunk.FileName = ""
	chunk.ChunkSize = int(req.File.Size)
	chunk.TotalChunks = req.TotalChunks
	chunk.ChunkIndex = req.ChunkIndex
	chunk.ChunkPath = chunkPath
	chunk.Status = 0
	chunk.CreatedBy = userID
	chunk.TenantID = tenantID

	// 检查是否已存在该分片记录（幂等处理）
	var existingCount int64
	if err := app.DB().WithContext(ctx).Model(&models.SysAffixChunk{}).
		Where("upload_id = ? AND chunk_index = ? AND tenant_id = ?", req.UploadId, req.ChunkIndex, tenantID).
		Count(&existingCount).Error; err != nil {
		return fmt.Errorf("查询分片记录失败: %v", err)
	}

	if existingCount > 0 {
		// 更新已有记录
		if err := app.DB().WithContext(ctx).Model(&models.SysAffixChunk{}).
			Where("upload_id = ? AND chunk_index = ? AND tenant_id = ?", req.UploadId, req.ChunkIndex, tenantID).
			Updates(map[string]interface{}{
				"chunk_path": chunkPath,
				"chunk_size": req.File.Size,
				"status":     0,
			}).Error; err != nil {
			return fmt.Errorf("更新分片记录失败: %v", err)
		}
	} else {
		// 创建新记录；并发重传同分片触发唯一索引冲突时转更新，保持幂等
		if err := chunk.Create(ctx); err != nil {
			if !gormhelper.IsDuplicateKeyError(err) {
				return fmt.Errorf("保存分片记录失败: %v", err)
			}
			if uerr := app.DB().WithContext(ctx).Model(&models.SysAffixChunk{}).
				Where("upload_id = ? AND chunk_index = ? AND tenant_id = ?", req.UploadId, req.ChunkIndex, tenantID).
				Updates(map[string]interface{}{
					"chunk_path": chunkPath,
					"chunk_size": req.File.Size,
					"status":     0,
				}).Error; uerr != nil {
				return fmt.Errorf("更新分片记录失败: %v", uerr)
			}
		}
	}

	return nil
}

// MergeChunks 合并分片（文件合并 + 大小校验 + 附件记录 + 清理）
func (s *SysAffixService) MergeChunks(ctx context.Context, req *models.ChunkMergeRequest, userID, tenantID uint) (*models.SysAffix, error) {
	// 验证分片上传的文件类型
	if err := s.ValidateChunkFile(req.FileName, req.FileSize); err != nil {
		return nil, err
	}

	// 获取所有分片记录
	chunkList, err := models.GetChunksByUploadId(ctx, req.UploadId, tenantID)
	if err != nil {
		return nil, fmt.Errorf("获取分片记录失败: %v", err)
	}

	// 校验分片总数上限
	uploadConfig := app.UploadService.GetUploadConfig()
	if req.TotalChunks < 1 || req.TotalChunks > maxTotalChunks(uploadConfig) {
		return nil, fmt.Errorf("分片总数超出允许范围(1~%d)", maxTotalChunks(uploadConfig))
	}

	// 校验分片序号恰好为 1..TotalChunks（连续、无缺失、无重复）
	chunkIndexes := make([]int, len(*chunkList))
	for i, chunk := range *chunkList {
		chunkIndexes[i] = chunk.ChunkIndex
	}
	if err := validateChunkIndexes(chunkIndexes, req.TotalChunks); err != nil {
		return nil, err
	}

	localPath := uploadConfig.LocalPath

	// 生成最终文件名
	ext := strings.ToLower(filepath.Ext(req.FileName))
	if ext == "" {
		ext = ".bin"
	}
	timestamp := time.Now().Format("20060102")
	newFileName := fmt.Sprintf("%s_%s%s", timestamp, uuid.New().String(), ext)
	dateFolder := time.Now().Format("2006-01-02")

	// 确保目标目录存在
	destDir := filepath.Join(localPath, dateFolder)
	if err := os.MkdirAll(destDir, 0755); err != nil {
		return nil, fmt.Errorf("创建目标目录失败: %v", err)
	}

	// 最终文件路径
	finalPath := filepath.Join(destDir, newFileName)

	// 合并分片文件
	finalFile, err := os.Create(finalPath)
	if err != nil {
		return nil, fmt.Errorf("创建最终文件失败: %v", err)
	}
	defer finalFile.Close()

	tmpDir := filepath.Join(localPath, "tmp", req.UploadId)
	var totalSize int64 = 0

	for _, chunk := range *chunkList {
		chunkFilePath := filepath.Join(tmpDir, fmt.Sprintf("chunk_%d", chunk.ChunkIndex))
		chunkFile, err := os.Open(chunkFilePath)
		if err != nil {
			os.Remove(finalPath)
			return nil, fmt.Errorf("打开分片 %d 失败: %v", chunk.ChunkIndex, err)
		}

		written, err := io.Copy(finalFile, chunkFile)
		chunkFile.Close()
		if err != nil {
			os.Remove(finalPath)
			return nil, fmt.Errorf("合并分片 %d 失败: %v", chunk.ChunkIndex, err)
		}
		totalSize += written
	}

	// 验证合并后文件总大小与声明大小是否一致
	if req.FileSize > 0 && totalSize != req.FileSize {
		os.Remove(finalPath)
		return nil, fmt.Errorf("文件大小不一致，声明 %d 字节，实际 %d 字节", req.FileSize, totalSize)
	}

	// 服务端计算合并后文件实际MD5并与声明值比对（完整性校验，防伪造/传输损坏）
	actualFileMd5, err := filehelper.CalculateFileMD5(finalPath)
	if err != nil {
		os.Remove(finalPath)
		return nil, fmt.Errorf("计算文件MD5失败: %v", err)
	}
	if !strings.EqualFold(actualFileMd5, req.FileMd5) {
		os.Remove(finalPath)
		return nil, fmt.Errorf("文件校验失败，请重新上传")
	}

	// 获取文件URL
	serverRootPath := app.ConfigYml.GetString("httpserver.serverrootpath")
	fileUrl := fmt.Sprintf("%s/uploads/%s/%s", strings.TrimSuffix(serverRootPath, "/"), dateFolder, newFileName)
	if !strings.HasPrefix(fileUrl, "/") {
		fileUrl = "/" + fileUrl
	}

	// 创建附件记录
	affix := models.NewSysAffix()
	affix.Name = req.FileName
	affix.Path = finalPath
	affix.Url = fileUrl
	affix.Size = int(totalSize)
	affix.Suffix = ext
	affix.Ftype = filehelper.GetFileTypeBySuffix(ext)
	// 存服务端计算的实际MD5（作为后续秒传检测的可信依据）
	affix.FileMd5 = actualFileMd5
	affix.CreatedBy = userID
	affix.TenantID = tenantID

	if err := affix.Create(ctx); err != nil {
		os.Remove(finalPath)
		return nil, fmt.Errorf("保存文件记录失败: %v", err)
	}

	// 更新分片记录状态为已合并（失败不中断主流程：附件已落库，返回失败会诱导
	// 客户端重试合并造成重复附件；但状态残留会留下脏数据，记 Error 便于排查）
	if err := models.UpdateChunkStatus(ctx, req.UploadId, tenantID, 1); err != nil {
		app.ZapLog.Error("更新分片合并状态失败", zap.Error(err))
	}

	// 异步清理临时分片文件
	// context.WithoutCancel 断开与已结束请求的关联，避免异步读取已被复用的 gin.Context；
	// GoSafe 捕获 panic，防止异步任务拖垮进程
	cleanCtx := context.WithoutCancel(ctx)
	goroutinehelper.GoSafe("sysaffix.mergeCleanup", func() {
		if err := os.RemoveAll(tmpDir); err != nil {
			app.ZapLog.Warn("清理临时分片目录失败", zap.Error(err))
		}
		if err := models.DeleteChunksByUploadId(cleanCtx, req.UploadId, tenantID); err != nil {
			app.ZapLog.Warn("清理分片记录失败", zap.Error(err))
		}
	})

	return affix, nil
}

// CancelChunkUpload 取消分片上传（清理临时文件 + 更新状态）
func (s *SysAffixService) CancelChunkUpload(ctx context.Context, uploadId string, tenantID uint) error {
	// 获取上传配置
	uploadConfig := app.UploadService.GetUploadConfig()
	localPath := uploadConfig.LocalPath

	// 删除临时分片目录
	tmpDir := filepath.Join(localPath, "tmp", uploadId)
	if err := os.RemoveAll(tmpDir); err != nil {
		app.ZapLog.Warn("清理临时分片目录失败", zap.Error(err))
	}

	// 更新分片记录状态为已取消（清理路径：失败仅记日志，不中断取消流程）
	if err := models.UpdateChunkStatus(ctx, uploadId, tenantID, 2); err != nil {
		app.ZapLog.Error("更新分片取消状态失败", zap.Error(err))
	}

	// 删除分片记录（清理路径：失败仅记日志，不中断取消流程）
	if err := models.DeleteChunksByUploadId(ctx, uploadId, tenantID); err != nil {
		app.ZapLog.Warn("删除分片记录失败", zap.Error(err))
	}

	return nil
}

// defaultMaxTotalChunks 上传配置缺失时的分片总数兜底上限
const defaultMaxTotalChunks = 10000

// maxTotalChunks 根据上传配置推导分片总数上限（文件总大小上限/单分片上限，向上取整），
// 防止恶意声明超大 TotalChunks 刷海量分片耗磁盘；单分片配置非法时常量兜底
func maxTotalChunks(uploadConfig app.UploadConfig) int {
	if uploadConfig.MaxChunkSize <= 0 {
		return defaultMaxTotalChunks
	}
	limit := (uploadConfig.ChunkMaxSize + uploadConfig.MaxChunkSize - 1) / uploadConfig.MaxChunkSize
	if limit < 1 {
		limit = 1
	}
	return limit
}

// validateChunkIndexes 校验分片序号集合恰好为 1..total（1-based，连续、无缺失、无重复）
func validateChunkIndexes(indexes []int, total int) error {
	if total < 1 {
		return fmt.Errorf("分片总数不合法")
	}
	seen := make(map[int]bool, len(indexes))
	for _, idx := range indexes {
		if idx < 1 || idx > total {
			return fmt.Errorf("分片序号 %d 超出范围(1~%d)", idx, total)
		}
		if seen[idx] {
			return fmt.Errorf("分片 %d 重复", idx)
		}
		seen[idx] = true
	}
	if len(indexes) != total {
		return fmt.Errorf("分片不完整，已上传 %d/%d", len(indexes), total)
	}
	return nil
}
