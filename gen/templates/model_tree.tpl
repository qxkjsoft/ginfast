package models

import (
	"context"
{{- if .HasTimeField}}
	"time"
{{- end}}
	"fmt"
	"gin-fast/app/global/app"
	"sort"

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
	Children {{.StructName}}List `gorm:"-" json:"children"` // 子节点
}

// {{.StructName}}List {{.TableName}} 列表
type {{.StructName}}List []*{{.StructName}}

// New{{.StructName}} 创建{{.TableName}}实例
func New{{.StructName}}() *{{.StructName}} {
	return &{{.StructName}}{}
}

// New{{.StructName}}List 创建{{.TableName}}列表实例
func New{{.StructName}}List() {{.StructName}}List {
	return {{.StructName}}List{}
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

// IsEmpty 检查列表是否为空
func (l *{{.StructName}}List) IsEmpty() bool {
	return len(*l) == 0
}

// BuildTree 构建树形结构
func (l {{.StructName}}List) BuildTree() {{.StructName}}List {
	// 哈希表存储所有节点
	nodeMap := make(map[{{if .PrimaryKey}}{{.PrimaryKey.GoType}}{{else}}int{{end}}]*{{.StructName}})
	// 存储顶层节点
	roots := {{.StructName}}List{}
	// 用于检测循环引用
	visited := make(map[{{if .PrimaryKey}}{{.PrimaryKey.GoType}}{{else}}int{{end}}]bool)

	// 第一次遍历: 注册所有节点 & 检测重复
	for i := range l {
		node := l[i]
		id := node.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}}

		// 检测重复ID
		if _, exists := nodeMap[id]; exists {
			app.ZapLog.Error(fmt.Sprintf("节点ID重复: %d", id))
			continue
		}

		// 循环引用检测 - 自引用
		if node.{{if .ParentIdField}}{{.ParentIdField.FieldName}}{{else}}Pid{{end}} == id {
			app.ZapLog.Error(fmt.Sprintf("循环引用: %d -> %d", node.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}}, node.{{if .ParentIdField}}{{.ParentIdField.FieldName}}{{else}}Pid{{end}}))
			continue
		}

		// 初始化子节点为nil
		node.Children = nil
		nodeMap[id] = node
	}

	// 第二次遍历: 构建树结构
	for _, node := range nodeMap {
		// {{if .ParentIdField}}{{.ParentIdField.FieldName}}{{else}}Pid{{end}}为0表示顶层节点
		if node.{{if .ParentIdField}}{{.ParentIdField.FieldName}}{{else}}Pid{{end}} == 0 {
			roots = append(roots, node) // 直接使用指针，避免值拷贝
		} else {
			parentID := node.{{if .ParentIdField}}{{.ParentIdField.FieldName}}{{else}}Pid{{end}}
			parent, exists := nodeMap[parentID]
			if exists {
				// 检测循环引用
				if visited[node.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}}] {
					app.ZapLog.Error(fmt.Sprintf("循环引用检测: 节点 %d 已被访问", node.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}}))
					continue
				}
				visited[node.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}}] = true

				// 初始化父节点的children为数组（若为nil）
				if parent.Children == nil {
					parent.Children = {{.StructName}}List{}
				}
				parent.Children = append(parent.Children, node) // 直接使用指针，避免值拷贝
			} else {
				app.ZapLog.Warn(fmt.Sprintf("独立节点 %d: parentId=%d 不存在", node.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}}, parentID))
			}
		}
	}

	// 对构建好的树进行排序
	return roots.TreeSort()
}

// TreeSort 对树形结构进行排序
func (l {{.StructName}}List) TreeSort() {{.StructName}}List {
	if len(l) == 0 {
		return l
	}

	// 对当前层级进行排序
	sort.Slice(l, func(i, j int) bool {
		a, b := l[i], l[j]

		// 按ID排序保证稳定性
		return a.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}} < b.{{if .PrimaryKey}}{{.PrimaryKey.FieldName}}{{else}}Id{{end}}
	})

	// 深层递归排序子节点
	for i := range l {
		if len(l[i].Children) > 0 {
			l[i].Children = l[i].Children.TreeSort()
		}
	}

	return l
}
