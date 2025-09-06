package common

import (
	"errors"
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"
	"regexp"
	"strings"

	"github.com/gin-gonic/gin"
)

// 获取access token
func GetAccessToken(c *gin.Context) (string, error) {
	authHeader := c.GetHeader("Authorization")
	if authHeader == "" {
		return "", errors.New("Authorization header is required")
	}
	headerParts := strings.Split(authHeader, " ")
	if len(headerParts) != 2 || headerParts[0] != "Bearer" {
		return "", errors.New("Authorization header format must be Bearer {token}")
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

// convertPathToWildcard 将路径中的参数（如 :roleId）转换为通配符 *
func ConvertPathToWildcard(path string) string {
	// 使用正则表达式匹配 :param 格式的参数
	re := regexp.MustCompile(`:[^/]+`)
	return re.ReplaceAllString(path, "*")
}
