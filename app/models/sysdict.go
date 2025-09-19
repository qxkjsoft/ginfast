package models

import (
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysDict 系统字典模型
type SysDict struct {
	BaseModel
	Name        *string `gorm:"column:name;size:255;comment:字典名称" json:"name"`
	Code        *string `gorm:"column:code;size:255;comment:字典编码" json:"code"`
	Status      *int8   `gorm:"column:status;comment:状态" json:"status"`
	Description *string `gorm:"column:description;size:500;comment:描述" json:"description"`
	CreatedBy   *uint   `gorm:"column:created_by;comment:创建人" json:"createdBy"`
	// 关联字典项表 - 一对多关系
	SysDictItems SysDictItemList `gorm:"foreignKey:DictID;references:ID" json:"list"`
}

// TableName 设置表名
func (SysDict) TableName() string {
	return "sys_dict"
}

func NewSysDict() *SysDict {
	return &SysDict{}
}

type SysDictList []*SysDict

func NewSysDictList() SysDictList {
	return SysDictList{}
}

func (list SysDictList) IsEmpty() bool {
	return len(list) == 0
}

func (list *SysDictList) Find(funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).Find(list).Error
	return
}

func (s *SysDict) IsEmpty() bool {
	return s == nil || s.ID == 0
}

func (s *SysDict) Create() (err error) {
	err = app.DB().Create(s).Error
	return
}

func (s *SysDict) Update() (err error) {
	err = app.DB().Save(s).Error
	return
}

func (s *SysDict) Delete() (err error) {
	err = app.DB().Delete(s).Error
	return
}

func (s *SysDict) FindByID(id uint) (err error) {
	err = app.DB().Where("id = ?", id).First(s).Error
	return
}

func (s *SysDict) FindByCode(code string) (err error) {
	err = app.DB().Where("code = ?", code).First(s).Error
	return
}
