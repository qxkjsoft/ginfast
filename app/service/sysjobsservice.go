package service

import (
	"encoding/json"
	"errors"
	"time"

	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/schedulerhelper"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysJobsService sys_jobs服务
type SysJobsService struct{}

// NewSysJobsService 创建sys_jobs服务
func NewSysJobsService() *SysJobsService {
	return &SysJobsService{}
}

// Create 创建sys_jobs
func (s *SysJobsService) Create(c *gin.Context, req models.SysJobsCreateRequest) (*models.SysJobs, error) {
	// 验证Cron表达式
	if err := schedulerhelper.ValidateCronExpression(req.CronExpression); err != nil {
		return nil, errors.New("Cron表达式格式错误: " + err.Error())
	}

	// 解析任务参数JSON字符串
	var parameters map[string]interface{}
	if req.Parameters != "" {
		if err := json.Unmarshal([]byte(req.Parameters), &parameters); err != nil {
			return nil, errors.New("任务参数JSON格式错误: " + err.Error())
		}
	}

	// 构建调度器Job对象
	job := &schedulerhelper.Job{
		Group:           req.Group,
		Name:            req.Name,
		Description:     req.Description,
		ExecutorName:    req.ExecutorName,
		ExecutionPolicy: schedulerhelper.ExecutionPolicy(req.ExecutionPolicy),
		Status:          schedulerhelper.JobStatus(req.Status),
		CronExpression:  req.CronExpression,
		Parameters:      parameters,
		BlockingPolicy:  schedulerhelper.BlockingPolicy(req.BlockingPolicy),
		Timeout:         time.Duration(req.Timeout),
		MaxRetry:        req.MaxRetry,
		RetryInterval:   time.Duration(req.RetryInterval),
		ParallelNum:     req.ParallelNum,
	}

	// 调用调度器AddOrUpdateJob生成jobID
	jobID, err := app.JobScheduler.AddOrUpdateJob(job)
	if err != nil {
		return nil, errors.New("添加任务到调度器失败: " + err.Error())
	}

	// 创建sys_jobs记录
	sysJobs := models.NewSysJobs()
	sysJobs.Id = jobID
	sysJobs.Group = req.Group
	sysJobs.Name = req.Name
	sysJobs.Description = req.Description
	sysJobs.ExecutorName = req.ExecutorName
	sysJobs.ExecutionPolicy = req.ExecutionPolicy
	sysJobs.Status = req.Status
	sysJobs.CronExpression = req.CronExpression
	sysJobs.Parameters = req.Parameters
	sysJobs.BlockingPolicy = req.BlockingPolicy
	sysJobs.Timeout = req.Timeout
	sysJobs.MaxRetry = req.MaxRetry
	sysJobs.RetryInterval = req.RetryInterval
	sysJobs.ParallelNum = req.ParallelNum
	// 保存到数据库
	if err := sysJobs.Create(c); err != nil {
		return nil, err
	}

	return sysJobs, nil
}

// Update 更新sys_jobs
func (s *SysJobsService) Update(c *gin.Context, req models.SysJobsUpdateRequest) error {
	// 验证Cron表达式
	if err := schedulerhelper.ValidateCronExpression(req.CronExpression); err != nil {
		return errors.New("Cron表达式格式错误: " + err.Error())
	}

	// 解析任务参数JSON字符串
	var parameters map[string]interface{}
	if req.Parameters != "" {
		if err := json.Unmarshal([]byte(req.Parameters), &parameters); err != nil {
			return errors.New("任务参数JSON格式错误: " + err.Error())
		}
	}

	// 构建调度器Job对象
	job := &schedulerhelper.Job{
		ID:              req.Id,
		Group:           req.Group,
		Name:            req.Name,
		Description:     req.Description,
		ExecutorName:    req.ExecutorName,
		ExecutionPolicy: schedulerhelper.ExecutionPolicy(req.ExecutionPolicy),
		Status:          schedulerhelper.JobStatus(req.Status),
		CronExpression:  req.CronExpression,
		Parameters:      parameters,
		BlockingPolicy:  schedulerhelper.BlockingPolicy(req.BlockingPolicy),
		Timeout:         time.Duration(req.Timeout),
		MaxRetry:        req.MaxRetry,
		RetryInterval:   time.Duration(req.RetryInterval),
		ParallelNum:     req.ParallelNum,
	}

	// 调用调度器AddOrUpdateJob更新任务
	_, err := app.JobScheduler.AddOrUpdateJob(job)
	if err != nil {
		return errors.New("更新调度器任务失败: " + err.Error())
	}

	// 查找sys_jobs记录
	sysJobs := models.NewSysJobs()
	if err := sysJobs.GetByID(c, req.Id); err != nil {
		return err
	}
	// 更新sys_jobs信息
	sysJobs.Group = req.Group
	sysJobs.Name = req.Name
	sysJobs.Description = req.Description
	sysJobs.ExecutorName = req.ExecutorName
	sysJobs.ExecutionPolicy = req.ExecutionPolicy
	sysJobs.Status = req.Status
	sysJobs.CronExpression = req.CronExpression
	sysJobs.Parameters = req.Parameters
	sysJobs.BlockingPolicy = req.BlockingPolicy
	sysJobs.Timeout = req.Timeout
	sysJobs.MaxRetry = req.MaxRetry
	sysJobs.RetryInterval = req.RetryInterval
	sysJobs.ParallelNum = req.ParallelNum
	// 保存到数据库
	if err := sysJobs.Update(c); err != nil {
		return err
	}
	return nil
}

// Delete 删除sys_jobs
func (s *SysJobsService) Delete(c *gin.Context, id string) error {
	// 查找sys_jobs记录
	sysJobs := models.NewSysJobs()
	if err := sysJobs.GetByID(c, id); err != nil {
		return err
	}

	// 从调度器中删除任务
	if err := app.JobScheduler.DeleteJob(id); err != nil {
		return errors.New("从调度器删除任务失败: " + err.Error())
	}

	// 删除数据库记录
	if err := sysJobs.Delete(c); err != nil {
		return err
	}

	return nil
}

// GetByID 根据ID获取sys_jobs
func (s *SysJobsService) GetByID(c *gin.Context, id string) (*models.SysJobs, error) {
	// 查找sys_jobs记录
	sysJobs := models.NewSysJobs()
	if err := sysJobs.GetByID(c, id); err != nil {
		return nil, err
	}

	return sysJobs, nil
}

// List sys_jobs列表（分页查询）
func (s *SysJobsService) List(c *gin.Context, req models.SysJobsListRequest) (*models.SysJobsList, int64, error) {
	// 获取总数
	sysJobsList := models.NewSysJobsList()
	scopes := []func(*gorm.DB) *gorm.DB{req.Handle()}
	total, err := sysJobsList.GetTotal(c, scopes...)
	if err != nil {
		return nil, 0, err
	}
	scopes = append(scopes, req.Paginate())
	// 获取分页数据
	err = sysJobsList.Find(c, scopes...)
	if err != nil {
		return nil, 0, err
	}

	return sysJobsList, total, nil
}

// SetStatus 设置任务状态
func (s *SysJobsService) SetStatus(c *gin.Context, id string, status int) error {
	// 查找sys_jobs记录
	sysJobs := models.NewSysJobs()
	if err := sysJobs.GetByID(c, id); err != nil {
		return err
	}

	// 检查任务是否存在于调度器中
	if !app.JobScheduler.JobExists(id) {
		// 任务不存在，需要先添加到调度器
		// 解析任务参数JSON字符串
		parameters, err := sysJobs.GetParameters()
		if err != nil {
			return err
		}

		// 构建调度器Job对象
		job := &schedulerhelper.Job{
			ID:              sysJobs.Id,
			Group:           sysJobs.Group,
			Name:            sysJobs.Name,
			Description:     sysJobs.Description,
			ExecutorName:    sysJobs.ExecutorName,
			ExecutionPolicy: schedulerhelper.ExecutionPolicy(sysJobs.ExecutionPolicy),
			Status:          schedulerhelper.JobStatus(sysJobs.Status),
			CronExpression:  sysJobs.CronExpression,
			Parameters:      parameters,
			BlockingPolicy:  schedulerhelper.BlockingPolicy(sysJobs.BlockingPolicy),
			Timeout:         time.Duration(sysJobs.Timeout),
			MaxRetry:        sysJobs.MaxRetry,
			RetryInterval:   time.Duration(sysJobs.RetryInterval),
			ParallelNum:     sysJobs.ParallelNum,
		}

		// 添加任务到调度器
		if _, err := app.JobScheduler.AddOrUpdateJob(job); err != nil {
			return errors.New("添加任务到调度器失败: " + err.Error())
		}
	}

	// 根据状态调用调度器的EnableJob或DisableJob
	if status == 1 {
		// 启用任务
		if err := app.JobScheduler.EnableJob(id); err != nil {
			return errors.New("启用调度器任务失败: " + err.Error())
		}
	} else {
		// 禁用任务
		if err := app.JobScheduler.DisableJob(id); err != nil {
			return errors.New("禁用调度器任务失败: " + err.Error())
		}
	}

	// 更新数据库状态
	sysJobs.Status = status
	if err := sysJobs.Update(c); err != nil {
		return err
	}

	return nil
}

// ExecuteNow 立即执行任务
func (s *SysJobsService) ExecuteNow(c *gin.Context, id string) error {
	// 查找sys_jobs记录
	sysJobs := models.NewSysJobs()
	if err := sysJobs.GetByID(c, id); err != nil {
		return err
	}

	// 检查任务是否存在于调度器中
	if !app.JobScheduler.JobExists(id) {
		// 任务不存在，需要先添加到调度器
		// 解析任务参数JSON字符串
		parameters, err := sysJobs.GetParameters()
		if err != nil {
			return err
		}

		// 构建调度器Job对象
		job := &schedulerhelper.Job{
			ID:              sysJobs.Id,
			Group:           sysJobs.Group,
			Name:            sysJobs.Name,
			Description:     sysJobs.Description,
			ExecutorName:    sysJobs.ExecutorName,
			ExecutionPolicy: schedulerhelper.ExecutionPolicy(sysJobs.ExecutionPolicy),
			Status:          schedulerhelper.JobStatus(sysJobs.Status),
			CronExpression:  sysJobs.CronExpression,
			Parameters:      parameters,
			BlockingPolicy:  schedulerhelper.BlockingPolicy(sysJobs.BlockingPolicy),
			Timeout:         time.Duration(sysJobs.Timeout),
			MaxRetry:        sysJobs.MaxRetry,
			RetryInterval:   time.Duration(sysJobs.RetryInterval),
			ParallelNum:     sysJobs.ParallelNum,
		}

		// 添加任务到调度器
		if _, err := app.JobScheduler.AddOrUpdateJob(job); err != nil {
			return errors.New("添加任务到调度器失败: " + err.Error())
		}
	}

	// 调用调度器ExecuteNow立即执行任务
	if err := app.JobScheduler.ExecuteNow(id); err != nil {
		return errors.New("立即执行任务失败: " + err.Error())
	}

	return nil
}
