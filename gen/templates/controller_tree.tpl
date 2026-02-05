package controllers

import (
    "gin-fast/app/controllers"
	"gin-fast/plugins/{{.DirName}}/models"
	"gin-fast/plugins/{{.DirName}}/service"
	"github.com/gin-gonic/gin"
)

// {{.StructName}}Controller {{.TableName}}控制器
type {{.StructName}}Controller struct {
	controllers.Common
	{{.StructName}}Service *service.{{.StructName}}Service
}

// New{{.StructName}}Controller 创建{{.TableName}}控制器
func New{{.StructName}}Controller() *{{.StructName}}Controller {
	return &{{.StructName}}Controller{
		{{.StructName}}Service: service.New{{.StructName}}Service(),
	}
}

// Create 创建{{.TableName}}
func (c *{{.StructName}}Controller) Create(ctx *gin.Context) {
	var req models.{{.StructName}}CreateRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	{{.StructNameLower}}, err := c.{{.StructName}}Service.Create(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "创建{{.TableName}}失败", err)
	}

	c.Success(ctx, gin.H{
		"id": {{.StructNameLower}}.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}},
	})
}

// Update 更新{{.TableName}}
func (c *{{.StructName}}Controller) Update(ctx *gin.Context) {
	var req models.{{.StructName}}UpdateRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.{{.StructName}}Service.Update(ctx, req)
	if err != nil {
		c.FailAndAbort(ctx, "更新{{.TableName}}失败", err)
	}

	c.SuccessWithMessage(ctx, "更新成功")
}

// Delete 删除{{.TableName}}
func (c *{{.StructName}}Controller) Delete(ctx *gin.Context) {
	var req models.{{.StructName}}DeleteRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	err := c.{{.StructName}}Service.Delete(ctx, req.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}})
	if err != nil {
		c.FailAndAbort(ctx, "删除{{.TableName}}失败", err)
	}

	c.SuccessWithMessage(ctx, "删除成功", nil)
}

// GetByID 根据ID获取{{.TableName}}信息
func (c *{{.StructName}}Controller) GetByID(ctx *gin.Context) {
	var req models.{{.StructName}}GetByIDRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	{{.StructNameLower}}, err := c.{{.StructName}}Service.GetByID(ctx, req.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}})
	if err != nil {
		c.FailAndAbort(ctx, "{{.TableName}}不存在", err)
	}

	c.Success(ctx, {{.StructNameLower}})
}

// GetTreeList 获取{{.TableName}}树形列表
func (c *{{.StructName}}Controller) GetTreeList(ctx *gin.Context) {
	{{.StructNameLower}}List, err := c.{{.StructName}}Service.GetTreeList(ctx)
	if err != nil {
		c.FailAndAbort(ctx, "获取{{.TableName}}树形列表失败", err)
	}

	c.Success(ctx, gin.H{
		"list": {{.StructNameLower}}List,
	})
}
