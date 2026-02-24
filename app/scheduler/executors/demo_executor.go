package executors

import (
	"context"
	"log"
	"time"

	"gin-fast/app/utils/schedulerhelper"
)

// DemoExecutor 演示执行器，用于测试和演示调度器功能
type DemoExecutor struct{}

// Execute 执行任务
func (e *DemoExecutor) Execute(ctx context.Context, job *schedulerhelper.Job) error {
	log.Printf("Executor %s executing job %s with params: %v",
		e.Name(), job.Name, job.Parameters)

	// 模拟任务执行
	select {
	case <-time.After(2 * time.Second):
		log.Printf("Job %s completed successfully", job.Name)
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}

// Name 返回执行器名称
func (e *DemoExecutor) Name() string {
	return "demo-executor"
}
