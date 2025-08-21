package routes

import (
	"gin-fast/app/controllers"
	"gin-fast/app/global/g"

	"gin-fast/app/middleware"

	"github.com/gin-gonic/gin"
)

var userControllers = &controllers.UserController{}
var authControllers = &controllers.AuthController{}

// InitRoutes 初始化路由
func InitRoutes(engine *gin.Engine) {
	// 跨域
	if g.ConfigYml.GetBool("HttpServer.AllowCrossDomain") {
		engine.Use(middleware.CorsNext())
	}

	engine.Static("/public", "./resource/public")
	// 公开路由
	public := engine.Group("/api")
	{
		public.POST("/login", authControllers.Login)
		public.POST("/refresh", authControllers.RefreshToken)
	}

	// 受保护的路由
	protected := engine.Group("/api")
	protected.Use(middleware.JWTAuthMiddleware())
	//protected.Use(middleware.CasbinMiddleware())
	{
		// 获取当前登录用户信息
		protected.GET("/users/profile", userControllers.GetProfile)
		// 更新用户信息
		protected.PUT("/users/profile", userControllers.UpdateProfile)
		// 根据ID获取用户信息
		protected.GET("/users/:id", userControllers.GetUserByID)
		// 新增用户
		protected.POST("/users/add", userControllers.Add)
		// 用户登出
		protected.POST("/logout", authControllers.Logout)
	}
}
