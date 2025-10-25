package models

import (
	"context"
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysApi 系统API权限模型
type SysApi struct {
	BaseModel
	Title       string      `gorm:"column:title;size:255;comment:权限名称" json:"title"`
	Path        string      `gorm:"column:path;size:255;comment:权限路径" json:"path"`
	Method      string      `gorm:"column:method;size:32;comment:请求方法" json:"method"`
	ApiGroup    string      `gorm:"column:api_group;size:255;comment:分组" json:"apiGroup"`
	CreatedBy   uint        `gorm:"column:created_by;comment:创建人" json:"createdBy"`
	SysMenuList SysMenuList `gorm:"many2many:sys_menu_api;foreignKey:id;joinForeignKey:api_id;references:id;joinReferences:menu_id" json:"sysMenuList"`
}

// TableName 设置表名
func (SysApi) TableName() string {
	return "sys_api"
}

// NewSysApi 创建新的SysApi实例
func NewSysApi() *SysApi {
	return &SysApi{}
}

// IsEmpty 检查API是否为空
func (api *SysApi) IsEmpty() bool {
	return api.ID == 0
}

// Find 查找单个API
func (api *SysApi) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().WithContext(ctx).Scopes(funcs...).First(api).Error
	if err == gorm.ErrRecordNotFound {
		err = nil // 将记录未找到的错误转换为nil，通过IsEmpty()方法判断
	}
	return
}

// SysApiList API列表
type SysApiList []*SysApi

// NewSysApiList 创建新的SysApiList实例
func NewSysApiList() SysApiList {
	return SysApiList{}
}

// IsEmpty 检查API列表是否为空
func (list SysApiList) IsEmpty() bool {
	return len(list) == 0
}

// Find 查找API列表
func (list *SysApiList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
	return
}

// 返回一个根据id去重的列表
func (list SysApiList) Unique() SysApiList {
	var uniqueList SysApiList
	uniqueMap := make(map[uint]*SysApi)
	for _, api := range list {
		uniqueMap[api.ID] = api
	}
	for _, api := range uniqueMap {
		uniqueList = append(uniqueList, api)
	}
	return uniqueList
}

func (list SysApiList) GetCount(ctx context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().Model(&SysApi{}).WithContext(ctx).Scopes(query...).Count(&count).Error
	if err != nil {
		return 0, err
	}
	return count, nil
}
