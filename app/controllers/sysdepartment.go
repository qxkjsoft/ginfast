package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type SysDepartmentController struct {
}

func (sc *SysDepartmentController) GetDivision(c *gin.Context) {
	sysDepartmentList := models.NewSysDepartmentList()
	err := sysDepartmentList.Find()
	if err != nil {
		app.ZapLog.Error("获取部门列表失败", zap.Error(err))
		app.Response.Fail(c, "获取部门列表失败")
		return
	}
	if !sysDepartmentList.IsEmpty() {
		sysDepartmentList = sysDepartmentList.BuildTree().TreeSort()
	}
	app.Response.Success(c, gin.H{
		"list": sysDepartmentList,
	})
}
