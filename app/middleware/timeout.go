package middleware

import (
	"context"
	"time"

	"github.com/gin-gonic/gin"
)

// TimeoutMiddleware 超时中间件
// 为每个请求设置全局超时时间，防止长时间运行的请求阻塞服务器
func TimeoutMiddleware(timeout time.Duration) gin.HandlerFunc {
	return func(c *gin.Context) {
		// 创建带超时的上下文
		ctx, cancel := context.WithTimeout(c.Request.Context(), timeout)
		defer cancel()

		// 替换请求的上下文
		c.Request = c.Request.WithContext(ctx)
		c.Next()
	}
}
