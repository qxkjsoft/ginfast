package response

import (
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"
	"net/http"

	"github.com/gin-gonic/gin"
)

// DefaultResponseHandler 默认响应处理器实现
type DefaultResponseHandler struct{}

// NewResponseHandler 创建新的响应处理器实例
func NewResponseHandler() app.ResponseHandler {
	return &DefaultResponseHandler{}
}

// DefaultResponseConfig 默认响应配置实现
type DefaultResponseConfig struct{}

// NewResponseConfig 创建新的响应配置实例
func NewResponseConfig() app.ResponseConfig {
	return &DefaultResponseConfig{}
}

func (r *DefaultResponseConfig) GetSuccessCode() int {
	return 0
}

func (r *DefaultResponseConfig) GetFailCode() int {
	return 1
}

func (r *DefaultResponseConfig) GetSystemErrorCode() int {
	return consts.ServerOccurredErrorCode
}

// ReturnJson 自定义返回JSON格式
// Context *gin.Context 上下文对象
// httpCode int HTTP状态码
// dataCode int 业务逻辑状态码
// msg string 业务逻辑消息
// data interface{} 业务逻辑数据
func (r *DefaultResponseHandler) ReturnJson(Context *gin.Context, httpCode int, dataCode int, msg string, data interface{}) {

	//Context.Header("key2020","value2020")  	//可以根据实际情况在头部添加额外的其他信息
	Context.JSON(httpCode, gin.H{
		"code":    dataCode,
		"message": msg,
		"data":    data,
	})
}

// Success 直接返回成功
func (r *DefaultResponseHandler) Success(c *gin.Context, data ...interface{}) {
	var dataValue interface{} = nil
	if len(data) > 0 {
		dataValue = data[0]
	}

	var msg string
	if len(data) > 1 {
		if msgValue, ok := data[1].(string); ok {
			msg = msgValue
		}
	}

	r.ReturnJson(c, http.StatusOK, 0, msg, dataValue)
}

// Fail 失败的业务逻辑
// data第一个元素为HTTP状态码(可选，默认为http.StatusBadRequest, 其他常用如:参数验证失败 → 422, 权限不足 → 403 ,资源不存在 → 404， 服务器内部错误 → 500)
// data第二个元素为业务逻辑状态码
// data第三个元素为业务逻辑的数据
func (r *DefaultResponseHandler) Fail(c *gin.Context, msg string, data ...interface{}) {
	httpCode := http.StatusBadRequest // 请求参数格式错误
	dataCode := 1
	var dataValue interface{} = nil

	if len(data) > 0 {
		if code, ok := data[0].(int); ok {
			httpCode = code
		}
	}

	if len(data) > 1 {
		if code, ok := data[1].(int); ok {
			dataCode = code
		}
	}

	if len(data) > 2 {
		dataValue = data[2]
	}

	r.ReturnJson(c, httpCode, dataCode, msg, dataValue)
	c.Abort()
}

// ErrorSystem 系统错误
func (r *DefaultResponseHandler) ErrorSystem(c *gin.Context, msg string, data interface{}) {
	r.ReturnJson(c, http.StatusInternalServerError, consts.ServerOccurredErrorCode, consts.ServerOccurredErrorMsg+msg, data)
	c.Abort()
}

// 为了保持向后兼容，提供全局函数
var defaultHandler = NewResponseHandler()

// ReturnJson 全局函数，保持向后兼容
func ReturnJson(Context *gin.Context, httpCode int, dataCode int, msg string, data interface{}) {
	defaultHandler.ReturnJson(Context, httpCode, dataCode, msg, data)
}

// Success 全局函数，保持向后兼容
func Success(c *gin.Context, data ...interface{}) {
	defaultHandler.Success(c, data...)
}

// Fail 全局函数，保持向后兼容
func Fail(c *gin.Context, msg string, data ...interface{}) {
	defaultHandler.Fail(c, msg, data...)
}

// ErrorSystem 全局函数，保持向后兼容
func ErrorSystem(c *gin.Context, msg string, data interface{}) {
	defaultHandler.ErrorSystem(c, msg, data)
}
