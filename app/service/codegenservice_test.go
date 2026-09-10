package service

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestValidateIdentifier(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantErr bool
	}{
		{"合法-字母数字下划线", "gin_fast_tenant", false},
		{"合法-纯字母", "mysql", false},
		{"合法-纯数字开头", "2026db", false},
		{"合法-带连字符的库名", "gin-fast-tenant-plugin-test", false},
		{"合法-带连字符", "gin-fast", false},
		{"空字符串", "", true},
		{"带分号注入", "db;DROP TABLE users", true},
		{"带分号注释注入", "db;--", true},
		{"带空格", "my db", true},
		{"带引号", "db';--", true},
		{"带点号跨库", "db.sys_user", true},
		{"带反引号", "db`", true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := validateIdentifier(tt.input, "数据库名")
			if tt.wantErr {
				assert.Error(t, err, "输入 %q 应校验失败", tt.input)
			} else {
				assert.NoError(t, err, "输入 %q 应校验通过", tt.input)
			}
		})
	}
}
