package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysDictItemAddRequest 新增字典项请求结构
type SysDictItemAddRequest struct {
	Validator
	Name   string `form:"name" validate:"required" message:"字典项名称不能为空"`
	Value  string `form:"value" validate:"required" message:"字典项值不能为空"`
	Status int8   `form:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	DictID uint   `form:"dictId" validate:"required" message:"所属字典ID不能为空"`
}

func (r *SysDictItemAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysDictItemUpdateRequest 更新字典项请求结构
type SysDictItemUpdateRequest struct {
	Validator
	ID     uint   `form:"id" validate:"required" message:"字典项ID不能为空"`
	Name   string `form:"name" validate:"required" message:"字典项名称不能为空"`
	Value  string `form:"value" validate:"required" message:"字典项值不能为空"`
	Status int8   `form:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	DictID uint   `form:"dictId" validate:"required" message:"所属字典ID不能为空"`
}

func (r *SysDictItemUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysDictItemDeleteRequest 删除字典项请求结构
type SysDictItemDeleteRequest struct {
	Validator
	ID uint `form:"id" validate:"required" message:"字典项ID不能为空"`
}

func (r *SysDictItemDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysDictItemListRequest 字典项列表查询请求结构（无分页）
type SysDictItemListRequest struct {
	Validator
	Name   string `form:"name"`   // 字典项名称，支持模糊查询
	Value  string `form:"value"`  // 字典项值，支持模糊查询
	Status *int8  `form:"status"` // 状态过滤，使用指针类型允许空值
	DictID *uint  `form:"dictId"` // 所属字典ID过滤，使用指针类型允许空值
}

func (r *SysDictItemListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *SysDictItemListRequest) Handler() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.Name != "" {
			db = db.Where("name LIKE ?", "%"+r.Name+"%")
		}
		if r.Value != "" {
			db = db.Where("value LIKE ?", "%"+r.Value+"%")
		}
		if r.Status != nil {
			db = db.Where("status = ?", r.Status)
		}
		if r.DictID != nil {
			db = db.Where("dict_id = ?", r.DictID)
		}
		return db
	}
}

// SysDictItemGetRequest 根据ID获取字典项请求结构
type SysDictItemGetRequest struct {
	Validator
	ID uint `form:"id" validate:"required" message:"字典项ID不能为空"`
}

func (r *SysDictItemGetRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
