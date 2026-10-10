// register.go 系统定时任务注册入口
//
// 本文件专门用于注册系统自带的定时任务（当前：演示任务、操作日志清理）。
// 任务加载（LoadJobsFromDB）、插件任务的注册与持久化（RegisterAndPersistJob /
// PersistJobToDB）见 jobs.go。
package scheduler

import (
	"time"

	"gin-fast/app/global/app"
	"gin-fast/app/scheduler/executors"
	"gin-fast/app/utils/schedulerhelper"
)

// RegisterExecutors 注册所有系统任务的执行器与任务定义
// 在这里添加新的执行器/任务注册
func RegisterExecutors() {
	// 注册演示执行器（仅演示执行器写法，无预置任务，可在后台"定时任务"模块建任务体验）
	app.JobScheduler.RegisterExecutor(&executors.DemoExecutor{})

	// 注册操作日志清理执行器，并预置定时任务（随启动自动注册+持久化，但**默认停用**，
	// 不会自动清理）。需要启用日志清理时，在后台"定时任务"模块将该任务**启用**并按需调整
	// 保留天数（参数 retain_days，默认 90 天）与执行时间即可，启用即生效无需重启。
	// 行为：硬删 retain_days 之前的 sys_operation_logs（非软删标记，删除后不可恢复），
	// 启用前请确认已了解删除范围。
	app.JobScheduler.RegisterExecutor(&executors.OperationLogCleanupExecutor{})

	logCleanupJob := &schedulerhelper.Job{
		ID:     "operation-log-cleanup",
		Group:  "system",
		Name:   "操作日志清理",
		// 描述须与下方 CronExpression 及 executor 实际行为保持一致（SB-13 教训）。
		// 注意：PersistJobToDB 为 OnConflict DoNothing，存量环境 sys_jobs 已持久化的状态/描述
		// 不会被本次代码覆盖，可在后台"定时任务"模块编辑或手动 UPDATE 同步。
		Description:     "每天凌晨 3 点清理 retain_days 天之前的操作日志（默认保留 90 天，任务参数可配）",
		ExecutorName:    (&executors.OperationLogCleanupExecutor{}).Name(),
		ExecutionPolicy: schedulerhelper.PolicyRepeat,
		Status:          schedulerhelper.StatusDisabled, // 默认停用：日志清理有不可恢复的删除动作，由管理员在后台按需启用
		CronExpression:  "0 0 3 * * *", // 6 段(含秒字段)，每天凌晨 3 点触发
		BlockingPolicy:  schedulerhelper.BlockDiscard,
		Timeout:         10 * time.Minute,
		Parameters:      map[string]interface{}{"retain_days": 90},
	}
	// 注册 + 持久化一步完成（内部失败仅记日志不阻断启动，可忽略返回值）
	_ = RegisterAndPersistJob(logCleanupJob)

	// 在这里添加更多执行器/任务...
	// app.JobScheduler.RegisterExecutor(&executors.YourExecutor{})
	// scheduler.RegisterAndPersistJob(&schedulerhelper.Job{...})
}
