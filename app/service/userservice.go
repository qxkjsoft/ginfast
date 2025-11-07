package service

import (
	"errors"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type User struct {
}

func NewUserService() *User {
	return &User{}
}

// 获取用户信息(包含角色、权限)
func (u *User) GetUserProfile(c *gin.Context, userID uint) (profile *models.UserProfile, err error) {

	user := models.NewUser()
	err = user.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Preload("Department").Preload("Roles").Where("id = ?", userID)
	})
	if err != nil {
		return
	}
	if user.IsEmpty() {
		err = errors.New("用户不存在")
		return
	}
	// 查询关联角色关联的按钮菜单权限
	permissions := []string{}
	// 跳过权限检查的用户，直接返回所有权限
	if common.IsSkipAuthUser(userID) {
		permissions = append(permissions, "*:*:*")
	} else if !user.Roles.IsEmpty() {
		// 获取用户的所有角色ID
		roleIDs := user.Roles.GetRoleIDs()

		//获取角色ID列表及其所有祖先角色ID
		menuService := NewSysMenuService()
		roleIDs, err = menuService.GetAllAncestorRoleIDs(c, roleIDs)
		if err != nil {
			return
		}

		// 查询角色关联的菜单ID
		roleMenuList := models.NewSysRoleMenuList()
		err = roleMenuList.Find(c, func(db *gorm.DB) *gorm.DB {
			return db.Where("role_id IN ?", roleIDs)
		})
		if err != nil {
			return
		}
		if len(roleMenuList) > 0 {
			// 获取菜单ID列表
			menuIDs := roleMenuList.Map(func(roleMenu *models.SysRoleMenu) uint {
				return roleMenu.MenuID
			})
			// 查询按钮类型的菜单（type=3）
			buttonMenus := models.NewSysMenuList()
			err = buttonMenus.Find(c, func(db *gorm.DB) *gorm.DB {
				return db.Select("permission").Where("id IN ? AND type = ? AND permission !=''", menuIDs, 3)
			})
			if err != nil {
				return
			}
			// 提取权限标识
			permissionSet := make(map[string]bool)
			for _, menu := range buttonMenus {
				permissionSet[menu.Permission] = true
			}
			// 转换为切片
			for permission := range permissionSet {
				permissions = append(permissions, permission)
			}
		}
	}
	profile = &models.UserProfile{
		User:        *user,
		Permissions: permissions,
	}
	return
}
