package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/service"
	"gin-fast/app/utils/common"
	"strconv"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type SysMenuController struct {
	Common
}

// GetRouters 获取当前用户有权限的菜单数据不含按钮
func (sm *SysMenuController) GetRouters(c *gin.Context) {
	// 从上下文中获取用户ID
	claims := common.GetClaims(c)
	if claims == nil {
		sm.FailAndAbort(c, "用户未登录", nil)
	}

	// 获取不需要检查权限的用户ID数组
	notCheckUserIds := app.ConfigYml.GetUintSlice("server.notcheckuser")

	// 检查当前用户ID是否在不需要检查权限的数组中
	needCheckPermission := true
	for _, userId := range notCheckUserIds {
		if userId == claims.UserID {
			needCheckPermission = false
			break
		}
	}

	var menuList models.SysMenuList
	var err error

	if !needCheckPermission {
		// 不需要检查权限，直接返回所有菜单数据（不含按钮）
		err = menuList.Find(func(db *gorm.DB) *gorm.DB {
			return db.Where("disable = ?", 0).
				Where("type = 1 or type = 2") // 只返回目录和菜单，不返回按钮
		})
		if err != nil {
			sm.FailAndAbort(c, "获取菜单失败", err)
			return
		}
	} else {
		// 需要检查权限，按原有逻辑处理
		sysUserRoleList := models.NewSysUserRoleList()
		err := sysUserRoleList.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("user_id = ?", claims.UserID)
		})
		if err != nil {
			sm.FailAndAbort(c, "获取用户角色失败", err)
			return
		}

		if sysUserRoleList.IsEmpty() {
			sm.FailAndAbort(c, "用户未分配角色", nil)
			return
		}
		roleIds := sysUserRoleList.Map(func(sur *models.SysUserRole) uint {
			return sur.RoleID
		})
		err = menuList.Find(func(db *gorm.DB) *gorm.DB {
			return db.Where("disable = ?", 0).
				Where("type = 1 or type = 2").
				Where("id in (?)", app.DB().Model(&models.SysRoleMenu{}).Where("role_id in (?)", roleIds).Select("menu_id"))
		})
		if err != nil {
			sm.FailAndAbort(c, "获取菜单失败", err)
			return
		}
	}

	if !menuList.IsEmpty() {
		menuList = menuList.BuildTree().TreeSort()
	}

	sm.Success(c, menuList)
}

// 获取完整的菜单列表
func (sm *SysMenuController) GetMenuList(c *gin.Context) {
	menuList := models.NewSysMenuList()
	err := menuList.Find(func(db *gorm.DB) *gorm.DB {
		return db.Preload("Apis").Where("disable = ?", 0)
	})
	if err != nil {
		sm.FailAndAbort(c, "获取菜单失败", err)
	}

	if !menuList.IsEmpty() {
		menuList = menuList.BuildTree().TreeSort()
	}

	sm.Success(c, menuList)
}

// Add 新增菜单
func (sm *SysMenuController) Add(c *gin.Context) {
	var req models.SysMenuAddRequest
	if err := req.Validate(c); err != nil {
		sm.FailAndAbort(c, err.Error(), err)
	}
	if req.Type == 3 && req.ParentID == 0 {
		sm.FailAndAbort(c, "请选择父级菜单", nil)
	}
	if req.Type == 1 || req.Type == 2 {
		// 检查菜单名称是否已存在
		existMenu := models.NewSysMenu()
		err := existMenu.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("name = ?", req.Name)
		})
		if err != nil {
			sm.FailAndAbort(c, "检查菜单名称失败", err)
		}
		if !existMenu.IsEmpty() {
			sm.FailAndAbort(c, "菜单名称已存在", nil)
		}

		// 检查路由路径是否已存在
		existPath := models.NewSysMenu()
		err = existPath.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("path = ?", req.Path)
		})
		if err != nil {
			sm.FailAndAbort(c, "检查路由路径失败", err)
		}
		if !existPath.IsEmpty() {
			sm.FailAndAbort(c, "路由路径已存在", nil)
		}
	}

	// 如果是按钮类型，检查Permission是否重复
	if req.Type == 3 && req.Permission != "" {
		existPermission := models.NewSysMenu()
		err := existPermission.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("permission = ? AND type = 3", req.Permission)
		})
		if err != nil {
			sm.FailAndAbort(c, "检查按钮权限标识失败", err)
		}
		if !existPermission.IsEmpty() {
			sm.FailAndAbort(c, "按钮权限标识已存在", nil)
		}
	}

	// 如果指定了父级ID，检查父级菜单是否存在
	if req.ParentID > 0 {
		parentMenu := models.NewSysMenu()
		err := parentMenu.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", req.ParentID)
		})
		if err != nil {
			sm.FailAndAbort(c, "检查父级菜单失败", err)
		}
		if parentMenu.IsEmpty() {
			sm.FailAndAbort(c, "父级菜单不存在", nil)
		}

		// 根据父级类型和当前类型进行权限检查
		switch parentMenu.Type {
		case 1: // 父级是目录
			if req.Type != 1 && req.Type != 2 {
				sm.FailAndAbort(c, "目录下只能添加目录或菜单", nil)
			}
		case 2: // 父级是菜单
			if req.Type != 3 {
				sm.FailAndAbort(c, "菜单下只能添加按钮", nil)
			}
		case 3: // 父级是按钮
			sm.FailAndAbort(c, "按钮下不能添加子项", nil)
		default:
			sm.FailAndAbort(c, "未知的父级菜单类型", nil)
		}
	}

	// 创建菜单
	menu := models.NewSysMenu()
	menu.ParentID = req.ParentID
	menu.Path = req.Path
	menu.Name = req.Name
	menu.Component = req.Component
	menu.Title = req.Title
	menu.IsFull = req.IsFull
	menu.Hide = req.Hide
	menu.Disable = req.Disable
	menu.KeepAlive = req.KeepAlive
	menu.Affix = req.Affix
	menu.Redirect = req.Redirect
	menu.IsLink = req.IsLink
	menu.Link = req.Link
	menu.Iframe = req.Iframe
	menu.SvgIcon = req.SvgIcon
	menu.Icon = req.Icon
	menu.Sort = req.Sort
	menu.Type = req.Type
	menu.Permission = req.Permission
	menu.CreatedBy = common.GetCurrentUserID(c)

	err := app.DB().Create(menu).Error
	if err != nil {
		sm.FailAndAbort(c, "新增菜单失败", err)
	}

	sm.SuccessWithMessage(c, "菜单创建成功", menu)
}

// Update 更新菜单
func (sm *SysMenuController) Update(c *gin.Context) {
	var req models.SysMenuUpdateRequest
	if err := req.Validate(c); err != nil {
		sm.FailAndAbort(c, err.Error(), err)
	}

	// 检查菜单是否存在
	menu := models.NewSysMenu()
	err := menu.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		sm.FailAndAbort(c, "查询菜单失败", err)
	}
	if menu.IsEmpty() {
		sm.FailAndAbort(c, "菜单不存在", nil)
	}
	if req.Type == 3 && req.ParentID == 0 {
		sm.FailAndAbort(c, "请选择父级菜单", nil)
	}
	if req.Type == 1 || req.Type == 2 {
		// 检查菜单名称是否与其他菜单冲突（排除当前菜单）
		existMenu := models.NewSysMenu()
		err = existMenu.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("name = ? AND id != ?", req.Name, req.ID)
		})
		if err != nil {
			sm.FailAndAbort(c, "检查菜单名称失败", err)
		}
		if !existMenu.IsEmpty() {
			sm.FailAndAbort(c, "菜单名称已被其他菜单使用", nil)
		}

		// 检查路由路径是否与其他菜单冲突（排除当前菜单）
		existPath := models.NewSysMenu()
		err = existPath.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("path = ? AND id != ?", req.Path, req.ID)
		})
		if err != nil {
			sm.FailAndAbort(c, "检查路由路径失败", err)
		}
		if !existPath.IsEmpty() {
			sm.FailAndAbort(c, "路由路径已被其他菜单使用", nil)
		}
	}

	// 如果是按钮类型，检查Permission是否与其他按钮重复（排除当前菜单）
	if req.Type == 3 && req.Permission != "" {
		existPermission := models.NewSysMenu()
		err = existPermission.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("permission = ? AND type = 3 AND id != ?", req.Permission, req.ID)
		})
		if err != nil {
			sm.FailAndAbort(c, "检查按钮权限标识失败", err)
		}
		if !existPermission.IsEmpty() {
			sm.FailAndAbort(c, "按钮权限标识已被其他按钮使用", nil)
		}
	}

	// 如果指定了父级ID，检查父级菜单是否存在且不能是自己
	if req.ParentID > 0 {
		if req.ParentID == req.ID {
			sm.FailAndAbort(c, "不能将自己设置为父级菜单", nil)
		}
		parentMenu := models.NewSysMenu()
		err := parentMenu.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", req.ParentID)
		})
		if err != nil {
			sm.FailAndAbort(c, "检查父级菜单失败", err)
		}
		if parentMenu.IsEmpty() {
			sm.FailAndAbort(c, "父级菜单不存在", nil)
		}

		// 根据父级类型和当前类型进行权限检查
		switch parentMenu.Type {
		case 1: // 父级是目录
			if req.Type != 1 && req.Type != 2 {
				sm.FailAndAbort(c, "目录下只能添加目录或菜单", nil)
			}
		case 2: // 父级是菜单
			if req.Type != 3 {
				sm.FailAndAbort(c, "菜单下只能添加按钮", nil)
			}
		case 3: // 父级是按钮
			sm.FailAndAbort(c, "按钮下不能添加子项", nil)
		default:
			sm.FailAndAbort(c, "未知的父级菜单类型", nil)
		}
	}

	// 更新菜单信息
	menu.ParentID = req.ParentID
	menu.Path = req.Path
	menu.Name = req.Name
	menu.Component = req.Component
	menu.Title = req.Title
	menu.IsFull = req.IsFull
	menu.Hide = req.Hide
	menu.Disable = req.Disable
	menu.KeepAlive = req.KeepAlive
	menu.Affix = req.Affix
	menu.Redirect = req.Redirect
	menu.IsLink = req.IsLink
	menu.Link = req.Link
	menu.Iframe = req.Iframe
	menu.SvgIcon = req.SvgIcon
	menu.Icon = req.Icon
	menu.Sort = req.Sort
	menu.Type = req.Type
	menu.Permission = req.Permission

	err = app.DB().Save(menu).Error
	if err != nil {
		sm.FailAndAbort(c, "更新菜单失败", err)
	}

	sm.SuccessWithMessage(c, "菜单更新成功", menu)
}

// Delete 删除菜单
func (sm *SysMenuController) Delete(c *gin.Context) {
	var req models.SysMenuDeleteRequest
	if err := req.Validate(c); err != nil {
		sm.FailAndAbort(c, err.Error(), err)
	}

	// 检查菜单是否存在
	menu := models.NewSysMenu()
	err := menu.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		sm.FailAndAbort(c, "查询菜单失败", err)
	}
	if menu.IsEmpty() {
		sm.FailAndAbort(c, "菜单不存在", nil)
	}

	// 检查是否有子菜单
	childMenus := models.NewSysMenuList()
	err = childMenus.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("parent_id = ?", req.ID)
	})
	if err != nil {
		sm.FailAndAbort(c, "检查子菜单失败", err)
	}
	if !childMenus.IsEmpty() {
		sm.FailAndAbort(c, "存在子菜单，无法删除", nil)
	}

	// 检查是否有角色关联此菜单
	var roleMenuCount int64
	err = app.DB().Model(&models.SysRoleMenu{}).Where("menu_id = ?", req.ID).Count(&roleMenuCount).Error
	if err != nil {
		sm.FailAndAbort(c, "检查角色菜单关联失败", err)
	}
	if roleMenuCount > 0 {
		sm.FailAndAbort(c, "存在角色关联此菜单，无法删除", nil)
	}

	// 使用事务删除菜单和相关数据
	err = app.DB().Transaction(func(tx *gorm.DB) error {
		// 删除菜单角色关联（保险起见，虽然上面已经检查过）
		if err := tx.Where("menu_id = ?", req.ID).Delete(&models.SysRoleMenu{}).Error; err != nil {
			return err
		}

		// 软删除菜单
		if err := tx.Where("id = ?", req.ID).Delete(menu).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		sm.FailAndAbort(c, "删除菜单失败", err)
	}

	sm.SuccessWithMessage(c, "菜单删除成功", nil)
}

// GetByID 根据ID获取菜单信息
func (sm *SysMenuController) GetByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		sm.FailAndAbort(c, "菜单ID格式错误", err)
	}

	// 查询菜单信息
	menu := models.NewSysMenu()
	err = menu.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", uint(id))
	})
	if err != nil {
		sm.FailAndAbort(c, "查询菜单失败", err)
	}
	if menu.IsEmpty() {
		sm.FailAndAbort(c, "菜单不存在", nil)
	}

	sm.Success(c, menu)
}

// GetMenuApiIds 根据menuId查询api_id集合
func (sm *SysMenuController) GetMenuApiIds(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		sm.FailAndAbort(c, "菜单ID格式错误", err)
	}

	// 检查菜单是否存在
	menu := models.NewSysMenu()
	err = menu.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", uint(id))
	})
	if err != nil {
		sm.FailAndAbort(c, "查询菜单失败", err)
	}
	if menu.IsEmpty() {
		sm.FailAndAbort(c, "菜单不存在", nil)
	}

	// 查询菜单关联的API ID集合
	var apiIds []uint
	err = app.DB().Model(&models.SysMenuApi{}).Where("menu_id = ?", uint(id)).Pluck("api_id", &apiIds).Error
	if err != nil {
		sm.FailAndAbort(c, "查询菜单API关联失败", err)
	}

	sm.Success(c, apiIds)
}

// SetMenuApis 设置菜单关联的API
func (sm *SysMenuController) SetMenuApis(c *gin.Context) {
	var req models.SysMenuApiAssignRequest
	if err := req.Validate(c); err != nil {
		sm.FailAndAbort(c, err.Error(), err)
	}

	// 检查菜单是否存在
	menu := models.NewSysMenu()
	err := menu.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.MenuID)
	})
	if err != nil {
		sm.FailAndAbort(c, "查询菜单失败", err)
	}
	if menu.IsEmpty() {
		sm.FailAndAbort(c, "菜单不存在", nil)
	}

	// 当ApiIDs不为空时，检查API ID是否存在
	if len(req.ApiIDs) > 0 {
		// 检查API ID是否存在 - 优化为批量查询
		var existingApiCount int64
		err = app.DB().Model(&models.SysApi{}).Where("id in ?", req.ApiIDs).Count(&existingApiCount).Error
		if err != nil {
			sm.FailAndAbort(c, "查询API失败", err)
		}

		// 验证所有请求的API ID是否都存在
		if int64(len(req.ApiIDs)) != existingApiCount {
			sm.FailAndAbort(c, "存在不存在的API ID", nil)
		}
	}

	// 使用事务处理菜单API关联分配
	err = app.DB().Transaction(func(tx *gorm.DB) error {
		// 先删除该菜单的所有API关联
		if err := tx.Where("menu_id = ?", req.MenuID).Delete(&models.SysMenuApi{}).Error; err != nil {
			app.ZapLog.Error("删除菜单API关联失败", zap.Error(err), zap.Uint("menuId", req.MenuID))
			return err
		}

		// 当ApiIDs不为空时，批量插入新的菜单API关联
		if len(req.ApiIDs) > 0 {
			// 批量插入新的菜单API关联 - 优化为批量操作
			var menuApis []models.SysMenuApi
			for _, apiID := range req.ApiIDs {
				menuApis = append(menuApis, models.SysMenuApi{
					MenuID: req.MenuID,
					ApiID:  apiID,
				})
			}

			if err := tx.CreateInBatches(menuApis, 100).Error; err != nil {
				app.ZapLog.Error("批量插入菜单API关联失败", zap.Error(err), zap.Uint("menuId", req.MenuID), zap.Any("apiIds", req.ApiIDs))
				return err
			}
		}

		return nil
	})

	if err != nil {
		sm.FailAndAbort(c, "设置菜单API关联失败", err)
	}

	// 调整与菜单关联的角色的API权限
	if err = service.CasbinService.UpdateRoleApiPermissionsByMenuID(req.MenuID); err != nil {
		sm.FailAndAbort(c, "更新角色API权限失败", err)
	}
	// 根据ApiIDs是否为空返回不同的成功消息
	var successMsg string
	if len(req.ApiIDs) == 0 {
		successMsg = "菜单API关联已清空"
	} else {
		successMsg = "设置菜单API关联成功"
	}
	sm.SuccessWithMessage(c, successMsg, nil)
}
