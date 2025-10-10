package app

import (
	"mime/multipart"

	"github.com/gin-gonic/gin"
)

// FileUploadService 文件上传服务接口
// 统一的文件上传接口，包含所有上传相关的操作
type FileUploadService interface {
	// UploadFile 上传文件
	// file: 上传的文件
	// 返回值: 文件URL, 错误信息
	UploadFile(file *multipart.FileHeader) (*UploadFileResponse, error)

	// UploadFileWithCustomPath 上传文件到指定路径
	// file: 上传的文件
	// customPath: 自定义路径
	// 返回值: 文件URL, 错误信息
	UploadFileWithCustomPath(file *multipart.FileHeader, customPath string) (string, error)

	// DeleteFile 删除文件
	// fileUrl: 文件URL
	// 返回值: 错误信息
	DeleteFile(fileUrl string) error

	// GetFileUrl 获取文件访问URL
	// fileName: 文件名
	// 返回值: 文件URL
	GetFileUrl(fileName string) string

	// GetUploadConfig 获取上传配置
	// 返回值: 上传配置结构体
	GetUploadConfig() UploadConfig

	// HandleUpload 处理文件上传（HTTP请求处理）
	// c: gin上下文
	// fileName: 表单中的文件字段名
	// 返回值: 上传响应, 错误信息
	HandleUpload(c *gin.Context, fileName string) (*UploadResponse, error)

	// ValidateFile 验证文件
	// file: 上传的文件
	// 返回值: 是否验证通过, 错误信息
	ValidateFile(file *multipart.FileHeader) (bool, error)

	// GetFileExtension 获取文件扩展名
	// fileName: 文件名
	// 返回值: 文件扩展名
	GetFileExtension(fileName string) string

	// GenerateFileName 生成文件名
	// originalFileName: 原始文件名
	// 返回值: 生成的新文件名
	GenerateFileName(originalFileName string) string

	// SaveFile 保存文件到本地
	// file: 上传的文件
	// filePath: 保存路径
	// 返回值: 错误信息
	SaveFile(file *multipart.FileHeader, filePath string) error
}

// UploadConfig 上传配置结构体
type UploadConfig struct {
	// UploadType 上传方式: local-本地上传, qiniu-七牛云上传
	UploadType string `yaml:"upload_type"`

	// MaxSize 最大文件大小(单位: MB)
	MaxSize int `yaml:"max_size"`

	// AllowedTypes 允许的文件类型(例如: [".jpg", ".png", ".gif"])
	AllowedTypes []string `yaml:"allowed_types"`

	// LocalPath 本地上传路径
	LocalPath string `yaml:"local_path"`

	// QiniuConfig 七牛云配置
	QiniuConfig QiniuConfig `yaml:"qiniu_config"`
}

// QiniuConfig 七牛云配置
type QiniuConfig struct {
	// AccessKey 七牛云AccessKey
	AccessKey string `yaml:"access_key"`

	// SecretKey 七牛云SecretKey
	SecretKey string `yaml:"secret_key"`

	// Bucket 七牛云存储空间名称
	Bucket string `yaml:"bucket"`

	// Domain 七牛云域名
	Domain string `yaml:"domain"`

	// Zone 七牛云存储区域
	Zone string `yaml:"zone"`
}

// UploadResponse 上传响应结构体
type UploadResponse struct {
	// Url 文件访问URL
	Url string `json:"url"`

	// FileName 文件名
	FileName string `json:"file_name"`

	// Size 文件大小(字节)
	Size int64 `json:"size"`

	// FileType 文件类型
	FileType string `json:"file_type"`

	// Path 文件路径
	Path string `json:"path"`
}

type UploadFileResponse struct {
	// Url 文件访问URL
	Url string `json:"url"`

	// Path 文件路径
	Path string `json:"path"`

	// FileName 文件名
	FileName string `json:"file_name"`
}
