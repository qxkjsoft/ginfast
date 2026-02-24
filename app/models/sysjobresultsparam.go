package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysJobResultsListRequest sys_job_results列表请求参数
type SysJobResultsListRequest struct {
	BasePaging
	Validator
	JobId          *string `form:"jobId"`          // 任务ID
	Status         *string `form:"status"`         // 执行状态
	StartTimeStart *string `form:"startTimeStart"` // 开始时间-起始
	StartTimeEnd   *string `form:"startTimeEnd"`   // 开始时间-结束
}

// Validate 验证请求参数
func (r *SysJobResultsListRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// Handle 获取查询条件
func (r *SysJobResultsListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.JobId != nil {
			// 默认等于查询
			db = db.Where("job_id = ?", *r.JobId)
		}
		if r.Status != nil {
			// 默认等于查询
			db = db.Where("status = ?", *r.Status)
		}
		if r.StartTimeStart != nil {
			db = db.Where("start_time >= ?", *r.StartTimeStart)
		}
		if r.StartTimeEnd != nil {
			db = db.Where("start_time <= ?", *r.StartTimeEnd)
		}
		return db
	}
}

// SysJobResultsDeleteRequest 删除sys_job_results请求参数
type SysJobResultsDeleteRequest struct {
	Validator
	Id uint64 `form:"id" validate:"required" message:"自增主键不能为空"` // 自增主键
}

// Validate 验证请求参数
func (r *SysJobResultsDeleteRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// SysJobResultsGetByIDRequest 根据ID获取sys_job_results请求参数
type SysJobResultsGetByIDRequest struct {
	Validator
	Id uint64 `uri:"id" validate:"required" message:"自增主键不能为空"` // 自增主键
}

// Validate 验证请求参数
func (r *SysJobResultsGetByIDRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}
