package controllers

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

// TestCanManageTenantCore 跨租户归属校验纯逻辑（表驱动，覆盖全部分支，不依赖配置/DB）
func TestCanManageTenantCore(t *testing.T) {
	tests := []struct {
		name               string
		skipAuth           bool
		currentTenantID    uint
		multiTenantEnabled bool
		targetTenantID     uint
		want               bool
	}{
		{name: "超管豁免_跨租户放行", skipAuth: true, currentTenantID: 1, multiTenantEnabled: true, targetTenantID: 2, want: true},
		{name: "多租户关闭_放行", skipAuth: false, currentTenantID: 1, multiTenantEnabled: false, targetTenantID: 2, want: true},
		{name: "全局租户用户_放行", skipAuth: false, currentTenantID: 0, multiTenantEnabled: true, targetTenantID: 2, want: true},
		{name: "本租户操作_放行", skipAuth: false, currentTenantID: 3, multiTenantEnabled: true, targetTenantID: 3, want: true},
		{name: "跨租户操作_拒绝", skipAuth: false, currentTenantID: 1, multiTenantEnabled: true, targetTenantID: 2, want: false},
		{name: "租户用户_操作全局租户_拒绝", skipAuth: false, currentTenantID: 1, multiTenantEnabled: true, targetTenantID: 0, want: false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			assert.Equal(t, tt.want, canManageTenant(tt.skipAuth, tt.currentTenantID, tt.multiTenantEnabled, tt.targetTenantID))
		})
	}
}
