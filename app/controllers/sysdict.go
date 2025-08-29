package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type SysDictController struct {
}

// GetAllDicts 获取所有字典数据（包含关联的字典项）
func (sdc *SysDictController) GetAllDicts(c *gin.Context) {
	// 获取所有字典数据
	dictList := models.NewSysDictList()
	err := dictList.Find(func(d *gorm.DB) *gorm.DB {
		return d.Preload("SysDictItems")
	})
	if err != nil {
		app.ZapLog.Error("获取字典列表失败", zap.Error(err))
		app.Response.Fail(c, "获取字典列表失败")
		return
	}

	app.Response.Success(c, gin.H{
		"list": dictList,
	})
}

// GetDictByCode 根据字典编码获取字典及其字典项
func (sdc *SysDictController) GetDictByCode(c *gin.Context) {
	code := c.Param("code")
	if code == "" {
		app.Response.Fail(c, "字典编码不能为空")
		return
	}

	// 根据编码获取字典
	dict := models.NewSysDict()
	err := dict.FindByCode(code)
	if err != nil {
		app.ZapLog.Error("字典不存在", zap.Error(err), zap.String("code", code))
		app.Response.Fail(c, "字典不存在")
		return
	}

	// 获取该字典下的所有字典项
	dictItemModel := models.NewSysDictItem()
	dictItems, err := dictItemModel.FindByDictCode(code)
	if err != nil {
		app.ZapLog.Error("获取字典项失败", zap.Error(err), zap.String("code", code))
		app.Response.Fail(c, "获取字典项失败")
		return
	}

	// 构建返回数据结构
	result := map[string]interface{}{
		"id":          dict.ID,
		"name":        dict.Name,
		"code":        dict.Code,
		"status":      dict.Status,
		"description": dict.Description,
		"createdBy":   dict.CreatedBy,
		"createdAt":   dict.CreatedAt,
		"updatedAt":   dict.UpdatedAt,
		"items":       dictItems,
	}

	app.Response.Success(c, result)
}
