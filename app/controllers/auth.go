package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"gin-fast/app/utils/common"
	"gin-fast/app/utils/passwordhelper"

	"github.com/dchest/captcha"
	"github.com/gin-gonic/gin"
)

// LoginRequest 登录请求结构

type AuthController struct {
	Common
}

// Login 用户登录
func (ac *AuthController) Login(c *gin.Context) {
	var req models.LoginRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, err.Error(), err)
	}
	// 根据用户名查找用户
	user := models.NewUser()
	err := user.GetUserByUsername(req.Username)
	if err != nil {
		ac.FailAndAbort(c, "用户查询错误", err)
	}

	if user.IsEmpty() {
		ac.FailAndAbort(c, "用户不存在", nil)
	}
	// 验证密码
	if err = passwordhelper.ComparePassword(user.Password, req.Password); err != nil {
		ac.FailAndAbort(c, "密码错误", err)
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
		ac.FailAndAbort(c, "生成token失败", err)
	}

	// 生成refresh token
	refreshToken, err := app.TokenService.GenerateRefreshToken(user.ID)
	if err != nil {
		ac.FailAndAbort(c, "生成refresh token失败", err)
	}
	claims, err := app.TokenService.ParseToken(token)
	if err != nil {
		ac.FailAndAbort(c, "解析token失败", err)
	}
	claims1, err := app.TokenService.ParseRefreshToken(refreshToken)
	if err != nil {
		ac.FailAndAbort(c, "解析refreshToken失败", err)
	}

	ac.Success(c, gin.H{
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
			ac.FailAndAbort(c, "refreshToken不能为空", err)
		}
		refreshToken = req.RefreshToken
	}

	// 解析refreshToken获取用户ID
	claims, err := app.TokenService.ParseRefreshToken(refreshToken)
	if err != nil {
		ac.FailAndAbort(c, "无效的refreshToken", err)
	}

	// 从数据库中获取用户信息
	var user models.User
	if err = app.DB().First(&user, claims.UserID).Error; err != nil {
		ac.FailAndAbort(c, "用户不存在", err)
	}

	// 使用refresh token刷新access token
	user.Password = ""
	newAccessToken, err := app.TokenService.RefreshAccessToken(refreshToken, &app.ClaimsUser{
		UserID:   user.ID,
		Username: user.Username,
	})
	if err != nil {
		ac.FailAndAbort(c, "刷新token失败", err)
	}
	claims1, err := app.TokenService.ParseToken(newAccessToken)
	if err != nil {
		ac.FailAndAbort(c, "解析token失败", err)
	}

	// 取消旧的refresh token生成新的refresh token
	newRefreshToken, err := app.TokenService.RotateRefreshToken(refreshToken)
	if err != nil {
		ac.FailAndAbort(c, "轮换refresh token失败", err)
	}

	// 解析新refresh token的过期时间
	newRefreshClaims, err := app.TokenService.ParseRefreshToken(newRefreshToken)
	if err != nil {
		ac.FailAndAbort(c, "解析新refresh token失败", err)
	}

	ac.Success(c, gin.H{
		"accessToken":         newAccessToken,
		"accessTokenExpires":  claims1.ExpiresAt.Unix(),
		"refreshToken":        newRefreshToken,
		"refreshTokenExpires": newRefreshClaims.ExpiresAt.Unix(),
	})
}

// Logout 用户登出
func (ac *AuthController) Logout(c *gin.Context) {
	// 从上下文中获取用户信息
	claims := common.GetClaims(c)
	if claims == nil {
		ac.FailAndAbort(c, "用户未登录", nil)
	}

	// access token如果使用缓存模式，需要撤销 access token
	tokenString, err := common.GetAccessToken(c)
	if err == nil && tokenString != "" {
		// 尝试撤销access token，即使失败也继续执行
		app.TokenService.RevokeTokenWithCache(tokenString)
	}

	// 撤销refresh token
	err = app.TokenService.RevokeRefreshToken(claims.UserID)
	if err != nil {
		ac.FailAndAbort(c, "登出失败", err)
	}

	ac.Success(c, gin.H{
		"message": "登出成功",
	})
}

// 生成验证码ID
func (ac *AuthController) GetCaptchaId(c *gin.Context) {
	length := app.ConfigYml.GetInt("Captcha.length")
	var captchaId string
	captchaId = captcha.NewLen(length)
	ac.Success(c, gin.H{
		"captchaId": captchaId,
	})
}

// 获取验证码图片
func (ac *AuthController) GetCaptchaImg(c *gin.Context) {
	var req models.CaptchaImgRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, "获取验证码图片失败", err)
	}
	if req.Time != "" {
		captcha.Reload(req.CaptchaId)
	}
	captcha.WriteImage(c.Writer, req.CaptchaId, req.Width, req.Height)
}
