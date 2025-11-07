package models

import (
	"time"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// ListRequest {{.TableName}}列表请求参数
type ListRequest struct {
	models.BasePaging
	models.Validator
{{- range .Columns}}
	{{.FieldName}} *{{.GoType}} `form:"{{.JsonTag}}"`{{if .Comment}} // {{.Comment}}{{end}}
{{- end}}
}

// Validate 验证请求参数
func (r *ListRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// Handle 获取查询条件
func (r *ListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
{{- range .Columns}}
		if r.{{.FieldName}} != nil {
			db = db.Where("{{.JsonTag}} = ?", *r.{{.FieldName}})
		}
{{- end}}
		return db
	}
}

// CreateRequest 创建{{.TableName}}请求参数
type CreateRequest struct {
	models.Validator
{{- range .Columns}}
    {{- if not .Exclude}}
	{{.FieldName}} {{.GoType}} `form:"{{.JsonTag}}" validate:"required" message:"{{.Comment}}不能为空"`{{if .Comment}} // {{.Comment}}{{end}}
    {{- end}}
{{- end}}
}

// Validate 验证请求参数
func (r *CreateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// UpdateRequest 更新{{.TableName}}请求参数
type UpdateRequest struct {
	models.Validator
{{- if .PrimaryKey}}
	{{.PrimaryKey.FieldName}} {{.PrimaryKey.GoType}} `form:"{{.PrimaryKey.JsonTag}}" validate:"required" message:"{{.PrimaryKey.Comment}}不能为空"`{{if .PrimaryKey.Comment}} // {{.PrimaryKey.Comment}}{{end}}
{{- end}}
{{- range .Columns}}
    {{- if and (not .Exclude) (not .IsPrimary)}}
	{{.FieldName}} {{.GoType}} `form:"{{.JsonTag}}" validate:"required" message:"{{.Comment}}不能为空"`{{if .Comment}} // {{.Comment}}{{end}}
    {{- end}}
{{- end}}
}

// Validate 验证请求参数
func (r *UpdateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// DeleteRequest 删除{{.TableName}}请求参数
type DeleteRequest struct {
	models.Validator
	{{if .PrimaryKey}}{{.PrimaryKey.FieldName}} {{.PrimaryKey.GoType}} `form:"{{.PrimaryKey.JsonTag}}" validate:"required" message:"{{.PrimaryKey.Comment}}不能为空"`{{if .PrimaryKey.Comment}} // {{.PrimaryKey.Comment}}{{end}}{{else}}ID int `form:"id" validate:"required" message:"ID不能为空"` // ID{{end}}
}

// Validate 验证请求参数
func (r *DeleteRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// GetByIDRequest 根据ID获取{{.TableName}}请求参数
type GetByIDRequest struct {
	models.Validator
	{{if .PrimaryKey}}{{.PrimaryKey.FieldName}} {{.PrimaryKey.GoType}} `uri:"{{.PrimaryKey.JsonTag}}" validate:"required" message:"{{.PrimaryKey.Comment}}不能为空"`{{if .PrimaryKey.Comment}} // {{.PrimaryKey.Comment}}{{end}}{{else}}ID int `uri:"id" validate:"required" message:"ID不能为空"` // ID{{end}}
}

// Validate 验证请求参数
func (r *GetByIDRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}