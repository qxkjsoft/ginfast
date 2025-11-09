package controllers

import (
	"gin-fast/app/models"
	"gin-fast/app/service"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysGenController 代码生成配置控制器
// @Summary 代码生成配置管理API
// @Description 代码生成配置管理相关接口
// @Tags 代码生成配置管理
// @Accept json
// @Produce json
// @Router /sysGen [get]
type SysGenController struct {
	Common
	service *service.SysGenService
}

// NewSysGenController 创建代码生成配置控制器
func NewSysGenController() *SysGenController {
	return &SysGenController{
		Common:  Common{},
		service: service.NewSysGenService(),
	}
}

// List 代码生成配置列表（分页查询）
// @Summary 代码生成配置列表
// @Description 获取代码生成配置列表，支持分页和过滤
// @Tags 代码生成配置管理
// @Accept json
// @Produce json
// @Param pageNum query int false "页码" default(1)
// @Param pageSize query int false "每页数量" default(10)
// @Param name query string false "表名"
// @Param moduleName query string false "模块名称"
// @Success 200 {object} map[string]interface{} "成功返回代码生成配置列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysGen/list [get]
// @Security ApiKeyAuth
func (sgc *SysGenController) List(c *gin.Context) {
	var req models.SysGenListRequest
	if err := req.Validate(c); err != nil {
		sgc.FailAndAbort(c, err.Error(), err)
	}

	// 获取查询条件
	query := req.Handle()

	// 获取总数
	genList := models.NewSysGenList()
	total, err := genList.GetTotal(c, query)
	if err != nil {
		sgc.FailAndAbort(c, "获取代码生成配置总数失败", err)
	}

	// 获取分页数据及数据权限
	err = genList.Find(c, req.Paginate(), query, func(d *gorm.DB) *gorm.DB {
		return d
	})
	if err != nil {
		sgc.FailAndAbort(c, "获取代码生成配置列表失败", err)
	}

	// 返回成功响应
	sgc.Success(c, gin.H{
		"list":  genList,
		"total": total,
	})
}

// BatchInsert 批量插入代码生成配置
// @Summary 批量插入代码生成配置
// @Description 根据数据库名称和表名称集合批量插入代码生成配置和字段信息，避免重复插入
// @Tags 代码生成配置管理
// @Accept json
// @Produce json
// @Param request body models.SysGenBatchInsertRequest true "批量插入请求参数"
// @Success 200 {object} map[string]interface{} "成功返回插入结果"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysGen/batchInsert [post]
// @Security ApiKeyAuth
func (sgc *SysGenController) BatchInsert(c *gin.Context) {
	var req models.SysGenBatchInsertRequest
	if err := req.Validate(c); err != nil {
		sgc.FailAndAbort(c, err.Error(), err)
	}

	// 调用服务层方法进行批量插入
	result, err := sgc.service.BatchInsert(c, &req)
	if err != nil {
		sgc.FailAndAbort(c, "批量插入代码生成配置失败", err)
	}

	// 返回成功响应
	sgc.Success(c, result)
}
