package ginhelper

import (
	"errors"
	"fmt"
	"net/http"
	"time"

	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"

	"io"

	"github.com/gin-contrib/pprof"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func GetEngine() *gin.Engine {
	var engine *gin.Engine
	if !app.ConfigYml.GetBool("server.appdebug") {
		// 生产环境下，关闭调试模式，提高性能
		gin.SetMode(gin.ReleaseMode)
		// 生产环境下，关闭gin框架默认的日志输出，避免日志重复输出
		gin.DefaultWriter = io.Discard
		engine = gin.New()
		engine.Use(gin.Logger(), CustomRecovery())
	} else {
		// 开发环境下，开启调试模式，方便开发调试
		gin.SetMode(gin.DebugMode)
		engine = gin.New()
		engine.Use(gin.Logger(), CustomRecovery())

		/**
		注册pprof后，可以通过以下HTTP端点访问性能数据：
		- /debug/pprof/ - 性能分析首页
		- /debug/pprof/profile - CPU性能分析
		- /debug/pprof/heap - 堆内存分析
		- /debug/pprof/goroutine - Goroutine信息
		- /debug/pprof/block - 阻塞分析
		- /debug/pprof/threadcreate - 线程创建分析
		**/
		pprof.Register(engine)
	}
	return engine

}

// CustomRecovery 自定义错误(panic等)拦截中间件、对可能发生的错误进行拦截、统一记录
func CustomRecovery() gin.HandlerFunc {
	DefaultErrorWriter := &PanicExceptionRecord{}
	return gin.RecoveryWithWriter(DefaultErrorWriter, func(c *gin.Context, err interface{}) {
		// 检查是否为请求中止类型的panic
		if err == consts.RequestAborted {
			// 这是由FailAndAbort方法触发的panic，已经处理了响应，不需要额外处理
			return
		}

		// 其他类型的 panic 使用默认处理
		app.ZapLog.Error("服务器内部错误",
			zap.Any("panic", err),
			zap.String("path", c.Request.URL.Path),
			zap.String("method", c.Request.Method),
		)

		// 对于其他类型的panic，记录错误并返回系统错误响应
		// 但需要检查是否已经发送过响应，避免重复响应
		if !c.Writer.Written() {
			// 这里的 err 数据类型为 ：runtime.boundsError  ，需要转为普通数据类型才可以输出
			app.Response.ErrorSystem(c, "", fmt.Sprintf("%s", err))
		}
	})
}

// PanicExceptionRecord  panic等异常记录
type PanicExceptionRecord struct{}

func (p *PanicExceptionRecord) Write(b []byte) (n int, err error) {
	errStr := string(b)
	err = errors.New(errStr)
	//app.ZapLog.Error(consts.ServerOccurredErrorMsg, zap.String("errStrace", errStr))
	return len(errStr), err
}

// PluginRouteFunc 插件路由函数类型
// 该函数类型定义了插件路由的回调函数，插件模块通过该函数注册自己的路由
type PluginRouteFunc func(*gin.Engine)

// pluginRouteFuncs 存储已注册的插件路由函数
var pluginRouteFuncs []PluginRouteFunc

// RegisterPluginRoutes 注册插件路由
// 该函数用于注册插件的路由函数，由插件模块主动调用
// 参数 routeFunc 是插件的路由注册函数，该函数会在初始化时被调用
func RegisterPluginRoutes(routeFunc PluginRouteFunc) {
	if routeFunc != nil {
		pluginRouteFuncs = append(pluginRouteFuncs, routeFunc)
		app.ZapLog.Info("插件路由函数注册成功")
	} else {
		app.ZapLog.Warn("插件路由函数为空，注册失败")
	}
}

// InitPluginRoutes 初始化插件路由
// 该函数在main.go中调用，将*gin.Engine传递给已注册的插件路由函数
// 参数 engine 是Gin引擎实例，会传递给每个已注册的插件路由函数
func InitPluginRoutes(engine *gin.Engine) {
	if len(pluginRouteFuncs) == 0 {
		app.ZapLog.Info("没有注册的插件路由函数")
		return
	}

	// 遍历所有已注册的插件路由函数，并调用它们
	for i, routeFunc := range pluginRouteFuncs {
		if routeFunc != nil {
			routeFunc(engine)
			app.ZapLog.Info("插件路由初始化成功", zap.Int("pluginIndex", i))
		} else {
			app.ZapLog.Warn("插件路由函数为空，跳过初始化", zap.Int("pluginIndex", i))
		}
	}

	app.ZapLog.Info("所有插件路由初始化完成", zap.Int("pluginCount", len(pluginRouteFuncs)))
}

// GetPluginRouteFuncs 获取已注册的插件路由函数列表
// 该函数主要用于调试和测试
func GetPluginRouteFuncs() []PluginRouteFunc {
	return pluginRouteFuncs
}

// StartServer 配置并启动HTTP服务器
func StartServer(engine *gin.Engine) error {
	// 配置HTTP服务器超时设置
	server := &http.Server{
		Addr:         app.ConfigYml.GetString("httpserver.port"),
		Handler:      engine,
		ReadTimeout:  time.Duration(app.ConfigYml.GetInt("httpserver.read_timeout")) * time.Second,
		WriteTimeout: time.Duration(app.ConfigYml.GetInt("httpserver.write_timeout")) * time.Second,
		IdleTimeout:  time.Duration(app.ConfigYml.GetInt("httpserver.idle_timeout")) * time.Second,
	}

	// 启动服务器
	return server.ListenAndServe()
}
