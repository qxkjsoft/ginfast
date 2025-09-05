package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysApiAddRequest 新增API请求结构
type SysApiAddRequest struct {
	Validator
	Title    string `form:"title" json:"title" validate:"required" message:"API名称不能为空"`
	Path     string `form:"path" json:"path" validate:"required" message:"API路径不能为空"`
	Method   string `form:"method" json:"method" validate:"required" message:"请求方法不能为空"`
	ApiGroup string `form:"apiGroup" json:"apiGroup" validate:"required" message:"API分组不能为空"`
	MenuID   uint   `form:"menuId" json:"menuId" validate:"gte:0" message:"菜单ID不能为负数"`
}

func (r *SysApiAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysApiUpdateRequest 更新API请求结构
type SysApiUpdateRequest struct {
	Validator
	ID       uint   `form:"id" json:"id" validate:"required" message:"API ID不能为空"`
	Title    string `form:"title" json:"title" validate:"required" message:"API名称不能为空"`
	Path     string `form:"path" json:"path" validate:"required" message:"API路径不能为空"`
	Method   string `form:"method" json:"method" validate:"required" message:"请求方法不能为空"`
	ApiGroup string `form:"apiGroup" json:"apiGroup" validate:"required" message:"API分组不能为空"`
}

func (r *SysApiUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysApiDeleteRequest 删除API请求结构
type SysApiDeleteRequest struct {
	Validator
	ID uint `form:"id" json:"id" validate:"required" message:"API ID不能为空"`
}

func (r *SysApiDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysApiListRequest API列表查询请求结构
type SysApiListRequest struct {
	BasePaging
	Validator
	Title    string `form:"title"`    // API名称，支持模糊查询
	Path     string `form:"path"`     // API路径，支持模糊查询
	Method   string `form:"method"`   // 请求方法过滤
	ApiGroup string `form:"apiGroup"` // API分组过滤
	MenuID   *uint  `form:"menuId"`   // 菜单ID，用于查询关联的API权限数据
}

func (r *SysApiListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *SysApiListRequest) Handler() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.Title != "" {
			db = db.Where("title LIKE ?", "%"+r.Title+"%")
		}
		if r.Path != "" {
			db = db.Where("path LIKE ?", "%"+r.Path+"%")
		}
		if r.Method != "" {
			db = db.Where("method = ?", r.Method)
		}
		if r.ApiGroup != "" {
			db = db.Where("api_group LIKE ?", "%"+r.ApiGroup+"%")
		}
		// 通过子查询获取与指定菜单ID关联的API数据
		if r.MenuID != nil {
			db = db.Where("id IN (SELECT api_id FROM sys_menu_api WHERE menu_id = ?)", *r.MenuID)
		}
		return db
	}
}

// SysApiGetRequest 根据ID获取API请求结构
type SysApiGetRequest struct {
	Validator
	ID uint `form:"id" validate:"required" message:"API ID不能为空"`
}

func (r *SysApiGetRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
