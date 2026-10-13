package gormhelper

import (
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"gorm.io/plugin/dbresolver"
)

// ForceWrite 强制本次查询链走写库（source），用于读写分离下的"写后立读"场景：
// 开启 isopenreaddb 后普通查询经 dbresolver 随机走从库，Create/Update 后立即查询
// 在复制延迟下可能读不到刚写的数据，此类敏感查询请包一层本函数：
//
//	gormhelper.ForceWrite(app.DB()).Where("id = ?", id).First(&row)
//
// 说明：未开启读写分离时为无副作用（no-op）；事务内查询本就走写连接，无需使用
func ForceWrite(db *gorm.DB) *gorm.DB {
	return db.Clauses(dbresolver.Write)
}

// getTenantIDFromContext 从上下文中获取租户ID
func GetTenantIDFromContext(ctx interface{}) uint {
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
func GetCurrentUserIDFromContext(ctx interface{}) uint {
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
