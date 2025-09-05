package middleware

import (
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"
	"gin-fast/app/utils/common"
	"net/http"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// JWTAuthMiddleware JWT认证中间件
func JWTAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString, err := common.GetAccessToken(c)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"message": err.Error()})
			c.Abort()
			return
		}
		// 带缓存检查
		claims, err := app.TokenService.ValidateTokenWithCache(tokenString)
		if err != nil {
			app.ZapLog.Error("Invalid token", zap.Error(err))
			c.JSON(http.StatusUnauthorized, gin.H{"message": "Invalid token"})
			c.Abort()
			return
		}

		// 将用户信息存储到上下文中
		c.Set(consts.BindContextKeyName, claims)
		c.Next()
	}
}
