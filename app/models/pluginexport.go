package models

// PluginMenu 插件菜单项
type PluginMenu struct {
	Path string `json:"path"`
	Type int    `json:"type"`
}

// PluginExport 插件导出配置（用于解析plugin_export.json）
type PluginExport struct {
	Name               string            `json:"name"`
	Version            string            `json:"version"`
	Description        string            `json:"description"`
	Author             string            `json:"author"`
	Email              string            `json:"email"`
	Url                string            `json:"url"`
	Dependencies       map[string]string `json:"dependencies"`
	ExportDirs         []string          `json:"exportDirs"`
	ExportDirsFrontend []string          `json:"exportDirsFrontend"`
	Menus              []PluginMenu      `json:"menus"`
	DatabaseTable      []string          `json:"databaseTable"`
	FolderName         string            `json:"folderName"`
}
