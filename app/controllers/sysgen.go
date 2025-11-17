package controllers

import (
	"gin-fast/app/models"
	"gin-fast/app/service"
	"strconv"

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

// BatchInsert 批量创建代码生成配置
// @Summary 批量创建代码生成配置
// @Description 根据数据库名称和表名称集合批量创建代码生成配置和字段信息，避免重复创建
// @Tags 代码生成配置管理
// @Accept json
// @Produce json
// @Param request body models.SysGenBatchInsertRequest true "批量创建请求参数"
// @Success 200 {object} map[string]interface{} "成功返回创建结果"
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

// GetByID 根据ID获取代码生成配置详情
// @Summary 获取代码生成配置详情
// @Description 根据ID获取代码生成配置详情
// @Tags 代码生成配置管理
// @Accept json
// @Produce json
// @Param id path int true "代码生成配置ID"
// @Success 200 {object} map[string]interface{} "成功返回代码生成配置详情"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 404 {object} map[string]interface{} "数据不存在"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysGen/{id} [get]
// @Security ApiKeyAuth
func (sgc *SysGenController) GetByID(c *gin.Context) {
	// 从路径参数中获取ID
	id := c.Param("id")
	if id == "" {
		sgc.FailAndAbort(c, "ID参数不能为空", nil)
	}

	// 将ID转换为uint
	genID, err := strconv.ParseUint(id, 10, 64)
	if err != nil || genID == 0 {
		sgc.FailAndAbort(c, "ID参数格式错误", err)
	}

	// 创建SysGen实例并查找数据
	gen := models.NewSysGen()
	gen.ID = uint(genID)
	err = gen.Find(c, func(db *gorm.DB) *gorm.DB {
		return db.Preload("SysGenFields") // 预加载字段信息
	})
	if err != nil {
		sgc.FailAndAbort(c, "查询代码生成配置失败", err)
	}

	// 检查数据是否存在
	if gen.IsEmpty() {
		sgc.FailAndAbort(c, "代码生成配置不存在", nil)
	}

	// 返回成功响应
	sgc.Success(c, gen)
}

// Update 根据ID更新代码生成配置和字段信息
// @Summary 更新代码生成配置和字段信息
// @Description 根据ID更新sys_gen表的module_name、describe字段，以及sys_gen_field表的data_name、data_comment字段
// @Tags 代码生成配置管理
// @Accept json
// @Produce json
// @Param request body models.SysGenUpdateRequest true "更新请求参数"
// @Success 200 {object} map[string]interface{} "成功返回更新结果"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysGen/update [put]
// @Security ApiKeyAuth
func (sgc *SysGenController) Update(c *gin.Context) {
	var req models.SysGenUpdateRequest
	if err := req.Validate(c); err != nil {
		sgc.FailAndAbort(c, err.Error(), err)
	}

	// 调用服务层方法进行更新
	err := sgc.service.Update(c, &req)
	if err != nil {
		sgc.FailAndAbort(c, "更新代码生成配置失败", err)
	}

	// 返回成功响应
	sgc.Success(c, "更新成功")
}

// Delete 根据ID删除代码生成配置和字段信息
// @Summary 删除代码生成配置和字段信息
// @Description 根据ID硬删除sys_gen表记录以及关联的sys_gen_field表记录
// @Tags 代码生成配置管理
// @Accept json
// @Produce json
// @Param id path int true "代码生成配置ID"
// @Success 200 {object} map[string]interface{} "成功返回删除结果"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysGen/{id} [delete]
// @Security ApiKeyAuth
func (sgc *SysGenController) Delete(c *gin.Context) {
	// 从路径参数中获取ID
	id := c.Param("id")
	if id == "" {
		sgc.FailAndAbort(c, "ID参数不能为空", nil)
	}

	// 将ID转换为uint
	genID, err := strconv.ParseUint(id, 10, 64)
	if err != nil || genID == 0 {
		sgc.FailAndAbort(c, "ID参数格式错误", err)
	}

	// 调用服务层方法进行删除
	err = sgc.service.Delete(c, uint(genID))
	if err != nil {
		sgc.FailAndAbort(c, "删除代码生成配置失败", err)
	}

	// 返回成功响应
	sgc.Success(c, "删除成功")
}

// RefreshFields 根据sys_gen的id刷新数据库表字段信息
// @Summary 刷新字段信息
// @Description 根据sys_gen的id刷新数据库表字段信息
// @Tags 代码生成配置管理
// @Accept json
// @Produce json
// @Param id path int true "代码生成配置ID"
// @Success 200 {object} map[string]interface{} "成功返回刷新结果"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysGen/{id}/refresh [put]
// @Security ApiKeyAuth
func (sgc *SysGenController) RefreshFields(c *gin.Context) {
	var req models.SysGenRefreshFieldsRequest
	if err := req.Validate(c); err != nil {
		sgc.FailAndAbort(c, err.Error(), err)
	}

	// 调用服务层方法刷新字段信息
	err := sgc.service.RefreshFields(c, req.ID)
	if err != nil {
		sgc.FailAndAbort(c, "刷新字段信息失败", err)
	}

	// 返回成功响应
	sgc.Success(c, "字段信息刷新成功")
}
