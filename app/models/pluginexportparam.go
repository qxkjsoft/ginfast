package models

// PluginImportRequest 插件导入请求参数
type PluginImportRequest struct {
	OverwriteDB    bool `form:"overwriteDB"`    // 是否导入并覆盖数据库
	OverwriteFiles bool `form:"overwriteFiles"` // 是否导入并覆盖文件
	ImportMenu     bool `form:"importMenu"`     // 是否导入菜单
	CheckExist     bool `form:"checkExist"`     // 是否检查文件及数据库
	UserID         uint // 当前用户ID
}

// PluginImportResponse 插件导入响应参数
type PluginImportResponse struct {
	ExistingPaths  []string `json:"existingPaths"`  // 已存在的路径列表
	ExistingTables []string `json:"existingTables"` // 已存在的数据库表列表
	IsWarning      bool     `json:"isWarning"`      // 是否存在警告
}

func (r *PluginImportResponse) IsEmpty() bool {
	return len(r.ExistingPaths) == 0 && len(r.ExistingTables) == 0
}
