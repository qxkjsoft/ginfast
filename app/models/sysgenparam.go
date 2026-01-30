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
	Tables   []string `json:"tables" form:"tables" validate:"required" message:"表名称集合不能为空"` // 表名称集合                                   // 是否覆盖
}

// Validate 验证批量插入请求参数
func (r *SysGenBatchInsertRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// SysGenUpdateRequest 代码生成配置更新请求参数
type SysGenUpdateRequest struct {
	Validator
	ID           uint                       `json:"id" form:"id" validate:"required" message:"ID不能为空"`
	ModuleName   string                     `json:"moduleName" form:"moduleName" validate:"required" message:"模块名称不能为空"` // 模块名称
	FileName     string                     `json:"fileName" form:"fileName" validate:"required" message:"文件名不能为空"`      // 文件名
	Describe     string                     `json:"describe" form:"describe" validate:"required" message:"描述不能为空"`       // 描述
	IsCover      int                        `json:"isCover" form:"isCover" `
	IsMenu       int                        `json:"isMenu" form:"isMenu" `
	FieldUpdates []SysGenFieldUpdateRequest `json:"sysGenFields" form:"sysGenFields" validate:"required" message:"字段更新列表不能为空"` // 字段更新列表
}

// Validate 验证更新请求参数
func (r *SysGenUpdateRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// SysGenFieldUpdateRequest 代码生成字段配置更新请求参数
type SysGenFieldUpdateRequest struct {
	ID          uint   `json:"id" form:"id"`
	DataComment string `json:"dataComment" form:"dataComment"` // 列注释
	CustomName  string `json:"customName" form:"customName"`   // 自定义字段名称
	Require     *int   `json:"require" form:"require" `        // 是否必填
	ListShow    *int   `json:"listShow" form:"listShow" `      // 列表显示
	FormShow    *int   `json:"formShow" form:"formShow" `      // 表单显示
	QueryShow   *int   `json:"queryShow" form:"queryShow" `    // 查询显示
	QueryType   string `json:"queryType" form:"queryType" `    // 查询方式
	FormType    string `json:"formType" form:"formType" `      // 表单类型
	DictType    string `json:"dictType" form:"dictType"`       // 关联的字典
}

// SysGenRefreshFieldsRequest 刷新字段信息请求参数
type SysGenRefreshFieldsRequest struct {
	Validator
	ID uint `json:"id" form:"id" validate:"required" message:"ID不能为空"` // sys_gen配置ID
}

// Validate 验证刷新字段请求参数
func (r *SysGenRefreshFieldsRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}
