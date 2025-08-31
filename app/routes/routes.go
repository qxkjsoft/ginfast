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
var sysDepartmentControllers = &controllers.SysDepartmentController{}
var sysRoleControllers = &controllers.SysRoleController{}
var sysDictControllers = &controllers.SysDictController{}

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
		// 用户管理路由组
		users := protected.Group("/users")
		{
			// 获取当前登录用户信息
			users.GET("/profile", userControllers.GetProfile)
			// 根据ID获取用户信息
			users.GET("/:id", userControllers.GetUserByID)
			// 用户列表
			users.GET("/list", userControllers.List)
			// 新增用户
			users.POST("/add", userControllers.Add)
			// 更新用户信息
			users.PUT("/edit", userControllers.Update)
			// 删除用户
			users.DELETE("/delete", userControllers.Delete)
			// 用户登出
			users.POST("/logout", authControllers.Logout)
		}

		// 系统菜单路由组
		sysMenu := protected.Group("/sysMenu")
		{
			// 导出菜单
			sysMenu.GET("/getMenu", sysMenuControllers.GetMenu)
		}

		// 系统部门路由组
		sysDepartment := protected.Group("/sysDepartment")
		{
			// 部门列表
			sysDepartment.GET("/getDivision", sysDepartmentControllers.GetDivision)
		}

		// 系统角色路由组
		sysRole := protected.Group("/sysRole")
		{
			// 获取角色列表（树形结构）
			sysRole.GET("/getRoles", sysRoleControllers.GetRoles)
			// 角色列表（支持分页和过滤）
			sysRole.GET("/list", sysRoleControllers.List)
			// 根据ID获取角色信息
			sysRole.GET("/:id", sysRoleControllers.GetByID)
			// 新增角色
			sysRole.POST("/add", sysRoleControllers.Add)
			// 更新角色
			sysRole.PUT("/edit", sysRoleControllers.Update)
			// 删除角色
			sysRole.DELETE("/delete", sysRoleControllers.Delete)
		}

		// 系统字典路由组
		sysDict := protected.Group("/sysDict")
		{
			// 获取所有字典数据（包含关联字典项）
			sysDict.GET("/getAllDicts", sysDictControllers.GetAllDicts)
			// 根据字典编码获取字典及其字典项
			sysDict.GET("/getByCode/:code", sysDictControllers.GetDictByCode)
		}
	}
}
