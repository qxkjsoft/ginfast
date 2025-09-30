package controllers

import (
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

type UserController struct {
	Common
}

// 获取当前登录用户信息
func (uc *UserController) GetProfile(c *gin.Context) {
	// 从上下文中获取用户ID
	claims := common.GetClaims(c)
	if claims == nil {
		uc.FailAndAbort(c, "用户未登录", nil)
	}

	user, err := service.UserServices.GetUserProfile(claims.UserID)
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
	})
}

// 用户列表
func (uc *UserController) List(c *gin.Context) {
	var req models.UserListRequest
	if err := req.Validate(c); err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}

	userList := models.NewUserList()
	total, err := userList.GetTotal(req.Handle())
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	err = userList.Find(req.Paginate(), req.Handle(), func(d *gorm.DB) *gorm.DB {
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
func (uc *UserController) GetUserByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		uc.FailAndAbort(c, "Invalid user ID", err)
	}

	// 获取用户信息
	user, err := service.UserServices.GetUserProfile(uint(id))
	if err != nil {
		uc.FailAndAbort(c, "获取用户信息失败", err)
	}
	user.Password = ""
	uc.Success(c, user)
}

// 新增用户
func (uc *UserController) Add(c *gin.Context) {
	var req models.AddRequest
	if err := req.Validate(c); err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	// 检查用户名是否已存在
	user := models.NewUser()
	err := user.GetUserByUsername(req.UserName)
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	if !user.IsEmpty() {
		uc.FailAndAbort(c, "用户已存在", nil)
	}
	// 密码加密
	hashedPassword, err := passwordhelper.HashPassword(req.Password)
	if err != nil {
		uc.FailAndAbort(c, "Failed to hash password", err)
	}

	// 使用事务创建用户和角色关联
	err = app.DB().Transaction(func(tx *gorm.DB) error {
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
		user.CreatedBy = common.GetCurrentUserID(c)

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

	if err = service.CasbinService.AddRoleForUser(user.ID, req.Roles); err != nil {
		uc.FailAndAbort(c, "Failed to create user", err)
	}

	uc.SuccessWithMessage(c, "User created successfully", nil)
}

// UpdateProfile 更新用户资料
func (uc *UserController) Update(c *gin.Context) {
	var req models.UpdateRequest
	if err := req.Validate(c); err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}

	// 检查用户是否存在
	user := models.NewUser()
	err := user.GetUserByID(req.Id)
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	if user.IsEmpty() {
		uc.FailAndAbort(c, "用户不存在", nil)
	}

	// 检查用户名是否与其他用户冲突（排除当前用户）
	existUser := models.NewUser()
	err = existUser.GetUserByUsername(req.UserName)
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

	if err = service.CasbinService.EditUserRoles(user.ID, req.Roles); err != nil {
		uc.FailAndAbort(c, "更新用户失败", err)
	}

	uc.SuccessWithMessage(c, "更新成功", nil)
}

// Delete 删除用户
func (uc *UserController) Delete(c *gin.Context) {
	var req models.DeleteRequest
	if err := req.Validate(c); err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}

	// 检查用户是否存在
	user := models.NewUser()
	err := user.GetUserByID(req.Id)
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

	if err = service.CasbinService.DeleteUserRoles(user.ID, nil); err != nil {
		uc.FailAndAbort(c, "删除用户失败", err)
	}
	uc.SuccessWithMessage(c, "删除成功", nil)
}

// UpdateAccount 更新用户账户信息（密码、手机号、邮箱）
func (uc *UserController) UpdateAccount(c *gin.Context) {
	var req models.UpdateAccountRequest
	if err := req.Validate(c); err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}

	// 检查用户是否存在
	user := models.NewUser()
	err := user.GetUserByID(req.ID)
	if err != nil {
		uc.FailAndAbort(c, err.Error(), err)
	}
	if user.IsEmpty() {
		uc.FailAndAbort(c, "用户不存在", nil)
	}

	// 检查手机号是否已被其他用户使用
	if req.Phone != "" {
		existUser := models.NewUser()
		err = existUser.GetUserByPhone(req.Phone)
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
		err = existUser.GetUserByEmail(req.Email)
		if err != nil {
			uc.FailAndAbort(c, err.Error(), err)
		}
		if !existUser.IsEmpty() && existUser.ID != req.ID {
			uc.FailAndAbort(c, "邮箱已被其他用户使用", nil)
		}
	}

	// 加密新密码
	hashedPassword, err := passwordhelper.HashPassword(req.Password)
	if err != nil {
		uc.FailAndAbort(c, "密码加密失败", err)
	}

	// 更新用户信息
	user.Password = string(hashedPassword)
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
func (uc *UserController) UploadAvatar(c *gin.Context) {
	// 从上下文中获取用户ID
	claims := common.GetClaims(c)
	if claims == nil {
		uc.FailAndAbort(c, "用户未登录", nil)
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
	err = user.GetUserByID(claims.UserID)
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
