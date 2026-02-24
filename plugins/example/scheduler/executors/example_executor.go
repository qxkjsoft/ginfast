package executors

import (
	"context"
	"time"

	"gin-fast/app/global/app"
	"gin-fast/app/utils/schedulerhelper"

	"go.uber.org/zap"
)

// ExampleExecutor 示例执行器，用于演示插件如何注册任务执行器
type ExampleExecutor struct{}

// Execute 执行任务
func (e *ExampleExecutor) Execute(ctx context.Context, job *schedulerhelper.Job) error {
	app.ZapLog.Info("ExampleExecutor 开始执行任务",
		zap.String("executor", e.Name()),
		zap.String("jobID", job.ID),
		zap.String("jobName", job.Name),
		zap.Any("parameters", job.Parameters))

	// 模拟任务执行
	select {
	case <-time.After(1 * time.Second):
		app.ZapLog.Info("ExampleExecutor 任务执行完成",
			zap.String("jobID", job.ID),
			zap.String("jobName", job.Name))
		return nil
	case <-ctx.Done():
		app.ZapLog.Warn("ExampleExecutor 任务被取消",
			zap.String("jobID", job.ID),
			zap.Error(ctx.Err()))
		return ctx.Err()
	}
}

// Name 返回执行器名称
func (e *ExampleExecutor) Name() string {
	return "example-executor"
}
