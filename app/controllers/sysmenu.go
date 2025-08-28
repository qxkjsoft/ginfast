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

	menuList := models.NewSysMenuList()
	err := menuList.Find(func(db *gorm.DB) *gorm.DB {
		return db.Where("parent_id = ?", 0)
	})
	if err != nil {
		app.Response.Fail(c, "获取菜单失败")
		return
	}
	app.Response.Success(c, menuList)
}
