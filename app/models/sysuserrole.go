package models

// SysUserRole 用户角色关联模型
type SysUserRole struct {
	UserID uint `gorm:"primaryKey;column:user_id;default:0;comment:用户ID" json:"user_id"`
	RoleID uint `gorm:"primaryKey;column:role_id;default:0;comment:角色ID" json:"role_id"`
}

// TableName 设置表名
func (SysUserRole) TableName() string {
	return "sys_user_role"
}
