package common

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestGetAccessTokenFromHeader(t *testing.T) {
	gin.SetMode(gin.TestMode)

	cases := []struct {
		name       string
		header     string
		queryToken string
		wantToken  string
		wantErr    bool
	}{
		{"标准 Bearer", "Bearer abc123", "", "abc123", false},
		{"无 header 且无 query", "", "", "", true},
		{"格式错误-非 Bearer 前缀", "Basic abc123", "", "", true},
		{"格式错误-缺 token", "Bearer", "", "", true},
		{"格式错误-多段", "Bearer a b", "", "", true},
		// 关键安全属性：query 参数不得作为 header 缺失时的兜底渠道
		{"仅 query 传 token 必须拒绝", "", "qt123", "", true},
		{"header 优先于 query", "Bearer hdr123", "qt123", "hdr123", false},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			c, _ := gin.CreateTestContext(httptest.NewRecorder())
			req := httptest.NewRequest(http.MethodGet, "/api/users/list", nil)
			if tc.queryToken != "" {
				q := req.URL.Query()
				q.Set("token", tc.queryToken)
				req.URL.RawQuery = q.Encode()
			}
			if tc.header != "" {
				req.Header.Set("Authorization", tc.header)
			}
			c.Request = req

			token, err := GetAccessTokenFromHeader(c)
			if tc.wantErr {
				assert.Error(t, err)
				assert.Empty(t, token)
			} else {
				assert.NoError(t, err)
				assert.Equal(t, tc.wantToken, token)
			}
		})
	}
}
