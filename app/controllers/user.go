package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"
	"gin-fast/app/utils/passwordhelper"

	"strconv"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type UserController struct {
}

// 获取当前登录用户信息
func (uc *UserController) GetProfile(c *gin.Context) {
	// 从上下文中获取用户ID
	claims := common.GetClaims(c)
	if claims == nil {
		app.Response.Fail(c, "用户未登录")
		return
	}

	// 获取用户信息
	user := models.NewUser()
	err := user.GetUserByID(claims.UserID)
	if err != nil {
		app.ZapLog.Error("用户不存在", zap.Error(err))
		app.Response.Fail(c, "用户不存在")
		return
	}
	app.Response.Success(c, gin.H{
		"id":       user.ID,
		"avatar":   user.Avatar,
		"username": user.Username,
		"nickname": user.NickName,
		"roles": user.Roles.Map(func(role *models.SysRole) interface{} {
			return role.ID
		}),
		"permissions": []string{},
	})
}

// 用户列表
func (uc *UserController) List(c *gin.Context) {
	var req models.UserListRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}
	var count int64
	err := app.DB().Model(&models.User{}).Count(&count).Error
	if err != nil {
		app.Response.Fail(c, err.Error())
		return
	}
	userList := models.NewUserList()
	err = userList.Find(req.Paginate(), func(d *gorm.DB) *gorm.DB {
		return d.Omit("password").Preload("Roles")
	})
	if err != nil {
		app.Response.Fail(c, err.Error())
		return
	}
	app.Response.Success(c, gin.H{
		"list":  userList,
		"total": count,
	})

}

// GetUserByID 根据ID获取用户
func (uc *UserController) GetUserByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		app.ZapLog.Error("用户不存在", zap.Error(err))
		app.Response.Fail(c, "Invalid user ID")
		return
	}

	// 获取用户信息
	user := models.NewUser()
	err = user.GetUserByID(uint(id))
	if err != nil {
		app.ZapLog.Error("用户不存在", zap.Error(err))
		app.Response.Fail(c, "用户不存在")
		return
	}

	app.Response.Success(c, user)
}

// 新增用户
func (uc *UserController) Add(c *gin.Context) {
	var req models.AddRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}
	// 检查用户名是否已存在
	user := models.NewUser()
	err := user.GetUserByUsername(req.UserName)
	if err != nil {
		app.ZapLog.Error("新增用户失败", zap.Error(err))
		app.Response.Fail(c, err.Error())
		return
	}
	if !user.IsEmpty() {
		app.ZapLog.Error("用户已存在", zap.Error(err))
		app.Response.Fail(c, "用户已存在")
		return

	}
	// 密码加密
	hashedPassword, err := passwordhelper.HashPassword(req.Password)
	if err != nil {
		app.ZapLog.Error("新增用户失败", zap.Error(err))
		app.Response.Fail(c, "Failed to hash password")
		return
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
		app.ZapLog.Error("新增用户失败", zap.Error(err))
		app.Response.Fail(c, "Failed to create user")
		return
	}

	app.Response.Success(c, nil, "User created successfully")
}

// UpdateProfile 更新用户资料
func (uc *UserController) Update(c *gin.Context) {
	var req models.UpdateRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查用户是否存在
	user := models.NewUser()
	err := user.GetUserByID(req.Id)
	if err != nil {
		app.ZapLog.Error("更新用户失败", zap.Error(err))
		app.Response.Fail(c, err.Error())
		return
	}
	if user.IsEmpty() {
		app.ZapLog.Error("用户不存在")
		app.Response.Fail(c, "用户不存在")
		return
	}

	// 检查用户名是否与其他用户冲突（排除当前用户）
	existUser := models.NewUser()
	err = existUser.GetUserByUsername(req.UserName)
	if err != nil {
		app.ZapLog.Error("更新用户失败", zap.Error(err))
		app.Response.Fail(c, err.Error())
		return
	}
	if !existUser.IsEmpty() && existUser.ID != req.Id {
		app.ZapLog.Error("用户名已被其他用户使用")
		app.Response.Fail(c, "用户名已被其他用户使用")
		return
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
		app.ZapLog.Error("更新用户失败", zap.Error(err))
		app.Response.Fail(c, "更新用户失败")
		return
	}

	app.Response.Success(c, nil, "更新成功")
}

// Delete 删除用户
func (uc *UserController) Delete(c *gin.Context) {
	var req models.DeleteRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查用户是否存在
	user := models.NewUser()
	err := user.GetUserByID(req.Id)
	if err != nil {
		app.ZapLog.Error("删除用户失败", zap.Error(err))
		app.Response.Fail(c, err.Error())
		return
	}
	if user.IsEmpty() {
		app.ZapLog.Error("用户不存在")
		app.Response.Fail(c, "用户不存在")
		return
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
		app.ZapLog.Error("删除用户失败", zap.Error(err))
		app.Response.Fail(c, "删除用户失败")
		return
	}

	app.Response.Success(c, nil, "删除成功")
}
