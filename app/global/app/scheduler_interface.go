package app

import (
	"gin-fast/app/utils/schedulerhelper"
)

// JobSchedulerInterf 任务调度器接口
// 定义了任务调度器的标准接口，支持任务管理和执行器管理
type JobSchedulerInterf interface {
	// 生命周期管理
	Start()
	Stop()

	// 执行器管理
	RegisterExecutor(executor schedulerhelper.Executor)
	ListExecutors() []schedulerhelper.Executor

	// 任务管理
	AddOrUpdateJob(job *schedulerhelper.Job) (string, error)
	EnableJob(jobID string) error
	DisableJob(jobID string) error
	DeleteJob(jobID string) error
	ExecuteNow(jobID string) error
	ListJobs() []*schedulerhelper.Job
	JobExists(jobID string) bool

	// 结果获取
	GetResults() <-chan *schedulerhelper.JobResult
}
