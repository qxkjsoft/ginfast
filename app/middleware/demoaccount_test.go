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
	"go.uber.org/zap"
)

// stubDemoConfig 打桩演示账号中间件所需的配置：
// enabled=true、演示账号 userids=[9]、白名单 allowpathprefixes=["/api/users"]；
// 其余配置方法经内嵌接口缺失即 panic，测试不应触达
type stubDemoConfig struct{ app.YmlConfigInterf }

func (stubDemoConfig) GetBool(string) bool            { return true }
func (stubDemoConfig) GetUintSlice(string) []uint     { return []uint{9} }
func (stubDemoConfig) GetStringSlice(string) []string { return []string{"/api/users"} }

// newDemoAccountRouter 构造挂载 DemoAccountMiddleware 的测试路由；
// userID 为 0 时不注入登录信息（模拟非受保护请求），9 为演示账号，其他为普通用户
func newDemoAccountRouter(userID uint, withClaims bool) *gin.Engine {
	gin.SetMode(gin.TestMode)
	app.ConfigYml = stubDemoConfig{}
	app.Response = response.NewResponseHandler()
	app.ZapLog = zap.NewNop() // 白名单放行分支会记日志，测试环境用空日志器
	router := gin.New()
	router.Use(func(c *gin.Context) {
		if withClaims {
			c.Set(consts.BindContextKeyName, &app.Claims{ClaimsUser: app.ClaimsUser{UserID: userID}})
		}
		c.Next()
	}, DemoAccountMiddleware())
	allMethods := []string{http.MethodGet, http.MethodPost, http.MethodPut, http.MethodDelete}
	for _, method := range allMethods {
		router.Handle(method, "/api/usersX", demoHandler())
		router.Handle(method, "/api/users", demoHandler())
		router.Handle(method, "/api/users/:id", demoHandler())
		router.Handle(method, "/api/orders", demoHandler())
	}
	return router
}

func demoHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"ok": true})
	}
}

func TestDemoAccount_GETAlwaysAllowed(t *testing.T) {
	router := newDemoAccountRouter(9, true)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/api/orders", nil))
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestDemoAccount_POSTOnExactWhitelistedPathAllowed(t *testing.T) {
	router := newDemoAccountRouter(9, true)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodPost, "/api/users", nil))
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestDemoAccount_POSTOnWhitelistedSubpathAllowed(t *testing.T) {
	router := newDemoAccountRouter(9, true)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodPut, "/api/users/1", nil))
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestDemoAccount_POSTOnLongerSegmentRejected(t *testing.T) {
	// B-21 核心：/api/users 白名单不应连带放行 /api/usersX
	router := newDemoAccountRouter(9, true)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodPost, "/api/usersX", nil))
	assert.Equal(t, http.StatusForbidden, w.Code)
}

func TestDemoAccount_POSTOutsideWhitelistRejected(t *testing.T) {
	router := newDemoAccountRouter(9, true)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodDelete, "/api/orders", nil))
	assert.Equal(t, http.StatusForbidden, w.Code)
}

func TestDemoAccount_NonDemoUserNotRestricted(t *testing.T) {
	router := newDemoAccountRouter(2, true)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodPost, "/api/orders", nil))
	assert.Equal(t, http.StatusOK, w.Code)
}
