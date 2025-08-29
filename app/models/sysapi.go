package models

// SysApi 系统API权限模型
type SysApi struct {
	BaseModel
	Title     string `gorm:"column:title;size:255;comment:权限名称" json:"title"`
	Path      string `gorm:"column:path;size:255;comment:权限路径" json:"path"`
	Method    string `gorm:"column:method;size:32;comment:请求方法" json:"method"`
	ApiGroup  string `gorm:"column:api_group;size:255;comment:分组" json:"apiGroup"`
	MenuID    uint   `gorm:"column:menu_id;comment:菜单ID" json:"menuId"`
	CreatedBy uint   `gorm:"column:created_by;comment:创建人" json:"createdBy"`
}

// TableName 设置表名
func (SysApi) TableName() string {
	return "sys_api"
}
