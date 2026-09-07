package middleware

import (
	"context"
	"gin-fast/app/global/consts"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// TimeoutMiddleware 超时中间件
// 为每个请求设置全局超时时间，超时后立即返回 504，不再同步等待 handler 跑完。
// 实现说明：
//   - handler 链在独立 goroutine 中执行；panic（含 FailAndAbort 触发的 RequestAborted）
//     经缓冲通道传回主 goroutine 重新 panic，由外层 CustomRecovery 统一处理，
//     FailAndAbort 的"已写响应即终止"语义保持不变；
//   - 超时触发时写 504 并 Abort；此时 handler goroutine 借助已取消的 ctx 自然失败
//     （如 GORM 查询中断报错），其内部 panic 进入缓冲通道后无人消费也被安全丢弃；
//   - 已知取舍：超时瞬间 handler 若恰好仍在写响应，与 504 写入存在微小竞态
//     （gin 会记录 superfluous response 警告日志），完整消除需引入缓冲响应体，此处从简。
func TimeoutMiddleware(timeout time.Duration) gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(c.Request.Context(), timeout)
		defer cancel()

		c.Request = c.Request.WithContext(ctx)

		finished := make(chan struct{})
		panicCh := make(chan interface{}, 1) // 缓冲 1：超时分支退出后 goroutine 的 panic 不会阻塞泄漏

		go func() {
			defer func() {
				if p := recover(); p != nil {
					panicCh <- p
				}
			}()
			c.Next()
			close(finished)
		}()

		select {
		case p := <-panicCh:
			panic(p) // 交还外层 CustomRecovery 处理
		case <-finished:
			// handler 正常完成，响应已写入
		case <-ctx.Done():
			c.AbortWithStatusJSON(http.StatusGatewayTimeout, gin.H{
				"code":    consts.ServerOccurredErrorCode,
				"message": "请求处理超时",
				"data":    nil,
			})
		}
	}
}
