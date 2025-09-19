package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"strconv"

	"github.com/gin-gonic/gin"
)

type SysDictItemController struct {
	Common
}

// List 字典项列表（无分页）
func (sdic *SysDictItemController) List(c *gin.Context) {
	var req models.SysDictItemListRequest
	if err := req.Validate(c); err != nil {
		sdic.FailAndAbort(c, err.Error(), err)
	}

	// 查询列表数据（无分页）
	dictItemList := models.NewSysDictItemList()
	err := dictItemList.Find(req.Handler())
	if err != nil {
		sdic.FailAndAbort(c, "获取字典项列表失败", err)
	}

	sdic.Success(c, gin.H{
		"list": dictItemList,
	})
}

// GetByID 根据ID获取字典项信息
func (sdic *SysDictItemController) GetByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		sdic.FailAndAbort(c, "字典项ID格式错误", err)
	}

	// 查询字典项信息
	dictItem := models.NewSysDictItem()
	err = dictItem.FindByID(uint(id))
	if err != nil {
		sdic.FailAndAbort(c, "查询字典项失败", err)
	}

	sdic.Success(c, dictItem)
}

// Add 新增字典项
func (sdic *SysDictItemController) Add(c *gin.Context) {
	var req models.SysDictItemAddRequest
	if err := req.Validate(c); err != nil {
		sdic.FailAndAbort(c, err.Error(), err)
	}

	// 检查所属字典是否存在
	dict := models.NewSysDict()
	err := dict.FindByID(req.DictID)
	if err != nil {
		sdic.FailAndAbort(c, "所属字典不存在", err)
	}

	// 检查同一字典下字典项值是否已存在
	var count int64
	err = app.DB().Model(&models.SysDictItem{}).
		Where("dict_id = ? AND value = ?", req.DictID, req.Value).
		Count(&count).Error
	if err != nil {
		sdic.FailAndAbort(c, "检查字典项值失败", err)
	}
	if count > 0 {
		sdic.FailAndAbort(c, "该字典下字典项值已存在", nil)
	}

	// 创建字典项
	dictItem := models.NewSysDictItem()
	dictItem.Name = &req.Name
	dictItem.Value = &req.Value
	dictItem.Status = &req.Status
	dictItem.DictID = &req.DictID

	err = dictItem.Create()
	if err != nil {
		sdic.FailAndAbort(c, "新增字典项失败", err)
	}

	sdic.SuccessWithMessage(c, "字典项创建成功", dictItem)
}

// Update 更新字典项
func (sdic *SysDictItemController) Update(c *gin.Context) {
	var req models.SysDictItemUpdateRequest
	if err := req.Validate(c); err != nil {
		sdic.FailAndAbort(c, err.Error(), err)
	}

	// 检查字典项是否存在
	dictItem := models.NewSysDictItem()
	err := dictItem.FindByID(req.ID)
	if err != nil {
		sdic.FailAndAbort(c, "字典项不存在", err)
	}

	// 检查所属字典是否存在
	dict := models.NewSysDict()
	err = dict.FindByID(req.DictID)
	if err != nil {
		sdic.FailAndAbort(c, "所属字典不存在", err)
	}

	// 检查同一字典下字典项值是否已被其他字典项使用
	var count int64
	err = app.DB().Model(&models.SysDictItem{}).
		Where("dict_id = ? AND value = ? AND id != ?", req.DictID, req.Value, req.ID).
		Count(&count).Error
	if err != nil {
		sdic.FailAndAbort(c, "检查字典项值失败", err)
	}
	if count > 0 {
		sdic.FailAndAbort(c, "该字典下字典项值已被其他字典项使用", nil)
	}

	// 更新字典项信息
	dictItem.Name = &req.Name
	dictItem.Value = &req.Value
	dictItem.Status = &req.Status
	dictItem.DictID = &req.DictID

	err = dictItem.Update()
	if err != nil {
		sdic.FailAndAbort(c, "更新字典项失败", err)
	}

	sdic.SuccessWithMessage(c, "字典项更新成功", dictItem)
}

// Delete 删除字典项
func (sdic *SysDictItemController) Delete(c *gin.Context) {
	var req models.SysDictItemDeleteRequest
	if err := req.Validate(c); err != nil {
		sdic.FailAndAbort(c, err.Error(), err)
	}

	// 检查字典项是否存在
	dictItem := models.NewSysDictItem()
	err := dictItem.FindByID(req.ID)
	if err != nil {
		sdic.FailAndAbort(c, "字典项不存在", err)
	}

	// 执行删除
	err = dictItem.Delete()
	if err != nil {
		sdic.FailAndAbort(c, "删除字典项失败", err)
	}

	sdic.SuccessWithMessage(c, "字典项删除成功", nil)
}

// GetByDictID 根据字典ID获取字典项列表
func (sdic *SysDictItemController) GetByDictID(c *gin.Context) {
	// 获取路径参数
	dictIdStr := c.Param("dictId")
	dictId, err := strconv.Atoi(dictIdStr)
	if err != nil {
		sdic.FailAndAbort(c, "字典ID格式错误", err)
	}

	// 检查字典是否存在
	dict := models.NewSysDict()
	err = dict.FindByID(uint(dictId))
	if err != nil {
		sdic.FailAndAbort(c, "字典不存在", err)
	}

	// 查询字典项列表
	dictItem := models.NewSysDictItem()
	dictItems, err := dictItem.FindByDictID(uint(dictId))
	if err != nil {
		sdic.FailAndAbort(c, "获取字典项列表失败", err)
	}

	sdic.Success(c, gin.H{
		"list": dictItems,
	})
}

// GetByDictCode 根据字典编码获取字典项列表
func (sdic *SysDictItemController) GetByDictCode(c *gin.Context) {
	// 获取路径参数
	dictCode := c.Param("dictCode")
	if dictCode == "" {
		sdic.FailAndAbort(c, "字典编码不能为空", nil)
	}

	// 检查字典是否存在
	dict := models.NewSysDict()
	err := dict.FindByCode(dictCode)
	if err != nil {
		sdic.FailAndAbort(c, "字典不存在", err)
	}

	// 查询字典项列表
	dictItem := models.NewSysDictItem()
	dictItems, err := dictItem.FindByDictCode(dictCode)
	if err != nil {
		sdic.FailAndAbort(c, "获取字典项列表失败", err)
	}

	sdic.Success(c, gin.H{
		"list": dictItems,
	})
}
