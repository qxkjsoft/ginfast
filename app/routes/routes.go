package routes

import (
	"context"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	"gin-fast/app/controllers"
	"gin-fast/app/global/app"
	"gin-fast/app/middleware"
)

var userControllers = &controllers.UserController{}
var authControllers = &controllers.AuthController{}
var sysMenuControllers = &controllers.SysMenuController{}
var sysDepartmentControllers = &controllers.SysDepartmentController{}
var sysRoleControllers = &controllers.SysRoleController{}
var sysDictControllers = &controllers.SysDictController{}
var sysDictItemControllers = &controllers.SysDictItemController{}
var sysApiControllers = &controllers.SysApiController{}
var sysAffixControllers = &controllers.SysAffixController{}
var configControllers = &controllers.ConfigController{}

// InitRoutes 初始化路由
func InitRoutes(engine *gin.Engine) {

	// 添加自定义 recovery 中间件来处理 FailAndAbort 的 panic
	engine.Use(middleware.RequestAbortedRecovery())

	// 跨域
	if app.ConfigYml.GetBool("httpserver.allowcrossdomain") {
		engine.Use(middleware.CorsNext())
	}

	// 静态文件
	engine.Static(app.ConfigYml.GetString("httpserver.serverrootpath"), app.ConfigYml.GetString("httpserver.serverroot"))

	if app.ConfigYml.GetBool("server.appdebug") {
		// 注册Swagger路由
		engine.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
		// 查看内存缓存项
		engine.GET("/viewCache", func(ctx *gin.Context) {
			items, err := app.Cache.GetAll(context.Background())
			if err != nil {
				ctx.JSON(500, gin.H{"error": "获取缓存项失败", "details": err.Error()})
				return
			}
			ctx.JSON(200, items)
		})
	}

	// 公开路由
	public := engine.Group("/api")
	{
		public.POST("/login", middleware.CaptchaMiddleware(), authControllers.Login)
		public.POST("/refreshToken", authControllers.RefreshToken)
		// 生成验证码ID
		public.GET("/captcha/id", authControllers.GetCaptchaId)
		// 获取验证码图片
		public.GET("/captcha/image", authControllers.GetCaptchaImg)
		// 获取配置信息
		public.GET("/config/get", configControllers.GetConfig)
	}

	// 受保护的路由
	protected := engine.Group("/api")
	protected.Use(middleware.JWTAuthMiddleware())
	protected.Use(middleware.CasbinMiddleware())
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
			users.POST("/add", middleware.PasswordValidatorMiddleware(), userControllers.Add)
			// 更新用户信息
			users.PUT("/edit", userControllers.Update)
			// 删除用户
			users.DELETE("/delete", userControllers.Delete)
			// 用户登出
			users.POST("/logout", authControllers.Logout)
			// 更新密码、邮箱及手机号
			users.PUT("/updateAccount", middleware.PasswordValidatorMiddleware(), userControllers.UpdateAccount)
			// 上传用户头像
			users.POST("/uploadAvatar", userControllers.UploadAvatar)
		}

		// 系统菜单路由组
		sysMenu := protected.Group("/sysMenu")
		{
			// 获取当前用户有权限的菜单数据不含按钮
			sysMenu.GET("/getRouters", sysMenuControllers.GetRouters)
			// 获取完整的菜单列表
			sysMenu.GET("/getMenuList", sysMenuControllers.GetMenuList)
			// 根据ID获取菜单信息
			sysMenu.GET("/:id", sysMenuControllers.GetByID)
			// 新增菜单
			sysMenu.POST("/add", sysMenuControllers.Add)
			// 更新菜单
			sysMenu.PUT("/edit", sysMenuControllers.Update)
			// 删除菜单
			sysMenu.DELETE("/delete", sysMenuControllers.Delete)
			// 根据菜单ID获取API ID集合
			sysMenu.GET("/apis/:id", sysMenuControllers.GetMenuApiIds)
			// 为菜单分配API权限
			sysMenu.POST("/setApis", sysMenuControllers.SetMenuApis)
		}

		// 系统部门路由组
		sysDepartment := protected.Group("/sysDepartment")
		{
			// 部门列表
			sysDepartment.GET("/getDivision", sysDepartmentControllers.GetDivision)
			// 根据ID获取部门信息
			sysDepartment.GET("/:id", sysDepartmentControllers.GetByID)
			// 新增部门
			sysDepartment.POST("/add", sysDepartmentControllers.Add)
			// 更新部门
			sysDepartment.PUT("/edit", sysDepartmentControllers.Update)
			// 删除部门
			sysDepartment.DELETE("/delete", sysDepartmentControllers.Delete)
		}

		// 系统角色路由组
		sysRole := protected.Group("/sysRole")
		{
			// 获取所有角色数据（树形结构）
			sysRole.GET("/getRoles", sysRoleControllers.GetRoles)
			// 根据角色ID获取角色菜单权限
			sysRole.GET("/getUserPermission/:roleId", sysRoleControllers.GetUserPermission)
			// 为角色分配菜单权限
			sysRole.POST("/addRoleMenu", sysRoleControllers.AddRoleMenu)
			// 角色分页列表
			sysRole.GET("/list", sysRoleControllers.List)
			// 根据ID获取角色信息
			sysRole.GET("/:id", sysRoleControllers.GetByID)
			// 新增角色
			sysRole.POST("/add", sysRoleControllers.Add)
			// 更新角色
			sysRole.PUT("/edit", sysRoleControllers.Update)
			// 删除角色
			sysRole.DELETE("/delete", sysRoleControllers.Delete)
			// 更新角色数据权限
			sysRole.PUT("/dataScope", sysRoleControllers.UpdateDataScope)
		}

		// 系统字典路由组
		sysDict := protected.Group("/sysDict")
		{
			// 获取所有字典数据（包含关联字典项）
			sysDict.GET("/getAllDicts", sysDictControllers.GetAllDicts)
			// 根据字典编码获取字典及其字典项
			sysDict.GET("/getByCode/:code", sysDictControllers.GetDictByCode)
			// 字典分页列表
			sysDict.GET("/list", sysDictControllers.List)
			// 根据ID获取字典信息
			sysDict.GET("/:id", sysDictControllers.GetByID)
			// 新增字典
			sysDict.POST("/add", sysDictControllers.Add)
			// 更新字典
			sysDict.PUT("/edit", sysDictControllers.Update)
			// 删除字典
			sysDict.DELETE("/delete", sysDictControllers.Delete)
		}

		// 系统字典项路由组
		sysDictItem := protected.Group("/sysDictItem")
		{
			// 字典项列表（无分页）
			sysDictItem.GET("/list", sysDictItemControllers.List)
			// 根据ID获取字典项信息
			sysDictItem.GET("/:id", sysDictItemControllers.GetByID)
			// 根据字典ID获取字典项列表
			sysDictItem.GET("/getByDictId/:dictId", sysDictItemControllers.GetByDictID)
			// 根据字典编码获取字典项列表
			sysDictItem.GET("/getByDictCode/:dictCode", sysDictItemControllers.GetByDictCode)
			// 新增字典项
			sysDictItem.POST("/add", sysDictItemControllers.Add)
			// 更新字典项
			sysDictItem.PUT("/edit", sysDictItemControllers.Update)
			// 删除字典项
			sysDictItem.DELETE("/delete", sysDictItemControllers.Delete)
		}

		// 系统API路由组
		sysApi := protected.Group("/sysApi")
		{
			// API列表
			sysApi.GET("/list", sysApiControllers.List)
			// 根据ID获取API信息
			sysApi.GET("/:id", sysApiControllers.GetByID)
			// 新增API
			sysApi.POST("/add", sysApiControllers.Add)
			// 更新API
			sysApi.PUT("/edit", sysApiControllers.Update)
			// 删除API
			sysApi.DELETE("/delete", sysApiControllers.Delete)
		}

		// 系统文件附件路由组
		sysAffix := protected.Group("/sysAffix")
		{
			// 上传文件
			sysAffix.POST("/upload", sysAffixControllers.Upload)
			// 删除文件
			sysAffix.DELETE("/delete", sysAffixControllers.Delete)
			// 修改文件名
			sysAffix.PUT("/updateName", sysAffixControllers.UpdateName)
			// 文件列表（分页查询）
			sysAffix.GET("/list", sysAffixControllers.List)
			// 根据ID获取文件信息
			sysAffix.GET("/:id", sysAffixControllers.GetByID)
			// 获取文件URL
			sysAffix.GET("/download/:id", sysAffixControllers.Download)
		}

		// 系统配置路由组
		config := protected.Group("/config")
		{

			// 更新配置信息
			config.PUT("/update", configControllers.UpdateConfig)

		}
	}
}
