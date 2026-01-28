package routes

import (
	"context"
	"time"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	"gin-fast/app/controllers"
	"gin-fast/app/global/app"
	"gin-fast/app/middleware"
)

var userControllers = controllers.NewUserController()                       // 用户控制器
var authControllers = controllers.NewAuthController()                       // 认证控制器
var sysMenuControllers = controllers.NewSysMenuController()                 // 菜单控制器
var sysDepartmentControllers = controllers.NewSysDepartmentController()     // 部门控制器
var sysRoleControllers = controllers.NewSysRoleController()                 // 角色控制器
var sysDictControllers = controllers.NewSysDictController()                 // 字典控制器
var sysDictItemControllers = controllers.NewSysDictItemController()         // 字典项控制器
var sysApiControllers = controllers.NewSysApiController()                   // API控制器
var sysAffixControllers = controllers.NewSysAffixController()               // 文件管理
var configControllers = controllers.NewConfigController()                   // 配置控制器
var sysOperationLogControllers = controllers.NewSysOperationLogController() // 操作日志控制器
var sysTenantControllers = controllers.NewTenantController()                // 租户控制器
var sysUserTenantControllers = controllers.NewSysUserTenantController()     // 用户租户关联控制器
var codeGenControllers = controllers.NewCodeGenController()                 // 代码生成控制器
var sysGenControllers = controllers.NewSysGenController()                   // 代码生成配置控制器
var pluginsManagerControllers = controllers.NewPluginsManagerController()   // 插件管理控制器

// InitRoutes 初始化路由
func InitRoutes(engine *gin.Engine) {
	// 全局跨域中间件
	if app.ConfigYml.GetBool("httpserver.allowcrossdomain") {
		engine.Use(middleware.CorsNext())
	}

	// 静态文件
	engine.Static(app.ConfigYml.GetString("httpserver.serverrootpath"), app.ConfigYml.GetString("httpserver.serverroot"))

	//	调试模式下注册Swagger路由、查看内存缓存项
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

	// 全局操作日志中间件
	if app.ConfigYml.GetBool("server.syslog") {
		engine.Use(middleware.OperationLogMiddleware())
	}

	// 全局超时中间件
	handlerTimeout := app.ConfigYml.GetInt("httpserver.handler_timeout")
	if handlerTimeout > 0 {
		engine.Use(middleware.TimeoutMiddleware(time.Duration(handlerTimeout) * time.Second))
	}

	api := engine.Group("/api")
	{
		// 公开路由
		public := api.Group("")
		public.POST("/login", middleware.CaptchaMiddleware(), authControllers.Login)
		public.POST("/refreshToken", authControllers.RefreshToken)
		// 获取验证码图片字符串
		public.GET("/captcha/verify", authControllers.GetVerifyImgString)
		// 获取配置信息
		public.GET("/config/get", configControllers.GetConfig)
		// 受保护的路由
		protected := api.Group("")
		protected.Use(middleware.JWTAuthMiddleware())
		protected.Use(middleware.DemoAccountMiddleware()) // 添加演示账号中间件
		protected.Use(middleware.CasbinMiddleware())
		{
			// 用户管理路由组
			users := protected.Group("/users")
			{
				// 获取当前登录用户信息
				users.GET("/profile", userControllers.GetProfile)
				// 用户列表
				users.GET("/list", userControllers.List)

				// 根据ID获取用户信息
				users.GET("/:id", userControllers.GetUserByID)
				// 新增用户
				users.POST("/add", middleware.PasswordValidatorMiddleware(), userControllers.Add)
				// 更新用户信息
				users.PUT("/edit", middleware.PasswordValidatorMiddleware(), userControllers.Update)
				// 删除用户
				users.DELETE("/delete", userControllers.Delete)
				// 用户登出
				users.POST("/logout", authControllers.Logout)
				// 更新当前登录用户密码、邮箱及手机号
				users.PUT("/updateAccount", middleware.PasswordValidatorMiddleware(), userControllers.UpdateAccount)
				// 上传用户头像
				users.POST("/uploadAvatar", userControllers.UploadAvatar)
				// 更新当前登录用户基本信息
				users.PUT("/updateBasicInfo", userControllers.UpdateBasicInfo)
				// 切换租户
				users.GET("/switchTenant/:tenantId", userControllers.SwitchTenant)
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
				// 批量删除菜单
				sysMenu.DELETE("/batchDelete", sysMenuControllers.BatchDelete)
				// 根据菜单ID获取API ID集合
				sysMenu.GET("/apis/:id", sysMenuControllers.GetMenuApiIds)
				// 为菜单分配API权限
				sysMenu.POST("/setApis", sysMenuControllers.SetMenuApis)
				// 导出菜单数据
				sysMenu.GET("/export", sysMenuControllers.Export)
				// 导入菜单数据
				sysMenu.POST("/import", sysMenuControllers.Import)
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

			// 操作日志路由组
			sysOperationLog := protected.Group("/sysOperationLog")
			{
				// 操作日志列表
				sysOperationLog.GET("/list", sysOperationLogControllers.List)
				// 删除操作日志
				sysOperationLog.DELETE("/delete", sysOperationLogControllers.Delete)
				// 导出操作日志
				sysOperationLog.GET("/export", sysOperationLogControllers.Export)
			}

			// 租户管理路由组
			sysTenant := protected.Group("/sysTenant")
			{
				// 租户列表
				sysTenant.GET("/list", sysTenantControllers.List)
				// 根据ID获取租户信息
				sysTenant.GET("/:id", sysTenantControllers.GetByID)
				// 新增租户
				sysTenant.POST("/add", sysTenantControllers.Add)
				// 更新租户
				sysTenant.PUT("/edit", sysTenantControllers.Update)
				// 删除租户
				sysTenant.DELETE("/:id", sysTenantControllers.Delete)
			}

			// 用户租户关联管理路由组
			sysUserTenant := protected.Group("/sysUserTenant")
			{
				// 用户租户关联列表
				sysUserTenant.GET("/list", sysUserTenantControllers.List)
				// 根据用户ID和租户ID获取用户租户关联信息
				sysUserTenant.GET("/get", sysUserTenantControllers.GetByID)
				//批量新增用户租户关联
				sysUserTenant.POST("/batchAdd", sysUserTenantControllers.BatchAdd)
				//批量删除用户租户关联
				sysUserTenant.DELETE("/batchDelete", sysUserTenantControllers.BatchDelete)
				// 用户列表(不限租户)
				sysUserTenant.GET("/userListAll", sysUserTenantControllers.UserListAll)
				// 角色列表(不限租户)
				sysUserTenant.GET("/getRolesAll", sysUserTenantControllers.GetRolesAll)
				// 根查询角色ID集合(不限租户)
				sysUserTenant.GET("/getUserRoleIDs", sysUserTenantControllers.GetUserRoleIDs)
				// 设置用户角色(不限租户)
				sysUserTenant.POST("/setUserRoles", sysUserTenantControllers.SetUserRoles)
			}

			// 代码生成配置路由组
			sysGen := protected.Group("/sysGen")
			{
				// 代码生成配置列表（分页查询）
				sysGen.GET("/list", sysGenControllers.List)
				// 批量创建代码生成配置
				sysGen.POST("/batchInsert", sysGenControllers.BatchInsert)
				// 根据ID获取代码生成配置详情
				sysGen.GET("/:id", sysGenControllers.GetByID)
				// 根据ID更新代码生成配置和字段信息
				sysGen.PUT("/update", sysGenControllers.Update)
				// 根据ID删除代码生成配置和字段信息
				sysGen.DELETE("/:id", sysGenControllers.Delete)
				// 根据ID刷新字段信息
				sysGen.PUT("/refreshFields", sysGenControllers.RefreshFields)
			}

			// 代码生成路由组
			codeGen := protected.Group("/codegen")
			{
				// 获取数据库列表
				codeGen.GET("/databases", codeGenControllers.GetDatabases)
				// 获取指定数据库中的表
				codeGen.GET("/tables", codeGenControllers.GetTables)
				// 获取指定表的字段信息
				codeGen.GET("/columns", codeGenControllers.GetTableColumns)
				// 生成代码
				codeGen.POST("/generate", codeGenControllers.GenerateCode)
				// 预览代码
				codeGen.GET("/preview", codeGenControllers.PreviewCode)
				// 生成菜单
				codeGen.POST("/insertmenuandapi", codeGenControllers.InsertMenuAndApiData)
			}

			// 插件管理路由组
			pluginsManager := protected.Group("/pluginsmanager")
			{
				// 获取所有插件导出配置
				pluginsManager.GET("/exports", pluginsManagerControllers.GetPluginsExport)
				// 导出插件为压缩包
				pluginsManager.POST("/export", pluginsManagerControllers.ExportPlugin)
				// 导入插件
				pluginsManager.POST("/import", pluginsManagerControllers.ImportPlugin)
				// 卸载插件
				pluginsManager.DELETE("/uninstall", pluginsManagerControllers.UninstallPlugin)
			}
		}
	}

}
