package service

import (
	"fmt"
	"gin-fast/app/models"

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
				ctx, ok := tx.Statement.Context.(*gin.Context)
				if !ok {
					return fmt.Errorf("上下文不是*gin.Context类型")
				}
				err := existingAPI.Find(ctx, func(d *gorm.DB) *gorm.DB {
					return d.Where("path = ? AND method = ?", api.Path, api.Method)
				})

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
