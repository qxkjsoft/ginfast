package response

import (
	"gin-fast/app/global/consts"
	"net/http"

	"github.com/gin-gonic/gin"
)

func ReturnJson(Context *gin.Context, httpCode int, dataCode int, msg string, data interface{}) {

	//Context.Header("key2020","value2020")  	//可以根据实际情况在头部添加额外的其他信息
	Context.JSON(httpCode, gin.H{
		"code": dataCode,
		"msg":  msg,
		"data": data,
	})
}

// 直接返回成功
func Success(c *gin.Context, data ...interface{}) {
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

	ReturnJson(c, http.StatusOK, 0, msg, dataValue)
}

// 失败的业务逻辑
func Fail(c *gin.Context, msg string, data ...interface{}) {
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

	ReturnJson(c, http.StatusBadRequest, dataCode, msg, dataValue)
	c.Abort()
}

func ErrorSystem(c *gin.Context, msg string, data interface{}) {
	ReturnJson(c, http.StatusInternalServerError, consts.ServerOccurredErrorCode, consts.ServerOccurredErrorMsg+msg, data)
	c.Abort()
}
