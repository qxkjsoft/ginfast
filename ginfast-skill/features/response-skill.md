---
name: response
description: 处理响应时
modeSlugs:
  - code
  - architect
---

# 响应处理指南

GinFast 提供了统一的响应处理机制，确保 API 响应格式的一致性。

## 目录

- [快速开始](#快速开始)
- [响应格式](#响应格式)
- [成功响应](#成功响应)
- [失败响应](#失败响应)
- [最佳实践](#最佳实践)

---

## 快速开始

### 使用 Common 控制器方法

```go
import "gin-fast/app/controllers"

type ExampleController struct {
    controllers.Common
}

func (c *ExampleController) Create(ctx *gin.Context) {
    // 成功响应
    c.Success(ctx, gin.H{"id": 1})

    // 失败响应
    c.FailAndAbort(ctx, "创建失败", err)
}
```

---

## 响应格式

### 标准响应格式

所有 API 响应都遵循统一的格式：

```json
{
    "code": 0,
    "msg": "success",
    "data": {}
}
```

### 响应字段说明

| 字段 | 类型 | 说明 |
|------|------|------|
| `code` | int | 业务状态码，0 表示成功，非 0 表示失败 |
| `msg` | string | 响应消息 |
| `data` | any | 响应数据 |

---

## 成功响应

### Success 方法

返回成功响应，只传递数据：

```go
func (c *ExampleController) GetByID(ctx *gin.Context) {
    example, err := c.service.GetByID(ctx, id)
    if err != nil {
        c.FailAndAbort(ctx, "查询失败", err)
        return
    }

    c.Success(ctx, example)
}
```

响应：
```json
{
    "code": 0,
    "msg": "success",
    "data": {
        "id": 1,
        "name": "示例名称"
    }
}
```

### SuccessWithMessage 方法

返回成功响应，并指定消息：

```go
func (c *ExampleController) Update(ctx *gin.Context) {
    err := c.service.Update(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "更新失败", err)
        return
    }

    c.SuccessWithMessage(ctx, "更新成功")
}
```

响应：
```json
{
    "code": 0,
    "msg": "更新成功",
    "data": null
}
```

### 返回复杂数据

```go
func (c *ExampleController) List(ctx *gin.Context) {
    list, total, err := c.service.List(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "查询失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "list":  list,
        "total": total,
    })
}
```

响应：
```json
{
    "code": 0,
    "msg": "success",
    "data": {
        "list": [...],
        "total": 100
    }
}
```

---

## 失败响应

### Fail 方法

返回失败响应，但不终止请求：

```go
func (c *ExampleController) SomeMethod(ctx *gin.Context) {
    // 记录错误但继续处理
    c.Fail(ctx, "警告信息", err)

    // 继续处理
    c.Success(ctx, gin.H{"result": "partial"})
}
```

### FailAndAbort 方法

返回失败响应，并终止请求：

```go
func (c *ExampleController) Create(ctx *gin.Context) {
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return  // 这行代码实际上不会执行
    }

    // 参数验证通过后继续处理
}
```

### 自定义状态码

```go
// 使用自定义状态码
c.FailAndAbort(ctx, "业务错误", err, 400, 1001)

// 响应
{
    "code": 1001,
    "msg": "业务错误",
    "data": null
}
```

---

## 响应接口

### Response 接口

```go
// app/global/app/response_interface.go
type ResponseInterface interface {
    Success(ctx *gin.Context, data ...interface{})
    SuccessWithMessage(ctx *gin.Context, msg string, data ...interface{})
    Fail(ctx *gin.Context, msg string, err error, data ...interface{})
}
```

### Response 实现

```go
// app/utils/response/response.go
type Response struct{}

// Success 返回成功响应
func (r *Response) Success(ctx *gin.Context, data ...interface{}) {
    result := gin.H{
        "code": 0,
        "msg":  "success",
    }

    if len(data) > 0 {
        result["data"] = data[0]
    } else {
        result["data"] = nil
    }

    // 支持自定义消息
    if len(data) > 1 {
        if msg, ok := data[1].(string); ok {
            result["msg"] = msg
        }
    }

    // 支持自定义状态码
    if len(data) > 2 {
        if code, ok := data[2].(int); ok {
            result["code"] = code
        }
    }

    ctx.JSON(http.StatusOK, result)
}

// SuccessWithMessage 返回成功响应并指定消息
func (r *Response) SuccessWithMessage(ctx *gin.Context, msg string, data ...interface{}) {
    if len(data) > 0 {
        r.Success(ctx, data[0], msg)
    } else {
        r.Success(ctx, nil, msg)
    }
}

// Fail 返回失败响应
func (r *Response) Fail(ctx *gin.Context, msg string, err error, data ...interface{}) {
    result := gin.H{
        "code": 500,
        "msg":  msg,
    }

    if len(data) > 0 {
        result["data"] = data[0]
    } else {
        result["data"] = nil
    }

    // 支持自定义 HTTP 状态码
    statusCode := http.StatusOK
    if len(data) > 1 {
        if code, ok := data[1].(int); ok {
            statusCode = code
        }
    }

    // 支持自定义业务状态码
    if len(data) > 2 {
        if code, ok := data[2].(int); ok {
            result["code"] = code
        }
    }

    ctx.JSON(statusCode, result)
}
```

---

## 最佳实践

### 1. 统一响应格式

始终使用统一的响应格式：

```go
// 好的做法
c.Success(ctx, gin.H{"id": example.ID})

// 不好的做法
ctx.JSON(http.StatusOK, gin.H{
    "status": "ok",
    "result": gin.H{"id": example.ID},
})
```

### 2. 使用 FailAndAbort 处理错误

对于需要终止请求的错误，使用 `FailAndAbort`：

```go
func (c *ExampleController) Create(ctx *gin.Context) {
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    // 继续处理
}
```

### 3. 提供清晰的错误消息

错误消息应该清晰明确：

```go
// 好的做法
c.FailAndAbort(ctx, "用户名已存在", err)

// 不好的做法
c.FailAndAbort(ctx, "操作失败", err)
```

### 4. 分页响应格式

分页查询返回列表和总数：

```go
func (c *ExampleController) List(ctx *gin.Context) {
    list, total, err := c.service.List(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "查询失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "list":  list,
        "total": total,
    })
}
```

### 5. 成功响应使用 Success

成功响应使用 `Success` 或 `SuccessWithMessage`：

```go
// 返回数据
c.Success(ctx, example)

// 返回消息
c.SuccessWithMessage(ctx, "创建成功")

// 返回数据和消息
c.Success(ctx, gin.H{"id": example.ID}, "创建成功")
```

### 6. HTTP 状态码

默认使用 200 状态码，业务错误通过 `code` 字段区分：

```json
{
    "code": 1001,
    "msg": "业务错误",
    "data": null
}
```

### 7. 记录错误日志

使用 `FailAndAbort` 会自动记录错误日志：

```go
// Common 控制器方法
func (c Common) FailAndAbort(ctx *gin.Context, msg string, err error, data ...interface{}) {
    app.ZapLog.Error(msg, zap.Error(err))
    app.Response.Fail(ctx, msg, data...)
    ctx.Set("error", err)
    ctx.Abort()
    panic(consts.RequestAborted)
}
```

### 8. 处理 RequestAborted panic

在全局中间件中恢复 `RequestAborted` panic：

```go
func RecoveryMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        defer func() {
            if err := recover(); err != nil {
                if err == consts.RequestAborted {
                    // 正常的业务中断，不需要处理
                    return
                }
                // 其他 panic 需要处理
            }
        }()
        c.Next()
    }
}
```

---

## 参考资源

### 项目内部资源

- [`app/controllers/common.go`](../app/controllers/common.go) - Common 控制器
- [`app/utils/response/response.go`](../app/utils/response/response.go) - Response 实现
- [`app/global/app/response_interface.go`](../app/global/app/response_interface.go) - Response 接口
