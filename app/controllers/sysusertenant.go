package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/service"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysUserTenantController 用户租户关联控制器
type SysUserTenantController struct {
	Common
	CasbinService *service.PermissionService
}

// NewSysUserTenantController 创建用户租户关联控制器
func NewSysUserTenantController() *SysUserTenantController {
	return &SysUserTenantController{
		Common:        Common{},
		CasbinService: service.NewPermissionService(),
	}
}

// List 用户租户关联列表（支持分页和过滤）
// @Summary 用户租户关联列表
// @Description 获取用户租户关联列表，支持分页和过滤
// @Tags 用户租户关联管理
// @Accept json
// @Produce json
// @Param pageNum query int false "页码" default(1)
// @Param pageSize query int false "每页数量" default(10)
// @Param userID query int false "用户ID"
// @Param tenantID query int false "租户ID"
// @Success 200 {object} map[string]interface{} "成功返回用户租户关联列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysUserTenant/list [get]
// @Security ApiKeyAuth
func (sut *SysUserTenantController) List(c *gin.Context) {
	var req models.SysUserTenantListRequest
	if err := req.Validate(c); err != nil {
		sut.FailAndAbort(c, err.Error(), err)
	}

	// 查询列表数据
	sysUserTenantList := models.NewSysUserTenantList()
	// 统计总数
	total, err := sysUserTenantList.GetTotal(c, req.Handler())
	if err != nil {
		sut.FailAndAbort(c, "统计用户租户关联数量失败", err)
	}
	req.Order = "created_at desc"
	err = sysUserTenantList.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Preload("User", func(db *gorm.DB) *gorm.DB {
			return db.Select("id, username, nick_name, tenant_id").Preload("Tenant")
		})
	}, req.Paginate(), req.Handler())
	if err != nil {
		sut.FailAndAbort(c, "获取用户租户关联列表失败", err)
	}

	sut.Success(c, gin.H{
		"list":  sysUserTenantList,
		"total": total,
	})
}

// GetByID 根据用户ID和租户ID获取用户租户关联信息
// @Summary 根据用户ID和租户ID获取用户租户关联信息
// @Description 根据用户ID和租户ID获取用户租户关联详细信息
// @Tags 用户租户关联管理
// @Accept json
// @Produce json
// @Param userID query int true "用户ID"
// @Param tenantID query int true "租户ID"
// @Success 200 {object} map[string]interface{} "成功返回用户租户关联信息"
// @Failure 400 {object} map[string]interface{} "参数格式错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysUserTenant/get [get]
// @Security ApiKeyAuth
func (sut *SysUserTenantController) GetByID(c *gin.Context) {
	var req models.SysUserTenantGetRequest
	if err := req.Validate(c); err != nil {
		sut.FailAndAbort(c, err.Error(), err)
	}

	// 查询用户租户关联信息
	sysUserTenant := &models.SysUserTenant{}
	err := sysUserTenant.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("user_id = ? AND tenant_id = ?", req.UserID, req.TenantID)
	})
	if err != nil {
		sut.FailAndAbort(c, "查询用户租户关联失败", err)
	}
	if sysUserTenant.IsEmpty() {
		sut.FailAndAbort(c, "用户租户关联不存在", nil)
	}

	sut.Success(c, sysUserTenant)
}

// BatchAdd 批量新增用户租户关联
// @Summary 批量新增用户租户关联
// @Description 批量创建用户租户关联
// @Tags 用户租户关联管理
// @Accept json
// @Produce json
// @Param sysUserTenant body models.SysUserTenantBatchAddRequest true "批量用户租户关联信息"
// @Success 200 {object} map[string]interface{} "用户租户关联批量创建成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysUserTenant/batchAdd [post]
// @Security ApiKeyAuth
func (sut *SysUserTenantController) BatchAdd(c *gin.Context) {
	var req models.SysUserTenantBatchAddRequest
	if err := req.Validate(c); err != nil {
		sut.FailAndAbort(c, err.Error(), err)
	}

	// 创建用户租户关联列表
	var sysUserTenants []*models.SysUserTenant
	for _, userID := range req.UserIDs {

		user := models.NewUser()
		err := user.Find(c, func(db *gorm.DB) *gorm.DB {
			return db.Select("id,tenant_id").Where("id = ?", userID)
		})
		if err != nil {
			sut.FailAndAbort(c, "获取用户失败", err)
		}
		if user.IsEmpty() {
			sut.FailAndAbort(c, "用户不存在", nil)
		}
		// 如果用户是全局租户，不允许关联其他租户
		if user.TenantID == 0 {
			sut.FailAndAbort(c, "全局租户用户不能关联其他租户", nil)
		}
		// 检查用户租户关联是否已存在
		existSysUserTenant := &models.SysUserTenant{}
		err = existSysUserTenant.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("user_id = ? AND tenant_id = ?", userID, req.TenantID)
		})
		if err != nil {
			sut.FailAndAbort(c, "检查用户租户关联失败", err)
		}
		// 如果不存在，则添加到待创建列表
		if existSysUserTenant.IsEmpty() {
			sysUserTenants = append(sysUserTenants, &models.SysUserTenant{
				UserID:    userID,
				TenantID:  req.TenantID,
				CreatedAt: time.Now(),
			})
		}
	}

	// 批量创建用户租户关联
	if len(sysUserTenants) > 0 {
		err := app.DB().WithContext(c).Create(sysUserTenants).Error
		if err != nil {
			sut.FailAndAbort(c, "批量新增用户租户关联失败", err)
		}
	}

	sut.SuccessWithMessage(c, "用户租户关联批量创建成功", sysUserTenants)
}

// BatchDelete 批量删除用户租户关联
// @Summary 批量删除用户租户关联
// @Description 批量删除指定用户租户关联
// @Tags 用户租户关联管理
// @Accept json
// @Produce json
// @Param sysUserTenant body models.SysUserTenantBatchDeleteRequest true "批量用户租户关联删除请求参数"
// @Success 200 {object} map[string]interface{} "用户租户关联批量删除成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysUserTenant/batchDelete [delete]
// @Security ApiKeyAuth
func (sut *SysUserTenantController) BatchDelete(c *gin.Context) {
	var req models.SysUserTenantBatchDeleteRequest
	if err := req.Validate(c); err != nil {
		sut.FailAndAbort(c, err.Error(), err)
	}

	// 检查是否有默认租户关联，如果有则不允许删除
	defaultSysUserTenant := &models.SysUserTenant{}
	err := defaultSysUserTenant.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("user_id IN ? AND tenant_id = ? AND is_default = ?", req.UserIDs, req.TenantID, true)
	})
	if err != nil {
		sut.FailAndAbort(c, "查询用户租户关联失败", err)
	}
	if !defaultSysUserTenant.IsEmpty() {
		sut.FailAndAbort(c, "不能删除默认租户关联", nil)
	}

	err = app.DB().WithContext(c).Transaction(func(tx *gorm.DB) (e error) {
		//批量删除用户租户关联
		e = tx.Where("user_id IN ? AND tenant_id = ?", req.UserIDs, req.TenantID).Delete(&models.SysUserTenant{}).Error
		if e != nil {
			return e
		}
		// 移除该租户下的角色关联
		// 使用子查询：先查询指定租户下的所有角色ID，再删除用户在这些角色中的关联
		subQuery := tx.Table("sys_role").Where("tenant_id = ?", req.TenantID).Select("id")
		e = tx.Where("user_id IN ? AND role_id IN (?)", req.UserIDs, subQuery).Delete(&models.SysUserRole{}).Error
		if e != nil {
			return e
		}
		return nil
	})

	if err != nil {
		sut.FailAndAbort(c, "批量删除用户租户关联失败", err)
	}

	// 移除casbin权限
	var e error
	for _, uid := range req.UserIDs {
		if err = sut.CasbinService.DeleteUserRoles(c, uid, nil, req.TenantID); err != nil {
			e = err
		}
	}
	if e != nil {
		sut.FailAndAbort(c, "移除casbin权限失败", e)
	}
	sut.SuccessWithMessage(c, "用户租户关联批量删除成功", nil)
}

// UserListAll 用户列表(不进行租户过滤)
// @Summary 用户列表(不进行租户过滤)
// @Description 获取所有用户列表，支持分页和过滤，不进行租户过滤
// @Tags 用户管理
// @Accept json
// @Produce json
// @Param pageNum query int false "页码" default(1)
// @Param pageSize query int false "每页数量" default(10)
// @Param name query string false "用户名或昵称"
// @Param phone query string false "手机号"
// @Param status query string false "状态"
// @Success 200 {object} map[string]interface{} "成功返回用户列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysUserTenant/userListAll [get]
// @Security ApiKeyAuth
func (sut *SysUserTenantController) UserListAll(c *gin.Context) {
	var req models.UserListRequest
	if err := req.Validate(c); err != nil {
		sut.FailAndAbort(c, err.Error(), err)
	}

	userList := models.NewUserList()
	total, err := userList.GetTotal(c, req.Handle())
	if err != nil {
		sut.FailAndAbort(c, err.Error(), err)
	}
	err = userList.Find(c, req.Paginate(), req.Handle(), func(d *gorm.DB) *gorm.DB {
		return d.Omit("password").Preload("Roles").Preload("Department").Preload("Tenant")
	})
	if err != nil {
		sut.FailAndAbort(c, err.Error(), err)
	}
	sut.Success(c, gin.H{
		"list":  userList,
		"total": total,
	})

}

// GetRolesAll 角色列表（不进行租户过滤，支持tenant_id查询）
// @Summary 角色列表(不进行租户过滤)
// @Description 获取所有角色列表，支持分页和过滤，不进行租户过滤，可根据tenant_id查询
// @Tags 角色管理
// @Accept json
// @Produce json
// @Param pageNum query int false "页码" default(1)
// @Param pageSize query int false "每页数量" default(10)
// @Param name query string false "角色名称"
// @Param status query int false "状态"
// @Param parentId query int false "父级ID"
// @Param tenantId query int false "租户ID"
// @Success 200 {object} map[string]interface{} "成功返回角色列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysUserTenant/getRolesAll [get]
// @Security ApiKeyAuth
func (sut *SysUserTenantController) GetRolesAll(c *gin.Context) {
	var req models.SysRoleListAllRequest
	if err := req.Validate(c); err != nil {
		sut.FailAndAbort(c, err.Error(), err)
	}

	// 查询列表数据
	sysRoleList := models.NewSysRoleList()

	err := sysRoleList.Find(c, req.Handler())
	if err != nil {
		sut.FailAndAbort(c, "获取角色列表失败", err)
	}

	sut.Success(c, gin.H{
		"list": sysRoleList,
	})
}

// GetUserRoleIDs 根据tenant_id和user_id查询角色ID集合
// @Summary 根据tenant_id和user_id查询角色ID集合
// @Description 根据tenant_id和user_id查询角色ID集合，注意sys_user_role表没有tenant_id字段，sys_role表中才有tenant_id字段
// @Tags 用户租户关联管理
// @Accept json
// @Produce json
// @Param userId query int true "用户ID"
// @Param tenantId query int true "租户ID"
// @Success 200 {object} map[string]interface{} "成功返回角色ID集合"
// @Failure 400 {object} map[string]interface{} "参数格式错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysUserTenant/getUserRoleIDs [get]
// @Security ApiKeyAuth
func (sut *SysUserTenantController) GetUserRoleIDs(c *gin.Context) {
	var req models.SysUserTenantGetUserRoleIDsRequest
	if err := req.Validate(c); err != nil {
		sut.FailAndAbort(c, err.Error(), err)
	}

	// 使用子查询直接获取用户在指定租户下的角色ID集合
	// 子查询: 先查询指定租户下的所有角色ID，再查询用户在这些角色中的关联
	var userRoleIDs []uint
	subQuery := app.DB().WithContext(c).Table("sys_role").Where("tenant_id = ?", req.TenantID).Select("id")
	err := app.DB().WithContext(c).Model(&models.SysUserRole{}).
		Where("user_id = ? AND role_id IN (?)", req.UserID, subQuery).
		Pluck("role_id", &userRoleIDs).Error
	if err != nil {
		sut.FailAndAbort(c, "查询用户角色失败", err)
	}

	sut.Success(c, userRoleIDs)
}

// SetUserRoles 设置用户角色
// @Summary 设置用户角色
// @Description 先移除租户相关的角色，再为用户分配新角色
// @Tags 用户租户关联管理
// @Accept json
// @Produce json
// @Param setUserRoles body models.SysUserTenantSetRolesRequest true "设置用户角色请求参数"
// @Success 200 {object} map[string]interface{} "设置用户角色成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysUserTenant/setUserRoles [post]
// @Security ApiKeyAuth
func (sut *SysUserTenantController) SetUserRoles(c *gin.Context) {
	var req models.SysUserTenantSetRolesRequest
	if err := req.Validate(c); err != nil {
		sut.FailAndAbort(c, err.Error(), err)
	}

	// 验证角色是否属于指定的租户
	if len(req.Roles) > 0 {
		roleList := models.NewSysRoleList()
		err := roleList.Find(c, func(db *gorm.DB) *gorm.DB {
			return db.Where("id IN ? AND tenant_id = ?", req.Roles, req.TenantID)
		})
		if err != nil {
			sut.FailAndAbort(c, "验证角色信息失败", err)
		}
		if len(roleList) != len(req.Roles) {
			sut.FailAndAbort(c, "存在不属于指定租户的角色", nil)
		}
	}

	// 使用事务处理用户角色设置
	err := app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
		// 先删除该用户在指定租户下的所有角色关联
		// 需要先查询出该租户下的所有角色ID
		var tenantRoleIDs []uint
		err := tx.Model(&models.SysRole{}).Where("tenant_id = ?", req.TenantID).Pluck("id", &tenantRoleIDs).Error
		if err != nil {
			return err
		}

		// 删除用户在该租户下的角色关联
		if len(tenantRoleIDs) > 0 {
			if err := tx.Where("user_id = ? AND role_id IN ?", req.UserID, tenantRoleIDs).Delete(&models.SysUserRole{}).Error; err != nil {
				return err
			}
		}

		// 创建新的用户角色关联
		if len(req.Roles) > 0 {
			var userRoles []models.SysUserRole
			for _, roleID := range req.Roles {
				userRoles = append(userRoles, models.SysUserRole{
					UserID: req.UserID,
					RoleID: roleID,
				})
			}
			if err := tx.Create(&userRoles).Error; err != nil {
				return err
			}
		}

		return nil
	})

	if err != nil {
		sut.FailAndAbort(c, "设置用户角色失败", err)
	}

	// 同步更新Casbin权限
	if err = sut.CasbinService.EditUserRoles(c, req.UserID, req.Roles, req.TenantID); err != nil {
		sut.FailAndAbort(c, "同步用户权限失败", err)
	}

	sut.SuccessWithMessage(c, "设置用户角色成功", nil)
}
