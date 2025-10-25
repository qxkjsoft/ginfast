package models

import (
	"context"
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"gorm.io/gorm"
)

// Example 示例模型
type Example struct {
	models.BaseModel
	Name        string `gorm:"type:varchar(255);comment:名称" json:"name"`
	Description string `gorm:"type:varchar(255);comment:描述" json:"description"`
	CreatedBy   uint   `gorm:"type:int(11);comment:创建者ID" json:"createdBy"`
	TenantID    uint   `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
}

// ExampleList 示例列表
type ExampleList []Example

// NewExample 创建示例实例
func NewExample() *Example {
	return &Example{}
}

// NewExampleList 创建示例列表实例
func NewExampleList() *ExampleList {
	return &ExampleList{}
}

// TableName 指定表名
func (Example) TableName() string {
	return "example"
}

// GetByID 根据ID获取示例
func (m *Example) GetByID(c context.Context, id uint) error {
	return app.DB().WithContext(c).First(m, id).Error
}

// Create 创建示例记录
func (m *Example) Create(c context.Context) error {
	return app.DB().WithContext(c).Create(m).Error
}

// Update 更新示例记录
func (m *Example) Update(c context.Context) error {
	return app.DB().WithContext(c).Save(m).Error
}

// Delete 软删除示例记录
func (m *Example) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(m).Error
}

// IsEmpty 检查模型是否为空
func (m *Example) IsEmpty() bool {
	return m.ID == 0
}

// Find 查询示例列表
func (l *ExampleList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(c).Model(&Example{}).Scopes(funcs...).Find(l).Error
}

// GetTotal 获取示例总数
func (l *ExampleList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(c).Model(&Example{}).Scopes(query...).Count(&count).Error
	return count, err
}
