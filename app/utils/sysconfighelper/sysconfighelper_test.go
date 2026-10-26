package sysconfighelper

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

// TestItemsCodesUnique items 清单的配置键必须唯一，防止重复补种/覆盖
func TestItemsCodesUnique(t *testing.T) {
	seen := make(map[string]bool, len(items))
	for _, it := range items {
		assert.False(t, seen[it.code], "items 中配置键重复: "+it.code)
		seen[it.code] = true
		assert.Equal(t, it.code, it.code)
	}
	assert.Len(t, seen, len(items))
}

// TestZeroValueFallback 缓存为空（含未知键）时读取返回类型零值，
// 不存在内置默认值——初始值由 config.yml 在启动补种时提供
func TestZeroValueFallback(t *testing.T) {
	h := Instance()
	h.applyValues(map[string]string{}) // 清空缓存

	assert.Equal(t, "", h.GetString(CodeSystemName))
	assert.Equal(t, 0, h.GetInt(CodeLoginLockThreshold))
	assert.False(t, h.GetBool(CodeRequireSpecialChar))

	assert.Equal(t, "", h.GetString("not.exist"))
	assert.Equal(t, 0, h.GetInt("not.exist"))
	assert.False(t, h.GetBool("not.exist"))
}

// TestApplyValuesAndTypedGetters 缓存命中时的字符串/整型/布尔转换
func TestApplyValuesAndTypedGetters(t *testing.T) {
	h := Instance()
	t.Cleanup(func() {
		h.applyValues(map[string]string{}) // 还原缓存，避免影响其他用例
	})
	h.applyValues(map[string]string{
		CodeSystemName:         "测试系统",
		CodeLoginLockThreshold: "5",
		CodeRequireSpecialChar: "false",
		CodeCaptchaOpen:        "true",
		CodeCaptchaLength:      "6",
	})

	assert.Equal(t, "测试系统", h.GetString(CodeSystemName))
	assert.Equal(t, 5, h.GetInt(CodeLoginLockThreshold))
	assert.False(t, h.GetBool(CodeRequireSpecialChar))
	assert.True(t, h.GetBool(CodeCaptchaOpen))
	assert.Equal(t, 6, h.GetInt(CodeCaptchaLength))
}
