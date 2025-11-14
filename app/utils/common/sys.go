package common

import (
	"gin-fast/app/global/app"
	"regexp"
	"strings"
	"unicode"
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

// KeepLettersOnly 只保留字符串中的英文字母和下划线，并且全部转换为小写
func KeepLettersOnly(s string) string {
	var result strings.Builder
	result.Grow(len(s))

	for _, r := range s {
		if (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z') || r == '_' {
			result.WriteRune(unicode.ToLower(r))
		}
	}
	return result.String()
}

// KeepLettersOnlyLower 只保留字符串中的英文字母，并且全部转换为小写
func KeepLettersOnlyLower(s string) string {
	var result strings.Builder
	result.Grow(len(s))

	for _, r := range s {
		if (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z') {
			result.WriteRune(unicode.ToLower(r))
		}
	}
	return result.String()
}

// ToCamelCase 将字符串转换为驼峰命名， 首字母大写
func ToCamelCase(str string) string {
	if str == "" {
		return ""
	}

	var result strings.Builder
	words := strings.Split(str, "_")
	for _, word := range words {
		if word == "" {
			continue
		}
		result.WriteString(strings.ToUpper(word[:1]))
		if len(word) > 1 {
			result.WriteString(word[1:])
		}
	}

	return result.String()
}

// ToCamelCaseLower 将字符串转换为小驼峰命名， 首字母小写
func ToCamelCaseLower(str string) string {
	if str == "" {
		return ""
	}

	camel := ToCamelCase(str)
	// 确保首字母小写，其余保持原样
	return strings.ToLower(camel[:1]) + camel[1:]
}
