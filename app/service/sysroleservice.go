package service

import (
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type SysRoleService struct {
	CasbinService *PermissionService
}

// NewSysRoleService 创建系统角色服务
func NewSysRoleService() *SysRoleService {
	return &SysRoleService{
		CasbinService: NewPermissionService(),
	}
}

func (s *SysRoleService) Update(c *gin.Context, req models.SysRoleUpdateRequest) (*models.SysRole, error) {
	// 检查角色名称是否与其他角色冲突（排除当前角色）
	existRole := models.NewSysRole()
	err := existRole.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ? AND id != ?", req.Name, req.ID)
	})
	if err != nil {
		return nil, err
	}
	if !existRole.IsEmpty() {
		return nil, fmt.Errorf("角色名称已被其他角色使用")
	}

	// 如果指定了父级ID，检查父级角色是否存在且不能是自己
	if req.ParentID > 0 {
		if req.ParentID == req.ID {
			return nil, fmt.Errorf("不能将自己设置为父级角色")
		}
		parentRole := models.NewSysRole()
		err := parentRole.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", req.ParentID)
		})
		if err != nil {
			return nil, err
		}
		if parentRole.IsEmpty() {
			return nil, fmt.Errorf("父级角色不存在")
		}
		// 检查是否会形成循环引用
		if err := s.checkCircularReference(c, req.ID, req.ParentID); err != nil {
			return nil, err
		}
	}

	// 更新角色信息
	role := models.NewSysRole()
	err = role.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		return nil, err
	}
	if role.IsEmpty() {
		return nil, fmt.Errorf("角色不存在")
	}
	role.Name = req.Name
	role.Sort = req.Sort
	role.Status = req.Status
	role.Description = req.Description
	role.ParentID = req.ParentID

	err = app.DB().WithContext(c).Save(role).Error
	if err != nil {
		return nil, err
	}

	// 编辑角色继承关系
	if err := s.CasbinService.EditRoleInheritance(c, role.ID, req.ParentID); err != nil {
		return nil, err
	}
	return role, nil
}

// checkCircularReference 检查是否存在循环引用
func (s *SysRoleService) checkCircularReference(c *gin.Context, currentRoleID uint, parentID uint) error {
	if parentID == 0 {
		return nil // 如果父级ID为0，不需要检查
	}

	// 获取所有角色用于构建角色树
	allRoles := models.NewSysRoleList()
	err := allRoles.Find(c, func(db *gorm.DB) *gorm.DB {
		return db
	})
	if err != nil {
		return err
	}

	// 创建角色ID到角色的映射
	roleMap := make(map[uint]*models.SysRole)
	for _, role := range allRoles {
		roleMap[role.ID] = role
	}

	// 从父级角色开始递归检查，确保没有一条路径最终指向currentRoleID
	var checkParent func(uint) bool
	checkParent = func(roleID uint) bool {
		if roleID == 0 {
			return false // 已到达根节点
		}
		if roleID == currentRoleID {
			return true // 发现循环引用
		}

		role, exists := roleMap[roleID]
		if !exists {
			return false // 角色不存在
		}

		// 递归检查父级
		return checkParent(role.ParentID)
	}

	// 从指定的父级开始检查
	if checkParent(parentID) {
		return fmt.Errorf("不能设置为父级角色：会导致循环引用")
	}

	return nil
}
