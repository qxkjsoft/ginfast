package tokeneasy

import (
	"gin-fast/app/global/app"
	"gin-fast/app/utils/common"
	"net/http"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

const (
	BindContextKeyName = "demoMemberClaims"
)

// FrontMemberJWT 会员JWT认证中间件
func FrontMemberJWT() gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString, err := common.GetAccessToken(c)
		if err != nil {
			app.ZapLog.Error("Get access token failed", zap.Error(err))
			// 401 未认证
			c.JSON(http.StatusUnauthorized, gin.H{"message": err.Error()})
			c.Abort()
			return
		}
		// 验证AccessToken
		claims, err := GetTokenService().ValidateTokenWithCache(tokenString)
		if err != nil {
			app.ZapLog.Error("Invalid token", zap.Error(err))
			// 401 未认证
			c.JSON(http.StatusUnauthorized, gin.H{"message": err.Error()})
			c.Abort()
			return
		}
		// 将用户信息存储到上下文中
		c.Set(BindContextKeyName, claims)
		// 继续处理请求
		c.Next()
	}
}

// 从上下文中获信会员信息
func GetFrontMemberClaims(c *gin.Context) *app.Claims {
	claims, exists := c.Get(BindContextKeyName)
	if !exists {
		return nil
	}
	return claims.(*app.Claims)
}
