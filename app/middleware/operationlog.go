package middleware

import (
	"bytes"
	"encoding/json"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"
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

		c.Next()

		// 记录操作日志
		go recordOperationLog(c, startTime, requestBody, writer.body.Bytes())
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
	skipPaths := []string{
		"/swagger/",
		"/favicon.ico",
		"/health",
		"/metrics",
		"/api/refreshToken",  // 刷新token
		"/api/captcha/id",    // 生成验证码ID
		"/api/captcha/image", // 获取验证码图片
		"/api/config/get",    // 获取配置信息
	}

	path := c.Request.URL.Path
	for _, skipPath := range skipPaths {
		if strings.Contains(path, skipPath) {
			return true
		}
	}

	return false
}

// recordOperationLog 记录操作日志
func recordOperationLog(c *gin.Context, startTime time.Time, requestBody, responseBody []byte) {
	duration := time.Since(startTime).Milliseconds()

	// 获取用户信息
	var userID uint
	var username string
	operationType := getOperationType(c)

	// 尝试从JWT token获取用户信息
	claims := common.GetClaims(c)
	if claims != nil {
		userID = claims.UserID
		username = claims.Username
	} else {
		// 如果是登录操作，尝试从请求体中获取用户名
		if c.Request.URL.Path == "/api/login" && c.Request.Method == "POST" {
			// 解析登录请求体获取用户名
			var loginReq struct {
				Username string `json:"username"`
			}
			if len(requestBody) > 0 {
				if err := json.Unmarshal(requestBody, &loginReq); err == nil && loginReq.Username != "" {
					username = loginReq.Username
					// 标记为登录操作
					operationType = models.OperationLogin
				}
			}
		}
	}

	// 获取部门信息（如果有）
	var deptID uint
	var deptName string
	// 这里可以根据需要从用户信息中获取部门信息

	// 构建操作日志
	log := &models.SysOperationLog{
		UserID:       userID,
		Username:     username,
		Module:       getOperationModule(c),
		Operation:    operationType,
		Method:       c.Request.Method,
		Path:         c.Request.URL.Path,
		IP:           c.ClientIP(),
		UserAgent:    c.Request.UserAgent(),
		RequestData:  sanitizeRequestData(requestBody),
		ResponseData: sanitizeResponseData(responseBody),
		StatusCode:   c.Writer.Status(),
		Duration:     duration,
		ErrorMsg:     getErrorMessage(c),
		Location:     getLocationByIP(c.ClientIP()),
		DeptID:       deptID,
		DeptName:     deptName,
	}

	// 异步保存日志
	go func() {
		if err := app.DB().Create(log).Error; err != nil {
			app.ZapLog.Error("记录操作日志失败", zap.Error(err))
		}
	}()
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

// getErrorMessage 获取错误信息
func getErrorMessage(c *gin.Context) string {
	if c.Writer.Status() >= 400 {
		// 可以从上下文中获取错误信息
		if err, exists := c.Get("error"); exists {
			return err.(error).Error()
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
