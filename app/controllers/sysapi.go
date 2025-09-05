package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/service"
	"gin-fast/app/utils/common"
	"strconv"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type SysApiController struct {
}

// List API列表（支持分页和过滤）
func (sc *SysApiController) List(c *gin.Context) {
	var req models.SysApiListRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 统计总数
	var count int64
	err := app.DB().Model(&models.SysApi{}).Scopes(req.Handler()).Count(&count).Error
	if err != nil {
		app.ZapLog.Error("统计API数量失败", zap.Error(err))
		app.Response.Fail(c, "统计API数量失败")
		return
	}

	// 查询列表数据
	sysApiList := models.NewSysApiList()
	err = sysApiList.Find(req.Paginate(), req.Handler())
	if err != nil {
		app.ZapLog.Error("获取API列表失败", zap.Error(err))
		app.Response.Fail(c, "获取API列表失败")
		return
	}

	app.Response.Success(c, gin.H{
		"list":  sysApiList,
		"total": count,
	})
}

// GetByID 根据ID获取API信息
func (sc *SysApiController) GetByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		app.ZapLog.Error("API ID格式错误", zap.Error(err))
		app.Response.Fail(c, "API ID格式错误")
		return
	}

	// 查询API信息
	api := models.NewSysApi()
	err = api.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", uint(id))
	})
	if err != nil {
		app.ZapLog.Error("查询API失败", zap.Error(err))
		app.Response.Fail(c, "查询API失败")
		return
	}
	if api.IsEmpty() {
		app.ZapLog.Error("API不存在")
		app.Response.Fail(c, "API不存在")
		return
	}

	app.Response.Success(c, api)
}

// Add 新增API
func (sc *SysApiController) Add(c *gin.Context) {
	var req models.SysApiAddRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查API路径和方法是否已存在
	existApi := models.NewSysApi()
	err := existApi.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("path = ? AND method = ?", req.Path, req.Method)
	})
	if err != nil {
		app.ZapLog.Error("检查API失败", zap.Error(err))
		app.Response.Fail(c, "检查API失败")
		return
	}
	if !existApi.IsEmpty() {
		app.ZapLog.Error("API路径和方法已存在")
		app.Response.Fail(c, "API路径和方法已存在")
		return
	}

	// 创建API
	api := models.NewSysApi()
	api.Title = req.Title
	api.Path = req.Path
	api.Method = req.Method
	api.ApiGroup = req.ApiGroup

	api.CreatedBy = common.GetCurrentUserID(c)

	err = app.DB().Create(api).Error
	if err != nil {
		app.ZapLog.Error("新增API失败", zap.Error(err))
		app.Response.Fail(c, "新增API失败")
		return
	}

	app.Response.Success(c, api, "API创建成功")
}

// Update 更新API
func (sc *SysApiController) Update(c *gin.Context) {
	var req models.SysApiUpdateRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查API是否存在
	api := models.NewSysApi()
	err := api.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		app.ZapLog.Error("查询API失败", zap.Error(err))
		app.Response.Fail(c, "查询API失败")
		return
	}
	if api.IsEmpty() {
		app.ZapLog.Error("API不存在")
		app.Response.Fail(c, "API不存在")
		return
	}

	// 检查API路径和方法是否与其他API冲突（排除当前API）
	existApi := models.NewSysApi()
	err = existApi.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("path = ? AND method = ? AND id != ?", req.Path, req.Method, req.ID)
	})
	if err != nil {
		app.ZapLog.Error("检查API失败", zap.Error(err))
		app.Response.Fail(c, "检查API失败")
		return
	}
	if !existApi.IsEmpty() {
		app.ZapLog.Error("API路径和方法已被其他API使用")
		app.Response.Fail(c, "API路径和方法已被其他API使用")
		return
	}

	// 更新API信息
	api.Title = req.Title
	api.Path = req.Path
	api.Method = req.Method
	api.ApiGroup = req.ApiGroup

	err = app.DB().Save(api).Error
	if err != nil {
		app.ZapLog.Error("更新API失败", zap.Error(err))
		app.Response.Fail(c, "更新API失败")
		return
	}
	err = service.CasbinService.UpdateRoleApiPermissionsByApiID(req.ID)
	if err != nil {
		app.ZapLog.Error("更新角色API权限失败", zap.Error(err))
		app.Response.Fail(c, "更新角色API权限失败")
		return
	}
	app.Response.Success(c, api, "API更新成功")
}

// Delete 删除API
func (sc *SysApiController) Delete(c *gin.Context) {
	var req models.SysApiDeleteRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查API是否存在
	api := models.NewSysApi()
	err := api.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		app.ZapLog.Error("查询API失败", zap.Error(err))
		app.Response.Fail(c, "查询API失败")
		return
	}
	if api.IsEmpty() {
		app.ZapLog.Error("API不存在")
		app.Response.Fail(c, "API不存在")
		return
	}

	// 软删除API
	err = app.DB().Where("id = ?", req.ID).Delete(api).Error
	if err != nil {
		app.ZapLog.Error("删除API失败", zap.Error(err))
		app.Response.Fail(c, "删除API失败")
		return
	}

	// 刷新角色API权限
	err = service.CasbinService.UpdateRoleApiPermissionsByApiID(req.ID)
	if err != nil {
		app.ZapLog.Error("更新角色API权限失败", zap.Error(err))
		app.Response.Fail(c, "更新角色API权限失败")
		return
	}

	// 移除菜单与API的关联
	err = app.DB().Where("api_id = ?", req.ID).Delete(&models.SysMenuApi{}).Error
	if err != nil {
		app.ZapLog.Error("删除菜单API关联失败", zap.Error(err))
		app.Response.Fail(c, "删除菜单API关联失败")
		return
	}

	app.Response.Success(c, nil, "API删除成功")
}
