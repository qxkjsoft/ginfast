package models

import (
	"context"
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysGenField 代码生成字段配置模型
type SysGenField struct {
	ID          uint   `gorm:"primarykey" json:"id"`
	GenID       uint   `gorm:"column:gen_id;comment:生成配置ID" json:"genId"`
	DataName    string `gorm:"column:data_name;size:255;comment:列名" json:"dataName"`
	DataType    string `gorm:"column:data_type;size:255;comment:数据类型" json:"dataType"`
	DataComment string `gorm:"column:data_comment;size:255;comment:列注释" json:"dataComment"`
	DataExtra   string `gorm:"column:data_extra;size:255;comment:额外信息" json:"dataExtra"`
	IsPrimary   *int   `gorm:"column:is_primary;comment:是否主键" json:"isPrimary"`
	GoType      string `gorm:"column:go_type;size:255;comment:go类型" json:"goType"`
	FrontType   string `gorm:"column:front_type;size:255;comment:前端类型" json:"frontType"`
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
func (list *SysGenFieldList) GetTotal(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (count int64, err error) {
	err = app.DB().Model(&SysGenField{}).Scopes(funcs...).WithContext(c).Count(&count).Error
	return
}
