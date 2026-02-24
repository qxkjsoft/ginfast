package schedulerhelper

import (
	"context"
	"time"

	"github.com/robfig/cron/v3"
)

// 任务状态
type JobStatus int

const (
	StatusEnabled  JobStatus = 1 // 启用
	StatusDisabled JobStatus = 0 // 禁用
)

// 执行策略
type ExecutionPolicy int

const (
	PolicyRepeat ExecutionPolicy = 1 // 重复执行
	PolicyOnce   ExecutionPolicy = 0 // 单次执行
)

// 阻塞策略
type BlockingPolicy int

const (
	BlockDiscard  BlockingPolicy = iota // 丢弃
	BlockParallel                       // 并行
)

// 任务结构体
type Job struct {
	ID              string                 `json:"id"`
	Group           string                 `json:"group"`           // 任务分组名称
	Name            string                 `json:"name"`            // 任务名称
	Description     string                 `json:"description"`     // 描述
	ExecutorName    string                 `json:"executorName"`    // 执行器名称
	ExecutionPolicy ExecutionPolicy        `json:"executionPolicy"` // 执行策略
	Status          JobStatus              `json:"status"`          // 状态
	CronExpression  string                 `json:"cronExpression"`  // cron表达式
	Parameters      map[string]interface{} `json:"parameters"`      // 任务参数
	BlockingPolicy  BlockingPolicy         `json:"blockingPolicy"`  // 阻塞策略
	Timeout         time.Duration          `json:"timeout"`         // 超时时间
	MaxRetry        int                    `json:"maxRetry"`        // 最大重试次数
	RetryInterval   time.Duration          `json:"retryInterval"`   // 重试间隔
	ParallelNum     int                    `json:"parallelNum"`     // 并行数
	RunningCount    int                    `json:"runningCount"`    // 当前运行中的任务数
	CreatedAt       time.Time              `json:"createdAt"`       // 创建时间
	UpdatedAt       time.Time              `json:"updatedAt"`       // 更新时间
	cronEntryID     cron.EntryID           // cron调度器中的条目ID
}

// 任务执行结果
type JobResult struct {
	JobID           string          `json:"jobId"`           // 任务ID
	Status          string          `json:"status"`          // 任务状态
	Error           error           `json:"error,omitempty"` // 错误信息
	StartTime       time.Time       `json:"startTime"`       // 开始时间
	EndTime         time.Time       `json:"endTime"`         // 结束时间
	Duration        time.Duration   `json:"duration"`        // 执行时长
	RetryCount      int             `json:"retryCount"`      // 重试次数
	ExecutionPolicy ExecutionPolicy `json:"executionPolicy"` // 执行策略
}

// 执行器接口
type Executor interface {
	Execute(ctx context.Context, job *Job) error
	Name() string
}

func getJobStatusName(status JobStatus) string {
	switch status {
	case StatusEnabled:
		return "启用"
	case StatusDisabled:
		return "禁用"
	default:
		return "未知"
	}
}

// Clone 创建 Job 的深拷贝，用于并发安全地传递给执行器
func (j *Job) Clone() *Job {
	clone := *j // 浅拷贝

	// 深拷贝 Parameters
	if j.Parameters != nil {
		clone.Parameters = make(map[string]interface{})
		for k, v := range j.Parameters {
			clone.Parameters[k] = v
		}
	}

	return &clone
}

// Helper functions
func getExecutionPolicyName(policy ExecutionPolicy) string {
	switch policy {
	case PolicyRepeat:
		return "重复执行"
	case PolicyOnce:
		return "单次执行"
	default:
		return "未知"
	}
}

func getBlockingPolicyName(policy BlockingPolicy) string {
	switch policy {
	case BlockDiscard:
		return "丢弃"
	case BlockParallel:
		return "并行"
	default:
		return "未知"
	}
}
