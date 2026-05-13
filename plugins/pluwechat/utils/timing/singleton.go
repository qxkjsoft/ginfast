package timing

import (
	"gin-fast/app/global/app"
	"sync"

	"go.uber.org/zap"
)

// zapLoggerAdapter 适配器，将 app.ZapLog 包装成 timing.Logger
type zapLoggerAdapter struct{}

func (z *zapLoggerAdapter) Info(msg string, keysAndValues ...interface{}) {
	app.ZapLog.Info("微信定时任务", zap.String("msg", msg), zap.Any("details", keysAndValues))
}

func (z *zapLoggerAdapter) Error(err error, msg string, keysAndValues ...interface{}) {
	app.ZapLog.Error("微信定时任务", zap.String("msg", msg), zap.Error(err), zap.Any("details", keysAndValues))
}

var (
	singletonCron *Cron
	singletonOnce sync.Once
)

// GetSingletonCron 获取单例Cron实例
// opts 仅在首次调用时生效，后续调用将忽略这些选项
func GetSingletonCron() *Cron {
	singletonOnce.Do(func() {
		singletonCron = New(WithLogger(&zapLoggerAdapter{}))
		singletonCron.Start()
	})
	return singletonCron
}
