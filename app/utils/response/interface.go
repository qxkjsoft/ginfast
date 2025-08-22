package response

import "github.com/gin-gonic/gin"

// ResponseHandler 定义响应处理器接口
type ResponseHandler interface {
	// ReturnJson 返回JSON格式的响应
	// Context: gin上下文
	// httpCode: HTTP状态码
	// dataCode: 业务状态码
	// msg: 响应消息
	// data: 响应数据
	ReturnJson(Context *gin.Context, httpCode int, dataCode int, msg string, data interface{})

	// Success 返回成功响应
	// c: gin上下文
	// data: 可选参数，第一个参数为响应数据，第二个参数为消息
	Success(c *gin.Context, data ...interface{})

	// Fail 返回失败响应
	// c: gin上下文
	// msg: 错误消息
	// data: 可选参数，第一个参数为错误代码，第二个参数为响应数据
	Fail(c *gin.Context, msg string, data ...interface{})

	// ErrorSystem 返回系统错误响应
	// c: gin上下文
	// msg: 错误消息
	// data: 响应数据
	ErrorSystem(c *gin.Context, msg string, data interface{})
}

// JsonResponse 定义JSON响应结构
type JsonResponse struct {
	Code int         `json:"code"`
	Msg  string      `json:"msg"`
	Data interface{} `json:"data"`
}

// ResponseConfig 响应配置接口
type ResponseConfig interface {
	// GetSuccessCode 获取成功状态码
	GetSuccessCode() int

	// GetFailCode 获取失败状态码
	GetFailCode() int

	// GetSystemErrorCode 获取系统错误状态码
	GetSystemErrorCode() int
}
