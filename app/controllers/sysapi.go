package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/service"
	"strconv"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysApiController 系统API控制器
// @Summary 系统API管理API
// @Description 系统API管理相关接口
// @Tags API管理
// @Accept json
// @Produce json
// @Router /sysApi [get]
type SysApiController struct {
	Common
	CasbinService *service.PermissionService
}

// NewSysApiController 创建系统API控制器
func NewSysApiController() *SysApiController {
	return &SysApiController{
		Common:        Common{},
		CasbinService: service.NewPermissionService(),
	}
}

// List API列表（支持分页和过滤）
// @Summary API列表
// @Description 获取API列表，支持分页和过滤
// @Tags API管理
// @Accept json
// @Produce json
// @Param pageNum query int false "页码" default(1)
// @Param pageSize query int false "每页数量" default(10)
// @Param title query string false "API名称"
// @Param path query string false "API路径"
// @Param method query string false "请求方法"
// @Success 200 {object} map[string]interface{} "成功返回API列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysApi/list [get]
// @Security ApiKeyAuth
func (sc *SysApiController) List(c *gin.Context) {
	var req models.SysApiListRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 查询列表数据
	sysApiList := models.NewSysApiList()
	// 获取总数
	count, err := sysApiList.GetCount(c, req.Handler())
	if err != nil {
		sc.FailAndAbort(c, "统计API数量失败", err)
	}

	err = sysApiList.Find(c, req.Paginate(), req.Handler(), func(d *gorm.DB) *gorm.DB {
		return d.Preload("SysMenuList")
	})
	if err != nil {
		sc.FailAndAbort(c, "获取API列表失败", err)
	}

	sc.Success(c, gin.H{
		"list":  sysApiList,
		"total": count,
	})
}

// GetByID 根据ID获取API信息
// @Summary 根据ID获取API信息
// @Description 根据API ID获取API详细信息
// @Tags API管理
// @Accept json
// @Produce json
// @Param id path int true "API ID"
// @Success 200 {object} map[string]interface{} "成功返回API信息"
// @Failure 400 {object} map[string]interface{} "API ID格式错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysApi/{id} [get]
// @Security ApiKeyAuth
func (sc *SysApiController) GetByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		sc.FailAndAbort(c, "API ID格式错误", err)
	}

	// 查询API信息
	api := models.NewSysApi()
	err = api.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", uint(id))
	})
	if err != nil {
		sc.FailAndAbort(c, "查询API失败", err)
	}
	if api.IsEmpty() {

		sc.FailAndAbort(c, "API不存在", nil)
		return
	}

	sc.Success(c, api)
}

// Add 新增API
// @Summary 新增API
// @Description 创建新API
// @Tags API管理
// @Accept json
// @Produce json
// @Param api body models.SysApiAddRequest true "API信息"
// @Success 200 {object} map[string]interface{} "API创建成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysApi/add [post]
// @Security ApiKeyAuth
func (sc *SysApiController) Add(c *gin.Context) {
	var req models.SysApiAddRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 检查API路径和方法是否已存在
	existApi := models.NewSysApi()
	err := existApi.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("path = ? AND method = ?", req.Path, req.Method)
	})
	if err != nil {
		sc.FailAndAbort(c, "检查API失败", err)
	}
	if !existApi.IsEmpty() {
		sc.FailAndAbort(c, "API路径和方法已存在", nil)
	}

	// 创建API
	api := models.NewSysApi()
	api.Title = req.Title
	api.Path = req.Path
	api.Method = req.Method
	api.ApiGroup = req.ApiGroup

	err = app.DB().WithContext(c).Create(api).Error
	if err != nil {
		sc.FailAndAbort(c, "新增API失败", err)
	}

	sc.SuccessWithMessage(c, "API创建成功", api)
}

// Update 更新API
// @Summary 更新API
// @Description 更新API信息
// @Tags API管理
// @Accept json
// @Produce json
// @Param api body models.SysApiUpdateRequest true "API信息"
// @Success 200 {object} map[string]interface{} "API更新成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysApi/edit [put]
// @Security ApiKeyAuth
func (sc *SysApiController) Update(c *gin.Context) {
	var req models.SysApiUpdateRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 检查API是否存在
	api := models.NewSysApi()
	err := api.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		sc.FailAndAbort(c, "查询API失败", err)
	}
	if api.IsEmpty() {
		sc.FailAndAbort(c, "API不存在", nil)
	}

	// 检查API路径和方法是否与其他API冲突（排除当前API）
	existApi := models.NewSysApi()
	err = existApi.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("path = ? AND method = ? AND id != ?", req.Path, req.Method, req.ID)
	})
	if err != nil {
		sc.FailAndAbort(c, "检查API失败", err)
	}
	if !existApi.IsEmpty() {
		sc.FailAndAbort(c, "API路径和方法已被其他API使用", nil)
	}

	// 更新API信息
	api.Title = req.Title
	api.Path = req.Path
	api.Method = req.Method
	api.ApiGroup = req.ApiGroup

	err = app.DB().WithContext(c).Save(api).Error
	if err != nil {
		sc.FailAndAbort(c, "更新API失败", err)
	}
	err = sc.CasbinService.UpdateRoleApiPermissionsByApiID(c, req.ID)
	if err != nil {
		sc.FailAndAbort(c, "更新角色API权限失败", err)
	}
	sc.SuccessWithMessage(c, "API更新成功", api)
}

// Delete 删除API
// @Summary 删除API
// @Description 删除API
// @Tags API管理
// @Accept json
// @Produce json
// @Param api body models.SysApiDeleteRequest true "API信息"
// @Success 200 {object} map[string]interface{} "API删除成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysApi/delete [delete]
// @Security ApiKeyAuth
func (sc *SysApiController) Delete(c *gin.Context) {
	var req models.SysApiDeleteRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 检查API是否存在
	api := models.NewSysApi()
	err := api.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		sc.FailAndAbort(c, "查询API失败", err)
	}
	if api.IsEmpty() {
		sc.FailAndAbort(c, "API不存在", nil)
	}

	// 检查API是否与菜单有关联
	var menuCount int64
	err = app.DB().WithContext(c).Model(&models.SysMenuApi{}).Where("api_id = ?", req.ID).Count(&menuCount).Error
	if err != nil {
		sc.FailAndAbort(c, "检查API与菜单关联关系失败", err)
	}
	if menuCount > 0 {
		sc.FailAndAbort(c, "该API已被菜单关联，无法删除", nil)
	}

	// 软删除API
	err = app.DB().WithContext(c).Where("id = ?", req.ID).Delete(api).Error
	if err != nil {
		sc.FailAndAbort(c, "删除API失败", err)
	}

	// 刷新角色API权限
	err = sc.CasbinService.UpdateRoleApiPermissionsByApiID(c, req.ID)
	if err != nil {
		sc.FailAndAbort(c, "更新角色API权限失败", err)
	}

	// 移除菜单与API的关联（虽然上面已经检查了没有关联，但为了安全起见还是执行一下）
	err = app.DB().WithContext(c).Where("api_id = ?", req.ID).Delete(&models.SysMenuApi{}).Error
	if err != nil {
		sc.FailAndAbort(c, "删除菜单API关联失败", err)
	}

	sc.SuccessWithMessage(c, "API删除成功", nil)
}
