package controllers

import (
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/service"
	"gin-fast/app/utils/tenanthelper"
	"strconv"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// SysRoleController 系统角色控制器
// @Summary 系统角色管理API
// @Description 系统角色管理相关接口
// @Tags 角色管理
// @Accept json
// @Produce json
// @Router /sysRole [get]
type SysRoleController struct {
	Common
	CasbinService *service.PermissionService
	RoleService   *service.SysRoleService
}

// NewSysRoleController 创建新的系统角色控制器实例
func NewSysRoleController() *SysRoleController {
	return &SysRoleController{
		Common:        Common{},
		CasbinService: service.NewPermissionService(),
		RoleService:   service.NewSysRoleService(),
	}
}

// GetUserPermission 根据用户ID获取角色菜单权限
// @Summary 根据角色ID获取菜单权限
// @Description 根据角色ID获取该角色拥有的菜单权限
// @Tags 角色管理
// @Accept json
// @Produce json
// @Param roleId path int true "角色ID"
// @Success 200 {object} map[string]interface{} "成功返回角色菜单权限"
// @Failure 400 {object} map[string]interface{} "角色ID格式错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysRole/getUserPermission/{roleId} [get]
// @Security ApiKeyAuth
func (sc *SysRoleController) GetUserPermission(c *gin.Context) {
	roleId, err := strconv.ParseUint(c.Param("roleId"), 10, 64)
	if err != nil {
		sc.FailAndAbort(c, "Invalid role ID", err)
	}
	sysRoleMenuList := models.NewSysRoleMenuList()
	err = sysRoleMenuList.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("role_id = ?", roleId)
	})
	if err != nil {
		sc.FailAndAbort(c, "获取角色菜单权限失败", err)
	}
	sc.Success(c, gin.H{
		"list": sysRoleMenuList.Map(func(m *models.SysRoleMenu) uint {
			return m.MenuID
		}),
	})
}

// GetRoles 获取角色列表（树形结构）
// @Summary 获取角色列表
// @Description 获取所有角色列表（树形结构）
// @Tags 角色管理
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{} "成功返回角色列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysRole/getRoles [get]
// @Security ApiKeyAuth
func (sc *SysRoleController) GetRoles(c *gin.Context) {
	sysRoleList := models.NewSysRoleList()
	err := sysRoleList.Find(c, tenanthelper.TenantScope(c))
	if err != nil {
		sc.FailAndAbort(c, "获取角色列表失败", err)
	}
	if !sysRoleList.IsEmpty() {
		sysRoleList = sysRoleList.BuildTree().TreeSort()
	}
	sc.Success(c, gin.H{
		"list": sysRoleList,
	})
}

// List 角色列表（支持分页和过滤）
// @Summary 角色列表
// @Description 获取角色列表，支持分页和过滤
// @Tags 角色管理
// @Accept json
// @Produce json
// @Param pageNum query int false "页码" default(1)
// @Param pageSize query int false "每页数量" default(10)
// @Param name query string false "角色名称"
// @Success 200 {object} map[string]interface{} "成功返回角色列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysRole/list [get]
// @Security ApiKeyAuth
func (sc *SysRoleController) List(c *gin.Context) {
	var req models.SysRoleListRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 查询列表数据
	sysRoleList := models.NewSysRoleList()

	// 统计总数
	var count int64
	var err error
	count, err = sysRoleList.GetTotal(c, req.Handler(), tenanthelper.TenantScope(c))
	if err != nil {
		sc.FailAndAbort(c, "统计角色数量失败", err)
	}
	err = sysRoleList.Find(c, req.Paginate(), req.Handler(), tenanthelper.TenantScope(c))
	if err != nil {
		sc.FailAndAbort(c, "获取角色列表失败", err)
	}

	sc.Success(c, gin.H{
		"list":  sysRoleList,
		"total": count,
	})
}

// GetByID 根据ID获取角色信息
// @Summary 根据ID获取角色信息
// @Description 根据角色ID获取角色详细信息
// @Tags 角色管理
// @Accept json
// @Produce json
// @Param id path int true "角色ID"
// @Success 200 {object} map[string]interface{} "成功返回角色信息"
// @Failure 400 {object} map[string]interface{} "角色ID格式错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysRole/{id} [get]
// @Security ApiKeyAuth
func (sc *SysRoleController) GetByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		sc.FailAndAbort(c, "角色ID格式错误", err)
	}

	// 查询角色信息
	role := models.NewSysRole()
	err = role.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", uint(id))
	})
	if err != nil {
		sc.FailAndAbort(c, "查询角色失败", err)
	}
	if role.IsEmpty() {
		sc.FailAndAbort(c, "角色不存在", nil)
	}

	sc.Success(c, role)
}

// Add 新增角色
// @Summary 新增角色
// @Description 创建新角色
// @Tags 角色管理
// @Accept json
// @Produce json
// @Param role body models.SysRoleAddRequest true "角色信息"
// @Success 200 {object} map[string]interface{} "角色创建成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysRole/add [post]
// @Security ApiKeyAuth
func (sc *SysRoleController) Add(c *gin.Context) {
	var req models.SysRoleAddRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 检查角色名称是否已存在
	existRole := models.NewSysRole()
	err := existRole.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ?", req.Name)
	})
	if err != nil {
		sc.FailAndAbort(c, "检查角色名称失败", err)
	}
	if !existRole.IsEmpty() {
		sc.FailAndAbort(c, "角色名称已存在", nil)
	}

	// 如果指定了父级ID，检查父级角色是否存在
	if req.ParentID > 0 {
		parentRole := models.NewSysRole()
		err := parentRole.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", req.ParentID)
		})
		if err != nil {
			sc.FailAndAbort(c, "检查父级角色失败", err)
		}
		if parentRole.IsEmpty() {
			sc.FailAndAbort(c, "父级角色不存在", nil)
		}
	}

	// 创建角色
	role := models.NewSysRole()
	role.Name = req.Name
	role.Sort = req.Sort
	role.Status = req.Status
	role.Description = req.Description
	role.ParentID = req.ParentID

	err = app.DB().WithContext(c).Create(role).Error
	if err != nil {
		sc.FailAndAbort(c, "新增角色失败", err)
	}
	// casbin 添加角色继承关系
	if req.ParentID > 0 {
		if err = sc.CasbinService.AddRoleInheritance(c, role.ID, req.ParentID); err != nil {
			sc.FailAndAbort(c, "添加角色继承关系失败", err)
		}
	}
	sc.SuccessWithMessage(c, "角色创建成功", role)
}

// Update 更新角色
// @Summary 更新角色
// @Description 更新角色信息
// @Tags 角色管理
// @Accept json
// @Produce json
// @Param role body models.SysRoleUpdateRequest true "角色信息"
// @Success 200 {object} map[string]interface{} "角色更新成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysRole/edit [put]
// @Security ApiKeyAuth
func (sc *SysRoleController) Update(c *gin.Context) {
	var req models.SysRoleUpdateRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}
	// 更新角色
	role, err := sc.RoleService.Update(c, req)
	if err != nil {
		sc.FailAndAbort(c, "更新角色失败", err)
	}
	sc.SuccessWithMessage(c, "角色更新成功", role)

}

// Delete 删除角色
// @Summary 删除角色
// @Description 删除指定角色
// @Tags 角色管理
// @Accept json
// @Produce json
// @Param id path int true "角色ID"
// @Success 200 {object} map[string]interface{} "角色删除成功"
// @Failure 400 {object} map[string]interface{} "角色ID格式错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysRole/{id} [delete]
// @Security ApiKeyAuth
func (sc *SysRoleController) Delete(c *gin.Context) {
	var req models.SysRoleDeleteRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 检查角色是否存在
	role := models.NewSysRole()
	err := role.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		sc.FailAndAbort(c, "查询角色失败", err)
	}
	if role.IsEmpty() {
		sc.FailAndAbort(c, "角色不存在", nil)
	}

	// 检查是否有子角色
	childRoles := models.NewSysRoleList()
	err = childRoles.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("parent_id = ?", req.ID)
	})
	if err != nil {
		sc.FailAndAbort(c, "检查子角色失败", err)
	}
	if !childRoles.IsEmpty() {
		sc.FailAndAbort(c, "存在子角色，无法删除", nil)
	}

	// 检查是否有用户关联此角色
	var userRoleCount int64
	err = app.DB().WithContext(c).Model(&models.SysUserRole{}).Where("role_id = ?", req.ID).Count(&userRoleCount).Error
	if err != nil {
		sc.FailAndAbort(c, "检查用户角色关联失败", err)
	}
	if userRoleCount > 0 {
		sc.FailAndAbort(c, "存在用户关联此角色，无法删除", nil)
	}

	// 使用事务删除角色和相关数据
	err = app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
		// 删除角色菜单关联
		if err := tx.Where("role_id = ?", req.ID).Delete(&models.SysRoleMenu{}).Error; err != nil {
			return err
		}

		// 软删除角色
		if err := tx.Where("id = ?", req.ID).Delete(role).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		sc.FailAndAbort(c, "删除角色失败", err)
	}
	// 删除角色继承关系
	if err := sc.CasbinService.DeleteRoleInheritance(c, role.ID, role.ParentID); err != nil {
		sc.FailAndAbort(c, "删除角色继承关系失败", err)
	}
	// 删除角色关联的api权限
	if err := sc.CasbinService.DeleteRoleApis(c, role.ID); err != nil {
		sc.FailAndAbort(c, "删除角色关联的api权限失败", err)
	}
	sc.SuccessWithMessage(c, "角色删除成功", nil)
}

// 为角色分配菜单权限
// @Summary 为角色分配菜单权限
// @Description 为指定角色分配菜单权限
// @Tags 角色管理
// @Accept json
// @Produce json
// @Param roleMenu body models.SysRoleMenuAssignRequest true "角色菜单信息"
// @Success 200 {object} map[string]interface{} "分配角色菜单权限成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysRole/addRoleMenu [post]
// @Security ApiKeyAuth
func (sm *SysRoleController) AddRoleMenu(c *gin.Context) {
	var req models.SysRoleMenuAssignRequest
	if err := req.Validate(c); err != nil {
		sm.FailAndAbort(c, err.Error(), err)
	}

	// 检查角色是否存在
	role := models.NewSysRole()
	err := role.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.RoleID)
	})
	if err != nil {
		sm.FailAndAbort(c, "查询角色失败", err)
	}
	if role.IsEmpty() {
		sm.FailAndAbort(c, "角色不存在", nil)
	}

	// 检查菜单ID是否存在 - 优化为批量查询
	menuList := models.NewSysMenuList()
	err = menuList.Find(c, func(db *gorm.DB) *gorm.DB {
		return db.Where("id in ?", req.MenuID).Select("id").Preload("Apis")
	})
	if err != nil {
		sm.FailAndAbort(c, "查询菜单失败", err)
	}

	// 验证所有请求的菜单ID是否都存在
	foundMenuIDs := make(map[uint]bool)
	for _, menu := range menuList {
		foundMenuIDs[menu.ID] = true
	}

	for _, menuID := range req.MenuID {
		if !foundMenuIDs[menuID] {
			sm.FailAndAbort(c, fmt.Sprintf("菜单ID %d 不存在", menuID), nil)
		}
	}

	// 使用事务处理角色菜单权限分配
	err = app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
		// 先删除该角色的所有菜单权限
		if err := tx.Where("role_id = ?", req.RoleID).Delete(&models.SysRoleMenu{}).Error; err != nil {
			app.ZapLog.Error("删除角色菜单权限失败", zap.Error(err), zap.Uint("roleId", req.RoleID))
			return err
		}

		// 批量插入新的角色菜单权限 - 优化为批量操作
		var roleMenus []*models.SysRoleMenu
		for _, menuID := range req.MenuID {
			roleMenus = append(roleMenus, &models.SysRoleMenu{
				RoleID: req.RoleID,
				MenuID: menuID,
			})
		}

		if len(roleMenus) > 0 {
			if err := tx.CreateInBatches(roleMenus, 100).Error; err != nil {
				app.ZapLog.Error("批量插入角色菜单权限失败", zap.Error(err), zap.Uint("roleId", req.RoleID), zap.Any("menuIds", req.MenuID))
				return err
			}
		}

		return nil
	})

	if err != nil {
		sm.FailAndAbort(c, "分配角色菜单权限失败", err)
	}

	// // 调整casbin权限
	apis := menuList.GetApis().Unique()
	if err := sm.CasbinService.AddPoliciesForRole(c, req.RoleID, apis); err != nil {
		sm.FailAndAbort(c, "添加角色权限策略失败", err)
	}
	sm.SuccessWithMessage(c, "分配角色菜单权限成功", nil)
}

// UpdateDataScope 更新角色数据权限
// @Summary 更新角色数据权限
// @Description 更新角色的数据权限
// @Tags 角色管理
// @Accept json
// @Produce json
// @Param roleDataScope body models.SysRoleDataScopeUpdateRequest true "角色数据权限信息"
// @Success 200 {object} map[string]interface{} "角色数据权限更新成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysRole/updateDataScope [put]
// @Security ApiKeyAuth
func (sc *SysRoleController) UpdateDataScope(c *gin.Context) {
	var req models.SysRoleDataScopeUpdateRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 检查角色是否存在
	role := models.NewSysRole()
	err := role.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		sc.FailAndAbort(c, "查询角色失败", err)
	}
	if role.IsEmpty() {
		sc.FailAndAbort(c, "角色不存在", nil)
	}

	// 更新数据权限字段
	role.DataScope = req.DataScope
	role.CheckedDepts = req.CheckedDepts

	err = app.DB().WithContext(c).Save(role).Error
	if err != nil {
		sc.FailAndAbort(c, "更新角色数据权限失败", err)
	}

	sc.SuccessWithMessage(c, "角色数据权限更新成功", role)
}
