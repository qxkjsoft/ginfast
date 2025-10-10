package controllers

import (
	"context"
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
)

type ConfigController struct {
	Common
}

// GetCacheItems 获取所有缓存项
// @Summary 获取所有缓存项
// @Description 获取所有缓存项
// @Tags 配置管理
// @Accept  application/json
// @Product application/json
// @Success 200 {object} app.Response "{"code":200,"data":{},"msg":"操作成功"}"
// @Router /config/cache/items [get]
func (con ConfigController) GetCacheItems(c *gin.Context) {
	items, err := app.Cache.GetAll(context.Background())
	if err != nil {
		con.FailAndAbort(c, "获取缓存项失败", err)
		return
	}
	con.Success(c, items)
}

// GetConfig 读取并返回config.yml中的内容（仅限于Server、HttpServer、Captcha中的内容）
func (con ConfigController) GetConfig(ctx *gin.Context) {
	// 提取Server、HttpServer和Captcha配置
	result := make(map[string]interface{})

	// 获取Server配置
	systemConfig := make(map[string]interface{})

	systemConfig["systemLogo"] = app.ConfigYml.GetString("system.systemlogo")
	systemConfig["systemIcon"] = app.ConfigYml.GetString("system.systemicon")
	systemConfig["systemName"] = app.ConfigYml.GetString("system.systemname")
	systemConfig["systemCopyright"] = app.ConfigYml.GetString("system.systemcopyright")
	systemConfig["systemRecordNo"] = app.ConfigYml.GetString("system.systemrecordno")
	result["system"] = systemConfig

	// 获取Safe配置
	safeConfig := make(map[string]interface{})
	safeConfig["loginLockThreshold"] = app.ConfigYml.GetInt("safe.loginlockthreshold")
	safeConfig["loginLockExpire"] = app.ConfigYml.GetInt("safe.loginlockexpire")
	safeConfig["loginLockDuration"] = app.ConfigYml.GetInt("safe.loginlockduration")
	safeConfig["minPasswordLength"] = app.ConfigYml.GetInt("safe.minpasswordlength")
	safeConfig["requireSpecialChar"] = app.ConfigYml.GetBool("safe.requirespecialchar")
	result["safe"] = safeConfig

	// 获取Captcha配置
	captchaConfig := make(map[string]interface{})
	captchaConfig["open"] = app.ConfigYml.GetBool("captcha.open")
	captchaConfig["length"] = app.ConfigYml.GetInt("captcha.length")
	result["captcha"] = captchaConfig

	// 返回成功响应
	con.Common.Success(ctx, result)
}

// UpdateConfig 修改config.yml中的内容（仅限于Server、HttpServer、Captcha中的内容）
func (con ConfigController) UpdateConfig(ctx *gin.Context) {
	var req models.ConfigRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		con.Common.FailAndAbort(ctx, "参数绑定失败", err)
	}

	// 更新System配置
	app.ConfigYml.Set("system.systemlogo", req.System.SystemLogo)
	app.ConfigYml.Set("system.systemicon", req.System.SystemIcon)
	app.ConfigYml.Set("system.systemname", req.System.SystemName)
	app.ConfigYml.Set("system.systemcopyright", req.System.SystemCopyright)
	app.ConfigYml.Set("system.systemrecordno", req.System.SystemRecordNo)

	// 更新Safe配置
	app.ConfigYml.Set("safe.loginlockthreshold", req.Safe.LoginLockThreshold)
	app.ConfigYml.Set("safe.loginlockexpire", req.Safe.LoginLockExpire)
	app.ConfigYml.Set("safe.loginlockduration", req.Safe.LoginLockDuration)
	app.ConfigYml.Set("safe.minpasswordlength", req.Safe.MinPasswordLength)
	app.ConfigYml.Set("safe.requirespecialchar", req.Safe.RequireSpecialChar)

	// 更新Captcha配置
	app.ConfigYml.Set("captcha.open", req.Captcha.Open)
	app.ConfigYml.Set("captcha.length", req.Captcha.Length)

	// 保存配置到文件
	if err := app.ConfigYml.SaveConfig(); err != nil {
		con.Common.FailAndAbort(ctx, "保存配置文件失败", err)
	}

	// 返回成功响应
	con.Common.SuccessWithMessage(ctx, "配置更新成功")
}
