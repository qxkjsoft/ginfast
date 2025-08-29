package models

import (
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysDictItem 系统字典项模型
type SysDictItem struct {
	ID     uint    `gorm:"primarykey" json:"id"`
	Name   *string `gorm:"column:name;size:255;comment:字典项名称" json:"name"`
	Value  *string `gorm:"column:value;size:255;comment:字典项值" json:"value"`
	Status *int8   `gorm:"column:status;comment:状态" json:"status"`
	DictID *uint   `gorm:"column:dict_id;comment:所属字典ID" json:"dictId"`

	// 关联字典表
	Dict *SysDict `gorm:"foreignKey:DictID;references:ID" json:"dict,omitempty"`
}

// TableName 设置表名
func (SysDictItem) TableName() string {
	return "sys_dict_item"
}

func NewSysDictItem() *SysDictItem {
	return &SysDictItem{}
}

type SysDictItemList []*SysDictItem

func NewSysDictItemList() SysDictItemList {
	return SysDictItemList{}
}

func (list SysDictItemList) IsEmpty() bool {
	return len(list) == 0
}

func (list *SysDictItemList) Find(funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).Find(list).Error
	return
}

func (s *SysDictItem) Create() (err error) {
	err = app.DB().Create(s).Error
	return
}

func (s *SysDictItem) Update() (err error) {
	err = app.DB().Save(s).Error
	return
}

func (s *SysDictItem) Delete() (err error) {
	err = app.DB().Delete(s).Error
	return
}

func (s *SysDictItem) FindByID(id uint) (err error) {
	err = app.DB().Where("id = ?", id).First(s).Error
	return
}

func (s *SysDictItem) FindByDictID(dictID uint) (list SysDictItemList, err error) {
	err = app.DB().Where("dict_id = ?", dictID).Find(&list).Error
	return
}

func (s *SysDictItem) FindByDictCode(dictCode string) (list SysDictItemList, err error) {
	err = app.DB().Joins("JOIN sys_dict ON sys_dict_item.dict_id = sys_dict.id").
		Where("sys_dict.code = ?", dictCode).
		Find(&list).Error
	return
}
