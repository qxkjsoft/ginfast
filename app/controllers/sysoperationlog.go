package controllers

import (
	"encoding/csv"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/tenanthelper"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysOperationLogController 操作日志控制器
type SysOperationLogController struct {
	Common
}

// NewSysOperationLogController 创建操作日志控制器
func NewSysOperationLogController() *SysOperationLogController {
	return &SysOperationLogController{
		Common: Common{},
	}
}

// List 操作日志列表
// @Summary 操作日志列表
// @Description 获取操作日志列表，支持分页和过滤
// @Tags 操作日志管理
// @Accept json
// @Produce json
// @Param pageNum query int false "页码" default(1)
// @Param pageSize query int false "每页数量" default(10)
// @Param username query string false "用户名"
// @Param module query string false "操作模块"
// @Param operation query string false "操作类型"
// @Param status query string false "状态" Enums(success,error)
// @Param startTime query string false "开始时间"
// @Param endTime query string false "结束时间"
// @Param ip query string false "IP地址"
// @Success 200 {object} map[string]interface{} "成功返回日志列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysOperationLog/list [get]
// @Security ApiKeyAuth
func (c *SysOperationLogController) List(ctx *gin.Context) {
	var req models.SysOperationLogListRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	logList := models.NewSysOperationLogList()
	total, err := logList.GetTotal(ctx, req.Handle(), tenanthelper.TenantScope(ctx))
	if err != nil {
		c.FailAndAbort(ctx, "获取日志总数失败", err)
	}

	err = logList.Find(ctx, req.Paginate(), req.Handle(), func(db *gorm.DB) *gorm.DB {
		return db.Order("created_at DESC")
	}, tenanthelper.TenantScope(ctx))
	if err != nil {
		c.FailAndAbort(ctx, "获取日志列表失败", err)
	}

	c.Success(ctx, gin.H{
		"list":  logList,
		"total": total,
	})
}

// Delete 删除操作日志
// @Summary 删除操作日志
// @Description 批量删除操作日志
// @Tags 操作日志管理
// @Accept json
// @Produce json
// @Param ids body []uint true "日志ID列表"
// @Success 200 {object} map[string]interface{} "删除成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysOperationLog/delete [delete]
// @Security ApiKeyAuth
func (c *SysOperationLogController) Delete(ctx *gin.Context) {
	var req models.SysOperationLogDeleteRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	if err := app.DB().WithContext(ctx).Where("id IN ?", req.IDs).Delete(&models.SysOperationLog{}).Error; err != nil {
		c.FailAndAbort(ctx, "删除操作日志失败", err)
	}

	c.SuccessWithMessage(ctx, "删除成功", nil)
}

// Export 导出操作日志
// @Summary 导出操作日志
// @Description 导出操作日志为CSV格式
// @Tags 操作日志管理
// @Accept json
// @Produce text/csv
// @Param username query string false "用户名"
// @Param module query string false "操作模块"
// @Param operation query string false "操作类型"
// @Param status query string false "状态" Enums(success,error)
// @Param startTime query string false "开始时间"
// @Param endTime query string false "结束时间"
// @Param ip query string false "IP地址"
// @Success 200 {file} file "CSV文件"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysOperationLog/export [get]
// @Security ApiKeyAuth
func (c *SysOperationLogController) Export(ctx *gin.Context) {
	var req models.SysOperationLogListRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	// 获取所有符合条件的日志
	logList := models.NewSysOperationLogList()
	err := logList.Find(ctx, req.Handle(), func(db *gorm.DB) *gorm.DB {
		return db.Order("created_at DESC").Limit(10000) // 限制导出数量
	})
	if err != nil {
		c.FailAndAbort(ctx, "获取导出数据失败", err)
	}

	// 设置响应头
	ctx.Header("Content-Type", "text/csv")
	ctx.Header("Content-Disposition", "attachment; filename=operation_logs_"+time.Now().Format("20060102_150405")+".csv")
	ctx.Header("Content-Transfer-Encoding", "binary")
	ctx.Header("Cache-Control", "no-cache")

	// 创建CSV写入器
	writer := csv.NewWriter(ctx.Writer)
	defer writer.Flush()

	// 写入表头
	headers := []string{"ID", "用户名", "操作模块", "操作类型", "请求方法", "请求路径", "IP地址", "状态码", "操作耗时(ms)", "操作时间", "错误信息"}
	if err := writer.Write(headers); err != nil {
		c.FailAndAbort(ctx, "导出CSV失败", err)
		return
	}

	// 写入数据
	for _, log := range logList {
		record := []string{
			strconv.FormatUint(uint64(log.ID), 10),
			log.Username,
			log.Module,
			log.Operation,
			log.Method,
			log.Path,
			log.IP,
			strconv.Itoa(log.StatusCode),
			strconv.FormatInt(log.Duration, 10),
			log.CreatedAt.Format("2006-01-02 15:04:05"),
			log.ErrorMsg,
		}
		if err := writer.Write(record); err != nil {
			c.FailAndAbort(ctx, "导出CSV失败", err)
			return
		}
	}
}
