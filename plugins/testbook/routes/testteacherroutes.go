package routes

import (
	"gin-fast/app/global/app"
	"gin-fast/app/middleware"
	"gin-fast/plugins/testbook/controllers"
	"gin-fast/app/utils/ginhelper"
	"github.com/gin-gonic/gin"
)

func init() {
    // RegisterRoutes 注册demo_teacher插件路由
    var testTeacherControllers = controllers.NewTestTeacherController()
	ginhelper.RegisterPluginRoutes(func (engine *gin.Engine) {
        // demo_teacher插件路由组
        testTeacher := engine.Group("/api/plugins/testbook/testteacher")
        testTeacher.Use(middleware.JWTAuthMiddleware())     // 认证中间件
        testTeacher.Use(middleware.DemoAccountMiddleware()) // 添加演示账号中间件
        testTeacher.Use(middleware.CasbinMiddleware())      // 权限中间件
        {
            // 创建demo_teacher
            testTeacher.POST("/add", testTeacherControllers.Create)
            // 更新demo_teacher
            testTeacher.PUT("/edit", testTeacherControllers.Update)
            // 删除demo_teacher
            testTeacher.DELETE("/delete", testTeacherControllers.Delete)
            // demo_teacher列表（分页查询）
            testTeacher.GET("/list", testTeacherControllers.List)
            // 根据ID获取demo_teacher信息
            testTeacher.GET("/:tcId", testTeacherControllers.GetByID)
        }

        app.ZapLog.Info("demo_teacher插件路由注册成功")
    })
}