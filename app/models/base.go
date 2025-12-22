package models

import (
	"net/url"
	"reflect"
	"strconv"
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
	// 获取Content-Type
	contentType := c.GetHeader("Content-Type")

	// GET请求：只处理数组参数、query和uri参数，不处理body
	if c.Request.Method == "GET" {
		r.parseArrayParams(c, obj)
		c.ShouldBindQuery(obj)
		c.ShouldBindUri(obj)
		return nil // GET请求通常没有body
	}

	// 非GET请求：根据Content-Type决定绑定策略
	if strings.Contains(contentType, "application/json") {
		// JSON请求：只处理路径参数，body由ShouldBindBodyWith处理 避免消耗request body
		c.ShouldBindUri(obj)
		return c.ShouldBindBodyWith(obj, binding.JSON)
	} else if strings.Contains(contentType, "application/x-www-form-urlencoded") ||
		strings.Contains(contentType, "multipart/form-data") {
		// 表单数据：先解析数组参数，然后处理query和uri，最后处理body
		r.parseArrayParams(c, obj)
		c.ShouldBindQuery(obj)
		c.ShouldBindUri(obj)
		return c.ShouldBind(obj)
	} else {
		// 其他类型的请求：处理数组参数、query和uri参数
		r.parseArrayParams(c, obj)
		c.ShouldBindQuery(obj)
		c.ShouldBindUri(obj)
		return nil
	}

}

// parseArrayParams 解析数组参数
func (r *BaseRequest) parseArrayParams(c *gin.Context, obj interface{}) {
	// 获取查询参数
	query := c.Request.URL.RawQuery
	if query == "" {
		return
	}

	// 解析查询参数
	values, err := url.ParseQuery(query)
	if err != nil {
		return
	}

	// 使用反射设置对象字段值
	objValue := reflect.ValueOf(obj).Elem()
	objType := objValue.Type()

	for i := 0; i < objValue.NumField(); i++ {
		field := objValue.Field(i)
		fieldType := objType.Field(i)

		// 只处理切片类型的字段
		if field.Kind() == reflect.Slice {
			formTag := fieldType.Tag.Get("form")
			if formTag != "" {
				// 查找匹配的数组参数，支持 field[0], field[1] 等格式
				var arrayValues []string

				for key, vals := range values {
					if key == formTag || strings.HasPrefix(key, formTag+"[") {
						arrayValues = append(arrayValues, vals...)
					}
				}

				// 如果找到了数组参数，则设置字段值
				if len(arrayValues) > 0 {
					elemType := field.Type().Elem()
					switch elemType.Kind() {
					case reflect.Uint:
						uintSlice := make([]uint, len(arrayValues))
						for j, val := range arrayValues {
							if u, err := strconv.ParseUint(val, 10, 64); err == nil {
								uintSlice[j] = uint(u)
							}
						}
						field.Set(reflect.ValueOf(uintSlice))
					case reflect.String:
						field.Set(reflect.ValueOf(arrayValues))
					case reflect.Struct:
						// 处理 time.Time 类型
						if elemType.Name() == "Time" && elemType.PkgPath() == "time" {
							timeSlice := make([]time.Time, len(arrayValues))
							for j, val := range arrayValues {
								// 尝试多种日期格式
								var t time.Time
								var err error

								// 首先尝试标准格式 2006-01-02
								t, err = time.Parse("2006-01-02", val)
								if err != nil {
									// 再尝试完整格式 2006-01-02 15:04:05
									t, err = time.Parse("2006-01-02 15:04:05", val)
									if err != nil {
										// 最后尝试 RFC3339 格式
										t, err = time.Parse(time.RFC3339, val) // 添加更多格式
									}
								}
								if err == nil {
									timeSlice[j] = t
								}
							}
							field.Set(reflect.ValueOf(timeSlice))
						}
						// 处理 JSONTime 类型
						if elemType.Name() == "JSONTime" && elemType.PkgPath() == "models" {
							timeSlice := make([]JSONTime, len(arrayValues))
							for j, val := range arrayValues {
								// 尝试多种日期格式
								var t time.Time
								var err error

								// 首先尝试标准格式 2006-01-02
								t, err = time.Parse("2006-01-02", val)
								if err != nil {
									// 再尝试完整格式 2006-01-02 15:04:05
									t, err = time.Parse("2006-01-02 15:04:05", val)
									if err != nil {
										// 最后尝试 RFC3339 格式
										t, err = time.Parse(time.RFC3339, val) // 添加更多格式
									}
								}
								if err == nil {
									timeSlice[j] = JSONTime{Time: t}
								}
							}
							field.Set(reflect.ValueOf(timeSlice))
						}
					}
				}
			}
		}
	}
}

type Validator struct {
	BaseRequest
}

// Validate 验证参数
func (vt *Validator) Check(c *gin.Context, obj interface{}) error {
	if err := vt.Bind(c, obj); err != nil {
		return err
	}

	// 验证参数
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
