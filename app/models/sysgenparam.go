package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysGenListRequest 代码生成配置列表请求参数
type SysGenListRequest struct {
	BasePaging
	Validator
	Name       string `json:"name" form:"name"`             // 表名
	ModuleName string `json:"moduleName" form:"moduleName"` // 模块名称
}

// Validate 验证请求参数
func (r *SysGenListRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// Handle 获取查询条件
func (r *SysGenListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.Name != "" {
			db = db.Where("name LIKE ?", "%"+r.Name+"%")
		}
		if r.ModuleName != "" {
			db = db.Where("module_name LIKE ?", "%"+r.ModuleName+"%")
		}
		return db
	}
}

// SysGenBatchInsertRequest 批量插入代码生成配置请求参数
type SysGenBatchInsertRequest struct {
	Validator
	Database string   `json:"database" form:"database"`                                     // 数据库名称
	Tables   []string `json:"tables" form:"tables" validate:"required" message:"表名称集合不能为空"` // 表名称集合
}

// Validate 验证批量插入请求参数
func (r *SysGenBatchInsertRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}
