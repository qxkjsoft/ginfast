package service

import (
	"testing"

	"gin-fast/app/models"

	"github.com/stretchr/testify/assert"
)

func TestClassifySyncAction(t *testing.T) {
	cases := []struct {
		name      string
		exist     *models.SysApi
		softExist bool
		want      string
	}{
		// 活跃行不存在
		{"库中无任何记录-新增", nil, false, "insert"},
		// 活跃行存在：一律跳过，保留库中人工维护的标题/分组
		{"活跃行内容一致-跳过", &models.SysApi{Title: "用户列表", ApiGroup: "用户管理"}, false, "skip"},
		{"活跃行有变化-保留库中值跳过", &models.SysApi{Title: "旧标题", ApiGroup: "用户管理"}, false, "skip"},
		{"活跃行分组变化-保留库中值跳过", &models.SysApi{Title: "用户列表", ApiGroup: "旧分组"}, false, "skip"},
		// 软删孪生行（无活跃行）
		{"软删孪生行-恢复", nil, true, "restore"},
		// 活跃行与软删行并存（异常存量）：以活跃行判定为准
		{"活跃行优先于软删行", &models.SysApi{Title: "用户列表", ApiGroup: "用户管理"}, true, "skip"},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := classifySyncAction(tc.exist, tc.softExist)
			assert.Equal(t, tc.want, got)
		})
	}
}
