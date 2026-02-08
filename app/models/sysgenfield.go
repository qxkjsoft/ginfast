package models

import (
	"context"
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/utils/common"

	"gorm.io/gorm"
)

// SysGenField 代码生成字段配置模型
type SysGenField struct {
	ID            uint   `gorm:"primarykey" json:"id"`
	GenID         uint   `gorm:"column:gen_id;comment:生成配置ID" json:"genId"`
	DataName      string `gorm:"column:data_name;size:255;comment:列名" json:"dataName"`
	DataType      string `gorm:"column:data_type;size:255;comment:数据类型" json:"dataType"`
	DataComment   string `gorm:"column:data_comment;size:255;comment:列注释" json:"dataComment"`
	DataExtra     string `gorm:"column:data_extra;size:255;comment:额外信息" json:"dataExtra"`
	DataColumnKey string `gorm:"column:data_column_key;size:255;comment:列键" json:"dataColumnKey"`
	DataUnsigned  *int   `gorm:"column:data_unsigned;comment:是否无符号" json:"dataUnsigned"`
	IsPrimary     *int   `gorm:"column:is_primary;comment:是否主键" json:"isPrimary"`
	GoType        string `gorm:"column:go_type;size:255;comment:go类型" json:"goType"`
	FrontType     string `gorm:"column:front_type;size:255;comment:前端类型" json:"frontType"`
	CustomName    string `gorm:"column:custom_name;size:255;comment:自定义字段名称" json:"customName"`
	Require       *int   `gorm:"column:require;comment:是否必填" json:"require"`
	ListShow      *int   `gorm:"column:list_show;comment:列表显示" json:"listShow"`
	FormShow      *int   `gorm:"column:form_show;comment:表单显示" json:"formShow"`
	QueryShow     *int   `gorm:"column:query_show;comment:查询显示" json:"queryShow"`
	QueryType     string `gorm:"column:query_type;size:255;comment:查询方式" json:"queryType"`
	FormType      string `gorm:"column:form_type;size:255;comment:表单类型" json:"formType"`
	DictType      string `gorm:"column:dict_type;size:255;comment:关联的字典" json:"dictType"`
	GormTag       string `gorm:"column:gorm_tag;size:255;comment:gorm标签" json:"gormTag"`
}

// TableName 设置表名
func (SysGenField) TableName() string {
	return "sys_gen_field"
}

// NewSysGenField 创建一个新的SysGenField实例
func NewSysGenField() *SysGenField {
	return &SysGenField{}
}

// IsEmpty 检查模型是否为空
func (field *SysGenField) IsEmpty() bool {
	return field == nil || field.ID == 0
}

// Find 查找单个代码生成字段配置
func (field *SysGenField) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).WithContext(c).First(field).Error
	if err == gorm.ErrRecordNotFound {
		err = nil // 将记录未找到的错误转换为nil，通过IsEmpty()方法判断
	}
	return
}

// Save 保存代码生成字段配置
func (field *SysGenField) Save(c context.Context) error {
	return app.DB().WithContext(c).Save(field).Error
}

// Create 创建代码生成字段配置
func (field *SysGenField) Create(c context.Context) error {
	return app.DB().WithContext(c).Create(field).Error
}

// Update 更新代码生成字段配置
func (field *SysGenField) Update(c context.Context, updates map[string]interface{}) error {
	return app.DB().WithContext(c).Model(field).Updates(updates).Error
}

// Delete 删除代码生成字段配置
func (field *SysGenField) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(field).Error
}

// SysGenFieldList 代码生成字段配置列表
type SysGenFieldList []*SysGenField

// NewSysGenFieldList 创建一个新的SysGenFieldList实例
func NewSysGenFieldList() SysGenFieldList {
	return SysGenFieldList{}
}

// IsEmpty 检查列表是否为空
func (list SysGenFieldList) IsEmpty() bool {
	return len(list) == 0
}

// Find 查找代码生成字段配置列表
func (list *SysGenFieldList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).WithContext(c).Find(list).Error
	return
}

// GetTotal 获取代码生成字段配置总数
func (list SysGenFieldList) GetTotal(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (count int64, err error) {
	err = app.DB().Model(&SysGenField{}).Scopes(funcs...).WithContext(c).Count(&count).Error
	return
}

func (list SysGenFieldList) PrimaryKeyCount() int {
	count := 0
	for _, field := range list {
		if field.IsPrimary != nil && *field.IsPrimary == 1 {
			count++
		}
	}
	return count
}

// HasParentIDWithNumericType 检查是否包含parent_id且类型与主键一致
func (list SysGenFieldList) HasParentIDWithNumericType() (bool, error) {
	// 获取主键的GoType
	var primaryKeyGoType string
	for _, field := range list {
		if field.IsPrimary != nil && *field.IsPrimary == 1 {
			primaryKeyGoType = field.GoType
			break
		}
	}

	// 如果没有主键，返回false
	if primaryKeyGoType == "" {
		return false, fmt.Errorf("找不到主键字段")
	}

	// 检查parent_id字段的GoType是否与主键类型一致
	for _, field := range list {
		if field.DataName == "parent_id" {
			if field.GoType != primaryKeyGoType {
				return false, fmt.Errorf("parent_id字段的 GoType(%s) 与主键类型(%s) 不一致", field.GoType, primaryKeyGoType)
			}
			return true, nil
		}
	}
	return false, fmt.Errorf("找不到parent_id字段")
}

// HasNameField 检查是否包含name字段
func (list SysGenFieldList) HasNameField() bool {
	for _, field := range list {
		if field.DataName == "name" {
			return true
		}
	}
	return false
}

// HasPrimaryKeyFieldNamedID 检查主键字段名称是否为id
func (list SysGenFieldList) HasPrimaryKeyFieldNamedID() bool {
	for _, field := range list {
		if field.IsPrimary != nil && *field.IsPrimary == 1 {
			return field.DataName == "id"
		}
	}
	return false
}

func (list SysGenFieldList) ToColumnTemplate() ColumnTemplateList {
	var templates []ColumnTemplate

	// 定义需要排除的字段列表（系统字段）
	excludeFields := map[string]bool{
		"CreatedAt": true,
		"UpdatedAt": true,
		"DeletedAt": true,
		"CreatedBy": true,
		"TenantId":  true,
	}

	// 获取主键的GoType
	var primaryKeyGoType string
	for _, field := range list {
		if field.IsPrimary != nil && *field.IsPrimary == 1 {
			primaryKeyGoType = field.GoType
			break
		}
	}

	for _, field := range list {
		// 使用自定义字段名称，如果没有则使用数据库字段名转换为驼峰命名
		fieldName := common.ToCamelCase(field.CustomName)
		if fieldName == "" {
			fieldName = common.ToCamelCase(field.DataName)
		}

		// 判断是否为主键
		isPrimary := field.IsPrimary != nil && *field.IsPrimary == 1

		// 判断是否为父级键（parent_id字段类型与主键一致）
		isParentKey := field.DataName == "parent_id" && field.GoType == primaryKeyGoType

		// 注释信息
		comment := fieldName
		if field.DataComment != "" {
			comment = field.DataComment
		}

		// JSON标签使用小驼峰命名
		jsonTag := common.ToCamelCaseLower(fieldName)

		templates = append(templates, ColumnTemplate{
			DataName:     field.DataName,
			FieldName:    fieldName,
			GoType:       field.GoType,
			FrontendType: field.FrontType,
			JsonTag:      jsonTag,
			GormTag:      field.GormTag,
			Comment:      comment,
			IsPrimary:    isPrimary,
			IsParentKey:  isParentKey,
			Exclude:      isPrimary || excludeFields[fieldName],
			Required:     field.Require != nil && *field.Require == 1,
			ListShow:     field.ListShow != nil && *field.ListShow == 1,
			FormShow:     field.FormShow != nil && *field.FormShow == 1,
			QueryShow:    field.QueryShow != nil && *field.QueryShow == 1,
			QueryType:    field.QueryType,
			FormType:     field.FormType,
			DictType:     field.DictType,
		})
	}

	return templates
}
