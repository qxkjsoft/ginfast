package models

import (
	"context"
{{- if .HasTimeField}}
	"time"
{{- end}}
	"gin-fast/app/global/app"
	"gorm.io/gorm"
)

// {{.StructName}} {{.TableName}} 模型结构体
type {{.StructName}} struct {
{{- range .Columns}}
	{{- if eq .FieldName "DeletedAt"}}
	{{.FieldName}} gorm.DeletedAt `gorm:"{{.GormTag}}" json:"{{.JsonTag}}"`{{if .Comment}} // {{.Comment}}{{end}}
	{{- else if eq .GoType "time.Time"}}
	{{.FieldName}} *{{.GoType}} `gorm:"{{.GormTag}}" json:"{{.JsonTag}}"`{{if .Comment}} // {{.Comment}}{{end}}
	{{- else}}
	{{.FieldName}} {{.GoType}} `gorm:"{{.GormTag}}" json:"{{.JsonTag}}"`{{if .Comment}} // {{.Comment}}{{end}}
	{{- end}}
{{- end}}
}

// {{.StructName}}List {{.TableName}} 列表
type {{.StructName}}List []{{.StructName}}

// New{{.StructName}} 创建{{.TableName}}实例
func New{{.StructName}}() *{{.StructName}} {
	return &{{.StructName}}{}
}

// New{{.StructName}}List 创建{{.TableName}}列表实例
func New{{.StructName}}List() *{{.StructName}}List {
	return &{{.StructName}}List{}
}

// TableName 指定表名
func ({{.StructName}}) TableName() string {
	return "{{.TableName}}"
}

// GetByID 根据ID获取{{.TableName}}
func (m *{{.StructName}}) GetByID(c context.Context, id {{if .PrimaryKey}}{{.PrimaryKey.GoType}}{{else}}int{{end}}) error {
	return app.DB().WithContext(c).First(m, id).Error
}

// Create 创建{{.TableName}}记录
func (m *{{.StructName}}) Create(c context.Context) error {
	return app.DB().WithContext(c).Create(m).Error
}

// Update 更新{{.TableName}}记录
func (m *{{.StructName}}) Update(c context.Context) error {
	return app.DB().WithContext(c).Save(m).Error
}

// Delete 软删除{{.TableName}}记录
func (m *{{.StructName}}) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(m).Error
}

// IsEmpty 检查模型是否为空
func (m *{{.StructName}}) IsEmpty() bool {
	return m == nil || {{if .PrimaryKey}}m.{{.PrimaryKey.FieldName}} == {{if eq .PrimaryKey.GoType "string"}}""{{else if eq .PrimaryKey.GoType "bool"}}false{{else}}0{{end}}{{else}}m.Id == 0{{end}}
}

// Find 查询{{.TableName}}列表
func (l *{{.StructName}}List) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(c).Model(&{{.StructName}}{}).Scopes(funcs...).Find(l).Error
}

// GetTotal 获取{{.TableName}}总数
func (l *{{.StructName}}List) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(c).Model(&{{.StructName}}{}).Scopes(query...).Count(&count).Error
	return count, err
}