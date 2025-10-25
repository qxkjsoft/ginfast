package models

import (
	"context"
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

func (list *SysDictItemList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().WithContext(c).Scopes(funcs...).Find(list).Error
	return
}

func (s *SysDictItem) Create(c context.Context) (err error) {
	err = app.DB().WithContext(c).Create(s).Error
	return
}

func (s *SysDictItem) Update(c context.Context) (err error) {
	err = app.DB().WithContext(c).Save(s).Error
	return
}

func (s *SysDictItem) Delete(c context.Context) (err error) {
	err = app.DB().WithContext(c).Delete(s).Error
	return
}

func (s *SysDictItem) FindByID(c context.Context, id uint) (err error) {
	err = app.DB().WithContext(c).Where("id = ?", id).First(s).Error
	return
}

func (s *SysDictItem) FindByDictID(c context.Context, dictID uint) (list SysDictItemList, err error) {
	err = app.DB().WithContext(c).Where("dict_id = ?", dictID).Find(&list).Error
	return
}

func (s *SysDictItem) FindByDictCode(c context.Context, dictCode string) (list SysDictItemList, err error) {
	err = app.DB().WithContext(c).Joins("JOIN sys_dict ON sys_dict_item.dict_id = sys_dict.id").
		Where("sys_dict.code = ?", dictCode).
		Find(&list).Error
	return
}
