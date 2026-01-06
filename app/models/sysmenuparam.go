package models

import "github.com/gin-gonic/gin"

// SysMenuAddRequest 新增菜单请求结构
type SysMenuAddRequest struct {
	Validator
	ParentID   uint   `form:"parentId" json:"parentId" validate:"gte:0" message:"父级ID不能为负数"`
	Path       string `form:"path" json:"path" `
	Name       string `form:"name" json:"name"`
	Component  string `form:"component" json:"component"`
	Title      string `form:"title" json:"title" validate:"required" message:"标题不能为空"`
	IsFull     int8   `form:"isFull" json:"isFull"`
	Hide       int8   `form:"hide" json:"hide"`
	Disable    int8   `form:"disable" json:"disable"`
	KeepAlive  int8   `form:"keepAlive" json:"keepAlive"`
	Affix      int8   `form:"affix" json:"affix"`
	Redirect   string `form:"redirect" json:"redirect"`
	IsLink     int8   `form:"isLink" json:"isLink"`
	Link       string `form:"link" json:"link"`
	Iframe     int8   `form:"iframe" json:"iframe"`
	SvgIcon    string `form:"svgIcon" json:"svgIcon"`
	Icon       string `form:"icon" json:"icon"`
	Sort       int    `form:"sort" json:"sort" validate:"gte:0" message:"排序值不能为负数"`
	Type       int8   `form:"type" json:"type" validate:"required|in:1,2,3" message:"类型必须为1-目录、2-菜单、3-按钮"`
	Permission string `form:"permission" json:"permission"`
}

func (r *SysMenuAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysMenuUpdateRequest 更新菜单请求结构
type SysMenuUpdateRequest struct {
	Validator
	ID         uint   `form:"id" json:"id" validate:"required" message:"菜单ID不能为空"`
	ParentID   uint   `form:"parentId" json:"parentId" validate:"gte:0" message:"父级ID不能为负数"`
	Path       string `form:"path" json:"path"`
	Name       string `form:"name" json:"name"`
	Component  string `form:"component" json:"component"`
	Title      string `form:"title" json:"title" validate:"required" message:"菜单标题不能为空"`
	IsFull     int8   `form:"isFull" json:"isFull"`
	Hide       int8   `form:"hide" json:"hide"`
	Disable    int8   `form:"disable" json:"disable"`
	KeepAlive  int8   `form:"keepAlive" json:"keepAlive"`
	Affix      int8   `form:"affix" json:"affix"`
	Redirect   string `form:"redirect" json:"redirect"`
	IsLink     int8   `form:"isLink" json:"isLink"`
	Link       string `form:"link" json:"link"`
	Iframe     int8   `form:"iframe" json:"iframe"`
	SvgIcon    string `form:"svgIcon" json:"svgIcon"`
	Icon       string `form:"icon" json:"icon"`
	Sort       int    `form:"sort" json:"sort" validate:"gte:0" message:"排序值不能为负数"`
	Type       int8   `form:"type" json:"type" validate:"required|in:1,2,3" message:"类型必须为1-目录、2-菜单、3-按钮"`
	Permission string `form:"permission" json:"permission"`
}

func (r *SysMenuUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysMenuDeleteRequest 删除菜单请求结构
type SysMenuDeleteRequest struct {
	Validator
	ID uint `form:"id" json:"id" validate:"required" message:"菜单ID不能为空"`
}

func (r *SysMenuDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysMenuApiAssignRequest 菜单API关联请求结构
type SysMenuApiAssignRequest struct {
	Validator
	MenuID uint   `form:"menuId" json:"menuId" validate:"required" message:"菜单ID不能为空"`
	ApiIDs []uint `form:"apiIds" json:"apiIds"`
}

func (r *SysMenuApiAssignRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysMenuExportRequest 菜单导出请求结构
type SysMenuExportRequest struct {
	Validator
	MenuIDs []uint `form:"menuIds" json:"menuIds" validate:"required" message:"菜单ID列表不能为空"`
}

func (r *SysMenuExportRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysMenuBatchDeleteRequest 批量删除菜单请求结构
type SysMenuBatchDeleteRequest struct {
	Validator
	MenuIDs []uint `form:"menuIds" json:"menuIds" validate:"required" message:"菜单ID列表不能为空"`
}

func (r *SysMenuBatchDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
