package models

import (
	"github.com/gin-gonic/gin"
)

type AddRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
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
