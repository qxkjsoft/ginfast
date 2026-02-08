package service

import (
	"gin-fast/plugins/{{.DirName}}/models"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
{{- if or .HasCreatedBy .HasTenantID}}
	"gin-fast/app/utils/datascope"
{{- end}}
{{- if .HasTenantID}}
	"gin-fast/app/utils/tenanthelper"
{{- end}}
)

// {{.StructName}}Service {{.TableName}}服务
type {{.StructName}}Service struct{}

// New{{.StructName}}Service 创建{{.TableName}}服务
func New{{.StructName}}Service() *{{.StructName}}Service {
	return &{{.StructName}}Service{}
}

// Create 创建{{.TableName}}
func (s *{{.StructName}}Service) Create(c *gin.Context, req models.{{.StructName}}CreateRequest) (*models.{{.StructName}}, error) {
	// 创建{{.TableName}}记录
	{{.StructNameLower}} := models.New{{.StructName}}()
{{- range .Columns}}
{{- if and (not .Exclude) .FormShow}}
	{{$.StructNameLower}}.{{.FieldName}} = req.{{.FieldName}}
{{- end}}
{{- end}}
	// 保存到数据库
	if err := {{.StructNameLower}}.Create(c); err != nil {
		return nil, err
	}

	return {{.StructNameLower}}, nil
}

// Update 更新{{.TableName}}
func (s *{{.StructName}}Service) Update(c *gin.Context, req models.{{.StructName}}UpdateRequest) error {
	// 查找{{.TableName}}记录
	{{.StructNameLower}} := models.New{{.StructName}}()
	if err := {{.StructNameLower}}.GetByID(c, req.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}}); err != nil {
		return err
	}
	// 更新{{.TableName}}信息
{{- range .Columns}}
{{- if and (not .Exclude) (not .IsPrimary) .FormShow}}
	{{$.StructNameLower}}.{{.FieldName}} = req.{{.FieldName}}
{{- end}}
{{- end}}
	// 保存到数据库
	if err := {{.StructNameLower}}.Update(c); err != nil {
		return err
	}
	return nil
}

// Delete 删除{{.TableName}}
func (s *{{.StructName}}Service) Delete(c *gin.Context, id {{if .PrimaryKey}}{{.PrimaryKey.GoType}}{{else}}int{{end}}) error {
	// 查找{{.TableName}}记录
	{{.StructNameLower}} := models.New{{.StructName}}()
	if err := {{.StructNameLower}}.GetByID(c, id); err != nil {
		return err
	}

	// 删除数据库记录
	if err := {{.StructNameLower}}.Delete(c); err != nil {
		return err
	}

	return nil
}

// GetByID 根据ID获取{{.TableName}}
func (s *{{.StructName}}Service) GetByID(c *gin.Context, id {{if .PrimaryKey}}{{.PrimaryKey.GoType}}{{else}}int{{end}}) (*models.{{.StructName}}, error) {
	// 查找{{.TableName}}记录
	{{.StructNameLower}} := models.New{{.StructName}}()
	if err := {{.StructNameLower}}.GetByID(c, id); err != nil {
		return nil, err
	}

	return {{.StructNameLower}}, nil
}

// GetTreeList 获取{{.TableName}}树形列表
func (s *{{.StructName}}Service) GetTreeList(c *gin.Context) (models.{{.StructName}}List, error) {
	{{.StructNameLower}}List := models.New{{.StructName}}List()
	scopes := []func(*gorm.DB) *gorm.DB{}
{{- if .HasCreatedBy}}
	scopes = append(scopes, datascope.GetDataScope(c))
{{- end}}
{{- if .HasTenantID}}
	scopes = append(scopes, tenanthelper.TenantScope(c))
{{- end}}
	err := {{.StructNameLower}}List.Find(c, scopes...)
	if err != nil {
		return nil, err
	}

	if !{{.StructNameLower}}List.IsEmpty() {
		{{.StructNameLower}}List = {{.StructNameLower}}List.BuildTree().TreeSort()
	}

	return {{.StructNameLower}}List, nil
}
