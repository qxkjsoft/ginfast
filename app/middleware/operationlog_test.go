package middleware

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestShouldSkipLog(t *testing.T) {
	gin.SetMode(gin.TestMode)

	cases := []struct {
		name string
		path string
		skip bool
	}{
		// 前缀匹配正例：swagger 下任意子路径
		{"swagger index", "/swagger/index.html", true},
		{"swagger doc", "/swagger/doc.json", true},
		// 精确匹配正例
		{"favicon", "/favicon.ico", true},
		{"health", "/health", true},
		{"metrics", "/metrics", true},
		{"refreshToken", "/api/refreshToken", true},
		{"captcha verify", "/api/captcha/verify", true},
		{"config get", "/api/config/get", true},
		// 子串误命中反例（原 strings.Contains 实现会误跳过）
		{"users health 不误跳", "/api/users/health", false},
		{"metrics 子路径不误跳", "/api/metrics/export", false},
		{"config get 变体不误跳", "/api/sysConfig/get", false},
		{"refreshToken 变体不误跳", "/api/token/refreshTokenList", false},
		// 已下线的旧验证码端点不再跳过
		{"旧端点 captcha/id", "/api/captcha/id", false},
		{"旧端点 captcha/image", "/api/captcha/image", false},
		// 普通业务路径
		{"login 记录日志", "/api/login", false},
		{"users list", "/api/users/list", false},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			c, _ := gin.CreateTestContext(httptest.NewRecorder())
			c.Request = httptest.NewRequest(http.MethodGet, tc.path, nil)
			assert.Equal(t, tc.skip, shouldSkipLog(c))
		})
	}
}
