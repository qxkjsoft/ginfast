package main

import (
	"gin-fast/app/global/g"
	"gin-fast/app/routes"
	"gin-fast/app/utils/ginhelper"
	_ "gin-fast/bootstrap"
)

func main() {
	engine := ginhelper.GetEngine()
	// 初始化路由
	routes.InitRoutes(engine)
	// 启动服务器
	_ = engine.Run(g.ConfigYml.GetString("HttpServer.Port"))

}
