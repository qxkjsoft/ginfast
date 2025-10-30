package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysUserTenantAddRequest 新增用户租户关联请求结构
type SysUserTenantAddRequest struct {
	Validator
	UserID   uint `form:"userID" json:"userID" validate:"required" message:"用户ID不能为空"`
	TenantID uint `form:"tenantID" json:"tenantID" validate:"required" message:"租户ID不能为空"`
}

func (r *SysUserTenantAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysUserTenantUpdateRequest 更新用户租户关联请求结构
type SysUserTenantUpdateRequest struct {
	Validator
	UserID   uint `form:"userID" json:"userID" validate:"required" message:"用户ID不能为空"`
	TenantID uint `form:"tenantID" json:"tenantID" validate:"required" message:"租户ID不能为空"`
}

func (r *SysUserTenantUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysUserTenantDeleteRequest 删除用户租户关联请求结构
type SysUserTenantDeleteRequest struct {
	Validator
	UserID   uint `form:"userID" json:"userID" validate:"required" message:"用户ID不能为空"`
	TenantID uint `form:"tenantID" json:"tenantID" validate:"required" message:"租户ID不能为空"`
}

func (r *SysUserTenantDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysUserTenantListRequest 用户租户关联列表查询请求结构
type SysUserTenantListRequest struct {
	BasePaging
	Validator
	UserID   *uint  `form:"userID" json:"userID"`     // 用户ID过滤
	TenantID *uint  `form:"tenantID" json:"tenantID"` // 租户ID过滤
	Key      string `form:"key" json:"key"`           // 搜索键值, 用户名或用户昵称
}

func (r *SysUserTenantListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *SysUserTenantListRequest) Handler() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.UserID != nil {
			db = db.Where("user_id = ?", *r.UserID)
		}
		if r.TenantID != nil {
			db = db.Where("tenant_id = ?", *r.TenantID)
		}
		// 添加通过用户名或用户昵称查询的功能
		if r.Key != "" {
			// 使用子查询查找匹配的用户ID
			subQuery := db.Session(&gorm.Session{NewDB: true}).Model(&User{}).
				Where("username LIKE ? OR nick_name LIKE ?", "%"+r.Key+"%", "%"+r.Key+"%").
				Select("id")
			db = db.Where("user_id IN (?)", subQuery)
		}
		return db
	}
}

// SysUserTenantGetRequest 根据用户ID和租户ID获取用户租户关联请求结构
type SysUserTenantGetRequest struct {
	Validator
	UserID   uint `form:"userID" json:"userID" validate:"required" message:"用户ID不能为空"`
	TenantID uint `form:"tenantID" json:"tenantID" validate:"required" message:"租户ID不能为空"`
}

func (r *SysUserTenantGetRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysUserTenantBatchAddRequest 批量新增用户租户关联请求结构
type SysUserTenantBatchAddRequest struct {
	Validator
	UserIDs  []uint `form:"userIDs" json:"userIDs" validate:"required" message:"用户ID列表不能为空"`
	TenantID uint   `form:"tenantID" json:"tenantID" validate:"required" message:"租户ID不能为空"`
}

func (r *SysUserTenantBatchAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysUserTenantBatchDeleteRequest 批量删除用户租户关联请求结构
type SysUserTenantBatchDeleteRequest struct {
	Validator
	UserIDs  []uint `form:"userIDs" json:"userIDs" validate:"required" message:"用户ID列表不能为空"`
	TenantID uint   `form:"tenantID" json:"tenantID" validate:"required" message:"租户ID不能为空"`
}

func (r *SysUserTenantBatchDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysUserTenantSetRolesRequest 设置用户角色请求结构
type SysUserTenantSetRolesRequest struct {
	Validator
	UserID   uint   `form:"userID" json:"userID" validate:"required" message:"用户ID不能为空"`
	Roles    []uint `form:"roles" json:"roles" validate:"required" message:"角色ID列表不能为空"`
	TenantID uint   `form:"tenantID" json:"tenantID" validate:"required" message:"租户ID不能为空"`
}

func (r *SysUserTenantSetRolesRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysUserTenantGetUserRoleIDsRequest 根据tenant_id和user_id查询角色ID集合请求结构
type SysUserTenantGetUserRoleIDsRequest struct {
	Validator
	UserID   uint `form:"userID" json:"userID" validate:"required" message:"用户ID不能为空"`
	TenantID uint `form:"tenantID" json:"tenantID" validate:"required" message:"租户ID不能为空"`
}

func (r *SysUserTenantGetUserRoleIDsRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
