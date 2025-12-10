package service

import (
	"archive/zip"
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"time"

	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/gormhelper"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// PluginsManagerService 插件管理服务
type PluginsManagerService struct{}

// NewPluginsManagerService 创建插件管理服务
func NewPluginsManagerService() *PluginsManagerService {
	return &PluginsManagerService{}
}

// GetPluginsExportList 获取所有插件导出配置
func (pms *PluginsManagerService) GetPluginsExportList() ([]models.PluginExport, error) {
	var pluginsExports []models.PluginExport

	// 获取plugins文件夹路径
	pluginsDirPath := "./plugins"

	// 读取plugins目录
	entries, err := os.ReadDir(pluginsDirPath)
	if err != nil {
		return nil, err
	}

	// 遍历plugins目录下的所有子文件夹
	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}

		// 构建plugin_export.json文件路径
		pluginExportPath := filepath.Join(pluginsDirPath, entry.Name(), "plugin_export.json")

		// 检查文件是否存在
		if _, err := os.Stat(pluginExportPath); errors.Is(err, os.ErrNotExist) {
			continue
		}

		// 读取plugin_export.json文件内容
		fileContent, err := os.ReadFile(pluginExportPath)
		if err != nil {
			continue
		}

		// 解析JSON到结构体
		var pluginExport models.PluginExport
		if err := json.Unmarshal(fileContent, &pluginExport); err != nil {
			continue
		}

		// 添加插件文件夹名称
		pluginExport.FolderName = entry.Name()
		pluginsExports = append(pluginsExports, pluginExport)
	}

	return pluginsExports, nil
}

// ExportPluginToWriter 导出插件为压缩包，直接写入 io.Writer（流式传输）
func (pms *PluginsManagerService) ExportPluginToWriter(pluginName string, writer io.Writer) (string, error) {
	if pluginName == "" {
		return "", errors.New("插件名称不能为空")
	}

	// 获取plugin_export.json文件路径
	pluginExportPath := filepath.Join("./plugins", pluginName, "plugin_export.json")

	// 检查文件是否存在
	if _, err := os.Stat(pluginExportPath); errors.Is(err, os.ErrNotExist) {
		return "", errors.New("插件不存在或plugin_export.json文件不存在")
	}

	// 读取plugin_export.json文件内容
	fileContent, err := os.ReadFile(pluginExportPath)
	if err != nil {
		return "", err
	}

	// 解析JSON到结构体
	var pluginExport models.PluginExport
	if err = json.Unmarshal(fileContent, &pluginExport); err != nil {
		return "", err
	}

	// 验证导出路径中的文件或文件夹是否存在
	var filesToAdd []string // 存储要添加到zip的文件及其相对路径
	var dirsToAdd []string  // 存储要添加到zip的目录

	for _, exportPath := range pluginExport.ExportDirs {
		// 规范化路径，移除前导斜杠
		exportPath = strings.TrimPrefix(exportPath, "/")
		exportPath = strings.TrimPrefix(exportPath, "\\")

		// 检查文件或文件夹是否存在
		fullPath := exportPath
		if _, err = os.Stat(fullPath); errors.Is(err, os.ErrNotExist) {
			return "", errors.New("导出路径不存在: " + exportPath)
		}

		// 判断是文件还是目录
		fileInfo, err := os.Stat(fullPath)
		if err != nil {
			return "", err
		}

		if fileInfo.IsDir() {
			dirsToAdd = append(dirsToAdd, fullPath)
		} else {
			filesToAdd = append(filesToAdd, fullPath)
		}
	}

	// 处理前端导出路径
	var frontendFilesToAdd []string // 存储前端文件
	var frontendDirsToAdd []string  // 存储前端目录

	if len(pluginExport.ExportDirsFrontend) > 0 {
		// 获取前端项目根目录
		frontendRootDir := app.ConfigYml.GetString("gen.dir")
		if frontendRootDir == "" {
			return "", errors.New("前端项目根目录未配置")
		}

		// 检查前端项目根目录是否存在
		if _, err := os.Stat(frontendRootDir); errors.Is(err, os.ErrNotExist) {
			return "", errors.New("前端项目根目录不存在: " + frontendRootDir)
		}

		// 验证并分类前端导出路径
		for _, exportPath := range pluginExport.ExportDirsFrontend {
			// 规范化路径，移除前导斜杠
			exportPath = strings.TrimPrefix(exportPath, "/")
			exportPath = strings.TrimPrefix(exportPath, "\\")

			// 构建完整路径
			fullPath := filepath.Join(frontendRootDir, exportPath)

			// 检查文件或文件夹是否存在
			if _, err := os.Stat(fullPath); errors.Is(err, os.ErrNotExist) {
				return "", errors.New("前端导出路径不存在: " + exportPath)
			}

			// 判断是文件还是目录
			fileInfo, err := os.Stat(fullPath)
			if err != nil {
				return "", err
			}

			if fileInfo.IsDir() {
				frontendDirsToAdd = append(frontendDirsToAdd, fullPath)
			} else {
				frontendFilesToAdd = append(frontendFilesToAdd, fullPath)
			}
		}
	}

	// 创建zip写入器，直接写入到 io.Writer
	zipWriter := zip.NewWriter(writer)
	defer zipWriter.Close()

	// 添加单个文件到zip的ginfastback目录
	for _, filePath := range filesToAdd {
		// 统一使用正斜杠作为zip内的路径分隔符
		arcPath := filepath.Join("ginfastback", filePath)
		arcPath = strings.ReplaceAll(arcPath, "\\", "/")
		if err := pms.addFileToZip(zipWriter, filePath, arcPath); err != nil {
			return "", err
		}
	}

	// 添加目录到zip的ginfastback目录
	for _, dirPath := range dirsToAdd {
		// 统一使用正斜杠作为zip内的路径分隔符
		arcPath := filepath.Join("ginfastback", dirPath)
		arcPath = strings.ReplaceAll(arcPath, "\\", "/")
		if err := pms.addDirToZip(zipWriter, dirPath, arcPath); err != nil {
			return "", err
		}
	}

	// 添加前端文件到zip的ginfastfront目录
	for _, filePath := range frontendFilesToAdd {
		// 获取文件相对于前端根目录的相对路径
		relPath, err := filepath.Rel(app.ConfigYml.GetString("gen.dir"), filePath)
		if err != nil {
			return "", err
		}
		// 统一使用正斜杠作为zip内的路径分隔符
		arcPath := filepath.Join("ginfastfront", relPath)
		arcPath = strings.ReplaceAll(arcPath, "\\", "/")
		if err := pms.addFileToZip(zipWriter, filePath, arcPath); err != nil {
			return "", err
		}
	}

	// 添加前端目录到zip的ginfastfront目录
	for _, dirPath := range frontendDirsToAdd {
		// 获取目录相对于前端根目录的相对路径
		relPath, err := filepath.Rel(app.ConfigYml.GetString("gen.dir"), dirPath)
		if err != nil {
			return "", err
		}
		// 统一使用正斜杠作为zip内的路径分隔符
		arcPath := filepath.Join("ginfastfront", relPath)
		arcPath = strings.ReplaceAll(arcPath, "\\", "/")
		if err := pms.addDirToZip(zipWriter, dirPath, arcPath); err != nil {
			return "", err
		}
	}

	// 将plugin_export.json复制为plugin.json到压缩包顶层
	if err := pms.addStringToZip(zipWriter, "plugin.json", string(fileContent)); err != nil {
		return "", err
	}

	// 处理菜单数据导出
	if len(pluginExport.Menus) > 0 {
		menuContent, err := pms.generateMenuJSON(pluginExport.Menus)
		if err != nil {
			return "", fmt.Errorf("生成菜单JSON文件失败: %v", err)
		}

		// 将菜单数据添加到zip
		if err := pms.addStringToZip(zipWriter, "menus.json", menuContent); err != nil {
			return "", err
		}
	}

	// 处理数据库表导出
	if len(pluginExport.DatabaseTable) > 0 {
		sqlContent, err := pms.generateTableSQL(pluginExport.DatabaseTable)
		if err != nil {
			return "", fmt.Errorf("生成数据库SQL文件失败: %v", err)
		}

		// 将SQL内容添加到zip
		if err := pms.addStringToZip(zipWriter, "database.sql", sqlContent); err != nil {
			return "", err
		}
	}

	// 完成zip写入
	err = zipWriter.Close()
	if err != nil {
		return "", err
	}

	// 返回插件版本信息
	return pluginExport.Version, nil
}

// addFileToZip 将单个文件添加到zip压缩包中
func (pms *PluginsManagerService) addFileToZip(zipWriter *zip.Writer, filePath, arcPath string) error {
	file, err := os.Open(filePath)
	if err != nil {
		return err
	}
	defer file.Close()

	// 在zip中创建文件条目
	zipEntry, err := zipWriter.Create(arcPath)
	if err != nil {
		return err
	}

	// 复制文件内容到zip条目
	_, err = io.Copy(zipEntry, file)
	return err
}

// addDirToZip 递归地将目录及其内容添加到zip压缩包中
func (pms *PluginsManagerService) addDirToZip(zipWriter *zip.Writer, dirPath, arcPath string) error {
	entries, err := os.ReadDir(dirPath)
	if err != nil {
		return err
	}

	for _, entry := range entries {
		fullPath := filepath.Join(dirPath, entry.Name())
		arcFullPath := filepath.Join(arcPath, entry.Name())
		// 统一使用正斜杠作为zip内的路径分隔符
		arcFullPath = strings.ReplaceAll(arcFullPath, "\\", "/")

		if entry.IsDir() {
			// 递归处理子目录
			if err := pms.addDirToZip(zipWriter, fullPath, arcFullPath); err != nil {
				return err
			}
		} else {
			// 添加文件
			if err := pms.addFileToZip(zipWriter, fullPath, arcFullPath); err != nil {
				return err
			}
		}
	}
	return nil
}

// addStringToZip 将字符串内容添加到zip压缩包中
func (pms *PluginsManagerService) addStringToZip(zipWriter *zip.Writer, fileName string, content string) error {
	zipEntry, err := zipWriter.Create(fileName)
	if err != nil {
		return err
	}

	_, err = io.WriteString(zipEntry, content)
	return err
}

// generateTableSQL 根据表名列表生成CREATE TABLE和INSERT SQL语句
func (pms *PluginsManagerService) generateTableSQL(tableNames []string) (string, error) {
	// 获取数据库连接
	dbType := app.ConfigYml.GetString("gormv2.usedbtype")
	var db *gorm.DB
	var err error

	switch dbType {
	case "mysql":
		db, err = gormhelper.GetOneMysqlClient()
	case "postgresql":
		db, err = gormhelper.GetOnePostgreSqlClient()
	case "sqlserver":
		db, err = gormhelper.GetOneSqlserverClient()
	default:
		db, err = gormhelper.GetOneMysqlClient()
	}

	if err != nil {
		return "", err
	}

	sqlDB, err := db.DB()
	if err != nil {
		return "", err
	}

	var sqlContent strings.Builder
	sqlContent.WriteString("-- Database table structure and data\n")
	sqlContent.WriteString("-- This file is auto-generated\n\n")

	// 根据数据库类型生成SQL
	for _, tableName := range tableNames {
		switch dbType {
		case "mysql":
			if err := pms.generateMySQLTableSQL(sqlDB, tableName, &sqlContent); err != nil {
				return "", err
			}
		case "postgresql":
			if err := pms.generatePostgreSQLTableSQL(sqlDB, tableName, &sqlContent); err != nil {
				return "", err
			}
		case "sqlserver":
			if err := pms.generateSQLServerTableSQL(sqlDB, tableName, &sqlContent); err != nil {
				return "", err
			}
		}
	}

	return sqlContent.String(), nil
}

// generateMySQLTableSQL 生成MySQL的建表和数据插入SQL
func (pms *PluginsManagerService) generateMySQLTableSQL(sqlDB *sql.DB, tableName string, sqlContent *strings.Builder) error {
	// 获取建表语句
	var createTableSQL string
	err := sqlDB.QueryRow(fmt.Sprintf("SHOW CREATE TABLE `%s`", tableName)).Scan(&tableName, &createTableSQL)
	if err != nil {
		return err
	}

	sqlContent.WriteString(fmt.Sprintf("-- Table structure for `%s`\n", tableName))
	sqlContent.WriteString(fmt.Sprintf("DROP TABLE IF EXISTS `%s`;\n", tableName))
	sqlContent.WriteString(createTableSQL)
	sqlContent.WriteString(";\n\n")

	// 获取表中的数据
	rows, err := sqlDB.Query(fmt.Sprintf("SELECT * FROM `%s`", tableName))
	if err != nil {
		return err
	}
	defer rows.Close()

	// 获取列信息
	columns, err := rows.Columns()
	if err != nil {
		return err
	}

	// 逐行扫描数据
	for rows.Next() {
		values := make([]interface{}, len(columns))
		valuePtrs := make([]interface{}, len(columns))
		for i := range columns {
			valuePtrs[i] = &values[i]
		}

		err := rows.Scan(valuePtrs...)
		if err != nil {
			return err
		}

		// 构建INSERT语句
		var insertSQL strings.Builder
		insertSQL.WriteString(fmt.Sprintf("INSERT INTO `%s` (", tableName))

		for i, col := range columns {
			if i > 0 {
				insertSQL.WriteString(", ")
			}
			insertSQL.WriteString(fmt.Sprintf("`%s`", col))
		}

		insertSQL.WriteString(") VALUES (")

		for i, v := range values {
			if i > 0 {
				insertSQL.WriteString(", ")
			}
			insertSQL.WriteString(pms.formatSQLValue(v))
		}

		insertSQL.WriteString(");\n")
		sqlContent.WriteString(insertSQL.String())
	}

	sqlContent.WriteString("\n")
	return nil
}

// generatePostgreSQLTableSQL 生成PostgreSQL的建表和数据插入SQL
func (pms *PluginsManagerService) generatePostgreSQLTableSQL(sqlDB *sql.DB, tableName string, sqlContent *strings.Builder) error {
	// 获取建表语句
	rows, err := sqlDB.Query(`
		SELECT 
			'CREATE TABLE ' || t.tablename || ' (' || 
			string_agg(a.attname || ' ' || format_type(a.atttypid, a.atttypmod), ', ') || 
			');' as create_table
		FROM pg_tables t
		JOIN pg_class c ON c.relname = t.tablename
		JOIN pg_attribute a ON a.attrelid = c.oid
		WHERE t.schemaname = 'public' AND t.tablename = $1
		GROUP BY t.tablename
	`, tableName)
	if err != nil {
		return err
	}
	defer rows.Close()

	for rows.Next() {
		var createTableSQL string
		if err := rows.Scan(&createTableSQL); err != nil {
			return err
		}
		sqlContent.WriteString(fmt.Sprintf("-- Table structure for %s\n", tableName))
		sqlContent.WriteString(fmt.Sprintf("DROP TABLE IF EXISTS %s;\n", tableName))
		sqlContent.WriteString(createTableSQL)
		sqlContent.WriteString(";\n\n")
	}

	// 获取表中的数据
	dataRows, err := sqlDB.Query(fmt.Sprintf("SELECT * FROM %s", tableName))
	if err != nil {
		return err
	}
	defer dataRows.Close()

	columns, err := dataRows.Columns()
	if err != nil {
		return err
	}

	for dataRows.Next() {
		values := make([]interface{}, len(columns))
		valuePtrs := make([]interface{}, len(columns))
		for i := range columns {
			valuePtrs[i] = &values[i]
		}

		err := dataRows.Scan(valuePtrs...)
		if err != nil {
			return err
		}

		var insertSQL strings.Builder
		insertSQL.WriteString(fmt.Sprintf("INSERT INTO %s (", tableName))

		for i, col := range columns {
			if i > 0 {
				insertSQL.WriteString(", ")
			}
			insertSQL.WriteString(col)
		}

		insertSQL.WriteString(") VALUES (")

		for i, v := range values {
			if i > 0 {
				insertSQL.WriteString(", ")
			}
			insertSQL.WriteString(pms.formatSQLValue(v))
		}

		insertSQL.WriteString(");\n")
		sqlContent.WriteString(insertSQL.String())
	}

	sqlContent.WriteString("\n")
	return nil
}

// generateSQLServerTableSQL 生成SQL Server的建表和数据插入SQL
func (pms *PluginsManagerService) generateSQLServerTableSQL(sqlDB *sql.DB, tableName string, sqlContent *strings.Builder) error {
	// 获取建表语句
	var createTableSQL string
	err := sqlDB.QueryRow(`
		SELECT 
			'CREATE TABLE [' + TABLE_NAME + '] (' + 
			STUFF((SELECT ', ' + '[' + COLUMN_NAME + '] ' + DATA_TYPE
			      FROM INFORMATION_SCHEMA.COLUMNS AS c2
			      WHERE c2.TABLE_NAME = c.TABLE_NAME
			      FOR XML PATH('')), 1, 2, '') + 
			');' as create_table
		FROM INFORMATION_SCHEMA.COLUMNS AS c
		WHERE TABLE_NAME = @tableName
		GROUP BY TABLE_NAME
	`, sql.Named("tableName", tableName)).Scan(&createTableSQL)
	if err != nil && err != sql.ErrNoRows {
		return err
	}

	if createTableSQL != "" {
		sqlContent.WriteString(fmt.Sprintf("-- Table structure for [%s]\n", tableName))
		sqlContent.WriteString(fmt.Sprintf("DROP TABLE IF EXISTS [%s];\n", tableName))
		sqlContent.WriteString(createTableSQL)
		sqlContent.WriteString(";\n\n")
	}

	// 获取表中的数据
	rows, err := sqlDB.Query(fmt.Sprintf("SELECT * FROM [%s]", tableName))
	if err != nil {
		return err
	}
	defer rows.Close()

	columns, err := rows.Columns()
	if err != nil {
		return err
	}

	for rows.Next() {
		values := make([]interface{}, len(columns))
		valuePtrs := make([]interface{}, len(columns))
		for i := range columns {
			valuePtrs[i] = &values[i]
		}

		err := rows.Scan(valuePtrs...)
		if err != nil {
			return err
		}

		var insertSQL strings.Builder
		insertSQL.WriteString(fmt.Sprintf("INSERT INTO [%s] (", tableName))

		for i, col := range columns {
			if i > 0 {
				insertSQL.WriteString(", ")
			}
			insertSQL.WriteString(fmt.Sprintf("[%s]", col))
		}

		insertSQL.WriteString(") VALUES (")

		for i, v := range values {
			if i > 0 {
				insertSQL.WriteString(", ")
			}
			insertSQL.WriteString(pms.formatSQLValue(v))
		}

		insertSQL.WriteString(");\n")
		sqlContent.WriteString(insertSQL.String())
	}

	sqlContent.WriteString("\n")
	return nil
}

// formatSQLValue 将数据库值格式化为SQL字面量
func (pms *PluginsManagerService) formatSQLValue(value interface{}) string {
	if value == nil {
		return "NULL"
	}

	switch v := value.(type) {
	case string:
		// 对字符串进行转义
		escaped := strings.ReplaceAll(v, "'", "''")
		return fmt.Sprintf("'%s'", escaped)
	case []byte:
		// 对字节数组进行转义
		escaped := strings.ReplaceAll(string(v), "'", "''")
		return fmt.Sprintf("'%s'", escaped)
	case bool:
		if v {
			return "1"
		}
		return "0"
	case time.Time:
		// 对时间类型进行格式化，转为标准SQL时间格式
		timeStr := v.Format("2006-01-02 15:04:05")
		return fmt.Sprintf("'%s'", timeStr)
	default:
		return fmt.Sprintf("%v", v)
	}
}

// generateMenuJSON 根据PluginMenu列表生成菜单JSON数据
// 从sys_menu表查询菜单数据并生成树形结构JSON
func (pms *PluginsManagerService) generateMenuJSON(pluginMenus []models.PluginMenu) (string, error) {
	if len(pluginMenus) == 0 {
		return "", nil
	}

	// 获取菜单数据库连接
	db := app.DB()
	if db == nil {
		return "", errors.New("数据库连接失败")
	}

	// 根据Path和Type查询菜单数据
	var menuIds []uint
	for _, pluginMenu := range pluginMenus {
		var menu models.SysMenu
		err := db.Where("path = ? AND type = ?", pluginMenu.Path, pluginMenu.Type).Select("id").First(&menu).Error
		if err != nil && err != gorm.ErrRecordNotFound {
			return "", fmt.Errorf("查询菜单数据失败: %v", err)
		}
		if menu.ID > 0 {
			menuIds = append(menuIds, menu.ID)
		}
	}

	if len(menuIds) == 0 {
		return "", nil
	}
	ctx := context.Background()
	// 获取所有菜单数据，包括子菜单
	menuList := models.NewSysMenuList()
	err := menuList.Find(ctx, func(d *gorm.DB) *gorm.DB {
		return d.Preload("Apis")
	})
	if err != nil {
		return "", fmt.Errorf("查询菜单失败: %v", err)
	}

	if menuList.IsEmpty() {
		return "", nil
	}

	// 获取指定菜单及其所有子菜单和父菜单
	menuList = menuList.GetMenusWithChildern(menuIds...)
	if menuList.IsEmpty() {
		return "", nil
	}

	// 构建树结构
	menuTree := menuList.FixOrphanParentIDs().BuildTree()

	// 生成JSON
	jsonStr, err := menuTree.Json()
	if err != nil {
		return "", fmt.Errorf("菜单数据序列化失败: %v", err)
	}

	return jsonStr, nil
}

// ImportPluginFromReader 从io.Reader导入插件（不需要保存文件）
func (pms *PluginsManagerService) ImportPluginFromReader(c *gin.Context, reader io.Reader, params models.PluginImportRequest) (*models.PluginImportResponse, error) {
	// 从Reader中读取zip内容到内存
	data, err := io.ReadAll(reader)
	if err != nil {
		return nil, fmt.Errorf("读取上传文件失败: %v", err)
	}

	// 使用bytes.Reader来模拞fzip.Reader
	zipReader, err := zip.NewReader(strings.NewReader(string(data)), int64(len(data)))
	if err != nil {
		return nil, fmt.Errorf("打开压缩包失败: %v", err)
	}

	return pms.processPluginImport(c, zipReader, params)
}

// processPluginImport 处理插件导入的公共逻辑
func (pms *PluginsManagerService) processPluginImport(c *gin.Context, zipReader *zip.Reader, params models.PluginImportRequest) (*models.PluginImportResponse, error) {
	var pluginConfig models.PluginExport
	pluginJSONFound := false
	for _, file := range zipReader.File {
		if file.Name == "plugin.json" {
			pluginJSONFound = true
			rc, err := file.Open()
			if err != nil {
				return nil, fmt.Errorf("读取plugin.json失败: %v", err)
			}
			defer rc.Close()

			data, err := io.ReadAll(rc)
			if err != nil {
				return nil, fmt.Errorf("读取plugin.json内容失败: %v", err)
			}

			if err := json.Unmarshal(data, &pluginConfig); err != nil {
				return nil, fmt.Errorf("解析plugin.json失败: %v", err)
			}
			break
		}
	}

	if !pluginJSONFound {
		return nil, errors.New("压缩包中不存在plugin.json文件")
	}

	// 检查文件、数据库及插件依赖
	if params.CheckExist {

		// 验证版本兼容性
		if err := pms.checkVersionCompatibility(&pluginConfig); err != nil {
			return nil, err
		}

		// 检查文件是否存在
		existingPaths, err := pms.checkFilesExist(&pluginConfig)
		if err != nil {
			return nil, err
		}

		// 检查数据库表是否存在
		existingTables, err := pms.checkTablesExist(pluginConfig.DatabaseTable)
		if err != nil {
			return nil, err
		}

		// 返回给controllers层，由controllers处理响应
		if len(existingPaths) > 0 || len(existingTables) > 0 {
			return &models.PluginImportResponse{
				ExistingPaths:  existingPaths,
				ExistingTables: existingTables,
				IsWarning:      true,
			}, nil
		}
	}

	// 导入数据库
	if params.OverwriteDB {
		if err := pms.importDatabase(zipReader); err != nil {
			return nil, fmt.Errorf("导入数据库失败: %v", err)
		}
	}

	// 导入菜单
	if params.ImportMenu {
		if err := pms.importMenus(c, zipReader, params.UserID); err != nil {
			return nil, fmt.Errorf("导入菜单失败: %v", err)
		}
	}

	// 解压并覆盖文件
	if params.OverwriteFiles {
		if err := pms.extractAndOverwriteFiles(zipReader); err != nil {
			return nil, fmt.Errorf("覆盖文件失败: %v", err)
		}
	}

	return nil, nil
}

// checkVersionCompatibility 检查版本兼容性
func (pms *PluginsManagerService) checkVersionCompatibility(pluginConfig *models.PluginExport) error {
	// 1. 获取当前系统中已安装的所有插件
	installedPlugins, err := pms.GetPluginsExportList()
	if err != nil {
		return fmt.Errorf("获取已安装插件列表失败: %v", err)
	}

	// 构建已安装插件的映射表，便于快速查询
	installedPluginMap := make(map[string]*models.PluginExport)
	for i, plugin := range installedPlugins {
		installedPluginMap[plugin.Name] = &installedPlugins[i]
	}

	// 2. 读取后端version.json
	backendVersionData, err := os.ReadFile("./version.json")
	if err != nil {
		return fmt.Errorf("读取后端version.json失败: %v", err)
	}

	var backendVersion models.PluginExport
	if err := json.Unmarshal(backendVersionData, &backendVersion); err != nil {
		return fmt.Errorf("解析后端version.json失败: %v", err)
	}

	// 将后端和前端信息添加到已安装插件映射表中
	installedPluginMap[backendVersion.Name] = &backendVersion

	// 3. 读取前端version.json
	frontendRootDir := app.ConfigYml.GetString("gen.dir")
	var frontendVersion models.PluginExport
	if frontendRootDir != "" {
		// 检查前端目录是否存在
		if _, err := os.Stat(frontendRootDir); errors.Is(err, os.ErrNotExist) {
			return fmt.Errorf("前端项目根目录不存在: %s", frontendRootDir)
		}

		frontendVersionPath := filepath.Join(frontendRootDir, "version.json")

		// 检查version.json文件是否存在
		if _, err := os.Stat(frontendVersionPath); errors.Is(err, os.ErrNotExist) {
			return fmt.Errorf("前端version.json文件不存在: %s", frontendVersionPath)
		}

		frontendVersionData, err := os.ReadFile(frontendVersionPath)
		if err != nil {
			return fmt.Errorf("读取前端version.json失败: %v", err)
		}

		if err := json.Unmarshal(frontendVersionData, &frontendVersion); err != nil {
			return fmt.Errorf("解析前端version.json失败: %v", err)
		}

		installedPluginMap[frontendVersion.Name] = &frontendVersion
	} else {
		return fmt.Errorf("前端项目根目录未配置")
	}

	// 4. 检查插件的所有依赖
	if len(pluginConfig.Dependencies) > 0 {
		for depName, requiredVersion := range pluginConfig.Dependencies {
			// 检查依赖插件是否存在
			installedPlugin, exists := installedPluginMap[depName]
			if !exists {
				return fmt.Errorf("依赖插件不存在: %s (版本需求: %s)", depName, requiredVersion)
			}

			// 检查依赖插件的版本是否兼容
			if !pms.isVersionCompatible(installedPlugin.Version, requiredVersion) {
				return fmt.Errorf("依赖插件版本不兼容: %s 需要版本 %s, 当前版本 %s", depName, requiredVersion, installedPlugin.Version)
			}
		}
	}

	return nil
}

// isVersionCompatible 检查版本是否兼容（简单的版本号比较）
func (pms *PluginsManagerService) isVersionCompatible(currentVersion, requiredVersion string) bool {
	// 移除版本号前缀符号（^, ~, >=, >, =）
	requiredVersion = strings.TrimPrefix(requiredVersion, "^")
	requiredVersion = strings.TrimPrefix(requiredVersion, "~")
	requiredVersion = strings.TrimPrefix(requiredVersion, ">=")
	requiredVersion = strings.TrimPrefix(requiredVersion, ">")
	requiredVersion = strings.TrimPrefix(requiredVersion, "=")
	requiredVersion = strings.TrimSpace(requiredVersion)

	// 简单的版本比较，实际项目中应该使用更完善的版本比较库
	return strings.HasPrefix(currentVersion, requiredVersion) || currentVersion >= requiredVersion
}

// checkFilesExist 检查文件是否已存在，返回所有存在的文件或目录
func (pms *PluginsManagerService) checkFilesExist(pluginConfig *models.PluginExport) ([]string, error) {
	var existingPaths []string

	// 检查后端文件
	for _, exportPath := range pluginConfig.ExportDirs {
		exportPath = strings.TrimPrefix(exportPath, "/")
		exportPath = strings.TrimPrefix(exportPath, "\\")

		if _, err := os.Stat(exportPath); err == nil {
			existingPaths = append(existingPaths, exportPath)
		}
	}

	// 检查前端文件
	frontendRootDir := app.ConfigYml.GetString("gen.dir")
	if frontendRootDir != "" && len(pluginConfig.ExportDirsFrontend) > 0 {
		for _, exportPath := range pluginConfig.ExportDirsFrontend {
			exportPath = strings.TrimPrefix(exportPath, "/")
			exportPath = strings.TrimPrefix(exportPath, "\\")

			fullPath := filepath.Join(frontendRootDir, exportPath)
			if _, err := os.Stat(fullPath); err == nil {
				existingPaths = append(existingPaths, exportPath)
			}
		}
	}

	return existingPaths, nil
}

// checkTablesExist 检查数据库表是否存在，返回所有存在的表
func (pms *PluginsManagerService) checkTablesExist(tableNames []string) ([]string, error) {
	if len(tableNames) == 0 {
		return nil, nil
	}

	var existingTables []string
	dbType := app.ConfigYml.GetString("gormv2.usedbtype")
	var db *gorm.DB
	var err error

	switch dbType {
	case "mysql":
		db, err = gormhelper.GetOneMysqlClient()
	case "postgresql":
		db, err = gormhelper.GetOnePostgreSqlClient()
	case "sqlserver":
		db, err = gormhelper.GetOneSqlserverClient()
	default:
		db, err = gormhelper.GetOneMysqlClient()
	}

	if err != nil {
		return nil, fmt.Errorf("获取数据库连接失败: %v", err)
	}

	sqlDB, err := db.DB()
	if err != nil {
		return nil, fmt.Errorf("获取数据库连接失败: %v", err)
	}

	// 检查每个表是否存在
	for _, tableName := range tableNames {
		var exists bool

		switch dbType {
		case "mysql":
			err := sqlDB.QueryRow(
				"SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?",
				tableName,
			).Scan(&exists)
			if err != nil && err != sql.ErrNoRows {
				return nil, fmt.Errorf("检查数据库表失败: %v", err)
			}

		case "postgresql":
			err := sqlDB.QueryRow(
				"SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name = $1)",
				tableName,
			).Scan(&exists)
			if err != nil {
				return nil, fmt.Errorf("检查数据库表失败: %v", err)
			}

		case "sqlserver":
			err := sqlDB.QueryRow(
				"SELECT CASE WHEN EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TableName) THEN 1 ELSE 0 END",
				sql.Named("TableName", tableName),
			).Scan(&exists)
			if err != nil {
				return nil, fmt.Errorf("检查数据库表失败: %v", err)
			}
		}

		if exists {
			existingTables = append(existingTables, tableName)
		}
	}

	return existingTables, nil
}

// extractAndOverwriteFiles 解压并覆盖文件
func (pms *PluginsManagerService) extractAndOverwriteFiles(zipReader *zip.Reader) error {
	// 当前项目根目录
	backendRoot := "./"
	frontendRoot := app.ConfigYml.GetString("gen.dir")

	for _, file := range zipReader.File {
		// 跳过顶层的配置文件
		if file.Name == "plugin.json" || file.Name == "menus.json" || file.Name == "database.sql" {
			continue
		}

		// 处理后端文件
		if strings.HasPrefix(file.Name, "ginfastback/") {
			relPath := strings.TrimPrefix(file.Name, "ginfastback/")
			destPath := filepath.Join(backendRoot, relPath)
			if err := pms.extractFile(file, destPath); err != nil {
				return err
			}
		}

		// 处理前端文件
		if frontendRoot != "" && strings.HasPrefix(file.Name, "ginfastfront/") {
			relPath := strings.TrimPrefix(file.Name, "ginfastfront/")
			destPath := filepath.Join(frontendRoot, relPath)

			if err := pms.extractFile(file, destPath); err != nil {
				return err
			}
		}
	}

	return nil
}

// extractFile 解压单个文件
func (pms *PluginsManagerService) extractFile(file *zip.File, destPath string) error {
	// 如果是目录，创建目录
	if file.FileInfo().IsDir() {
		return os.MkdirAll(destPath, os.ModePerm)
	}

	// 确保目标目录存在
	if err := os.MkdirAll(filepath.Dir(destPath), os.ModePerm); err != nil {
		return err
	}

	// 打开zip中的文件
	rc, err := file.Open()
	if err != nil {
		return err
	}
	defer rc.Close()

	// 创建目标文件
	destFile, err := os.Create(destPath)
	if err != nil {
		return err
	}
	defer destFile.Close()

	// 复制内容
	_, err = io.Copy(destFile, rc)
	return err
}

// importDatabase 导入数据库
func (pms *PluginsManagerService) importDatabase(zipReader *zip.Reader) error {
	// 查找database.sql文件
	var sqlContent string
	for _, file := range zipReader.File {
		if file.Name == "database.sql" {
			rc, err := file.Open()
			if err != nil {
				return fmt.Errorf("读取database.sql失败: %v", err)
			}
			defer rc.Close()

			data, err := io.ReadAll(rc)
			if err != nil {
				return fmt.Errorf("读取database.sql内容失败: %v", err)
			}
			sqlContent = string(data)
			break
		}
	}

	if sqlContent == "" {
		return nil // 没有database.sql文件，跳过
	}

	// 执行SQL
	dbType := app.ConfigYml.GetString("gormv2.usedbtype")
	var db *gorm.DB
	var err error

	switch dbType {
	case "mysql":
		db, err = gormhelper.GetOneMysqlClient()
	case "postgresql":
		db, err = gormhelper.GetOnePostgreSqlClient()
	case "sqlserver":
		db, err = gormhelper.GetOneSqlserverClient()
	default:
		db, err = gormhelper.GetOneMysqlClient()
	}

	if err != nil {
		return err
	}

	// 执行SQL语句
	// 使用更智能的SQL语句分割，避免字符串内容中的分号造成的问题
	statements := splitSQLStatements(sqlContent)
	for _, stmt := range statements {
		if stmt == "" {
			continue
		}
		if err := db.Exec(stmt).Error; err != nil {
			return fmt.Errorf("执行SQL失败: %v", err)
		}
	}

	return nil
}

// importMenus 导入菜单
func (pms *PluginsManagerService) importMenus(c *gin.Context, zipReader *zip.Reader, userID uint) error {
	// 查找menus.json文件
	var menuContent string
	for _, file := range zipReader.File {
		if file.Name == "menus.json" {
			rc, err := file.Open()
			if err != nil {
				return fmt.Errorf("读取menus.json失败: %v", err)
			}
			defer rc.Close()

			data, err := io.ReadAll(rc)
			if err != nil {
				return fmt.Errorf("读取menus.json内容失败: %v", err)
			}
			menuContent = string(data)
			break
		}
	}

	if menuContent == "" {
		return nil // 没有menus.json文件，跳过
	}

	// 解析菜单数据
	var menuList models.SysMenuList
	if err := json.Unmarshal([]byte(menuContent), &menuList); err != nil {
		return fmt.Errorf("解析menus.json失败: %v", err)
	}

	// 调用菜单服务导入
	menuService := NewSysMenuService()
	if err := menuService.Import(c, menuList, userID); err != nil {
		return err
	}

	return nil
}

// splitSQLStatements 智能分割SQL语句，处理字符串和注释中的分号
// 避免字符串内容中的分号造成的SQL语句分割错误
func splitSQLStatements(sqlContent string) []string {
	var statements []string         // 存储拆分后的SQL语句
	var currentStmt strings.Builder // 当前正在构建的语句
	inSingleQuote := false          // 是否在单引号内
	inDoubleQuote := false          // 是否在双引号内
	inBacktick := false             // 是否在反引号内
	i := 0

	for i < len(sqlContent) {
		ch := sqlContent[i]

		// 处理字符转义
		if i > 0 && sqlContent[i-1] == '\\' {
			currentStmt.WriteByte(ch)
			i++
			continue
		}

		// 处理单引号
		if ch == '\'' && !inDoubleQuote && !inBacktick {
			inSingleQuote = !inSingleQuote
			currentStmt.WriteByte(ch)
			i++
			continue
		}

		// 处理双引号
		if ch == '"' && !inSingleQuote && !inBacktick {
			inDoubleQuote = !inDoubleQuote
			currentStmt.WriteByte(ch)
			i++
			continue
		}

		// 处理反引号（MySQL的标识符引号）
		if ch == '`' && !inSingleQuote && !inDoubleQuote {
			inBacktick = !inBacktick
			currentStmt.WriteByte(ch)
			i++
			continue
		}

		// 当不在任何字符串内时，分号是语句分隔符
		if ch == ';' && !inSingleQuote && !inDoubleQuote && !inBacktick {
			stmt := strings.TrimSpace(currentStmt.String())
			if stmt != "" {
				statements = append(statements, stmt)
			}
			currentStmt.Reset()
			i++
			continue
		}

		currentStmt.WriteByte(ch)
		i++
	}

	// 处理最后一条语句（如果没有以分号结尾）
	stmt := strings.TrimSpace(currentStmt.String())
	if stmt != "" {
		statements = append(statements, stmt)
	}

	return statements
}

// UninstallPlugin 卸载插件
func (pms *PluginsManagerService) UninstallPlugin(c *gin.Context, folderName string) error {
	if folderName == "" {
		return errors.New("插件名称不能为空")
	}

	// 获取plugin_export.json文件路径
	pluginExportPath := filepath.Join("./plugins", folderName, "plugin_export.json")

	// 检查文件是否存在
	if _, err := os.Stat(pluginExportPath); errors.Is(err, os.ErrNotExist) {
		return errors.New("插件不存在或plugin_export.json文件不存在")
	}

	// 读取plugin_export.json文件内容
	fileContent, err := os.ReadFile(pluginExportPath)
	if err != nil {
		return fmt.Errorf("读取plugin_export.json失败: %v", err)
	}

	// 解析JSON到结构体
	var pluginExport models.PluginExport
	if err = json.Unmarshal(fileContent, &pluginExport); err != nil {
		return fmt.Errorf("解析plugin_export.json失败: %v", err)
	}

	// 1. 卸载菜单和API
	if len(pluginExport.Menus) > 0 {
		if err := pms.uninstallMenus(c, pluginExport.Menus); err != nil {
			return err
		}
	}

	// 3. 删除前端文件和文件夹
	if len(pluginExport.ExportDirsFrontend) > 0 {
		if err := pms.deleteFrontendFiles(pluginExport.ExportDirsFrontend); err != nil {
			return err
		}
	}

	// 2. 删除文件和文件夹
	if len(pluginExport.ExportDirs) > 0 {
		if err := pms.deleteFiles(pluginExport.ExportDirs); err != nil {
			return err
		}
	}

	// 4. 删除数据库表
	if len(pluginExport.DatabaseTable) > 0 {
		if err := pms.dropDatabaseTables(pluginExport.DatabaseTable); err != nil {
			return err
		}
	}

	return nil
}

// uninstallMenus 卸载菜单和关联的API
func (pms *PluginsManagerService) uninstallMenus(c *gin.Context, pluginMenus []models.PluginMenu) error {
	if len(pluginMenus) == 0 {
		return nil
	}

	db := app.DB()
	if db == nil {
		return errors.New("数据库连接失败")
	}

	// 根据Path和Type查询菜单ID
	var menuIds []uint
	for _, pluginMenu := range pluginMenus {
		var menu models.SysMenu
		err := db.Where("path = ? AND type = ?", pluginMenu.Path, pluginMenu.Type).Select("id").First(&menu).Error
		if err != nil && err != gorm.ErrRecordNotFound {
			return fmt.Errorf("查询菜单数据失败: %v", err)
		}
		if menu.ID > 0 {
			menuIds = append(menuIds, menu.ID)
		}
	}

	if len(menuIds) == 0 {
		return nil // 没有找到菜单，不需要删除
	}

	// 获取所有菜单数据
	menuList := models.NewSysMenuList()
	err := menuList.Find(c.Request.Context())
	if err != nil {
		return fmt.Errorf("查询菜单失败: %v", err)
	}

	// 获取完整的菜单（包括子菜单）
	menuTree := menuList.GetMenusWithChildern(menuIds...)
	if !menuTree.IsEmpty() {
		allMenuIds := menuTree.Map(func(menu *models.SysMenu) uint {
			return menu.ID
		})
		// 检查菜单是否与角色有关联
		var roleMenuCount int64
		err := db.Model(&models.SysRoleMenu{}).
			Where("menu_id IN ?", allMenuIds).
			Count(&roleMenuCount).Error
		if err != nil {
			return fmt.Errorf("检查菜单角色关联失败: %v", err)
		}

		if roleMenuCount > 0 {
			return fmt.Errorf("菜单仍与角色有关联(%d条记录)，无法删除。请先解除关联", roleMenuCount)
		}

		// 再次检查所有菜单（包括子菜单）是否与角色有关联
		var totalRoleMenuCount int64
		err = db.Model(&models.SysRoleMenu{}).
			Where("menu_id IN ?", allMenuIds).
			Count(&totalRoleMenuCount).Error
		if err != nil {
			return fmt.Errorf("检查菜单角色关联失败: %v", err)
		}

		if totalRoleMenuCount > 0 {
			return fmt.Errorf("菜单(含子菜单)仍与角色有关联(%d条记录)，无法删除。请先解除关联", totalRoleMenuCount)
		}

		// 使用事务处理菜单及API的删除操作
		err = db.WithContext(c.Request.Context()).Transaction(func(tx *gorm.DB) error {
			// 获取所有关联的API ID（需要删除的API）
			var apiIds []uint
			err := tx.Model(&models.SysMenuApi{}).
				Where("menu_id IN ?", allMenuIds).
				Distinct("api_id").
				Pluck("api_id", &apiIds).Error
			if err != nil {
				return fmt.Errorf("查询菜单关联API失败: %v", err)
			}

			// 删除菜单的关联API
			if err := tx.Where("menu_id IN ?", allMenuIds).Delete(&models.SysMenuApi{}).Error; err != nil {
				return fmt.Errorf("删除菜单API关联失败: %v", err)
			}

			// 删除菜单
			if err := tx.Where("id IN ?", allMenuIds).Delete(&models.SysMenu{}).Error; err != nil {
				return fmt.Errorf("删除菜单失败: %v", err)
			}

			// 删除孤立的API（不被其他菜单使用的API）
			if len(apiIds) > 0 {
				if err := pms.deleteOrphanedAPIsInTx(tx, apiIds); err != nil {
					return err
				}
			}

			return nil
		})

		if err != nil {
			return err
		}
	}

	return nil
}

// deleteOrphanedAPIsInTx 在事务中删除孤立的API（不被任何菜单使用的API）
func (pms *PluginsManagerService) deleteOrphanedAPIsInTx(tx *gorm.DB, apiIds []uint) error {
	if len(apiIds) == 0 {
		return nil
	}

	// 找出这些API中，不再被其他菜单关联的API
	var orphanedApiIds []uint
	for _, apiId := range apiIds {
		var count int64
		err := tx.Model(&models.SysMenuApi{}).
			Where("api_id = ?", apiId).
			Count(&count).Error
		if err != nil {
			return fmt.Errorf("检查API关联失败: %v", err)
		}

		// 如果该API不再被任何菜单关联，则标记为孤立
		if count == 0 {
			orphanedApiIds = append(orphanedApiIds, apiId)
		}
	}

	// 删除孤立的API
	if len(orphanedApiIds) > 0 {
		if err := tx.Where("id IN ?", orphanedApiIds).Delete(&models.SysApi{}).Error; err != nil {
			return fmt.Errorf("删除孤立API失败: %v", err)
		}
	}

	return nil
}

// deleteFiles 删除后端文件和文件夹
func (pms *PluginsManagerService) deleteFiles(exportDirs []string) error {
	for _, exportPath := range exportDirs {
		// 规范化路径，移除前导斜杠
		exportPath = strings.TrimPrefix(exportPath, "/")
		exportPath = strings.TrimPrefix(exportPath, "\\")

		// 检查文件或文件夹是否存在
		if _, err := os.Stat(exportPath); errors.Is(err, os.ErrNotExist) {
			// 文件不存在，跳过
			continue
		}

		// 删除文件或文件夹
		if err := os.RemoveAll(exportPath); err != nil {
			return fmt.Errorf("删除文件/文件夹失败 %s: %v", exportPath, err)
		}
	}

	return nil
}

// deleteFrontendFiles 删除前端文件和文件夹
func (pms *PluginsManagerService) deleteFrontendFiles(exportDirsFrontend []string) error {
	if len(exportDirsFrontend) == 0 {
		return nil
	}

	// 获取前端项目根目录
	frontendRootDir := app.ConfigYml.GetString("gen.dir")
	if frontendRootDir == "" {
		return errors.New("前端项目根目录未配置")
	}

	// 检查前端项目根目录是否存在
	if _, err := os.Stat(frontendRootDir); errors.Is(err, os.ErrNotExist) {
		return errors.New("前端项目根目录不存在: " + frontendRootDir)
	}

	for _, exportPath := range exportDirsFrontend {
		// 规范化路径，移除前导斜杠
		exportPath = strings.TrimPrefix(exportPath, "/")
		exportPath = strings.TrimPrefix(exportPath, "\\")

		// 构建完整路径
		fullPath := filepath.Join(frontendRootDir, exportPath)

		// 检查文件或文件夹是否存在
		if _, err := os.Stat(fullPath); errors.Is(err, os.ErrNotExist) {
			// 文件不存在，跳过
			continue
		}

		// 删除文件或文件夹
		if err := os.RemoveAll(fullPath); err != nil {
			return fmt.Errorf("删除前端文件/文件夹失败 %s: %v", exportPath, err)
		}
	}

	return nil
}

// dropDatabaseTables 删除数据库表
func (pms *PluginsManagerService) dropDatabaseTables(tableNames []string) error {
	if len(tableNames) == 0 {
		return nil
	}

	// 获取数据库连接
	dbType := app.ConfigYml.GetString("gormv2.usedbtype")
	var db *gorm.DB
	var err error

	switch dbType {
	case "mysql":
		db, err = gormhelper.GetOneMysqlClient()
	case "postgresql":
		db, err = gormhelper.GetOnePostgreSqlClient()
	case "sqlserver":
		db, err = gormhelper.GetOneSqlserverClient()
	default:
		db, err = gormhelper.GetOneMysqlClient()
	}

	if err != nil {
		return fmt.Errorf("获取数据库连接失败: %v", err)
	}

	// 删除每个表
	for _, tableName := range tableNames {
		switch dbType {
		case "mysql":
			if err := db.Exec(fmt.Sprintf("DROP TABLE IF EXISTS `%s`", tableName)).Error; err != nil {
				return fmt.Errorf("删除MySQL表失败 %s: %v", tableName, err)
			}
		case "postgresql":
			if err := db.Exec(fmt.Sprintf("DROP TABLE IF EXISTS %s CASCADE", tableName)).Error; err != nil {
				return fmt.Errorf("删除PostgreSQL表失败 %s: %v", tableName, err)
			}
		case "sqlserver":
			if err := db.Exec(fmt.Sprintf("IF OBJECT_ID('[%s]') IS NOT NULL DROP TABLE [%s]", tableName, tableName)).Error; err != nil {
				return fmt.Errorf("删除SQL Server表失败 %s: %v", tableName, err)
			}
		default:
			if err := db.Exec(fmt.Sprintf("DROP TABLE IF EXISTS `%s`", tableName)).Error; err != nil {
				return fmt.Errorf("删除表失败 %s: %v", tableName, err)
			}
		}
	}

	return nil
}
