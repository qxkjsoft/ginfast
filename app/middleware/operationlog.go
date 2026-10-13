package middleware

import (
	"bytes"
	"encoding/json"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"
	"gin-fast/app/utils/goroutinehelper"
	"io"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// OperationLogMiddleware 操作日志中间件
func OperationLogMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 跳过不需要记录日志的请求
		if shouldSkipLog(c) {
			c.Next()
			return
		}

		startTime := time.Now()

		// 复制请求体用于记录
		var requestBody []byte
		if c.Request.Body != nil {
			requestBody, _ = io.ReadAll(c.Request.Body)
			c.Request.Body = io.NopCloser(bytes.NewBuffer(requestBody))
		}

		// 创建自定义的ResponseWriter来捕获响应
		writer := &responseWriter{body: bytes.NewBuffer(nil), ResponseWriter: c.Writer}
		c.Writer = writer

		defer func() {
			// 在请求结束、gin.Context 被复用前同步采集日志数据，再异步落库，避免数据竞态
			data := collectOperationLogData(c, writer, startTime, requestBody)
			goroutinehelper.GoSafe("operationlog", func() {
				saveOperationLog(data)
			})
		}()

		c.Next()
	}
}

// responseWriter 自定义ResponseWriter用于捕获响应数据
type responseWriter struct {
	gin.ResponseWriter
	body *bytes.Buffer
}

func (w *responseWriter) Write(b []byte) (int, error) {
	w.body.Write(b)
	return w.ResponseWriter.Write(b)
}

// shouldSkipLog 判断是否需要跳过日志记录
func shouldSkipLog(c *gin.Context) bool {
	// 跳过静态文件、健康检查等请求
	// prefixSkipPaths 按前缀匹配（其下有子路径）；其余按路径精确匹配，
	// 避免 strings.Contains 子串误伤（如 /api/users/health 误命中 /health）
	prefixSkipPaths := []string{
		"/swagger/",
	}
	exactSkipPaths := []string{
		"/favicon.ico",
		"/health",
		"/metrics",
		"/api/refreshToken", // 刷新token
		"/api/captcha/verify", // 获取验证码图片
		"/api/config/get",   // 获取配置信息
	}

	path := c.Request.URL.Path
	for _, p := range prefixSkipPaths {
		if strings.HasPrefix(path, p) {
			return true
		}
	}
	for _, p := range exactSkipPaths {
		if path == p {
			return true
		}
	}

	return false
}

// operationLogData 操作日志数据快照。
// 在请求结束、gin.Context 被复用之前同步采集，异步落库阶段仅读取本结构体，
// 避免跨 goroutine 访问 *gin.Context 造成数据竞态。
type operationLogData struct {
	StartTime     time.Time
	Method        string
	Path          string
	ClientIP      string
	UserAgent     string
	StatusCode    int
	ErrorMessage  string
	UserID        uint
	Username      string
	TenantID      uint
	OperationType string
	Module        string
	RequestBody   []byte
	ResponseBody  []byte
}

// collectOperationLogData 同步采集记录操作日志所需的全部数据。
// 必须在启动异步落库 goroutine 之前调用。
func collectOperationLogData(c *gin.Context, writer *responseWriter, startTime time.Time, requestBody []byte) operationLogData {
	data := operationLogData{
		StartTime:     startTime,
		Method:        c.Request.Method,
		Path:          c.Request.URL.Path,
		ClientIP:      c.ClientIP(),
		UserAgent:     c.Request.UserAgent(),
		StatusCode:    writer.Status(),
		OperationType: getOperationType(c),
		Module:        getOperationModule(c),
		RequestBody:   requestBody,
		ResponseBody:  writer.body.Bytes(),
	}

	// 尝试从JWT token获取用户信息
	claims := common.GetClaims(c)
	if claims != nil {
		data.UserID = claims.UserID
		data.Username = claims.Username
		data.TenantID = claims.TenantID
	} else {
		// 如果是登录操作，尝试从请求体中获取用户名
		if data.Path == "/api/login" && data.Method == "POST" && len(data.RequestBody) > 0 {
			// 解析登录请求体获取用户名
			var loginReq struct {
				Username string `json:"username"`
			}
			if err := json.Unmarshal(data.RequestBody, &loginReq); err == nil && loginReq.Username != "" {
				data.Username = loginReq.Username
				// 标记为登录操作
				data.OperationType = models.OperationLogin
			}
		}
	}

	// 错误信息
	ctxErr, _ := c.Get("error")
	data.ErrorMessage = getErrorMessage(data.StatusCode, ctxErr, data.ResponseBody)

	return data
}

// saveOperationLog 构建并保存操作日志（仅在异步 goroutine 中执行，不读取 gin.Context）
func saveOperationLog(data operationLogData) {
	log := &models.SysOperationLog{
		UserID:      data.UserID,
		Username:    data.Username,
		Module:      data.Module,
		Operation:   data.OperationType,
		Method:      data.Method,
		Path:        data.Path,
		IP:          data.ClientIP,
		UserAgent:   data.UserAgent,
		RequestData: sanitizeRequestData(data.RequestBody),
		//ResponseData: sanitizeResponseData(data.ResponseBody),
		StatusCode: data.StatusCode,
		Duration:   time.Since(data.StartTime).Milliseconds(),
		ErrorMsg:   data.ErrorMessage,
		Location:   getLocationByIP(data.ClientIP),
		TenantID:   data.TenantID,
	}

	if err := app.DB().Create(log).Error; err != nil {
		app.ZapLog.Error("记录操作日志失败", zap.Error(err))
	}
}

// getOperationModule 获取操作模块
func getOperationModule(c *gin.Context) string {
	path := c.Request.URL.Path
	if strings.Contains(path, "/users") {
		return "用户管理"
	} else if strings.Contains(path, "/sysMenu") {
		return "菜单管理"
	} else if strings.Contains(path, "/sysRole") {
		return "角色管理"
	} else if strings.Contains(path, "/sysDepartment") {
		return "部门管理"
	} else if strings.Contains(path, "/sysDict") {
		return "字典管理"
	} else if strings.Contains(path, "/sysApi") {
		return "API管理"
	} else if strings.Contains(path, "/sysAffix") {
		return "文件管理"
	} else if strings.Contains(path, "/config") {
		return "系统配置"
	} else if strings.Contains(path, "/sysOperationLog") {
		return "操作日志管理"
	}
	return "其他"
}

// getOperationType 获取操作类型
func getOperationType(c *gin.Context) string {
	method := c.Request.Method
	switch method {
	case "POST":
		return models.OperationCreate
	case "PUT", "PATCH":
		return models.OperationUpdate
	case "DELETE":
		return models.OperationDelete
	case "GET":
		return models.OperationQuery
	default:
		return "unknown"
	}
}

// getErrorMessage 获取错误信息（基于已采集的值，不读取 gin.Context）
func getErrorMessage(statusCode int, ctxErr interface{}, responseBody []byte) string {
	if statusCode >= 400 {
		// 首先使用上下文中携带的错误信息
		if err, ok := ctxErr.(error); ok {
			return err.Error()
		}
		// 如果上下文中没有错误信息，尝试解析响应体
		if len(responseBody) > 0 {
			// 尝试解析JSON响应体
			var response map[string]interface{}
			if err := json.Unmarshal(responseBody, &response); err == nil {
				// 根据项目中的响应格式获取错误信息（使用message字段）
				if msg, ok := response["message"].(string); ok && msg != "" {
					return msg
				}
			}
		}
		return "请求处理失败"
	}
	return ""
}

// getLocationByIP 根据IP获取地理位置（简化实现）
func getLocationByIP(ip string) string {
	// 这里可以集成第三方IP地理位置服务
	// 简化实现：返回空字符串
	return ""
}

// sanitizeRequestData 对请求数据进行脱敏处理
func sanitizeRequestData(data []byte) string {
	if len(data) == 0 {
		return ""
	}

	// 如果是JSON数据，尝试脱敏敏感字段
	if json.Valid(data) {
		var jsonData map[string]interface{}
		if err := json.Unmarshal(data, &jsonData); err == nil {
			// 脱敏密码字段
			if _, exists := jsonData["password"]; exists {
				jsonData["password"] = "***"
			}
			if _, exists := jsonData["Password"]; exists {
				jsonData["Password"] = "***"
			}
			if _, exists := jsonData["newPassword"]; exists {
				jsonData["newPassword"] = "***"
			}

			// 重新序列化
			if sanitized, err := json.Marshal(jsonData); err == nil {
				return string(sanitized)
			}
		}
	}

	// 如果不是JSON，直接返回原始数据（限制长度）
	if len(data) > 10000 {
		return string(data[:10000]) + "...(truncated)"
	}
	return string(data)
}

// sanitizeResponseData 对响应数据进行脱敏处理
func sanitizeResponseData(data []byte) string {
	if len(data) == 0 {
		return ""
	}

	// 限制响应数据长度
	if len(data) > 5000 {
		return string(data[:5000]) + "...(truncated)"
	}
	return string(data)
}
