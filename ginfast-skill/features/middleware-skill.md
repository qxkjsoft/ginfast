---
name: middleware
description: 创建中间件时
modeSlugs:
  - code
  - architect
---

# 中间件开发指南

中间件（Middleware）是在请求处理前后执行的函数，用于实现跨切面的功能，如认证、日志、权限控制等。

## 目录

- [快速开始](#快速开始)
- [内置中间件](#内置中间件)
- [自定义中间件](#自定义中间件)
- [最佳实践](#最佳实践)

---

## 快速开始

### 中间件基本结构

```go
package middleware

import (
    "github.com/gin-gonic/gin"
)

// ExampleMiddleware 示例中间件
func ExampleMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        // 请求处理前的逻辑
        println("请求处理前")

        // 调用下一个中间件/处理器
        c.Next()

        // 请求处理后的逻辑
        println("请求处理后")
    }
}
```

### 使用中间件

```go
// 全局使用
engine.Use(middleware.ExampleMiddleware())

// 路由组使用
protected := engine.Group("/api")
protected.Use(middleware.ExampleMiddleware())

// 单个路由使用
engine.GET("/example", middleware.ExampleMiddleware(), handler)
```

---

## 内置中间件

### JWT 认证中间件

验证用户的 JWT Token：

```go
// app/middleware/jwt.go
func JWTAuthMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        tokenString, err := common.GetAccessToken(c)
        if err != nil {
            c.JSON(http.StatusUnauthorized, gin.H{"message": err.Error()})
            c.Abort()
            return
        }

        claims, err := app.TokenService.ValidateTokenWithCache(tokenString)
        if err != nil {
            c.JSON(http.StatusUnauthorized, gin.H{"message": err.Error()})
            c.Abort()
            return
        }

        c.Set(consts.BindContextKeyName, claims)
        c.Next()
    }
}
```

### Casbin 权限中间件

使用 Casbin 进行权限控制：

```go
// app/middleware/casbin.go
func CasbinMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        claims := common.GetClaims(c)
        if claims == nil {
            c.JSON(http.StatusUnauthorized, gin.H{"message": "未授权"})
            c.Abort()
            return
        }

        // 跳过权限检查的用户
        if common.IsSkipAuthUser(claims.UserID) {
            c.Next()
            return
        }

        // 获取请求路径和方法
        path := c.Request.URL.Path
        method := c.Request.Method

        // 检查权限
        ok, err := app.Casbin.Enforce(claims.UserID, path, method)
        if err != nil || !ok {
            c.JSON(http.StatusForbidden, gin.H{"message": "无权限访问"})
            c.Abort()
            return
        }

        c.Next()
    }
}
```

### 跨域中间件

处理 CORS 跨域请求：

```go
// app/middleware/cors.go
func CorsNext() gin.HandlerFunc {
    return func(c *gin.Context) {
        method := c.Request.Method
        origin := c.Request.Header.Get("Origin")

        c.Header("Access-Control-Allow-Origin", origin)
        c.Header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE, UPDATE")
        c.Header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization")
        c.Header("Access-Control-Expose-Headers", "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Cache-Control, Content-Language, Content-Type")
        c.Header("Access-Control-Allow-Credentials", "true")

        if method == "OPTIONS" {
            c.AbortWithStatus(http.StatusNoContent)
            return
        }

        c.Next()
    }
}
```

### 验证码中间件

验证图形验证码：

```go
// app/middleware/captcha.go
func CaptchaMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        captchaId := c.PostForm("captchaId")
        verifyValue := c.PostForm("verifyValue")

        if captchaId == "" || verifyValue == "" {
            c.JSON(http.StatusBadRequest, gin.H{"message": "验证码不能为空"})
            c.Abort()
            return
        }

        if !captchahelper.Verify(captchaId, verifyValue, true) {
            c.JSON(http.StatusBadRequest, gin.H{"message": "验证码错误"})
            c.Abort()
            return
        }

        c.Next()
    }
}
```

### 演示账号中间件

限制演示账号的操作：

```go
// app/middleware/demoaccount.go
func DemoAccountMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        claims := common.GetClaims(c)
        if claims != nil && common.IsDemoUser(claims.UserID) {
            method := c.Request.Method
            // 演示账号只能执行 GET 和 POST 请求
            if method != "GET" && method != "POST" {
                c.JSON(http.StatusForbidden, gin.H{"message": "演示账号只能执行查询操作"})
                c.Abort()
                return
            }
        }
        c.Next()
    }
}
```

### 操作日志中间件

记录用户操作日志：

```go
// app/middleware/operationlog.go
func OperationLogMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        // 记录请求开始时间
        start := time.Now()

        // 处理请求
        c.Next()

        // 请求处理完成后记录日志
        duration := time.Since(start)
        status := c.Writer.Status()

        // 记录操作日志
        logOperation(c, start, duration, status)
    }
}
```

### 超时中间件

设置请求超时时间：

```go
// app/middleware/timeout.go
func TimeoutMiddleware(timeout time.Duration) gin.HandlerFunc {
    return func(c *gin.Context) {
        // 设置超时上下文
        ctx, cancel := context.WithTimeout(c.Request.Context(), timeout)
        defer cancel()

        // 替换请求上下文
        c.Request = c.Request.WithContext(ctx)

        finished := make(chan struct{})
        go func() {
            defer close(finished)
            c.Next()
        }()

        select {
        case <-finished:
            // 正常完成
        case <-ctx.Done():
            // 超时
            c.JSON(http.StatusRequestTimeout, gin.H{"message": "请求超时"})
            c.Abort()
        }
    }
}
```

---

## 自定义中间件

### 创建自定义中间件

```go
// app/middleware/custom.go
package middleware

import (
    "github.com/gin-gonic/gin"
)

// CustomMiddleware 自定义中间件
func CustomMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        // 1. 请求处理前的逻辑

        // 获取请求信息
        path := c.Request.URL.Path
        method := c.Request.Method

        // 业务逻辑
        // ...

        // 2. 调用下一个中间件/处理器
        c.Next()

        // 3. 请求处理后的逻辑

        // 获取响应状态
        status := c.Writer.Status()

        // 业务逻辑
        // ...
    }
}
```

### 带参数的中间件

```go
// 带参数的中间件工厂函数
func CustomMiddlewareWithParam(param string) gin.HandlerFunc {
    return func(c *gin.Context) {
        // 使用参数
        println("参数:", param)

        c.Next()
    }
}

// 使用
engine.Use(CustomMiddlewareWithParam("value"))
```

### 条件中间件

根据条件决定是否执行中间件：

```go
func ConditionalMiddleware(condition func(*gin.Context) bool) gin.HandlerFunc {
    return func(c *gin.Context) {
        if !condition(c) {
            // 不满足条件，跳过中间件
            c.Next()
            return
        }

        // 满足条件，执行中间件逻辑
        // ...
        c.Next()
    }
}
```

---

## 最佳实践

### 1. 中间件执行顺序

中间件按照注册顺序执行：

```go
engine.Use(middleware1())  // 第1个执行
engine.Use(middleware2())  // 第2个执行
engine.Use(middleware3())  // 第3个执行

// 执行顺序：middleware1 -> middleware2 -> middleware3 -> handler
```

### 2. 使用 c.Next()

使用 `c.Next()` 将控制权传递给下一个中间件：

```go
func GoodMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        // 前置逻辑
        println("前置")

        c.Next()  // 调用下一个中间件

        // 后置逻辑
        println("后置")
    }
}
```

### 3. 使用 c.Abort()

使用 `c.Abort()` 终止请求处理：

```go
func AuthMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        if !isAuthenticated(c) {
            c.JSON(http.StatusUnauthorized, gin.H{"message": "未授权"})
            c.Abort()  // 终止请求
            return
        }
        c.Next()
    }
}
```

### 4. 中间件中设置值

使用 `c.Set()` 和 `c.Get()` 在中间件间传递数据：

```go
// 设置值
func SetMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        c.Set("user", "john")
        c.Next()
    }
}

// 获取值
func GetMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        if user, exists := c.Get("user"); exists {
            println(user.(string))
        }
        c.Next()
    }
}
```

### 5. 错误处理

在中间件中处理错误：

```go
func ErrorHandlingMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        c.Next()

        // 检查是否有错误
        if len(c.Errors) > 0 {
            // 处理错误
            err := c.Errors.Last()
            println("错误:", err.Error())
        }
    }
}
```

### 6. 性能监控

记录请求处理时间：

```go
func PerformanceMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()

        c.Next()

        duration := time.Since(start)
        println("请求耗时:", duration)
    }
}
```

### 7. 恢复 Panic

使用 `gin.Recovery()` 恢复 panic：

```go
engine.Use(gin.Recovery())
```

### 8. 中间件组合

将多个中间件组合使用：

```go
// 创建中间件链
func AuthAndPermissionMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        // 先认证
        if !isAuthenticated(c) {
            c.JSON(http.StatusUnauthorized, gin.H{"message": "未授权"})
            c.Abort()
            return
        }

        // 再授权
        if !hasPermission(c) {
            c.JSON(http.StatusForbidden, gin.H{"message": "无权限"})
            c.Abort()
            return
        }

        c.Next()
    }
}
```

---

## 参考资源

### 项目内部资源

- [`app/middleware/jwt.go`](../app/middleware/jwt.go) - JWT 认证中间件
- [`app/middleware/casbin.go`](../app/middleware/casbin.go) - Casbin 权限中间件
- [`app/middleware/cors.go`](../app/middleware/cors.go) - 跨域中间件
- [`app/middleware/captcha.go`](../app/middleware/captcha.go) - 验证码中间件
- [`app/middleware/demoaccount.go`](../app/middleware/demoaccount.go) - 演示账号中间件
- [`app/middleware/operationlog.go`](../app/middleware/operationlog.go) - 操作日志中间件
- [`app/middleware/timeout.go`](../app/middleware/timeout.go) - 超时中间件
