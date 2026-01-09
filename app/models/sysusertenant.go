package models

import (
	"context"
	"gin-fast/app/global/app"
	"time"

	"gorm.io/gorm"
)

type SysUserTenant struct {
	UserID    uint      `gorm:"primaryKey;type:int(11);column:user_id;default:0;comment:用户ID" json:"userID"`
	TenantID  uint      `gorm:"primaryKey;type:int(11);column:tenant_id;default:0;comment:租户ID" json:"tenantID"`
	IsDefault bool      `gorm:"type:tinyint(1);column:is_default;default:0;comment:是否默认租户" json:"isDefault"`
	User      *User     `gorm:"foreignKey:user_id;references:id" json:"user"`
	Tenant    *Tenant   `gorm:"foreignKey:tenant_id;references:id" json:"tenant"`
	CreatedAt time.Time `gorm:"type:timestamp;column:created_at;default:null;comment:创建时间" json:"createdAt"`
}

func NewSysUserTenant() *SysUserTenant {
	return &SysUserTenant{}
}

// TableName 设置表名
func (SysUserTenant) TableName() string {
	return "sys_user_tenant"
}

// Find 查找用户租户关联记录
func (sut *SysUserTenant) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().WithContext(c).Scopes(funcs...).First(sut).Error
	if err == gorm.ErrRecordNotFound {
		err = nil // 将记录未找到的错误转换为nil，通过IsEmpty()方法判断
	}
	return
}

// Create 创建用户租户关联记录
func (sut *SysUserTenant) Create(c context.Context) (err error) {
	return app.DB().WithContext(c).Create(sut).Error
}

// Update 更新用户租户关联记录
func (sut *SysUserTenant) Update(c context.Context) (err error) {
	return app.DB().WithContext(c).Save(sut).Error
}

// Delete 删除用户租户关联记录
func (sut *SysUserTenant) Delete(c context.Context) (err error) {
	return app.DB().WithContext(c).Delete(sut).Error
}

// IsEmpty 检查用户租户关联是否为空
func (sut *SysUserTenant) IsEmpty() bool {
	return sut.UserID == 0 && sut.TenantID == 0
}

// SysUserTenantList 用户租户关联列表
type SysUserTenantList []*SysUserTenant

// NewSysUserTenantList 创建新的用户租户关联列表实例
func NewSysUserTenantList() SysUserTenantList {
	return SysUserTenantList{}
}

// Find 查找用户租户关联列表
func (list *SysUserTenantList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().WithContext(c).Scopes(funcs...).Find(list).Error
	return
}

// GetTotal 获取用户租户关联总数
func (list *SysUserTenantList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var total int64
	err := app.DB().WithContext(c).Model(&SysUserTenant{}).Scopes(query...).Count(&total).Error
	if err != nil {
		return 0, err
	}
	return total, nil
}

func (list SysUserTenantList) Filter(filter func(*SysUserTenant) bool) *SysUserTenant {
	for _, item := range list {
		if filter(item) {
			return item
		}
	}
	return nil
}

func (list SysUserTenantList) GetTenants() TenantList {
	var tenants TenantList
	for _, item := range list {
		if item.Tenant != nil {
			tenants = append(tenants, item.Tenant)
		}
	}
	return tenants
}
