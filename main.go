package main

import (
	"gin-fast/app/global/app"
	"gin-fast/app/routes"
	"gin-fast/app/utils/ginhelper"
	_ "gin-fast/bootstrap"
	_ "gin-fast/plugins"
)

func main() {
	engine := ginhelper.GetEngine()
	// 初始化系统路由
	routes.InitRoutes(engine)
	// 初始化插件路由
	ginhelper.InitPluginRoutes(engine)
	// 启动服务器
	_ = engine.Run(app.ConfigYml.GetString("httpserver.port"))

}
