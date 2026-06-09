package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type SysParamAddRequest struct {
	Validator
	Name        string `form:"name" validate:"required" message:"参数名称不能为空"`
	Code        string `form:"code" validate:"required" message:"参数唯一标识不能为空"`
	Value       string `form:"value"`
	Status      int8   `form:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	Description string `form:"description"`
}

func (r *SysParamAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

type SysParamUpdateRequest struct {
	Validator
	ID          uint   `form:"id" validate:"required" message:"参数ID不能为空"`
	Name        string `form:"name" validate:"required" message:"参数名称不能为空"`
	Code        string `form:"code" validate:"required" message:"参数唯一标识不能为空"`
	Value       string `form:"value"`
	Status      int8   `form:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	Description string `form:"description"`
}

func (r *SysParamUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

type SysParamDeleteRequest struct {
	Validator
	ID uint `form:"id" validate:"required" message:"参数ID不能为空"`
}

func (r *SysParamDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

type SysParamListRequest struct {
	BasePaging
	Validator
	Name   string `form:"name"`
	Code   string `form:"code"`
	Status *int8  `form:"status"`
}

func (r *SysParamListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *SysParamListRequest) Handler() func(db *gorm.DB) *gorm.DB {
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
