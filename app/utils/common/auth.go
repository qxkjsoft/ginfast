package common

import (
	"context"
	"errors"
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"
	"strings"

	"github.com/gin-gonic/gin"
)

// GetAccessTokenFromHeader 仅从 Authorization header 获取 access token。
// 主应用认证中间件应使用本函数：token 经 URL 参数传递会泄露到访问日志、
// Referer 与浏览器历史，不接受该渠道
func GetAccessTokenFromHeader(c *gin.Context) (string, error) {
	authHeader := c.GetHeader("Authorization")
	if authHeader == "" {
		return "", errors.New("token is required in Authorization header (Bearer {token})")
	}
	headerParts := strings.Split(authHeader, " ")
	if len(headerParts) == 2 && headerParts[0] == "Bearer" {
		return headerParts[1], nil
	}
	return "", errors.New("authorization header format must be Bearer {token}")
}

// GetAccessToken 从 Authorization header 或 URL query 参数获取 access token。
// 仅供插件端点（H5 会员端等无法自定义请求头的场景）兼容使用，
// 主应用路由请改用 GetAccessTokenFromHeader，避免 token 泄露到访问日志/Referer
// 获取access token
func GetAccessToken(c *gin.Context) (string, error) {
	// 首先尝试从 Authorization header 获取 token
	authHeader := c.GetHeader("Authorization")
	if authHeader != "" {
		headerParts := strings.Split(authHeader, " ")
		if len(headerParts) == 2 && headerParts[0] == "Bearer" {
			return headerParts[1], nil
		}
	}

	// 如果 header 中没有找到有效的 token，尝试从 URL 参数中获取
	token := c.Query("token")
	if token != "" {
		return token, nil
	}

	// 如果 header 格式不正确但没有 token 参数，返回格式错误
	if authHeader != "" {
		return "", errors.New("authorization header format must be Bearer {token}")
	}

	// 都没有找到 token
	return "", errors.New("token is required, either in Authorization header (Bearer {token}) or as URL parameter (?token={token})")
}

// GetClaims 从上下文获取 Claims
func GetClaims(c *gin.Context) *app.Claims {
	claims, exists := c.Get(consts.BindContextKeyName)
	if !exists {
		return nil
	}
	// 类型断言
	res, ok := claims.(*app.Claims)
	if !ok {
		return nil
	}
	return res
}

// GetCurrentUserID 获取当前用户ID
func GetCurrentUserID(c *gin.Context) uint {
	claims := GetClaims(c)
	if claims == nil {
		return 0
	}
	return claims.UserID
}

// 获取当前租户ID
func GetCurrentTenantID(c *gin.Context) uint {
	if c == nil {
		return 0
	}
	claims := GetClaims(c)
	if claims == nil {
		return 0
	}
	return claims.TenantID
}

// 获取当前租户Code
func GetCurrentTenantCode(c *gin.Context) string {
	if c == nil {
		return ""
	}
	claims := GetClaims(c)
	if claims == nil {
		return ""
	}
	return claims.TenantCode
}

// 尝试将context.Context转换成*gin.Context
func TryConvertToGinContext(c context.Context) *gin.Context {
	if c == nil {
		return nil
	}
	ginCtx, ok := c.(*gin.Context)
	if !ok {
		return nil
	}
	return ginCtx
}
