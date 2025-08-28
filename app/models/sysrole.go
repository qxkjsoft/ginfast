package models

import (
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysRole 系统角色模型
type SysRole struct {
	gorm.Model
	Name        string   `gorm:"column:name;size:255;default:'';comment:角色名称" json:"name"`
	Sort        int      `gorm:"column:sort;default:0;comment:排序" json:"sort"`
	Status      int8     `gorm:"column:status;default:0;comment:状态" json:"status"`
	Description string   `gorm:"column:description;size:255;comment:描述" json:"description"`
	ParentID    uint     `gorm:"column:parent_id;default:0;comment:父级ID" json:"parent_id"`
	CreatedBy   uint     `gorm:"column:created_by;comment:创建人" json:"created_by"`
	Users       UserList `gorm:"many2many:sys_user_role;foreignKey:id;joinForeignKey:role_id;References:id;joinReferences:user_id" json:"users"`
}

// TableName 设置表名
func (SysRole) TableName() string {
	return "sys_role"
}

type SysRoleList []*SysRole

func (list SysRoleList) Map(fn func(*SysRole) interface{}) []interface{} {
	var roles []interface{}
	for _, role := range list {
		roles = append(roles, fn(role))
	}
	return roles
}

// GetRoleByID 根据ID获取角色
func GetRoleByID(id uint) (*SysRole, error) {
	var role SysRole
	if err := app.GormDbMysql.First(&role, id).Error; err != nil {
		return nil, err
	}
	return &role, nil
}

// CreateRole 创建角色
func CreateRole(role *SysRole) error {
	return app.GormDbMysql.Create(role).Error
}

// UpdateRole 更新角色
func UpdateRole(role *SysRole) error {
	return app.GormDbMysql.Save(role).Error
}

// DeleteRole 删除角色
func DeleteRole(id uint) error {
	return app.GormDbMysql.Delete(&SysRole{}, id).Error
}

// GetRoleList 获取角色列表
func GetRoleList() ([]SysRole, error) {
	var roles []SysRole
	if err := app.GormDbMysql.Find(&roles).Error; err != nil {
		return nil, err
	}
	return roles, nil
}
