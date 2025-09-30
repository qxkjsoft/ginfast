package uploadhelper

import (
	"context"
	"fmt"
	"gin-fast/app/global/app"
	"mime/multipart"
	"path/filepath"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/qiniu/go-sdk/v7/auth/qbox"
	"github.com/qiniu/go-sdk/v7/storage"
)

// QiniuUploadService 七牛云文件上传服务
type QiniuUploadService struct {
	config app.UploadConfig
	mac    *qbox.Mac
	cfg    *storage.Config
	bucket string
	domain string
}

// NewQiniuUploadService 创建七牛云文件上传服务
func NewQiniuUploadService() app.FileUploadService {
	config := GetUploadConfig()

	// 创建七牛云认证对象
	mac := qbox.NewMac(config.QiniuConfig.AccessKey, config.QiniuConfig.SecretKey)

	// 创建七牛云配置对象
	cfg := &storage.Config{
		// 空间对应的机房
		Zone: getZone(config.QiniuConfig.Zone),
		// 是否使用https域名
		UseHTTPS: true,
		// 上传是否使用CDN上传加速
		UseCdnDomains: true,
	}

	return &QiniuUploadService{
		config: config,
		mac:    mac,
		cfg:    cfg,
		bucket: config.QiniuConfig.Bucket,
		domain: config.QiniuConfig.Domain,
	}
}

// HandleUpload 处理文件上传（HTTP请求处理）
func (s *QiniuUploadService) HandleUpload(c *gin.Context, fileName string) (*app.UploadResponse, error) {
	// 获取上传的文件
	file, err := c.FormFile(fileName)
	if err != nil {
		return nil, fmt.Errorf("获取文件失败: %v", err)
	}

	// 验证文件
	if valid, err := s.ValidateFile(file); !valid {
		return nil, err
	}

	// 上传文件
	fileUrl, err := s.UploadFile(file)
	if err != nil {
		return nil, fmt.Errorf("上传文件失败: %v", err)
	}

	// 获取文件扩展名
	fileExt := s.GetFileExtension(file.Filename)

	// 构建响应
	response := &app.UploadResponse{
		Url:      fileUrl,
		FileName: file.Filename,
		Size:     file.Size,
		FileType: fileExt,
	}

	return response, nil
}

// UploadFile 上传文件
func (s *QiniuUploadService) UploadFile(file *multipart.FileHeader) (string, error) {
	// 生成文件名
	fileName := s.GenerateFileName(file.Filename)

	// 上传文件
	key := fileName
	return s.uploadFile(file, key)
}

// UploadFileWithCustomPath 上传文件到指定路径
func (s *QiniuUploadService) UploadFileWithCustomPath(file *multipart.FileHeader, customPath string) (string, error) {
	// 生成文件名
	fileName := s.GenerateFileName(file.Filename)

	// 构建文件key
	key := filepath.Join(customPath, fileName)

	// 上传文件
	return s.uploadFile(file, key)
}

// DeleteFile 删除文件
func (s *QiniuUploadService) DeleteFile(fileUrl string) error {
	// 从URL中提取文件key
	key := s.getFileKeyFromUrl(fileUrl)
	if key == "" {
		return fmt.Errorf("无效的文件URL: %s", fileUrl)
	}

	// 创建七牛云存储管理器
	bucketManager := storage.NewBucketManager(s.mac, s.cfg)

	// 删除文件
	err := bucketManager.Delete(s.bucket, key)
	if err != nil {
		return fmt.Errorf("删除文件失败: %v", err)
	}

	return nil
}

// GetFileUrl 获取文件访问URL
func (s *QiniuUploadService) GetFileUrl(fileName string) string {
	// 构建公开访问URL
	if s.domain != "" {
		// 确保域名以http://或https://开头
		if !strings.HasPrefix(s.domain, "http://") && !strings.HasPrefix(s.domain, "https://") {
			s.domain = "https://" + s.domain
		}

		// 确保域名不以/结尾
		s.domain = strings.TrimSuffix(s.domain, "/")

		return fmt.Sprintf("%s/%s", s.domain, fileName)
	}

	return ""
}

// GetUploadConfig 获取上传配置
func (s *QiniuUploadService) GetUploadConfig() app.UploadConfig {
	return s.config
}

// GetFileExtension 获取文件扩展名
func (s *QiniuUploadService) GetFileExtension(fileName string) string {
	return strings.ToLower(filepath.Ext(fileName))
}

// SaveFile 保存文件到本地
func (s *QiniuUploadService) SaveFile(file *multipart.FileHeader, filePath string) error {
	// 七牛云上传服务不支持本地保存文件
	return fmt.Errorf("七牛云上传服务不支持本地保存文件")
}

// ValidateFile 验证文件
func (s *QiniuUploadService) ValidateFile(file *multipart.FileHeader) (bool, error) {
	// 获取上传配置
	config := s.GetUploadConfig()

	// 验证文件大小
	maxSize := int64(config.MaxSize * 1024 * 1024) // 转换为字节
	if file.Size > maxSize {
		return false, fmt.Errorf("文件大小超过限制，最大允许 %d MB", config.MaxSize)
	}

	// 验证文件类型
	fileExt := s.GetFileExtension(file.Filename)
	if len(config.AllowedTypes) > 0 {
		allowed := false
		for _, allowedType := range config.AllowedTypes {
			if strings.EqualFold(fileExt, allowedType) {
				allowed = true
				break
			}
		}
		if !allowed {
			return false, fmt.Errorf("文件类型不允许，允许的类型: %v", config.AllowedTypes)
		}
	}

	return true, nil
}

// GenerateFileName 生成文件名
func (s *QiniuUploadService) GenerateFileName(originalFileName string) string {
	// 获取文件扩展名
	ext := s.GetFileExtension(originalFileName)

	// 生成UUID作为文件名
	uuidName := uuid.New().String()

	// 添加时间戳
	timestamp := time.Now().Format("20060102")

	return fmt.Sprintf("%s_%s%s", timestamp, uuidName, ext)
}

// uploadFile 上传文件到七牛云
func (s *QiniuUploadService) uploadFile(file *multipart.FileHeader, key string) (string, error) {
	// 创建表单上传的对象
	formUploader := storage.NewFormUploader(s.cfg)
	ret := storage.PutRet{}

	// 可选配置
	putExtra := storage.PutExtra{
		// 设置文件上传后进行的处理
		// MimeType: "application/octet-stream",
	}

	// 打开上传的文件
	src, err := file.Open()
	if err != nil {
		return "", fmt.Errorf("打开文件失败: %v", err)
	}
	defer src.Close()

	// 上传文件
	putPolicy := storage.PutPolicy{
		Scope: s.bucket,
	}
	upToken := putPolicy.UploadToken(s.mac)
	err = formUploader.Put(context.Background(), &ret, upToken, key, src, int64(file.Size), &putExtra)
	if err != nil {
		return "", fmt.Errorf("上传文件失败: %v", err)
	}

	// 返回文件URL
	return s.GetFileUrl(key), nil
}

// getFileKeyFromUrl 从URL中提取文件key
func (s *QiniuUploadService) getFileKeyFromUrl(fileUrl string) string {
	// 从URL中提取文件key部分
	key := strings.TrimPrefix(fileUrl, s.domain)
	key = strings.TrimPrefix(key, "http://")
	key = strings.TrimPrefix(key, "https://")
	key = strings.TrimPrefix(key, "/")

	return key
}

// getZone 根据区域名称获取七牛云区域对象
func getZone(zoneName string) *storage.Zone {
	switch zoneName {
	case "ZoneHuadong":
		return &storage.ZoneHuadong
	case "ZoneHuabei":
		return &storage.ZoneHuabei
	case "ZoneHuanan":
		return &storage.ZoneHuanan
	case "ZoneBeimei":
		return &storage.ZoneBeimei
	case "ZoneXinjiapo":
		return &storage.ZoneXinjiapo
	default:
		// 默认使用华东区域
		return &storage.ZoneHuadong
	}
}
