package models

// PluginImportRequest 插件导入请求参数
type PluginImportRequest struct {
	OverwriteDB         bool `form:"overwriteDB"`         // 是否导入并覆盖数据库
	OverwriteFiles      bool `form:"overwriteFiles"`      // 是否导入并覆盖文件
	ImportMenu          bool `form:"importMenu"`          // 是否导入菜单
	CheckExist          bool `form:"checkExist"`          // 是否检查文件及数据库
	ConfirmDangerousSQL bool `form:"confirmDangerousSQL"` // 已确认database.sql中的危险语句，允许继续执行
	UserID              uint // 当前用户ID
}

// SQLDangerInfo database.sql 中检测到的危险语句信息
type SQLDangerInfo struct {
	Index     int    `json:"index"`     // 语句序号（从1开始）
	Keyword   string `json:"keyword"`   // 命中的危险关键字
	Reason    string `json:"reason"`    // 危险原因说明
	Statement string `json:"statement"` // 语句内容预览（超长截断）
}

// PluginImportResponse 插件导入响应参数
type PluginImportResponse struct {
	ExistingPaths  []string       `json:"existingPaths"`  // 已存在的路径列表
	ExistingTables []string       `json:"existingTables"` // 已存在的数据库表列表
	DangerousSQLs  []SQLDangerInfo `json:"dangerousSQLs"` // database.sql中检测到的危险语句列表
	IsWarning      bool           `json:"isWarning"`      // 是否存在警告
}

func (r *PluginImportResponse) IsEmpty() bool {
	if r == nil {
		return true
	}
	return len(r.ExistingPaths) == 0 && len(r.ExistingTables) == 0 && len(r.DangerousSQLs) == 0
}
