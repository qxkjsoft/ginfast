package usermodel

import (
	"gin-fast/app/models/common/valid"

	"github.com/gin-gonic/gin"
)

type LoginRequest struct {
	valid.Validator
	Username string `validate:"required" message:"用户名不能为空"`
	Password string `validate:"required" message:"密码不能为空"`
}

func (l *LoginRequest) Validate(c *gin.Context) error {
	return l.Check(c, l)
}
