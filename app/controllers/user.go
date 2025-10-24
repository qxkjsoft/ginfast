package controllers

import (
	"errors"
	"strings"

	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/service"
	"gin-fast/app/utils/common"
	"gin-fast/app/utils/passwordhelper"

	"strconv"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// UserController 用户控制器
// @Summary 用户管理API
// @Description 用户管理相关接口
// @Tags 用户管理
// @Accept json
// @Produce json
// @Router /users [get]
type UserController struct {
	Common
	UserService   *service.User
	CasbinService *service.PermissionService
}

// NewUserController 创建用户控制器
func NewUserController() *UserController {
	return &UserController{
		Common:        Common{},
		UserService:   service.NewUserService(),
		CasbinService: service.NewPermissionService(),
	}
}

// GetProfile 获取当前登录用户信息
// @Summary 获取当前登录用户信息
// @Description 获取当前登录用户的信息，包括角色和权限
// @Tags 用户管理
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{} "成功返回用户信息"
// @Failure 401 {object} map[string]interface{} "用户未登录"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /users/profile [get]
// @Security ApiKeyAuth
func (uc *UserController) GetProfile(c *gin.Context) {
	// 从上下文中获取用户ID
	claims := common.GetClaims(c)
	if claims == nil {
		uc.FailAndAbort(c, "用户未登录", errors.New("用户未登录"))
		return
	}

	user, err := uc.UserService.GetUserProfile(c, claims.UserID)
	if err != nil {
		uc.FailAndAbort(c, "获取用户信息失败", err)
	}
	uc.Success(c, gin.H{
		"id":          user.ID,
		"avatar":      user.Avatar,
		"username":    user.Username,
		"nickname":    user.NickName,
		"roles":       user.Roles.GetRoleIDs(),
		"permissions": user.Permissions,
		"tenantID":    claims.TenantID,
		"tenantCode":  claims.TenantCode,
	})
}

// List 用户列表
// @Summary 用户列表
// @Description 获取用户列表，支持分页和过滤
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
// @Router /users/list [get]
// @Security ApiKeyAuth
func (uc *UserController) List(c *gin.Context) {
	var req models.UserListRequest
	if err := req.Validate(c); err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}

	userList := models.NewUserList()
	total, err := userList.GetTotal(c, req.Handle())
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	err = userList.Find(c, req.Paginate(), req.Handle(), func(d *gorm.DB) *gorm.DB {
		return d.Omit("password").Preload("Roles").Preload("Department")
	})
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	uc.Success(c, gin.H{
		"list":  userList,
		"total": total,
	})

}

// GetUserByID 根据ID获取用户
// @Summary 根据ID获取用户
// @Description 根据用户ID获取用户详细信息
// @Tags 用户管理
// @Accept json
// @Produce json
// @Param id path int true "用户ID"
// @Success 200 {object} map[string]interface{} "成功返回用户信息"
// @Failure 400 {object} map[string]interface{} "用户ID格式错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /users/{id} [get]
// @Security ApiKeyAuth
func (uc *UserController) GetUserByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		uc.FailAndAbort(c, "Invalid user ID", err)
	}

	// 获取用户信息
	user, err := uc.UserService.GetUserProfile(c, uint(id))
	if err != nil {
		uc.FailAndAbort(c, "获取用户信息失败", err)
	}
	user.Password = ""
	uc.Success(c, user)
}

// Add 新增用户
// @Summary 新增用户
// @Description 创建新用户
// @Tags 用户管理
// @Accept json
// @Produce json
// @Param user body models.AddRequest true "用户信息"
// @Success 200 {object} map[string]interface{} "用户创建成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /users/add [post]
// @Security ApiKeyAuth
func (uc *UserController) Add(c *gin.Context) {
	var req models.AddRequest
	if err := req.Validate(c); err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	// 检查用户名是否已存在
	user := models.NewUser()
	err := user.GetUserByUsername(c, req.UserName)
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	if !user.IsEmpty() {
		uc.FailAndAbort(c, "用户已存在", nil)
	}

	// 检查手机号是否已被其他用户使用
	if req.Phone != "" {
		existUser := models.NewUser()
		err = existUser.GetUserByPhone(c, req.Phone)
		if err != nil {
			uc.FailAndAbort(c, err.Error(), err)
		}
		if !existUser.IsEmpty() {
			uc.FailAndAbort(c, "手机号已被其他用户使用", nil)
		}
	}

	// 检查邮箱是否已被其他用户使用
	if req.Email != "" {
		existUser := models.NewUser()
		err = existUser.GetUserByEmail(c, req.Email)
		if err != nil {
			uc.FailAndAbort(c, err.Error(), err)
		}
		if !existUser.IsEmpty() {
			uc.FailAndAbort(c, "邮箱已被其他用户使用", nil)
		}
	}

	// 密码加密
	hashedPassword, err := passwordhelper.HashPassword(req.Password)
	if err != nil {
		uc.FailAndAbort(c, "Failed to hash password", err)
	}

	// 使用事务创建用户和角色关联
	err = app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
		// 创建用户
		user.Username = req.UserName
		user.NickName = req.NickName
		user.Phone = req.Phone
		user.Email = req.Email
		user.Password = string(hashedPassword)
		user.Sex = req.Sex
		user.DeptID = req.DeptId
		user.Status = req.Status
		user.Description = req.Description

		if err := tx.Create(user).Error; err != nil {
			return err
		}

		// 创建用户角色关联
		if len(req.Roles) > 0 {
			userRoles := make([]models.SysUserRole, len(req.Roles))
			for i, roleID := range req.Roles {
				userRoles[i] = models.SysUserRole{
					UserID: user.ID,
					RoleID: roleID,
				}
			}
			if err := tx.Create(&userRoles).Error; err != nil {
				return err
			}
		}

		return nil
	})

	if err != nil {
		uc.FailAndAbort(c, "Failed to create user", err)
	}

	if err = uc.CasbinService.AddRoleForUser(user.ID, req.Roles); err != nil {
		uc.FailAndAbort(c, "Failed to create user", err)
	}

	uc.SuccessWithMessage(c, "User created successfully", nil)
}

// UpdateProfile 更新用户资料
// @Summary 更新用户资料
// @Description 更新用户信息
// @Tags 用户管理
// @Accept json
// @Produce json
// @Param user body models.UpdateRequest true "用户信息"
// @Success 200 {object} map[string]interface{} "用户更新成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /users/edit [put]
// @Security ApiKeyAuth
func (uc *UserController) Update(c *gin.Context) {
	var req models.UpdateRequest
	if err := req.Validate(c); err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}

	// 检查用户是否存在
	user := models.NewUser()
	err := user.GetUserByID(c, req.Id)
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	if user.IsEmpty() {
		uc.FailAndAbort(c, "用户不存在", nil)
	}

	// 检查用户名是否与其他用户冲突（排除当前用户）
	existUser := models.NewUser()
	err = existUser.GetUserByUsername(c, req.UserName)
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	if !existUser.IsEmpty() && existUser.ID != req.Id {
		uc.FailAndAbort(c, "用户名已被其他用户使用", nil)
	}

	// 使用事务更新用户和角色关联
	err = app.DB().Transaction(func(tx *gorm.DB) error {
		// 更新用户信息
		user.Username = req.UserName
		user.NickName = req.NickName
		user.Phone = req.Phone
		user.Email = req.Email
		user.Sex = req.Sex
		user.DeptID = req.DeptId
		user.Status = req.Status
		user.Description = req.Description

		if err := tx.Save(user).Error; err != nil {
			return err
		}

		// 删除现有的用户角色关联
		if err := tx.Where("user_id = ?", user.ID).Delete(&models.SysUserRole{}).Error; err != nil {
			return err
		}

		// 创建新的用户角色关联
		if len(req.Roles) > 0 {
			userRoles := make([]models.SysUserRole, len(req.Roles))
			for i, roleID := range req.Roles {
				userRoles[i] = models.SysUserRole{
					UserID: user.ID,
					RoleID: roleID,
				}
			}
			if err := tx.Create(&userRoles).Error; err != nil {
				return err
			}
		}

		return nil
	})

	if err != nil {
		uc.FailAndAbort(c, "更新用户失败", err)
	}

	if err = uc.CasbinService.EditUserRoles(user.ID, req.Roles); err != nil {
		uc.FailAndAbort(c, "更新用户失败", err)
	}

	uc.SuccessWithMessage(c, "更新成功", nil)
}

// Delete 删除用户
// @Summary 删除用户
// @Description 删除用户信息
// @Tags 用户管理
// @Accept json
// @Produce json
// @Param user body models.DeleteRequest true "用户删除请求参数"
// @Success 200 {object} map[string]interface{} "用户删除成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /users/delete [delete]
// @Security ApiKeyAuth
func (uc *UserController) Delete(c *gin.Context) {
	var req models.DeleteRequest
	if err := req.Validate(c); err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}

	// 检查用户是否存在
	user := models.NewUser()
	err := user.GetUserByID(c, req.Id)
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	if user.IsEmpty() {
		uc.FailAndAbort(c, "用户不存在", nil)
	}

	// 使用事务删除用户和角色关联
	err = app.DB().Transaction(func(tx *gorm.DB) error {
		// 删除用户角色关联
		if err := tx.Where("user_id = ?", user.ID).Delete(&models.SysUserRole{}).Error; err != nil {
			return err
		}

		// 软删除用户
		if err := tx.Where("id = ?", user.ID).Delete(user).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		uc.FailAndAbort(c, "删除用户失败", err)
	}

	if err = uc.CasbinService.DeleteUserRoles(user.ID, nil); err != nil {
		uc.FailAndAbort(c, "删除用户失败", err)
	}
	uc.SuccessWithMessage(c, "删除成功", nil)
}

// UpdateAccount 更新用户账户信息（密码、手机号、邮箱）
// @Summary 更新用户账户信息
// @Description 更新用户密码、手机号及邮箱信息
// @Tags 用户管理
// @Accept json
// @Produce json
// @Param user body models.UpdateAccountRequest true "用户账户信息"
// @Success 200 {object} map[string]interface{} "用户账户信息更新成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /users/updateAccount [put]
// @Security ApiKeyAuth
func (uc *UserController) UpdateAccount(c *gin.Context) {
	var req models.UpdateAccountRequest
	if err := req.Validate(c); err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}

	// 检查用户是否存在
	user := models.NewUser()
	err := user.GetUserByID(c, req.ID)
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	if user.IsEmpty() {
		uc.FailAndAbort(c, "用户不存在", nil)
	}

	// 检查手机号是否已被其他用户使用
	if req.Phone != "" {
		existUser := models.NewUser()
		err = existUser.GetUserByPhone(c, req.Phone)
		if err != nil {
			uc.FailAndAbort(c, err.Error(), err)
		}
		if !existUser.IsEmpty() && existUser.ID != req.ID {
			uc.FailAndAbort(c, "手机号已被其他用户使用", nil)
		}
	}

	// 检查邮箱是否已被其他用户使用
	if req.Email != "" {
		existUser := models.NewUser()
		err = existUser.GetUserByEmail(c, req.Email)
		if err != nil {
			uc.FailAndAbort(c, err.Error(), err)
		}
		if !existUser.IsEmpty() && existUser.ID != req.ID {
			uc.FailAndAbort(c, "邮箱已被其他用户使用", nil)
		}
	}
	if req.Password != "" {
		// 加密新密码
		hashedPassword, err := passwordhelper.HashPassword(req.Password)
		if err != nil {
			uc.FailAndAbort(c, "密码加密失败", err)
		}

		// 更新用户信息
		user.Password = string(hashedPassword)
	}

	if req.Phone != "" {
		user.Phone = req.Phone
	}
	if req.Email != "" {
		user.Email = req.Email
	}

	if err := app.DB().Save(user).Error; err != nil {
		uc.FailAndAbort(c, "更新用户信息失败", err)
	}

	uc.SuccessWithMessage(c, "账户信息更新成功", nil)
}

// UploadAvatar 上传用户头像
// @Summary 上传用户头像
// @Description 上传用户头像文件
// @Tags 用户管理
// @Accept multipart/form-data
// @Produce json
// @Param file formData file true "用户头像文件"
// @Success 200 {object} map[string]interface{} "用户头像上传成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /users/uploadAvatar [post]
// @Security ApiKeyAuth
func (uc *UserController) UploadAvatar(c *gin.Context) {
	// 从上下文中获取用户ID
	claims := common.GetClaims(c)
	if claims == nil {
		uc.FailAndAbort(c, "用户未登录", nil)
		return
	}

	// 处理文件上传
	response, err := app.UploadService.HandleUpload(c, "file")
	if err != nil {
		uc.FailAndAbort(c, "文件上传失败", err)
	}

	// 验证文件是否为图片类型
	validImageTypes := []string{".jpg", ".jpeg", ".png", ".gif", ".bmp"}
	isImage := false
	for _, ext := range validImageTypes {
		if strings.EqualFold(response.FileType, ext) {
			isImage = true
			break
		}
	}
	if !isImage {
		uc.FailAndAbort(c, "只允许上传图片文件", nil)
	}

	// 获取用户信息
	user := models.NewUser()
	err = user.GetUserByID(c, claims.UserID)
	if err != nil {
		uc.FailAndAbort(c, "获取用户信息失败", err)
	}
	if user.IsEmpty() {
		uc.FailAndAbort(c, "用户不存在", nil)
	}

	// 更新用户头像字段
	user.Avatar = response.Url
	if err := app.DB().Save(user).Error; err != nil {
		uc.FailAndAbort(c, "更新用户头像失败", err)
	}

	// 返回成功响应
	uc.Success(c, gin.H{
		"url": response.Url,
	})
}
