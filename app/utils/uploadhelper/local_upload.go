package uploadhelper

import (
	"fmt"
	"gin-fast/app/global/app"
	"io"
	"mime/multipart"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// LocalUploadService 本地文件上传服务
type LocalUploadService struct {
	config app.UploadConfig
}

// NewLocalUploadService 创建本地文件上传服务
func NewLocalUploadService() app.FileUploadService {
	config := GetUploadConfig()
	return &LocalUploadService{
		config: config,
	}
}

// UploadFile 上传文件
func (s *LocalUploadService) UploadFile(file *multipart.FileHeader) (*app.UploadFileResponse, error) {
	// 生成文件名
	fileName := s.GenerateFileName(file.Filename)

	// 获取当天日期作为文件夹名
	dateFolder := time.Now().Format("2006-01-02")

	// 构建文件保存路径，包含日期文件夹
	filePath := filepath.Join(s.config.LocalPath, dateFolder, fileName)

	// 确保目录存在，包括日期文件夹
	if err := os.MkdirAll(filepath.Join(s.config.LocalPath, dateFolder), 0755); err != nil {
		return nil, fmt.Errorf("创建目录失败: %v", err)
	}

	// 保存文件
	if err := s.SaveFile(file, filePath); err != nil {
		return nil, err
	}

	// 返回文件URL，包含日期文件夹路径
	return &app.UploadFileResponse{
		Url:      s.GetFileUrl(fmt.Sprintf("%s/%s", dateFolder, fileName)),
		Path:     filePath,
		FileName: fileName,
	}, nil
}

// UploadFileWithCustomPath 上传文件到指定路径
func (s *LocalUploadService) UploadFileWithCustomPath(file *multipart.FileHeader, customPath string) (string, error) {
	// 生成文件名
	fileName := s.GenerateFileName(file.Filename)

	// 构建文件保存路径
	filePath := filepath.Join(s.config.LocalPath, customPath, fileName)

	// 确保目录存在
	if err := os.MkdirAll(filepath.Join(s.config.LocalPath, customPath), 0755); err != nil {
		return "", fmt.Errorf("创建目录失败: %v", err)
	}

	// 保存文件
	if err := s.SaveFile(file, filePath); err != nil {
		return "", err
	}

	// 返回文件URL
	return s.GetFileUrl(fmt.Sprintf("%s/%s", customPath, fileName)), nil
}

// DeleteFile 删除文件
func (s *LocalUploadService) DeleteFile(fileUrl string) error {
	// 从URL中提取文件路径
	filePath := s.getFilePathFromUrl(fileUrl)
	if filePath == "" {
		return fmt.Errorf("无效的文件路径: %s", fileUrl)
	}

	// 删除文件
	if err := os.Remove(filePath); err != nil {
		return fmt.Errorf("删除文件失败: %v", err)
	}

	return nil
}

// GetFileUrl 获取文件访问URL
func (s *LocalUploadService) GetFileUrl(fileName string) string {
	// 获取静态资源路由路径
	serverRootPath := app.ConfigYml.GetString("httpserver.serverrootpath")

	// 构建URL
	url := fmt.Sprintf("%s/uploads/%s", strings.TrimSuffix(serverRootPath, "/"), fileName)

	// 确保URL以/开头
	if !strings.HasPrefix(url, "/") {
		url = "/" + url
	}

	return url
}

// GetUploadConfig 获取上传配置
func (s *LocalUploadService) GetUploadConfig() app.UploadConfig {
	return s.config
}

// GenerateFileName 生成文件名
func (s *LocalUploadService) GenerateFileName(originalFileName string) string {
	// 获取文件扩展名
	ext := s.GetFileExtension(originalFileName)

	// 生成UUID作为文件名
	uuidName := uuid.New().String()

	// 添加时间戳
	timestamp := time.Now().Format("20060102")

	return fmt.Sprintf("%s_%s%s", timestamp, uuidName, ext)
}

func (s *LocalUploadService) GetFileExtension(fileName string) string {
	return strings.ToLower(filepath.Ext(fileName))
}

// HandleUpload 处理文件上传（HTTP请求处理）
func (s *LocalUploadService) HandleUpload(c *gin.Context, fileName string) (*app.UploadResponse, error) {
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
	res, err := s.UploadFile(file)
	if err != nil {
		return nil, fmt.Errorf("上传文件失败: %v", err)
	}

	// 获取文件扩展名
	fileExt := s.GetFileExtension(file.Filename)

	// 构建响应
	response := &app.UploadResponse{
		Url:      res.Url,
		Path:     res.Path,
		FileName: res.FileName,
		Size:     file.Size,
		FileType: fileExt,
	}

	return response, nil
}

// ValidateFile 验证文件
func (s *LocalUploadService) ValidateFile(file *multipart.FileHeader) (bool, error) {
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

// SaveFile 保存文件到本地
func (s *LocalUploadService) SaveFile(file *multipart.FileHeader, filePath string) error {
	// 打开上传的文件
	src, err := file.Open()
	if err != nil {
		return fmt.Errorf("打开文件失败: %v", err)
	}
	defer src.Close()

	// 创建目标文件
	dst, err := os.Create(filePath)
	if err != nil {
		return fmt.Errorf("创建文件失败: %v", err)
	}
	defer dst.Close()

	// 复制文件内容
	if _, err = io.Copy(dst, src); err != nil {
		return fmt.Errorf("保存文件失败: %v", err)
	}

	return nil
}

// getFilePathFromUrl 从相对路径构造可供删除的完整文件路径
func (s *LocalUploadService) getFilePathFromUrl(relativePath string) string {
	// 如果路径为空，直接返回空字符串
	if relativePath == "" {
		return ""
	}

	// 使用正则表达式提取日期/文件名部分
	// 匹配类似 /2025-09-26/20250926_736fd9bd-21cd-491c-bc01-1c07926b34fc.jpeg 的部分
	re := regexp.MustCompile(`/(\d{4}-\d{2}-\d{2}/[^/]+)$`)
	matches := re.FindStringSubmatch(relativePath)

	if len(matches) > 1 {
		// 提取到的日期/文件名部分
		dateAndFile := matches[1]

		// 组合本地路径和文件路径部分
		fullPath := filepath.Join(s.config.LocalPath, dateAndFile)

		// 检查文件是否存在
		if _, err := os.Stat(fullPath); err == nil {
			// 文件存在，返回完整路径
			return fullPath
		}
	}

	// 如果没有匹配到或文件不存在，返回空字符串
	return ""
}
