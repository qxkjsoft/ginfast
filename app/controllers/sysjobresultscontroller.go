package controllers

import (
	"gin-fast/app/models"
	"gin-fast/app/service"

	"github.com/gin-gonic/gin"
)

// SysJobResultsController sys_job_results控制器
type SysJobResultsController struct {
	Common
	SysJobResultsService *service.SysJobResultsService
}

// NewSysJobResultsController 创建sys_job_results控制器
func NewSysJobResultsController() *SysJobResultsController {
	return &SysJobResultsController{
		SysJobResultsService: service.NewSysJobResultsService(),
	}
}

// Delete 删除sys_job_results
func (c *SysJobResultsController) Delete(ctx *gin.Context) {
	var req models.SysJobResultsDeleteRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.SysJobResultsService.Delete(ctx, req.Id)
	if err != nil {
		c.FailAndAbort(ctx, "删除sys_job_results失败", err)
	}

	c.SuccessWithMessage(ctx, "删除成功", nil)
}

// GetByID 根据ID获取sys_job_results信息
func (c *SysJobResultsController) GetByID(ctx *gin.Context) {
	var req models.SysJobResultsGetByIDRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	sysJobResults, err := c.SysJobResultsService.GetByID(ctx, req.Id)
	if err != nil {
		c.FailAndAbort(ctx, "sys_job_results不存在", err)
	}

	c.Success(ctx, sysJobResults)
}

// List sys_job_results列表（分页查询）
func (c *SysJobResultsController) List(ctx *gin.Context) {
	var req models.SysJobResultsListRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	sysJobResultsList, total, err := c.SysJobResultsService.List(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "获取sys_job_results列表失败", err)
	}

	c.Success(ctx, gin.H{
		"list":  sysJobResultsList,
		"total": total,
	})
}
