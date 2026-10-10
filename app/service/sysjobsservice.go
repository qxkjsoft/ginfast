package service

import (
	"errors"
	"time"

	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/schedulerhelper"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// SysJobsService sys_jobs服务
type SysJobsService struct{}

// NewSysJobsService 创建sys_jobs服务
func NewSysJobsService() *SysJobsService {
	return &SysJobsService{}
}

// ErrSysJobsNotFound 任务不存在的哨兵错误。
// gormhelper.MaskNotDataError 全局屏蔽了 ErrRecordNotFound：查无数据时 err 为 nil、记录为零值，须按 IsEmpty 判定。
var ErrSysJobsNotFound = errors.New("任务不存在")

// Create 创建sys_jobs
func (s *SysJobsService) Create(c *gin.Context, req models.SysJobsCreateRequest) (*models.SysJobs, error) {
	// 验证Cron表达式
	if err := schedulerhelper.ValidateCronExpression(req.CronExpression); err != nil {
		return nil, errors.New("Cron表达式格式错误: " + err.Error())
	}

	// 解析任务参数JSON字符串
	parameters, err := models.ParseJobParameters(req.Parameters)
	if err != nil {
		return nil, err
	}

	// 先入库生成记录（DB 为事实源），提前生成 jobID
	jobID := schedulerhelper.GenerateJobID()
	sysJobs := models.NewSysJobs()
	sysJobs.Id = jobID
	sysJobs.Group = req.Group
	sysJobs.Name = req.Name
	sysJobs.Description = req.Description
	sysJobs.ExecutorName = req.ExecutorName
	sysJobs.ExecutionPolicy = req.ExecutionPolicy
	sysJobs.Status = req.Status
	sysJobs.CronExpression = req.CronExpression
	sysJobs.Parameters = models.NormalizeJobParameters(req.Parameters)
	sysJobs.BlockingPolicy = req.BlockingPolicy
	sysJobs.Timeout = req.Timeout
	sysJobs.MaxRetry = req.MaxRetry
	sysJobs.RetryInterval = req.RetryInterval
	sysJobs.ParallelNum = req.ParallelNum
	if err := sysJobs.Create(c); err != nil {
		return nil, err
	}

	// 再注册到调度器；失败则回滚刚插入的记录，避免幽灵任务（调度器运行未持久化任务）
	job := &schedulerhelper.Job{
		ID:              jobID,
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
	if _, err := app.JobScheduler.AddOrUpdateJob(job); err != nil {
		if delErr := sysJobs.Delete(c); delErr != nil {
			// 回滚失败仅记录，不掩盖原始错误（重启后 LoadJobsFromDB 不加载已删记录，自然对齐）
			app.ZapLog.Error("创建任务后调度器注册失败，回滚数据库记录失败",
				zap.String("jobID", jobID), zap.Error(delErr))
		}
		return nil, errors.New("添加任务到调度器失败: " + err.Error())
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
	parameters, err := models.ParseJobParameters(req.Parameters)
	if err != nil {
		return err
	}

	// 先更新数据库（DB 为事实源）
	sysJobs := models.NewSysJobs()
	if err := sysJobs.GetByID(c, req.Id); err != nil {
		return err
	}
	// 查无数据时 Save 会以空主键转 INSERT 产生脏数据，须先判 IsEmpty
	if sysJobs.IsEmpty() {
		return ErrSysJobsNotFound
	}
	// 更新sys_jobs信息
	sysJobs.Group = req.Group
	sysJobs.Name = req.Name
	sysJobs.Description = req.Description
	sysJobs.ExecutorName = req.ExecutorName
	sysJobs.ExecutionPolicy = req.ExecutionPolicy
	sysJobs.Status = req.Status
	sysJobs.CronExpression = req.CronExpression
	sysJobs.Parameters = models.NormalizeJobParameters(req.Parameters)
	sysJobs.BlockingPolicy = req.BlockingPolicy
	sysJobs.Timeout = req.Timeout
	sysJobs.MaxRetry = req.MaxRetry
	sysJobs.RetryInterval = req.RetryInterval
	sysJobs.ParallelNum = req.ParallelNum
	if err := sysJobs.Update(c); err != nil {
		return err
	}

	// 再同步调度器；失败时库已是最新值，重启后 LoadJobsFromDB 会自动对齐
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
	if _, err := app.JobScheduler.AddOrUpdateJob(job); err != nil {
		return errors.New("更新调度器任务失败（数据库已更新，重启服务后自动对齐）: " + err.Error())
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
	if sysJobs.IsEmpty() {
		return ErrSysJobsNotFound
	}

	// 先删数据库记录（DB 为事实源；若先删调度器、库删除失败，任务会在重启后被 LoadJobsFromDB 复活）
	if err := sysJobs.Delete(c); err != nil {
		return err
	}

	// 再从调度器移除；任务不在内存（如禁用任务重启后未加载）时跳过
	if app.JobScheduler.JobExists(id) {
		if err := app.JobScheduler.DeleteJob(id); err != nil {
			return errors.New("数据库记录已删除，但从调度器移除任务失败（重启后自动生效）: " + err.Error())
		}
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
	if sysJobs.IsEmpty() {
		return nil, ErrSysJobsNotFound
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
	if sysJobs.IsEmpty() {
		return ErrSysJobsNotFound
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
	if sysJobs.IsEmpty() {
		return ErrSysJobsNotFound
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
