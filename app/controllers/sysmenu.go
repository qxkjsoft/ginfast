package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type SysMenuController struct {
}

func (sc *SysMenuController) GetMenu(c *gin.Context) {
	// 从上下文中获取用户ID
	claims := common.GetClaims(c)
	if claims == nil {
		app.Response.Fail(c, "用户未登录")
		return
	}
	sysUserRoleList := models.NewSysUserRoleList()
	err := sysUserRoleList.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("user_id = ?", claims.UserID)
	})
	if err != nil {
		app.Response.Fail(c, "获取用户角色失败")
		return
	}

	if sysUserRoleList.IsEmpty() {
		app.Response.Fail(c, "用户未分配角色")
		return
	}
	roleIds := sysUserRoleList.Map(func(sur *models.SysUserRole) uint {
		return sur.RoleID
	})
	menuList := models.NewSysMenuList()
	err = menuList.Find(func(db *gorm.DB) *gorm.DB {
		return db.Where("disable = ?", 0).Where("id in (?)", app.DB().Model(&models.SysRoleMenu{}).Where("role_id in (?)", roleIds).Select("menu_id"))
	})
	if err != nil {
		app.Response.Fail(c, "获取菜单失败")
		return
	}

	if !menuList.IsEmpty() {
		menuList = menuList.BuildTree().TreeSort()
	}

	app.Response.Success(c, menuList)
}
