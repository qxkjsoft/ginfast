package app

import (
	"encoding/json"
	"os"
	"path/filepath"
)

// VersionInfo 版本信息结构
type VersionInfo struct {
	Name    string `json:"name"`
	Version string `json:"version"`
}

// AppVersion 全局版本信息
var AppVersion VersionInfo

// LoadVersionInfo 从 version.json 加载版本信息
func LoadVersionInfo() error {
	versionPath := filepath.Join(BasePath, "version.json")
	data, err := os.ReadFile(versionPath)
	if err != nil {
		return err
	}
	return json.Unmarshal(data, &AppVersion)
}
