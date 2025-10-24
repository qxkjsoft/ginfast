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
		if claims != nil && claims.TenantID > 0 {
			// 只对包含tenant_id字段的表添加过滤条件
			// 这里可以根据实际需要调整，或者为每个表单独处理
			return db.Where("tenant_id = ?", claims.TenantID)
		}
		return db
	}
}
