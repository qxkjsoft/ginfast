package schedulerhelper

import (
	"log"

	"github.com/robfig/cron/v3"
)

// Option 定义调度器配置选项函数类型
type Option func(*JobScheduler)

// WithLogger 设置自定义日志记录器
func WithLogger(logger JobLogger) Option {
	return func(s *JobScheduler) {
		s.logger = logger
	}
}

// WithLoggerConfig 设置日志目录和级别
func WithLoggerConfig(logDir string, level LogLevel) Option {
	return func(s *JobScheduler) {
		logger, err := NewFileJobLogger(logDir, level)
		if err != nil {
			log.Fatalf("Failed to create logger: %v", err)
		}
		s.logger = logger
	}
}

// WithJobResultsBufferSize 设置任务结果通道缓冲大小
func WithJobResultsBufferSize(size int) Option {
	return func(s *JobScheduler) {
		s.jobResults = make(chan *JobResult, size)
	}
}

// WithCronOptions 设置自定义 cron 选项
func WithCronOptions(opts ...cron.Option) Option {
	return func(s *JobScheduler) {
		s.cron = cron.New(opts...)
	}
}
