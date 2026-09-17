package uploadhelper

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

// TestVerifyMagicNumber 内容嗅探与扩展名比对（表驱动，使用真实魔数字节，不依赖 DB/配置）
func TestVerifyMagicNumber(t *testing.T) {
	png := []byte{0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A, 0, 0, 0, 13, 'I', 'H', 'D', 'R'}
	jpeg := []byte{0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 'J', 'F', 'I', 'F', 0x00}
	gif := []byte("GIF89a\x01\x00\x01\x00")
	pdf := []byte("%PDF-1.4\n%test\n")
	zip := []byte("PK\x03\x04\x14\x00\x00\x00")
	text := []byte("hello world, plain text")
	html := []byte("<html><body><script>alert(1)</script></body></html>")

	tests := []struct {
		name    string
		ext     string
		content []byte
		wantErr bool
	}{
		{"png内容_声明png", ".png", png, false},
		// 位图扩展名之间交叉放行（改名文件/前端裁剪导出 PNG 却沿用 .jpg 原名的场景）
		{"png内容_声明jpg", ".jpg", png, false},
		{"jpeg内容_声明png", ".png", jpeg, false},
		{"jpeg内容_声明jpeg", ".jpeg", jpeg, false},
		{"gif内容_声明gif", ".gif", gif, false},
		{"pdf内容_声明pdf", ".pdf", pdf, false},
		{"zip内容_声明zip", ".zip", zip, false},
		{"zip内容_声明docx", ".docx", zip, false},
		{"html内容_伪装png", ".png", html, true},
		{"html内容_伪装jpg", ".jpg", html, true},
		{"pdf内容_伪装png", ".png", pdf, true},
		// txt 以 text/plain 提供静态直出，无脚本执行面；嗅探为 text/html 时按主类型前缀放行
		{"html内容_声明txt", ".txt", html, false},
		{"文本内容_声明txt", ".txt", text, false},
		{"未知扩展名_放行", ".bin", html, false},
		{"ico_跳过校验", ".ico", html, false},
		{"空内容_声明png", ".png", nil, true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := VerifyMagicNumber(tt.ext, strings.NewReader(string(tt.content)))
			if tt.wantErr {
				assert.Error(t, err)
			} else {
				assert.NoError(t, err)
			}
		})
	}
}
