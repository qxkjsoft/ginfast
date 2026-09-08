package tenanthelper

import (
	"gin-fast/app/global/app"
	"gin-fast/app/utils/common"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// MultiTenantEnabled 多租户开关；配置键缺失时默认开启，保证旧配置文件行为不变
func MultiTenantEnabled() bool {
	if !app.ConfigYml.IsSet("server.multitenant") {
		return true
	}
	return app.ConfigYml.GetBool("server.multitenant")
}

// TenantScope 租户数据隔离作用域
func TenantScope(c *gin.Context) func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		// 获取租户ID
		claims := common.GetClaims(c)
		if claims == nil {
			// 没有权限
			return db.Where("1 = 0")
		}
		// 多租户关闭时不再按租户过滤数据（单体模式）
		if !MultiTenantEnabled() {
			return db
		}
		return db.Where("tenant_id = ?", claims.TenantID)
	}
}
