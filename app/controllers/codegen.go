package controllers

import (
	"fmt"
	"gin-fast/app/models"
	"gin-fast/app/service"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// CodeGenController 代码生成控制器
type CodeGenController struct {
	Common
	service *service.CodeGenService // 代码生成服务
}

// NewCodeGenController 创建代码生成控制器
func NewCodeGenController() *CodeGenController {
	return &CodeGenController{
		Common:  Common{},
		service: service.NewCodeGenService(),
	}
}

// GetDatabases 获取数据库列表
// @Summary 获取数据库列表
// @Description 获取当前连接的数据库服务器中的所有数据库列表
// @Tags 代码生成
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{} "成功返回数据库列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/databases [get]
// @Security ApiKeyAuth
func (cgc *CodeGenController) GetDatabases(ctx *gin.Context) {
	// 使用service层获取数据库列表
	databases, err := cgc.service.GetDatabases("")
	if err != nil {
		cgc.FailAndAbort(ctx, "获取数据库列表失败", err)
	}

	cgc.Success(ctx, gin.H{
		"databases": databases,
	})
}

// GetTables 获取指定数据库中的所有表
// @Summary 获取指定数据库中的所有表
// @Description 根据数据库名称获取该数据库中的所有表名
// @Tags 代码生成
// @Accept json
// @Produce json
// @Param database query string true "数据库名称"
// @Success 200 {object} map[string]interface{} "成功返回表列表"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/tables [get]
// @Security ApiKeyAuth
func (cgc *CodeGenController) GetTables(ctx *gin.Context) {
	database := ctx.Query("database")
	// 使用service层获取表列表
	tables, err := cgc.service.GetTables("", database)
	if err != nil {
		cgc.FailAndAbort(ctx, "获取表列表失败", err)
	}

	cgc.Success(ctx, gin.H{
		"tables": tables,
	})
}

// GetTableColumns 获取指定表的字段信息
// @Summary 获取指定表的字段信息
// @Description 根据数据库名称和表名获取该表的所有字段信息
// @Tags 代码生成
// @Accept json
// @Produce json
// @Param database query string true "数据库名称"
// @Param table query string true "表名"
// @Success 200 {object} map[string]interface{} "成功返回字段列表"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/columns [get]
// @Security ApiKeyAuth
func (cgc *CodeGenController) GetTableColumns(ctx *gin.Context) {
	database := ctx.Query("database")
	table := ctx.Query("table")
	if database == "" || table == "" {
		cgc.FailAndAbort(ctx, "数据库名称和表名不能为空", nil)

	}

	// 使用service层获取字段信息
	columns, err := cgc.service.GetTableColumns(database, table)
	if err != nil {
		cgc.FailAndAbort(ctx, "获取字段信息失败", err)
	}

	cgc.Success(ctx, gin.H{
		"columns": columns,
	})
}

// GenerateCode 生成代码
// @Summary 生成代码
// @Description 根据配置生成模型、控制器、服务代码
// @Tags 代码生成
// @Accept json
// @Produce json
// @Param request body map[string]interface{} true "生成代码请求参数"
// @Success 200 {object} map[string]interface{} "成功返回生成的代码"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/generate [post]
// @Security ApiKeyAuth
func (cgc *CodeGenController) GenerateCode(ctx *gin.Context) {
	var request map[string]interface{}
	if err := ctx.ShouldBindJSON(&request); err != nil {
		cgc.FailAndAbort(ctx, "请求参数解析失败", err)
	}

	genID, _ := request["genId"].(float64)
	if genID == 0 {
		cgc.FailAndAbort(ctx, "代码生成配置ID不能为空", nil)
	}

	// 使用service层获取代码生成配置详情
	sysGen := models.NewSysGen()
	err := sysGen.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("id = ?", uint(genID)).Preload("SysGenFields")
	})
	if err != nil {
		cgc.FailAndAbort(ctx, "获取代码生成配置详情失败", err)
	}
	if sysGen.SysGenFields.PrimaryKeyCount() != 1 {
		cgc.FailAndAbort(ctx, "表必须也只能包含一个主键", nil)
	}
	// 生成后端代码
	err = cgc.service.GenerateBackendCodeFiles(ctx, sysGen)
	if err != nil {
		cgc.FailAndAbort(ctx, "生成后端代码失败", err)
	}

	// 生成前端代码
	err = cgc.service.GenerateFrontendCodeFiles(sysGen)
	if err != nil {
		cgc.FailAndAbort(ctx, "生成前端代码失败", err)
	}

	cgc.Success(ctx, gin.H{})
}

// PreviewCode 预览生成的代码
// @Summary 预览生成的代码
// @Description 预览根据配置生成的模型、控制器、服务代码
// @Tags 代码生成
// @Accept json
// @Produce json
// @Param genId query uint true "代码生成配置ID"
// @Success 200 {object} map[string]interface{} "成功返回预览的代码"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/preview [get]
// @Security ApiKeyAuth
func (cgc *CodeGenController) PreviewCode(ctx *gin.Context) {
	genID := ctx.Query("genId")
	if genID == "" {
		cgc.FailAndAbort(ctx, "代码生成配置ID不能为空", nil)
	}

	var id uint
	_, err := fmt.Sscanf(genID, "%d", &id)
	if err != nil || id == 0 {
		cgc.FailAndAbort(ctx, "代码生成配置ID格式错误", nil)
	}

	// 使用service层生成预览代码
	result, err := cgc.service.PreviewCode(ctx, id)
	if err != nil {
		cgc.FailAndAbort(ctx, "生成预览代码失败", err)
	}

	cgc.Success(ctx, gin.H{
		"preview": result,
	})
}
