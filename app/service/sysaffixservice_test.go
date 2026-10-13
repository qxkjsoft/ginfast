package service

import (
	"testing"

	"gin-fast/app/global/app"

	"github.com/stretchr/testify/assert"
)

// TestValidateChunkIndexes 分片序号完整性校验（表驱动，恰好为 1..total 连续无缺无重）
func TestValidateChunkIndexes(t *testing.T) {
	tests := []struct {
		name    string
		indexes []int
		total   int
		wantErr bool
	}{
		{name: "正常连续", indexes: []int{1, 2, 3}, total: 3, wantErr: false},
		{name: "乱序但完整", indexes: []int{3, 1, 2}, total: 3, wantErr: false},
		{name: "单分片", indexes: []int{1}, total: 1, wantErr: false},
		{name: "缺片", indexes: []int{1, 3}, total: 3, wantErr: true},
		{name: "重片", indexes: []int{1, 1, 2}, total: 3, wantErr: true},
		{name: "越界_超上限", indexes: []int{1, 2, 4}, total: 3, wantErr: true},
		{name: "越界_0号", indexes: []int{0, 1, 2}, total: 3, wantErr: true},
		{name: "空列表", indexes: []int{}, total: 3, wantErr: true},
		{name: "total为0", indexes: []int{}, total: 0, wantErr: true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := validateChunkIndexes(tt.indexes, tt.total)
			if tt.wantErr {
				assert.Error(t, err)
			} else {
				assert.NoError(t, err)
			}
		})
	}
}

// TestMaxTotalChunks 分片总数上限推导（文件总大小上限/单分片上限，向上取整）
func TestMaxTotalChunks(t *testing.T) {
	// 整除：5120MB/5MB = 1024
	assert.Equal(t, 1024, maxTotalChunks(app.UploadConfig{ChunkMaxSize: 5120, MaxChunkSize: 5}))
	// 除不尽向上取整：11/5 = 3
	assert.Equal(t, 3, maxTotalChunks(app.UploadConfig{ChunkMaxSize: 11, MaxChunkSize: 5}))
	// 单分片配置非法时兜底
	assert.Equal(t, defaultMaxTotalChunks, maxTotalChunks(app.UploadConfig{ChunkMaxSize: 5120, MaxChunkSize: 0}))
	// 总量小于单片时至少为 1
	assert.Equal(t, 1, maxTotalChunks(app.UploadConfig{ChunkMaxSize: 2, MaxChunkSize: 5}))
}
