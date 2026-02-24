package scheduler

import (
	"context"
	"fmt"
	"time"

	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/schedulerhelper"

	"go.uber.org/zap"
)

// resultHandlerCancel 用于取消结果处理协程
var resultHandlerCancel context.CancelFunc

// StartResultHandler 启动任务结果处理器
// 该函数会启动一个后台协程，从调度器的结果通道中读取任务执行结果，
// 并将结果保存到数据库的 sys_job_results 表中
func StartResultHandler() {
	ctx, cancel := context.WithCancel(context.Background())
	resultHandlerCancel = cancel

	go func() {
		app.ZapLog.Info("任务结果处理器已启动")
		defer app.ZapLog.Info("任务结果处理器已停止")

		resultsChan := app.JobScheduler.GetResults()

		for {
			select {
			case <-ctx.Done():
				// 处理剩余的结果
				app.ZapLog.Info("正在处理剩余的任务结果...")
				drainResults(resultsChan)
				return

			case result, ok := <-resultsChan:
				if !ok {
					// 通道已关闭
					app.ZapLog.Info("任务结果通道已关闭，处理器退出")
					return
				}

				// 保存结果到数据库
				if err := saveJobResult(result); err != nil {
					app.ZapLog.Error("保存任务结果失败",
						zap.String("jobID", result.JobID),
						zap.String("status", result.Status),
						zap.Error(err))
				}
			}
		}
	}()
}

// saveJobResult 将任务执行结果保存到数据库
func saveJobResult(result *schedulerhelper.JobResult) error {
	// 转换 JobResult 为 SysJobResults 模型
	jobResult := &models.SysJobResults{
		JobId:      result.JobID,
		Status:     result.Status,
		StartTime:  &result.StartTime,
		EndTime:    &result.EndTime,
		Duration:   result.Duration.Nanoseconds(), // 转换为纳秒
		RetryCount: result.RetryCount,
	}

	// 处理错误信息
	if result.Error != nil {
		jobResult.Error = result.Error.Error()
	}

	// 设置创建时间
	now := time.Now()
	jobResult.CreatedAt = &now

	// 保存到数据库
	ctx := context.Background()
	if err := jobResult.Create(ctx); err != nil {
		return fmt.Errorf("保存任务结果到数据库失败: %w", err)
	}

	app.ZapLog.Debug("任务结果已保存到数据库",
		zap.String("jobID", result.JobID),
		zap.String("status", result.Status),
		zap.Duration("duration", result.Duration),
		zap.Int("retryCount", result.RetryCount))

	// 如果是单次执行策略且执行成功，更新 sys_jobs 表的 status 为 0
	if result.ExecutionPolicy == schedulerhelper.PolicyOnce && result.Status == "SUCCESS" {
		job := &models.SysJobs{}
		if err := job.GetByID(ctx, result.JobID); err != nil {
			app.ZapLog.Error("获取任务信息失败",
				zap.String("jobID", result.JobID),
				zap.Error(err))
		} else {
			if job.Status == 1 {
				job.Status = 0
				if err := job.Update(ctx); err != nil {
					app.ZapLog.Error("更新单次执行任务状态失败",
						zap.String("jobID", result.JobID),
						zap.Error(err))
				} else {
					app.ZapLog.Info("单次执行任务已完成，已更新数据库状态为禁用",
						zap.String("jobID", result.JobID))
				}
			}

		}
	}

	return nil
}

// StopResultHandler 停止任务结果处理器
// 该函数会优雅地停止结果处理协程，确保所有待处理的结果都被保存
func StopResultHandler() {
	if resultHandlerCancel != nil {
		app.ZapLog.Info("正在停止任务结果处理器...")
		resultHandlerCancel()
		resultHandlerCancel = nil
	}
}

// drainResults 处理结果通道中剩余的所有结果
func drainResults(resultsChan <-chan *schedulerhelper.JobResult) {
	count := 0
	for {
		select {
		case result, ok := <-resultsChan:
			if !ok {
				app.ZapLog.Info("所有剩余任务结果已处理完成", zap.Int("count", count))
				return
			}
			count++
			if err := saveJobResult(result); err != nil {
				app.ZapLog.Error("保存剩余任务结果失败",
					zap.String("jobID", result.JobID),
					zap.Error(err))
			}
		default:
			// 通道为空，退出
			if count > 0 {
				app.ZapLog.Info("所有剩余任务结果已处理完成", zap.Int("count", count))
			}
			return
		}
	}
}
