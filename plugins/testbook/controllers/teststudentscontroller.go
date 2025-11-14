package controllers

import (
	"gin-fast/app/controllers"
	"gin-fast/plugins/testbook/models"
	"gin-fast/plugins/testbook/service"

	"github.com/gin-gonic/gin"
)

// TestStudentsController demo_students控制器
type TestStudentsController struct {
	controllers.Common
	TestStudentsService *service.TestStudentsService
}

// NewTestStudentsController 创建demo_students控制器
func NewTestStudentsController() *TestStudentsController {
	return &TestStudentsController{
		TestStudentsService: service.NewTestStudentsService(),
	}
}

// Create 创建demo_students
func (c *TestStudentsController) Create(ctx *gin.Context) {
	var req models.TestStudentsCreateRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}
	
	testStudents, err := c.TestStudentsService.Create(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "创建demo_students失败", err)
	}

	c.Success(ctx, gin.H{
		"stuId": testStudents.StuId,
	})
}

// Update 更新demo_students
func (c *TestStudentsController) Update(ctx *gin.Context) {
	var req models.TestStudentsUpdateRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.TestStudentsService.Update(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "更新demo_students失败", err)
	}

	c.SuccessWithMessage(ctx, "更新成功")
}

// Delete 删除demo_students
func (c *TestStudentsController) Delete(ctx *gin.Context) {
	var req models.TestStudentsDeleteRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.TestStudentsService.Delete(ctx, req.StuId)
	if err != nil {
		c.FailAndAbort(ctx, "删除demo_students失败", err)
	}

	c.SuccessWithMessage(ctx, "删除成功", nil)
}

// GetByID 根据ID获取demo_students信息
func (c *TestStudentsController) GetByID(ctx *gin.Context) {
	var req models.TestStudentsGetByIDRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	testStudents, err := c.TestStudentsService.GetByID(ctx, req.StuId)
	if err != nil {
		c.FailAndAbort(ctx, "demo_students不存在", err)
	}

	c.Success(ctx, testStudents)
}

// List demo_students列表（分页查询）
func (c *TestStudentsController) List(ctx *gin.Context) {
	var req models.TestStudentsListRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	testStudentsList, total, err := c.TestStudentsService.List(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "获取demo_students列表失败", err)
	}

	c.Success(ctx, gin.H{
		"list":  testStudentsList,
		"total": total,
	})
}