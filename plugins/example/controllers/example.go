package controllers

import (
	"gin-fast/app/controllers"
	"gin-fast/app/utils/common"
	"gin-fast/plugins/example/models"
	"strconv"

	"github.com/gin-gonic/gin"
)

// ExampleController 示例控制器
type ExampleController struct {
	controllers.Common
}

// Create 创建示例
func (ec *ExampleController) Create(c *gin.Context) {
	var req models.CreateRequest
	if err := req.Validate(c); err != nil {
		ec.FailAndAbort(c, err.Error(), err)
	}

	// 创建示例记录
	example := models.NewExample()
	example.Name = req.Name
	example.Description = req.Description
	example.CreatedBy = common.GetCurrentUserID(c)

	// 保存到数据库
	if err := example.Create(); err != nil {
		ec.FailAndAbort(c, "创建示例失败", err)
	}

	// 返回成功响应
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

	// 查找示例记录
	example := models.NewExample()
	if err := example.GetByID(req.ID); err != nil {
		ec.FailAndAbort(c, "示例不存在", err)
	}

	// 更新示例信息
	example.Name = req.Name
	example.Description = req.Description
	if err := example.Update(); err != nil {
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

	// 查找示例记录
	example := models.NewExample()
	if err := example.GetByID(req.ID); err != nil {
		ec.FailAndAbort(c, "示例不存在", err)
	}

	// 删除数据库记录
	if err := example.Delete(); err != nil {
		ec.FailAndAbort(c, "删除示例失败", err)
	}

	// 返回成功响应
	ec.SuccessWithMessage(c, "删除成功", nil)
}

// GetByID 根据ID获取示例信息
func (ec *ExampleController) GetByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		ec.FailAndAbort(c, "无效的示例ID", err)
	}

	// 查找示例记录
	example := models.NewExample()
	if err := example.GetByID(uint(id)); err != nil {
		ec.FailAndAbort(c, "示例不存在", err)
	}

	// 返回成功响应
	ec.Success(c, gin.H{
		"id":          example.ID,
		"name":        example.Name,
		"description": example.Description,
		"createdAt":   example.CreatedAt,
		"updatedAt":   example.UpdatedAt,
	})
}

// List 示例列表（分页查询）
func (ec *ExampleController) List(c *gin.Context) {
	var req models.ListRequest
	if err := req.Validate(c); err != nil {
		ec.FailAndAbort(c, err.Error(), err)
	}

	// 获取查询条件
	query := req.Handle()

	// 获取总数
	exampleList := models.NewExampleList()
	total, err := exampleList.GetTotal(query)
	if err != nil {
		ec.FailAndAbort(c, "获取示例总数失败", err)
	}

	// 获取分页数据
	err = exampleList.Find(req.Paginate(), query)
	if err != nil {
		ec.FailAndAbort(c, "获取示例列表失败", err)
	}

	// 返回成功响应
	ec.Success(c, gin.H{
		"list":  exampleList,
		"total": total,
	})
}
