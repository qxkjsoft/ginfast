package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models/usermodel"
	"gin-fast/app/utils/passwordhelper"
	"gin-fast/app/utils/response"
	"gin-fast/app/utils/tokenhelper"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// LoginRequest 登录请求结构

type AuthController struct {
}

// RefreshRequest 刷新token请求结构
type RefreshRequest struct {
	RefreshToken string `json:"refreshToken" binding:"required"`
}

// Login 用户登录
func (ac *AuthController) Login(c *gin.Context) {
	var req usermodel.LoginRequest
	if err := req.Validate(c); err != nil {
		response.Fail(c, err.Error())
		return
	}
	// 根据用户名查找用户
	user, err := usermodel.GetUserByUsername(req.Username)
	if err != nil {
		app.ZapLog.Error("用户名不存在", zap.Error(err))
		response.Fail(c, "用户名不存在")
		return
	}

	// 验证密码
	if err = passwordhelper.ComparePassword(user.Password, req.Password); err != nil {
		app.ZapLog.Error("密码错误", zap.Error(err))
		response.Fail(c, "密码错误")
		return
	}

	// 生成token
	user.Password = ""
	token, err := app.TokenService.GenerateToken(&tokenhelper.ClaimsUser{
		UserID:   user.ID,
		Username: user.Username,
		RawData:  *user,
	})
	if err != nil {
		app.ZapLog.Error("生成token失败", zap.Error(err))
		response.Fail(c, "生成token失败")
		return
	}

	// 生成refresh token
	refreshToken, err := app.TokenService.GenerateRefreshToken(user.ID)
	if err != nil {
		app.ZapLog.Error("生成refresh token失败", zap.Error(err))
		response.Fail(c, "生成refresh token失败")
		return
	}
	claims, err := app.TokenService.ParseToken(token)
	if err != nil {
		app.ZapLog.Error("解析token失败", zap.Error(err))
		response.Fail(c, "解析token失败")
		return
	}
	claims1, err := app.TokenService.ParseRefreshToken(refreshToken)
	if err != nil {
		app.ZapLog.Error("解析refreshToken失败", zap.Error(err))
		response.Fail(c, "解析refreshToken失败")
		return
	}
	response.Success(c, gin.H{
		"accessToken":         token,
		"refreshToken":        refreshToken,
		"accessTokenExpires":  claims.ExpiresAt.Unix(),
		"refreshTokenExpires": claims1.ExpiresAt.Unix(),
		"user": gin.H{
			"id":          user.ID,
			"avatar":      "",
			"username":    user.Username,
			"nickname":    "",
			"role":        []string{user.Role},
			"permissions": []string{},
		},
	})
}

// RefreshToken 刷新access token
func (ac *AuthController) RefreshToken(c *gin.Context) {
	// 首先尝试从header中获取refreshToken
	refreshToken := c.GetHeader("RefreshToken")
	if refreshToken == "" {
		// 如果header中没有，尝试从body中获取
		var req RefreshRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			app.ZapLog.Error("刷新token失败", zap.Error(err))
			response.Fail(c, "refreshToken不能为空")
			return
		}
		refreshToken = req.RefreshToken
	}

	// 解析refreshToken获取用户ID
	claims, err := app.TokenService.ParseRefreshToken(refreshToken)
	if err != nil {
		app.ZapLog.Error("解析refreshToken失败", zap.Error(err))
		response.Fail(c, "无效的refreshToken")
		return
	}

	// 从数据库中获取用户信息
	var user usermodel.User
	if err = app.GormDbMysql.First(&user, claims.UserID).Error; err != nil {
		app.ZapLog.Error("用户不存在", zap.Error(err))
		response.Fail(c, "用户不存在")
		return
	}

	// 使用refresh token刷新access token
	user.Password = ""
	newAccessToken, err := app.TokenService.RefreshAccessToken(refreshToken, &tokenhelper.ClaimsUser{
		UserID:   user.ID,
		Username: user.Username,
		RawData:  user,
	})
	if err != nil {
		app.ZapLog.Error("刷新token失败", zap.Error(err))
		response.Fail(c, "刷新token失败")
		return
	}
	claims1, err := app.TokenService.ParseRefreshToken(newAccessToken)
	if err != nil {
		app.ZapLog.Error("解析token失败", zap.Error(err))
		response.Fail(c, "解析token失败")
		return
	}
	response.Success(c, gin.H{
		"accessToken":        newAccessToken,
		"accessTokenExpires": claims1.ExpiresAt,
	})
}

// Logout 用户登出
func (ac *AuthController) Logout(c *gin.Context) {
	// 从上下文中获取用户信息
	userID, exists := c.Get("user_id")
	if !exists {
		response.Fail(c, "用户未登录")
		return
	}

	// 撤销refresh token
	err := app.TokenService.RevokeRefreshToken(uint(userID.(float64)))
	if err != nil {
		app.ZapLog.Error("登出失败", zap.Error(err))
		response.Fail(c, "登出失败")
		return
	}

	response.Success(c, gin.H{
		"message": "登出成功",
	})
}
