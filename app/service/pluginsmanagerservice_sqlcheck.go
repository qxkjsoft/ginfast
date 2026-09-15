package service

import (
	"archive/zip"
	"fmt"
	"io"
	"regexp"
	"strings"
	"unicode"

	"gin-fast/app/models"
)

// maxDangerousSQLCheck 单次导入最多上报的危险语句条数，防止响应体过大
const maxDangerousSQLCheck = 100

// maxDangerousSQLPreview 危险语句预览的最大字符数
const maxDangerousSQLPreview = 200

// dangerousSQLVerbs 首词即危险的SQL动词（破坏性/修改性/权限类语句）
var dangerousSQLVerbs = map[string]string{
	"drop":     "破坏性语句(DROP)",
	"truncate": "清空表数据(TRUNCATE)",
	"delete":   "删除数据(DELETE)",
	"update":   "修改数据(UPDATE)",
	"alter":    "修改表结构(ALTER)",
	"rename":   "重命名对象(RENAME)",
	"grant":    "授权语句(GRANT)",
	"revoke":   "回收权限(REVOKE)",
	"replace":  "替换写入(REPLACE)",
	"call":     "调用存储过程(CALL)",
	"set":      "设置变量(SET)",
	"lock":     "锁定表(LOCK)",
	"kill":     "终止连接/查询(KILL)",
	"shutdown": "关闭数据库(SHUTDOWN)",
}

// dangerousSQLCreateObjects CREATE后接这些对象类型视为危险（CREATE TABLE/INDEX为插件正常语句，不拦）
var dangerousSQLCreateObjects = map[string]string{
	"user":      "创建数据库用户",
	"database":  "创建数据库",
	"schema":    "创建SCHEMA",
	"function":  "创建函数",
	"procedure": "创建存储过程",
	"trigger":   "创建触发器",
	"event":     "创建事件",
}

// dangerousSQLGlobalPatterns 语句任意位置命中即危险的模式
var dangerousSQLGlobalPatterns = []struct {
	re   *regexp.Regexp
	desc string
}{
	{regexp.MustCompile(`(?i)\b(sys_[a-z0-9_]+|casbin_rule)\b`), "涉及系统表，可能篡改框架数据"},
	{regexp.MustCompile(`(?i)\b(outfile|dumpfile|infile|load_file)\b`), "数据库文件读写"},
	{regexp.MustCompile(`(?i)\bload\s+data\b`), "加载数据文件"},
	{regexp.MustCompile(`(?i)\binformation_schema\b`), "访问元数据表"},
}

// stripSQLCommentsAndLiterals 剥离语句中的注释与字符串字面量，仅用于危险关键字检测（不改变执行内容）
func stripSQLCommentsAndLiterals(stmt string) string {
	var b strings.Builder
	b.Grow(len(stmt))
	runes := []rune(stmt)
	n := len(runes)
	i := 0
	for i < n {
		c := runes[i]
		// 行注释 -- ...
		if c == '-' && i+1 < n && runes[i+1] == '-' {
			for i < n && runes[i] != '\n' {
				i++
			}
			continue
		}
		// 块注释 /* ... */
		if c == '/' && i+1 < n && runes[i+1] == '*' {
			i += 2
			for i+1 < n && !(runes[i] == '*' && runes[i+1] == '/') {
				i++
			}
			if i+1 < n {
				i += 2
			}
			b.WriteRune(' ')
			continue
		}
		// 字符串/标识符字面量：跳过内容，仅保留占位空格
		if c == '\'' || c == '"' || c == '`' {
			quote := c
			i++
			for i < n {
				if runes[i] == '\\' && quote != '`' && i+1 < n {
					i += 2
					continue
				}
				if runes[i] == quote {
					// 连续两个单引号是SQL标准的引号转义
					if quote == '\'' && i+1 < n && runes[i+1] == '\'' {
						i += 2
						continue
					}
					break
				}
				i++
			}
			i++ // 跳过收尾定界符
			b.WriteRune(' ')
			continue
		}
		b.WriteRune(c)
		i++
	}
	return b.String()
}

// sqlWords 返回剥离注释/字面量后语句的单词序列（统一转小写，括号视作分隔符）
func sqlWords(cleaned string) []string {
	words := strings.FieldsFunc(cleaned, func(r rune) bool {
		return unicode.IsSpace(r) || r == '('
	})
	for i, w := range words {
		words[i] = strings.ToLower(w)
	}
	return words
}

// newSQLDangerInfo 构造危险语句信息，语句预览超长截断
func newSQLDangerInfo(index int, keyword, reason, statement string) models.SQLDangerInfo {
	preview := strings.TrimSpace(statement)
	r := []rune(preview)
	if len(r) > maxDangerousSQLPreview {
		preview = string(r[:maxDangerousSQLPreview]) + "..."
	}
	return models.SQLDangerInfo{
		Index:     index,
		Keyword:   keyword,
		Reason:    reason,
		Statement: preview,
	}
}

// scanDangerousSQL 检测分句后SQL语句中的危险关键字，返回命中的危险信息（Index为语句序号，从1开始）
func scanDangerousSQL(statements []string) []models.SQLDangerInfo {
	var dangers []models.SQLDangerInfo
	for idx, stmt := range statements {
		if len(dangers) >= maxDangerousSQLCheck {
			break
		}
		cleaned := stripSQLCommentsAndLiterals(stmt)
		if strings.TrimSpace(cleaned) == "" {
			continue
		}
		words := sqlWords(cleaned)

		// 首词为危险动词
		if reason, ok := dangerousSQLVerbs[words[0]]; ok {
			dangers = append(dangers, newSQLDangerInfo(idx+1, strings.ToUpper(words[0]), reason, stmt))
			continue
		}
		// CREATE + 危险对象类型
		if words[0] == "create" && len(words) >= 2 {
			if reason, ok := dangerousSQLCreateObjects[words[1]]; ok {
				dangers = append(dangers, newSQLDangerInfo(idx+1, "CREATE "+strings.ToUpper(words[1]), reason, stmt))
				continue
			}
		}
		// 任意位置的全局敏感模式
		for _, p := range dangerousSQLGlobalPatterns {
			if loc := p.re.FindString(cleaned); loc != "" {
				dangers = append(dangers, newSQLDangerInfo(idx+1, strings.ToUpper(loc), p.desc, stmt))
				break
			}
		}
	}
	return dangers
}

// readDatabaseSQLStatements 读取zip中的database.sql并分句；zip中无该文件时返回nil
func readDatabaseSQLStatements(zipReader *zip.Reader) ([]string, error) {
	for _, file := range zipReader.File {
		if file.Name != "database.sql" {
			continue
		}
		rc, err := file.Open()
		if err != nil {
			return nil, fmt.Errorf("读取database.sql失败: %v", err)
		}
		data, err := io.ReadAll(rc)
		rc.Close()
		if err != nil {
			return nil, fmt.Errorf("读取database.sql内容失败: %v", err)
		}
		return splitSQLStatements(string(data)), nil
	}
	return nil, nil
}
