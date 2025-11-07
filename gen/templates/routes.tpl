package routes

import (
	"gin-fast/app/global/app"
	"gin-fast/app/middleware"
	"gin-fast/plugins/{{.DirName}}/controllers"

	"github.com/gin-gonic/gin"
)

var {{.StructNameLower}}Controllers = controllers.New{{.StructName}}Controller()

// RegisterRoutes 注册{{.TableName}}插件路由
func RegisterRoutes(engine *gin.Engine) {
	// {{.TableName}}插件路由组
	{{.StructNameLower}} := engine.Group("/api/plugins/{{.DirName}}")
	{{.StructNameLower}}.Use(middleware.JWTAuthMiddleware())     // 认证中间件
	{{.StructNameLower}}.Use(middleware.DemoAccountMiddleware()) // 添加演示账号中间件
	{{.StructNameLower}}.Use(middleware.CasbinMiddleware())      // 权限中间件
	{
		// 创建{{.TableName}}
		{{.StructNameLower}}.POST("/add", {{.StructNameLower}}Controllers.Create)
		// 更新{{.TableName}}
		{{.StructNameLower}}.PUT("/edit", {{.StructNameLower}}Controllers.Update)
		// 删除{{.TableName}}
		{{.StructNameLower}}.DELETE("/delete", {{.StructNameLower}}Controllers.Delete)
		// {{.TableName}}列表（分页查询）
		{{.StructNameLower}}.GET("/list", {{.StructNameLower}}Controllers.List)
		// 根据ID获取{{.TableName}}信息
		{{.StructNameLower}}.GET("/:{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}", {{.StructNameLower}}Controllers.GetByID)
	}

	app.ZapLog.Info("{{.TableName}}插件路由注册成功")
}