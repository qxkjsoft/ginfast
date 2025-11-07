package controllers

import (
	"gin-fast/app/controllers"
	"gin-fast/plugins/example/models"
	"gin-fast/plugins/example/service"

	"github.com/gin-gonic/gin"
)

// ExampleController 示例控制器
type ExampleController struct {
	controllers.Common
	ExampleService *service.ExampleService
}

func NewExampleController() *ExampleController {
	return &ExampleController{
		ExampleService: service.NewExampleService(),
	}
}

// Create 创建示例
func (ec *ExampleController) Create(c *gin.Context) {
	var req models.CreateRequest
	if err := req.Validate(c); err != nil {
		ec.FailAndAbort(c, err.Error(), err)
	}
	example, err := ec.ExampleService.Create(c, req)
	if err != nil {
		ec.FailAndAbort(c, "创建示例失败", err)
	}

	ec.Success(c, gin.H{
		"id": example.ID,
	})
}

// Update 更新示例
func (ec *ExampleController) Update(c *gin.Context) {
	var req models.UpdateRequest
	if err := req.Validate(c); err != nil {
		ec.FailAndAbort(c, err.Error(), err)
	}

	err := ec.ExampleService.Update(c, req)
	if err != nil {
		ec.FailAndAbort(c, "更新示例失败", err)
	}

	// 返回成功响应
	ec.SuccessWithMessage(c, "更新成功")

}

// Delete 删除示例
func (ec *ExampleController) Delete(c *gin.Context) {
	var req models.DeleteRequest
	if err := req.Validate(c); err != nil {
		ec.FailAndAbort(c, err.Error(), err)
	}

	// 调用服务层删除示例
	err := ec.ExampleService.Delete(c, req.ID)
	if err != nil {
		ec.FailAndAbort(c, "删除示例失败", err)
	}

	// 返回成功响应
	ec.SuccessWithMessage(c, "删除成功", nil)
}

// GetByID 根据ID获取示例信息
func (ec *ExampleController) GetByID(c *gin.Context) {

	var req models.GetByIDRequest
	if err := req.Validate(c); err != nil {
		ec.FailAndAbort(c, err.Error(), err)
	}

	example, err := ec.ExampleService.GetByID(c, req.ID)
	if err != nil {
		ec.FailAndAbort(c, "示例不存在", err)
	}

	// 返回成功响应
	ec.Success(c, example)
}

// List 示例列表（分页查询）
func (ec *ExampleController) List(c *gin.Context) {
	var req models.ListRequest
	if err := req.Validate(c); err != nil {
		ec.FailAndAbort(c, err.Error(), err)
	}

	// 调用服务层获取示例列表
	exampleList, total, err := ec.ExampleService.List(c, req)
	if err != nil {
		ec.FailAndAbort(c, "获取示例列表失败", err)
	}

	// 返回成功响应
	ec.Success(c, gin.H{
		"list":  exampleList,
		"total": total,
	})
}
