package middleware

import (
	"gin-fast/app/global/app"

	"github.com/gin-gonic/gin"
)

// CasbinMiddleware Casbin权限中间件
func CasbinMiddleware() gin.HandlerFunc {
	//return casbinhelper.GetCasbinService().CasbinMiddleware()
	return app.CasbinV2.CasbinMiddleware()
}
