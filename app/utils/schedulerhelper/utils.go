package schedulerhelper

import (
	"fmt"
	"time"

	"github.com/robfig/cron/v3"
	"github.com/sony/sonyflake"
)

var sf *sonyflake.Sonyflake

func init() {
	sf = sonyflake.NewSonyflake(sonyflake.Settings{})
}

func generateJobID() string {
	id, _ := sf.NextID()
	return fmt.Sprintf("%d", id)
}

func validateJob(job *Job) error {
	if job.Group == "" {
		return fmt.Errorf("任务分组不能为空")
	}
	if job.Name == "" {
		return fmt.Errorf("任务名称不能为空")
	}
	if job.ExecutorName == "" {
		return fmt.Errorf("执行器名称不能为空")
	}
	if job.CronExpression == "" {
		return fmt.Errorf("CRON表达式不能为空")
	}
	if job.ParallelNum <= 0 {
		job.ParallelNum = 1
	}
	if job.Timeout == 0 {
		job.Timeout = 30 * time.Second
	}
	if job.RetryInterval == 0 {
		job.RetryInterval = 10 * time.Second
	}
	return nil
}

// ValidateCronExpression 验证Cron表达式是否有效
// 支持两种格式：
// - 标准Cron：分 时 日 月 周 (5段)
// - 带秒Cron：秒 分 时 日 月 周 (6段)
func ValidateCronExpression(cronExpr string) error {
	if cronExpr == "" {
		return fmt.Errorf("CRON表达式不能为空")
	}

	// 尝试解析为6段格式（带秒）
	parser := cron.NewParser(cron.Second | cron.Minute | cron.Hour | cron.Dom | cron.Month | cron.Dow | cron.Descriptor)
	_, err := parser.Parse(cronExpr)
	if err == nil {
		return nil
	}

	// 尝试解析为5段格式（标准）
	parser = cron.NewParser(cron.Minute | cron.Hour | cron.Dom | cron.Month | cron.Dow | cron.Descriptor)
	_, err = parser.Parse(cronExpr)
	if err == nil {
		return nil
	}

	return fmt.Errorf("无效的CRON表达式: %s", cronExpr)
}
