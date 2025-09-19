package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"
	"strconv"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type SysDictController struct {
	Common
}

// GetAllDicts 获取所有字典数据（包含关联的字典项）
func (sdc *SysDictController) GetAllDicts(c *gin.Context) {
	// 获取所有字典数据
	dictList := models.NewSysDictList()
	err := dictList.Find(func(d *gorm.DB) *gorm.DB {
		return d.Preload("SysDictItems")
	})
	if err != nil {
		sdc.FailAndAbort(c, "获取字典列表失败", err)
		return
	}

	sdc.Success(c, gin.H{
		"list": dictList,
	})
}

// GetDictByCode 根据字典编码获取字典及其字典项
func (sdc *SysDictController) GetDictByCode(c *gin.Context) {
	code := c.Param("code")
	if code == "" {
		sdc.FailAndAbort(c, "字典编码不能为空", nil)
	}

	// 根据编码获取字典
	dict := models.NewSysDict()
	err := dict.FindByCode(code)
	if err != nil {
		sdc.FailAndAbort(c, "字典不存在", err)
	}

	// 获取该字典下的所有字典项
	dictItemModel := models.NewSysDictItem()
	dictItems, err := dictItemModel.FindByDictCode(code)
	if err != nil {
		sdc.FailAndAbort(c, "获取字典项失败", err)
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

	sdc.Success(c, result)
}

// List 字典列表（支持分页和过滤）
func (sdc *SysDictController) List(c *gin.Context) {
	var req models.SysDictListRequest
	if err := req.Validate(c); err != nil {
		sdc.FailAndAbort(c, err.Error(), err)
	}

	// 统计总数
	var count int64
	err := app.DB().Model(&models.SysDict{}).Scopes(req.Handler()).Count(&count).Error
	if err != nil {
		sdc.FailAndAbort(c, "统计字典数量失败", err)
	}

	// 查询列表数据
	dictList := models.NewSysDictList()
	err = dictList.Find(req.Paginate(), req.Handler(), func(d *gorm.DB) *gorm.DB {
		return d.Preload("SysDictItems")
	})
	if err != nil {
		sdc.FailAndAbort(c, "获取字典列表失败", err)
	}

	sdc.Success(c, gin.H{
		"list":  dictList,
		"total": count,
	})
}

// GetByID 根据ID获取字典信息
func (sdc *SysDictController) GetByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		sdc.FailAndAbort(c, "字典ID格式错误", err)
	}

	// 查询字典信息
	dict := models.NewSysDict()
	err = dict.FindByID(uint(id))
	if err != nil {
		sdc.FailAndAbort(c, "查询字典失败", err)
	}

	sdc.Success(c, dict)
}

// Add 新增字典
func (sdc *SysDictController) Add(c *gin.Context) {
	var req models.SysDictAddRequest
	if err := req.Validate(c); err != nil {
		sdc.FailAndAbort(c, err.Error(), err)
	}

	// 检查字典编码是否已存在
	existDict := models.NewSysDict()
	err := existDict.FindByCode(req.Code)
	if err != nil {
		sdc.FailAndAbort(c, "查询字典失败", err)
	}
	if !existDict.IsEmpty() {
		sdc.FailAndAbort(c, "字典编码已存在", nil)
	}

	// 创建字典
	dict := models.NewSysDict()
	dict.Name = &req.Name
	dict.Code = &req.Code
	dict.Status = &req.Status
	dict.Description = &req.Description
	createdBy := common.GetCurrentUserID(c)
	dict.CreatedBy = &createdBy

	err = dict.Create()
	if err != nil {
		sdc.FailAndAbort(c, "新增字典失败", err)
	}

	sdc.SuccessWithMessage(c, "字典创建成功", dict)
}

// Update 更新字典
func (sdc *SysDictController) Update(c *gin.Context) {
	var req models.SysDictUpdateRequest
	if err := req.Validate(c); err != nil {
		sdc.FailAndAbort(c, err.Error(), err)
	}

	// 检查字典是否存在
	dict := models.NewSysDict()
	err := dict.FindByID(req.ID)
	if err != nil {
		sdc.FailAndAbort(c, "字典不存在", err)
	}

	// 检查字典编码是否已被其他字典使用
	existDict := models.NewSysDict()
	err = app.DB().Where("code = ? AND id != ?", req.Code, req.ID).First(existDict).Error
	if err == nil {
		sdc.FailAndAbort(c, "字典编码已被其他字典使用", nil)
	}

	// 更新字典信息
	dict.Name = &req.Name
	dict.Code = &req.Code
	dict.Status = &req.Status
	dict.Description = &req.Description

	err = dict.Update()
	if err != nil {
		sdc.FailAndAbort(c, "更新字典失败", err)
	}

	sdc.SuccessWithMessage(c, "字典更新成功", dict)
}

// Delete 删除字典
func (sdc *SysDictController) Delete(c *gin.Context) {
	var req models.SysDictDeleteRequest
	if err := req.Validate(c); err != nil {
		sdc.FailAndAbort(c, err.Error(), err)
	}

	// 检查字典是否存在
	dict := models.NewSysDict()
	err := dict.FindByID(req.ID)
	if err != nil {
		sdc.FailAndAbort(c, "字典不存在", err)
	}

	// 检查该字典下是否有字典项
	dictItemModel := models.NewSysDictItem()
	dictItems, err := dictItemModel.FindByDictCode(*dict.Code)
	if err == nil && len(dictItems) > 0 {
		sdc.FailAndAbort(c, "该字典下还有字典项，无法删除", nil)
	}

	// 执行删除
	err = dict.Delete()
	if err != nil {
		sdc.FailAndAbort(c, "删除字典失败", err)
	}

	sdc.SuccessWithMessage(c, "字典删除成功", nil)
}
