package models

import (
	"github.com/gin-gonic/gin"
)

// RefreshRequest 刷新token请求结构
type RefreshRequest struct {
	RefreshToken string `form:"refreshToken" validate:"required"`
}

type AddRequest struct {
	Validator
	UserName    string `form:"userName" validate:"required" message:"用户名不能为空"`
	NickName    string `form:"nickName" validate:"required" message:"昵称不能为空"`
	Phone       string `form:"phone"`
	Email       string `form:"email"`
	Password    string `form:"password" validate:"required|min_len:6" message:"密码至少6位"`
	Sex         string `form:"sex" validate:"required" message:"性别不能为空"`
	DeptId      uint   `form:"deptId" validate:"required" message:"部门ID不能为空"`
	Roles       []uint `form:"roles" validate:"required" message:"角色不能为空"`
	Status      int8   `form:"status" validate:"required" message:"状态不能为空"`
	Description string `form:"description"`
}

func (r *AddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

type UpdateRequest struct {
	Validator
	Id          uint   `form:"id"  validate:"required" message:"ID不能为空"`
	UserName    string `form:"userName" validate:"required" message:"用户名不能为空"`
	NickName    string `form:"nickName" validate:"required" message:"昵称不能为空"`
	Phone       string `form:"phone"`
	Email       string `form:"email"`
	Sex         string `form:"sex" validate:"required" message:"性别不能为空"`
	DeptId      uint   `form:"deptId" validate:"required" message:"部门ID不能为空"`
	Roles       []uint `form:"roles" validate:"required" message:"角色不能为空"`
	Status      int8   `form:"status" validate:"required" message:"状态不能为空"`
	Description string `form:"description"`
}

func (r *UpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

type LoginRequest struct {
	Validator
	Username string `validate:"required" message:"用户名不能为空"`
	Password string `validate:"required" message:"密码不能为空"`
}

func (r *LoginRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

type CaptchaImgRequest struct {
	Validator
	CaptchaId string `form:"captchaId" validate:"required" message:"验证码ID不能为空"`
	Time      string `form:"time"`
	Width     int    `form:"width"`
	Height    int    `form:"height"`
}

func (r *CaptchaImgRequest) Validate(c *gin.Context) error {
	err := r.Check(c, r)
	if err != nil {
		return err
	}
	if r.Width == 0 {
		r.Width = 130
	}
	if r.Height == 0 {
		r.Height = 30
	}
	return nil
}

type UserListRequest struct {
	BasePaging
	Validator
}

func (r *UserListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// DeleteRequest 删除用户请求结构
type DeleteRequest struct {
	Validator
	Id uint `form:"id" validate:"required" message:"用户ID不能为空"`
}

func (r *DeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
