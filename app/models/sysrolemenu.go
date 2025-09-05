package models

import (
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysRoleMenu 角色菜单关联模型
type SysRoleMenu struct {
	RoleID uint `gorm:"primaryKey;column:role_id;comment:角色ID" json:"roleId"`
	MenuID uint `gorm:"primaryKey;column:menu_id;comment:菜单ID" json:"menuId"`
}

// TableName 设置表名
func (SysRoleMenu) TableName() string {
	return "sys_role_menu"
}

func NewSysRoleMenu() *SysRoleMenu {
	return &SysRoleMenu{}
}

// Find
func (m *SysRoleMenu) Find(funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().Scopes(funcs...).Find(m).Error
}

type SysRoleMenuList []*SysRoleMenu

func NewSysRoleMenuList() SysRoleMenuList {
	return SysRoleMenuList{}
}

// IsEmpty 检查角色菜单列表是否为空
func (list SysRoleMenuList) IsEmpty() bool {
	return len(list) == 0
}

// Find
func (list *SysRoleMenuList) Find(funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).Find(list).Error
	return
}

func (list SysRoleMenuList) Map(fn func(*SysRoleMenu) uint) []uint {
	res := make([]uint, len(list))
	for i, v := range list {
		res[i] = fn(v)
	}
	return res
}
