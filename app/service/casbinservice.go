package service

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"

	"gorm.io/gorm"
)

var CasbinService = &PermissionService{}

type PermissionService struct{}

// 为角色分配资源权限，原有权限会被清除
func (ps *PermissionService) AddPoliciesForRole(roleID uint, sysapilist models.SysApiList) (err error) {
	// 删除该角色的所有权限
	app.CasbinV2.RemoveAllPoliciesForRole(roleID)
	// 如果有API权限，则添加到casbin
	if !sysapilist.IsEmpty() {
		// 构建权限策略列表
		var policies [][]string
		for _, api := range sysapilist {
			// 处理路径中的参数，将 :roleId 等参数转换为 *
			path := api.Path
			// 使用正则表达式替换路径参数为通配符 *
			path = common.ConvertPathToWildcard(path)

			// 构建策略：[obj, act]
			policy := []string{path, api.Method}
			policies = append(policies, policy)
		}

		// 批量添加权限策略
		if err = app.CasbinV2.AddPoliciesForRole(roleID, policies); err != nil {
			return
		}
	}
	return
}

// 添加角色继承关系
func (ps *PermissionService) AddRoleInheritance(roleID uint, parentRoleID uint) (err error) {
	// 添加角色继承关系
	err = app.CasbinV2.AddRoleInheritance(roleID, parentRoleID)
	return
}

// 编辑角色继承关系
func (ps *PermissionService) EditRoleInheritance(roleID uint, parentRoleID uint) (err error) {
	// 删除角色的所有继承关系
	err = app.CasbinV2.DeleteRoleInheritance(roleID, 0)
	if err != nil {
		return
	}
	if parentRoleID > 0 {
		// 添加角色继承关系
		err = app.CasbinV2.AddRoleInheritance(roleID, parentRoleID)
		if err != nil {
			return
		}
	}
	return
}

// 删除角色继承关系
func (ps *PermissionService) DeleteRoleInheritance(roleID uint, parentRoleID uint) (err error) {
	// 删除角色的继承关系
	err = app.CasbinV2.DeleteRoleInheritance(roleID, parentRoleID)
	return
}

// 为用户分配角色
func (ps *PermissionService) AddRoleForUser(userID uint, roles []uint) (err error) {
	// 添加用户角色关系
	err = app.CasbinV2.AddRolesForUserByID(userID, roles)
	return
}

// 编辑用户的角色
func (ps *PermissionService) EditUserRoles(userID uint, roles []uint) (err error) {
	// 删除用户的所有角色
	err = app.CasbinV2.DeleteRolesForUserByID(userID, nil)
	if err != nil {
		return
	}
	// 添加用户角色关系
	err = app.CasbinV2.AddRolesForUserByID(userID, roles)
	return
}

// 删除用户的角色关系
func (ps *PermissionService) DeleteUserRoles(userID uint, roles []uint) (err error) {
	// 删除用户角色关系
	err = app.CasbinV2.DeleteRolesForUserByID(userID, roles)
	return
}

// 根据菜单ID调整与该菜单关联的角色的API权限
func (ps *PermissionService) UpdateRoleApiPermissionsByMenuID(menuID uint) (err error) {
	// 1. 查找与指定菜单ID关联的所有角色
	var roleMenus models.SysRoleMenuList
	if err = roleMenus.Find(func(db *gorm.DB) *gorm.DB {
		return db.Where("menu_id = ?", menuID)
	}); err != nil {
		return
	}

	// 如果没有关联的角色，直接返回
	if roleMenus.IsEmpty() {
		return
	}

	// 提取关联角色ID列表
	roleIDs := roleMenus.Map(func(rm *models.SysRoleMenu) uint {
		return rm.RoleID
	})

	// 2. 为每个关联的角色更新API权限
	for _, roleID := range roleIDs {
		// 查找该角色关联的所有菜单
		var roleMenusForRole models.SysRoleMenuList
		if err = roleMenusForRole.Find(func(db *gorm.DB) *gorm.DB {
			return db.Where("role_id = ?", roleID)
		}); err != nil {
			return
		}

		// 如果角色没有关联任何菜单，则清除该角色的所有API权限
		if roleMenusForRole.IsEmpty() {
			app.CasbinV2.RemoveAllPoliciesForRole(roleID)
			continue
		}

		// 提取菜单ID列表
		menuIDs := make([]uint, len(roleMenusForRole))
		for i, rm := range roleMenusForRole {
			menuIDs[i] = rm.MenuID
		}

		// 查找这些菜单关联的所有API
		var menus models.SysMenuList
		if err = menus.Find(func(db *gorm.DB) *gorm.DB {
			return db.Preload("Apis").Where("id IN ?", menuIDs)
		}); err != nil {
			return
		}

		// 收集所有API（去重）
		var allApis models.SysApiList
		for _, menu := range menus {
			allApis = append(allApis, menu.Apis...)
		}
		// 去重
		allApis = allApis.Unique()

		// 使用已有的 AddPoliciesForRole 方法为角色分配所有关联菜单的API权限
		if err = ps.AddPoliciesForRole(roleID, allApis); err != nil {
			return
		}
	}

	return
}

// 根据API ID调整与该API关联的角色的权限
func (ps *PermissionService) UpdateRoleApiPermissionsByApiID(apiID uint) (err error) {
	// 1. 通过api_id查找关联的menu_id
	var menuIds []uint
	err = app.DB().Model(&models.SysMenuApi{}).Where("api_id = ?", apiID).Pluck("menu_id", &menuIds).Error
	if err != nil {
		return
	}

	// 如果没有关联的菜单，直接返回
	if len(menuIds) == 0 {
		return
	}

	// 2. 通过menu_id查找关联的role_id
	var roleMenus models.SysRoleMenuList
	if err = roleMenus.Find(func(db *gorm.DB) *gorm.DB {
		return db.Where("menu_id IN ?", menuIds)
	}); err != nil {
		return
	}

	// 如果没有关联的角色，直接返回
	if roleMenus.IsEmpty() {
		return
	}

	// 提取关联角色ID列表（去重）
	roleIDSet := make(map[uint]bool)
	for _, rm := range roleMenus {
		roleIDSet[rm.RoleID] = true
	}

	// 3. 为每个关联的角色重新设置casbin权限
	for roleID := range roleIDSet {
		// 查找该角色关联的所有菜单
		var roleMenusForRole models.SysRoleMenuList
		if err = roleMenusForRole.Find(func(db *gorm.DB) *gorm.DB {
			return db.Where("role_id = ?", roleID)
		}); err != nil {
			return
		}

		// 如果角色没有关联任何菜单，则清除该角色的所有API权限
		if roleMenusForRole.IsEmpty() {
			app.CasbinV2.RemoveAllPoliciesForRole(roleID)
			continue
		}

		// 提取菜单ID列表
		menuIDs := make([]uint, len(roleMenusForRole))
		for i, rm := range roleMenusForRole {
			menuIDs[i] = rm.MenuID
		}

		// 查找这些菜单关联的所有API
		var menus models.SysMenuList
		if err = menus.Find(func(db *gorm.DB) *gorm.DB {
			return db.Preload("Apis").Where("id IN ?", menuIDs)
		}); err != nil {
			return
		}

		// 收集所有API（去重）
		var allApis models.SysApiList
		for _, menu := range menus {
			allApis = append(allApis, menu.Apis...)
		}
		// 去重
		allApis = allApis.Unique()

		// 使用已有的 AddPoliciesForRole 方法为角色分配所有关联菜单的API权限
		if err = ps.AddPoliciesForRole(roleID, allApis); err != nil {
			return
		}
	}

	return
}
