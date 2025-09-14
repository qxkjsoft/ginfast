package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysDictAddRequest 新增字典请求结构
type SysDictAddRequest struct {
	Validator
	Name        string `form:"name" validate:"required" message:"字典名称不能为空"`
	Code        string `form:"code" validate:"required" message:"字典编码不能为空"`
	Status      int8   `form:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	Description string `form:"description"`
}

func (r *SysDictAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysDictUpdateRequest 更新字典请求结构
type SysDictUpdateRequest struct {
	Validator
	ID          uint   `form:"id" validate:"required" message:"字典ID不能为空"`
	Name        string `form:"name" validate:"required" message:"字典名称不能为空"`
	Code        string `form:"code" validate:"required" message:"字典编码不能为空"`
	Status      int8   `form:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	Description string `form:"description"`
}

func (r *SysDictUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysDictDeleteRequest 删除字典请求结构
type SysDictDeleteRequest struct {
	Validator
	ID uint `form:"id" validate:"required" message:"字典ID不能为空"`
}

func (r *SysDictDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysDictListRequest 字典列表查询请求结构
type SysDictListRequest struct {
	BasePaging
	Validator
	Name   string `form:"name"`   // 字典名称，支持模糊查询
	Code   string `form:"code"`   // 字典编码，支持模糊查询
	Status *int8  `form:"status"` // 状态过滤，使用指针类型允许空值
}

func (r *SysDictListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *SysDictListRequest) Handler() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.Name != "" {
			db = db.Where("name LIKE ?", "%"+r.Name+"%")
		}
		if r.Code != "" {
			db = db.Where("code LIKE ?", "%"+r.Code+"%")
		}
		if r.Status != nil {
			db = db.Where("status = ?", r.Status)
		}
		return db
	}
}

// SysDictGetRequest 根据ID获取字典请求结构
type SysDictGetRequest struct {
	Validator
	ID uint `form:"id" validate:"required" message:"字典ID不能为空"`
}

func (r *SysDictGetRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
