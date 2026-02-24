package scheduler

import (
	"context"
	"encoding/json"
	"time"

	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/scheduler/executors"
	"gin-fast/app/utils/schedulerhelper"

	"go.uber.org/zap"
)

// RegisterExecutors 注册所有执行器
// 在这里添加新的执行器注册
func RegisterExecutors() {
	// 注册演示执行器
	app.JobScheduler.RegisterExecutor(&executors.DemoExecutor{})

	// 在这里添加更多执行器...
	// app.JobScheduler.RegisterExecutor(&executors.YourExecutor{})
}

// LoadJobsFromDB 从数据库加载启用的任务并注册到调度器
func LoadJobsFromDB() {
	ctx := context.Background()

	// 查询所有启用的任务 (status=1)
	var jobsList models.SysJobsList
	err := app.DB().WithContext(ctx).Model(&models.SysJobs{}).Where("status = ?", 1).Find(&jobsList).Error
	if err != nil {
		app.ZapLog.Error("从数据库加载任务失败", zap.Error(err))
		return
	}

	app.ZapLog.Info("从数据库加载启用的任务", zap.Int("count", len(jobsList)))

	// 遍历任务列表，添加到调度器
	for _, job := range jobsList {
		// 解析任务参数JSON字符串
		var parameters map[string]interface{}
		if job.Parameters != "" {
			if err := json.Unmarshal([]byte(job.Parameters), &parameters); err != nil {
				app.ZapLog.Error("解析任务参数失败",
					zap.String("jobID", job.Id),
					zap.String("name", job.Name),
					zap.Error(err))
				continue
			}
		}

		// 构建调度器Job对象
		schedulerJob := &schedulerhelper.Job{
			ID:              job.Id,
			Group:           job.Group,
			Name:            job.Name,
			Description:     job.Description,
			ExecutorName:    job.ExecutorName,
			ExecutionPolicy: schedulerhelper.ExecutionPolicy(job.ExecutionPolicy),
			Status:          schedulerhelper.JobStatus(job.Status),
			CronExpression:  job.CronExpression,
			Parameters:      parameters,
			BlockingPolicy:  schedulerhelper.BlockingPolicy(job.BlockingPolicy),
			Timeout:         time.Duration(job.Timeout),
			MaxRetry:        job.MaxRetry,
			RetryInterval:   time.Duration(job.RetryInterval),
			ParallelNum:     job.ParallelNum,
		}

		// 添加到调度器
		_, err := app.JobScheduler.AddOrUpdateJob(schedulerJob)
		if err != nil {
			app.ZapLog.Error("添加任务到调度器失败",
				zap.String("jobID", job.Id),
				zap.String("name", job.Name),
				zap.Error(err))
			continue
		}

		app.ZapLog.Info("成功加载任务到调度器",
			zap.String("jobID", job.Id),
			zap.String("name", job.Name),
			zap.String("cron", job.CronExpression))
	}

	// 启动任务结果处理器，将任务执行结果保存到数据库
	StartResultHandler()
}
