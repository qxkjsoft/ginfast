---
name: routes
description: 创建路由时
modeSlugs:
  - code
  - architect
---

# 路由开发指南

路由（Routes）负责定义 API 端点，将 HTTP 请求映射到控制器方法。

## 目录

- [快速开始](#快速开始)
- [App 目录开发](#app-目录开发)
- [Plugin 目录开发](#plugin-目录开发)
- [中间件使用](#中间件使用)
- [最佳实践](#最佳实践)

---

## 快速开始

### 路由基本结构

```go
package routes

import (
    "gin-fast/app/controllers"
    "gin-fast/app/middleware"
    "github.com/gin-gonic/gin"
)

var exampleControllers = controllers.NewExampleController()

func InitRoutes(engine *gin.Engine) {
    api := engine.Group("/api")
    {
        protected := api.Group("")
        protected.Use(middleware.JWTAuthMiddleware())
        protected.Use(middleware.CasbinMiddleware())
        {
            example := protected.Group("/example")
            {
                example.GET("/list", exampleControllers.List)
                example.GET("/:id", exampleControllers.GetByID)
            }
        }
    }
}
```

### RESTful 路由规范

| 操作 | HTTP 方法 | 路由 | 控制器方法 |
|------|-----------|------|-----------|
| 创建 | POST | `/api/example/add` | `Create` |
| 更新 | PUT | `/api/example/edit` | `Update` |
| 删除 | DELETE | `/api/example/delete` | `Delete` |
| 获取单个 | GET | `/api/example/:id` | `GetByID` |
| 获取列表 | GET | `/api/example/list` | `List` |

---

## App 目录开发

### 文件位置

```
app/routes/
└── routes.go
```

### 完整示例

```go
// app/routes/routes.go
package routes

import (
    "gin-fast/app/controllers"
    "gin-fast/app/global/app"
    "gin-fast/app/middleware"

    "github.com/gin-gonic/gin"
    swaggerFiles "github.com/swaggo/files"
    ginSwagger "github.com/swaggo/gin-swagger"
)

// 定义控制器实例
var exampleControllers = controllers.NewExampleController()

// InitRoutes 初始化路由
func InitRoutes(engine *gin.Engine) {
    // 全局跨域中间件
    if app.ConfigYml.GetBool("httpserver.allowcrossdomain") {
        engine.Use(middleware.CorsNext())
    }

    // 静态文件
    engine.Static(app.ConfigYml.GetString("httpserver.serverrootpath"),
                 app.ConfigYml.GetString("httpserver.serverroot"))

    // 调试模式下注册Swagger路由
    if app.ConfigYml.GetBool("server.appdebug") {
        engine.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
    }

    // 全局操作日志中间件
    if app.ConfigYml.GetBool("server.syslog") {
        engine.Use(middleware.OperationLogMiddleware())
    }

    // API路由组
    api := engine.Group("/api")
    {
        // 公开路由
        public := api.Group("")
        {
            public.POST("/login", middleware.CaptchaMiddleware(), authControllers.Login)
            public.POST("/refreshToken", authControllers.RefreshToken)
            public.GET("/captcha/verify", authControllers.GetVerifyImgString)
        }

        // 受保护的路由
        protected := api.Group("")
        protected.Use(middleware.JWTAuthMiddleware())
        protected.Use(middleware.DemoAccountMiddleware())
        protected.Use(middleware.CasbinMiddleware())
        {
            // 示例路由组
            example := protected.Group("/example")
            {
                // 创建示例
                example.POST("/add", exampleControllers.Create)
                // 更新示例
                example.PUT("/edit", exampleControllers.Update)
                // 删除示例
                example.DELETE("/delete", exampleControllers.Delete)
                // 示例列表
                example.GET("/list", exampleControllers.List)
                // 根据ID获取示例
                example.GET("/:id", exampleControllers.GetByID)
            }
        }
    }
}
```

### 路由初始化

在 [`bootstrap/init.go`](../bootstrap/init.go) 中初始化路由：

```go
// bootstrap/init.go
package bootstrap

import (
    "gin-fast/app/routes"
    "github.com/gin-gonic/gin"
)

func Init(engine *gin.Engine) {
    // 初始化路由
    routes.InitRoutes(engine)
}
```

---

## Plugin 目录开发

### 文件位置

```
plugins/
└── example/
    ├── routes/
    │   └── exampleroutes.go
    └── exampleinit.go
```

### 完整示例

```go
// plugins/example/routes/exampleroutes.go
package routes

import (
    "gin-fast/app/global/app"
    "gin-fast/app/middleware"
    "gin-fast/app/utils/ginhelper"
    "gin-fast/plugins/example/controllers"

    "github.com/gin-gonic/gin"
)

func init() {
    var exampleControllers = controllers.NewExampleController()

    // 注册插件路由
    ginhelper.RegisterPluginRoutes(func(engine *gin.Engine) {
        // 示例插件路由组
        example := engine.Group("/api/plugins/example")
        example.Use(middleware.JWTAuthMiddleware())
        example.Use(middleware.DemoAccountMiddleware())
        example.Use(middleware.CasbinMiddleware())
        {
            // 创建示例
            example.POST("/add", exampleControllers.Create)
            // 更新示例
            example.PUT("/edit", exampleControllers.Update)
            // 删除示例
            example.DELETE("/delete", exampleControllers.Delete)
            // 示例列表
            example.GET("/list", exampleControllers.List)
            // 根据ID获取示例
            example.GET("/:id", exampleControllers.GetByID)
        }

        app.ZapLog.Info("示例插件路由注册成功")
    })
}
```

### 插件初始化

在 `plugins/exampleinit.go` 中导入路由：

```go
// plugins/exampleinit.go
package plugins

import (
    _ "gin-fast/plugins/example/routes"
    "gin-fast/plugins/example/scheduler"
)

// 插件初始化时自动执行
func init() {
    // 注册示例执行器
    scheduler.RegisterExampleExecutors()
}
```

---

## 中间件使用

### 全局中间件

在 `InitRoutes` 函数开始时注册全局中间件：

```go
func InitRoutes(engine *gin.Engine) {
    // 全局跨域中间件
    if app.ConfigYml.GetBool("httpserver.allowcrossdomain") {
        engine.Use(middleware.CorsNext())
    }

    // 全局操作日志中间件
    if app.ConfigYml.GetBool("server.syslog") {
        engine.Use(middleware.OperationLogMiddleware())
    }

    // ...
}
```

### 路由组中间件

在路由组上使用中间件：

```go
// 受保护的路由组
protected := api.Group("")
protected.Use(middleware.JWTAuthMiddleware())
protected.Use(middleware.DemoAccountMiddleware())
protected.Use(middleware.CasbinMiddleware())
{
    // 路由定义
}
```

### 单个路由中间件

在单个路由上使用中间件：

```go
// 登录路由使用验证码中间件
public.POST("/login", middleware.CaptchaMiddleware(), authControllers.Login)
```

### 常用中间件

| 中间件 | 说明 | 使用场景 |
|--------|------|---------|
| `JWTAuthMiddleware()` | JWT 认证 | 需要登录的路由 |
| `CasbinMiddleware()` | 权限控制 | 需要权限验证的路由 |
| `DemoAccountMiddleware()` | 演示账号限制 | 演示环境 |
| `CaptchaMiddleware()` | 验证码验证 | 登录、注册等 |
| `CorsNext()` | 跨域处理 | 全局使用 |
| `OperationLogMiddleware()` | 操作日志 | 全局使用 |
| `PasswordValidatorMiddleware()` | 密码验证 | 涉及密码修改的路由 |

---

## 最佳实践

### 1. 路由命名规范

- 使用小写字母和连字符
- 使用复数形式表示资源
- 使用 RESTful 风格

```go
// 好的做法
example.GET("/list", exampleControllers.List)
example.GET("/:id", exampleControllers.GetByID)

// 不好的做法
example.GET("/GetList", exampleControllers.List)
example.GET("/getById", exampleControllers.GetByID)
```

### 2. 路由分组

按功能模块分组路由：

```go
// 用户管理路由组
users := protected.Group("/users")
{
    users.GET("/list", userControllers.List)
    users.GET("/:id", userControllers.GetByID)
    users.POST("/add", userControllers.Create)
    users.PUT("/edit", userControllers.Update)
    users.DELETE("/delete", userControllers.Delete)
}

// 角色管理路由组
roles := protected.Group("/roles")
{
    roles.GET("/list", roleControllers.List)
    roles.GET("/:id", roleControllers.GetByID)
    roles.POST("/add", roleControllers.Create)
    roles.PUT("/edit", roleControllers.Update)
    roles.DELETE("/delete", roleControllers.Delete)
}
```

### 3. 版本控制

为 API 添加版本控制：

```go
// v1 API
v1 := engine.Group("/api/v1")
{
    v1.GET("/users", userControllers.List)
}

// v2 API
v2 := engine.Group("/api/v2")
{
    v2.GET("/users", userControllers.ListV2)
}
```

### 4. 路由变量

使用路由变量获取参数：

```go
// 定义路由
example.GET("/:id", exampleControllers.GetByID)

// 在控制器中获取参数
func (c *ExampleController) GetByID(ctx *gin.Context) {
    id := ctx.Param("id")
    // ...
}
```

### 5. 查询参数

使用查询参数传递过滤条件：

```go
// 定义路由
example.GET("/list", exampleControllers.List)

// 请求示例：/api/example/list?name=test&status=1
func (c *ExampleController) List(ctx *gin.Context) {
    name := ctx.Query("name")
    status := ctx.Query("status")
    // ...
}
```

### 6. 插件路由前缀

插件路由使用 `/api/plugins/插件名` 前缀：

```go
// 插件路由组
example := engine.Group("/api/plugins/example")
{
    example.GET("/list", exampleControllers.List)
}
```

### 7. 路由日志

记录路由注册日志：

```go
func init() {
    ginhelper.RegisterPluginRoutes(func(engine *gin.Engine) {
        example := engine.Group("/api/plugins/example")
        {
            // 路由定义
        }

        app.ZapLog.Info("示例插件路由注册成功")
    })
}
```

### 8. Swagger 注释

为路由添加 Swagger 注释：

```go
// Create 创建示例
// @Summary 创建示例
// @Description 创建一个新的示例
// @Tags 示例管理
// @Accept json
// @Produce json
// @Param request body models.CreateRequest true "创建请求参数"
// @Success 200 {object} map[string]interface{} "成功返回示例ID"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /example/add [post]
// @Security ApiKeyAuth
func (c *ExampleController) Create(ctx *gin.Context) {
    // ...
}
```

---

## 参考资源

### 项目内部资源

- [`app/routes/routes.go`](../app/routes/routes.go) - 路由注册示例
- [`plugins/example/routes/exampleroutes.go`](../plugins/example/routes/exampleroutes.go) - 插件路由注册示例
- [`app/middleware/`](../app/middleware/) - 中间件目录
