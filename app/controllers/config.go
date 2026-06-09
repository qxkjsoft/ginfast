package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
)

// ConfigController 配置控制器
// @Summary 系统配置管理API
// @Description 系统配置管理相关接口
// @Tags 配置管理
// @Accept json
// @Produce json
// @Router /config [get]
type ConfigController struct {
	Common
}

// NewConfigController 创建配置控制器
func NewConfigController() *ConfigController {
	return &ConfigController{
		Common: Common{},
	}
}

// GetConfig 获取配置信息
// @Summary 获取配置信息
// @Description 获取系统配置信息
// @Tags 配置管理
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{} "成功返回配置信息"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /config/get [get]
func (con ConfigController) GetConfig(ctx *gin.Context) {
	// 提取Server、HttpServer和Captcha配置
	result := make(map[string]interface{})

	// 获取Server配置
	systemConfig := make(map[string]interface{})

	systemConfig["systemLogo"] = app.ConfigYml.GetString("system.systemlogo")           // 系统LOGO图片地址
	systemConfig["systemIcon"] = app.ConfigYml.GetString("system.systemicon")           // 系统图标地址
	systemConfig["systemName"] = app.ConfigYml.GetString("system.systemname")           // 系统名称
	systemConfig["systemCopyright"] = app.ConfigYml.GetString("system.systemcopyright") // 版权声明信息
	systemConfig["systemRecordNo"] = app.ConfigYml.GetString("system.systemrecordno")   // 网站备案号
	// 获取DemoAccount配置，仅在演示账号开关开启时传递
	if app.ConfigYml.GetBool("server.demoaccount.enabled") {
		systemConfig["defaultusername"] = app.ConfigYml.GetString("server.demoaccount.defaultusername") // 演示账号默认用户名
		systemConfig["defaultpassword"] = app.ConfigYml.GetString("server.demoaccount.defaultpassword") // 演示账号默认密码
	}
	result["system"] = systemConfig // 将系统配置放入结果集

	// 获取Safe配置
	safeConfig := make(map[string]interface{})
	safeConfig["loginLockThreshold"] = app.ConfigYml.GetInt("safe.loginlockthreshold")  // 密码错误锁定阈值，连续登录失败次数达到该值将锁定账号，0表示不锁定
	safeConfig["loginLockExpire"] = app.ConfigYml.GetInt("safe.loginlockexpire")        // 连续登录失败次数记录的缓存时间（单位：秒）
	safeConfig["loginLockDuration"] = app.ConfigYml.GetInt("safe.loginlockduration")    // 账号锁定时长（单位：秒）
	safeConfig["minPasswordLength"] = app.ConfigYml.GetInt("safe.minpasswordlength")    // 密码最小长度要求
	safeConfig["requireSpecialChar"] = app.ConfigYml.GetBool("safe.requirespecialchar") // 密码是否必须包含特殊字符
	result["safe"] = safeConfig                                                         // 将安全配置放入结果集

	// 获取Captcha配置
	captchaConfig := make(map[string]interface{})
	captchaConfig["open"] = app.ConfigYml.GetBool("captcha.open")    // 是否开启验证码功能
	captchaConfig["length"] = app.ConfigYml.GetInt("captcha.length") // 验证码字符长度
	result["captcha"] = captchaConfig                                // 将验证码配置放入结果集

	// 返回成功响应
	con.Common.Success(ctx, result)
}

// UpdateConfig 更新配置信息
// @Summary 更新配置信息
// @Description 更新系统配置信息
// @Tags 配置管理
// @Accept json
// @Produce json
// @Param config body map[string]interface{} true "配置信息"
// @Success 200 {object} map[string]interface{} "成功更新配置信息"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /config/update [put]
// @Security ApiKeyAuth
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
	// 更新DemoAccount配置
	app.ConfigYml.Set("server.demoaccount.defaultusername", req.System.DefaultUsername)
	app.ConfigYml.Set("server.demoaccount.defaultpassword", req.System.DefaultPassword)

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
