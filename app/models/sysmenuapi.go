package models

// SysMenuApi 菜单API关联模型
type SysMenuApi struct {
	MenuID uint `gorm:"primaryKey;column:menu_id;comment:菜单ID" json:"menu_id"`
	ApiID  uint `gorm:"primaryKey;column:api_id;comment:API ID" json:"api_id"`
}

// TableName 设置表名
func (SysMenuApi) TableName() string {
	return "sys_menu_api"
}
