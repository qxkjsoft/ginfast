package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysDepartmentAddRequest 新增部门请求结构
type SysDepartmentAddRequest struct {
	Validator
	ParentID *uint  `form:"parentId" validate:"gte:0" message:"父级部门ID不能为负数"`
	Name     string `form:"name" validate:"required" message:"部门名称不能为空"`
	Status   *int8  `form:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	Leader   string `form:"leader"`
	Phone    string `form:"phone"`
	Email    string `form:"email" validate:"omitempty,email" message:"邮箱格式不正确"`
	Sort     *int   `form:"sort" validate:"gte:0" message:"排序值不能为负数"`
	Describe string `form:"describe"`
}

func (r *SysDepartmentAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysDepartmentUpdateRequest 更新部门请求结构
type SysDepartmentUpdateRequest struct {
	Validator
	ID       uint   `form:"id" validate:"required" message:"部门ID不能为空"`
	ParentID *uint  `form:"parentId" validate:"gte:0" message:"父级部门ID不能为负数"`
	Name     string `form:"name" validate:"required" message:"部门名称不能为空"`
	Status   *int8  `form:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	Leader   string `form:"leader"`
	Phone    string `form:"phone"`
	Email    string `form:"email" validate:"omitempty,email" message:"邮箱格式不正确"`
	Sort     *int   `form:"sort" validate:"gte:0" message:"排序值不能为负数"`
	Describe string `form:"describe"`
}

func (r *SysDepartmentUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysDepartmentDeleteRequest 删除部门请求结构
type SysDepartmentDeleteRequest struct {
	Validator
	ID uint `form:"id" validate:"required" message:"部门ID不能为空"`
}

func (r *SysDepartmentDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysDepartmentListRequest 部门列表查询请求结构
type SysDepartmentListRequest struct {
	BasePaging
	Validator
	Name     string `form:"name"`     // 部门名称，支持模糊查询
	Status   *int8  `form:"status"`   // 状态过滤，使用指针类型允许空值
	ParentID *uint  `form:"parentId"` // 父级ID过滤，使用指针类型允许空值
	Leader   string `form:"leader"`   // 负责人，支持模糊查询
}

func (r *SysDepartmentListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *SysDepartmentListRequest) Handler() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.Name != "" {
			db = db.Where("name LIKE ?", "%"+r.Name+"%")
		}
		if r.Status != nil {
			db = db.Where("status = ?", r.Status)
		}
		if r.ParentID != nil {
			db = db.Where("parent_id = ?", r.ParentID)
		}
		if r.Leader != "" {
			db = db.Where("leader LIKE ?", "%"+r.Leader+"%")
		}
		return db
	}
}

// SysDepartmentGetRequest 根据ID获取部门请求结构
type SysDepartmentGetRequest struct {
	Validator
	ID uint `form:"id" validate:"required" message:"部门ID不能为空"`
}

func (r *SysDepartmentGetRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
