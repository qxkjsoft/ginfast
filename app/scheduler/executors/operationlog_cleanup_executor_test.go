package executors

import (
	"gin-fast/app/utils/schedulerhelper"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestResolveRetainDays(t *testing.T) {
	// 缺省/nil 兜底 90
	assert.Equal(t, 90, resolveRetainDays(nil))
	assert.Equal(t, 90, resolveRetainDays(map[string]interface{}{}))

	// 合法数字（json 反序列化后为 float64）取该值
	assert.Equal(t, 30, resolveRetainDays(map[string]interface{}{"retain_days": float64(30)}))
	assert.Equal(t, 365, resolveRetainDays(map[string]interface{}{"retain_days": 365}))
	assert.Equal(t, 7, resolveRetainDays(map[string]interface{}{"retain_days": int64(7)}))

	// 字符串数字取该值
	assert.Equal(t, 60, resolveRetainDays(map[string]interface{}{"retain_days": "60"}))

	// 非法/≤0 一律兜底 90
	assert.Equal(t, 90, resolveRetainDays(map[string]interface{}{"retain_days": 0}))
	assert.Equal(t, 90, resolveRetainDays(map[string]interface{}{"retain_days": -5}))
	assert.Equal(t, 90, resolveRetainDays(map[string]interface{}{"retain_days": "abc"}))
	assert.Equal(t, 90, resolveRetainDays(map[string]interface{}{"retain_days": true}))
}

func TestOperationLogCleanupExecutorName(t *testing.T) {
	e := &OperationLogCleanupExecutor{}
	assert.Equal(t, "operation-log-cleanup", e.Name())
}

// 编译期保证实现 Executor 接口
var _ schedulerhelper.Executor = (*OperationLogCleanupExecutor)(nil)
