package middleware

import (
	"gin-fast/app/global/app"
	"gin-fast/app/utils/common"
	"net/http"

	"github.com/gin-gonic/gin"
)

// SuperAdminMiddleware 超管校验中间件：仅 server.notcheckuser 名单或 initadmin 超管可放行，
// 用于 /viewCache、pprof 等调试端点（须挂在 JWTAuthMiddleware 之后，依赖上下文中的用户信息）
func SuperAdminMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// IsSkipAuthUser 对 userID=0（无登录信息）同样返回 false
		if !common.IsSkipAuthUser(common.GetCurrentUserID(c)) {
			app.Response.Fail(c, "仅平台超级管理员可访问", http.StatusForbidden)
			return
		}
		c.Next()
	}
}
