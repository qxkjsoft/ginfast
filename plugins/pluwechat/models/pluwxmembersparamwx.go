package models

import (
	"gin-fast/app/models"
	"mime/multipart"

	"github.com/gin-gonic/gin"
)

type WxLoginRequest struct {
	models.Validator
	PhoneCode string `form:"phoneCode" validate:"required" message:"phoneCode不能为空"`
	Code      string `form:"code" validate:"required" message:"code不能为空"`
}

// Validate 验证微信登录请求参数
func (r *WxLoginRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

type WxMemberInfoResponse struct {
	ID       uint   `json:"id"`
	Username string `json:"username"`
	NickName string `json:"nickName"`
	Avatar   string `json:"avatar"`
	Phone    string `json:"phone"`
}

type WxLoginByCodeRequest struct {
	models.Validator
	Code string `form:"code" validate:"required" message:"code不能为空"`
}

// Validate 验证微信code登录请求参数
func (r *WxLoginByCodeRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

type WxUpdateProfileRequest struct {
	models.Validator
	Avatar   string `form:"avatar" `
	NickName string `form:"nickname"`
}

// Validate 验证更新用户信息请求参数
func (r *WxUpdateProfileRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// 微信端文件上传请求参数
type WxFileUploadRequest struct {
	models.Validator
	File *multipart.FileHeader `form:"file" validate:"required" message:"文件不能为空"`
}

// Validate 验证请求参数
func (r *WxFileUploadRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}
