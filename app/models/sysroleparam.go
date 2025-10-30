package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysRoleAddRequest 新增角色请求结构
type SysRoleAddRequest struct {
	Validator
	Name        string `form:"name" validate:"required" message:"角色名称不能为空"`
	Sort        int    `form:"sort" validate:"gte:0" message:"排序值不能为负数"`
	Status      int8   `form:"status" validate:"required|in:0,1" message:"状态值必须为0或1"`
	Description string `form:"description"`
	ParentID    uint   `form:"parentId" validate:"gte:0" message:"父级ID不能为负数"`
}

func (r *SysRoleAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysRoleUpdateRequest 更新角色请求结构
type SysRoleUpdateRequest struct {
	Validator
	ID          uint   `form:"id" validate:"required" message:"角色ID不能为空"`
	Name        string `form:"name" validate:"required" message:"角色名称不能为空"`
	Sort        int    `form:"sort" validate:"gte:0" message:"排序值不能为负数"`
	Status      int8   `form:"status" validate:"in:0,1" message:"状态值必须为0或1"`
	Description string `form:"description"`
	ParentID    uint   `form:"parentId" validate:"gte:0" message:"父级ID不能为负数"`
}

func (r *SysRoleUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysRoleDeleteRequest 删除角色请求结构
type SysRoleDeleteRequest struct {
	Validator
	ID uint `form:"id" validate:"required" message:"角色ID不能为空"`
}

func (r *SysRoleDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysRoleListRequest 角色列表查询请求结构
type SysRoleListRequest struct {
	BasePaging
	Validator
	Name     string `form:"name"`     // 角色名称，支持模糊查询
	Status   *int8  `form:"status"`   // 状态过滤，使用指针类型允许空值
	ParentID *uint  `form:"parentId"` // 父级ID过滤，使用指针类型允许空值
}

func (r *SysRoleListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *SysRoleListRequest) Handler() func(db *gorm.DB) *gorm.DB {
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
		return db
	}
}

// SysRoleGetRequest 根据ID获取角色请求结构
type SysRoleGetRequest struct {
	Validator
	ID uint `form:"id" validate:"required" message:"角色ID不能为空"`
}

func (r *SysRoleGetRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysRoleMenuAssignRequest 角色菜单权限分配请求结构
type SysRoleMenuAssignRequest struct {
	Validator
	RoleID uint   `form:"roleId" json:"roleId" validate:"required" message:"角色ID不能为空"`
	MenuID []uint `form:"menuId" json:"menuId" validate:"required" message:"菜单ID列表不能为空"`
}

func (r *SysRoleMenuAssignRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysRoleDataScopeUpdateRequest 角色数据权限更新请求结构
type SysRoleDataScopeUpdateRequest struct {
	Validator
	ID           uint   `form:"id" json:"id" validate:"required" message:"角色ID不能为空"`
	CheckedDepts string `form:"checkedDepts" json:"checkedDepts"`
	DataScope    int8   `form:"dataScope" json:"dataScope" validate:"required|in:0,1,2,3,4,5" message:"数据权限必须在0-5之间"`
}

func (r *SysRoleDataScopeUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysRoleListAllRequest 角色列表查询请求结构(不进行租户过滤，支持tenant_id查询)
type SysRoleListAllRequest struct {
	Validator
	Status   *int8 `form:"status"`   // 状态过滤，使用指针类型允许空值
	ParentID *uint `form:"parentID"` // 父级ID过滤，使用指针类型允许空值
	TenantID *uint `form:"tenantID"` // 租户ID过滤，使用指针类型允许空值
}

func (r *SysRoleListAllRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *SysRoleListAllRequest) Handler() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.Status != nil {
			db = db.Where("status = ?", r.Status)
		}
		if r.ParentID != nil {
			db = db.Where("parent_id = ?", r.ParentID)
		}
		if r.TenantID != nil {
			db = db.Where("tenant_id = ?", r.TenantID)
		}
		return db
	}
}
