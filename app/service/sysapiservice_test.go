package service

import (
	"testing"

	"gin-fast/app/models"

	"github.com/stretchr/testify/assert"
)

func TestClassifySyncAction(t *testing.T) {
	item := SyncItem{Path: "/api/users/list", Method: "GET", Title: "用户列表", ApiGroup: "用户管理"}

	cases := []struct {
		name      string
		item      SyncItem
		exist     *models.SysApi
		softExist bool
		overwrite bool
		want      string
	}{
		// 活跃行存在
		{"库中无任何记录-新增", item, nil, false, false, "insert"},
		{"库中无任何记录-新增(overwrite)", item, nil, false, true, "insert"},
		// 活跃行存在、内容一致
		{"活跃行内容一致-跳过", item, &models.SysApi{Title: "用户列表", ApiGroup: "用户管理"}, false, false, "skip"},
		{"活跃行内容一致-跳过(overwrite)", item, &models.SysApi{Title: "用户列表", ApiGroup: "用户管理"}, false, true, "skip"},
		// 活跃行存在、内容有变化
		{"活跃行有变化-不覆盖则跳过", item, &models.SysApi{Title: "旧标题", ApiGroup: "用户管理"}, false, false, "skip"},
		{"活跃行有变化-覆盖则更新", item, &models.SysApi{Title: "旧标题", ApiGroup: "用户管理"}, false, true, "update"},
		{"活跃行分组变化-覆盖则更新", item, &models.SysApi{Title: "用户列表", ApiGroup: "旧分组"}, false, true, "update"},
		// 软删孪生行（无活跃行）
		{"软删孪生行-恢复", item, nil, true, false, "restore"},
		{"软删孪生行-恢复(overwrite)", item, nil, true, true, "restore"},
		// 活跃行与软删行并存（异常存量）：以活跃行判定为准
		{"活跃行优先于软删行", item, &models.SysApi{Title: "用户列表", ApiGroup: "用户管理"}, true, false, "skip"},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := classifySyncAction(tc.item, tc.exist, tc.softExist, tc.overwrite)
			assert.Equal(t, tc.want, got)
		})
	}
}
