---
name: controller
description: 创建控制器时
modeSlugs:
  - code
  - architect
---

# 控制器开发指南

控制器（Controller）负责处理 HTTP 请求，调用服务层处理业务逻辑，并返回响应。

## 目录

- [快速开始](#快速开始)
- [App 目录开发](#app-目录开发)
- [Plugin 目录开发](#plugin-目录开发)
- [最佳实践](#最佳实践)

---

## 快速开始

### 控制器基本结构

```go
package controllers

import (
    "github.com/gin-gonic/gin"
)

// ExampleController 示例控制器
type ExampleController struct {
    Common
}

// NewExampleController 创建示例控制器
func NewExampleController() *ExampleController {
    return &ExampleController{
        Common: Common{},
    }
}
```

### Common 基础控制器

所有控制器都应嵌入 `Common` 结构体，它提供了常用的响应方法：

```go
type Common struct {
}

// Success 返回成功响应
func (c Common) Success(ctx *gin.Context, data ...interface{})

// SuccessWithMessage 返回成功响应并指定消息
func (c Common) SuccessWithMessage(ctx *gin.Context, msg string, data ...interface{})

// Fail 返回失败响应
func (c Common) Fail(ctx *gin.Context, msg string, err error, data ...interface{})

// FailAndAbort 失败并自动终止执行
func (c Common) FailAndAbort(ctx *gin.Context, msg string, err error, data ...interface{})

// GetCurrentUserID 获取当前用户ID
func (c Common) GetCurrentUserID(ctx *gin.Context) uint

// GetCurrentTenantID 获取当前租户ID
func (c Common) GetCurrentTenantID(ctx *gin.Context) uint
```

---

## App 目录开发

### 文件位置

```
app/controllers/
└── example.go
```

### 完整示例

```go
// app/controllers/example.go
package controllers

import (
    "gin-fast/app/models"
    "gin-fast/app/service"

    "github.com/gin-gonic/gin"
)

// ExampleController 示例控制器
type ExampleController struct {
    Common
    service *service.ExampleService
}

// NewExampleController 创建示例控制器
func NewExampleController() *ExampleController {
    return &ExampleController{
        Common:  Common{},
        service: service.NewExampleService(),
    }
}

// Create 创建示例
func (c *ExampleController) Create(ctx *gin.Context) {
    var req models.CreateRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    example, err := c.service.Create(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "创建示例失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "id": example.ID,
    })
}

// Update 更新示例
func (c *ExampleController) Update(ctx *gin.Context) {
    var req models.UpdateRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    err := c.service.Update(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "更新示例失败", err)
        return
    }

    c.SuccessWithMessage(ctx, "更新成功")
}

// Delete 删除示例
func (c *ExampleController) Delete(ctx *gin.Context) {
    var req models.DeleteRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    err := c.service.Delete(ctx, req.ID)
    if err != nil {
        c.FailAndAbort(ctx, "删除示例失败", err)
        return
    }

    c.SuccessWithMessage(ctx, "删除成功", nil)
}

// GetByID 根据ID获取示例信息
func (c *ExampleController) GetByID(ctx *gin.Context) {
    var req models.GetByIDRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    example, err := c.service.GetByID(ctx, req.ID)
    if err != nil {
        c.FailAndAbort(ctx, "示例不存在", err)
        return
    }

    c.Success(ctx, example)
}

// List 示例列表（分页查询）
func (c *ExampleController) List(ctx *gin.Context) {
    var req models.ListRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    exampleList, total, err := c.service.List(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "获取示例列表失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "list":  exampleList,
        "total": total,
    })
}
```

### 在路由中注册

在 [`app/routes/routes.go`](../app/routes/routes.go) 中注册控制器：

```go
// app/routes/routes.go
package routes

import (
    "gin-fast/app/controllers"
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
            // 示例路由组
            example := protected.Group("/example")
            {
                example.POST("/add", exampleControllers.Create)
                example.PUT("/edit", exampleControllers.Update)
                example.DELETE("/delete", exampleControllers.Delete)
                example.GET("/list", exampleControllers.List)
                example.GET("/:id", exampleControllers.GetByID)
            }
        }
    }
}
```

---

## Plugin 目录开发

### 文件位置

```
plugins/
└── example/
    ├── controllers/
    │   └── examplecontroller.go
    ├── models/
    ├── routes/
    └── service/
```

### 完整示例

```go
// plugins/example/controllers/examplecontroller.go
package controllers

import (
    "gin-fast/app/controllers"
    "gin-fast/plugins/example/models"
    "gin-fast/plugins/example/service"

    "github.com/gin-gonic/gin"
)

// ExampleController 示例控制器
type ExampleController struct {
    controllers.Common
    ExampleService *service.ExampleService
}

// NewExampleController 创建示例控制器
func NewExampleController() *ExampleController {
    return &ExampleController{
        Common:         controllers.Common{},
        ExampleService: service.NewExampleService(),
    }
}

// Create 创建示例
func (c *ExampleController) Create(ctx *gin.Context) {
    var req models.CreateRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    example, err := c.ExampleService.Create(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "创建示例失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "id": example.ID,
    })
}

// Update 更新示例
func (c *ExampleController) Update(ctx *gin.Context) {
    var req models.UpdateRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    err := c.ExampleService.Update(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "更新示例失败", err)
        return
    }

    c.SuccessWithMessage(ctx, "更新成功")
}

// Delete 删除示例
func (c *ExampleController) Delete(ctx *gin.Context) {
    var req models.DeleteRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    err := c.ExampleService.Delete(ctx, req.ID)
    if err != nil {
        c.FailAndAbort(ctx, "删除示例失败", err)
        return
    }

    c.SuccessWithMessage(ctx, "删除成功", nil)
}

// GetByID 根据ID获取示例信息
func (c *ExampleController) GetByID(ctx *gin.Context) {
    var req models.GetByIDRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    example, err := c.ExampleService.GetByID(ctx, req.ID)
    if err != nil {
        c.FailAndAbort(ctx, "示例不存在", err)
        return
    }

    c.Success(ctx, example)
}

// List 示例列表（分页查询）
func (c *ExampleController) List(ctx *gin.Context) {
    var req models.ListRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    exampleList, total, err := c.ExampleService.List(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "获取示例列表失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "list":  exampleList,
        "total": total,
    })
}
```

### 在路由中注册

在 `plugins/example/routes/exampleroutes.go` 中注册控制器：

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
            // 示例列表（分页查询）
            example.GET("/list", exampleControllers.List)
            // 根据ID获取示例信息
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
)
```

---

## 最佳实践

### 1. 统一的错误处理

使用 `FailAndAbort` 方法处理错误，它会自动终止请求执行：

```go
func (c *ExampleController) Create(ctx *gin.Context) {
    var req models.CreateRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)  // 自动终止执行
        return  // 这行代码实际上不会执行，但为了代码完整性保留
    }

    example, err := c.service.Create(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "创建示例失败", err)
        return
    }

    c.Success(ctx, gin.H{"id": example.ID})
}
```

### 2. 参数验证

在控制器方法开始时验证参数：

```go
func (c *ExampleController) Update(ctx *gin.Context) {
    var req models.UpdateRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    // 参数验证通过后继续处理
    // ...
}
```

### 3. RESTful API 设计

遵循 RESTful 设计原则：

| 操作 | HTTP 方法 | 路由 | 说明 |
|------|-----------|------|------|
| 创建 | POST | `/api/example/add` | 创建新资源 |
| 更新 | PUT | `/api/example/edit` | 更新资源 |
| 删除 | DELETE | `/api/example/delete` | 删除资源 |
| 获取单个 | GET | `/api/example/:id` | 获取单个资源 |
| 获取列表 | GET | `/api/example/list` | 获取资源列表 |

### 4. 响应格式统一

使用统一的响应格式：

```go
// 成功响应 - 返回数据
c.Success(ctx, gin.H{"id": example.ID})

// 成功响应 - 返回消息
c.SuccessWithMessage(ctx, "更新成功")

// 成功响应 - 返回数据和消息
c.SuccessWithMessage(ctx, "创建成功", gin.H{"id": example.ID})

// 失败响应
c.FailAndAbort(ctx, "创建示例失败", err)
```

### 5. 服务层注入

通过构造函数注入服务层：

```go
type ExampleController struct {
    Common
    service *service.ExampleService
}

func NewExampleController() *ExampleController {
    return &ExampleController{
        Common:  Common{},
        service: service.NewExampleService(),
    }
}
```

### 6. 获取当前用户信息

使用 Common 提供的方法获取当前用户信息：

```go
func (c *ExampleController) GetCurrentUserInfo(ctx *gin.Context) {
    userID := c.GetCurrentUserID(ctx)
    tenantID := c.GetCurrentTenantID(ctx)

    // 使用 userID 和 tenantID
    // ...
}
```

### 7. 分页查询

处理分页查询时返回列表和总数：

```go
func (c *ExampleController) List(ctx *gin.Context) {
    var req models.ListRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    exampleList, total, err := c.service.List(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "获取示例列表失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "list":  exampleList,
        "total": total,
    })
}
```

### 8. Swagger 注释

为控制器方法添加 Swagger 注释：

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

- [`app/controllers/common.go`](../app/controllers/common.go) - Common 基础控制器
- [`app/controllers/user.go`](../app/controllers/user.go) - 用户控制器示例
- [`app/routes/routes.go`](../app/routes/routes.go) - 路由注册示例
- [`plugins/example/controllers/examplecontroller.go`](../plugins/example/controllers/examplecontroller.go) - 插件控制器示例
- [`plugins/example/routes/exampleroutes.go`](../plugins/example/routes/exampleroutes.go) - 插件路由注册示例
