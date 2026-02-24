package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysJobsListRequest sys_jobs列表请求参数
type SysJobsListRequest struct {
	BasePaging
	Validator
	Id              *string `form:"id"`              // 任务ID
	Group           *string `form:"group"`           // 任务分组名称
	Name            *string `form:"name"`            // 任务名称
	ExecutorName    *string `form:"executorName"`    // 执行器名称
	ExecutionPolicy *int    `form:"executionPolicy"` // 执行策略
	Status          *int    `form:"status"`          // 任务状态
}

// Validate 验证请求参数
func (r *SysJobsListRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// Handle 获取查询条件
func (r *SysJobsListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.Id != nil {
			// 默认等于查询
			db = db.Where("id = ?", *r.Id)
		}
		if r.Group != nil {
			// 默认等于查询
			db = db.Where("group = ?", *r.Group)
		}
		if r.Name != nil {
			db = db.Where("name LIKE ?", "%"+*r.Name+"%")
		}
		if r.ExecutorName != nil {
			db = db.Where("executor_name LIKE ?", "%"+*r.ExecutorName+"%")
		}
		if r.ExecutionPolicy != nil {
			// 默认等于查询
			db = db.Where("execution_policy = ?", *r.ExecutionPolicy)
		}
		if r.Status != nil {
			// 默认等于查询
			db = db.Where("status = ?", *r.Status)
		}
		return db
	}
}

// SysJobsCreateRequest 创建sys_jobs请求参数
type SysJobsCreateRequest struct {
	Validator
	Group           string `form:"group" validate:"required" message:"任务分组名称不能为空"`           // 任务分组名称
	Name            string `form:"name" validate:"required" message:"任务名称不能为空"`              // 任务名称
	Description     string `form:"description"`                                              // 任务描述
	ExecutorName    string `form:"executorName" validate:"required" message:"执行器名称不能为空"`     // 执行器名称
	ExecutionPolicy int    `form:"executionPolicy"`                                          // 执行策略
	Status          int    `form:"status"`                                                   // 任务状态
	CronExpression  string `form:"cronExpression" validate:"required" message:"Cron表达式不能为空"` // Cron表达式
	Parameters      string `form:"parameters"`                                               // 任务参数
	BlockingPolicy  int    `form:"blockingPolicy"`                                           // 阻塞策略
	Timeout         int64  `form:"timeout"`                                                  // 超时时间(纳秒)
	MaxRetry        int    `form:"maxRetry"`                                                 // 最大重试次数
	RetryInterval   int64  `form:"retryInterval"`                                            // 重试间隔(纳秒)
	ParallelNum     int    `form:"parallelNum"`                                              // 并行数
}

// Validate 验证请求参数
func (r *SysJobsCreateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// SysJobsUpdateRequest 更新sys_jobs请求参数
type SysJobsUpdateRequest struct {
	Validator
	Id              string `form:"id" validate:"required" message:"任务ID不能为空"`                // 任务ID
	Group           string `form:"group" validate:"required" message:"任务分组名称不能为空"`           // 任务分组名称
	Name            string `form:"name" validate:"required" message:"任务名称不能为空"`              // 任务名称
	Description     string `form:"description"`                                              // 任务描述
	ExecutorName    string `form:"executorName" validate:"required" message:"执行器名称不能为空"`     // 执行器名称
	ExecutionPolicy int    `form:"executionPolicy"`                                          // 执行策略
	Status          int    `form:"status"`                                                   // 任务状态
	CronExpression  string `form:"cronExpression" validate:"required" message:"Cron表达式不能为空"` // Cron表达式
	Parameters      string `form:"parameters"`                                               // 任务参数
	BlockingPolicy  int    `form:"blockingPolicy"`                                           // 阻塞策略
	Timeout         int64  `form:"timeout"`                                                  // 超时时间(纳秒)
	MaxRetry        int    `form:"maxRetry"`                                                 // 最大重试次数
	RetryInterval   int64  `form:"retryInterval"`                                            // 重试间隔(纳秒)
	ParallelNum     int    `form:"parallelNum"`                                              // 并行数
}

// Validate 验证请求参数
func (r *SysJobsUpdateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// SysJobsDeleteRequest 删除sys_jobs请求参数
type SysJobsDeleteRequest struct {
	Validator
	Id string `form:"id" validate:"required" message:"任务ID不能为空"` // 任务ID
}

// Validate 验证请求参数
func (r *SysJobsDeleteRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// SysJobsGetByIDRequest 根据ID获取sys_jobs请求参数
type SysJobsGetByIDRequest struct {
	Validator
	Id string `uri:"id" validate:"required" message:"任务ID不能为空"` // 任务ID
}

// Validate 验证请求参数
func (r *SysJobsGetByIDRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// SysJobsSetStatusRequest 设置状态请求参数
type SysJobsSetStatusRequest struct {
	Validator
	Id     string `form:"id" validate:"required" message:"任务ID不能为空"` // 任务ID
	Status int    `form:"status"`                                    // 任务状态(1:启用, 0:禁用)
}

// Validate 验证请求参数
func (r *SysJobsSetStatusRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// SysJobsExecuteNowRequest 立即执行任务请求参数
type SysJobsExecuteNowRequest struct {
	Validator
	Id string `form:"id" validate:"required" message:"任务ID不能为空"` // 任务ID
}

// Validate 验证请求参数
func (r *SysJobsExecuteNowRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}
