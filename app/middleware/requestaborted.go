package middleware

import (
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// RequestAbortedRecovery 自定义 recovery 中间件，用于处理 FailAndAbort 的 panic
func RequestAbortedRecovery() gin.HandlerFunc {
	return gin.CustomRecovery(func(c *gin.Context, recovered interface{}) {
		if recovered == consts.RequestAborted {
			// 这是我们的 FailAndAbort 方法触发的 panic，已经处理了响应，不需要额外处理
			//app.ZapLog.Debug("请求被 FailAndAbort 方法终止", zap.String("path", c.Request.URL.Path))
			return
		}

		// 其他类型的 panic 使用默认处理
		app.ZapLog.Error("服务器内部错误",
			zap.Any("panic", recovered),
			zap.String("path", c.Request.URL.Path),
			zap.String("method", c.Request.Method),
		)

		// 返回500错误
		if !c.Writer.Written() {
			app.Response.Fail(c, "服务器内部错误")
		}
		c.Abort()
	})
}
