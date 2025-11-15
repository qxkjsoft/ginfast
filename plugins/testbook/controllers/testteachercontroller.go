package controllers

import (
	"gin-fast/app/controllers"
	"gin-fast/plugins/testbook/models"
	"gin-fast/plugins/testbook/service"

	"github.com/gin-gonic/gin"
)

// TestTeacherController demo_teacher控制器
type TestTeacherController struct {
	controllers.Common
	TestTeacherService *service.TestTeacherService
}

// NewTestTeacherController 创建demo_teacher控制器
func NewTestTeacherController() *TestTeacherController {
	return &TestTeacherController{
		TestTeacherService: service.NewTestTeacherService(),
	}
}

// Create 创建demo_teacher
func (c *TestTeacherController) Create(ctx *gin.Context) {
	var req models.TestTeacherCreateRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}
	
	testTeacher, err := c.TestTeacherService.Create(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "创建demo_teacher失败", err)
	}

	c.Success(ctx, gin.H{
		"tcId": testTeacher.TcId,
	})
}

// Update 更新demo_teacher
func (c *TestTeacherController) Update(ctx *gin.Context) {
	var req models.TestTeacherUpdateRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.TestTeacherService.Update(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "更新demo_teacher失败", err)
	}

	c.SuccessWithMessage(ctx, "更新成功")
}

// Delete 删除demo_teacher
func (c *TestTeacherController) Delete(ctx *gin.Context) {
	var req models.TestTeacherDeleteRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.TestTeacherService.Delete(ctx, req.TcId)
	if err != nil {
		c.FailAndAbort(ctx, "删除demo_teacher失败", err)
	}

	c.SuccessWithMessage(ctx, "删除成功", nil)
}

// GetByID 根据ID获取demo_teacher信息
func (c *TestTeacherController) GetByID(ctx *gin.Context) {
	var req models.TestTeacherGetByIDRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	testTeacher, err := c.TestTeacherService.GetByID(ctx, req.TcId)
	if err != nil {
		c.FailAndAbort(ctx, "demo_teacher不存在", err)
	}

	c.Success(ctx, testTeacher)
}

// List demo_teacher列表（分页查询）
func (c *TestTeacherController) List(ctx *gin.Context) {
	var req models.TestTeacherListRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	testTeacherList, total, err := c.TestTeacherService.List(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "获取demo_teacher列表失败", err)
	}

	c.Success(ctx, gin.H{
		"list":  testTeacherList,
		"total": total,
	})
}