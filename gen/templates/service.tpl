package service

import (
	"gin-fast/plugins/{{.DirName}}/models"
	"github.com/gin-gonic/gin"
)

// {{.StructName}}Service {{.TableName}}服务
type {{.StructName}}Service struct{}

// New{{.StructName}}Service 创建{{.TableName}}服务
func New{{.StructName}}Service() *{{.StructName}}Service {
	return &{{.StructName}}Service{}
}

// Create 创建{{.TableName}}
func (s *{{.StructName}}Service) Create(c *gin.Context, req models.CreateRequest) (*models.{{.StructName}}, error) {
	// 创建{{.TableName}}记录
	{{.StructNameLower}} := models.New{{.StructName}}()
    {{- range .Columns}}
    {{- if not .Exclude}}
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
func (s *{{.StructName}}Service) Update(c *gin.Context, req models.UpdateRequest) error {
	// 查找{{.TableName}}记录
	{{.StructNameLower}} := models.New{{.StructName}}()
	if err := {{.StructNameLower}}.GetByID(c, req.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}}); err != nil {
		return err
	}
	// 更新{{.TableName}}信息
    {{- range .Columns}}
    {{- if not .Exclude}}
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

// List {{.TableName}}列表（分页查询）
func (s *{{.StructName}}Service) List(c *gin.Context, req models.ListRequest) (*models.{{.StructName}}List, int64, error) {
	// 获取总数
	{{.StructNameLower}}List := models.New{{.StructName}}List()
	total, err := {{.StructNameLower}}List.GetTotal(c, req.Handle())
	if err != nil {
		return nil, 0, err
	}

	// 获取分页数据
	err = {{.StructNameLower}}List.Find(c,req.Paginate(),req.Handle())
	if err != nil {
		return nil, 0, err
	}

	return {{.StructNameLower}}List, total, nil
}