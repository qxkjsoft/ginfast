package gormhelper

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
	"gorm.io/gorm"
)

// TestIsDuplicateKeyError 判断唯一索引/唯一约束冲突错误（表驱动，不依赖 DB）
func TestIsDuplicateKeyError(t *testing.T) {
	tests := []struct {
		name string
		err  error
		want bool
	}{
		{name: "直接ErrDuplicatedKey", err: gorm.ErrDuplicatedKey, want: true},
		{name: "百分比w包装ErrDuplicatedKey", err: fmt.Errorf("创建用户失败: %w", gorm.ErrDuplicatedKey), want: true},
		{name: "普通错误", err: fmt.Errorf("connection refused"), want: false},
		{name: "nil错误", err: nil, want: false},
		{name: "其他gorm错误", err: gorm.ErrRecordNotFound, want: false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			assert.Equal(t, tt.want, IsDuplicateKeyError(tt.err))
		})
	}
}
