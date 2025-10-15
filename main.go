package main

import (
	"gin-fast/app/global/app"
	"gin-fast/app/routes"
	"gin-fast/app/utils/ginhelper"
	_ "gin-fast/bootstrap"

	_ "gin-fast/docs/swagger" // swagger docs
	_ "gin-fast/plugins"
)

// @title Gin-Fast API
// @version 1.0
// @description 基于Gin框架的快速开发脚手架API文档
// @termsOfService https://github.com/your-repo/gin-fast

// @contact.name API Support
// @contact.url https://github.com/your-repo/gin-fast/issues
// @contact.email your-email@example.com

// @license.name MIT
// @license.url https://github.com/your-repo/gin-fast/blob/master/LICENSE

// @host localhost:8080
// @BasePath /api
func main() {
	// 获取Gin引擎实例
	engine := ginhelper.GetEngine()
	// 初始化系统路由
	routes.InitRoutes(engine)
	// 初始化插件路由
	ginhelper.InitPluginRoutes(engine)

	// 启动服务器
	_ = engine.Run(app.ConfigYml.GetString("httpserver.port"))

}
