package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"strconv"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// TenantController 租户控制器
type TenantController struct {
	Common
}

// NewTenantController 创建租户控制器
func NewTenantController() *TenantController {
	return &TenantController{
		Common: Common{},
	}
}

// List 租户列表（支持分页和过滤）
// @Summary 租户列表
// @Description 获取租户列表，支持分页和过滤
// @Tags 租户管理
// @Accept json
// @Produce json
// @Param pageNum query int false "页码" default(1)
// @Param pageSize query int false "每页数量" default(10)
// @Param name query string false "租户名称"
// @Param code query string false "租户编码"
// @Param status query int false "状态"
// @Success 200 {object} map[string]interface{} "成功返回租户列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysTenant/list [get]
// @Security ApiKeyAuth
func (tc *TenantController) List(c *gin.Context) {
	var req models.SysTenantListRequest
	if err := req.Validate(c); err != nil {
		tc.FailAndAbort(c, err.Error(), err)
	}

	// 查询列表数据
	tenantList := models.NewTenantList()
	// 统计总数
	total, err := tenantList.GetTotal(c, req.Handler())
	if err != nil {
		tc.FailAndAbort(c, "统计租户数量失败", err)
	}
	err = tenantList.Find(c, req.Paginate(), req.Handler())
	if err != nil {
		tc.FailAndAbort(c, "获取租户列表失败", err)
	}

	tc.Success(c, gin.H{
		"list":  tenantList,
		"total": total,
	})
}

// GetByID 根据ID获取租户信息
// @Summary 根据ID获取租户信息
// @Description 根据租户ID获取租户详细信息
// @Tags 租户管理
// @Accept json
// @Produce json
// @Param id path string true "租户ID(数字格式)"
// @Success 200 {object} map[string]interface{} "成功返回租户信息"
// @Failure 400 {object} map[string]interface{} "租户ID格式错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysTenant/{id} [get]
// @Security ApiKeyAuth
func (tc *TenantController) GetByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		tc.FailAndAbort(c, "租户ID格式错误", err)
	}

	// 查询租户信息
	tenant := models.NewTenant()
	err = tenant.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", uint(id))
	})
	if err != nil {
		tc.FailAndAbort(c, "查询租户失败", err)
	}
	if tenant.IsEmpty() {
		tc.FailAndAbort(c, "租户不存在", nil)
	}

	tc.Success(c, tenant)
}

// Add 新增租户
// @Summary 新增租户
// @Description 创建新租户
// @Tags 租户管理
// @Accept json
// @Produce json
// @Param tenant body models.SysTenantAddRequest true "租户信息"
// @Success 200 {object} map[string]interface{} "租户创建成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysTenant/add [post]
// @Security ApiKeyAuth
func (tc *TenantController) Add(c *gin.Context) {
	var req models.SysTenantAddRequest
	if err := req.Validate(c); err != nil {
		tc.FailAndAbort(c, err.Error(), err)
	}

	// 检查租户编码(二级域名)是否已存在 - Code必须全局唯一
	existTenant := models.NewTenant()
	err := existTenant.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("code = ?", req.Code)
	})
	if err != nil {
		tc.FailAndAbort(c, "检查租户编码失败", err)
	}
	if !existTenant.IsEmpty() {
		tc.FailAndAbort(c, "租户编码已存在", nil)
	}

	// 检查租户名称是否已存在
	existTenant = models.NewTenant()
	err = existTenant.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ?", req.Name)
	})
	if err != nil {
		tc.FailAndAbort(c, "检查租户名称失败", err)
	}
	if !existTenant.IsEmpty() {
		tc.FailAndAbort(c, "租户名称已存在", nil)
	}

	// 检查Domain唯一性（当Domain非空时）
	if req.Domain != "" {
		existTenant = models.NewTenant()
		err = existTenant.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("domain = ?", req.Domain)
		})
		if err != nil {
			tc.FailAndAbort(c, "检查域名失败", err)
		}
		if !existTenant.IsEmpty() {
			tc.FailAndAbort(c, "域名已被其他租户使用", nil)
		}
	}

	// 创建租户
	tenant := models.NewTenant()
	tenant.Name = req.Name
	tenant.Code = req.Code
	tenant.Description = req.Description
	tenant.Status = req.Status
	tenant.Domain = req.Domain
	tenant.PlatformDomain = req.PlatformDomain

	err = app.DB().WithContext(c).Create(tenant).Error
	if err != nil {
		tc.FailAndAbort(c, "新增租户失败", err)
	}

	tc.SuccessWithMessage(c, "租户创建成功", tenant)
}

// Update 更新租户
// @Summary 更新租户
// @Description 更新租户信息
// @Tags 租户管理
// @Accept json
// @Produce json
// @Param tenant body models.SysTenantUpdateRequest true "租户信息"
// @Success 200 {object} map[string]interface{} "租户更新成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysTenant/edit [put]
// @Security ApiKeyAuth
func (tc *TenantController) Update(c *gin.Context) {
	var req models.SysTenantUpdateRequest
	if err := req.Validate(c); err != nil {
		tc.FailAndAbort(c, err.Error(), err)
	}

	// 检查租户是否存在
	tenant := models.NewTenant()
	err := tenant.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		tc.FailAndAbort(c, "查询租户失败", err)
	}
	if tenant.IsEmpty() {
		tc.FailAndAbort(c, "租户不存在", nil)
	}

	// 检查租户编码(二级域名)是否与其他租户冲突（排除当前租户）
	existTenant := models.NewTenant()
	err = existTenant.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("code = ? AND id != ?", req.Code, req.ID)
	})
	if err != nil {
		tc.FailAndAbort(c, "检查租户编码失败", err)
	}
	if !existTenant.IsEmpty() {
		tc.FailAndAbort(c, "租户编码已被其他租户使用", nil)
	}

	// 检查租户名称是否与其他租户冲突（排除当前租户）
	existTenant = models.NewTenant()
	err = existTenant.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ? AND id != ?", req.Name, req.ID)
	})
	if err != nil {
		tc.FailAndAbort(c, "检查租户名称失败", err)
	}
	if !existTenant.IsEmpty() {
		tc.FailAndAbort(c, "租户名称已被其他租户使用", nil)
	}

	// 检查Domain唯一性（当Domain非空时，排除当前租户）
	if req.Domain != "" {
		existTenant = models.NewTenant()
		err = existTenant.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("domain = ? AND id != ?", req.Domain, req.ID)
		})
		if err != nil {
			tc.FailAndAbort(c, "检查域名失败", err)
		}
		if !existTenant.IsEmpty() {
			tc.FailAndAbort(c, "域名已被其他租户使用", nil)
		}
	}

	// 更新租户信息
	tenant.Name = req.Name
	tenant.Code = req.Code
	tenant.Description = req.Description
	tenant.Status = req.Status
	tenant.Domain = req.Domain
	tenant.PlatformDomain = req.PlatformDomain

	err = app.DB().WithContext(c).Save(tenant).Error
	if err != nil {
		tc.FailAndAbort(c, "更新租户失败", err)
	}

	tc.SuccessWithMessage(c, "租户更新成功", tenant)
}

// Delete 删除租户
// @Summary 删除租户
// @Description 删除指定租户
// @Tags 租户管理
// @Accept json
// @Produce json
// @Param id path string true "租户ID(数字格式)"
// @Success 200 {object} map[string]interface{} "租户删除成功"
// @Failure 400 {object} map[string]interface{} "租户ID格式错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysTenant/{id} [delete]
// @Security ApiKeyAuth
func (tc *TenantController) Delete(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		tc.FailAndAbort(c, "租户ID格式错误", err)
	}

	// 检查租户是否存在
	tenant := models.NewTenant()
	err = tenant.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", id)
	})
	if err != nil {
		tc.FailAndAbort(c, "查询租户失败", err)
	}
	if tenant.IsEmpty() {
		tc.FailAndAbort(c, "租户不存在", nil)
	}

	// 使用事务删除租户
	err = app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
		// 软删除租户
		if err := tx.Where("id = ?", id).Delete(tenant).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		tc.FailAndAbort(c, "删除租户失败", err)
	}

	tc.SuccessWithMessage(c, "租户删除成功", nil)
}
