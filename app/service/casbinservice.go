package service

import (
	"context"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"

	"go.uber.org/zap"
	"gorm.io/gorm"
)

type PermissionService struct{}

// NewPermissionService 创建权限服务
func NewPermissionService() *PermissionService {
	return &PermissionService{}
}

// getDomain 获取当前租户的Casbin域
func getDomain(c context.Context) []string {
	tenantID := common.GetCurrentTenantID(common.TryConvertToGinContext(c))
	if tenantID == 0 {
		return nil
	}
	return []string{app.CasbinV2.PrefixDomain(tenantID)}
}

// handleTenantID 处理租户ID：显式传非0用之，显式传0表示全局租户(nil)，缺省取当前登录用户所处租户
func handleTenantID(c context.Context, tenantID ...uint) []string {
	if len(tenantID) > 0 {
		if tenantID[0] == 0 {
			return nil
		}
		return []string{app.CasbinV2.PrefixDomain(tenantID[0])}
	}
	return getDomain(c)
}

// deleteRoleApis 删除角色的所有权限
// ops 为策略操作目标：全局 enforcer（app.CasbinV2）或 RunWithCasbin 事务闭包内的事务视图
func deleteRoleApis(ops app.CasbinInterf, c context.Context, roleID uint, tenantID ...uint) error {
	domain := handleTenantID(c, tenantID...)

	// 删除该角色的所有权限（失败必须返回错误，保证事务回滚语义）
	return ops.RemoveAllPoliciesForRole(roleID, domain...)
}

// addPoliciesForRole 为角色分配资源权限，原有权限会被清除
func addPoliciesForRole(ops app.CasbinInterf, c context.Context, roleID uint, sysapilist models.SysApiList, tenantID ...uint) error {
	domain := handleTenantID(c, tenantID...)

	// 删除该角色的所有权限（失败必须返回错误，保证事务回滚语义）
	if err := ops.RemoveAllPoliciesForRole(roleID, domain...); err != nil {
		return err
	}
	// 如果有API权限，则添加到casbin
	if sysapilist.IsEmpty() {
		return nil
	}
	// 构建权限策略列表
	var policies [][]string
	for _, api := range sysapilist {
		// 处理路径中的参数，将 :roleId 等参数转换为 *
		path := api.Path
		// 使用正则表达式替换路径参数为通配符 *
		//path = common.ConvertPathToWildcard(path)

		// 构建策略：[obj, act]
		policy := []string{path, api.Method}
		policies = append(policies, policy)
	}
	// 对policies进行去重处理（按obj和act）
	policyMap := make(map[string]bool)
	var deduplicatedPolicies [][]string
	for _, policy := range policies {
		key := policy[0] + "|" + policy[1]
		if !policyMap[key] {
			policyMap[key] = true
			deduplicatedPolicies = append(deduplicatedPolicies, policy)
		}
	}
	// 批量添加权限策略
	return ops.AddPoliciesForRole(roleID, deduplicatedPolicies, domain...)
}

// addRoleInheritance 添加角色继承关系
func addRoleInheritance(ops app.CasbinInterf, c context.Context, roleID uint, parentRoleID uint, tenantID ...uint) error {
	domain := handleTenantID(c, tenantID...)

	// 检查角色是否已继承自父角色
	if roleID == parentRoleID || parentRoleID == 0 {
		app.ZapLog.Warn("child role ID cannot be equal to parent role ID or parent role ID is 0")
		return nil
	}

	// 添加角色继承关系
	return ops.AddRoleInheritance(roleID, parentRoleID, domain...)
}

// editRoleInheritance 编辑角色继承关系
func editRoleInheritance(ops app.CasbinInterf, c context.Context, roleID uint, parentRoleID uint, tenantID ...uint) error {
	domain := handleTenantID(c, tenantID...)

	if roleID == parentRoleID {
		app.ZapLog.Warn("child role ID cannot be equal to parent role ID")
		return nil
	}
	// 删除角色的所有继承关系
	if err := ops.DeleteRoleInheritance(roleID, 0, domain...); err != nil {
		return err
	}
	if parentRoleID > 0 {
		// 添加角色继承关系
		if err := ops.AddRoleInheritance(roleID, parentRoleID, domain...); err != nil {
			return err
		}
	}
	return nil
}

// deleteRoleInheritance 删除角色继承关系
func deleteRoleInheritance(ops app.CasbinInterf, c context.Context, roleID uint, parentRoleID uint, tenantID ...uint) error {
	domain := handleTenantID(c, tenantID...)

	// 检查角色是否已继承自父角色
	if roleID == parentRoleID || parentRoleID == 0 {
		app.ZapLog.Warn("child role ID cannot be equal to parent role ID or parent role ID is 0")
		return nil
	}
	// 删除角色的继承关系
	return ops.DeleteRoleInheritance(roleID, parentRoleID, domain...)
}

// addRoleForUser 为用户分配角色
func addRoleForUser(ops app.CasbinInterf, c context.Context, userID uint, roles []uint, tenantID ...uint) error {
	domain := handleTenantID(c, tenantID...)
	// 添加用户角色关系
	return ops.AddRolesForUserByID(userID, roles, domain...)
}

// editUserRoles 编辑用户的角色
func editUserRoles(ops app.CasbinInterf, c context.Context, userID uint, roles []uint, tenantID ...uint) error {
	domain := handleTenantID(c, tenantID...)
	// 删除用户的所有角色
	if err := ops.DeleteRolesForUserByID(userID, nil, domain...); err != nil {
		return err
	}
	// 添加用户角色关系
	return ops.AddRolesForUserByID(userID, roles, domain...)
}

// deleteUserRoles 删除用户的角色关系
func deleteUserRoles(ops app.CasbinInterf, c context.Context, userID uint, roles []uint, tenantID ...uint) error {
	domain := handleTenantID(c, tenantID...)
	// 删除用户角色关系
	return ops.DeleteRolesForUserByID(userID, roles, domain...)
}

// RunWithCasbin 将业务DB写与casbin策略写包进同一事务：fn 内用 tx 做库写、用 ops 做策略写
// （经 PermissionService.Use(ops) 调用），任一步失败整体回滚；
// 提交成功后刷新全局enforcer内存（失败仅告警，由定期自动重载兜底，数据已一致）
func (ps *PermissionService) RunWithCasbin(c context.Context, fn func(tx *gorm.DB, ops app.CasbinInterf) error) error {
	err := app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
		ops, err := app.CasbinV2.NewTxCasbin(tx)
		if err != nil {
			return err
		}
		return fn(tx, ops)
	})
	if err != nil {
		return err
	}
	if err := app.CasbinV2.ReloadPolicy(); err != nil {
		app.ZapLog.Warn("事务提交后刷新全局casbin策略失败，等待自动重载", zap.Error(err))
	}
	return nil
}

// Use 返回绑定指定casbin操作目标的权限操作视图，用于RunWithCasbin事务闭包内调用，
// 使策略写入与业务表写在同一事务中提交/回滚
func (ps *PermissionService) Use(ops app.CasbinInterf) *ScopedPermissionService {
	return &ScopedPermissionService{ops: ops}
}

// ScopedPermissionService 事务内权限操作视图（目标为绑定事务的casbin enforcer）
type ScopedPermissionService struct {
	ops app.CasbinInterf
}

// DeleteRoleApis 删除角色的所有权限
func (s *ScopedPermissionService) DeleteRoleApis(c context.Context, roleID uint, tenantID ...uint) error {
	return deleteRoleApis(s.ops, c, roleID, tenantID...)
}

// AddPoliciesForRole 为角色分配资源权限，原有权限会被清除
func (s *ScopedPermissionService) AddPoliciesForRole(c context.Context, roleID uint, sysapilist models.SysApiList, tenantID ...uint) error {
	return addPoliciesForRole(s.ops, c, roleID, sysapilist, tenantID...)
}

// AddRoleInheritance 添加角色继承关系
func (s *ScopedPermissionService) AddRoleInheritance(c context.Context, roleID uint, parentRoleID uint, tenantID ...uint) error {
	return addRoleInheritance(s.ops, c, roleID, parentRoleID, tenantID...)
}

// EditRoleInheritance 编辑角色继承关系
func (s *ScopedPermissionService) EditRoleInheritance(c context.Context, roleID uint, parentRoleID uint, tenantID ...uint) error {
	return editRoleInheritance(s.ops, c, roleID, parentRoleID, tenantID...)
}

// DeleteRoleInheritance 删除角色继承关系
func (s *ScopedPermissionService) DeleteRoleInheritance(c context.Context, roleID uint, parentRoleID uint, tenantID ...uint) error {
	return deleteRoleInheritance(s.ops, c, roleID, parentRoleID, tenantID...)
}

// AddRoleForUser 为用户分配角色
func (s *ScopedPermissionService) AddRoleForUser(c context.Context, userID uint, roles []uint, tenantID ...uint) error {
	return addRoleForUser(s.ops, c, userID, roles, tenantID...)
}

// EditUserRoles 编辑用户的角色
func (s *ScopedPermissionService) EditUserRoles(c context.Context, userID uint, roles []uint, tenantID ...uint) error {
	return editUserRoles(s.ops, c, userID, roles, tenantID...)
}

// DeleteUserRoles 删除用户的角色关系
func (s *ScopedPermissionService) DeleteUserRoles(c context.Context, userID uint, roles []uint, tenantID ...uint) error {
	return deleteUserRoles(s.ops, c, userID, roles, tenantID...)
}

// GetDomain 获取当前租户的Casbin域
func (ps *PermissionService) GetDomain(c context.Context) []string {
	return getDomain(c)
}

// PrefixDomain 为租户ID添加域前缀
func (ps *PermissionService) PrefixDomain(tenantID uint) string {
	return app.CasbinV2.PrefixDomain(tenantID)
}

// HandleTenantID 处理租户ID，若未指定则使用当前登录用户所处的租户的ID，返回nil时代表全局租户
func (ps *PermissionService) HandleTenantID(c context.Context, tenantID ...uint) []string {
	return handleTenantID(c, tenantID...)
}

// DeleteRoleApis 删除角色的所有权限
func (ps *PermissionService) DeleteRoleApis(c context.Context, roleID uint, tenantID ...uint) error {
	return deleteRoleApis(app.CasbinV2, c, roleID, tenantID...)
}

// AddPoliciesForRole 为角色分配资源权限，原有权限会被清除
func (ps *PermissionService) AddPoliciesForRole(c context.Context, roleID uint, sysapilist models.SysApiList, tenantID ...uint) error {
	return addPoliciesForRole(app.CasbinV2, c, roleID, sysapilist, tenantID...)
}

// AddRoleInheritance 添加角色继承关系
func (ps *PermissionService) AddRoleInheritance(c context.Context, roleID uint, parentRoleID uint, tenantID ...uint) error {
	return addRoleInheritance(app.CasbinV2, c, roleID, parentRoleID, tenantID...)
}

// EditRoleInheritance 编辑角色继承关系
func (ps *PermissionService) EditRoleInheritance(c context.Context, roleID uint, parentRoleID uint, tenantID ...uint) error {
	return editRoleInheritance(app.CasbinV2, c, roleID, parentRoleID, tenantID...)
}

// DeleteRoleInheritance 删除角色继承关系
func (ps *PermissionService) DeleteRoleInheritance(c context.Context, roleID uint, parentRoleID uint, tenantID ...uint) error {
	return deleteRoleInheritance(app.CasbinV2, c, roleID, parentRoleID, tenantID...)
}

// AddRoleForUser 为用户分配角色
func (ps *PermissionService) AddRoleForUser(c context.Context, userID uint, roles []uint, tenantID ...uint) error {
	return addRoleForUser(app.CasbinV2, c, userID, roles, tenantID...)
}

// EditUserRoles 编辑用户的角色
func (ps *PermissionService) EditUserRoles(c context.Context, userID uint, roles []uint, tenantID ...uint) error {
	return editUserRoles(app.CasbinV2, c, userID, roles, tenantID...)
}

// DeleteUserRoles 删除用户的角色关系
func (ps *PermissionService) DeleteUserRoles(c context.Context, userID uint, roles []uint, tenantID ...uint) error {
	return deleteUserRoles(app.CasbinV2, c, userID, roles, tenantID...)
}

// UpdateRoleApiPermissionsByMenuID 根据菜单ID调整与该菜单关联的角色的API权限
func (ps *PermissionService) UpdateRoleApiPermissionsByMenuID(c context.Context, menuID uint, tenantID ...uint) (err error) {
	//domain := ps.HandleTenantID(c, tenantID...)

	// 1. 查找与指定菜单ID关联的所有角色
	var roleMenus models.SysRoleMenuList
	if err = roleMenus.Find(c, func(db *gorm.DB) *gorm.DB {
		return db.Where("menu_id = ?", menuID).Preload("Role")
	}); err != nil {
		return
	}

	// 如果没有关联的角色，直接返回
	if roleMenus.IsEmpty() {
		return
	}

	// 获取关联角色
	roles := roleMenus.GetRoles()
	// 2. 为每个关联的角色更新API权限
	for _, role := range roles {
		// 查找该角色关联的所有菜单
		var roleMenusForRole models.SysRoleMenuList
		if err = roleMenusForRole.Find(c, func(db *gorm.DB) *gorm.DB {
			return db.Where("role_id = ?", role.ID)
		}); err != nil {
			return
		}
		domain := ps.HandleTenantID(c, role.TenantID)
		// 如果角色没有关联任何菜单，则清除该角色的所有API权限
		if roleMenusForRole.IsEmpty() {
			if err = app.CasbinV2.RemoveAllPoliciesForRole(role.ID, domain...); err != nil {
				return
			}
			continue
		}

		// 提取菜单ID列表
		menuIDs := make([]uint, len(roleMenusForRole))
		for i, rm := range roleMenusForRole {
			menuIDs[i] = rm.MenuID
		}

		// 查找这些菜单关联的所有API
		var menus models.SysMenuList
		if err = menus.Find(c, func(db *gorm.DB) *gorm.DB {
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
		if err = ps.AddPoliciesForRole(c, role.ID, allApis, role.TenantID); err != nil {
			return
		}
	}

	return
}

// UpdateRoleApiPermissionsByApiID 根据API ID调整与该API关联的角色的权限
func (ps *PermissionService) UpdateRoleApiPermissionsByApiID(c context.Context, apiID uint, tenantID ...uint) (err error) {
	domain := ps.HandleTenantID(c, tenantID...)

	// 1. 通过api_id查找关联的menu_id
	var menuIds []uint
	err = app.DB().WithContext(c).Model(&models.SysMenuApi{}).Where("api_id = ?", apiID).Pluck("menu_id", &menuIds).Error
	if err != nil {
		return
	}

	// 如果没有关联的菜单，直接返回
	if len(menuIds) == 0 {
		return
	}

	// 2. 通过menu_id查找关联的role_id
	var roleMenus models.SysRoleMenuList
	if err = roleMenus.Find(c, func(db *gorm.DB) *gorm.DB {
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
		if err = roleMenusForRole.Find(c, func(db *gorm.DB) *gorm.DB {
			return db.Where("role_id = ?", roleID)
		}); err != nil {
			return
		}

		// 如果角色没有关联任何菜单，则清除该角色的所有API权限
		if roleMenusForRole.IsEmpty() {
			if err = app.CasbinV2.RemoveAllPoliciesForRole(roleID, domain...); err != nil {
				return
			}
			continue
		}

		// 提取菜单ID列表
		menuIDs := make([]uint, len(roleMenusForRole))
		for i, rm := range roleMenusForRole {
			menuIDs[i] = rm.MenuID
		}

		// 查找这些菜单关联的所有API
		var menus models.SysMenuList
		if err = menus.Find(c, func(db *gorm.DB) *gorm.DB {
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
		if err = ps.AddPoliciesForRole(c, roleID, allApis, tenantID...); err != nil {
			return
		}
	}

	return
}
