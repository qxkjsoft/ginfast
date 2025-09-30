package uploadhelper

import (
	"errors"
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"
)

// GetUploadType 获取上传类型
func GetUploadType() string {
	return app.ConfigYml.GetString("Upload.upload_type")
}

// GetUploadConfig 获取上传配置
func GetUploadConfig() app.UploadConfig {
	uploadType := GetUploadType()
	maxSize := app.ConfigYml.GetInt("Upload.max_size")
	allowedTypes := app.ConfigYml.GetStringSlice("Upload.allowed_types")
	localPath := app.ConfigYml.GetString("Upload.local_path")

	// 获取七牛云配置
	qiniuConfig := app.QiniuConfig{
		AccessKey: app.ConfigYml.GetString("Upload.qiniu_config.access_key"),
		SecretKey: app.ConfigYml.GetString("Upload.qiniu_config.secret_key"),
		Bucket:    app.ConfigYml.GetString("Upload.qiniu_config.bucket"),
		Domain:    app.ConfigYml.GetString("Upload.qiniu_config.domain"),
		Zone:      app.ConfigYml.GetString("Upload.qiniu_config.zone"),
	}

	return app.UploadConfig{
		UploadType:   uploadType,
		MaxSize:      maxSize,
		AllowedTypes: allowedTypes,
		LocalPath:    localPath,
		QiniuConfig:  qiniuConfig,
	}
}

// CreateUploadService 创建上传服务
func CreateUploadService() (app.FileUploadService, error) {
	uploadType := GetUploadType()

	switch uploadType {
	case consts.UploadTypeLocal:
		return NewLocalUploadService(), nil
	case consts.UploadTypeQiniu:
		return NewQiniuUploadService(), nil
	default:
		return nil, errors.New("不支持的上传类型")
	}
}
