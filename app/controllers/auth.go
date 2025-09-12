package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"gin-fast/app/utils/common"
	"gin-fast/app/utils/passwordhelper"

	"github.com/dchest/captcha"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// LoginRequest 登录请求结构

type AuthController struct {
}

/*
*

	Login 用户登录
	目前accesstoken是无缓存模式, 想要改成缓存模式需要调整:  Login、RefreshToken、Logout及

*
*/
func (ac *AuthController) Login(c *gin.Context) {
	var req models.LoginRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}
	// 根据用户名查找用户
	user := models.NewUser()
	err := user.GetUserByUsername(req.Username)
	if err != nil {
		app.ZapLog.Error("用户查询错误", zap.Error(err))
		app.Response.Fail(c, "用户查询错误")
		return
	}

	if user.IsEmpty() {
		app.ZapLog.Error("用户不存在")
		app.Response.Fail(c, "用户不存在")
		return
	}
	// 验证密码
	if err = passwordhelper.ComparePassword(user.Password, req.Password); err != nil {
		app.ZapLog.Error("密码错误", zap.Error(err))
		app.Response.Fail(c, "密码错误")
		return
	}

	// 生成token
	user.Password = ""
	// token 不记录缓存
	token, err := app.TokenService.GenerateToken(&app.ClaimsUser{
		UserID:   user.ID,
		Username: user.Username,
	})

	// // token 将记录缓存
	// token, err := app.TokenService.GenerateTokenWithCache(&app.ClaimsUser{
	// 	UserID:   user.ID,
	// 	Username: user.Username,
	// })
	if err != nil {
		app.ZapLog.Error("生成token失败", zap.Error(err))
		app.Response.Fail(c, "生成token失败")
		return
	}

	// 生成refresh token
	refreshToken, err := app.TokenService.GenerateRefreshToken(user.ID)
	if err != nil {
		app.ZapLog.Error("生成refresh token失败", zap.Error(err))
		app.Response.Fail(c, "生成refresh token失败")
		return
	}
	claims, err := app.TokenService.ParseToken(token)
	if err != nil {
		app.ZapLog.Error("解析token失败", zap.Error(err))
		app.Response.Fail(c, "解析token失败")
		return
	}
	claims1, err := app.TokenService.ParseRefreshToken(refreshToken)
	if err != nil {
		app.ZapLog.Error("解析refreshToken失败", zap.Error(err))
		app.Response.Fail(c, "解析refreshToken失败")
		return
	}

	app.Response.Success(c, gin.H{
		"accessToken":         token,
		"accessTokenExpires":  claims.ExpiresAt.Unix(),
		"refreshToken":        refreshToken,
		"refreshTokenExpires": claims1.ExpiresAt.Unix(),
	})
}

// RefreshToken 刷新access token
func (ac *AuthController) RefreshToken(c *gin.Context) {
	// 首先尝试从header中获取refreshToken
	refreshToken := c.GetHeader("RefreshToken")
	if refreshToken == "" {
		// 如果header中没有，尝试从body中获取
		var req models.RefreshRequest
		if err := c.ShouldBind(&req); err != nil {
			app.ZapLog.Error("刷新token失败", zap.Error(err))
			app.Response.Fail(c, "refreshToken不能为空")
			return
		}
		refreshToken = req.RefreshToken
	}

	// 解析refreshToken获取用户ID
	claims, err := app.TokenService.ParseRefreshToken(refreshToken)
	if err != nil {
		app.ZapLog.Error("解析refreshToken失败", zap.Error(err))
		app.Response.Fail(c, "无效的refreshToken")
		return
	}

	// 从数据库中获取用户信息
	var user models.User
	if err = app.DB().First(&user, claims.UserID).Error; err != nil {
		app.ZapLog.Error("用户不存在", zap.Error(err))
		app.Response.Fail(c, "用户不存在")
		return
	}

	// 使用refresh token刷新access token
	user.Password = ""
	newAccessToken, err := app.TokenService.RefreshAccessToken(refreshToken, &app.ClaimsUser{
		UserID:   user.ID,
		Username: user.Username,
	})
	if err != nil {
		app.ZapLog.Error("刷新token失败", zap.Error(err))
		app.Response.Fail(c, "刷新token失败")
		return
	}
	claims1, err := app.TokenService.ParseToken(newAccessToken)
	if err != nil {
		app.ZapLog.Error("解析token失败", zap.Error(err))
		app.Response.Fail(c, "解析token失败")
		return
	}
	app.Response.Success(c, gin.H{
		"accessToken":        newAccessToken,
		"accessTokenExpires": claims1.ExpiresAt,
	})
}

// Logout 用户登出
func (ac *AuthController) Logout(c *gin.Context) {
	// 从上下文中获取用户信息
	claims := common.GetClaims(c)
	if claims == nil {
		app.Response.Fail(c, "用户未登录")
		return
	}
	// 撤销 access token（缓存模式）
	// tokenString, err := common.GetAccessToken(c)
	// if err != nil {
	// 	app.Response.Fail(c, "获取access token失败")
	// 	return
	// }
	// app.TokenService.RevokeTokenWithCache(tokenString)

	// 撤销refresh token
	err := app.TokenService.RevokeRefreshToken(claims.UserID)
	if err != nil {
		app.ZapLog.Error("登出失败", zap.Error(err))
		app.Response.Fail(c, "登出失败")
		return
	}

	app.Response.Success(c, gin.H{
		"message": "登出成功",
	})
}

// 生成验证码ID
func (ac *AuthController) GetCaptchaId(c *gin.Context) {
	length := app.ConfigYml.GetInt("Captcha.length")
	var captchaId string
	captchaId = captcha.NewLen(length)
	app.Response.Success(c, gin.H{
		"captchaId": captchaId,
	})
}

// 获取验证码图片
func (ac *AuthController) GetCaptchaImg(c *gin.Context) {
	var req models.CaptchaImgRequest
	if err := req.Validate(c); err != nil {
		//app.Response.Fail(c, err.Error())
		app.ZapLog.Error("获取验证码图片失败", zap.Error(err))
		return
	}
	if req.Time != "" {
		captcha.Reload(req.CaptchaId)
	}
	captcha.WriteImage(c.Writer, req.CaptchaId, req.Width, req.Height)
}
