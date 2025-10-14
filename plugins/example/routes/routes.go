package routes

import (
	"gin-fast/app/global/app"
	"gin-fast/app/middleware"
	"gin-fast/plugins/example/controllers"

	"github.com/gin-gonic/gin"
)

var exampleControllers = &controllers.ExampleController{}

// RegisterRoutes 注册示例插件路由
func RegisterRoutes(engine *gin.Engine) {
	// 示例插件路由组
	example := engine.Group("/api/plugins/example")
	example.Use(middleware.JWTAuthMiddleware())
	example.Use(middleware.CasbinMiddleware())
	{
		// 创建示例
		example.POST("/add", exampleControllers.Create)
		// 更新示例
		example.PUT("/edit", exampleControllers.Update)
		// 删除示例
		example.DELETE("/delete", exampleControllers.Delete)
		// 根据ID获取示例信息
		example.GET("/:id", exampleControllers.GetByID)
		// 示例列表（分页查询）
		example.GET("/list", exampleControllers.List)
	}

	app.ZapLog.Info("示例插件路由注册成功")
}
