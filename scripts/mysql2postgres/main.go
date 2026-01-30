package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

// MySQL 到 PostgreSQL 类型映射
var typeMap = map[string]string{
	"int(11)":        "INTEGER",
	"int(10)":        "INTEGER",
	"int":            "INTEGER",
	"bigint(20)":     "BIGINT",
	"bigint":         "BIGINT",
	"tinyint(1)":     "SMALLINT",
	"tinyint(3)":     "SMALLINT",
	"tinyint(4)":     "SMALLINT",
	"tinyint":        "SMALLINT",
	"smallint(6)":    "SMALLINT",
	"smallint":       "SMALLINT",
	"mediumint":      "INTEGER",
	"decimal":        "NUMERIC",
	"decimal(%d,%d)": "NUMERIC(%d,%d)",
	"numeric":        "NUMERIC",
	"float":          "REAL",
	"double":         "DOUBLE PRECISION",
	"char":           "CHAR",
	"varchar(50)":    "VARCHAR(50)",
	"varchar(100)":   "VARCHAR(100)",
	"varchar(255)":   "VARCHAR(255)",
	"varchar(500)":   "VARCHAR(500)",
	"varchar(1000)":  "VARCHAR(1000)",
	"varchar":        "VARCHAR",
	"text":           "TEXT",
	"mediumtext":     "TEXT",
	"longtext":       "TEXT",
	"datetime":       "TIMESTAMP",
	"datetime(3)":    "TIMESTAMP(3)",
	"datetime(6)":    "TIMESTAMP(6)",
	"timestamp":      "TIMESTAMP",
	"timestamp(3)":   "TIMESTAMP(3)",
	"timestamp(6)":   "TIMESTAMP(6)",
	"date":           "DATE",
	"time":           "TIME",
	"year":           "INTEGER",
	"boolean":        "BOOLEAN",
	"bool":           "BOOLEAN",
	"json":           "JSON",
	"enum":           "VARCHAR(255)",
	"set":            "VARCHAR(255)",
	"binary":         "BYTEA",
	"varbinary":      "BYTEA",
	"blob":           "BYTEA",
	"mediumblob":     "BYTEA",
	"longblob":       "BYTEA",
}

// 表信息结构
type TableInfo struct {
	Name                 string
	Columns              []ColumnInfo
	Comments             map[string]string // 列注释
	TableComment         string
	AutoIncrementColumns []string
	AutoIncrementMax     map[string]int64 // 列名 -> 最大ID值
	Indexes              []IndexInfo
}

// 列信息
type ColumnInfo struct {
	Name      string
	Type      string
	IsPrimary bool
	IsAutoInc bool
	NotNull   bool
	Default   string
}

// 索引信息
type IndexInfo struct {
	Name     string
	Columns  []string
	IsUnique bool
}

// 转换器
type Converter struct {
	inputFile    string
	outputFile   string
	tables       map[string]*TableInfo
	currentTable string
	hasData      map[string]bool // 记录表是否有数据插入
}

func NewConverter(input, output string) *Converter {
	return &Converter{
		inputFile:  input,
		outputFile: output,
		tables:     make(map[string]*TableInfo),
		hasData:    make(map[string]bool),
	}
}

// 主函数
func main() {
	inputFile := flag.String("input", "../../resource/database/gin-fast-tenant.sql", "MySQL SQL 文件路径")
	outputFile := flag.String("output", "../../resource/database/postgresql_converted.sql", "PostgreSQL SQL 输出文件路径（默认在输入文件名后加 _pg.sql）")
	flag.Parse()

	if *inputFile == "" {
		fmt.Println("请指定输入文件路径: -input <path>")
		os.Exit(1)
	}

	if *outputFile == "" {
		// 默认输出文件名：在输入文件名后加 _pg.sql
		*outputFile = strings.TrimSuffix(*inputFile, ".sql") + "_pg.sql"
	}

	converter := NewConverter(*inputFile, *outputFile)
	if err := converter.Convert(); err != nil {
		fmt.Printf("转换失败: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("转换完成! 输出文件: %s\n", *outputFile)
}

// 转换主函数
func (c *Converter) Convert() error {
	// 读取输入文件
	inputContent, err := os.ReadFile(c.inputFile)
	if err != nil {
		return fmt.Errorf("读取输入文件失败: %w", err)
	}

	// 创建输出文件
	outputFile, err := os.Create(c.outputFile)
	if err != nil {
		return fmt.Errorf("创建输出文件失败: %w", err)
	}
	defer outputFile.Close()

	writer := bufio.NewWriter(outputFile)
	defer writer.Flush()

	// 写入 PostgreSQL 头部
	writer.WriteString("-- PostgreSQL SQL 转换文件\n")
	writer.WriteString("-- 由 MySQL SQL 转换而来\n\n")

	// 禁止外键检查和通知消息，减少干扰
	writer.WriteString("SET session_replication_role = replica;\n")
	writer.WriteString("SET client_min_messages TO WARNING;\n\n")

	// 逐行处理
	lines := strings.Split(string(inputContent), "\n")
	var inCreateTable bool
	var createTableLines []string
	var tableName string
	var inInsert bool
	var insertLines []string
	var currentInsertTable string // 当前INSERT语句的表名

	for _, line := range lines {
		trimmedLine := strings.TrimSpace(line)

		// 跳过注释行（保留部分）
		if strings.HasPrefix(trimmedLine, "/*") {
			// 处理多行注释
			if !strings.Contains(trimmedLine, "*/") {
				continue
			}
		}
		if strings.HasPrefix(trimmedLine, "--") {
			// 保留有用的注释
			if strings.Contains(trimmedLine, "Table structure") || strings.Contains(trimmedLine, "Records of") {
				writer.WriteString(line + "\n")
			}
			continue
		}

		// 处理 SET FOREIGN_KEY_CHECKS
		if strings.Contains(trimmedLine, "SET FOREIGN_KEY_CHECKS") {
			continue
		}

		// 处理 DROP TABLE
		if strings.HasPrefix(trimmedLine, "DROP TABLE IF EXISTS") {
			tableName = extractTableName(trimmedLine)
			// 在PostgreSQL中，我们将在后面统一DROP TABLE
			// 这里不写入，避免表不存在时的NOTICE
			continue
		}

		// 处理 CREATE TABLE 开始
		if strings.HasPrefix(trimmedLine, "CREATE TABLE") {
			inCreateTable = true
			createTableLines = []string{line}
			tableName = extractTableName(trimmedLine)
			c.currentTable = tableName
			c.tables[tableName] = &TableInfo{
				Name:     tableName,
				Comments: make(map[string]string),
			}
			c.hasData[tableName] = false
			continue
		}

		// 处理 CREATE TABLE 内容
		if inCreateTable {
			if strings.Contains(trimmedLine, "ENGINE=") {
				// CREATE TABLE 结束
				inCreateTable = false
				c.processCreateTable(writer, tableName, createTableLines)
				createTableLines = nil
				continue
			}
			createTableLines = append(createTableLines, line)
			continue
		}

		// 处理 INSERT 语句开始
		if strings.HasPrefix(trimmedLine, "INSERT INTO") {
			// 如果已经在处理 INSERT 语句，先处理完之前的
			if inInsert && len(insertLines) > 0 {
				c.processInsert(writer, insertLines, currentInsertTable)
			}
			inInsert = true
			insertLines = []string{line}
			// 提取INSERT语句的表名
			currentInsertTable = extractInsertTableName(trimmedLine)
			c.hasData[currentInsertTable] = true
			continue
		}

		// 处理 INSERT 语句内容（可能多行）
		if inInsert {
			// 检查是否 INSERT 语句结束（以分号结尾）
			if strings.HasSuffix(trimmedLine, ";") {
				insertLines = append(insertLines, line)
				c.processInsert(writer, insertLines, currentInsertTable)
				inInsert = false
				insertLines = nil
				continue
			}
			// 如果是空行且已经收集了 INSERT 内容，说明 INSERT 结束
			if trimmedLine == "" && len(insertLines) > 0 {
				c.processInsert(writer, insertLines, currentInsertTable)
				inInsert = false
				insertLines = nil
				continue
			}
			insertLines = append(insertLines, line)
			continue
		}
	}

	// 写入索引（在数据插入之后）
	c.writeIndexes(writer)

	// 写入序列值设置（在数据插入之后）
	c.writeSequences(writer)

	// 恢复外键检查
	writer.WriteString("\nSET session_replication_role = DEFAULT;\n")
	writer.WriteString("SET client_min_messages TO NOTICE;\n")

	return nil
}

// 处理 CREATE TABLE
func (c *Converter) processCreateTable(writer *bufio.Writer, tableName string, lines []string) {
	tableInfo := c.tables[tableName]

	// 提取表注释
	for _, line := range lines {
		if strings.Contains(line, "COMMENT='") {
			re := regexp.MustCompile(`COMMENT='([^']*)'`)
			matches := re.FindStringSubmatch(line)
			if len(matches) > 1 {
				tableInfo.TableComment = matches[1]
			}
		}
	}

	// 开始 CREATE TABLE
	writer.WriteString(fmt.Sprintf("DROP TABLE IF EXISTS %s;\n", tableName))
	writer.WriteString(fmt.Sprintf("CREATE TABLE %s (\n", tableName))

	// 处理列定义
	var columnDefs []string
	for _, line := range lines {
		trimmedLine := strings.TrimSpace(line)

		// 跳过开头的 CREATE TABLE 和结尾的 ENGINE
		if strings.HasPrefix(trimmedLine, "CREATE TABLE") || strings.Contains(trimmedLine, "ENGINE=") {
			continue
		}

		// 移除反引号
		line = strings.ReplaceAll(line, "`", "")

		// 跳过空行和注释
		if trimmedLine == "" || strings.HasPrefix(trimmedLine, "--") {
			continue
		}

		// 处理主键定义
		if strings.HasPrefix(trimmedLine, "PRIMARY KEY") {
			pkLine := c.convertPrimaryKey(trimmedLine)
			columnDefs = append(columnDefs, "    "+pkLine)
			continue
		}

		// 处理索引定义（KEY, UNIQUE KEY）
		if strings.HasPrefix(trimmedLine, "KEY ") || strings.HasPrefix(trimmedLine, "UNIQUE KEY ") {
			indexInfo := c.parseIndex(trimmedLine)
			if indexInfo != nil {
				tableInfo.Indexes = append(tableInfo.Indexes, *indexInfo)
			}
			continue
		}

		// 处理列定义
		if strings.Contains(trimmedLine, "`") || !strings.HasPrefix(trimmedLine, ")") {
			colDef := c.convertColumn(trimmedLine, tableInfo)
			if colDef != "" {
				columnDefs = append(columnDefs, "    "+colDef)
			}
		}
	}

	// 写入列定义
	for i, def := range columnDefs {
		if i == len(columnDefs)-1 {
			writer.WriteString(def + "\n")
		} else {
			writer.WriteString(def + ",\n")
		}
	}

	writer.WriteString(");\n\n")

	// 写入表注释
	if tableInfo.TableComment != "" {
		writer.WriteString(fmt.Sprintf("COMMENT ON TABLE %s IS '%s';\n", tableName, tableInfo.TableComment))
	}

	// 写入列注释
	for colName, comment := range tableInfo.Comments {
		if comment != "" {
			writer.WriteString(fmt.Sprintf("COMMENT ON COLUMN %s.%s IS '%s';\n", tableName, colName, comment))
		}
	}
	writer.WriteString("\n")
}

// 转换列定义
func (c *Converter) convertColumn(line string, tableInfo *TableInfo) string {
	// 移除反引号
	line = strings.ReplaceAll(line, "`", "")
	line = strings.TrimSpace(line)

	// 提取列名
	parts := strings.Fields(line)
	if len(parts) < 2 {
		return ""
	}

	colName := parts[0]

	// 提取注释
	var comment string
	if strings.Contains(line, "COMMENT") {
		re := regexp.MustCompile(`COMMENT\s+'([^']*)'`)
		matches := re.FindStringSubmatch(line)
		if len(matches) > 1 {
			comment = matches[1]
		}
		tableInfo.Comments[colName] = comment
	}

	// 声明 colType 变量
	var colType string

	// 首先处理 varchar 类型（带长度）
	if strings.Contains(line, "varchar(") {
		re := regexp.MustCompile(`varchar\((\d+)\)`)
		matches := re.FindStringSubmatch(line)
		if len(matches) > 1 {
			colType = fmt.Sprintf("VARCHAR(%s)", matches[1])
		} else {
			colType = "VARCHAR"
		}
	} else {
		// 转换数据类型
		colType = "TEXT" // 默认类型
		// 首先尝试精确匹配类型（带括号）
		for mysqlType, pgType := range typeMap {
			// 使用正则表达式匹配单词边界，避免部分匹配
			pattern := `\b` + regexp.QuoteMeta(mysqlType) + `\b`
			matched, _ := regexp.MatchString(pattern, line)
			if matched {
				colType = pgType
				// 处理带占位符的类型，如 decimal(%d,%d)
				if strings.Contains(pgType, "%d") && strings.Contains(mysqlType, "%d") {
					// 提取括号内的参数
					re := regexp.MustCompile(`(\w+)\((\d+),(\d+)\)`)
					matches := re.FindStringSubmatch(line)
					if len(matches) > 3 {
						colType = fmt.Sprintf(pgType, matches[2], matches[3])
					}
				}
				break
			}
		}
	}

	// 检查是否为自增
	isAutoInc := strings.Contains(line, "AUTO_INCREMENT")
	if isAutoInc {
		// 根据原始类型选择 SERIAL 类型
		// 检测原始类型
		originalType := ""
		for mysqlType := range typeMap {
			pattern := `\b` + regexp.QuoteMeta(mysqlType) + `\b`
			matched, _ := regexp.MatchString(pattern, line)
			if matched {
				originalType = mysqlType
				break
			}
		}

		// 根据原始类型选择 SERIAL 类型
		if strings.Contains(originalType, "bigint") {
			colType = "BIGSERIAL"
		} else if strings.Contains(originalType, "smallint") || strings.Contains(originalType, "tinyint") {
			colType = "SMALLSERIAL"
		} else {
			colType = "SERIAL"
		}

		tableInfo.AutoIncrementColumns = append(tableInfo.AutoIncrementColumns, colName)

		// 初始化AutoIncrementMax映射
		if tableInfo.AutoIncrementMax == nil {
			tableInfo.AutoIncrementMax = make(map[string]int64)
		}
		// 初始化最大值为0
		tableInfo.AutoIncrementMax[colName] = 0
	}

	// 检查是否为主键
	isPrimary := strings.Contains(line, "PRIMARY KEY")
	if isPrimary {
		tableInfo.Columns = append(tableInfo.Columns, ColumnInfo{
			Name:      colName,
			Type:      colType,
			IsPrimary: true,
			IsAutoInc: isAutoInc,
		})
		return fmt.Sprintf("%s %s PRIMARY KEY", colName, colType)
	}

	// 检查 NOT NULL
	notNull := strings.Contains(line, "NOT NULL")

	// 检查 DEFAULT
	defaultValue := ""
	if strings.Contains(line, "DEFAULT") && !strings.Contains(line, "DEFAULT NULL") {
		// 使用正则表达式匹配 DEFAULT 值，支持带引号的字符串、数字、函数等
		// 模式1: DEFAULT 'string' (可能包含转义单引号)
		// 模式2: DEFAULT number
		// 模式3: DEFAULT function()
		// 模式4: DEFAULT NULL (已排除)
		re := regexp.MustCompile(`DEFAULT\s+((?:'[^']*(?:''[^']*)*')|\d+(?:\.\d+)?|true|false|NULL|CURRENT_TIMESTAMP|NOW\(\)|CURRENT_DATE\(\)|[a-zA-Z_][a-zA-Z0-9_]*\(\)?)`)
		matches := re.FindStringSubmatch(line)
		if len(matches) > 1 {
			defaultValue = matches[1]

			// 处理字符串默认值：保持单引号，但转义单引号
			if strings.HasPrefix(defaultValue, "'") && strings.HasSuffix(defaultValue, "'") {
				// 替换MySQL转义单引号 (\') 为PostgreSQL转义单引号 ('')
				defaultValue = strings.ReplaceAll(defaultValue, "\\'", "''")
			} else if strings.HasPrefix(defaultValue, "'") {
				// 不完整的字符串，保持原样
			} else {
				// 数字、布尔值或函数：直接使用
				// 转换MySQL函数到PostgreSQL等效函数
				if defaultValue == "NOW()" {
					defaultValue = "CURRENT_TIMESTAMP"
				} else if defaultValue == "CURRENT_DATE()" {
					defaultValue = "CURRENT_DATE"
				}
			}
		}
	}

	// 构建列定义
	result := colName + " " + colType
	if notNull {
		result += " NOT NULL"
	}
	if defaultValue != "" {
		result += " DEFAULT " + defaultValue
	}

	tableInfo.Columns = append(tableInfo.Columns, ColumnInfo{
		Name:      colName,
		Type:      colType,
		IsPrimary: isPrimary,
		IsAutoInc: isAutoInc,
		NotNull:   notNull,
		Default:   defaultValue,
	})

	return result
}

// 转换主键定义
func (c *Converter) convertPrimaryKey(line string) string {
	// 移除 USING BTREE
	line = strings.ReplaceAll(line, "USING BTREE", "")
	line = strings.ReplaceAll(line, "`", "")
	line = strings.TrimSpace(line)
	// 移除行尾的逗号（如果有）
	line = strings.TrimSuffix(line, ",")
	return strings.TrimSpace(line)
}

// 解析索引
func (c *Converter) parseIndex(line string) *IndexInfo {
	// 移除反引号
	line = strings.ReplaceAll(line, "`", "")
	line = strings.TrimSpace(line)

	var indexName string
	var columns []string
	isUnique := false

	// 匹配 UNIQUE KEY 或 KEY
	// 模式: UNIQUE KEY index_name (col1, col2) 或 KEY index_name (col1, col2)
	// 使用更灵活的正则表达式处理可能的空格和列名
	re := regexp.MustCompile(`(UNIQUE KEY|KEY)\s+(\w+)\s*\(([^)]+)\)`)
	matches := re.FindStringSubmatch(line)
	if len(matches) > 3 {
		isUnique = matches[1] == "UNIQUE KEY"
		indexName = matches[2]
		columnStr := matches[3]
		// 分割列名，处理逗号分隔
		columns = strings.Split(columnStr, ",")
		for i := range columns {
			columns[i] = strings.TrimSpace(columns[i])
			// 移除可能的长度说明符，如 col(10)
			if idx := strings.Index(columns[i], "("); idx != -1 {
				columns[i] = columns[i][:idx]
			}
		}
	}

	if indexName != "" && len(columns) > 0 {
		return &IndexInfo{
			Name:     indexName,
			Columns:  columns,
			IsUnique: isUnique,
		}
	}

	return nil
}

// 处理 INSERT 语句（支持多行）
func (c *Converter) processInsert(writer *bufio.Writer, lines []string, tableName string) {
	// 合并多行为一行
	insertSQL := strings.Join(lines, " ")

	// 移除反引号
	insertSQL = strings.ReplaceAll(insertSQL, "`", "")

	// 处理 NULL 值 - 使用正则表达式全面替换小写 null 为大写 NULL
	// 匹配单词边界 null 单词边界，避免匹配到字符串中的 null
	reNull := regexp.MustCompile(`\bnull\b`)
	insertSQL = reNull.ReplaceAllString(insertSQL, "NULL")

	// 处理字符串中的单引号转义
	insertSQL = strings.ReplaceAll(insertSQL, "\\'", "''")
	// 处理其他常见转义序列
	insertSQL = strings.ReplaceAll(insertSQL, "\\\"", "\"")
	insertSQL = strings.ReplaceAll(insertSQL, "\\n", "\n")
	insertSQL = strings.ReplaceAll(insertSQL, "\\r", "\r")
	insertSQL = strings.ReplaceAll(insertSQL, "\\t", "\t")
	insertSQL = strings.ReplaceAll(insertSQL, "\\\\", "\\")

	// 移除行尾的分号（如果存在） - 先修剪空格确保分号在末尾
	insertSQL = strings.TrimSpace(insertSQL)
	insertSQL = strings.TrimSuffix(insertSQL, ";")

	// 确保以分号结尾
	insertSQL += ";"

	// 写入 INSERT 语句
	writer.WriteString(insertSQL + "\n")

	// 提取并更新自增列的最大值
	c.extractAndUpdateAutoIncrementValues(insertSQL, tableName)
}

// 从INSERT语句中提取自增列的值
func (c *Converter) extractAndUpdateAutoIncrementValues(insertSQL string, tableName string) {
	tableInfo, exists := c.tables[tableName]
	if !exists || len(tableInfo.AutoIncrementColumns) == 0 {
		return
	}

	// 使用正则表达式匹配 INSERT 语句中的 VALUES 部分
	// 支持两种格式：
	// 1. INSERT INTO table (col1, col2, ...) VALUES (val1, val2, ...)
	// 2. INSERT INTO table VALUES (val1, val2, ...)
	re := regexp.MustCompile(`(?i)INSERT INTO\s+\w+\s*(?:\([^)]+\))?\s*VALUES\s*\(([^)]+)\)`)
	matches := re.FindStringSubmatch(insertSQL)

	if len(matches) < 2 {
		return
	}

	valuesStr := matches[1]

	// 解析值
	values := c.parseValues(valuesStr)

	// 初始化AutoIncrementMax映射
	if tableInfo.AutoIncrementMax == nil {
		tableInfo.AutoIncrementMax = make(map[string]int64)
	}

	// 简化处理：假设自增列是第一个列
	// 对于大多数MySQL表，自增ID通常是第一列
	if len(values) > 0 && len(tableInfo.AutoIncrementColumns) > 0 {
		autoCol := tableInfo.AutoIncrementColumns[0]
		valStr := values[0]
		// 去除可能的引号
		valStr = strings.Trim(valStr, "'\"")
		if val, err := strconv.ParseInt(valStr, 10, 64); err == nil {
			if val > tableInfo.AutoIncrementMax[autoCol] {
				tableInfo.AutoIncrementMax[autoCol] = val
			}
		}
	}
}

// 解析VALUES子句中的值
func (c *Converter) parseValues(valuesStr string) []string {
	var values []string
	var currentValue strings.Builder
	inQuotes := false
	quoteChar := rune(0)

	for i := 0; i < len(valuesStr); i++ {
		ch := rune(valuesStr[i])

		if ch == '\\' && i+1 < len(valuesStr) {
			// 处理转义字符
			currentValue.WriteRune(ch)
			i++
			currentValue.WriteRune(rune(valuesStr[i]))
			continue
		}

		if !inQuotes && (ch == '\'' || ch == '"') {
			inQuotes = true
			quoteChar = ch
			currentValue.WriteRune(ch)
			continue
		}

		if inQuotes && ch == quoteChar {
			// 检查是否转义引号
			if i+1 < len(valuesStr) && rune(valuesStr[i+1]) == quoteChar {
				currentValue.WriteRune(ch)
				i++
				currentValue.WriteRune(rune(valuesStr[i]))
				continue
			}
			inQuotes = false
			currentValue.WriteRune(ch)
			continue
		}

		if !inQuotes && ch == ',' {
			values = append(values, strings.TrimSpace(currentValue.String()))
			currentValue.Reset()
			continue
		}

		currentValue.WriteRune(ch)
	}

	// 添加最后一个值
	if currentValue.Len() > 0 {
		values = append(values, strings.TrimSpace(currentValue.String()))
	}

	return values
}

// 写入序列值设置
func (c *Converter) writeSequences(writer *bufio.Writer) {
	if len(c.tables) == 0 {
		return
	}

	writer.WriteString("\n-- 设置序列值\n")

	// 收集所有表的自增列信息
	for tableName, tableInfo := range c.tables {
		for _, columnName := range tableInfo.AutoIncrementColumns {
			// PostgreSQL中SERIAL类型创建的序列命名规则为：表名_列名_seq
			seqName := fmt.Sprintf("%s_%s_seq", tableName, columnName)

			// 获取收集到的最大值
			maxVal := int64(0)
			if tableInfo.AutoIncrementMax != nil {
				if val, exists := tableInfo.AutoIncrementMax[columnName]; exists {
					maxVal = val
				}
			}

			// 如果表有数据且有最大值，设置序列值
			if c.hasData[tableName] && maxVal > 0 {
				setSeqSQL := fmt.Sprintf("SELECT setval('%s', %d, true);\n", seqName, maxVal)
				writer.WriteString(setSeqSQL)
			} else {
				// 对于空表，不设置序列值，让序列保持默认起始值1
				// 这样可以避免"value 0 is out of bounds"错误
				writer.WriteString(fmt.Sprintf("-- 表 %s 的列 %s 没有数据，序列 %s 将保持默认起始值\n",
					tableName, columnName, seqName))
			}
		}
	}

	writer.WriteString("\n")
}

// 写入索引
func (c *Converter) writeIndexes(writer *bufio.Writer) {
	if len(c.tables) == 0 {
		return
	}

	writer.WriteString("\n-- 创建索引\n")

	for tableName, tableInfo := range c.tables {
		for _, index := range tableInfo.Indexes {
			if index.IsUnique {
				writer.WriteString(fmt.Sprintf("CREATE UNIQUE INDEX %s ON %s (%s);\n",
					index.Name, tableName, strings.Join(index.Columns, ", ")))
			} else {
				writer.WriteString(fmt.Sprintf("CREATE INDEX %s ON %s (%s);\n",
					index.Name, tableName, strings.Join(index.Columns, ", ")))
			}
		}
	}
}

// 提取表名（用于DROP TABLE和CREATE TABLE）
func extractTableName(line string) string {
	line = strings.ReplaceAll(line, "`", "")
	line = strings.TrimSpace(line)

	// 匹配 DROP TABLE IF EXISTS table_name 或 CREATE TABLE table_name
	// 使用非贪婪匹配直到遇到空格、分号或左括号
	re := regexp.MustCompile(`(?:DROP TABLE IF EXISTS|CREATE TABLE)\s+([^\s;(]+)`)
	matches := re.FindStringSubmatch(line)
	if len(matches) > 1 {
		return matches[1]
	}

	return ""
}

// 提取INSERT语句的表名
func extractInsertTableName(line string) string {
	line = strings.ReplaceAll(line, "`", "")
	line = strings.TrimSpace(line)

	// 匹配 INSERT INTO table_name
	re := regexp.MustCompile(`INSERT INTO\s+([^\s(]+)`)
	matches := re.FindStringSubmatch(line)
	if len(matches) > 1 {
		return matches[1]
	}

	return ""
}
