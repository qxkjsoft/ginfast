package response

import (
	"gin-fast/app/global/consts"
	"net/http"

	"github.com/gin-gonic/gin"
)

// DefaultResponseHandler 默认响应处理器实现
type DefaultResponseHandler struct{}

// NewResponseHandler 创建新的响应处理器实例
func NewResponseHandler() ResponseHandler {
	return &DefaultResponseHandler{}
}

// DefaultResponseConfig 默认响应配置实现
type DefaultResponseConfig struct{}

// NewResponseConfig 创建新的响应配置实例
func NewResponseConfig() ResponseConfig {
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

func (r *DefaultResponseHandler) ReturnJson(Context *gin.Context, httpCode int, dataCode int, msg string, data interface{}) {

	//Context.Header("key2020","value2020")  	//可以根据实际情况在头部添加额外的其他信息
	Context.JSON(httpCode, gin.H{
		"code": dataCode,
		"msg":  msg,
		"data": data,
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
func (r *DefaultResponseHandler) Fail(c *gin.Context, msg string, data ...interface{}) {
	dataCode := 1
	if len(data) > 0 {
		if code, ok := data[0].(int); ok {
			dataCode = code
		}
	}

	var dataValue interface{} = nil
	if len(data) > 1 {
		dataValue = data[1]
	}

	r.ReturnJson(c, http.StatusBadRequest, dataCode, msg, dataValue)
	c.Abort()
}

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
