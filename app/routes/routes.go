package routes

import (
	"gin-fast/app/controllers"
	"gin-fast/app/global/app"

	"gin-fast/app/middleware"

	"github.com/gin-gonic/gin"
)

var userControllers = &controllers.UserController{}
var authControllers = &controllers.AuthController{}
var sysMenuControllers = &controllers.SysMenuController{}

// InitRoutes 初始化路由
func InitRoutes(engine *gin.Engine) {
	// 跨域
	if app.ConfigYml.GetBool("HttpServer.AllowCrossDomain") {
		engine.Use(middleware.CorsNext())
	}
	// 静态文件
	engine.Static("/public", "./resource/public")
	// 公开路由
	public := engine.Group("/api")
	{
		public.POST("/login", middleware.CaptchaMiddleware(false), authControllers.Login)
		public.POST("/refreshToken", authControllers.RefreshToken)
		// 生成验证码ID
		public.GET("/captcha/id", authControllers.GetCaptchaId)
		// 获取验证码图片
		public.GET("/captcha/image", authControllers.GetCaptchaImg)
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
		protected.POST("/users/logout", authControllers.Logout)

		// 导出菜单
		protected.GET("/sysMenu/getMenu", sysMenuControllers.GetMenu)
	}
}
