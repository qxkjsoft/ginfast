package middleware

import (
	"net/http"
	"regexp"
	"strconv"
	"strings"

	"gin-fast/app/global/app"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
)

// PasswordValidatorMiddleware 密码验证中间件
func PasswordValidatorMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 获取配置中的密码安全设置
		minPasswordLength := app.ConfigYml.GetInt("safe.minpasswordlength")
		requireSpecialChar := app.ConfigYml.GetBool("safe.requirespecialchar")

		// 获取请求方法
		method := c.Request.Method

		// 根据请求方法获取参数
		var password string
		if method == "POST" || method == "PUT" {
			// PUT请求，优先从form中获取
			password = c.PostForm("password")
			if password == "" {
				// 如果form中没有获取到，再从body中获取
				// 使用ShouldBindBodyWith避免消耗请求体，确保后续处理器可以正常读取
				contentType := c.GetHeader("Content-Type")
				// 检查Content-Type是否包含application/json（可能带有charset等参数）
				if strings.Contains(contentType, "application/json") {
					var jsonData map[string]interface{}
					if err := c.ShouldBindBodyWith(&jsonData, binding.JSON); err == nil {
						if pwd, ok := jsonData["password"].(string); ok {
							password = pwd
						}
					}
				}
			}
		}

		// 如果没有获取到密码，则跳过验证（可能是不需要密码的操作）
		if password == "" {
			c.Next()
			return
		}

		// 验证密码长度
		if len(password) < minPasswordLength {
			c.JSON(http.StatusBadRequest, gin.H{
				"code":    400,
				"message": "密码长度不能少于" + strconv.Itoa(minPasswordLength) + "位",
			})
			c.Abort()
			return
		}

		// 如果配置要求特殊字符，则验证密码是否包含特殊字符
		if requireSpecialChar {
			// 定义特殊字符正则表达式
			specialCharRegex := regexp.MustCompile(`[!@#$%]`)
			if !specialCharRegex.MatchString(password) {
				c.JSON(http.StatusBadRequest, gin.H{
					"code":    400,
					"message": "密码必须包含特殊字符 !@#$%",
				})
				c.Abort()
				return
			}
		}

		c.Next()
	}
}
