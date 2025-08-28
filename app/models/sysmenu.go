package models

import (
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysMenu 系统菜单路由模型
type SysMenu struct {
	gorm.Model
	ParentID  uint   `gorm:"column:parent_id;not null;default:0;comment:父级路由ID，顶层为0" json:"parent_id"`
	Path      string `gorm:"column:path;not null;size:255;comment:路由路径" json:"path"`
	Name      string `gorm:"column:name;not null;size:100;comment:路由名称" json:"name"`
	Component string `gorm:"column:component;size:255;comment:组件文件路径" json:"component"`
	Title     string `gorm:"column:title;size:100;comment:菜单标题，国际化key" json:"title"`
	IsFull    bool   `gorm:"column:is_full;default:false;comment:是否全屏显示" json:"is_full"`
	Hide      bool   `gorm:"column:hide;default:false;comment:是否隐藏" json:"hide"`
	Disable   bool   `gorm:"column:disable;default:false;comment:是否停用" json:"disable"`
	KeepAlive bool   `gorm:"column:keep_alive;default:false;comment:是否缓存" json:"keep_alive"`
	Affix     bool   `gorm:"column:affix;default:false;comment:是否固定" json:"affix"`
	Link      string `gorm:"column:link;default:'';size:500;comment:外链地址" json:"link"`
	Iframe    bool   `gorm:"column:iframe;default:false;comment:是否内嵌" json:"iframe"`
	SvgIcon   string `gorm:"column:svg_icon;default:'';size:100;comment:svg图标名称" json:"svg_icon"`
	Icon      string `gorm:"column:icon;default:'';size:100;comment:普通图标名称" json:"icon"`
	Sort      int    `gorm:"column:sort;default:1;comment:排序字段" json:"sort"`
	Type      int8   `gorm:"column:type;default:2;comment:类型：1-目录，2-菜单，3-按钮" json:"type"`
	CreatedBy uint   `gorm:"column:created_by;comment:创建人" json:"created_by"`
}

// TableName 设置表名
func (SysMenu) TableName() string {
	return "sys_menu"
}

func NewSysMenu() *SysMenu {
	return &SysMenu{}
}

type SysMenuList []*SysMenu

func NewSysMenuList() SysMenuList {
	return SysMenuList{}
}

func (sml *SysMenuList) Find(funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.GormDbMysql.Scopes(funcs...).Find(sml).Error
	return
}
