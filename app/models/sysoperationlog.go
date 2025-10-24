package models

import (
	"gin-fast/app/global/app"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysOperationLog 操作日志模型
type SysOperationLog struct {
	BaseModel
	UserID       uint   `gorm:"column:user_id;index;comment:操作用户ID" json:"userId"`
	Username     string `gorm:"column:username;size:50;comment:操作用户名" json:"username"`
	Module       string `gorm:"column:module;size:100;comment:操作模块" json:"module"`
	Operation    string `gorm:"column:operation;size:100;comment:操作类型" json:"operation"`
	Method       string `gorm:"column:method;size:10;comment:请求方法" json:"method"`
	Path         string `gorm:"column:path;size:500;comment:请求路径" json:"path"`
	IP           string `gorm:"column:ip;size:50;comment:客户端IP" json:"ip"`
	UserAgent    string `gorm:"column:user_agent;size:500;comment:用户代理" json:"userAgent"`
	RequestData  string `gorm:"column:request_data;type:text;comment:请求参数" json:"requestData"`
	ResponseData string `gorm:"column:response_data;type:text;comment:响应数据" json:"responseData"`
	StatusCode   int    `gorm:"column:status_code;comment:响应状态码" json:"statusCode"`
	Duration     int64  `gorm:"column:duration;comment:操作耗时(毫秒)" json:"duration"`
	ErrorMsg     string `gorm:"column:error_msg;type:text;comment:错误信息" json:"errorMsg"`
	Location     string `gorm:"column:location;size:100;comment:操作地点" json:"location"`
	TenantID     uint   `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
}

// TableName 设置表名
func (SysOperationLog) TableName() string {
	return "sys_operation_logs"
}

func NewSysOperationLog() *SysOperationLog {
	return &SysOperationLog{}
}

// 操作类型常量
const (
	OperationCreate = "create" // 新增
	OperationUpdate = "update" // 更新
	OperationDelete = "delete" // 删除
	OperationQuery  = "query"  // 查询
	OperationLogin  = "login"  // 登录
	OperationLogout = "logout" // 登出
	OperationExport = "export" // 导出
	OperationImport = "import" // 导入
)

type SysOperationLogList []*SysOperationLog

func NewSysOperationLogList() SysOperationLogList {
	return SysOperationLogList{}
}

func (list *SysOperationLogList) Find(c *gin.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(c).Scopes(funcs...).Find(list).Error
}

func (list *SysOperationLogList) GetTotal(c *gin.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var total int64
	err := app.DB().WithContext(c).Model(&SysOperationLog{}).Scopes(query...).Count(&total).Error
	return total, err
}
