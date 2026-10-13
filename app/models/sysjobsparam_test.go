package models

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"gorm.io/driver/mysql"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// dryRunDB 构造不连库的 DryRun gorm 实例，仅用于检查生成的 SQL
func dryRunDB(t *testing.T, dialector gorm.Dialector) *gorm.DB {
	t.Helper()
	db, err := gorm.Open(dialector, &gorm.Config{
		DryRun:               true,
		DisableAutomaticPing: true,
		Logger:               logger.Default.LogMode(logger.Silent),
	})
	assert.NoError(t, err)
	return db
}

// buildSysJobsListSQL 用列表查询条件构建 DryRun SQL
func buildSysJobsListSQL(db *gorm.DB) (string, []interface{}) {
	req := SysJobsListRequest{Group: new(string), Name: new(string)}
	*req.Group = "def"
	*req.Name = "order"
	stmt := db.Session(&gorm.Session{DryRun: true}).
		Model(&SysJobs{}).
		Scopes(req.Handle()).
		Find(&SysJobs{}).Statement
	return stmt.SQL.String(), stmt.Vars
}

// TestNormalizeJobParameters 入库前规范化：空白串存"{}"（JSON列不接受空文档），其余原样
func TestNormalizeJobParameters(t *testing.T) {
	tests := []struct {
		name  string
		input string
		want  string
	}{
		{"空串_存空对象", "", "{}"},
		{"纯空白_存空对象", "  \t ", "{}"},
		{"JSON对象_原样保留", `{"a":1}`, `{"a":1}`},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			assert.Equal(t, tt.want, NormalizeJobParameters(tt.input))
		})
	}
}

// TestSysJobsListGroupReservedWord group 为 SQL 保留字，验证模糊查询条件在各数据库方言下被正确加引号
func TestSysJobsListGroupReservedWord(t *testing.T) {
	t.Run("MySQL方言", func(t *testing.T) {
		db := dryRunDB(t, mysql.New(mysql.Config{
			SkipInitializeWithVersion: true,
			DSN:                       "gorm:gorm@tcp(localhost:9910)/gorm?charset=utf8&parseTime=True",
		}))
		sql, vars := buildSysJobsListSQL(db)
		assert.Contains(t, sql, "`group` LIKE ?")
		assert.Contains(t, vars, "%def%")
	})

	t.Run("PostgreSQL方言", func(t *testing.T) {
		db := dryRunDB(t, postgres.New(postgres.Config{
			DSN: "postgres://gorm:gorm@localhost:9920/gorm?sslmode=disable",
		}))
		sql, vars := buildSysJobsListSQL(db)
		assert.Contains(t, sql, `"group" LIKE`)
		assert.Contains(t, vars, "%def%")
	})
}

// TestParseJobParameters 任务参数仅接受JSON对象或空串（调度器Job.Parameters为map类型）
func TestParseJobParameters(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantErr bool
		wantNil bool
	}{
		{"空串_合法返回nil", "", false, true},
		{"纯空白串_合法返回nil", "   \t\n", false, true},
		{"JSON对象_合法", `{"param1":"value1"}`, false, false},
		{"嵌套对象_合法", `{"a":{"b":1}}`, false, false},
		{"空对象_合法", `{}`, false, false},
		{"null_合法返回nil", "null", false, true},
		{"数字_非法", "123", true, false},
		{"数组_非法", "[1,2]", true, false},
		{"字符串_非法", `"abc"`, true, false},
		{"true_非法", "true", true, false},
		{"纯文本_非法", "abc", true, false},
		{"残缺JSON_非法", `{"a":`, true, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			params, err := ParseJobParameters(tt.input)
			assert.Equal(t, tt.wantErr, err != nil)
			if tt.wantErr {
				assert.Contains(t, err.Error(), "JSON对象")
			}
			if tt.wantNil {
				assert.Nil(t, params)
			} else if !tt.wantErr {
				assert.NotNil(t, params)
			}
		})
	}
}
