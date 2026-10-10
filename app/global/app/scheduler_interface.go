package app

import (
	"gin-fast/app/utils/schedulerhelper"
)

// JobSchedulerInterf 任务调度器接口
// 定义了任务调度器的标准接口，支持任务管理和执行器管理
type JobSchedulerInterf interface {
	// 生命周期管理

	// Start 启动调度器：加载任务并开始按 CRON 周期触发执行
	Start()

	// Stop 停止调度器：停止所有任务的触发，已开始执行的任务由各任务的超时/上下文控制收尾
	Stop()

	// 执行器管理

	// RegisterExecutor 注册执行器：任务通过 ExecutorName 与执行器关联后才能被调度执行
	RegisterExecutor(executor schedulerhelper.Executor)

	// ListExecutors 返回已注册的全部执行器列表
	ListExecutors() []schedulerhelper.Executor

	// 任务管理

	// AddOrUpdateJob 添加或更新任务：同 ID 任务已存在则按传入定义覆盖（CRON/参数等修改即时生效），
	// 不存在则新增并按 CRON 开始调度；返回任务 ID 与错误
	AddOrUpdateJob(job *schedulerhelper.Job) (string, error)

	// EnableJob 启用任务：恢复按 CRON 周期调度（对已启用的任务重复调用无副作用）
	EnableJob(jobID string) error

	// DisableJob 停用任务：保留任务定义但暂停调度，可通过 EnableJob 重新启用
	DisableJob(jobID string) error

	// DeleteJob 删除任务：从调度器中移除任务定义，恢复需重新添加
	DeleteJob(jobID string) error

	// ExecuteNow 立即触发任务：不等下一个 CRON 周期，按任务的执行策略（如阻塞丢弃）立刻调度一次
	ExecuteNow(jobID string) error

	// ListJobs 返回调度器中的全部任务列表
	ListJobs() []*schedulerhelper.Job

	// JobExists 判断指定 ID 的任务是否存在于调度器中
	JobExists(jobID string) bool

	// 结果获取

	// GetResults 返回任务执行结果的只读通道：每执行完成一次任务产出一条结果，
	// 由 result_handler 消费并持久化到 sys_job_results 表
	GetResults() <-chan *schedulerhelper.JobResult
}
