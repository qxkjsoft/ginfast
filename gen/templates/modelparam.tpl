package models

import (
{{- if .HasTimeField}}
	"time"
{{- end}}
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// {{.StructName}}ListRequest {{.TableName}}列表请求参数
type {{.StructName}}ListRequest struct {
	models.BasePaging
	models.Validator
{{- range .Columns}}
	{{- if .QueryShow}}
	{{- if and (eq .QueryType "BETWEEN") (eq .GoType "time.Time")}}
	{{.FieldName}} []{{.GoType}} `form:"{{.JsonTag}}"`{{if .Comment}} // {{.Comment}}范围（仅日期类型支持）{{end}}
	{{- else}}
	{{.FieldName}} *{{.GoType}} `form:"{{.JsonTag}}"`{{if .Comment}} // {{.Comment}}{{end}}
	{{- end}}
	{{- end}}
{{- end}}
}

// Validate 验证请求参数
func (r *{{.StructName}}ListRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// Handle 获取查询条件
func (r *{{.StructName}}ListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
{{- range .Columns}}
		{{- if .QueryShow}}
            {{- if and (eq .QueryType "BETWEEN") (eq .GoType "time.Time")}}
        if len(r.{{.FieldName}}) >= 2 {
            db = db.Where("{{.DataName}} BETWEEN ? AND ?", r.{{.FieldName}}[0], r.{{.FieldName}}[1])
        }
            {{- else if eq .QueryType "BETWEEN"}}
        // 非日期类型不支持BETWEEN查询，使用精确查询
        if r.{{.FieldName}} != nil {
            db = db.Where("{{.DataName}} = ?", *r.{{.FieldName}})
        }
            {{- else}}
        if r.{{.FieldName}} != nil {
            {{- if eq .QueryType "EQ"}}
            db = db.Where("{{.DataName}} = ?", *r.{{.FieldName}})
            {{- else if eq .QueryType "NE"}}
            db = db.Where("{{.DataName}} != ?", *r.{{.FieldName}})
            {{- else if and (eq .QueryType "LIKE") (ne .FrontendType "number")}}
            db = db.Where("{{.DataName}} LIKE ?", "%" + *r.{{.FieldName}} + "%")
            {{- else if and (eq .QueryType "LIKE") (eq .FrontendType "number")}}
            // 数值类型不支持LIKE查询，使用精确查询
            db = db.Where("{{.DataName}} = ?", *r.{{.FieldName}})
            {{- else if eq .QueryType "GT"}}
            db = db.Where("{{.DataName}} > ?", *r.{{.FieldName}})
            {{- else if eq .QueryType "GTE"}}
            db = db.Where("{{.DataName}} >= ?", *r.{{.FieldName}})
            {{- else if eq .QueryType "LT"}}
            db = db.Where("{{.DataName}} < ?", *r.{{.FieldName}})
            {{- else if eq .QueryType "LTE"}}
            db = db.Where("{{.DataName}} <= ?", *r.{{.FieldName}})
            {{- else}}
            // 默认等于查询
            db = db.Where("{{.DataName}} = ?", *r.{{.FieldName}})
            {{- end}}
        }
            {{- end}}
		{{- end}}
{{- end}}
		return db
	}
}

// {{.StructName}}CreateRequest 创建{{.TableName}}请求参数
type {{.StructName}}CreateRequest struct {
	models.Validator
{{- range .Columns}}
    {{- if and (not .Exclude) (not .IsPrimary) .FormShow}}
	{{.FieldName}} {{.GoType}} `form:"{{.JsonTag}}"{{if .Required}} validate:"required" message:"{{.Comment}}不能为空"{{end}}`{{if .Comment}} // {{.Comment}}{{end}}
    {{- end}}
{{- end}}
}

// Validate 验证请求参数
func (r *{{.StructName}}CreateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// {{.StructName}}UpdateRequest 更新{{.TableName}}请求参数
type {{.StructName}}UpdateRequest struct {
	models.Validator
{{- if .PrimaryKey}}
	{{.PrimaryKey.FieldName}} {{.PrimaryKey.GoType}} `form:"{{.PrimaryKey.JsonTag}}" validate:"required" message:"{{.PrimaryKey.Comment}}不能为空"`{{if .PrimaryKey.Comment}} // {{.PrimaryKey.Comment}}{{end}}
{{- end}}
{{- range .Columns}}
    {{- if and (not .Exclude) (not .IsPrimary) .FormShow}}
	{{.FieldName}} {{.GoType}} `form:"{{.JsonTag}}"{{if .Required}} validate:"required" message:"{{.Comment}}不能为空"{{end}}`{{if .Comment}} // {{.Comment}}{{end}}
    {{- end}}
{{- end}}
}

// Validate 验证请求参数
func (r *{{.StructName}}UpdateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// {{.StructName}}DeleteRequest 删除{{.TableName}}请求参数
type {{.StructName}}DeleteRequest struct {
	models.Validator
	{{if .PrimaryKey}}{{.PrimaryKey.FieldName}} {{.PrimaryKey.GoType}} `form:"{{.PrimaryKey.JsonTag}}" validate:"required" message:"{{.PrimaryKey.Comment}}不能为空"`{{if .PrimaryKey.Comment}} // {{.PrimaryKey.Comment}}{{end}}{{else}}ID int `form:"id" validate:"required" message:"ID不能为空"` // ID{{end}}
}

// Validate 验证请求参数
func (r *{{.StructName}}DeleteRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// {{.StructName}}GetByIDRequest 根据ID获取{{.TableName}}请求参数
type {{.StructName}}GetByIDRequest struct {
	models.Validator
	{{if .PrimaryKey}}{{.PrimaryKey.FieldName}} {{.PrimaryKey.GoType}} `uri:"{{.PrimaryKey.JsonTag}}" validate:"required" message:"{{.PrimaryKey.Comment}}不能为空"`{{if .PrimaryKey.Comment}} // {{.PrimaryKey.Comment}}{{end}}{{else}}ID int `uri:"id" validate:"required" message:"ID不能为空"` // ID{{end}}
}

// Validate 验证请求参数
func (r *{{.StructName}}GetByIDRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}