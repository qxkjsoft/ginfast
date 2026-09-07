package middleware

import (
	"gin-fast/app/global/consts"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestTimeoutMiddleware_FastHandler(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := gin.New()
	router.Use(TimeoutMiddleware(200 * time.Millisecond))
	router.GET("/ok", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"msg": "ok"})
	})

	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/ok", nil))

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "ok")
}

func TestTimeoutMiddleware_SlowHandlerReturns504(t *testing.T) {
	gin.SetMode(gin.TestMode)
	done := make(chan struct{})
	router := gin.New()
	router.Use(TimeoutMiddleware(50 * time.Millisecond))
	router.GET("/slow", func(c *gin.Context) {
		time.Sleep(300 * time.Millisecond)
		c.JSON(http.StatusOK, gin.H{"msg": "late"})
		close(done)
	})

	w := httptest.NewRecorder()
	start := time.Now()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/slow", nil))
	elapsed := time.Since(start)

	assert.Equal(t, http.StatusGatewayTimeout, w.Code)
	assert.Contains(t, w.Body.String(), "请求处理超时")
	assert.Less(t, elapsed, 250*time.Millisecond, "超时后不应同步等待 handler 跑完")
	<-done // 等 handler goroutine 结束，避免测试内 goroutine 泄漏
}

func TestTimeoutMiddleware_PanicPropagates(t *testing.T) {
	gin.SetMode(gin.TestMode)
	recovered := make(chan interface{}, 1)
	router := gin.New()
	router.Use(func(c *gin.Context) {
		defer func() {
			if p := recover(); p != nil {
				recovered <- p
				c.AbortWithStatus(http.StatusInternalServerError)
			}
		}()
		c.Next()
	})
	router.Use(TimeoutMiddleware(200 * time.Millisecond))
	router.GET("/panic", func(c *gin.Context) {
		panic("boom")
	})

	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/panic", nil))

	select {
	case p := <-recovered:
		assert.Equal(t, "boom", p, "panic 必须传回主 goroutine 由外层 recovery 处理")
	default:
		t.Fatal("panic 未传播回主 goroutine")
	}
	assert.Equal(t, http.StatusInternalServerError, w.Code)
}

func TestTimeoutMiddleware_RequestAbortedPropagates(t *testing.T) {
	gin.SetMode(gin.TestMode)
	recovered := make(chan interface{}, 1)
	router := gin.New()
	router.Use(func(c *gin.Context) {
		defer func() {
			if p := recover(); p != nil {
				recovered <- p
			}
		}()
		c.Next()
	})
	router.Use(TimeoutMiddleware(200 * time.Millisecond))
	router.GET("/abort", func(c *gin.Context) {
		// 模拟 FailAndAbort：先写响应再 panic(consts.RequestAborted)
		c.JSON(http.StatusOK, gin.H{"message": "failed-and-aborted"})
		c.Abort()
		panic(consts.RequestAborted)
	})

	w := httptest.NewRecorder()
	router.ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/abort", nil))

	select {
	case p := <-recovered:
		assert.Equal(t, consts.RequestAborted, p, "RequestAborted 必须传回主 goroutine 保持 FailAndAbort 语义")
	default:
		t.Fatal("RequestAborted 未传播回主 goroutine")
	}
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "failed-and-aborted")
}
