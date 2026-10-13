package goroutinehelper

import (
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"gin-fast/app/global/app"

	"go.uber.org/zap"
)

// TestGoSafeExecutesFunction 正常路径：传入函数被执行且只执行一次
func TestGoSafeExecutesFunction(t *testing.T) {
	var executed int32
	var wg sync.WaitGroup
	wg.Add(1)
	GoSafe("test-exec", func() {
		defer wg.Done()
		atomic.StoreInt32(&executed, 1)
	})
	wg.Wait()
	if atomic.LoadInt32(&executed) != 1 {
		t.Fatal("GoSafe 未执行传入的函数")
	}
}

// TestGoSafeRecoversPanic panic 被捕获：不向进程传播，goroutine 内 defer 逻辑仍执行完毕
func TestGoSafeRecoversPanic(t *testing.T) {
	// 测试环境无 bootstrap 初始化，app.ZapLog 为 nil，
	// 补一个 Nop 日志器避免 recover 记录日志时空指针
	app.ZapLog = zap.NewNop()

	done := make(chan struct{})
	GoSafe("test-panic", func() {
		defer close(done)
		panic("模拟异步任务panic")
	})
	select {
	case <-done:
	case <-time.After(2 * time.Second):
		t.Fatal("panic 未被 recover 捕获，goroutine 异常退出")
	}
}

// TestGoSafePanicAfterWork 函数先正常执行部分逻辑再 panic：已执行部分生效，panic 不传播
func TestGoSafePanicAfterWork(t *testing.T) {
	app.ZapLog = zap.NewNop()

	var partial int32
	done := make(chan struct{})
	GoSafe("test-partial-panic", func() {
		defer close(done)
		atomic.StoreInt32(&partial, 42)
		panic("执行一半后panic")
	})
	select {
	case <-done:
	case <-time.After(2 * time.Second):
		t.Fatal("panic 未被 recover 捕获，goroutine 异常退出")
	}
	if atomic.LoadInt32(&partial) != 42 {
		t.Fatal("panic 前已执行的逻辑结果丢失")
	}
}
