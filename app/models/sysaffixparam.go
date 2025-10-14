package models

import (
	"mime/multipart"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// ListRequest 文件附件列表请求参数
type ListRequest struct {
	BasePaging
	Validator
	Name  string `json:"name" form:"name"`   // 文件名
	Ftype string `json:"ftype" form:"ftype"` // 文件类型
}

// Validate 验证请求参数
func (r *ListRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// GetQuery 获取查询条件
func (r *ListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.Name != "" {
			db = db.Where("name LIKE ?", "%"+r.Name+"%")
		}
		if r.Ftype != "" {
			db = db.Where("ftype = ?", r.Ftype)
		}
		return db
	}
}

// UploadRequest 上传文件请求参数
type UploadRequest struct {
	Validator
	File *multipart.FileHeader `form:"file" binding:"required"`
}

// Validate 验证请求参数
func (r *UploadRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// AffixDeleteRequest 删除文件请求参数
type AffixDeleteRequest struct {
	Validator
	ID uint `json:"id" form:"id" binding:"required"`
}

// Validate 验证请求参数
func (r *AffixDeleteRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// UpdateNameRequest 修改文件名请求参数
type UpdateNameRequest struct {
	Validator
	ID   uint   `json:"id" form:"id" binding:"required"`
	Name string `json:"name" form:"name" binding:"required"`
}

// Validate 验证请求参数
func (r *UpdateNameRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}
