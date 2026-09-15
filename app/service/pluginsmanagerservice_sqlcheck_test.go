package service

import (
	"archive/zip"
	"bytes"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

// createTestSQLZip 构造内存zip用于测试readDatabaseSQLStatements
func createTestSQLZip(t *testing.T, files map[string]string) *zip.Reader {
	var buf bytes.Buffer
	zw := zip.NewWriter(&buf)
	for name, content := range files {
		w, err := zw.Create(name)
		assert.NoError(t, err)
		_, err = w.Write([]byte(content))
		assert.NoError(t, err)
	}
	assert.NoError(t, zw.Close())
	zr, err := zip.NewReader(bytes.NewReader(buf.Bytes()), int64(buf.Len()))
	assert.NoError(t, err)
	return zr
}

func TestScanDangerousSQL(t *testing.T) {
	cases := []struct {
		name       string
		statements []string
		wantCount  int
		wantFirst  string // 首条命中的关键字（为空表示不应命中）
	}{
		{
			name: "正常插件语句不告警",
			statements: []string{
				"CREATE TABLE plu_goods (id bigint PRIMARY KEY, name varchar(64))",
				"INSERT INTO plu_goods (name) VALUES ('上衣')",
				"CREATE INDEX idx_plu_goods_name ON plu_goods (name)",
			},
			wantCount: 0,
		},
		{
			name: "DROP语句告警",
			statements: []string{
				"DROP TABLE plu_goods",
			},
			wantCount: 1,
			wantFirst: "DROP",
		},
		{
			name: "TRUNCATE语句告警",
			statements: []string{
				"TRUNCATE TABLE plu_goods",
			},
			wantCount: 1,
			wantFirst: "TRUNCATE",
		},
		{
			name: "DELETE语句告警",
			statements: []string{
				"DELETE FROM plu_goods WHERE id = 1",
			},
			wantCount: 1,
			wantFirst: "DELETE",
		},
		{
			name: "UPDATE语句告警",
			statements: []string{
				"UPDATE plu_goods SET price = 1 WHERE id = 1",
			},
			wantCount: 1,
			wantFirst: "UPDATE",
		},
		{
			name: "ALTER语句告警",
			statements: []string{
				"ALTER TABLE plu_goods ADD COLUMN stock int",
			},
			wantCount: 1,
			wantFirst: "ALTER",
		},
		{
			name: "SET语句告警",
			statements: []string{
				"SET GLOBAL max_connections = 1",
			},
			wantCount: 1,
			wantFirst: "SET",
		},
		{
			name: "INSERT写系统表告警",
			statements: []string{
				"INSERT INTO sys_users (username, password) VALUES ('backdoor', 'x')",
			},
			wantCount: 1,
			wantFirst: "SYS_USERS",
		},
		{
			name: "INSERT写casbin_rule告警",
			statements: []string{
				"INSERT INTO casbin_rule (ptype, v0, v1) VALUES ('p', 'admin', '/api/*')",
			},
			wantCount: 1,
			wantFirst: "CASBIN_RULE",
		},
		{
			name: "UPDATE系统表按首词告警",
			statements: []string{
				"UPDATE sys_users SET password = 'newpass'",
			},
			wantCount: 1,
			wantFirst: "UPDATE",
		},
		{
			name: "CREATE USER告警",
			statements: []string{
				"CREATE USER 'evil'@'%' IDENTIFIED BY 'pass'",
			},
			wantCount: 1,
			wantFirst: "CREATE USER",
		},
		{
			name: "CREATE DATABASE告警",
			statements: []string{
				"CREATE DATABASE evil_db",
			},
			wantCount: 1,
			wantFirst: "CREATE DATABASE",
		},
		{
			name: "OUTFILE文件读写告警",
			statements: []string{
				"SELECT * FROM plu_goods INTO OUTFILE '/tmp/data.txt'",
			},
			wantCount: 1,
			wantFirst: "OUTFILE",
		},
		{
			name: "LOAD_FILE告警",
			statements: []string{
				"INSERT INTO plu_goods (name) VALUES (LOAD_FILE('/etc/passwd'))",
			},
			wantCount: 1,
			wantFirst: "LOAD_FILE",
		},
		{
			name: "注释中的关键字不误报",
			statements: []string{
				"-- drop table sys_users\nINSERT INTO plu_goods (name) VALUES ('a')",
				"/* update sys_users set password */\nINSERT INTO plu_goods (name) VALUES ('b')",
			},
			wantCount: 0,
		},
		{
			name: "字符串字面量中的关键字不误报",
			statements: []string{
				"INSERT INTO plu_goods (name) VALUES ('please delete me and drop everything')",
			},
			wantCount: 0,
		},
		{
			name: "混合语句仅危险句命中且序号正确",
			statements: []string{
				"CREATE TABLE plu_goods (id bigint)",
				"DROP TABLE plu_goods",
				"INSERT INTO plu_goods (name) VALUES ('a')",
				"TRUNCATE TABLE plu_goods",
			},
			wantCount: 2,
			wantFirst: "DROP",
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := scanDangerousSQL(tc.statements)
			assert.Len(t, got, tc.wantCount)
			if tc.wantFirst != "" {
				assert.Equal(t, tc.wantFirst, got[0].Keyword)
			}
		})
	}

	// 序号校验：混合语句中第一条危险语句应为第2句
	got := scanDangerousSQL([]string{
		"CREATE TABLE plu_goods (id bigint)",
		"DROP TABLE plu_goods",
	})
	assert.Equal(t, 2, got[0].Index)

	// 截断校验：超长语句预览应截断
	longStmt := "DROP TABLE plu_goods -- " + strings.Repeat("x", 500)
	got = scanDangerousSQL([]string{longStmt})
	assert.Len(t, got, 1)
	assert.LessOrEqual(t, len([]rune(got[0].Statement)), maxDangerousSQLPreview+3)
	assert.True(t, strings.HasSuffix(got[0].Statement, "..."))
}

func TestReadDatabaseSQLStatements(t *testing.T) {
	t.Run("zip中无database.sql返回nil", func(t *testing.T) {
		zr := createTestSQLZip(t, map[string]string{"plugin.json": "{}"})
		stmts, err := readDatabaseSQLStatements(zr)
		assert.NoError(t, err)
		assert.Nil(t, stmts)
	})

	t.Run("读取并分句database.sql", func(t *testing.T) {
		zr := createTestSQLZip(t, map[string]string{
			"database.sql": "CREATE TABLE plu_goods (id bigint);\nINSERT INTO plu_goods (name) VALUES ('a');",
		})
		stmts, err := readDatabaseSQLStatements(zr)
		assert.NoError(t, err)
		assert.Len(t, stmts, 2)
		assert.Equal(t, "CREATE TABLE plu_goods (id bigint)", stmts[0])
	})
}

func TestStripSQLCommentsAndLiterals(t *testing.T) {
	cases := []struct {
		name  string
		input string
		want  string
	}{
		{"行注释被剥离", "INSERT INTO t -- drop table x\nVALUES (1)", "INSERT INTO t \nVALUES (1)"},
		{"块注释被剥离", "INSERT /* delete */ INTO t VALUES (1)", "INSERT   INTO t VALUES (1)"},
		{"单引号字面量内容被剥离", "INSERT INTO t VALUES ('delete from sys_users')", "INSERT INTO t VALUES ( )"},
		{"双引号字面量内容被剥离", `INSERT INTO t VALUES ("update")`, "INSERT INTO t VALUES ( )"},
		{"反引号标识符保留定界占位", "SELECT `drop` FROM t", "SELECT   FROM t"},
		{"转义单引号不截断", `INSERT INTO t VALUES ('it''s ok; drop')`, "INSERT INTO t VALUES ( )"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.want, stripSQLCommentsAndLiterals(tc.input))
		})
	}
}
