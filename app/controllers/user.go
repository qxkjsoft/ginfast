package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models/usermodel"
	"gin-fast/app/utils/common"
	"gin-fast/app/utils/passwordhelper"
	"gin-fast/app/utils/response"
	"strconv"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type AddRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type UserController struct {
}

// 获取当前登录用户信息
func (uc *UserController) GetProfile(c *gin.Context) {
	// 从上下文中获取用户ID
	claims := common.GetClaims(c)
	if claims == nil {
		response.Fail(c, "UserId必须")
		return
	}

	// 获取用户信息
	user, err := usermodel.GetUserByID(claims.UserID)
	if err != nil {
		app.ZapLog.Error("用户不存在", zap.Error(err))
		response.Fail(c, "用户不存在")
		return
	}
	user.Password = ""
	response.Success(c, user)
}

// UpdateProfile 更新用户资料
func (uc *UserController) UpdateProfile(c *gin.Context) {
	// 从上下文中获取用户ID
	userID, exists := c.Get("user_id")
	if !exists {
		response.Fail(c, "UserId必须")
		return
	}

	// 获取用户信息
	user, err := usermodel.GetUserByID(userID.(uint))
	if err != nil {
		app.ZapLog.Error("用户不存在", zap.Error(err))
		response.Fail(c, "用户不存在")
		return
	}

	// 绑定请求数据
	if err := c.ShouldBindJSON(&user); err != nil {
		app.ZapLog.Error("更新用户信息失败", zap.Error(err))
		response.Fail(c, err.Error())
		return
	}

	// 更新用户信息
	if err := app.GormDbMysql.Save(&user).Error; err != nil {
		app.ZapLog.Error("更新用户信息失败", zap.Error(err))
		response.Fail(c, "更新失败")
		return
	}

	response.Success(c, nil, "更新成功")
}

// GetUserByID 根据ID获取用户
func (uc *UserController) GetUserByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		app.ZapLog.Error("用户不存在", zap.Error(err))
		response.Fail(c, "Invalid user ID")
		return
	}

	// 获取用户信息
	user, err := usermodel.GetUserByID(uint(id))
	if err != nil {
		app.ZapLog.Error("用户不存在", zap.Error(err))
		response.Fail(c, "用户不存在")
		return
	}

	response.Success(c, user)
}

// 新增用户
func (uc *UserController) Add(c *gin.Context) {
	var req AddRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		app.ZapLog.Error("新增用户失败", zap.Error(err))
		response.Fail(c, err.Error())
		return
	}

	// 检查用户名是否已存在
	_, err := usermodel.GetUserByUsername(req.Username)
	if err == nil {
		app.ZapLog.Error("新增用户失败", zap.Error(err))
		response.Fail(c, "Username already exists")
		return
	}

	// 密码加密
	hashedPassword, err := passwordhelper.HashPassword(req.Password)
	if err != nil {
		app.ZapLog.Error("新增用户失败", zap.Error(err))
		response.Fail(c, "Failed to hash password")
		return
	}

	// 创建用户
	user := &usermodel.User{
		Username: req.Username,
		Password: string(hashedPassword),
		Role:     "user", // 默认角色为user
	}

	if err := usermodel.CreateUser(user); err != nil {
		app.ZapLog.Error("新增用户失败", zap.Error(err))
		response.Fail(c, "Failed to create user")
		return
	}

	response.Success(c, nil, "User created successfully")
}
