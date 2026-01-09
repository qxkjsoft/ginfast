package models

import (
	"context"
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// Tenant 租户模型
type Tenant struct {
	BaseModel
	Name           string `gorm:"column:name;size:255;not null;comment:租户名称" json:"name"`
	Code           string `gorm:"column:code;size:100;uniqueIndex;not null;comment:租户编码(子域名标识)" json:"code"`
	Description    string `gorm:"column:description;size:500;comment:租户描述" json:"description"`
	Status         int8   `gorm:"column:status;default:1;comment:状态 0停用 1启用" json:"status"`
	Domain         string `gorm:"column:domain;size:255;comment:绑定域名(完整域名，非空时应唯一)" json:"domain"`
	PlatformDomain string `gorm:"column:platform_domain;size:255;comment:平台基础域名(如:yourplatform.com)" json:"platformDomain"`
	CreatedBy      uint   `gorm:"column:created_by;comment:创建人" json:"createdBy"`
	MenuPermission string `gorm:"column:menu_permission;size:500;comment:菜单权限" json:"menuPermission"`
}

// TableName 设置表名
func (Tenant) TableName() string {
	return "sys_tenants"
}

// NewTenant 创建新的租户实例
func NewTenant() *Tenant {
	return &Tenant{}
}

// IsEmpty 检查租户是否为空
func (t *Tenant) IsEmpty() bool {
	return t.ID == 0
}

// Find 查找单个租户
func (t *Tenant) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().WithContext(c).Scopes(funcs...).First(t).Error
	if err == gorm.ErrRecordNotFound {
		err = nil // 将记录未找到的错误转换为nil，通过IsEmpty()方法判断
	}
	return
}

// Create 创建租户
func (t *Tenant) Create(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	return app.DB().WithContext(c).Scopes(funcs...).Create(t).Error
}

// Update 更新租户
func (t *Tenant) Update(c context.Context) (err error) {
	return app.DB().WithContext(c).Save(t).Error
}

// Delete 删除租户
func (t *Tenant) Delete(c context.Context) (err error) {
	return app.DB().WithContext(c).Delete(t).Error
}

// TenantList 租户列表
type TenantList []*Tenant

// NewTenantList 创建新的租户列表实例
func NewTenantList() TenantList {
	return TenantList{}
}

// IsEmpty 检查租户列表是否为空
func (list TenantList) IsEmpty() bool {
	return len(list) == 0
}

// Find 查找租户列表
func (list *TenantList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().WithContext(c).Scopes(funcs...).Find(list).Error
	return
}

func (list *TenantList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var total int64
	err := app.DB().WithContext(c).Model(&Tenant{}).Scopes(query...).Count(&total).Error
	if err != nil {
		return 0, err
	}
	return total, nil
}

// FindByID 按ID查找租户
func (t *Tenant) FindByID(c context.Context, id uint) (err error) {
	err = app.DB().WithContext(c).Where("id = ?", id).First(t).Error
	if err == gorm.ErrRecordNotFound {
		err = nil
	}
	return
}

// FindByCode 按Code(二级域名)查找租户
func (t *Tenant) FindByCode(c context.Context, code string) (err error) {
	err = app.DB().WithContext(c).Where("code = ? AND status = 1", code).First(t).Error
	if err == gorm.ErrRecordNotFound {
		err = nil
	}
	return
}

// FindByDomain 按Domain(主域名)查找租户 - Domain可以被多个租户共用
func (t *Tenant) FindByDomain(c context.Context, domain string) (err error) {
	err = app.DB().WithContext(c).Where("domain = ? AND status = 1", domain).First(t).Error
	if err == gorm.ErrRecordNotFound {
		err = nil
	}
	return
}

// FindByCodeOrDomain 按Code或Domain查找租户(优先级: Code > Domain)
func (t *Tenant) FindByCodeOrDomain(c context.Context, code, domain string) (err error) {
	// 优先按Code查询
	if code != "" {
		err = t.FindByCode(c, code)
		if err != nil || !t.IsEmpty() {
			return
		}
	}
	// 如果Code未找到，则按Domain查询
	if domain != "" {
		err = t.FindByDomain(c, domain)
	}
	return
}
