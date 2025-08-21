package valid

import (
	"github.com/gin-gonic/gin"
	"github.com/gookit/validate"
)

type Validator struct {
}

func (vt *Validator) Check(c *gin.Context, obj interface{}) error {
	_ = c.ShouldBindJSON(obj)
	v := validate.Struct(obj)
	if !v.Validate() {
		return v.Errors.OneError()
	}
	return nil
}
