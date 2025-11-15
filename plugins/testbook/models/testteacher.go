package models

import (
	"context"
	"time"
	"gin-fast/app/global/app"
	"gorm.io/gorm"
)

// TestTeacher demo_teacher 模型结构体
type TestTeacher struct {
	TcId uint `gorm:"column:id;primaryKey;not null;autoIncrement" json:"tcId"` // 主键ID
	TcName string `gorm:"column:name;not null" json:"tcName"` // 教师姓名
	EmployeeId string `gorm:"column:employee_id" json:"employeeId"` // 工号
	Gender int `gorm:"column:gender;default:0" json:"gender"` // 性别：0-未知 1-男 2-女
	Phone string `gorm:"column:phone" json:"phone"` // 手机号
	Email string `gorm:"column:email" json:"email"` // 邮箱
	Subject string `gorm:"column:subject" json:"subject"` // 所教学科
	Title string `gorm:"column:title" json:"title"` // 职称
	Status int `gorm:"column:status;default:1" json:"status"` // 状态：0-离职 1-在职
	HireDate time.Time `gorm:"column:hire_date" json:"hireDate"` // 入职日期
	BirthDate time.Time `gorm:"column:birth_date" json:"birthDate"` // 出生日期
	CreatedAt time.Time `gorm:"column:created_at" json:"createdAt"` // 创建时间
	UpdatedAt time.Time `gorm:"column:updated_at" json:"updatedAt"` // 更新时间
	DeletedAt gorm.DeletedAt `gorm:"column:deleted_at" json:"deletedAt"` // 删除时间
	CreatedBy uint `gorm:"column:created_by" json:"createdBy"` // 创建人
}

// TestTeacherList demo_teacher 列表
type TestTeacherList []TestTeacher

// NewTestTeacher 创建demo_teacher实例
func NewTestTeacher() *TestTeacher {
	return &TestTeacher{}
}

// NewTestTeacherList 创建demo_teacher列表实例
func NewTestTeacherList() *TestTeacherList {
	return &TestTeacherList{}
}

// TableName 指定表名
func (TestTeacher) TableName() string {
	return "demo_teacher"
}

// GetByID 根据ID获取demo_teacher
func (m *TestTeacher) GetByID(c context.Context, id uint) error {
	return app.DB().WithContext(c).First(m, id).Error
}

// Create 创建demo_teacher记录
func (m *TestTeacher) Create(c context.Context) error {
	return app.DB().WithContext(c).Create(m).Error
}

// Update 更新demo_teacher记录
func (m *TestTeacher) Update(c context.Context) error {
	return app.DB().WithContext(c).Save(m).Error
}

// Delete 软删除demo_teacher记录
func (m *TestTeacher) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(m).Error
}

// IsEmpty 检查模型是否为空
func (m *TestTeacher) IsEmpty() bool {
	return m == nil || m.TcId == 0
}

// Find 查询demo_teacher列表
func (l *TestTeacherList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(c).Model(&TestTeacher{}).Scopes(funcs...).Find(l).Error
}

// GetTotal 获取demo_teacher总数
func (l *TestTeacherList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(c).Model(&TestTeacher{}).Scopes(query...).Count(&count).Error
	return count, err
}