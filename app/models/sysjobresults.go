package models

import (
	"context"
	"gin-fast/app/global/app"
	"time"

	"gorm.io/gorm"
)

// SysJobResults sys_job_results 模型结构体
type SysJobResults struct {
	Id         uint64     `gorm:"column:id;primaryKey;not null;autoIncrement" json:"id"`   // 自增主键
	JobId      string     `gorm:"column:job_id;not null;index" json:"jobId"`               // 任务ID
	Status     string     `gorm:"column:status;not null;index" json:"status"`              // 执行状态
	Error      string     `gorm:"column:error" json:"error"`                               // 错误信息
	StartTime  *time.Time `gorm:"column:start_time;not null;index" json:"startTime"`       // 开始时间
	EndTime    *time.Time `gorm:"column:end_time;not null" json:"endTime"`                 // 结束时间
	Duration   int64      `gorm:"column:duration;not null" json:"duration"`                // 执行时长(纳秒)
	RetryCount int        `gorm:"column:retry_count;not null;default:0" json:"retryCount"` // 重试次数
	CreatedAt  *time.Time `gorm:"column:created_at;not null;index" json:"createdAt"`       // 记录创建时间
}

// SysJobResultsList sys_job_results 列表
type SysJobResultsList []SysJobResults

// NewSysJobResults 创建sys_job_results实例
func NewSysJobResults() *SysJobResults {
	return &SysJobResults{}
}

// NewSysJobResultsList 创建sys_job_results列表实例
func NewSysJobResultsList() *SysJobResultsList {
	return &SysJobResultsList{}
}

// TableName 指定表名
func (SysJobResults) TableName() string {
	return "sys_job_results"
}

// GetByID 根据ID获取sys_job_results
func (m *SysJobResults) GetByID(c context.Context, id uint64) error {
	return app.DB().WithContext(c).First(m, id).Error
}

// Create 创建sys_job_results记录
func (m *SysJobResults) Create(c context.Context) error {
	return app.DB().WithContext(c).Create(m).Error
}

// Update 更新sys_job_results记录
func (m *SysJobResults) Update(c context.Context) error {
	return app.DB().WithContext(c).Save(m).Error
}

// Delete 软删除sys_job_results记录
func (m *SysJobResults) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(m).Error
}

// IsEmpty 检查模型是否为空
func (m *SysJobResults) IsEmpty() bool {
	return m == nil || m.Id == 0
}

// Find 查询sys_job_results列表
func (l *SysJobResultsList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(c).Model(&SysJobResults{}).Scopes(funcs...).Find(l).Error
}

// GetTotal 获取sys_job_results总数
func (l *SysJobResultsList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(c).Model(&SysJobResults{}).Scopes(query...).Count(&count).Error
	return count, err
}
