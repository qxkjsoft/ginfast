package plugins

import (
	"gin-fast/app/global/app"
	"gin-fast/app/utils/ginhelper"
	"gin-fast/plugins/{{.DirName}}/routes"

	"github.com/gin-gonic/gin"
)

// init 在包被导入时自动执行
func init() {
	// 注册插件路由
	ginhelper.RegisterPluginRoutes(func(engine *gin.Engine) {
		routes.RegisterRoutes(engine)
		app.ZapLog.Info("{{.TableName}}插件路由注册成功")
	})

	app.ZapLog.Info("{{.TableName}}插件初始化完成")
}