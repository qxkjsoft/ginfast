package gormhelper

import (
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"

	"github.com/gin-gonic/gin"
)

// getTenantIDFromContext 从上下文中获取租户ID
func getTenantIDFromContext(ctx interface{}) uint {
	// 检查context是否为gin.Context类型
	if gc, ok := ctx.(*gin.Context); ok {
		// 从gin.Context中获取Claims
		claims, exists := gc.Get(consts.BindContextKeyName)
		if exists {
			// 类型断言
			if c, ok := claims.(*app.Claims); ok {
				return c.TenantID
			}
		}
	}

	// 如果ctx不是gin.Context，尝试从context的value中获取
	// 注意：这需要在调用GORM操作时通过WithValue将Claims注入到context中
	if gc, ok := ctx.(interface{ Value(interface{}) interface{} }); ok {
		if claims := gc.Value(consts.BindContextKeyName); claims != nil {
			if c, ok := claims.(*app.Claims); ok {
				return c.TenantID
			}
		}
	}

	return 0
}

// getCurrentUserIDFromContext 从上下文中获取当前用户ID
func getCurrentUserIDFromContext(ctx interface{}) uint {
	// 检查context是否为gin.Context类型
	if gc, ok := ctx.(*gin.Context); ok {
		// 从gin.Context中获取Claims
		claims, exists := gc.Get(consts.BindContextKeyName)
		if exists {
			// 类型断言
			if c, ok := claims.(*app.Claims); ok {
				return c.UserID
			}
		}
	}

	// 如果ctx不是gin.Context，尝试从context的value中获取
	// 注意：这需要在调用GORM操作时通过WithValue将Claims注入到context中
	if gc, ok := ctx.(interface{ Value(interface{}) interface{} }); ok {
		if claims := gc.Value(consts.BindContextKeyName); claims != nil {
			if c, ok := claims.(*app.Claims); ok {
				return c.UserID
			}
		}
	}

	return 0
}
