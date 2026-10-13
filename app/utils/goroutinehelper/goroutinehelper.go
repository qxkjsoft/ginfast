// Package goroutinehelper 提供安全的 goroutine 启动封装。
// 所有在请求生命周期之外执行的异步任务（落库、清理、通知等）应统一通过 GoSafe 启动，
// 确保 panic 被捕获并记录，不会拖垮整个进程。
package goroutinehelper

import (
	"gin-fast/app/global/app"
	"runtime/debug"

	"go.uber.org/zap"
)

// GoSafe 安全地启动 goroutine：内部捕获 panic 并记录错误日志（含堆栈），
// 避免 panic 导致进程退出。name 用于日志中定位异步任务来源。
func GoSafe(name string, fn func()) {
	go func() {
		defer func() {
			if r := recover(); r != nil {
				app.ZapLog.Error("异步goroutine发生panic",
					zap.String("name", name),
					zap.Any("panic", r),
					zap.String("stack", string(debug.Stack())),
				)
			}
		}()
		fn()
	}()
}
