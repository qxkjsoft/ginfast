package middleware

import (
	"bytes"
	"encoding/json"
	"gin-fast/app/global/app"
	"io"

	"github.com/dchest/captcha"
	"github.com/gin-gonic/gin"
)

// CaptchaMiddleware 验证码验证中间件
func CaptchaMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		if !app.ConfigYml.GetBool("Captcha.open") {
			c.Next()
			return
		}
		// 从请求中获取验证码ID和验证码值
		captchaId := c.Query("captchaId")
		if captchaId == "" {
			captchaId = c.PostForm("captchaId")
		}

		captchaValue := c.Query("captchaValue")
		if captchaValue == "" {
			captchaValue = c.PostForm("captchaValue")
		}

		// 如果URL参数和表单数据中没有找到，尝试从JSON body中获取
		if captchaId == "" || captchaValue == "" {
			// 使用GetRawData获取原始数据，避免消耗request body
			rawData, err := c.GetRawData()
			if err == nil && len(rawData) > 0 {
				var jsonBody map[string]interface{}
				if err := json.Unmarshal(rawData, &jsonBody); err == nil {
					if captchaId == "" {
						if val, ok := jsonBody["captchaId"].(string); ok {
							captchaId = val
						}
					}
					if captchaValue == "" {
						if val, ok := jsonBody["captchaValue"].(string); ok {
							captchaValue = val
						}
					}
				}
				// 将原始数据重新设置回request body，以便后续中间件使用
				c.Request.Body = io.NopCloser(bytes.NewBuffer(rawData))
			}
		}

		// 检查验证码ID和值是否为空
		if captchaId == "" || captchaValue == "" {
			app.Response.Fail(c, "验证码ID和验证码值不能为空")
			c.Abort()
			return
		}

		// 验证验证码
		if !captcha.VerifyString(captchaId, captchaValue) {
			app.Response.Fail(c, "验证码错误")
			c.Abort()
			return
		}

		// 验证通过，继续处理请求
		c.Next()
	}
}
