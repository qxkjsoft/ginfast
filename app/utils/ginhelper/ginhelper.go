package ginhelper

import (
	"errors"
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"

	"io"

	"github.com/gin-contrib/pprof"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func GetEngine() *gin.Engine {
	var engine *gin.Engine
	if app.ConfigYml.GetBool("Server.AppDebug") == false {
		gin.SetMode(gin.ReleaseMode)
		gin.DefaultWriter = io.Discard
		engine = gin.New()
		engine.Use(gin.Logger(), CustomRecovery())
	} else {
		gin.SetMode(gin.DebugMode)
		engine = gin.Default()

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
		// 这里针对发生的panic等异常进行统一响应即可
		// 这里的 err 数据类型为 ：runtime.boundsError  ，需要转为普通数据类型才可以输出
		app.Response.ErrorSystem(c, "", fmt.Sprintf("%s", err))
	})
}

// PanicExceptionRecord  panic等异常记录
type PanicExceptionRecord struct{}

func (p *PanicExceptionRecord) Write(b []byte) (n int, err error) {
	errStr := string(b)
	err = errors.New(errStr)
	app.ZapLog.Error(consts.ServerOccurredErrorMsg, zap.String("errStrace", errStr))
	return len(errStr), err
}
