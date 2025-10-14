package models

import (
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// ListRequest 示例列表请求参数
type ListRequest struct {
	models.BasePaging
	models.Validator
	Name        string `json:"name" form:"name"`               // 名称
	Description string `json:"description" form:"description"` // 描述
}

// Validate 验证请求参数
func (r *ListRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// Handle 获取查询条件
func (r *ListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.Name != "" {
			db = db.Where("name LIKE ?", "%"+r.Name+"%")
		}
		if r.Description != "" {
			db = db.Where("description LIKE ?", "%"+r.Description+"%")
		}
		return db
	}
}

// CreateRequest 创建示例请求参数
type CreateRequest struct {
	models.Validator
	Name        string `json:"name" binding:"required"`        // 名称
	Description string `json:"description" binding:"required"` // 描述
}

// Validate 验证请求参数
func (r *CreateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// UpdateRequest 更新示例请求参数
type UpdateRequest struct {
	models.Validator
	ID          uint   `json:"id" binding:"required"`          // ID
	Name        string `json:"name" binding:"required"`        // 名称
	Description string `json:"description" binding:"required"` // 描述
}

// Validate 验证请求参数
func (r *UpdateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// DeleteRequest 删除示例请求参数
type DeleteRequest struct {
	models.Validator
	ID uint `json:"id" binding:"required"` // ID
}

// Validate 验证请求参数
func (r *DeleteRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// GetByIDRequest 根据ID获取示例请求参数
type GetByIDRequest struct {
	models.Validator
	ID uint `json:"id" binding:"required"` // ID
}

// Validate 验证请求参数
func (r *GetByIDRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}
