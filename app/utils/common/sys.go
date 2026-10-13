package common

import (
	"gin-fast/app/global/app"
	"net/http"
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
// 命中 server.notcheckuser 列表，或 server.initadmin.enabled=true 时等于 initadmin.id（超管初始化期间自动豁免）
func IsSkipAuthUser(userID uint) bool {
	if userID == 0 {
		return false
	}
	notCheckUsers := app.ConfigYml.GetUintSlice("server.notcheckuser")
	for _, id := range notCheckUsers {
		if userID == id {
			return true
		}
	}
	if app.ConfigYml.GetBool("server.initadmin.enabled") && userID == uint(app.ConfigYml.GetInt("server.initadmin.id")) {
		return true
	}
	return false
}

// selfServiceAPIs 自服务接口白名单：这些接口在控制器内部强制只操作当前登录用户本人数据
// （如个人中心的查看/修改个人信息、改密码、传头像，不接受外部用户ID参数），无越权面。
// 个人中心属于全员基础功能，任何已登录用户都应可用，不依赖角色菜单授权（前端右上角入口为硬编码跳转，
// 若按角色挂菜单鉴权，角色漏配隐藏菜单时页面即不可用）。
var selfServiceAPIs = map[string]string{
	"/api/users/profile":         http.MethodGet,
	"/api/users/updateAccount":   http.MethodPut,
	"/api/users/updateBasicInfo": http.MethodPut,
	"/api/users/uploadAvatar":    http.MethodPost,
}

// IsSelfServiceAPI 判断请求是否为自服务接口（路径与方法均精确匹配才算命中）
func IsSelfServiceAPI(path, method string) bool {
	return selfServiceAPIs[path] == method
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
// 未被使用
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

// KeepLettersPathAndUnderscoreLower 只保留字符串中的英文字母、下划线和路径分隔符 "/"，并且全部转换为小写。
// 同时规范化路径：去除首尾 "/"，合并连续的 "//"，丢弃空段。
// 例如: "Test/Admin_Foo" -> "test/admin_foo", "//a//b//" -> "a/b"
func KeepLettersPathAndUnderscoreLower(s string) string {
	var result strings.Builder
	result.Grow(len(s))

	for _, r := range s {
		if (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z') || r == '_' || r == '/' {
			result.WriteRune(unicode.ToLower(r))
		}
	}

	// 规范化路径：合并连续的 "/"，去除首尾 "/"
	parts := strings.Split(result.String(), "/")
	var validParts []string
	for _, part := range parts {
		if part != "" {
			validParts = append(validParts, part)
		}
	}
	return strings.Join(validParts, "/")
}

// KeepLettersAndPathLower 只保留字符串中的英文字母和路径分隔符 "/"，并且全部转换为小写。
// 同时规范化路径：去除首尾 "/"，合并连续的 "//"，丢弃空段。
// 例如: "Test/Admin" -> "test/admin", "//a//b//" -> "a/b"
func KeepLettersAndPathLower(s string) string {
	var result strings.Builder
	result.Grow(len(s))

	for _, r := range s {
		if (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z') || r == '/' {
			result.WriteRune(unicode.ToLower(r))
		}
	}

	// 规范化路径：合并连续的 "/"，去除首尾 "/"
	parts := strings.Split(result.String(), "/")
	var validParts []string
	for _, part := range parts {
		if part != "" {
			validParts = append(validParts, part)
		}
	}
	return strings.Join(validParts, "/")
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
