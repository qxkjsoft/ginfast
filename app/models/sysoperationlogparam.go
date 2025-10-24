package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysOperationLogListRequest 操作日志列表查询请求
type SysOperationLogListRequest struct {
	BasePaging
	Validator
	Username  string `form:"username"`  // 用户名
	Module    string `form:"module"`    // 操作模块
	Operation string `form:"operation"` // 操作类型
	Status    string `form:"status"`    // 状态：success/error
	StartTime string `form:"startTime"` // 开始时间
	EndTime   string `form:"endTime"`   // 结束时间
	IP        string `form:"ip"`        // IP地址
}

func (r *SysOperationLogListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *SysOperationLogListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.Username != "" {
			db = db.Where("username LIKE ?", "%"+r.Username+"%")
		}
		if r.Module != "" {
			db = db.Where("module LIKE ?", "%"+r.Module+"%")
		}
		if r.Operation != "" {
			db = db.Where("operation = ?", r.Operation)
		}
		if r.Status != "" {
			switch r.Status {
			case "success":
				db = db.Where("status_code < 400")
			case "error":
				db = db.Where("status_code >= 400")
			}
		}
		if r.IP != "" {
			db = db.Where("ip LIKE ?", "%"+r.IP+"%")
		}
		if r.StartTime != "" && r.EndTime != "" {
			db = db.Where("created_at BETWEEN ? AND ?", r.StartTime, r.EndTime)
		}
		return db
	}
}

// SysOperationLogDeleteRequest 删除操作日志请求
type SysOperationLogDeleteRequest struct {
	Validator
	IDs []uint `form:"ids" validate:"required" message:"日志ID列表不能为空"`
}

func (r *SysOperationLogDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// SysOperationLogStatsRequest 操作日志统计请求
type SysOperationLogStatsRequest struct {
	Validator
	StartTime string `form:"startTime" validate:"required" message:"开始时间不能为空"`
	EndTime   string `form:"endTime" validate:"required" message:"结束时间不能为空"`
	Type      string `form:"type"` // 统计类型：daily/hourly/module/operation
}

func (r *SysOperationLogStatsRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
