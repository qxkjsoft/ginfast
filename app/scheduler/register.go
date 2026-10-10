// register.go 系统定时任务注册入口
//
// 本文件专门用于注册系统自带的定时任务（当前：演示任务、操作日志清理）。
// 任务加载（LoadJobsFromDB）与插件任务的持久化（PersistJobToDB）见 jobs.go。
package scheduler

import (
	"gin-fast/app/global/app"
	"gin-fast/app/scheduler/executors"
)

// RegisterExecutors 注册所有执行器
// 在这里添加新的执行器注册
func RegisterExecutors() {
	// 注册演示执行器
	app.JobScheduler.RegisterExecutor(&executors.DemoExecutor{})

	// 注册操作日志清理执行器。
	// 本执行器本身不会自动运行，需在管理端"定时任务"模块新建任务后才会生效：
	//   执行器名称：operation-log-cleanup
	//   执行策略：重复执行
	//   CRON 表达式：0 0 3 * * *（六段含秒，建议凌晨低峰；保存即生效，无需重启）
	//   任务参数：{"retain_days": 90}（可选；缺省/非法/≤0 时兜底 90 天）
	// 行为：硬删 retain_days 之前的 sys_operation_logs（非软删标记，删除后不可恢复）；
	//      不配置任务则清理不运行，与未启用时等价
	app.JobScheduler.RegisterExecutor(&executors.OperationLogCleanupExecutor{})

	// 在这里添加更多执行器...
	// app.JobScheduler.RegisterExecutor(&executors.YourExecutor{})
}
