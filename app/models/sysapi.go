package models

import (
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysApi 系统API权限模型
type SysApi struct {
	gorm.Model
	Title     string `gorm:"column:title;size:255;comment:权限名称" json:"title"`
	Path      string `gorm:"column:path;size:255;comment:权限路径" json:"path"`
	Method    string `gorm:"column:method;size:32;comment:请求方法" json:"method"`
	ApiGroup  string `gorm:"column:api_group;size:255;comment:分组" json:"api_group"`
	MenuID    uint   `gorm:"column:menu_id;comment:菜单ID" json:"menu_id"`
	CreatedBy uint   `gorm:"column:created_by;comment:创建人" json:"created_by"`
}

// TableName 设置表名
func (SysApi) TableName() string {
	return "sys_api"
}

// CreateApi 创建API
func CreateApi(api *SysApi) error {
	return app.GormDbMysql.Create(api).Error
}

// UpdateApi 更新API
func UpdateApi(api *SysApi) error {
	return app.GormDbMysql.Save(api).Error
}

// DeleteApi 删除API
func DeleteApi(id uint) error {
	return app.GormDbMysql.Delete(&SysApi{}, id).Error
}

// GetApiList 获取API列表
func GetApiList() ([]SysApi, error) {
	var apis []SysApi
	if err := app.GormDbMysql.Find(&apis).Error; err != nil {
		return nil, err
	}
	return apis, nil
}

// GetApiByID 根据ID获取API
func GetApiByID(id uint) (*SysApi, error) {
	var api SysApi
	if err := app.GormDbMysql.First(&api, id).Error; err != nil {
		return nil, err
	}
	return &api, nil
}
