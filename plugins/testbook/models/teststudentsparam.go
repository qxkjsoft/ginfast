package models

import (
	"time"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// TestStudentsListRequest demo_students列表请求参数
type TestStudentsListRequest struct {
	models.BasePaging
	models.Validator
	StuId *uint `form:"stuId"` // ID
	StuName *string `form:"stuName"` // 姓名
	Age *int `form:"age"` // 年龄
	Gender *string `form:"gender"` // 性别
	Address *string `form:"address"` // 地址
	CreatedAt []time.Time `form:"createdAt"` // 创建时间范围
}

// Validate 验证请求参数
func (r *TestStudentsListRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// Handle 获取查询条件
func (r *TestStudentsListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
        if r.StuId != nil {
            db = db.Where("student_id = ?", *r.StuId)
        }
        if r.StuName != nil {
            db = db.Where("student_name LIKE ?", "%" + *r.StuName + "%")
        }
        if r.Age != nil {
            db = db.Where("age >= ?", *r.Age)
        }
        if r.Gender != nil {
            // 默认等于查询
            db = db.Where("gender = ?", *r.Gender)
        }
        if r.Address != nil {
            // 默认等于查询
            db = db.Where("address = ?", *r.Address)
        }
        if len(r.CreatedAt) >= 2 {
            db = db.Where("created_at BETWEEN ? AND ?", r.CreatedAt[0], r.CreatedAt[1])
        }
		return db
	}
}

// TestStudentsCreateRequest 创建demo_students请求参数
type TestStudentsCreateRequest struct {
	models.Validator
	StuName string `form:"stuName" validate:"required" message:"姓名不能为空"` // 姓名
	Age int `form:"age" validate:"required" message:"年龄不能为空"` // 年龄
	Gender string `form:"gender" validate:"required" message:"性别不能为空"` // 性别
	ClassName string `form:"className"` // 班级名称
	AdmissionDate time.Time `form:"admissionDate"` // 入学日期
	Address string `form:"address"` // 地址
}

// Validate 验证请求参数
func (r *TestStudentsCreateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// TestStudentsUpdateRequest 更新demo_students请求参数
type TestStudentsUpdateRequest struct {
	models.Validator
	StuId uint `form:"stuId" validate:"required" message:"ID不能为空"` // ID
	StuName string `form:"stuName" validate:"required" message:"姓名不能为空"` // 姓名
	Age int `form:"age" validate:"required" message:"年龄不能为空"` // 年龄
	Gender string `form:"gender" validate:"required" message:"性别不能为空"` // 性别
	ClassName string `form:"className"` // 班级名称
	AdmissionDate time.Time `form:"admissionDate"` // 入学日期
	Address string `form:"address"` // 地址
}

// Validate 验证请求参数
func (r *TestStudentsUpdateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// TestStudentsDeleteRequest 删除demo_students请求参数
type TestStudentsDeleteRequest struct {
	models.Validator
	StuId uint `form:"stuId" validate:"required" message:"ID不能为空"` // ID
}

// Validate 验证请求参数
func (r *TestStudentsDeleteRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// TestStudentsGetByIDRequest 根据ID获取demo_students请求参数
type TestStudentsGetByIDRequest struct {
	models.Validator
	StuId uint `uri:"stuId" validate:"required" message:"ID不能为空"` // ID
}

// Validate 验证请求参数
func (r *TestStudentsGetByIDRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}