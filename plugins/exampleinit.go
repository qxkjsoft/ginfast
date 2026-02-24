package plugins

import (
	_ "gin-fast/plugins/example/routes"
	"gin-fast/plugins/example/scheduler"
)

// 插件初始化时自动执行
func init() {
	// 注册示例执行器
	scheduler.RegisterExampleExecutors()
}
