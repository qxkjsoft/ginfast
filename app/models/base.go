package models

import (
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/gookit/validate"
	"gorm.io/gorm"
)

type BaseRequest struct {
}

// Bind 绑定请求参数
func (r *BaseRequest) Bind(c *gin.Context, obj interface{}) (err error) {
	// 先尝试从URL参数读取数据
	c.ShouldBindQuery(obj)
	// 获取Content-Type
	contentType := c.GetHeader("Content-Type")

	// 处理表单数据（不会消耗body用于后续绑定）
	if strings.Contains(contentType, "application/x-www-form-urlencoded") ||
		strings.Contains(contentType, "multipart/form-data") {
		return c.ShouldBind(obj)
	}

	// 处理JSON数据，使用ShouldBindBodyWith避免消耗request body
	if strings.Contains(contentType, "application/json") {
		return c.ShouldBindBodyWith(obj, binding.JSON)
	}

	// 其他情况尝试ShouldBind
	return c.ShouldBind(obj)
}

type Validator struct {
	BaseRequest
}

// Validate 验证参数
func (vt *Validator) Check(c *gin.Context, obj interface{}) error {
	if err := vt.Bind(c, obj); err != nil {
		return err
	}
	v := validate.Struct(obj)
	if !v.Validate() {
		return v.Errors.OneError()
	}
	return nil
}

// 分页
type BasePaging struct {
	PageNum  int    `json:"pageNum" form:"pageNum"`
	PageSize int    `json:"pageSize" form:"pageSize"`
	Order    string `json:"order" form:"order"`
}

// 分页数据
func (bp *BasePaging) Paginate() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if bp.PageNum > 0 && bp.PageSize > 0 {
			db = db.Offset((bp.PageNum - 1) * bp.PageSize).Limit(bp.PageSize)
		}

		if bp.Order != "" {
			db = db.Order(bp.Order)
		} else {
			db = db.Order("id desc")
		}
		return db
	}
}

type BaseModel struct {
	ID        uint           `gorm:"primarykey" json:"id"`
	CreatedAt time.Time      `json:"createdAt"`
	UpdatedAt time.Time      `json:"updatedAt"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"deletedAt"`
}
