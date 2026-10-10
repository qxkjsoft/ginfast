// jobs.go 任务加载与持久化（与 sys_jobs 表交互）
//
// 承载两项职责：
//   - LoadJobsFromDB：启动时从 sys_jobs 加载启用的任务并注册到内存调度器，
//     随后启动结果处理器（将执行结果持久化到 sys_job_results）
//   - PersistJobToDB：供插件将自定义任务持久化到 sys_jobs（满足 sys_job_results 外键约束）
//
// 执行器的注册见 register.go（RegisterExecutors），本文件不负责执行器注册。
package scheduler

import (
	"context"
	"encoding/json"
	"time"

	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/schedulerhelper"

	"go.uber.org/zap"
	"gorm.io/gorm/clause"
)

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

// RegisterAndPersistJob 注册任务到内存调度器并持久化到 sys_jobs（两步合并的便捷方法）。
//
// 内部依次执行：
//  1. AddOrUpdateJob：任务按 CRON 立即开始调度（进程重启后随 LoadJobsFromDB 自动恢复）；
//  2. PersistJobToDB：写入 sys_jobs 镜像记录（OnConflict DoNothing 仅首次启动插入，
//     不覆盖用户在后台对任务的修改）。
//
// 任一步骤失败仅记录日志并返回错误，不 panic：任务调度不依赖 sys_jobs 记录，
// 持久化失败仅影响 sys_job_results 历史落库；调用方可按需忽略返回值。
func RegisterAndPersistJob(job *schedulerhelper.Job) error {
	if _, err := app.JobScheduler.AddOrUpdateJob(job); err != nil {
		app.ZapLog.Error("注册任务到调度器失败",
			zap.String("jobID", job.ID),
			zap.String("name", job.Name),
			zap.Error(err))
		return err
	}

	if err := PersistJobToDB(job); err != nil {
		app.ZapLog.Error("持久化任务到 sys_jobs 失败",
			zap.String("jobID", job.ID),
			zap.String("name", job.Name),
			zap.Error(err))
		return err
	}
	return nil
}

// PersistJobToDB 将任务定义持久化到 sys_jobs 表（主键冲突时忽略）。
// 供插件注册任务时调用，确保 sys_job_results 的外键约束 (job_id -> sys_jobs.id) 得到满足。
//
// 行为：使用 OnConflict{DoNothing}（MySQL 为 INSERT IGNORE）：
//   - 首次启动：插入新记录
//   - 重启(记录已存在)：跳过，不覆盖用户在后台对任务的修改
//
// 参数 job 应为已通过 AddOrUpdateJob 注册到调度器的任务（validateJob 会就地设置
// ParallelNum/Timeout/RetryInterval 等默认值，故此时读取字段即为最终配置）。
//
// 返回持久化错误；调用方可选择仅记录日志、不阻断启动（任务已在内存 cron 中运行，
// 仅 sys_job_results 历史无法落库）。
func PersistJobToDB(job *schedulerhelper.Job) error {
	ctx := context.Background()

	parametersJSON := "{}"
	if len(job.Parameters) > 0 {
		if b, err := json.Marshal(job.Parameters); err == nil {
			parametersJSON = string(b)
		}
	}

	now := time.Now()
	sysJob := &models.SysJobs{
		Id:              job.ID,
		Group:           job.Group,
		Name:            job.Name,
		Description:     job.Description,
		ExecutorName:    job.ExecutorName,
		ExecutionPolicy: int(job.ExecutionPolicy),
		Status:          int(job.Status),
		CronExpression:  job.CronExpression,
		Parameters:      parametersJSON,
		BlockingPolicy:  int(job.BlockingPolicy),
		Timeout:         job.Timeout.Nanoseconds(),
		MaxRetry:        job.MaxRetry,
		RetryInterval:   job.RetryInterval.Nanoseconds(),
		ParallelNum:     job.ParallelNum,
		CreatedAt:       &now,
		UpdatedAt:       &now,
	}

	return app.DB().WithContext(ctx).
		Clauses(clause.OnConflict{DoNothing: true}).
		Create(sysJob).Error
}
