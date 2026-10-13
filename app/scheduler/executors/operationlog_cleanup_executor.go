package executors

import (
	"context"
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/schedulerhelper"
	"time"

	"go.uber.org/zap"
)

const (
	// operationLogRetainDaysParam 任务参数键：日志保留天数
	operationLogRetainDaysParam = "retain_days"
	// defaultOperationLogRetainDays 保留天数缺省值（参数缺失/非法/≤0 时兜底）
	defaultOperationLogRetainDays = 90
	// operationLogDeleteBatchSize 单批删除行数，避免单条大 DELETE 长事务锁表
	operationLogDeleteBatchSize = 5000
)

// OperationLogCleanupExecutor 操作日志清理执行器：
// 硬删保留期之前的 sys_operation_logs（表带软删字段，必须 Unscoped 才能真正缩容）。
// 由 sys_jobs 定时任务驱动，参数 {"retain_days": 90} 可选，未配置任务则不运行
type OperationLogCleanupExecutor struct{}

// Execute 执行清理任务
func (e *OperationLogCleanupExecutor) Execute(ctx context.Context, job *schedulerhelper.Job) error {
	retainDays := resolveRetainDays(job.Parameters)
	deadline := time.Now().AddDate(0, 0, -retainDays)

	var total int64
	for {
		// 响应调度器超时/停止
		select {
		case <-ctx.Done():
			app.ZapLog.Warn("操作日志清理任务中断",
				zap.Int64("deleted", total), zap.Error(ctx.Err()))
			return ctx.Err()
		default:
		}

		result := app.DB().Unscoped().
			Where("created_at < ?", deadline).
			Limit(operationLogDeleteBatchSize).
			Delete(&models.SysOperationLog{})
		if result.Error != nil {
			app.ZapLog.Error("操作日志清理失败",
				zap.Int64("deleted", total), zap.Error(result.Error))
			return result.Error
		}
		total += result.RowsAffected
		if result.RowsAffected < int64(operationLogDeleteBatchSize) {
			break
		}
	}

	app.ZapLog.Info("操作日志清理完成",
		zap.Int64("deleted", total),
		zap.Int("retainDays", retainDays),
		zap.Time("deadline", deadline))
	return nil
}

// Name 返回执行器名称
func (e *OperationLogCleanupExecutor) Name() string {
	return "operation-log-cleanup"
}

// resolveRetainDays 解析保留天数参数：缺省/非法/≤0 一律兜底默认值
func resolveRetainDays(parameters map[string]interface{}) int {
	if parameters == nil {
		return defaultOperationLogRetainDays
	}
	switch v := parameters[operationLogRetainDaysParam].(type) {
	case int:
		if v > 0 {
			return v
		}
	case int64:
		if v > 0 {
			return int(v)
		}
	case float64:
		if v > 0 {
			return int(v)
		}
	case string:
		var n int
		if _, err := fmt.Sscanf(v, "%d", &n); err == nil && n > 0 {
			return n
		}
	}
	return defaultOperationLogRetainDays
}
