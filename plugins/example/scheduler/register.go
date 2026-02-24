package scheduler

import (
	"gin-fast/app/global/app"
	"gin-fast/plugins/example/scheduler/executors"
)

// RegisterExampleExecutors 注册示例插件的所有执行器
// 在插件初始化时调用此函数
func RegisterExampleExecutors() {
	// 注册示例执行器
	app.JobScheduler.RegisterExecutor(&executors.ExampleExecutor{})
}
