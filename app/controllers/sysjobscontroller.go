package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/service"

	"github.com/gin-gonic/gin"
)

// SysJobsController sys_jobs控制器
type SysJobsController struct {
	Common
	SysJobsService *service.SysJobsService
}

// NewSysJobsController 创建sys_jobs控制器
func NewSysJobsController() *SysJobsController {
	return &SysJobsController{
		SysJobsService: service.NewSysJobsService(),
	}
}

// Create 创建sys_jobs
func (c *SysJobsController) Create(ctx *gin.Context) {
	var req models.SysJobsCreateRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	sysJobs, err := c.SysJobsService.Create(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "创建sys_jobs失败", err)
	}

	c.Success(ctx, gin.H{
		"id": sysJobs.Id,
	})
}

// Update 更新sys_jobs
func (c *SysJobsController) Update(ctx *gin.Context) {
	var req models.SysJobsUpdateRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.SysJobsService.Update(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "更新sys_jobs失败", err)
	}

	c.SuccessWithMessage(ctx, "更新成功")
}

// Delete 删除sys_jobs
func (c *SysJobsController) Delete(ctx *gin.Context) {
	var req models.SysJobsDeleteRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.SysJobsService.Delete(ctx, req.Id)
	if err != nil {
		c.FailAndAbort(ctx, "删除sys_jobs失败", err)
	}

	c.SuccessWithMessage(ctx, "删除成功", nil)
}

// GetByID 根据ID获取sys_jobs信息
func (c *SysJobsController) GetByID(ctx *gin.Context) {
	var req models.SysJobsGetByIDRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	sysJobs, err := c.SysJobsService.GetByID(ctx, req.Id)
	if err != nil {
		c.FailAndAbort(ctx, "sys_jobs不存在", err)
	}

	c.Success(ctx, sysJobs)
}

// List sys_jobs列表（分页查询）
func (c *SysJobsController) List(ctx *gin.Context) {
	var req models.SysJobsListRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	sysJobsList, total, err := c.SysJobsService.List(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "获取sys_jobs列表失败", err)
	}

	c.Success(ctx, gin.H{
		"list":  sysJobsList,
		"total": total,
	})
}

// ListExecutors 获取所有已注册的执行器列表
func (c *SysJobsController) ListExecutors(ctx *gin.Context) {
	executors := app.JobScheduler.ListExecutors()

	// 提取执行器名称列表
	executorNames := make([]string, 0, len(executors))
	for _, executor := range executors {
		executorNames = append(executorNames, executor.Name())
	}

	c.Success(ctx, gin.H{
		"list": executorNames,
	})
}

// SetStatus 设置任务状态
func (c *SysJobsController) SetStatus(ctx *gin.Context) {
	var req models.SysJobsSetStatusRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.SysJobsService.SetStatus(ctx, req.Id, req.Status)
	if err != nil {
		c.FailAndAbort(ctx, "设置任务状态失败", err)
	}

	c.SuccessWithMessage(ctx, "设置成功")
}

// ExecuteNow 立即执行任务
func (c *SysJobsController) ExecuteNow(ctx *gin.Context) {
	var req models.SysJobsExecuteNowRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.SysJobsService.ExecuteNow(ctx, req.Id)
	if err != nil {
		c.FailAndAbort(ctx, "立即执行任务失败", err)
	}

	c.SuccessWithMessage(ctx, "任务已提交执行")
}
