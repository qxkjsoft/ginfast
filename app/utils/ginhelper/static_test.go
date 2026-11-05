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

// TestSecureStaticDirectoryEntry 目录请求下 index.html 入口（H5 编译产物挂载场景）
func TestSecureStaticDirectoryEntry(t *testing.T) {
	dir := t.TempDir()

	// /shop：含 index.html 的 H5 站点目录
	shop := filepath.Join(dir, "shop")
	assert.NoError(t, os.MkdirAll(shop, 0755))
	assert.NoError(t, os.WriteFile(filepath.Join(shop, "index.html"), []byte("<html><body>shop</body></html>"), 0644))

	// uploads/sub：上传区子目录也放一个 index.html，验证目录形式访问不绕过强制下载
	uploads := filepath.Join(dir, "uploads")
	sub := filepath.Join(uploads, "sub")
	assert.NoError(t, os.MkdirAll(sub, 0755))
	assert.NoError(t, os.WriteFile(filepath.Join(sub, "index.html"), []byte("<html></html>"), 0644))

	gin.SetMode(gin.TestMode)
	engine := gin.New()
	SecureStatic(engine, "/public", dir)
	SecureStatic(engine, "/shop", shop)

	get := func(path string) *httptest.ResponseRecorder {
		w := httptest.NewRecorder()
		req := httptest.NewRequest(http.MethodGet, path, nil)
		engine.ServeHTTP(w, req)
		return w
	}

	// 裸前缀 /shop → gin 自动 301 到 /shop/（后续请求拿到入口文件）
	w := get("/shop")
	assert.Equal(t, http.StatusMovedPermanently, w.Code)
	assert.Equal(t, "/shop/", w.Header().Get("Location"))

	// /shop/ → 目录请求输出 index.html 作为站点入口
	w = get("/shop/")
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Header().Get("Content-Type"), "text/html")
	assert.Equal(t, "nosniff", w.Header().Get("X-Content-Type-Options"))
	assert.Equal(t, "<html><body>shop</body></html>", w.Body.String())

	// uploads 子目录的 index.html 经目录形式访问，同样强制下载（防存储型 XSS 绕过）
	w = get("/public/uploads/sub/")
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "attachment", w.Header().Get("Content-Disposition"))
	assert.Equal(t, "nosniff", w.Header().Get("X-Content-Type-Options"))

	// 无 index.html 的目录仍 404（防目录列表）
	w = get("/public/uploads/")
	assert.Equal(t, http.StatusNotFound, w.Code)

	// 入口目录下请求不存在的文件仍 404
	w = get("/shop/not-exist.js")
	assert.Equal(t, http.StatusNotFound, w.Code)
}
