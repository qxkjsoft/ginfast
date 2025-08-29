package common

import (
	"gin-fast/app/global/consts"
	"gin-fast/app/utils/tokenhelper"

	"github.com/gin-gonic/gin"
)

// GetClaims 从上下文获取 Claims
func GetClaims(c *gin.Context) *tokenhelper.Claims {
	claims, exists := c.Get(consts.BindContextKeyName)
	if !exists {
		return nil
	}
	// 类型断言
	res, ok := claims.(*tokenhelper.Claims)
	if !ok {
		return nil
	}
	return res
}

func GetCurrentUserID(c *gin.Context) uint {
	claims := GetClaims(c)
	if claims == nil {
		return 0
	}
	return claims.UserID
}
