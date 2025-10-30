package tenanthelper

import (
	"gin-fast/app/utils/common"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// TenantScope 租户数据隔离作用域
func TenantScope(c *gin.Context) func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		// 获取租户ID
		claims := common.GetClaims(c)
		if claims != nil {
			return db.Where("tenant_id = ?", claims.TenantID)
		} else {
			// 没有权限
			return db.Where("1 = 0")
		}
	}
}
