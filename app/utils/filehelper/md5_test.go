package filehelper

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
)

// TestCalculateFileMD5 计算文件MD5（临时文件，不依赖 DB/配置）
func TestCalculateFileMD5(t *testing.T) {
	dir := t.TempDir()

	// 已知内容校验：md5("hello") = 5d41402abc4b2a76b9719d911017c592
	p1 := filepath.Join(dir, "hello.txt")
	assert.NoError(t, os.WriteFile(p1, []byte("hello"), 0644))
	sum, err := CalculateFileMD5(p1)
	assert.NoError(t, err)
	assert.Equal(t, "5d41402abc4b2a76b9719d911017c592", sum)

	// 空文件：md5("") = d41d8cd98f00b204e9800998ecf8427e
	p2 := filepath.Join(dir, "empty.txt")
	assert.NoError(t, os.WriteFile(p2, []byte{}, 0644))
	sum, err = CalculateFileMD5(p2)
	assert.NoError(t, err)
	assert.Equal(t, "d41d8cd98f00b204e9800998ecf8427e", sum)

	// 文件不存在时返回错误
	_, err = CalculateFileMD5(filepath.Join(dir, "not-exist.txt"))
	assert.Error(t, err)
}
