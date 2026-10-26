package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/sysconfighelper"
	"gin-fast/app/utils/tenanthelper"
	"strconv"

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
	result := make(map[string]interface{})

	// 获取System配置（用户配置项存于 sys_config 表，经 sysconfighelper 内存缓存读取）
	sysConfig := sysconfighelper.Instance()
	systemConfig := make(map[string]interface{})

	systemConfig["systemLogo"] = sysConfig.GetString(sysconfighelper.CodeSystemLogo)         // 系统LOGO图片地址
	systemConfig["systemIcon"] = sysConfig.GetString(sysconfighelper.CodeSystemIcon)         // 系统图标地址
	systemConfig["systemName"] = sysConfig.GetString(sysconfighelper.CodeSystemName)         // 系统名称
	systemConfig["systemCopyright"] = sysConfig.GetString(sysconfighelper.CodeSystemCopyright) // 版权声明信息
	systemConfig["systemRecordNo"] = sysConfig.GetString(sysconfighelper.CodeSystemRecordNo)   // 网站备案号
	// 演示账号开关属部署级配置，仍在 config.yml；仅在开启时下发默认账密
	// 密码仅用于登录页密码框 placeholder 提示（用户自行输入）；注意：若演示账号同时配置在
	// notcheckuser 中，该密码可被匿名获取并绕过全部权限校验，生产环境务必保持 notcheckuser 为空
	if app.ConfigYml.GetBool("server.demoaccount.enabled") {
		systemConfig["defaultusername"] = sysConfig.GetString(sysconfighelper.CodeDemoUsername) // 演示账号默认用户名
		systemConfig["defaultpassword"] = sysConfig.GetString(sysconfighelper.CodeDemoPassword) // 演示账号默认密码（placeholder提示用）
	}
	result["system"] = systemConfig // 将系统配置放入结果集

	// 获取Safe配置
	safeConfig := make(map[string]interface{})
	safeConfig["loginLockThreshold"] = sysConfig.GetInt(sysconfighelper.CodeLoginLockThreshold)  // 密码错误锁定阈值，连续登录失败次数达到该值将锁定账号，0表示不锁定
	safeConfig["loginLockExpire"] = sysConfig.GetInt(sysconfighelper.CodeLoginLockExpire)        // 连续登录失败次数记录的缓存时间（单位：秒）
	safeConfig["loginLockDuration"] = sysConfig.GetInt(sysconfighelper.CodeLoginLockDuration)    // 账号锁定时长（单位：秒）
	safeConfig["minPasswordLength"] = sysConfig.GetInt(sysconfighelper.CodeMinPasswordLength)    // 密码最小长度要求
	safeConfig["requireSpecialChar"] = sysConfig.GetBool(sysconfighelper.CodeRequireSpecialChar) // 密码是否必须包含特殊字符
	result["safe"] = safeConfig                                                                  // 将安全配置放入结果集

	// 获取Captcha配置
	captchaConfig := make(map[string]interface{})
	captchaConfig["open"] = sysConfig.GetBool(sysconfighelper.CodeCaptchaOpen)    // 是否开启验证码功能
	captchaConfig["length"] = sysConfig.GetInt(sysconfighelper.CodeCaptchaLength) // 验证码字符长度
	result["captcha"] = captchaConfig                                             // 将验证码配置放入结果集

	// 获取多租户开关配置（前端据此显隐租户相关界面）
	tenantConfig := make(map[string]interface{})
	tenantConfig["enabled"] = tenanthelper.MultiTenantEnabled()
	result["tenant"] = tenantConfig // 将多租户配置放入结果集

	// 菜单表是否为空（前端据此在菜单为空时弹出「菜单恢复」引导弹窗，用于全新部署初始化）
	var menuCount int64
	if err := app.DB().WithContext(ctx).Model(&models.SysMenu{}).Count(&menuCount).Error; err != nil {
		con.Common.FailAndAbort(ctx, "查询菜单数据失败", err)
	}
	menuConfig := make(map[string]interface{})
	menuConfig["empty"] = menuCount == 0
	result["menu"] = menuConfig // 将菜单配置放入结果集

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

	// 更新用户配置项到 sys_config 表（config.yml 不再被程序改写）
	values := map[string]string{
		// System配置
		sysconfighelper.CodeSystemLogo:      req.System.SystemLogo,
		sysconfighelper.CodeSystemIcon:      req.System.SystemIcon,
		sysconfighelper.CodeSystemName:      req.System.SystemName,
		sysconfighelper.CodeSystemCopyright: req.System.SystemCopyright,
		sysconfighelper.CodeSystemRecordNo:  req.System.SystemRecordNo,
		// DemoAccount默认账密
		sysconfighelper.CodeDemoUsername: req.System.DefaultUsername,
		sysconfighelper.CodeDemoPassword: req.System.DefaultPassword,
		// Safe配置
		sysconfighelper.CodeLoginLockThreshold: strconv.Itoa(req.Safe.LoginLockThreshold),
		sysconfighelper.CodeLoginLockExpire:    strconv.Itoa(req.Safe.LoginLockExpire),
		sysconfighelper.CodeLoginLockDuration:  strconv.Itoa(req.Safe.LoginLockDuration),
		sysconfighelper.CodeMinPasswordLength:  strconv.Itoa(req.Safe.MinPasswordLength),
		sysconfighelper.CodeRequireSpecialChar: strconv.FormatBool(req.Safe.RequireSpecialChar),
		// Captcha配置
		sysconfighelper.CodeCaptchaOpen:   strconv.FormatBool(req.Captcha.Open),
		sysconfighelper.CodeCaptchaLength: strconv.Itoa(req.Captcha.Length),
	}
	if err := sysconfighelper.Instance().Update(values); err != nil {
		con.Common.FailAndAbort(ctx, "保存配置失败", err)
	}

	// 返回成功响应
	con.Common.SuccessWithMessage(ctx, "配置更新成功")
}
