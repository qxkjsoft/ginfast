package service

import (
	"context"
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/filehelper"
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

	// 秒传检测：根据MD5查找是否已有相同文件
	existAffix, _ := models.GetAffixByMd5(ctx, req.FileMd5, req.FileSize, tenantID)
	if existAffix != nil && existAffix.ID > 0 {
		return &models.ChunkInitResult{
			UploadId:       "",
			UploadedChunks: []int{},
			ExistFile:      existAffix,
		}, nil
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
	app.DB().WithContext(ctx).Model(&models.SysAffixChunk{}).
		Where("upload_id = ? AND chunk_index = ? AND tenant_id = ?", req.UploadId, req.ChunkIndex, tenantID).
		Count(&existingCount)

	if existingCount > 0 {
		// 更新已有记录
		app.DB().WithContext(ctx).Model(&models.SysAffixChunk{}).
			Where("upload_id = ? AND chunk_index = ? AND tenant_id = ?", req.UploadId, req.ChunkIndex, tenantID).
			Updates(map[string]interface{}{
				"chunk_path": chunkPath,
				"chunk_size": req.File.Size,
				"status":     0,
			})
	} else {
		// 创建新记录
		if err := chunk.Create(ctx); err != nil {
			return fmt.Errorf("保存分片记录失败: %v", err)
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

	// 验证分片数量
	if len(*chunkList) != req.TotalChunks {
		return nil, fmt.Errorf("分片不完整，已上传 %d/%d", len(*chunkList), req.TotalChunks)
	}

	// 获取上传配置
	uploadConfig := app.UploadService.GetUploadConfig()
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
	affix.FileMd5 = req.FileMd5
	affix.CreatedBy = userID
	affix.TenantID = tenantID

	if err := affix.Create(ctx); err != nil {
		os.Remove(finalPath)
		return nil, fmt.Errorf("保存文件记录失败: %v", err)
	}

	// 更新分片记录状态为已合并
	models.UpdateChunkStatus(ctx, req.UploadId, tenantID, 1)

	// 异步清理临时分片文件
	go func() {
		os.RemoveAll(tmpDir)
		models.DeleteChunksByUploadId(ctx, req.UploadId, tenantID)
	}()

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

	// 更新分片记录状态为已取消
	models.UpdateChunkStatus(ctx, uploadId, tenantID, 2)

	// 删除分片记录
	models.DeleteChunksByUploadId(ctx, uploadId, tenantID)

	return nil
}
