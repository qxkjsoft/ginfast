package routes

import (
	"gin-fast/app/global/app"
	"gin-fast/app/middleware"
	"gin-fast/plugins/testbook/controllers"
	"gin-fast/app/utils/ginhelper"
	"github.com/gin-gonic/gin"
)

func init() {
    // RegisterRoutes 注册demo_students插件路由
    var testStudentsControllers = controllers.NewTestStudentsController()
	ginhelper.RegisterPluginRoutes(func (engine *gin.Engine) {
        // demo_students插件路由组
        testStudents := engine.Group("/api/plugins/testbook/teststudents")
        testStudents.Use(middleware.JWTAuthMiddleware())     // 认证中间件
        testStudents.Use(middleware.DemoAccountMiddleware()) // 添加演示账号中间件
        testStudents.Use(middleware.CasbinMiddleware())      // 权限中间件
        {
            // 创建demo_students
            testStudents.POST("/add", testStudentsControllers.Create)
            // 更新demo_students
            testStudents.PUT("/edit", testStudentsControllers.Update)
            // 删除demo_students
            testStudents.DELETE("/delete", testStudentsControllers.Delete)
            // demo_students列表（分页查询）
            testStudents.GET("/list", testStudentsControllers.List)
            // 根据ID获取demo_students信息
            testStudents.GET("/:stuId", testStudentsControllers.GetByID)
        }

        app.ZapLog.Info("demo_students插件路由注册成功")
    })
}