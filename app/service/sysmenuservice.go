package service

import (
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"strings"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

// SysMenuService 菜单服务
type SysMenuService struct{}

// NewSysMenuService 创建新的菜单服务实例
func NewSysMenuService() *SysMenuService {
	return &SysMenuService{}
}

// GetAllAncestorRoleIDs 获取角色ID列表及其所有祖先角色ID
func (s *SysMenuService) GetAllAncestorRoleIDs(c *gin.Context, roleIDs []uint) ([]uint, error) {
	// 使用map去重
	allRoleIDs := make(map[uint]bool)
	for _, id := range roleIDs {
		allRoleIDs[id] = true
	}

	// 获取所有角色，用于查找祖先角色
	allRoles := models.NewSysRoleList()
	err := allRoles.Find(c, func(db *gorm.DB) *gorm.DB {
		return db
	})
	if err != nil {
		return nil, err
	}

	// 创建角色ID到角色的映射，方便查找
	roleMap := make(map[uint]*models.SysRole)
	for _, role := range allRoles {
		roleMap[role.ID] = role
	}

	// 对每个角色查找其所有祖先角色
	for _, roleID := range roleIDs {
		// 递归查找祖先角色
		currentRoleID := roleID
		for {
			role, exists := roleMap[currentRoleID]
			if !exists || role.ParentID == 0 {
				break // 没有父角色或父角色ID为0，停止查找
			}

			// 添加祖先角色ID到结果中
			allRoleIDs[role.ParentID] = true
			currentRoleID = role.ParentID
		}
	}

	// 将map转换为slice
	result := make([]uint, 0, len(allRoleIDs))
	for id := range allRoleIDs {
		result = append(result, id)
	}

	return result, nil
}

// ProcessMenuImport 递归处理菜单导入
func (s *SysMenuService) ProcessMenuImport(tx *gorm.DB, menuList models.SysMenuList, parentID uint, idMap map[uint]uint, currentUserID uint) error {
	for _, menu := range menuList {
		// 保存原始ID
		oldID := menu.ID
		oldParentID := menu.ParentID
		// 清空ID，让数据库自动生成新ID
		menu.ID = 0
		menu.ParentID = parentID
		menu.CreatedBy = currentUserID

		// 创建菜单
		err := tx.Omit(clause.Associations).Create(menu).Error
		if err != nil {
			return fmt.Errorf("创建菜单失败: %w", err)
		}
		newMenuID := menu.ID
		// 记录ID映射
		idMap[oldID] = newMenuID

		// 递归处理子菜单
		if len(menu.Children) > 0 {
			err := s.ProcessMenuImport(tx, menu.Children, newMenuID, idMap, currentUserID)
			if err != nil {
				return err
			}
		}

		// 还原ID
		menu.ID = oldID
		// 还原ParentID
		menu.ParentID = oldParentID
	}

	return nil
}

// checkCircularReference 检查是否存在循环引用
func (s *SysMenuService) checkCircularReference(c *gin.Context, currentMenuID uint, parentID uint) error {
	if parentID == 0 {
		return nil // 如果父级ID为0，不需要检查
	}

	// 获取所有菜单用于构建菜单树
	allMenus := models.NewSysMenuList()
	err := allMenus.Find(c, func(db *gorm.DB) *gorm.DB {
		return db
	})
	if err != nil {
		return err
	}

	// 创建菜单ID到菜单的映射
	menuMap := make(map[uint]*models.SysMenu)
	for _, menu := range allMenus {
		menuMap[menu.ID] = menu
	}

	// 从父级菜单开始递归检查，确保没有一条路径最终指向currentMenuID
	var checkParent func(uint) bool
	checkParent = func(menuID uint) bool {
		if menuID == 0 {
			return false // 已到达根节点
		}
		if menuID == currentMenuID {
			return true // 发现循环引用
		}

		menu, exists := menuMap[menuID]
		if !exists {
			return false // 菜单不存在
		}

		// 递归检查父级
		return checkParent(menu.ParentID)
	}

	// 从指定的父级开始检查
	if checkParent(parentID) {
		return fmt.Errorf("不能设置为父级菜单：会导致循环引用")
	}

	return nil
}

// CreateMenuApis 创建菜单关联的API
func (s *SysMenuService) CreateMenuApis(tx *gorm.DB, menuList models.SysMenuList, idMap map[uint]uint, currentUserID uint) error {
	for _, menu := range menuList {
		newMenuID := idMap[menu.ID]

		// 处理关联的API
		if len(menu.Apis) > 0 {
			// 创建API和菜单API关联
			for _, api := range menu.Apis {
				// 检查API是否已存在（根据path和method）
				existingAPI := models.NewSysApi()
				var err error
				//err = existingAPI.Find(tx.Statement.Context, func(d *gorm.DB) *gorm.DB {
				//	return d.Where("path = ? AND method = ?", api.Path, api.Method)
				//})
				//处理SQLServer的兼容性问题
				err = existingAPI.FindByPathAndMethod(tx, api.Path, api.Method)
				if err != nil {
					return fmt.Errorf("查询API失败: %w", err)
				}

				var apiID uint
				if existingAPI.IsEmpty() {
					oldAPIID := api.ID
					oldCreatedBy := api.CreatedBy
					// API不存在，创建新的API
					api.ID = 0 // 清空ID，让数据库自动生成新ID
					api.CreatedBy = currentUserID
					err = tx.Omit(clause.Associations).Create(api).Error
					if err != nil {
						return fmt.Errorf("创建API失败: %w", err)
					}
					apiID = api.ID
					// 还原
					api.ID = oldAPIID
					api.CreatedBy = oldCreatedBy
				} else {
					// API已存在，使用现有的ID
					apiID = existingAPI.ID
				}

				// 创建菜单API关联
				menuApi := models.SysMenuApi{
					MenuID: newMenuID,
					ApiID:  apiID,
				}
				err = tx.FirstOrCreate(&menuApi, menuApi).Error
				if err != nil {
					return fmt.Errorf("创建菜单API关联失败: %w", err)
				}
			}
		}

		// 递归处理子菜单的API
		if len(menu.Children) > 0 {
			err := s.CreateMenuApis(tx, menu.Children, idMap, currentUserID)
			if err != nil {
				return err
			}
		}
	}

	return nil
}

// Import 导入菜单数据
func (s *SysMenuService) Import(c *gin.Context, menuList models.SysMenuList, userID uint) error {
	// 验证菜单数据合法性
	validateTreeErr := menuList.ValidateTree()
	if !validateTreeErr.IsEmpty() {
		return validateTreeErr
	}

	// 获取所有组件文件路径
	componentPaths := menuList.GetAllComponentPaths()
	// 检查组件文件是否存在
	if len(componentPaths) > 0 {
		var componentCount int64
		app.DB().WithContext(c).Model(&models.SysMenu{}).Where("component IN ?", componentPaths).Count(&componentCount)
		if componentCount > 0 {
			return fmt.Errorf("存在重复的组件路径:%s", strings.Join(componentPaths, ","))
		}
	}

	allPermission := menuList.GetAllPermission()
	// 检查权限是否存在
	if len(allPermission) > 0 {
		var permissionCount int64
		app.DB().WithContext(c).Model(&models.SysMenu{}).Where("permission IN ?", allPermission).Count(&permissionCount)
		if permissionCount > 0 {
			return fmt.Errorf("存在重复的权限标识:%s", strings.Join(allPermission, ","))
		}
	}

	// 使用事务处理导入
	err := app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
		// 创建ID映射，用于处理父子关系
		idMap := make(map[uint]uint) // oldID -> newID

		// 递归处理菜单数据
		err := s.ProcessMenuImport(tx, menuList, 0, idMap, userID)
		if err != nil {
			return err
		}

		// 创建菜单API关联
		err = s.CreateMenuApis(tx, menuList, idMap, userID)
		if err != nil {
			return err
		}

		return nil
	})

	return err
}

func (s *SysMenuService) Update(c *gin.Context, req models.SysMenuUpdateRequest) (*models.SysMenu, error) {
	// 检查菜单是否存在
	menu := models.NewSysMenu()
	err := menu.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		return nil, err
	}
	if menu.IsEmpty() {
		return nil, fmt.Errorf("菜单不存在")
	}
	if req.Type == 3 && req.ParentID == 0 {
		return nil, fmt.Errorf("请选择父级菜单")
	}
	if req.Type == 1 || req.Type == 2 {
		// 检查菜单名称是否与其他菜单冲突（排除当前菜单）
		existMenu := models.NewSysMenu()
		err = existMenu.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("name = ? AND id != ?", req.Name, req.ID)
		})
		if err != nil {
			return nil, err
		}
		if !existMenu.IsEmpty() {
			return nil, fmt.Errorf("菜单名称已被其他菜单使用")
		}

		// 检查路由路径是否与其他菜单冲突（排除当前菜单）
		existPath := models.NewSysMenu()
		err = existPath.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("path = ? AND id != ?", req.Path, req.ID)
		})
		if err != nil {
			return nil, err
		}
		if !existPath.IsEmpty() {
			return nil, fmt.Errorf("路由路径已被其他菜单使用")
		}
	}

	// 如果是按钮类型，检查Permission是否与其他按钮重复（排除当前菜单）
	if req.Type == 3 && req.Permission != "" {
		existPermission := models.NewSysMenu()
		err = existPermission.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("permission = ? AND type = 3 AND id != ?", req.Permission, req.ID)
		})
		if err != nil {
			return nil, err
		}
		if !existPermission.IsEmpty() {
			return nil, fmt.Errorf("按钮权限标识已被其他按钮使用")
		}
	}

	// 如果指定了父级ID，检查父级菜单是否存在且不能是自己
	if req.ParentID > 0 {
		if req.ParentID == req.ID {
			return nil, fmt.Errorf("不能将自己设置为父级菜单")
		}

		// 检查是否会导致循环引用
		err = s.checkCircularReference(c, req.ID, req.ParentID)
		if err != nil {
			return nil, err
		}

		parentMenu := models.NewSysMenu()
		err = parentMenu.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", req.ParentID)
		})
		if err != nil {
			return nil, err
		}
		if parentMenu.IsEmpty() {
			return nil, fmt.Errorf("父级菜单不存在")
		}

		// 根据父级类型和当前类型进行权限检查
		switch parentMenu.Type {
		case 1: // 父级是目录
			if req.Type != 1 && req.Type != 2 {
				return nil, fmt.Errorf("目录下只能添加目录或菜单")
			}
		case 2: // 父级是菜单
			if req.Type != 3 {
				return nil, fmt.Errorf("菜单下只能添加按钮")
			}
		case 3: // 父级是按钮
			return nil, fmt.Errorf("按钮下不能添加子项")
		default:
			return nil, fmt.Errorf("未知的父级菜单类型")
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

	err = app.DB().WithContext(c).Save(menu).Error
	if err != nil {
		return nil, err
	}
	return menu, nil
}

// GetAllDescendantIDs 获取菜单的所有子孙ID（包括指定的ID本身）
func (s *SysMenuService) GetAllDescendantIDs(c *gin.Context, menuIDs []uint) ([]uint, error) {
	if len(menuIDs) == 0 {
		return []uint{}, nil
	}

	// 获取所有菜单
	allMenus := models.NewSysMenuList()
	err := allMenus.Find(c, func(db *gorm.DB) *gorm.DB {
		return db
	})
	if err != nil {
		return nil, err
	}

	// 构建菜单树映射
	childrenMap := make(map[uint][]uint)
	for _, menu := range allMenus {
		childrenMap[menu.ParentID] = append(childrenMap[menu.ParentID], menu.ID)
	}

	// 使用map存储所有要删除的ID，避免重复
	allIDs := make(map[uint]bool)

	// 递归函数：收集指定菜单及其所有子孙ID
	var collectDescendants func(uint)
	collectDescendants = func(menuID uint) {
		if allIDs[menuID] {
			return // 已经处理过
		}
		allIDs[menuID] = true

		// 递归处理所有子菜单
		for _, childID := range childrenMap[menuID] {
			collectDescendants(childID)
		}
	}

	// 收集所有指定菜单的子孙ID
	for _, menuID := range menuIDs {
		collectDescendants(menuID)
	}

	// 将map转换为slice
	result := make([]uint, 0, len(allIDs))
	for id := range allIDs {
		result = append(result, id)
	}

	return result, nil
}

// BatchDelete 批量删除菜单及其关联数据，包含了删除api
func (s *SysMenuService) BatchDelete(c *gin.Context, menuIDs []uint) error {
	if len(menuIDs) == 0 {
		return fmt.Errorf("菜单ID列表不能为空")
	}

	// 获取所有子孙ID（包括原始ID）
	allMenuIDs, err := s.GetAllDescendantIDs(c, menuIDs)
	if err != nil {
		return fmt.Errorf("获取菜单子孙ID失败: %w", err)
	}

	if len(allMenuIDs) == 0 {
		return fmt.Errorf("菜单不存在")
	}

	// 检查是否有角色关联这些菜单， 如果有，不能删除
	var roleMenuCount int64
	err = app.DB().WithContext(c).Model(&models.SysRoleMenu{}).Where("menu_id IN ?", allMenuIDs).Count(&roleMenuCount).Error
	if err != nil {
		return fmt.Errorf("检查角色菜单关联失败: %w", err)
	}

	if roleMenuCount > 0 {
		return fmt.Errorf("存在角色关联这些菜单，无法删除")
	}

	// 使用事务处理批量删除
	err = app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
		// 1. 删除菜单与角色的关联（虽然检查时已经无关联，但保险起见）
		if err := tx.Where("menu_id IN ?", allMenuIDs).Delete(&models.SysRoleMenu{}).Error; err != nil {
			return fmt.Errorf("删除菜单角色关联失败: %w", err)
		}

		// 2. 获取所有与菜单关联的API ID
		var relatedApiIds []uint
		if err := tx.Model(&models.SysMenuApi{}).
			Where("menu_id IN ?", allMenuIDs).
			Distinct("api_id").
			Pluck("api_id", &relatedApiIds).Error; err != nil {
			return fmt.Errorf("查询菜单关联的API失败: %w", err)
		}

		// 3. 在删除菜单API关联之前，先检查这些API是否还有其他菜单关联
		apiIdsToDelete := make([]uint, 0)
		if len(relatedApiIds) > 0 {
			// 查询这些API中，还有其他菜单关联的API ID
			var apiIdsWithRelations []uint
			err := tx.Model(&models.SysMenuApi{}).
				Where("api_id IN ?", relatedApiIds).
				Where("menu_id NOT IN ?", allMenuIDs).
				Distinct("api_id").
				Pluck("api_id", &apiIdsWithRelations).Error
			if err != nil {
				return fmt.Errorf("检查API关联失败: %w", err)
			}

			// 找出没有其他菜单关联的API ID
			relationsMap := make(map[uint]bool)
			for _, id := range apiIdsWithRelations {
				relationsMap[id] = true
			}
			for _, apiId := range relatedApiIds {
				if !relationsMap[apiId] {
					apiIdsToDelete = append(apiIdsToDelete, apiId)
				}
			}
		}
		// 开始删除相关数据
		// 4. 删除菜单与API的关联
		if err := tx.Where("menu_id IN ?", allMenuIDs).Delete(&models.SysMenuApi{}).Error; err != nil {
			return fmt.Errorf("删除菜单API关联失败: %w", err)
		}

		// 5. 批量删除没有其他菜单关联的API
		if len(apiIdsToDelete) > 0 {
			if err := tx.Unscoped().Where("id IN ?", apiIdsToDelete).Delete(&models.SysApi{}).Error; err != nil {
				return fmt.Errorf("删除API失败: %w", err)
			}
		}

		// 6. 硬删除菜单
		if err := tx.Unscoped().Where("id IN ?", allMenuIDs).Delete(&models.SysMenu{}).Error; err != nil {
			return fmt.Errorf("删除菜单失败: %w", err)
		}

		return nil
	})

	return err
}
