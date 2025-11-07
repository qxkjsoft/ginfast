package controllers

import (
	"gin-fast/app/models"
	"gin-fast/app/service"

	"github.com/gin-gonic/gin"
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

	database, _ := request["database"].(string)
	table, _ := request["table"].(string)

	if database == "" || table == "" {
		cgc.FailAndAbort(ctx, "数据库名称、表名不能为空", nil)
	}
	// 获取表注释
	comment, err := cgc.service.GetTableComment(database, table)
	if err != nil {
		cgc.FailAndAbort(ctx, "获取表注释失败", err)
	}
	// 获取表的字段信息
	columns, err := cgc.service.GetTableColumns(database, table)
	if err != nil {
		cgc.FailAndAbort(ctx, "获取字段信息失败", err)
	}
	// 检查是否包含主键
	if models.TableColumns(columns).PrimaryKeyCount() != 1 {
		cgc.FailAndAbort(ctx, "表必须包含一个主键", nil)
	}

	// 生成后端代码
	err = cgc.service.GenerateBackendCodeFiles(ctx, table, comment, columns)
	if err != nil {
		cgc.FailAndAbort(ctx, "生成后端代码失败", err)
	}

	// 生成前端代码
	err = cgc.service.GenerateFrontendCodeFiles(table, columns)
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
// @Param request body map[string]interface{} true "预览代码请求参数"
// @Success 200 {object} map[string]interface{} "成功返回预览的代码"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/preview [post]
// @Security ApiKeyAuth
func (cgc *CodeGenController) PreviewCode(ctx *gin.Context) {
	database := ctx.Query("database")
	table := ctx.Query("table")
	if database == "" || table == "" {
		cgc.FailAndAbort(ctx, "数据库名称和表名不能为空", nil)
	}

	// 使用service层生成预览代码
	result, err := cgc.service.GenerateCode(database, table)
	if err != nil {
		cgc.FailAndAbort(ctx, "生成预览代码失败", err)
	}

	cgc.Success(ctx, gin.H{
		"preview": result,
	})
}

// DownloadCode 下载生成的代码
// @Summary 下载生成的代码
// @Description 下载根据配置生成的模型、控制器、服务代码文件
// @Tags 代码生成
// @Accept json
// @Produce json
// @Param request body map[string]interface{} true "下载代码请求参数"
// @Success 200 {object} map[string]interface{} "成功返回下载链接"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/download [post]
// @Security ApiKeyAuth
func (cgc *CodeGenController) DownloadCode(ctx *gin.Context) {
	var request map[string]interface{}
	if err := ctx.ShouldBindJSON(&request); err != nil {
		cgc.FailAndAbort(ctx, "请求参数解析失败", err)
	}

	database, _ := request["database"].(string)
	table, _ := request["table"].(string)
	moduleName, _ := request["moduleName"].(string)

	if database == "" || table == "" || moduleName == "" {
		cgc.FailAndAbort(ctx, "数据库名称、表名和模块名称不能为空", nil)
	}

	// 使用service层生成代码并创建下载文件
	downloadPath, err := cgc.service.DownloadCode(database, table, moduleName)
	if err != nil {
		cgc.FailAndAbort(ctx, "下载代码失败", err)
	}

	cgc.Success(ctx, gin.H{
		"downloadUrl": downloadPath,
	})
}

// GetConfig 获取代码生成配置
// @Summary 获取代码生成配置
// @Description 获取当前的代码生成配置
// @Tags 代码生成
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{} "成功返回配置信息"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/config [get]
// @Security ApiKeyAuth
func (cgc *CodeGenController) GetConfig(ctx *gin.Context) {
	config, err := cgc.service.GetConfig()
	if err != nil {
		cgc.FailAndAbort(ctx, "获取配置失败", err)
	}

	cgc.Success(ctx, gin.H{
		"config": config,
	})
}

// UpdateConfig 更新代码生成配置
// @Summary 更新代码生成配置
// @Description 更新代码生成配置信息
// @Tags 代码生成
// @Accept json
// @Produce json
// @Param config body models.CodeGenConfig true "配置信息"
// @Success 200 {object} map[string]interface{} "成功返回更新后的配置"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/config [put]
// @Security ApiKeyAuth
func (cgc *CodeGenController) UpdateConfig(ctx *gin.Context) {
	var config models.CodeGenConfig
	if err := ctx.ShouldBindJSON(&config); err != nil {
		cgc.FailAndAbort(ctx, "参数绑定失败", err)
	}

	// 使用service层更新配置
	err := cgc.service.UpdateConfig(config)
	if err != nil {
		cgc.FailAndAbort(ctx, "更新配置失败", err)
	}

	cgc.Success(ctx, gin.H{
		"message": "配置更新成功",
		"config":  config,
	})
}

// GetTemplates 获取模板列表
// @Summary 获取模板列表
// @Description 获取可用的代码生成模板列表
// @Tags 代码生成
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{} "成功返回模板列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/templates [get]
// @Security ApiKeyAuth
func (cgc *CodeGenController) GetTemplates(ctx *gin.Context) {
	templates, err := cgc.service.GetTemplates()
	if err != nil {
		cgc.FailAndAbort(ctx, "获取模板列表失败", err)
	}

	cgc.Success(ctx, gin.H{
		"templates": templates,
	})
}

// GetTemplateContent 获取模板内容
// @Summary 获取模板内容
// @Description 根据模板名称获取模板的具体内容
// @Tags 代码生成
// @Accept json
// @Produce json
// @Param templateName query string true "模板名称"
// @Success 200 {object} map[string]interface{} "成功返回模板内容"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /codegen/template [get]
// @Security ApiKeyAuth
func (cgc *CodeGenController) GetTemplateContent(ctx *gin.Context) {
	templateName := ctx.Query("templateName")
	if templateName == "" {
		cgc.FailAndAbort(ctx, "模板名称不能为空", nil)
	}

	// 使用service层获取模板内容
	templateContent, err := cgc.service.GetTemplateContent(templateName)
	if err != nil {
		cgc.FailAndAbort(ctx, "获取模板内容失败", err)
	}

	cgc.Success(ctx, gin.H{
		"templateName":    templateName,
		"templateContent": templateContent,
	})
}
