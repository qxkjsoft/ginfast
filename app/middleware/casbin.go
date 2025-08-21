package middleware

import (
	"gin-fast/app/utils/casbinhelper"

	"github.com/gin-gonic/gin"
)

// CasbinMiddleware Casbin权限中间件
func CasbinMiddleware() gin.HandlerFunc {
	return casbinhelper.GetCasbinService().CasbinMiddleware()
}
