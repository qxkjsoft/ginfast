package controllers

import (
	"bytes"
	"errors"

	"gin-fast/app/models"
	"gin-fast/app/service"
	"gin-fast/app/utils/common"

	"github.com/gin-gonic/gin"
)

// PluginsManagerController 插件管理控制器
type PluginsManagerController struct {
	Common
	service *service.PluginsManagerService
}

// NewPluginsManagerController 创建插件管理控制器
func NewPluginsManagerController() *PluginsManagerController {
	return &PluginsManagerController{
		Common:  Common{},
		service: service.NewPluginsManagerService(),
	}
}

// GetPluginsExport 获取所有插件导出配置
// @Summary 获取插件导出配置列表
// @Description 获取plugins文件夹下所有子文件夹中的plugin_export.json文件内容
// @Tags 插件管理
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{} "成功返回插件导出配置列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /pluginsmanager/exports [get]
// @Security ApiKeyAuth
func (pmc *PluginsManagerController) GetPluginsExport(c *gin.Context) {
	pluginsExports, err := pmc.service.GetPluginsExportList()
	if err != nil {
		pmc.FailAndAbort(c, "读取plugins目录失败", err, 500)
	}

	// 返回成功响应
	pmc.Success(c, gin.H{
		"list": pluginsExports,
	})
}

// ExportPlugin 导出插件为压缩包
// @Summary 导出插件
// @Description 根据plugin_export中的导出配置，将指定插件打包成压缩文件
// @Tags 插件管理
// @Accept json
// @Produce application/zip
// @Param body body map[string]string true "请求体 {folderName: 插件文件夹名称}"
// @Success 200 "返回压缩包文件"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /pluginsmanager/export [post]
// @Security ApiKeyAuth
func (pmc *PluginsManagerController) ExportPlugin(c *gin.Context) {
	var req map[string]string
	if err := c.ShouldBindJSON(&req); err != nil {
		pmc.FailAndAbort(c, "请求参数错误", err, 400)
		return
	}
	folderName := req["folderName"]
	if folderName == "" {
		pmc.FailAndAbort(c, "插件名称不能为空", errors.New("folderName is required"), 400)
	}

	// 先写入到内存中，需要先设置响应头
	buf := new(bytes.Buffer)
	version, err := pmc.service.ExportPluginToWriter(folderName, buf)
	if err != nil {
		pmc.FailAndAbort(c, err.Error(), err, 500)
	}

	// 构建包含版本信息的文件名
	filename := folderName
	if version != "" {
		filename = folderName + "_" + version
	}

	// 设置响应头 - 使用正确的 Content-Disposition 格式
	c.Header("Content-Type", "application/zip")
	// 测试使用RFC 5987的filename*参数，并同时保留filename以兼容旧浏览器
	c.Header("Content-Disposition", "attachment; filename=\""+filename+".zip\"")
	c.Header("Cache-Control", "no-cache, no-store, must-revalidate")

	// 将缩缩包内容写入响应体
	c.DataFromReader(200, int64(buf.Len()), "application/zip", buf, nil)
}

// ImportPlugin 导入插件
// @Summary 导入插件
// @Description 从上传的压缩包导入插件
// @Tags 插件管理
// @Accept multipart/form-data
// @Produce json
// @Param file formData file true "插件压缩包文件"
// @Param overwriteDB formData int false "是否覆盖数据库 (0:否, 1:是)" default(0)
// @Param importMenu formData int false "是否导入菜单 (0:否, 1:是)" default(0)
// @Param overwriteFiles formData int false "是否覆盖文件 (0:否, 1:是)" default(0)
// @Success 200 {object} map[string]interface{} "导入成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /pluginsmanager/import [post]
// @Security ApiKeyAuth
func (pmc *PluginsManagerController) ImportPlugin(c *gin.Context) {
	// 获取上传的文件
	file, err := c.FormFile("file")
	if err != nil {
		pmc.FailAndAbort(c, "请上传插件压缩包文件", err, 400)
	}

	// 解析请求参数
	var req models.PluginImportRequest
	if err := c.ShouldBind(&req); err != nil {
		pmc.FailAndAbort(c, "请求参数错误", err, 400)
	}

	// 如果UserID为0，使用当前登录用户的ID
	if req.UserID == 0 {
		req.UserID = common.GetCurrentUserID(c)
	}

	// 打开上传的文件
	src, err := file.Open()
	if err != nil {
		pmc.FailAndAbort(c, "打开上传文件失败", err, 500)
	}
	defer src.Close()

	// 调用服务层导入插件
	existingItems, err := pmc.service.ImportPluginFromReader(c, src, req)
	if err != nil {
		pmc.FailAndAbort(c, err.Error(), err, 500)
	}

	// 如果CheckExist=true，仅检查了，返回存在的项目列表
	if req.CheckExist {
		if !existingItems.IsEmpty() {
			pmc.SuccessWithMessage(c, "以下项已存在，请核查", existingItems, 1)
			return
		}
	}

	// 返回成功响应
	pmc.SuccessWithMessage(c, "插件导入成功")
}

// UninstallPlugin 卸载插件
// @Summary 卸载插件
// @Description 根据plugin_export.json配置，卸载指定插件（移除菜单、文件和数据库表）
// @Tags 插件管理
// @Accept json
// @Produce json
// @Param folderName query string true "插件文件夹名称"
// @Success 200 {object} map[string]interface{} "卸载成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /pluginsmanager/uninstall [delete]
// @Security ApiKeyAuth
func (pmc *PluginsManagerController) UninstallPlugin(c *gin.Context) {
	folderName := c.Query("folderName")
	if folderName == "" {
		pmc.FailAndAbort(c, "插件名称不能为空", errors.New("folderName is required"), 400)
	}

	// 调用服务层卸载插件
	err := pmc.service.UninstallPlugin(c, folderName)
	if err != nil {
		pmc.FailAndAbort(c, err.Error(), err, 500)
	}

	// 返回成功响应
	pmc.SuccessWithMessage(c, "插件卸载成功")
}
