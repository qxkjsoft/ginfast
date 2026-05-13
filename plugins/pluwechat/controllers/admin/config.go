package admin

import (
	"fmt"
	"gin-fast/app/controllers"
	"gin-fast/plugins/pluwechat/utils/wxhelper"
	"io"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type ConfigController struct {
	controllers.Common
}

func NewConfigController() *ConfigController {
	return &ConfigController{}
}

// 获取微信配置
func (cc *ConfigController) GetWxConfig(ctx *gin.Context) {
	wcconfig := wxhelper.GetConfig()
	if wcconfig == nil {
		cc.FailAndAbort(ctx, "获取微信配置失败", nil)
	}
	cc.Success(ctx, wcconfig)
}

// UpdateMiniProgramConfig 更新小程序配置
func (cc *ConfigController) UpdateMiniProgramConfig(ctx *gin.Context) {
	var config wxhelper.MiniProgramConfig
	if err := ctx.ShouldBindJSON(&config); err != nil {
		cc.FailAndAbort(ctx, "参数绑定失败", err)
		return
	}

	if err := wxhelper.SetMiniProgramConfig(config); err != nil {
		cc.FailAndAbort(ctx, "更新小程序配置失败", err)
		return
	}

	cc.SuccessWithMessage(ctx, "小程序配置更新成功")
}

// UpdatePaymentConfig 更新支付配置
func (cc *ConfigController) UpdatePaymentConfig(ctx *gin.Context) {
	var config wxhelper.PaymentConfig
	if err := ctx.ShouldBindJSON(&config); err != nil {
		cc.FailAndAbort(ctx, "参数绑定失败", err)
		return
	}

	if err := wxhelper.SetPaymentConfig(config); err != nil {
		cc.FailAndAbort(ctx, "更新支付配置失败", err)
		return
	}

	cc.SuccessWithMessage(ctx, "支付配置更新成功")
}

// UpdateOfficialAccountConfig 更新微信公众号配置
func (cc *ConfigController) UpdateOfficialAccountConfig(ctx *gin.Context) {
	var config wxhelper.OfficialAccountConfig
	if err := ctx.ShouldBindJSON(&config); err != nil {
		cc.FailAndAbort(ctx, "参数绑定失败", err)
		return
	}

	if err := wxhelper.SetOfficialAccountConfig(config); err != nil {
		cc.FailAndAbort(ctx, "更新微信公众号配置失败", err)
		return
	}

	cc.SuccessWithMessage(ctx, "微信公众号配置更新成功")
}

// UploadFile 上传文件
func (cc *ConfigController) UploadFile(ctx *gin.Context) {
	// 获取上传的文件
	file, err := ctx.FormFile("file")
	if err != nil {
		cc.FailAndAbort(ctx, "获取文件失败", err)
		return
	}

	// 验证文件大小（限制为10MB）
	const maxSize = 10 * 1024 * 1024
	if file.Size > maxSize {
		cc.FailAndAbort(ctx, "文件大小超过限制，最大允许10MB", nil)
		return
	}

	// 验证文件类型（允许的文件扩展名）
	allowedExts := map[string]bool{
		".jpg":  true,
		".jpeg": true,
		".png":  true,
		".gif":  true,
		".pdf":  true,
		".doc":  true,
		".docx": true,
		".xls":  true,
		".xlsx": true,
		".txt":  true,
		".pem":  true,
	}
	ext := strings.ToLower(filepath.Ext(file.Filename))
	if !allowedExts[ext] {
		cc.FailAndAbort(ctx, "不支持的文件类型", nil)
		return
	}

	// 生成新文件名
	uuidName := uuid.New().String()
	timestamp := time.Now().Format("20060102")
	newFileName := fmt.Sprintf("%s_%s%s", timestamp, uuidName, ext)

	// 构建保存路径
	uploadDir := "resource/pluwechat"
	filePath := filepath.Join(uploadDir, newFileName)

	// 确保目录存在
	if err := os.MkdirAll(uploadDir, 0755); err != nil {
		cc.FailAndAbort(ctx, "创建目录失败", err)
		return
	}

	// 打开上传的文件
	src, err := file.Open()
	if err != nil {
		cc.FailAndAbort(ctx, "打开文件失败", err)
		return
	}
	defer src.Close()

	// 创建目标文件
	dst, err := os.Create(filePath)
	if err != nil {
		cc.FailAndAbort(ctx, "创建文件失败", err)
		return
	}
	defer dst.Close()

	// 复制文件内容
	if _, err = io.Copy(dst, src); err != nil {
		cc.FailAndAbort(ctx, "保存文件失败", err)
		return
	}

	// 返回相对路径
	relativePath := filepath.Join(uploadDir, newFileName)
	cc.Success(ctx, gin.H{
		"path":     relativePath,
		"fileName": newFileName,
	})
}
