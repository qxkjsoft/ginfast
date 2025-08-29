package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type SysRoleController struct {
}

func (sc *SysRoleController) GetRoles(c *gin.Context) {
	sysRoleList := models.NewSysRoleList()
	err := sysRoleList.Find()
	if err != nil {
		app.ZapLog.Error("获取角色列表失败", zap.Error(err))
		app.Response.Fail(c, "获取角色列表失败")
		return
	}
	if !sysRoleList.IsEmpty() {
		sysRoleList = sysRoleList.BuildTree().TreeSort()
	}
	app.Response.Success(c, gin.H{
		"list": sysRoleList,
	})
}
