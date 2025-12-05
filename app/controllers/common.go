package controllers

import (
	"errors"
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type Common struct {
}

// Fail 返回失败响应，支持可变参数：第一个参数为HTTP状态码（默认400）, 第二个参数为业务状态码, 第三个参数为响应数据
func (c Common) Fail(ctx *gin.Context, msg string, err error, data ...interface{}) {
	app.ZapLog.Error("请求失败", zap.Error(err))
	app.Response.Fail(ctx, msg, data...)
}

// FailAndAbort 失败并自动终止执行，无需手动 return ，支持可变参数：第一个参数为HTTP状态码（默认400）, 第二个参数为业务状态码, 第三个参数为响应数据
func (c Common) FailAndAbort(ctx *gin.Context, msg string, err error, data ...interface{}) {
	app.ZapLog.Error(msg, zap.Error(err))
	app.Response.Fail(ctx, msg, data...)
	if err != nil {
		ctx.Set("error", err)
	} else {
		ctx.Set("error", errors.New(msg))
	}
	// 使用 Gin 的 Abort 方法终止请求处理链
	ctx.Abort()
	// 使用 panic 终止当前函数执行
	panic(consts.RequestAborted)
}

// Success 返回成功响应，支持可变参数：第一个参数为响应数据，第二个参数为消息, 第三个参数为业务逻辑状态码
func (c Common) Success(ctx *gin.Context, data ...interface{}) {
	app.Response.Success(ctx, data...)
}

// SuccessWithMessage 返回成功响应并指定消息，支持可变参数：第一个参数为响应数据，第二个参数为业务逻辑状态码
func (c Common) SuccessWithMessage(ctx *gin.Context, msg string, data ...interface{}) {
	if len(data) > 0 {
		code := 0
		if len(data) > 1 {
			if codeValue, ok := data[1].(int); ok {
				code = codeValue
			}
		}
		app.Response.Success(ctx, data[0], msg, code)
	} else {
		app.Response.Success(ctx, nil, msg)
	}
}
