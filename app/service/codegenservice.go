package service

import (
	"context"
	"database/sql"
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"
	"gin-fast/app/utils/gormhelper"
	"os"
	"path/filepath"
	"strings"
	"text/template"

	"go.uber.org/zap"
	"gorm.io/gorm"
)

// CodeGenService 代码生成服务
type CodeGenService struct{}

// NewCodeGenService 创建代码生成服务
func NewCodeGenService() *CodeGenService {
	return &CodeGenService{}
}

// GetDatabases 获取数据库列表
func (cgs *CodeGenService) GetDatabases(dbType string) ([]string, error) {
	// 获取数据库连接
	if dbType == "" {
		dbType = app.ConfigYml.GetString("gormv2.usedbtype")
	}
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
		return nil, err
	}

	// 获取原生数据库连接
	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	var databases []string

	// 根据数据库类型执行不同的查询
	switch dbType {
	case "mysql":
		rows, err := sqlDB.Query("SHOW DATABASES")
		if err != nil {
			return nil, err
		}
		defer rows.Close()

		for rows.Next() {
			var dbName string
			if err := rows.Scan(&dbName); err != nil {
				return nil, err
			}
			databases = append(databases, dbName)
		}
	case "postgresql":
		rows, err := sqlDB.Query("SELECT datname FROM pg_database WHERE datistemplate = false")
		if err != nil {
			return nil, err
		}
		defer rows.Close()

		for rows.Next() {
			var dbName string
			if err := rows.Scan(&dbName); err != nil {
				return nil, err
			}
			databases = append(databases, dbName)
		}
	case "sqlserver":
		rows, err := sqlDB.Query("SELECT name FROM sys.databases")
		if err != nil {
			return nil, err
		}
		defer rows.Close()

		for rows.Next() {
			var dbName string
			if err := rows.Scan(&dbName); err != nil {
				return nil, err
			}
			databases = append(databases, dbName)
		}
	default:
		return nil, fmt.Errorf("不支持的数据库类型: %s", dbType)
	}

	return databases, nil
}

// GetTables 获取指定数据库中的所有表
func (cgs *CodeGenService) GetTables(dbType, database string) ([]models.TableInfo, error) {

	// 获取数据库连接
	if dbType == "" {
		dbType = app.ConfigYml.GetString("gormv2.usedbtype")
	}
	// 获取默认的数据库
	if database == "" {
		// 从配置文件中获取默认数据库
		database = app.ConfigYml.GetString("gormv2." + dbType + ".write.database")
	}
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
		return nil, err
	}

	// 获取原生数据库连接
	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	var tables []models.TableInfo

	// 根据数据库类型执行不同的查询
	switch dbType {
	case "mysql":
		rows, err := sqlDB.Query("SELECT TABLE_NAME, TABLE_COMMENT FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = ?", database)
		if err != nil {
			return nil, err
		}
		defer rows.Close()

		for rows.Next() {
			var table models.TableInfo
			if err := rows.Scan(&table.TableName, &table.TableComment); err != nil {
				return nil, err
			}
			tables = append(tables, table)
		}
	case "postgresql":
		// PostgreSQL需要先切换到指定数据库
		_, err := sqlDB.Exec("USE " + database)
		if err != nil {
			// 如果USE命令失败，尝试直接查询
			rows, err := sqlDB.Query(`
				SELECT 
					t.tablename,
					obj_description(c.oid) as tablecomment
				FROM pg_tables t
				LEFT JOIN pg_class c ON c.relname = t.tablename
				WHERE t.schemaname = 'public'`)
			if err != nil {
				return nil, err
			}
			defer rows.Close()

			for rows.Next() {
				var table models.TableInfo
				if err := rows.Scan(&table.TableName, &table.TableComment); err != nil {
					return nil, err
				}
				tables = append(tables, table)
			}
		} else {
			rows, err := sqlDB.Query(`
				SELECT 
					t.tablename,
					obj_description(c.oid) as tablecomment
				FROM pg_tables t
				LEFT JOIN pg_class c ON c.relname = t.tablename
				WHERE t.schemaname = 'public'`)
			if err != nil {
				return nil, err
			}
			defer rows.Close()

			for rows.Next() {
				var table models.TableInfo
				if err := rows.Scan(&table.TableName, &table.TableComment); err != nil {
					return nil, err
				}
				tables = append(tables, table)
			}
		}
	case "sqlserver":
		rows, err := sqlDB.Query(`
			SELECT 
				t.TABLE_NAME,
				ISNULL(ep.value, '') as TABLE_COMMENT
			FROM INFORMATION_SCHEMA.TABLES t
			LEFT JOIN sys.extended_properties ep
				ON ep.major_id = OBJECT_ID(t.TABLE_SCHEMA + '.' + t.TABLE_NAME)
				AND ep.minor_id = 0
				AND ep.name = 'MS_Description'
			WHERE t.TABLE_CATALOG = ? AND t.TABLE_TYPE = 'BASE TABLE'`, database)
		if err != nil {
			return nil, err
		}
		defer rows.Close()

		for rows.Next() {
			var table models.TableInfo
			if err := rows.Scan(&table.TableName, &table.TableComment); err != nil {
				return nil, err
			}
			tables = append(tables, table)
		}
	default:
		return nil, fmt.Errorf("不支持的数据库类型")
	}

	return tables, nil
}

// GetTableColumns 获取指定表的所有字段信息
func (cgs *CodeGenService) GetTableColumns(database, table string) (models.TableColumns, error) {
	if database == "" {
		return nil, fmt.Errorf("数据库名称不能为空")
	}

	if table == "" {
		return nil, fmt.Errorf("表名不能为空")
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
		return nil, err
	}

	// 获取原生数据库连接
	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	var columns []models.TableColumn

	// 根据数据库类型执行不同的查询
	switch dbType {
	case "mysql":
		rows, err := sqlDB.Query(`
			SELECT
				COLUMN_NAME,
				DATA_TYPE,
				COLUMN_COMMENT,
				IS_NULLABLE,
				COLUMN_DEFAULT,
				COLUMN_KEY,
				EXTRA,
				COLUMN_TYPE
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?
			ORDER BY ORDINAL_POSITION`, database, table)
		if err != nil {
			return nil, err
		}
		defer rows.Close()

		for rows.Next() {
			var column models.TableColumn
			var columnComment, columnDefault, columnKey, extra, columnType sql.NullString
			if err := rows.Scan(
				&column.ColumnName,
				&column.DataType,
				&columnComment,
				&column.IsNullable,
				&columnDefault,
				&columnKey,
				&extra,
				&columnType); err != nil {
				return nil, err
			}
			column.ColumnComment = columnComment
			column.ColumnDefault = columnDefault
			column.ColumnKey = columnKey
			column.Extra = extra
			// 检查是否为unsigned字段
			column.IsUnsigned = columnType.Valid && strings.Contains(strings.ToUpper(columnType.String), "UNSIGNED")
			columns = append(columns, column)
		}
	case "postgresql":
		// PostgreSQL需要先切换到指定数据库
		_, err := sqlDB.Exec("USE " + database)
		if err != nil {
			// 如果USE命令失败，尝试直接查询
			rows, err := sqlDB.Query(`
				SELECT
					column_name,
					data_type,
					col_description((table_schema||'.'||table_name)::regclass, ordinal_position) as column_comment,
					is_nullable,
					column_default,
					'' as column_key,
					'' as extra,
					'' as column_type
				FROM information_schema.columns
				WHERE table_schema = 'public' AND table_name = $1
				ORDER BY ordinal_position`, table)
			if err != nil {
				return nil, err
			}
			defer rows.Close()

			for rows.Next() {
				var column models.TableColumn
				var columnComment, columnDefault, columnKey, extra, columnType sql.NullString
				if err := rows.Scan(
					&column.ColumnName,
					&column.DataType,
					&columnComment,
					&column.IsNullable,
					&columnDefault,
					&columnKey,
					&extra,
					&columnType); err != nil {
					return nil, err
				}
				column.ColumnComment = columnComment
				column.ColumnDefault = columnDefault
				column.ColumnKey = columnKey
				column.Extra = extra
				// PostgreSQL不支持unsigned，直接设置为false
				column.IsUnsigned = false
				columns = append(columns, column)
			}
		} else {
			rows, err := sqlDB.Query(`
				SELECT
					column_name,
					data_type,
					col_description((table_schema||'.'||table_name)::regclass, ordinal_position) as column_comment,
					is_nullable,
					column_default,
					'' as column_key,
					'' as extra,
					'' as column_type
				FROM information_schema.columns
				WHERE table_schema = 'public' AND table_name = $1
				ORDER BY ordinal_position`, table)
			if err != nil {
				return nil, err
			}
			defer rows.Close()

			for rows.Next() {
				var column models.TableColumn
				var columnComment, columnDefault, columnKey, extra, columnType sql.NullString
				if err := rows.Scan(
					&column.ColumnName,
					&column.DataType,
					&columnComment,
					&column.IsNullable,
					&columnDefault,
					&columnKey,
					&extra,
					&columnType); err != nil {
					return nil, err
				}
				column.ColumnComment = columnComment
				column.ColumnDefault = columnDefault
				column.ColumnKey = columnKey
				column.Extra = extra
				// PostgreSQL不支持unsigned，直接设置为false
				column.IsUnsigned = false
				columns = append(columns, column)
			}
		}
	case "sqlserver":
		rows, err := sqlDB.Query(`
			SELECT
				c.COLUMN_NAME,
				c.DATA_TYPE,
				ISNULL(ep.value, '') as COLUMN_COMMENT,
				c.IS_NULLABLE,
				c.COLUMN_DEFAULT,
				CASE WHEN pk.COLUMN_NAME IS NOT NULL THEN 'PRI' ELSE '' END as COLUMN_KEY,
				'' as EXTRA,
				'' as COLUMN_TYPE
			FROM INFORMATION_SCHEMA.COLUMNS c
			LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE pk
				ON c.TABLE_NAME = pk.TABLE_NAME
				AND c.COLUMN_NAME = pk.COLUMN_NAME
				AND pk.CONSTRAINT_NAME LIKE 'PK_%'
			LEFT JOIN sys.extended_properties ep
				ON ep.major_id = OBJECT_ID(c.TABLE_SCHEMA + '.' + c.TABLE_NAME)
				AND ep.minor_id = COLUMNPROPERTY(ep.major_id, c.COLUMN_NAME, 'ColumnId')
				AND ep.name = 'MS_Description'
			WHERE c.TABLE_CATALOG = ? AND c.TABLE_NAME = ?
			ORDER BY c.ORDINAL_POSITION`, database, table)
		if err != nil {
			return nil, err
		}
		defer rows.Close()

		for rows.Next() {
			var column models.TableColumn
			var columnComment, columnDefault, columnKey, extra, columnType sql.NullString
			if err := rows.Scan(
				&column.ColumnName,
				&column.DataType,
				&columnComment,
				&column.IsNullable,
				&columnDefault,
				&columnKey,
				&extra,
				&columnType); err != nil {
				return nil, err
			}
			column.ColumnComment = columnComment
			column.ColumnDefault = columnDefault
			column.ColumnKey = columnKey
			column.Extra = extra
			// SQL Server不支持unsigned，直接设置为false
			column.IsUnsigned = false
			columns = append(columns, column)
		}
	default:
		return nil, fmt.Errorf("不支持的数据库类型")
	}

	return columns, nil
}

// 生成后端代码文件
func (cgs *CodeGenService) GenerateBackendCodeFiles(ctx context.Context, sysGen *models.SysGen) error {
	var tableName, dirName, fileName, comment string
	var columnTemplates models.ColumnTemplateList
	tableName = sysGen.Name
	//KeepLettersOnlyLower 只保留字符串中的英文字母，并且全部转换为小写
	dirName = common.KeepLettersOnlyLower(sysGen.ModuleName)
	fileName = common.KeepLettersOnlyLower(sysGen.FileName)
	comment = sysGen.Describe
	columnTemplates = sysGen.SysGenFields.ToColumnTemplate()

	// 构建插件目录路径
	pluginsDir := filepath.Join("plugins", dirName)

	// 创建基础的插件目录结构
	dirs := []string{
		pluginsDir,
		filepath.Join(pluginsDir, "controllers"),
		filepath.Join(pluginsDir, "models"),
		filepath.Join(pluginsDir, "service"),
		filepath.Join(pluginsDir, "routes"),
	}

	for _, dir := range dirs {
		if err := os.MkdirAll(dir, 0755); err != nil {
			return fmt.Errorf("创建目录失败: %s, 错误: %v", dir, err)
		}
	}

	// 创建代码生成上下文
	codeGenCtx := models.NewCodeGenContext(tableName, sysGen.ModuleName, sysGen.FileName, comment, columnTemplates)

	// 生成模型代码
	modelCode := cgs.generateModelCode(codeGenCtx)
	modelFilePath := filepath.Join(pluginsDir, "models", fileName+".go")
	if err := cgs.writeCodeToFile(modelFilePath, modelCode); err != nil {
		return fmt.Errorf("生成模型文件失败: %v", err)
	}

	// 生成参数模型代码
	modelParamCode := cgs.generateModelParamCode(codeGenCtx)
	modelParamFilePath := filepath.Join(pluginsDir, "models", fileName+"param.go")
	if err := cgs.writeCodeToFile(modelParamFilePath, modelParamCode); err != nil {
		return fmt.Errorf("生成参数模型文件失败: %v", err)
	}

	// 生成控制器代码
	controllerCode := cgs.generateControllerCode(codeGenCtx)
	controllerFilePath := filepath.Join(pluginsDir, "controllers", fileName+"controller.go")
	if err := cgs.writeCodeToFile(controllerFilePath, controllerCode); err != nil {
		return fmt.Errorf("生成控制器文件失败: %v", err)
	}

	// 生成服务代码
	serviceCode := cgs.generateServiceCode(codeGenCtx)
	serviceFilePath := filepath.Join(pluginsDir, "service", fileName+"service.go")
	if err := cgs.writeCodeToFile(serviceFilePath, serviceCode); err != nil {
		return fmt.Errorf("生成服务文件失败: %v", err)
	}

	// 生成路由代码
	routesCode := cgs.generateRoutesCode(codeGenCtx)
	routesFilePath := filepath.Join(pluginsDir, "routes", fileName+"routes.go")
	if err := cgs.writeCodeToFile(routesFilePath, routesCode); err != nil {
		return fmt.Errorf("生成路由文件失败: %v", err)
	}

	// 生成初始化代码
	initCode := cgs.generateInitCode(codeGenCtx)
	initFilePath := filepath.Join("plugins", dirName+"init.go")
	if err := cgs.writeCodeToFile(initFilePath, initCode); err != nil {
		return fmt.Errorf("生成初始化文件失败: %v", err)
	}

	// 插入菜单和API数据
	menuApiCtx := &models.MenuApiContext{TableName: tableName, FileName: fileName, DirName: dirName, Comment: comment}
	if err := cgs.InsertMenuAndApiData(ctx, menuApiCtx); err != nil {
		return fmt.Errorf("插入菜单和API数据失败: %v", err)
	}

	return nil
}

// 生成前端代码文件
func (cgs *CodeGenService) GenerateFrontendCodeFiles(sysGen *models.SysGen) error {
	var tableName, dirName, fileName string
	tableName = sysGen.Name
	// KeepLettersOnlyLower 只保留字符串中的英文字母，并且全部转换为小写
	dirName = common.KeepLettersOnlyLower(sysGen.ModuleName)
	fileName = common.KeepLettersOnlyLower(sysGen.FileName)
	columnTemplates := sysGen.SysGenFields.ToColumnTemplate()
	// 获取前端代码生成目录配置
	frontendDir := cgs.getFrontendGenDir()
	if frontendDir == "" {
		return fmt.Errorf("前端代码生成目录未配置或不存在")
	}

	// 构建前端插件目录路径
	pluginsDir := filepath.Join(frontendDir, dirName)

	// 创建前端插件目录结构
	dirs := []string{
		pluginsDir,
		filepath.Join(pluginsDir, "api"),
		filepath.Join(pluginsDir, "store"),
		filepath.Join(pluginsDir, "views"),
	}

	for _, dir := range dirs {
		if err := os.MkdirAll(dir, 0755); err != nil {
			return fmt.Errorf("创建前端目录失败: %s, 错误: %v", dir, err)
		}
	}

	// 生成API代码
	frontendCtx := models.NewFrontendGenContext(tableName, sysGen.ModuleName, sysGen.FileName, columnTemplates)
	apiCode := cgs.generateFrontendAPICode(frontendCtx)
	apiFilePath := filepath.Join(pluginsDir, "api", fileName+".ts")
	if err := cgs.writeCodeToFile(apiFilePath, apiCode); err != nil {
		return fmt.Errorf("生成API文件失败: %v", err)
	}

	// 生成Store代码
	storeCode := cgs.generateFrontendStoreCode(frontendCtx)
	storeFilePath := filepath.Join(pluginsDir, "store", fileName+".ts")
	if err := cgs.writeCodeToFile(storeFilePath, storeCode); err != nil {
		return fmt.Errorf("生成Store文件失败: %v", err)
	}

	// 生成视图代码
	viewCode := cgs.generateFrontendViewCode(frontendCtx)
	viewFilePath := filepath.Join(pluginsDir, "views", fileName+"list.vue")
	if err := cgs.writeCodeToFile(viewFilePath, viewCode); err != nil {
		return fmt.Errorf("生成视图文件失败: %v", err)
	}

	return nil
}

// getFrontendGenDir 获取前端代码生成目录
func (cgs *CodeGenService) getFrontendGenDir() string {
	// 从配置文件中读取前端代码生成目录
	// 检查配置文件中的gen.dir配置
	if app.ConfigYml != nil {
		frontendDir := app.ConfigYml.GetString("gen.dir")
		if frontendDir != "" {
			// 检查路径目录是否存在
			if _, err := os.Stat(frontendDir); os.IsNotExist(err) {
				// 路径不存在，返回空字符串触发错误处理
				return ""
			}
			return frontendDir
		}
	}

	// 不返回默认路径，而是返回空字符串触发错误处理
	return ""
}

// generateFrontendAPICode 生成前端API代码
func (cgs *CodeGenService) generateFrontendAPICode(ctx *models.FrontendGenContext) string {
	// 创建模板数据
	templateData := map[string]interface{}{
		"StructName":      ctx.StructName,
		"StructNameLower": ctx.StructNameLower,
		"TableName":       ctx.TableName,
		"DirName":         ctx.DirName,
		"FileName":        ctx.FileName,
		"Columns":         ctx.Columns,
		"PrimaryKey":      ctx.PrimaryKey,
	}

	for key, value := range ctx.ExtraParams {
		templateData[key] = value
	}

	// 解析模板并生成代码
	return cgs.executeTemplate("frontend/api.tpl", templateData)
}

// generateFrontendStoreCode 生成前端Store代码
func (cgs *CodeGenService) generateFrontendStoreCode(ctx *models.FrontendGenContext) string {
	// 创建模板数据
	templateData := map[string]interface{}{
		"StructName":      ctx.StructName,
		"StructNameLower": ctx.StructNameLower,
		"TableName":       ctx.TableName,
		"DirName":         ctx.DirName,
		"FileName":        ctx.FileName,
		"Columns":         ctx.Columns,
		"PrimaryKey":      ctx.PrimaryKey,
	}

	for key, value := range ctx.ExtraParams {
		templateData[key] = value
	}

	// 解析模板并生成代码
	return cgs.executeTemplate("frontend/store.tpl", templateData)
}

// generateFrontendViewCode 生成前端视图代码
func (cgs *CodeGenService) generateFrontendViewCode(ctx *models.FrontendGenContext) string {
	// 创建模板数据
	templateData := map[string]interface{}{
		"StructName":      ctx.StructName,
		"StructNameLower": ctx.StructNameLower,
		"TableName":       ctx.TableName,
		"DirName":         ctx.DirName,
		"FileName":        ctx.FileName,
		"Columns":         ctx.Columns,
		"PrimaryKey":      ctx.PrimaryKey,
	}

	for key, value := range ctx.ExtraParams {
		templateData[key] = value
	}

	// 解析模板并生成代码
	return cgs.executeTemplate("frontend/views.tpl", templateData)
}

// GenerateCode 生成后端代码
func (cgs *CodeGenService) GenerateCode(database, table string) (map[string]string, error) {
	if database == "" {
		return nil, fmt.Errorf("数据库名称不能为空")
	}

	if table == "" {
		return nil, fmt.Errorf("表名不能为空")
	}

	// 获取表的字段信息
	columns, err := cgs.GetTableColumns(database, table)
	if err != nil {
		return nil, err
	}

	// 将表名转换为目录名（移除下划线并转为小写）
	dirName := common.KeepLettersOnlyLower(table)
	fileName := common.KeepLettersOnlyLower(table)
	columnTemplates := columns.ColumnTemplate()

	// 创建代码生成上下文
	codeGenCtx := models.NewCodeGenContext(table, dirName, fileName, table, columnTemplates)

	// 生成模型代码
	modelCode := cgs.generateModelCode(codeGenCtx)

	// 生成参数模型代码
	modelParamCode := cgs.generateModelParamCode(codeGenCtx)

	// 生成控制器代码
	controllerCode := cgs.generateControllerCode(codeGenCtx)

	// 生成服务代码
	serviceCode := cgs.generateServiceCode(codeGenCtx)

	// 生成路由代码
	routesCode := cgs.generateRoutesCode(codeGenCtx)

	// 生成初始化代码
	initCode := cgs.generateInitCode(codeGenCtx)

	return map[string]string{
		"model":      modelCode,
		"modelparam": modelParamCode,
		"controller": controllerCode,
		"service":    serviceCode,
		"routes":     routesCode,
		"init":       initCode,
	}, nil
}

// generateModelCode 生成模型代码
func (cgs *CodeGenService) generateModelCode(ctx *models.CodeGenContext) string {
	primaryKey := ctx.PrimaryKey

	// 创建模板数据
	templateData := map[string]interface{}{
		"StructName":   ctx.StructName,
		"TableName":    ctx.TableName,
		"Columns":      ctx.Columns,
		"PrimaryKey":   primaryKey,
		"HasTimeField": ctx.HasTimeField,
	}

	for key, value := range ctx.ExtraParams {
		templateData[key] = value
	}

	// 解析模板并生成代码
	return cgs.executeTemplate("model.tpl", templateData)
}

// generateModelParamCode 生成参数模型代码
func (cgs *CodeGenService) generateModelParamCode(ctx *models.CodeGenContext) string {
	primaryKey := ctx.PrimaryKey

	// 创建模板数据
	templateData := map[string]interface{}{
		"StructName":   ctx.StructName,
		"TableName":    ctx.TableName,
		"Columns":      ctx.Columns,
		"PrimaryKey":   primaryKey,
		"HasTimeField": ctx.HasTimeField,
	}

	for key, value := range ctx.ExtraParams {
		templateData[key] = value
	}

	// 解析模板并生成代码
	return cgs.executeTemplate("modelparam.tpl", templateData)
}

// generateControllerCode 生成控制器代码
func (cgs *CodeGenService) generateControllerCode(ctx *models.CodeGenContext) string {
	// 创建模板数据
	templateData := map[string]interface{}{
		"StructName":      ctx.StructName,
		"StructNameLower": ctx.StructNameLower,
		"TableName":       ctx.TableName,
		"DirName":         ctx.DirName,
		"PrimaryKey":      ctx.PrimaryKey,
	}

	for key, value := range ctx.ExtraParams {
		templateData[key] = value
	}

	// 解析模板并生成代码
	return cgs.executeTemplate("controller.tpl", templateData)
}

// generateServiceCode 生成服务代码
func (cgs *CodeGenService) generateServiceCode(ctx *models.CodeGenContext) string {
	// 创建模板数据
	templateData := map[string]interface{}{
		"StructName":      ctx.StructName,
		"StructNameLower": ctx.StructNameLower,
		"TableName":       ctx.TableName,
		"DirName":         ctx.DirName,
		"Columns":         ctx.Columns,
		"PrimaryKey":      ctx.PrimaryKey,
	}

	for key, value := range ctx.ExtraParams {
		templateData[key] = value
	}

	// 解析模板并生成代码
	return cgs.executeTemplate("service.tpl", templateData)
}

// generateRoutesCode 生成路由代码
func (cgs *CodeGenService) generateRoutesCode(ctx *models.CodeGenContext) string {
	// 创建模板数据
	templateData := map[string]interface{}{
		"StructName":      ctx.StructName,
		"StructNameLower": ctx.StructNameLower,
		"TableName":       ctx.TableName,
		"DirName":         ctx.DirName,
		"FileName":        ctx.FileName,
		"PrimaryKey":      ctx.PrimaryKey,
	}

	for key, value := range ctx.ExtraParams {
		templateData[key] = value
	}

	// 解析模板并生成代码
	return cgs.executeTemplate("routes.tpl", templateData)
}

// generateInitCode 生成初始化代码
func (cgs *CodeGenService) generateInitCode(ctx *models.CodeGenContext) string {
	// 创建模板数据
	templateData := map[string]interface{}{
		"StructName":      ctx.StructName,
		"StructNameLower": ctx.StructNameLower,
		"TableName":       ctx.TableName,
		"DirName":         ctx.DirName,
	}

	for key, value := range ctx.ExtraParams {
		templateData[key] = value
	}

	// 解析模板并生成代码
	return cgs.executeTemplate("init.tpl", templateData)
}

// GetConfig 获取代码生成配置
func (cgs *CodeGenService) GetConfig() (map[string]interface{}, error) {
	// 简化实现，返回默认配置
	return map[string]interface{}{
		"model_template":      "default",
		"controller_template": "default",
		"service_template":    "default",
		"output_path":         "./generated",
		"package_name":        "generated",
	}, nil
}

// UpdateConfig 更新代码生成配置
func (cgs *CodeGenService) UpdateConfig(config models.CodeGenConfig) error {
	// 简化实现，实际应该保存配置到文件或数据库
	return nil
}

// GetTemplates 获取模板列表
func (cgs *CodeGenService) GetTemplates() ([]string, error) {
	// 简化实现，返回默认模板列表
	return []string{"default", "simple", "advanced"}, nil
}

// GetTemplateContent 获取模板内容
func (cgs *CodeGenService) GetTemplateContent(templateName string) (string, error) {
	// 简化实现，返回默认模板内容
	switch templateName {
	case "default":
		return "默认模板内容", nil
	case "simple":
		return "简单模板内容", nil
	case "advanced":
		return "高级模板内容", nil
	default:
		return "", fmt.Errorf("模板不存在: %s", templateName)
	}
}

// DownloadCode 下载生成的代码
func (cgs *CodeGenService) DownloadCode(database, table, moduleName string) (string, error) {
	// 简化实现，生成代码并返回下载路径
	_, err := cgs.GenerateCode(database, table)
	if err != nil {
		return "", err
	}

	// 实际应该创建文件并返回下载路径
	return fmt.Sprintf("/downloads/%s_%s.zip", database, table), nil
}

// executeTemplate 执行模板
func (cgs *CodeGenService) executeTemplate(templateName string, data interface{}) string {
	// 获取当前工作目录
	wd, err := os.Getwd()
	if err != nil {
		app.ZapLog.Error("获取工作目录失败", zap.Error(err))
		return ""
	}

	// 构建模板文件路径
	templatePath := filepath.Join(wd, "gen", "templates", templateName)

	// 读取模板文件
	templateContent, err := os.ReadFile(templatePath)
	if err != nil {
		app.ZapLog.Error("读取模板文件失败", zap.String("templatePath", templatePath), zap.Error(err))
		return ""
	}

	// 解析模板
	tmpl, err := template.New(templateName).Parse(string(templateContent))
	if err != nil {
		app.ZapLog.Error("解析模板失败", zap.String("templateName", templateName), zap.Error(err))
		return ""
	}

	// 执行模板
	var buf strings.Builder
	err = tmpl.Execute(&buf, data)
	if err != nil {
		app.ZapLog.Error("执行模板失败", zap.String("templateName", templateName), zap.Error(err))
		return ""
	}

	return buf.String()
}

// writeCodeToFile 将代码写入文件
func (cgs *CodeGenService) writeCodeToFile(filePath string, content string) error {
	// 确保目录存在
	dir := filepath.Dir(filePath)
	if err := os.MkdirAll(dir, 0755); err != nil {
		return fmt.Errorf("创建目录失败: %v", err)
	}

	// 写入文件
	if err := os.WriteFile(filePath, []byte(content), 0644); err != nil {
		return fmt.Errorf("写入文件失败: %v", err)
	}

	return nil
}

// InsertMenuAndApiData 在生成代码时插入菜单和API数据
func (cgs *CodeGenService) InsertMenuAndApiData(ctx context.Context, menuApiCtx *models.MenuApiContext) error {
	// 获取数据库连接
	db := app.DB()

	// 生成菜单和API数据
	menuData, apiData, err := cgs.generateMenuAndApiData(menuApiCtx.FileName, menuApiCtx.DirName, menuApiCtx.Comment)
	if err != nil {
		return fmt.Errorf("生成菜单和API数据失败: %v", err)
	}

	// 开始事务
	tx := db.WithContext(ctx).Begin()
	if tx.Error != nil {
		return fmt.Errorf("开始事务失败: %v", tx.Error)
	}
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// 插入主菜单数据
	mainMenu := &menuData[0]
	// 检查主菜单是否已存在
	var existMenu models.SysMenu
	err = tx.Where("name = ?", mainMenu.Name).First(&existMenu).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		tx.Rollback()
		return fmt.Errorf("检查主菜单是否存在失败: %v", err)
	}

	if existMenu.IsEmpty() {
		// 主菜单不存在，插入新菜单
		if err := tx.Create(mainMenu).Error; err != nil {
			tx.Rollback()
			return fmt.Errorf("插入主菜单失败: %v", err)
		}
	} else {
		// 主菜单已存在，更新ID以便后续使用
		mainMenu.ID = existMenu.ID
	}

	// 更新按钮菜单的父级ID
	for i := 1; i < 4; i++ {
		menuData[i].ParentID = mainMenu.ID
	}

	// 插入按钮菜单数据
	for i := 1; i < 4; i++ {
		buttonMenu := &menuData[i]
		// 检查按钮菜单是否已存在
		var existButton models.SysMenu
		err := tx.Where("permission = ? AND type = 3", buttonMenu.Permission).First(&existButton).Error
		if err != nil && err != gorm.ErrRecordNotFound {
			tx.Rollback()
			return fmt.Errorf("检查按钮菜单是否存在失败: %v", err)
		}

		if existButton.IsEmpty() {
			// 按钮菜单不存在，插入新菜单
			if err := tx.Create(buttonMenu).Error; err != nil {
				tx.Rollback()
				return fmt.Errorf("插入按钮菜单失败: %v", err)
			}
		} else {
			// 按钮菜单已存在，更新ID以便后续使用
			buttonMenu.ID = existButton.ID
		}
	}

	// 插入API数据
	for i := range apiData {
		api := &apiData[i]
		// 检查API是否已存在
		var existApi models.SysApi
		err := tx.Where("path = ? AND method = ?", api.Path, api.Method).First(&existApi).Error
		if err != nil && err != gorm.ErrRecordNotFound {
			tx.Rollback()
			return fmt.Errorf("检查API是否存在失败: %v", err)
		}

		if existApi.IsEmpty() {
			// API不存在，插入新API
			if err := tx.Create(api).Error; err != nil {
				tx.Rollback()
				return fmt.Errorf("插入API失败: %v", err)
			}
		} else {
			// API已存在，更新ID以便后续使用
			api.ID = existApi.ID
		}
	}

	// 生成并插入菜单API关联数据
	menuApiData := cgs.generateMenuApiData(menuData, apiData)
	for _, menuApi := range menuApiData {
		// 检查关联是否已存在
		var existMenuApi models.SysMenuApi
		err := tx.Where("menu_id = ? AND api_id = ?", menuApi.MenuID, menuApi.ApiID).First(&existMenuApi).Error
		if err != nil && err != gorm.ErrRecordNotFound {
			tx.Rollback()
			return fmt.Errorf("检查菜单API关联是否存在失败: %v", err)
		}

		if existMenuApi.MenuID == 0 {
			// 关联不存在，插入新关联
			if err := tx.Create(&menuApi).Error; err != nil {
				tx.Rollback()
				return fmt.Errorf("插入菜单API关联失败: %v", err)
			}
		}
	}

	// 提交事务
	if err := tx.Commit().Error; err != nil {
		return fmt.Errorf("提交事务失败: %v", err)
	}

	return nil
}

// generateMenuAndApiData 生成菜单和API数据
func (cgs *CodeGenService) generateMenuAndApiData(fileName, dirName, comment string) (
	[]models.SysMenu, []models.SysApi, error) {

	// 父级菜单ID
	parentMenuID := uint(0)

	routerPath := dirName + fileName
	// 生成主菜单项
	mainMenu := models.SysMenu{
		ParentID:   parentMenuID,
		Path:       "/plugins/" + dirName + "/" + fileName + "list",
		Name:       "Plugins" + routerPath,
		Component:  "plugins/" + dirName + "/views/" + fileName + "list",
		Title:      comment, // 使用表注释作为菜单标题
		IsFull:     false,
		Hide:       false,
		Disable:    false,
		KeepAlive:  true,
		Affix:      false,
		Link:       "",
		Iframe:     false,
		SvgIcon:    "",
		Icon:       "IconMenu",
		Sort:       0,
		Type:       2, // 菜单类型
		IsLink:     false,
		Permission: "",
	}

	// 生成按钮菜单项
	addButton := models.SysMenu{
		Title:      "新增",
		IsFull:     false,
		Hide:       false,
		Disable:    false,
		KeepAlive:  true,
		Affix:      false,
		Link:       "",
		Iframe:     false,
		SvgIcon:    "",
		Icon:       "",
		Sort:       0,
		Type:       3, // 按钮类型
		IsLink:     false,
		Permission: "plugins:" + routerPath + ":add",
	}

	editButton := models.SysMenu{
		Title:      "编辑",
		IsFull:     false,
		Hide:       false,
		Disable:    false,
		KeepAlive:  true,
		Affix:      false,
		Link:       "",
		Iframe:     false,
		SvgIcon:    "",
		Icon:       "",
		Sort:       0,
		Type:       3, // 按钮类型
		IsLink:     false,
		Permission: "plugins:" + routerPath + ":edit",
	}

	deleteButton := models.SysMenu{
		Title:      "删除",
		IsFull:     false,
		Hide:       false,
		Disable:    false,
		KeepAlive:  true,
		Affix:      false,
		Link:       "",
		Iframe:     false,
		SvgIcon:    "",
		Icon:       "",
		Sort:       0,
		Type:       3, // 按钮类型
		IsLink:     false,
		Permission: "plugins:" + routerPath + ":delete",
	}

	// 菜单列表
	menus := []models.SysMenu{mainMenu, addButton, editButton, deleteButton}

	// 生成API数据
	listApi := models.SysApi{
		Title:    "列表查询",
		Path:     "/api/plugins/" + dirName + "/" + fileName + "/list",
		Method:   "GET",
		ApiGroup: comment, // 使用表注释作为API分组
	}

	addApi := models.SysApi{
		Title:    "新增",
		Path:     "/api/plugins/" + dirName + "/" + fileName + "/add",
		Method:   "POST",
		ApiGroup: comment, // 使用表注释作为API分组
	}

	editApi := models.SysApi{
		Title:    "修改",
		Path:     "/api/plugins/" + dirName + "/" + fileName + "/edit",
		Method:   "PUT",
		ApiGroup: comment, // 使用表注释作为API分组
	}

	deleteApi := models.SysApi{
		Title:    "删除",
		Path:     "/api/plugins/" + dirName + "/" + fileName + "/delete",
		Method:   "DELETE",
		ApiGroup: comment, // 使用表注释作为API分组
	}

	getByIdApi := models.SysApi{
		Title:    "查询单条数据",
		Path:     "/api/plugins/" + dirName + "/" + fileName + "/:id", // 这里使用:id作为参数
		Method:   "GET",
		ApiGroup: comment, // 使用表注释作为API分组
	}

	// API列表
	apis := []models.SysApi{listApi, addApi, editApi, deleteApi, getByIdApi}

	return menus, apis, nil
}

// generateMenuApiData 生成菜单API关联数据
func (cgs *CodeGenService) generateMenuApiData(menus []models.SysMenu, apis []models.SysApi) []models.SysMenuApi {
	// 关联数据：
	// 主菜单 -> 列表查询API
	// 新增按钮 -> 新增API
	// 编辑按钮 -> 编辑API
	// 编辑按钮 -> 查询单条数据API
	// 删除按钮 -> 删除API

	var menuApis []models.SysMenuApi

	// 主菜单关联列表查询API
	if len(menus) > 0 && len(apis) > 0 {
		menuApis = append(menuApis, models.SysMenuApi{
			MenuID: menus[0].ID,
			ApiID:  apis[0].ID, // 列表查询API
		})
	}

	// 新增按钮关联新增API
	if len(menus) > 1 && len(apis) > 1 {
		menuApis = append(menuApis, models.SysMenuApi{
			MenuID: menus[1].ID, // 新增按钮
			ApiID:  apis[1].ID,  // 新增API
		})
	}

	// 编辑按钮关联编辑API
	if len(menus) > 2 && len(apis) > 2 {
		menuApis = append(menuApis, models.SysMenuApi{
			MenuID: menus[2].ID, // 编辑按钮
			ApiID:  apis[2].ID,  // 编辑API
		})
	}

	// 编辑按钮关联查询单条数据API
	if len(menus) > 2 && len(apis) > 4 {
		menuApis = append(menuApis, models.SysMenuApi{
			MenuID: menus[2].ID, // 编辑按钮
			ApiID:  apis[4].ID,  // 查询单条数据API
		})
	}

	// 删除按钮关联删除API
	if len(menus) > 3 && len(apis) > 3 {
		menuApis = append(menuApis, models.SysMenuApi{
			MenuID: menus[3].ID, // 删除按钮
			ApiID:  apis[3].ID,  // 删除API
		})
	}

	return menuApis
}

// GetTableComment 根据数据库和表名获取表的注释
func (cgs *CodeGenService) GetTableComment(database, table string) (tableComment string, err error) {
	if database == "" {
		err = fmt.Errorf("数据库名称不能为空")
		return

	}

	if table == "" {
		err = fmt.Errorf("表名不能为空")
		return
	}
	tableComment = table
	// 获取数据库连接
	dbType := app.ConfigYml.GetString("gormv2.usedbtype")
	var db *gorm.DB

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
		return
	}

	// 获取原生数据库连接
	sqlDB, err := db.DB()
	if err != nil {
		return
	}

	// 根据数据库类型执行不同的查询
	switch dbType {
	case "mysql":
		// MySQL通过information_schema.TABLES获取表注释
		row := sqlDB.QueryRow(`
			SELECT TABLE_COMMENT 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?`, database, table)
		err = row.Scan(&tableComment)
		if err != nil {
			if err == sql.ErrNoRows {
				err = fmt.Errorf("表 %s 在数据库 %s 中未找到", table, database)
			} else {
				err = fmt.Errorf("查询表注释失败: %v", err)
			}
			return
		}
	case "postgresql":
		// PostgreSQL通过pg_class和pg_namespace获取表注释
		row := sqlDB.QueryRow(`
			SELECT obj_description(c.oid) 
			FROM pg_class c 
			JOIN pg_namespace n ON n.oid = c.relnamespace 
			WHERE n.nspname = $1 AND c.relname = $2`, "public", table)
		err = row.Scan(&tableComment)
		if err != nil {
			if err == sql.ErrNoRows {
				err = fmt.Errorf("表 %s 在数据库 %s 中未找到", table, database)
			} else {
				err = fmt.Errorf("查询表注释失败: %v", err)
			}
			return
		}
	case "sqlserver":
		// SQL Server通过sys.extended_properties获取表注释
		row := sqlDB.QueryRow(`
			SELECT ISNULL(ep.value, '') 
			FROM sys.tables t 
			LEFT JOIN sys.schemas s ON t.schema_id = s.schema_id 
			LEFT JOIN sys.extended_properties ep ON ep.major_id = t.object_id AND ep.minor_id = 0 AND ep.name = 'MS_Description'
			WHERE s.name = 'dbo' AND t.name = ?`, table)
		err = row.Scan(&tableComment)
		if err != nil {
			if err == sql.ErrNoRows {
				err = fmt.Errorf("表 %s 在数据库 %s 中未找到", table, database)
			} else {
				err = fmt.Errorf("查询表注释失败: %v", err)
			}
			return
		}
	default:
		err = fmt.Errorf("不支持的数据库类型")
		return
	}

	return tableComment, nil
}
