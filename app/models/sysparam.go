package models

import (
	"context"
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

type SysParam struct {
	BaseModel
	Name        *string `gorm:"column:name;size:255;comment:参数名称" json:"name"`
	Code        *string `gorm:"column:code;size:255;uniqueIndex;comment:参数唯一标识" json:"code"`
	Value       *string `gorm:"column:value;type:text;comment:参数值" json:"value"`
	Status      *int8   `gorm:"column:status;comment:状态" json:"status"`
	Description *string `gorm:"column:description;size:500;comment:描述" json:"description"`
	CreatedBy   *uint   `gorm:"column:created_by;comment:创建人" json:"createdBy"`
}

func (SysParam) TableName() string {
	return "sys_param"
}

func NewSysParam() *SysParam {
	return &SysParam{}
}

type SysParamList []*SysParam

func NewSysParamList() SysParamList {
	return SysParamList{}
}

func (list SysParamList) IsEmpty() bool {
	return len(list) == 0
}

func (list *SysParamList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().WithContext(c).Scopes(funcs...).Find(list).Error
	return
}

func (s *SysParam) IsEmpty() bool {
	return s == nil || s.ID == 0
}

func (s *SysParam) Create(c context.Context) (err error) {
	err = app.DB().WithContext(c).Create(s).Error
	return
}

func (s *SysParam) Update(c context.Context) (err error) {
	err = app.DB().WithContext(c).Save(s).Error
	return
}

func (s *SysParam) Delete(c context.Context) (err error) {
	err = app.DB().WithContext(c).Delete(s).Error
	return
}

func (s *SysParam) FindByID(c context.Context, id uint) (err error) {
	err = app.DB().WithContext(c).Where("id = ?", id).First(s).Error
	return
}

func (s *SysParam) FindByCode(c context.Context, code string) (err error) {
	err = app.DB().WithContext(c).Where("code = ?", code).First(s).Error
	return
}

func FindByCodePrefix(c context.Context, prefix string) (SysParamList, error) {
	list := NewSysParamList()
	err := app.DB().WithContext(c).Where("code LIKE ?", prefix+"%").Find(&list).Error
	return list, err
}
