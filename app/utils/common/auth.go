package common

import (
	"context"
	"errors"
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"
	"strings"

	"github.com/gin-gonic/gin"
)

// 获取access token
func GetAccessToken(c *gin.Context) (string, error) {
	authHeader := c.GetHeader("Authorization")
	if authHeader == "" {
		return "", errors.New("authorization header is required")
	}
	headerParts := strings.Split(authHeader, " ")
	if len(headerParts) != 2 || headerParts[0] != "Bearer" {
		return "", errors.New("authorization header format must be Bearer {token}")
	}
	return headerParts[1], nil
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
