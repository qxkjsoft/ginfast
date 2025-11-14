package models

import (
	"context"
	"time"
	"gin-fast/app/global/app"
	"gorm.io/gorm"
)

// TestStudents demo_students 模型结构体
type TestStudents struct {
	StuId uint `gorm:"column:student_id;primaryKey;not null;autoIncrement" json:"stuId"` // ID
	StuName string `gorm:"column:student_name;not null" json:"stuName"` // 姓名
	Age int `gorm:"column:age;not null;default:18" json:"age"` // 年龄
	Gender string `gorm:"column:gender;not null;default:''" json:"gender"` // 性别
	ClassName string `gorm:"column:class_name;not null" json:"className"` // 班级名称
	AdmissionDate time.Time `gorm:"column:admission_date;not null" json:"admissionDate"` // 入学日期
	Email string `gorm:"column:email;uniqueIndex" json:"email"` //  邮箱
	Phone string `gorm:"column:phone" json:"phone"` // 电话号码
	Address string `gorm:"column:address" json:"address"` // 地址
	CreatedAt time.Time `gorm:"column:created_at" json:"createdAt"` // 创建时间
	UpdatedAt time.Time `gorm:"column:updated_at" json:"updatedAt"` // 更新时间
	DeletedAt gorm.DeletedAt `gorm:"column:deleted_at" json:"deletedAt"` // 删除时间
	CreatedBy uint `gorm:"column:created_by" json:"createdBy"` // 创建人
	TenantId uint `gorm:"column:tenant_id" json:"tenantId"` // 租户ID字段
}

// TestStudentsList demo_students 列表
type TestStudentsList []TestStudents

// NewTestStudents 创建demo_students实例
func NewTestStudents() *TestStudents {
	return &TestStudents{}
}

// NewTestStudentsList 创建demo_students列表实例
func NewTestStudentsList() *TestStudentsList {
	return &TestStudentsList{}
}

// TableName 指定表名
func (TestStudents) TableName() string {
	return "demo_students"
}

// GetByID 根据ID获取demo_students
func (m *TestStudents) GetByID(c context.Context, id uint) error {
	return app.DB().WithContext(c).First(m, id).Error
}

// Create 创建demo_students记录
func (m *TestStudents) Create(c context.Context) error {
	return app.DB().WithContext(c).Create(m).Error
}

// Update 更新demo_students记录
func (m *TestStudents) Update(c context.Context) error {
	return app.DB().WithContext(c).Save(m).Error
}

// Delete 软删除demo_students记录
func (m *TestStudents) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(m).Error
}

// IsEmpty 检查模型是否为空
func (m *TestStudents) IsEmpty() bool {
	return m == nil || m.StuId == 0
}

// Find 查询demo_students列表
func (l *TestStudentsList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(c).Model(&TestStudents{}).Scopes(funcs...).Find(l).Error
}

// GetTotal 获取demo_students总数
func (l *TestStudentsList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(c).Model(&TestStudents{}).Scopes(query...).Count(&count).Error
	return count, err
}