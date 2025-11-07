package controllers

import (
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/service"
	"gin-fast/app/utils/datascope"
	"gin-fast/app/utils/tenanthelper"
	"regexp"
	"strings"

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
}

// NewSysGenController 创建代码生成配置控制器
func NewSysGenController() *SysGenController {
	return &SysGenController{
		Common: Common{},
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
	total, err := genList.GetTotal(c, query, datascope.GetDataScope(c), tenanthelper.TenantScope(c))
	if err != nil {
		sgc.FailAndAbort(c, "获取代码生成配置总数失败", err)
	}

	// 获取分页数据及数据权限
	err = genList.Find(c, req.Paginate(), query, func(d *gorm.DB) *gorm.DB {
		return d
	}, datascope.GetDataScope(c), tenanthelper.TenantScope(c))
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
// @Description 根据数据库名称和表名称集合批量插入代码生成配置，避免重复插入
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
	if err := c.ShouldBindJSON(&req); err != nil {
		sgc.FailAndAbort(c, "请求参数解析失败", err)
	}

	// 获取数据库连接
	db := app.DB()

	// 开始事务
	tx := db.Begin()
	if tx.Error != nil {
		sgc.FailAndAbort(c, "开始事务失败", tx.Error)
	}
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// 创建代码生成服务实例
	codeGenService := service.NewCodeGenService()

	// 记录成功和失败的表
	successTables := make([]string, 0)
	failedTables := make(map[string]string)

	// 遍历表名称集合
	for _, tableName := range req.Tables {
		// 获取表注释
		describe, err := codeGenService.GetTableComment(req.Database, tableName)
		if err != nil {
			failedTables[tableName] = fmt.Sprintf("获取表注释失败: %v", err)
			continue
		}

		// 处理模块名称：只保留字母且全小写
		moduleName := strings.ToLower(regexp.MustCompile("[^a-zA-Z]").ReplaceAllString(tableName, ""))

		// 检查是否已存在相同的记录
		var existingGen models.SysGen
		err = tx.Where("name = ? AND module_name = ?", tableName, moduleName).First(&existingGen).Error
		if err != nil && err != gorm.ErrRecordNotFound {
			failedTables[tableName] = fmt.Sprintf("查询记录失败: %v", err)
			continue
		}

		// 如果记录不存在，则插入新记录
		if existingGen.IsEmpty() {
			gen := models.NewSysGen()
			gen.Name = tableName
			gen.ModuleName = moduleName
			gen.Describe = describe
			// 插入记录
			if err := tx.Create(gen).Error; err != nil {
				failedTables[tableName] = fmt.Sprintf("插入记录失败: %v", err)
				continue
			}
		}
		// 添加到成功列表
		successTables = append(successTables, tableName)
	}

	// 提交事务
	if err := tx.Commit().Error; err != nil {
		sgc.FailAndAbort(c, "提交事务失败", err)
	}

	// 返回成功响应
	sgc.Success(c, gin.H{
		"successCount":  len(successTables),
		"successTables": successTables,
		"failedCount":   len(failedTables),
		"failedTables":  failedTables,
	})
}
