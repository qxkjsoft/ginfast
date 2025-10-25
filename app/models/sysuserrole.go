package models

import (
	"context"
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysUserRole 用户角色关联模型
type SysUserRole struct {
	UserID uint `gorm:"primaryKey;column:user_id;default:0;comment:用户ID" json:"userId"`
	RoleID uint `gorm:"primaryKey;column:role_id;default:0;comment:角色ID" json:"roleId"`
}

// TableName 设置表名
func (SysUserRole) TableName() string {
	return "sys_user_role"
}

func NewSysUserRole() *SysUserRole {
	return &SysUserRole{}
}

type SysUserRoleList []*SysUserRole

func NewSysUserRoleList() SysUserRoleList {
	return SysUserRoleList{}
}

func (list *SysUserRoleList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(c).Scopes(funcs...).Find(list).Error
}

func (list SysUserRoleList) IsEmpty() bool {
	return len(list) == 0
}

func (list SysUserRoleList) Map(fn func(*SysUserRole) uint) []uint {
	res := make([]uint, len(list))
	for i, v := range list {
		res[i] = fn(v)
	}
	return res
}
