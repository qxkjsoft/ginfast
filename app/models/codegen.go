package models

import "database/sql"

// TableInfo 表信息结构体
type TableInfo struct {
	TableName    string         `json:"tableName"`    // 表名
	TableComment sql.NullString `json:"tableComment"` // 表注释/描述
}

// TableColumn 字段信息结构体
type TableColumn struct {
	ColumnName       string         `json:"columnName"`       // 列名
	DataType         string         `json:"dataType"`         // 数据类型
	ColumnComment    sql.NullString `json:"columnComment"`    // 列注释
	IsNullable       string         `json:"isNullable"`       // 是否可为空
	ColumnDefault    sql.NullString `json:"columnDefault"`    // 默认值
	ColumnKey        sql.NullString `json:"columnKey"`        // 列键信息
	Extra            sql.NullString `json:"extra"`            // 额外信息
	MaxLength        sql.NullInt64  `json:"maxLength"`        // 最大长度
	NumericPrecision sql.NullInt64  `json:"numericPrecision"` // 数值精度
	NumericScale     sql.NullInt64  `json:"numericScale"`     // 数值标度
	IsUnsigned       bool           `json:"isUnsigned"`       // 是否为无符号类型
}

// 是否主键
// IsPrimaryKey 是否主键
func (tc *TableColumn) IsPrimaryKey() bool {
	return tc.ColumnKey.Valid && tc.ColumnKey.String == "PRI"
}

type TableColumns []TableColumn

// 是否包含主键
// HasPrimaryKey 是否包含主键
func (tcs TableColumns) HasPrimaryKey() bool {
	for _, tc := range tcs {
		if tc.IsPrimaryKey() {
			return true
		}
	}
	return false
}

// 主键字段数量
// PrimaryKeyCount 主键字段数量
func (tcs TableColumns) PrimaryKeyCount() int {
	count := 0
	for _, tc := range tcs {
		if tc.IsPrimaryKey() {
			count++
		}
	}
	return count
}

// 获取主键
// GetPrimaryKey 获取主键
func (tcs TableColumns) GetPrimaryKey() *TableColumn {
	for _, tc := range tcs {
		if tc.IsPrimaryKey() {
			return &tc
		}
	}
	return nil
}

// CodeGenConfig 代码生成配置
type CodeGenConfig struct {
	ModelTemplate      string `json:"model_template"`      // 模型模板
	ControllerTemplate string `json:"controller_template"` // 控制器模板
	ServiceTemplate    string `json:"service_template"`    // 服务模板
	OutputPath         string `json:"output_path"`         // 输出路径
	PackageName        string `json:"package_name"`        // 包名
}

// ModelTemplateData 模型模板数据
type ModelTemplateData struct {
	StructName string           `json:"structName"`
	TableName  string           `json:"tableName"`
	Columns    []ColumnTemplate `json:"columns"`
}

// ControllerTemplateData 控制器模板数据
type ControllerTemplateData struct {
	StructName      string `json:"structName"`
	StructNameLower string `json:"structNameLower"`
	TableName       string `json:"tableName"`
	DirName         string `json:"dirName"`
}

// ServiceTemplateData 服务模板数据
type ServiceTemplateData struct {
	StructName      string `json:"structName"`
	StructNameLower string `json:"structNameLower"`
	TableName       string `json:"tableName"`
	DirName         string `json:"dirName"`
}

// RoutesTemplateData 路由模板数据
type RoutesTemplateData struct {
	StructName      string `json:"structName"`
	StructNameLower string `json:"structNameLower"`
	TableName       string `json:"tableName"`
	DirName         string `json:"dirName"`
}

// InitTemplateData 初始化模板数据
type InitTemplateData struct {
	StructName      string `json:"structName"`
	StructNameLower string `json:"structNameLower"`
	TableName       string `json:"tableName"`
	DirName         string `json:"dirName"`
}

// ColumnTemplate 字段模板数据
type ColumnTemplate struct {
	FieldName    string `json:"fieldName"`
	GoType       string `json:"goType"`
	FrontendType string `json:"frontendType"`
	JsonTag      string `json:"jsonTag"`
	GormTag      string `json:"gormTag"`
	Comment      string `json:"comment"`
	IsPrimary    bool   `json:"isPrimary"`
	Exclude      bool   `json:"exclude"` // 是否在Create/Update中排除
}
