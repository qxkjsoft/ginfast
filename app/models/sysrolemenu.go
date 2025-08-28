package models

// SysRoleMenu 角色菜单关联模型
type SysRoleMenu struct {
	RoleID uint `gorm:"primaryKey;column:role_id;comment:角色ID" json:"role_id"`
	MenuID uint `gorm:"primaryKey;column:menu_id;comment:菜单ID" json:"menu_id"`
}

// TableName 设置表名
func (SysRoleMenu) TableName() string {
	return "sys_role_menu"
}
