package models

import (
	"io"

	"github.com/gin-gonic/gin"
	"github.com/gookit/validate"
)

type Validator struct {
}

func (vt *Validator) Check(c *gin.Context, obj interface{}) error {
	// 先尝试从JSON body及form表单读取数据
	if err := c.ShouldBind(obj); err != nil && err != io.EOF {
		// 如果JSON body读取失败，尝试从URL参数读取
		if err := c.ShouldBindQuery(obj); err != nil {
			return err
		}
	}
	v := validate.Struct(obj)
	if !v.Validate() {
		return v.Errors.OneError()
	}
	return nil
}
