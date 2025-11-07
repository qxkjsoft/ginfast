package models

import (
	"context"
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysGen 代码生成配置模型
type SysGen struct {
	BaseModel
	Name       string `gorm:"column:name;size:255;comment:表名" json:"name"`
	ModuleName string `gorm:"column:module_name;size:255;comment:模块名称" json:"moduleName"`
	Describe   string `gorm:"column:describe;size:1000;comment:描述" json:"describe"`
	CreatedBy  uint   `gorm:"column:created_by;comment:创建人" json:"createdBy"`
}

// TableName 设置表名
func (SysGen) TableName() string {
	return "sys_gen"
}

// NewSysGen 创建一个新的SysGen实例
func NewSysGen() *SysGen {
	return &SysGen{}
}

// IsEmpty 检查模型是否为空
func (gen *SysGen) IsEmpty() bool {
	return gen.ID == 0
}

// Find 查找单个代码生成配置
func (gen *SysGen) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).WithContext(c).First(gen).Error
	if err == gorm.ErrRecordNotFound {
		err = nil // 将记录未找到的错误转换为nil，通过IsEmpty()方法判断
	}
	return
}

// Save 保存代码生成配置
func (gen *SysGen) Save(c context.Context) error {
	return app.DB().WithContext(c).Save(gen).Error
}

// Create 创建代码生成配置
func (gen *SysGen) Create(c context.Context) error {
	return app.DB().WithContext(c).Create(gen).Error
}

// Update 更新代码生成配置
func (gen *SysGen) Update(c context.Context, updates map[string]interface{}) error {
	return app.DB().WithContext(c).Model(gen).Updates(updates).Error
}

// Delete 删除代码生成配置
func (gen *SysGen) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(gen).Error
}

// SysGenList 代码生成配置列表
type SysGenList []*SysGen

// NewSysGenList 创建一个新的SysGenList实例
func NewSysGenList() SysGenList {
	return SysGenList{}
}

// IsEmpty 检查列表是否为空
func (list SysGenList) IsEmpty() bool {
	return len(list) == 0
}

// Find 查找代码生成配置列表
func (list *SysGenList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).WithContext(c).Find(list).Error
	return
}

// GetTotal 获取代码生成配置总数
func (list *SysGenList) GetTotal(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (count int64, err error) {
	err = app.DB().Model(&SysGen{}).Scopes(funcs...).WithContext(c).Count(&count).Error
	return
}
