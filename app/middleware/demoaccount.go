package middleware

import (
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"
	"net/http"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// DemoAccountMiddleware 演示账号中间件
// 限制演示账号只能发送GET请求，阻止所有非GET请求
func DemoAccountMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 检查是否启用了演示账号功能
		if !app.ConfigYml.GetBool("server.demoaccount.enabled") {
			// 未启用演示账号功能，直接通过
			c.Next()
			return
		}

		// 获取演示账号ID列表
		demoUserIDs := app.ConfigYml.GetUintSlice("server.demoaccount.userids")
		if len(demoUserIDs) == 0 {
			// 演示账号ID列表为空，直接通过
			c.Next()
			return
		}

		// 从上下文中获取当前用户信息
		userClaims, exists := c.Get(consts.BindContextKeyName)
		if !exists {
			// 未找到用户信息，直接通过（可能不是受保护的路由）
			c.Next()
			return
		}

		// 类型断言获取用户信息
		claims, ok := userClaims.(*app.Claims)
		if !ok {
			// 用户信息类型不匹配，直接通过
			c.Next()
			return
		}

		// 检查当前用户是否为演示账号
		isDemoUser := false
		for _, demoUserID := range demoUserIDs {
			if claims.UserID == demoUserID {
				isDemoUser = true
				break
			}
		}

		// 如果不是演示账号，直接通过
		if !isDemoUser {
			c.Next()
			return
		}

		// 是演示账号，检查请求方法
		if c.Request.Method != "GET" {
			// 非GET请求，拒绝访问
			app.ZapLog.Warn("演示账号尝试执行非GET操作",
				zap.Uint("userID", claims.UserID),
				zap.String("method", c.Request.Method),
				zap.String("path", c.Request.URL.Path))

			c.JSON(http.StatusForbidden, gin.H{
				"code":    http.StatusForbidden,
				"message": "演示账号仅允许查看操作，禁止修改数据",
			})
			c.Abort()
			return
		}

		// GET请求，允许通过
		c.Next()
	}
}
