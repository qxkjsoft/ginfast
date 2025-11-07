package common

import (
	"gin-fast/app/global/app"
	"regexp"
)

// convertPathToWildcard 将路径中的参数（如 :roleId）转换为通配符 *
func ConvertPathToWildcard(path string) string {
	// 使用正则表达式匹配 :param 格式的参数
	re := regexp.MustCompile(`:[^/]+`)
	return re.ReplaceAllString(path, "*")
}

// 是否是需要跳过权限检查的用户
func IsSkipAuthUser(userID uint) bool {
	notCheckUsers := app.ConfigYml.GetUintSlice("server.notcheckuser")
	for _, id := range notCheckUsers {
		if userID == id {
			return true
		}
	}
	return false
}
