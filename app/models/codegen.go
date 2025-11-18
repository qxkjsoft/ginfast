package models

import (
	"database/sql"
	"fmt"

	"gin-fast/app/utils/common"
	"strconv"
	"strings"
)

// CodeGenContext 代码生成上下文 - 统一参数结构体
type CodeGenContext struct {
	// 基础信息
	TableName string `json:"tableName"` // 表名
	DirName   string `json:"dirName"`   // 目录名（全英文字母小写）
	FileName  string `json:"fileName"`  // 文件名（全英文字母小写）
	Comment   string `json:"comment"`   // 表注释/描述

	// 派生信息
	StructName      string `json:"structName"`      // 大驼峰结构体名
	StructNameLower string `json:"structNameLower"` // 小驼峰结构体名

	// 列信息
	Columns      ColumnTemplateList `json:"columns"`      // 字段列表
	PrimaryKey   *ColumnTemplate    `json:"primaryKey"`   // 主键
	HasTimeField bool               `json:"hasTimeField"` // 是否有时间字段
	HasCreatedBy bool               `json:"hasCreatedBy"` // 是否有created_by字段
	HasTenantID  bool               `json:"hasTenantID"`  // 是否有tenant_id字段

	// 参数模型中的时间字段判断
	HasTimeFieldInQuery bool `json:"hasTimeFieldInQuery"` // 是否在查询中有时间字段
	HasTimeFieldInForm  bool `json:"hasTimeFieldInForm"`  // 是否在表单中有时间字段

	// 扩展参数
	ExtraParams map[string]interface{} `json:"extraParams"` // 额外参数
}

// NewCodeGenContext 创建代码生成上下文
func NewCodeGenContext(tableName, dirName, fileName, comment string, columns ColumnTemplateList) *CodeGenContext {
	// 日光时间字段判断 - 筛选实际会被渲染的时间字段
	hasTimeInQuery := len(columns.Filter(func(col ColumnTemplate) bool {
		return col.QueryShow && col.GoType == "time.Time"
	})) > 0

	hasTimeInForm := len(columns.Filter(func(col ColumnTemplate) bool {
		return col.FormShow && col.GoType == "time.Time"
	})) > 0

	ctx := &CodeGenContext{
		TableName:           tableName,
		DirName:             common.KeepLettersOnlyLower(dirName),
		FileName:            common.KeepLettersOnlyLower(fileName),
		Comment:             comment,
		Columns:             columns,
		PrimaryKey:          columns.GetPrimaryKey(),
		StructName:          common.ToCamelCase(fileName),
		StructNameLower:     common.ToCamelCaseLower(fileName),
		ExtraParams:         make(map[string]interface{}),
		HasTimeField:        columns.HasTimeField(),
		HasCreatedBy:        columns.HasCreatedBy(),
		HasTenantID:         columns.HasTenantID(),
		HasTimeFieldInQuery: hasTimeInQuery,
		HasTimeFieldInForm:  hasTimeInForm,
	}
	return ctx
}

// MenuApiContext 菜单API上下文
type MenuApiContext struct {
	TableName string `json:"tableName"` // 表名
	FileName  string `json:"fileName"`  // 自定义文件名 (全英文字母小写)
	DirName   string `json:"dirName"`   // 目录名（全英文字母小写）
	Comment   string `json:"comment"`   // 表注释/描述
}

// FrontendGenContext 前端代码生成上下文
type FrontendGenContext struct {
	// 基础信息
	TableName string `json:"tableName"` // 表名
	DirName   string `json:"dirName"`   // 目录名（全英文字母小写）
	FileName  string `json:"fileName"`  // 文件名（全英文字母小写）

	// 派生信息
	StructName      string `json:"structName"`      // 大驼峰结构体名
	StructNameLower string `json:"structNameLower"` // 小驼峰结构体名

	// 列信息
	Columns    ColumnTemplateList `json:"columns"`    // 字段列表
	PrimaryKey *ColumnTemplate    `json:"primaryKey"` // 主键

	// 扩展参数
	ExtraParams map[string]interface{} `json:"extraParams"` // 额外参数
}

// NewFrontendGenContext 创建前端代码生成上下文
func NewFrontendGenContext(tableName, dirName, fileName string, columns ColumnTemplateList) *FrontendGenContext {
	ctx := &FrontendGenContext{
		TableName:       tableName,
		DirName:         common.KeepLettersOnlyLower(dirName),
		FileName:        common.KeepLettersOnlyLower(fileName),
		Columns:         columns,
		PrimaryKey:      columns.GetPrimaryKey(),
		StructName:      common.ToCamelCase(fileName),
		StructNameLower: common.ToCamelCaseLower(fileName),
		ExtraParams:     make(map[string]interface{}),
	}
	return ctx
}

// TableInfo 表信息结构体
type TableInfo struct {
	TableName    string         `json:"tableName"`    // 表名
	TableComment sql.NullString `json:"tableComment"` // 表注释/描述
}

// TableColumn 数据库字段信息结构体
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

// GoType 获取Go语言类型
func (tc *TableColumn) GoType() string {
	// 根据数据类型和是否unsigned返回对应的Go类型
	switch tc.DataType {
	case "int", "integer", "smallint", "tinyint":
		if tc.IsUnsigned {
			return "uint"
		}
		return "int"
	case "bigint":
		if tc.IsUnsigned {
			return "uint64"
		}
		return "int64"
	case "varchar", "text", "char", "nvarchar", "ntext":
		return "string"
	case "datetime", "timestamp", "date":
		return "time.Time"
	case "decimal", "numeric", "float", "double":
		return "float64"
	case "boolean", "bool":
		return "bool"
	default:
		return "string"
	}
}

func (tc *TableColumn) FrontendType() string {
	// 根据数据类型返回对应的TypeScript类型
	switch tc.DataType {
	case "int", "integer", "smallint", "tinyint", "bigint":
		return "number"
	case "varchar", "text", "char", "nvarchar", "ntext":
		return "string"
	case "datetime", "timestamp", "date":
		return "string" // 前端通常使用字符串表示日期
	case "decimal", "numeric", "float", "double":
		return "number"
	case "boolean", "bool":
		return "boolean"
	default:
		return "string"
	}
}

func (tc *TableColumn) BuildGormTag() string {
	// 构建列名
	columnTag := fmt.Sprintf("column:%s", tc.ColumnName)
	tags := []string{columnTag}

	// 处理主键
	if tc.IsPrimaryKey() {
		tags = append(tags, "primaryKey")
	}

	// 处理可为 null
	if tc.IsNullable == "NO" {
		tags = append(tags, "not null")
	}

	// 处理默认值
	if tc.ColumnDefault.Valid {
		defaultValue := tc.ColumnDefault.String
		// 如果默认值包含特殊字符，需要添加引号
		if needsQuotes(tc.DataType) && !isNumericOrBoolean(defaultValue) {
			defaultValue = fmt.Sprintf("'%s'", defaultValue)
		}
		tags = append(tags, fmt.Sprintf("default:%s", defaultValue))
	}

	// 处理自动递增
	if tc.Extra.Valid && tc.Extra.String == "auto_increment" {
		tags = append(tags, "autoIncrement")
	}

	// 处理唯一键
	if tc.ColumnKey.Valid && tc.ColumnKey.String == "UNI" {
		tags = append(tags, "uniqueIndex")
	}

	// 处理索引 (MUL 表示普通索引)
	if tc.ColumnKey.Valid && tc.ColumnKey.String == "MUL" {
		tags = append(tags, "index")
	}

	// 处理字段长度
	if tc.MaxLength.Valid && tc.MaxLength.Int64 > 0 {
		tags = append(tags, fmt.Sprintf("size:%d", tc.MaxLength.Int64))
	}

	// 处理数值类型精度
	if (tc.DataType == "decimal" || tc.DataType == "numeric") && tc.NumericPrecision.Valid && tc.NumericScale.Valid {
		precision := tc.NumericPrecision.Int64
		scale := tc.NumericScale.Int64
		if precision > 0 && scale >= 0 {
			tags = append(tags, fmt.Sprintf("precision:%d", precision))
			if scale > 0 {
				tags = append(tags, fmt.Sprintf("scale:%d", scale))
			}
		}
	}

	// 构建最终标签
	return strings.Join(tags, ";")
}

// needsQuotes 判断数据类型是否需要引号包围默认值
func needsQuotes(dataType string) bool {
	switch dataType {
	case "varchar", "char", "text", "datetime", "timestamp", "date":
		return true
	default:
		return false
	}
}

// isNumericOrBoolean 判断值是否为数字或布尔值
func isNumericOrBoolean(value string) bool {
	if value == "CURRENT_TIMESTAMP" || value == "NULL" {
		return true
	}
	// 检查是否为数字
	if _, err := strconv.Atoi(value); err == nil {
		return true
	}
	if _, err := strconv.ParseFloat(value, 64); err == nil {
		return true
	}
	// 检查是否为布尔值
	if value == "true" || value == "false" || value == "0" || value == "1" {
		return true
	}
	return false
}

type TableColumns []TableColumn

// ColumnTemplate 列模板
func (tcs TableColumns) ColumnTemplate() ColumnTemplateList {
	columnTemplates := make([]ColumnTemplate, 0, len(tcs))
	for _, column := range tcs {
		// 转换字段名（驼峰命名）
		fieldName := common.ToCamelCase(column.ColumnName)

		// 定义需要排除的字段列表（系统字段）
		excludeFields := map[string]bool{
			"CreatedAt": true,
			"UpdatedAt": true,
			"DeletedAt": true,
			"CreatedBy": true,
			"TenantId":  true,
		}

		// 主键字段
		isPrimary := column.ColumnKey.String == "PRI"
		comment := fieldName
		if column.ColumnComment.String != "" {
			comment = column.ColumnComment.String
		}

		columnTemplates = append(columnTemplates, ColumnTemplate{
			FieldName:    fieldName,
			GoType:       column.FrontendType(),
			FrontendType: column.FrontendType(),
			JsonTag:      common.ToCamelCaseLower(column.ColumnName),
			GormTag:      column.BuildGormTag(),
			Comment:      comment,
			IsPrimary:    isPrimary,
			Exclude:      excludeFields[fieldName],
		})
	}
	return columnTemplates
}

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

// ColumnTemplate 字段模板数据
type ColumnTemplate struct {
	DataName     string `json:"dataName"`     // 数据库字段名
	FieldName    string `json:"fieldName"`    // 字段名 （驼峰命名）
	GoType       string `json:"goType"`       // Go类型
	FrontendType string `json:"frontendType"` // 前端类型
	JsonTag      string `json:"jsonTag"`      // JSON标签
	GormTag      string `json:"gormTag"`      // GORM标签
	Comment      string `json:"comment"`      // 注释
	IsPrimary    bool   `json:"isPrimary"`    // 是否主键
	Exclude      bool   `json:"exclude"`      // 是否在Create/Update中排除
	Required     bool   `json:"required"`     // 是否必填
	ListShow     bool   `json:"listShow"`     // 是否在列表中显示
	FormShow     bool   `json:"formShow"`     // 是否在表单中显示
	QueryShow    bool   `json:"queryShow"`    // 是否在查询中显示
	QueryType    string `json:"queryType"`    // 查询类型： EQ 等于 NE 不等于 GT 大于 GTE 大于等于 LT 小于 LTE 小于等于 LIKE 包含 BETWEEN 范围
	FormType     string `json:"formType"`     // 表单类型 : input 文本框 textarea 文本域 number 数字输入框 select 下拉框 radio 单选框 checkbox 复选框 datetime 日期时间
	DictType     string `json:"dictType"`     // 关联的字典
}

type ColumnTemplateList []ColumnTemplate

func (c ColumnTemplateList) Filter(fn func(col ColumnTemplate) bool) ColumnTemplateList {
	filtered := make(ColumnTemplateList, 0)
	for _, col := range c {
		if fn(col) {
			filtered = append(filtered, col)
		}
	}
	return filtered
}

func (c ColumnTemplateList) GetPrimaryKey() *ColumnTemplate {
	for _, col := range c {
		if col.IsPrimary {
			return &col
		}
	}
	return nil
}

// 是否有时间字段
// HasTimeField 是否有时间字段
func (c ColumnTemplateList) HasTimeField() bool {
	for _, col := range c {
		if col.GoType == "time.Time" {
			return true
		}
	}
	return false
}

// HasCreatedBy 是否有created_by字段
func (c ColumnTemplateList) HasCreatedBy() bool {
	for _, col := range c {
		if col.DataName == "created_by" {
			return true
		}
	}
	return false
}

// HasTenantID 是否有tenant_id字段
func (c ColumnTemplateList) HasTenantID() bool {
	for _, col := range c {
		if col.DataName == "tenant_id" {
			return true
		}
	}
	return false
}
