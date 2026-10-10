package models

import (
	"context"
	"encoding/json"
	"errors"
	"strings"
	"gin-fast/app/global/app"
	"time"

	"gorm.io/gorm"
)

// SysJobs sys_jobs 模型结构体
type SysJobs struct {
	Id              string         `gorm:"column:id;primaryKey;not null" json:"id"`                           // 任务ID
	Group           string         `gorm:"column:group;not null;index" json:"group"`                          // 任务分组名称
	Name            string         `gorm:"column:name;not null" json:"name"`                                  // 任务名称
	Description     string         `gorm:"column:description" json:"description"`                             // 任务描述
	ExecutorName    string         `gorm:"column:executor_name;not null;index" json:"executorName"`           // 执行器名称
	ExecutionPolicy int            `gorm:"column:execution_policy;not null" json:"executionPolicy"`           // 执行策略
	Status          int            `gorm:"column:status;not null;index" json:"status"`                        // 任务状态
	CronExpression  string         `gorm:"column:cron_expression;not null" json:"cronExpression"`             // Cron表达式
	Parameters      string         `gorm:"column:parameters" json:"parameters"`                               // 任务参数
	BlockingPolicy  int            `gorm:"column:blocking_policy;not null;default:0" json:"blockingPolicy"`   // 阻塞策略
	Timeout         int64          `gorm:"column:timeout;not null;default:0" json:"timeout"`                  // 超时时间(纳秒)
	MaxRetry        int            `gorm:"column:max_retry;not null;default:0" json:"maxRetry"`               // 最大重试次数
	RetryInterval   int64          `gorm:"column:retry_interval;not null;default:0" json:"retryInterval"`     // 重试间隔(纳秒)
	ParallelNum     int            `gorm:"column:parallel_num;not null;default:0" json:"parallelNum"`         // 并行数
	CreatedAt       *time.Time     `gorm:"column:created_at;not null;" json:"createdAt"`                      // 创建时间
	UpdatedAt       *time.Time     `gorm:"column:updated_at;not null;" json:"updatedAt"`                      // 更新时间
	DeletedAt       gorm.DeletedAt `gorm:"index" json:"deletedAt"`
	CreatedBy       uint           `gorm:"column:created_by;comment:创建人" json:"createdBy"`
}

// SysJobsList sys_jobs 列表
type SysJobsList []SysJobs

// NewSysJobs 创建sys_jobs实例
func NewSysJobs() *SysJobs {
	return &SysJobs{}
}

// NewSysJobsList 创建sys_jobs列表实例
func NewSysJobsList() *SysJobsList {
	return &SysJobsList{}
}

// TableName 指定表名
func (SysJobs) TableName() string {
	return "sys_jobs"
}

// GetByID 根据ID获取sys_jobs；任务ID可能为非数字字符串（插件预置任务），必须显式参数化条件，
// 不能写 First(m, id)——非数字字符串会被 GORM 当裸 SQL 拼进 WHERE 导致语法错误
func (m *SysJobs) GetByID(c context.Context, id string) error {
	return app.DB().WithContext(c).Where("id = ?", id).First(m).Error
}

// Create 创建sys_jobs记录
func (m *SysJobs) Create(c context.Context) error {
	return app.DB().WithContext(c).Create(m).Error
}

// Update 更新sys_jobs记录
func (m *SysJobs) Update(c context.Context) error {
	return app.DB().WithContext(c).Save(m).Error
}

// Delete 软删除sys_jobs记录
func (m *SysJobs) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(m).Error
}

// IsEmpty 检查模型是否为空
func (m *SysJobs) IsEmpty() bool {
	return m == nil || m.Id == ""
}

// Find 查询sys_jobs列表
func (l *SysJobsList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(c).Model(&SysJobs{}).Scopes(funcs...).Find(l).Error
}

// GetTotal 获取sys_jobs总数
func (l *SysJobsList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(c).Model(&SysJobs{}).Scopes(query...).Count(&count).Error
	return count, err
}

// ParseJobParameters 校验并解析任务参数JSON字符串
// 空白串返回nil；调度器Job.Parameters为map类型，参数必须是JSON对象，否则返回友好错误
func ParseJobParameters(s string) (map[string]interface{}, error) {
	var parameters map[string]interface{}
	if strings.TrimSpace(s) == "" {
		return nil, nil
	}
	if err := json.Unmarshal([]byte(s), &parameters); err != nil {
		return nil, errors.New(`任务参数必须是JSON对象格式，例如 {"param1": "value1"}`)
	}
	return parameters, nil
}

// NormalizeJobParameters 规范化任务参数的入库值：空白串存储"{}"
// sys_jobs.parameters为JSON类型列（MySQL/PG），不接受空字符串文档
func NormalizeJobParameters(s string) string {
	if strings.TrimSpace(s) == "" {
		return "{}"
	}
	return s
}

// GetParameters 解析任务参数JSON字符串为map
func (m *SysJobs) GetParameters() (map[string]interface{}, error) {
	return ParseJobParameters(m.Parameters)
}
