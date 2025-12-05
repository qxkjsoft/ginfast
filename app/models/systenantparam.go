package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysTenantAddRequest 新增租户请求结构
type SysTenantAddRequest struct {
	Validator
	Name           string `form:"name" json:"name" validate:"required" message:"租户名称不能为空"`
	Code           string `form:"code" json:"code" validate:"required" message:"租户编码不能为空"`
	Description    string `form:"description" json:"description"`
	Status         int8   `form:"status" json:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	Domain         string `form:"domain" json:"domain"`
	PlatformDomain string `form:"platformDomain" json:"platformDomain"`
}

func (r *SysTenantAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysTenantUpdateRequest 更新租户请求结构
type SysTenantUpdateRequest struct {
	Validator
	ID             uint   `form:"id" json:"id" validate:"required" message:"租户ID不能为空"`
	Name           string `form:"name" json:"name" validate:"required" message:"租户名称不能为空"`
	Code           string `form:"code" json:"code" validate:"required" message:"租户编码不能为空"`
	Description    string `form:"description" json:"description"`
	Status         int8   `form:"status" json:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	Domain         string `form:"domain" json:"domain"`
	PlatformDomain string `form:"platformDomain" json:"platformDomain"`
}

func (r *SysTenantUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysTenantDeleteRequest 删除租户请求结构
type SysTenantDeleteRequest struct {
	Validator
	ID uint `form:"id" json:"id" validate:"required" message:"租户ID不能为空"`
}

func (r *SysTenantDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysTenantListRequest 租户列表查询请求结构
type SysTenantListRequest struct {
	BasePaging
	Validator
	Name   string `form:"name" json:"name"`     // 租户名称，支持模糊查询
	Code   string `form:"code" json:"code"`     // 租户编码，支持模糊查询
	Status *int8  `form:"status" json:"status"` // 状态过滤，使用指针类型允许空值
}

func (r *SysTenantListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *SysTenantListRequest) Handler() func(db *gorm.DB) *gorm.DB {
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

// SysTenantGetRequest 根据ID获取租户请求结构
type SysTenantGetRequest struct {
	Validator
	ID uint `form:"id" json:"id" validate:"required" message:"租户ID不能为空"`
}

func (r *SysTenantGetRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
