package ginhelper

import (
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

// TestSecureStatic 静态直出安全防护（nosniff / svg CSP / html 强制下载 / 目录 404）
func TestSecureStatic(t *testing.T) {
	dir := t.TempDir()
	uploads := filepath.Join(dir, "uploads")
	assert.NoError(t, os.MkdirAll(uploads, 0755))
	assert.NoError(t, os.WriteFile(filepath.Join(uploads, "logo.svg"), []byte(`<svg xmlns="http://www.w3.org/2000/svg"><script>alert(1)</script></svg>`), 0644))
	assert.NoError(t, os.WriteFile(filepath.Join(uploads, "page.html"), []byte("<html></html>"), 0644))
	assert.NoError(t, os.WriteFile(filepath.Join(uploads, "pic.png"), []byte{0x89, 'P', 'N', 'G'}, 0644))
	assert.NoError(t, os.WriteFile(filepath.Join(dir, "root.txt"), []byte("root"), 0644))

	gin.SetMode(gin.TestMode)
	engine := gin.New()
	SecureStatic(engine, "/public", dir)

	get := func(path string) *httptest.ResponseRecorder {
		w := httptest.NewRecorder()
		req := httptest.NewRequest(http.MethodGet, path, nil)
		engine.ServeHTTP(w, req)
		return w
	}

	// svg：追加禁脚本 CSP + nosniff，不强制下载（<img> 引用可正常显示）
	w := get("/public/uploads/logo.svg")
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "script-src 'none'; object-src 'none'", w.Header().Get("Content-Security-Policy"))
	assert.Equal(t, "nosniff", w.Header().Get("X-Content-Type-Options"))
	assert.Empty(t, w.Header().Get("Content-Disposition"))

	// html：强制下载
	w = get("/public/uploads/page.html")
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "attachment", w.Header().Get("Content-Disposition"))
	assert.Equal(t, "nosniff", w.Header().Get("X-Content-Type-Options"))

	// png：无额外内容型响应头
	w = get("/public/uploads/pic.png")
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Empty(t, w.Header().Get("Content-Security-Policy"))
	assert.Empty(t, w.Header().Get("Content-Disposition"))

	// 根路径（目录列表）→ 404
	w = get("/public/")
	assert.Equal(t, http.StatusNotFound, w.Code)

	// uploads 目录本身（目录列表）→ 404
	w = get("/public/uploads")
	assert.Equal(t, http.StatusNotFound, w.Code)

	// 不存在的文件 → 404
	w = get("/public/uploads/not-exist.png")
	assert.Equal(t, http.StatusNotFound, w.Code)

	// 根目录下普通文件正常访问
	w = get("/public/root.txt")
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "nosniff", w.Header().Get("X-Content-Type-Options"))
}
