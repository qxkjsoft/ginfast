package controllers

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestSanitizeDownloadFilename(t *testing.T) {
	// 合法名（folderName 白名单字符 + 常规版本号）原样保留
	assert.Equal(t, "simplemall_1.2.0", sanitizeDownloadFilename("simplemall_1.2.0"))

	// 引号/CRLF/空格/中文等一律替换为下划线，杜绝响应头注入
	assert.Equal(t, "evil_x", sanitizeDownloadFilename(`evil"x`))
	assert.Equal(t, "evil__x", sanitizeDownloadFilename("evil\r\nx"))
	assert.Equal(t, "a_b", sanitizeDownloadFilename("a b"))
	assert.Equal(t, "____", sanitizeDownloadFilename("订单导出"))
}
