package uploadhelper

import (
	"fmt"
	"gin-fast/app/global/app"
	"io"
	"mime/multipart"
	"net"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/gabriel-vasile/mimetype"
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
func (s *LocalUploadService) UploadFile(file *multipart.FileHeader) (*app.UploadResponse, error) {
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
	return &app.UploadResponse{
		Url:      s.GetFileUrl(fmt.Sprintf("%s/%s", dateFolder, fileName)),
		Path:     filePath,
		FileName: fileName,
		Size:     file.Size,
		FileType: s.GetFileExtension(file.Filename),
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
	var filePath string

	// 先检查 fileUrl 是否作为文件路径存在
	if _, err := os.Stat(fileUrl); err == nil {
		// fileUrl 是有效的文件路径
		filePath = fileUrl
	} else {
		// fileUrl 不存在，从URL中提取文件路径
		filePath = s.getFilePathFromUrl(fileUrl)
		if filePath == "" {
			return fmt.Errorf("无效的文件路径: %s", fileUrl)
		}
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
	return s.UploadFile(file)
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

	// 校验文件内容与扩展名一致（magic bytes 嗅探，防伪造扩展名上传）
	if err := VerifyFileMagic(file); err != nil {
		return false, err
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

// maxRemoteImageSize 远程图片下载大小上限（10MB，覆盖头像等远程图片场景）
const maxRemoteImageSize = 10 << 20

// DownloadAndSaveRemoteImage 下载并保存远程图片
func (s *LocalUploadService) DownloadAndSaveRemoteImage(imageUrl string) (*app.UploadResponse, error) {
	// SSRF 防护：仅允许公网 http/https 地址
	if err := ValidateRemoteImageURL(imageUrl, net.LookupIP); err != nil {
		return nil, err
	}

	// 创建HTTP客户端（默认启用 TLS 证书校验），限制重定向次数并对每一跳做 SSRF 校验
	client := &http.Client{
		Timeout: 30 * time.Second,
		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			if len(via) >= 3 {
				return fmt.Errorf("重定向次数过多")
			}
			return ValidateRemoteImageURL(req.URL.String(), net.LookupIP)
		},
	}

	// 发送HTTP请求下载图片
	resp, err := client.Get(imageUrl)
	if err != nil {
		return nil, fmt.Errorf("下载图片失败: %v", err)
	}
	defer resp.Body.Close()

	// 检查响应状态码
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("下载图片失败，状态码: %d", resp.StatusCode)
	}

	// 限制下载大小读入内存（超限拒绝），避免超大响应拖垮磁盘/内存
	data, err := io.ReadAll(io.LimitReader(resp.Body, maxRemoteImageSize+1))
	if err != nil {
		return nil, fmt.Errorf("读取图片内容失败: %v", err)
	}
	if int64(len(data)) > maxRemoteImageSize {
		return nil, fmt.Errorf("图片超过大小限制（最大 %d MB）", maxRemoteImageSize>>20)
	}

	// 内容嗅探：必须是真实图片且不允许 SVG（文本型、可携带脚本）
	detected := mimetype.Detect(data)
	if detected.Is("image/svg+xml") {
		return nil, fmt.Errorf("不支持 SVG 图片")
	}
	if !strings.HasPrefix(detected.String(), "image/") {
		return nil, fmt.Errorf("下载的文件不是图片类型: %s", detected.String())
	}

	// 由嗅探结果确定扩展名
	var ext string
	switch {
	case detected.Is("image/png"):
		ext = ".png"
	case detected.Is("image/gif"):
		ext = ".gif"
	case detected.Is("image/webp"):
		ext = ".webp"
	case detected.Is("image/bmp"):
		ext = ".bmp"
	default:
		ext = ".jpg"
	}

	// 生成文件名
	fileName := s.GenerateFileName("image" + ext)

	// 获取当天日期作为文件夹名
	dateFolder := time.Now().Format("2006-01-02")

	// 构建文件保存路径
	filePath := filepath.Join(s.config.LocalPath, dateFolder, fileName)

	// 确保目录存在
	if err := os.MkdirAll(filepath.Join(s.config.LocalPath, dateFolder), 0755); err != nil {
		return nil, fmt.Errorf("创建目录失败: %v", err)
	}

	// 写入文件
	if err := os.WriteFile(filePath, data, 0644); err != nil {
		return nil, fmt.Errorf("保存图片失败: %v", err)
	}

	// 构建响应
	response := &app.UploadResponse{
		Url:      s.GetFileUrl(fmt.Sprintf("%s/%s", dateFolder, fileName)),
		FileName: fileName,
		Size:     int64(len(data)),
		FileType: ext,
		Path:     filePath,
	}

	return response, nil
}
