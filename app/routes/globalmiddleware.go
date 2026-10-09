package routes

import (
	"context"
	"time"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	"gin-fast/app/global/app"
	"gin-fast/app/middleware"
	"gin-fast/app/utils/cachehelper"
	"gin-fast/app/utils/ginhelper"
)

// setupGlobalMiddleware 注册引擎级全局中间件与全局路由（须在 /api 业务路由注册之前调用，保持原有注册顺序）：
//   - 全局跨域中间件（httpserver.allowcrossdomain）
//   - 静态资源：主静态目录（httpserver.serverrootpath/serverroot）+ 额外静态目录映射（httpserver.extra_static）
//   - 调试模式路由：Swagger 文档、内存缓存查看（server.appdebug）
//   - 全局操作日志中间件（server.syslog）
//   - 全局超时中间件（httpserver.handler_timeout）
//
// 注意：gin 的 engine.Use 只对其后注册的路由生效，静态资源与 Swagger 不受操作日志/超时中间件约束，
// 各段注册顺序不可调换
func setupGlobalMiddleware(engine *gin.Engine) {
	// 全局跨域中间件
	if app.ConfigYml.GetBool("httpserver.allowcrossdomain") {
		engine.Use(middleware.CorsNext())
	}

	// 静态文件（安全加固：nosniff、uploads 下 svg 禁脚本 CSP、html 类强制下载、关闭目录列表）
	ginhelper.SecureStatic(engine, app.ConfigYml.GetString("httpserver.serverrootpath"), app.ConfigYml.GetString("httpserver.serverroot"))

	// 额外静态目录映射（httpserver.extra_static 列表，每项 prefix(URL前缀)+dir(磁盘目录)），
	// 用于旧系统迁移的静态资源路径（如旧CMS图片 /d/...），同样复用 SecureStatic 安全加固
	if extras, ok := app.ConfigYml.Get("httpserver.extra_static").([]interface{}); ok {
		for _, item := range extras {
			m, _ := item.(map[string]interface{})
			prefix, _ := m["prefix"].(string)
			dir, _ := m["dir"].(string)
			if prefix == "" || dir == "" {
				continue
			}
			ginhelper.SecureStatic(engine, prefix, dir)
		}
	}

	//	调试模式下注册Swagger路由、查看内存缓存项
	if app.ConfigYml.GetBool("server.appdebug") {
		// 注册Swagger路由
		engine.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
		// 查看内存缓存项（需登录鉴权 + 超管校验，且 token 类缓存值脱敏，防止泄露在线用户凭证）
		engine.GET("/viewCache", middleware.JWTAuthMiddleware(), middleware.SuperAdminMiddleware(), func(ctx *gin.Context) {
			items, err := app.Cache.GetAll(context.Background())
			if err != nil {
				ctx.JSON(500, gin.H{"error": "获取缓存项失败", "details": err.Error()})
				return
			}
			ctx.JSON(200, cachehelper.MaskTokenValues(items))
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
}
