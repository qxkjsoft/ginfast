package models

import (
	"time"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// TestTeacherListRequest demo_teacher列表请求参数
type TestTeacherListRequest struct {
	models.BasePaging
	models.Validator
	TcId *uint `form:"tcId"` // 主键ID
	TcName *string `form:"tcName"` // 教师姓名
	EmployeeId *string `form:"employeeId"` // 工号
	Gender *int `form:"gender"` // 性别：0-未知 1-男 2-女
	Phone *string `form:"phone"` // 手机号
	Email *string `form:"email"` // 邮箱
	Subject *string `form:"subject"` // 所教学科
	Title *string `form:"title"` // 职称
	Status *int `form:"status"` // 状态：0-离职 1-在职
	HireDate []time.Time `form:"hireDate"` // 入职日期范围（仅日期类型支持）
	BirthDate *time.Time `form:"birthDate"` // 出生日期
}

// Validate 验证请求参数
func (r *TestTeacherListRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// Handle 获取查询条件
func (r *TestTeacherListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
        if r.TcId != nil {
            // 默认等于查询
            db = db.Where("id = ?", *r.TcId)
        }
        if r.TcName != nil {
            db = db.Where("name LIKE ?", "%" + *r.TcName + "%")
        }
        // 非日期类型不支持BETWEEN查询，使用精确查询
        if r.EmployeeId != nil {
            db = db.Where("employee_id = ?", *r.EmployeeId)
        }
        if r.Gender != nil {
            db = db.Where("gender = ?", *r.Gender)
        }
        if r.Phone != nil {
            db = db.Where("phone > ?", *r.Phone)
        }
        if r.Email != nil {
            db = db.Where("email != ?", *r.Email)
        }
        if r.Subject != nil {
            // 默认等于查询
            db = db.Where("subject = ?", *r.Subject)
        }
        if r.Title != nil {
            // 默认等于查询
            db = db.Where("title = ?", *r.Title)
        }
        if r.Status != nil {
            // 默认等于查询
            db = db.Where("status = ?", *r.Status)
        }
        if len(r.HireDate) >= 2 {
            db = db.Where("hire_date BETWEEN ? AND ?", r.HireDate[0], r.HireDate[1])
        }
        if r.BirthDate != nil {
            // 默认等于查询
            db = db.Where("birth_date = ?", *r.BirthDate)
        }
		return db
	}
}

// TestTeacherCreateRequest 创建demo_teacher请求参数
type TestTeacherCreateRequest struct {
	models.Validator
	TcName string `form:"tcName" validate:"required" message:"教师姓名不能为空"` // 教师姓名
	EmployeeId string `form:"employeeId" validate:"required" message:"工号不能为空"` // 工号
	Gender int `form:"gender" validate:"required" message:"性别：0-未知 1-男 2-女不能为空"` // 性别：0-未知 1-男 2-女
	Phone string `form:"phone" validate:"required" message:"手机号不能为空"` // 手机号
	Email string `form:"email" validate:"required" message:"邮箱不能为空"` // 邮箱
	Subject string `form:"subject" validate:"required" message:"所教学科不能为空"` // 所教学科
	Title string `form:"title" validate:"required" message:"职称不能为空"` // 职称
	Status int `form:"status" validate:"required" message:"状态：0-离职 1-在职不能为空"` // 状态：0-离职 1-在职
	HireDate time.Time `form:"hireDate" validate:"required" message:"入职日期不能为空"` // 入职日期
	BirthDate time.Time `form:"birthDate" validate:"required" message:"出生日期不能为空"` // 出生日期
}

// Validate 验证请求参数
func (r *TestTeacherCreateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// TestTeacherUpdateRequest 更新demo_teacher请求参数
type TestTeacherUpdateRequest struct {
	models.Validator
	TcId uint `form:"tcId" validate:"required" message:"主键ID不能为空"` // 主键ID
	TcName string `form:"tcName" validate:"required" message:"教师姓名不能为空"` // 教师姓名
	EmployeeId string `form:"employeeId" validate:"required" message:"工号不能为空"` // 工号
	Gender int `form:"gender" validate:"required" message:"性别：0-未知 1-男 2-女不能为空"` // 性别：0-未知 1-男 2-女
	Phone string `form:"phone" validate:"required" message:"手机号不能为空"` // 手机号
	Email string `form:"email" validate:"required" message:"邮箱不能为空"` // 邮箱
	Subject string `form:"subject" validate:"required" message:"所教学科不能为空"` // 所教学科
	Title string `form:"title" validate:"required" message:"职称不能为空"` // 职称
	Status int `form:"status" validate:"required" message:"状态：0-离职 1-在职不能为空"` // 状态：0-离职 1-在职
	HireDate time.Time `form:"hireDate" validate:"required" message:"入职日期不能为空"` // 入职日期
	BirthDate time.Time `form:"birthDate" validate:"required" message:"出生日期不能为空"` // 出生日期
}

// Validate 验证请求参数
func (r *TestTeacherUpdateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// TestTeacherDeleteRequest 删除demo_teacher请求参数
type TestTeacherDeleteRequest struct {
	models.Validator
	TcId uint `form:"tcId" validate:"required" message:"主键ID不能为空"` // 主键ID
}

// Validate 验证请求参数
func (r *TestTeacherDeleteRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// TestTeacherGetByIDRequest 根据ID获取demo_teacher请求参数
type TestTeacherGetByIDRequest struct {
	models.Validator
	TcId uint `uri:"tcId" validate:"required" message:"主键ID不能为空"` // 主键ID
}

// Validate 验证请求参数
func (r *TestTeacherGetByIDRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}