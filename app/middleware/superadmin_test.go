package middleware

import (
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"
	"gin-fast/app/utils/response"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

// stubSuperAdminConfig 打桩超管判定所需的三个配置读：
// notcheckuser=[1]、initadmin.enabled=true 且 initadmin.id=1，即 userID=1 视为超管；
// 其余配置方法经内嵌接口缺失即 panic，测试不应触达
type stubSuperAdminConfig struct{ app.YmlConfigInterf }

func (stubSuperAdminConfig) GetUintSlice(string) []uint { return []uint{1} }
func (stubSuperAdminConfig) GetBool(string) bool        { return true }
func (stubSuperAdminConfig) GetInt(string) int          { return 1 }

// newSuperAdminRouter 构造挂载 SuperAdminMiddleware 的测试路由；
// withClaims 为 true 时前置中间件向上下文注入指定 userID 的登录信息
func newSuperAdminRouter(withClaims bool, userID uint) *gin.Engine {
	gin.SetMode(gin.TestMode)
	app.ConfigYml = stubSuperAdminConfig{}
	app.Response = response.NewResponseHandler()
	router := gin.New()
	router.GET("/debug", func(c *gin.Context) {
		if withClaims {
			c.Set(consts.BindContextKeyName, &app.Claims{ClaimsUser: app.ClaimsUser{UserID: userID}})
		}
		c.Next()
	}, SuperAdminMiddleware(), func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"ok": true})
	})
	return router
}

func TestSuperAdminMiddleware_AllowsSuperAdmin(t *testing.T) {
	router := newSuperAdminRouter(true, 1)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/debug", nil))
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "ok")
}

func TestSuperAdminMiddleware_RejectsNormalUser(t *testing.T) {
	router := newSuperAdminRouter(true, 2)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/debug", nil))
	assert.Equal(t, http.StatusForbidden, w.Code)
	assert.Contains(t, w.Body.String(), "仅平台超级管理员可访问")
}

func TestSuperAdminMiddleware_RejectsNoClaims(t *testing.T) {
	router := newSuperAdminRouter(false, 0)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/debug", nil))
	assert.Equal(t, http.StatusForbidden, w.Code)
}
