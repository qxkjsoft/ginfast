---
name: plugin-dev
description: 开发插件时
modeSlugs:
  - code
  - architect
---

# 插件开发完整指南

GinFast 支持完整的插件系统，可以独立开发、打包、导入、导出插件。

## 目录

- [快速开始](#快速开始)
- [插件结构](#插件结构)
- [插件配置](#插件配置)
- [插件开发](#插件开发)
- [插件打包](#插件打包)
- [插件导入](#插件导入)
- [最佳实践](#最佳实践)

---

## 快速开始

### 1. 创建插件目录

在 `plugins/` 目录下创建插件文件夹：

```
plugins/
└── myplugin/
```

### 2. 创建插件配置文件

创建 `plugin_export.json`：

```json
{
    "name": "myplugin",
    "version": "1.0.0",
    "description": "我的插件",
    "author": "yourname",
    "email": "your@email.com",
    "url": "https://example.com",
    "dependencies": {
        "ginfast-tenant": "^1.0.0"
    },
    "exportDirs": [
        "plugins/myplugin/",
        "plugins/myplugininit.go"
    ],
    "exportDirsFrontend": [
        "src/plugins/myplugin/"
    ],
    "menus": [
        {
            "path": "/myplugin",
            "type": 1
        }
    ],
    "databaseTable": [
        "plugin_myplugin"
    ]
}
```

### 3. 创建插件初始化文件

创建 `plugins/myplugininit.go`：

```go
package plugins

import (
    _ "gin-fast/plugins/myplugin/routes"
)
```

---

## 插件结构

### 完整插件结构

```
plugins/
└── myplugin/
    ├── controllers/           # 控制器
    │   └── myplugincontroller.go
    ├── models/               # 模型
    │   ├── myplugin.go
    │   └── mypluginparam.go
    ├── routes/               # 路由
    │   └── mypluginroutes.go
    ├── service/              # 服务层
    │   └── mypluginservice.go
    ├── scheduler/            # 定时任务（可选）
    │   ├── register.go
    │   └── executors/
    │       └── myplugin_executor.go
    └── plugin_export.json    # 插件配置
plugins/
└── myplugininit.go          # 插件初始化
```

### 最小插件结构

最小插件只需要以下文件：

```
plugins/
└── myplugin/
    ├── controllers/
    │   └── myplugincontroller.go
    ├── models/
    │   ├── myplugin.go
    │   └── mypluginparam.go
    ├── routes/
    │   └── mypluginroutes.go
    ├── service/
    │   └── mypluginservice.go
    └── plugin_export.json
plugins/
└── myplugininit.go
```

---

## 插件配置

### plugin_export.json 配置

```json
{
    "name": "myplugin",
    "version": "1.0.0",
    "description": "我的插件描述",
    "author": "作者名称",
    "email": "author@example.com",
    "url": "https://example.com",
    "dependencies": {
        "ginfast-tenant": "^1.0.0",
        "ginfast-tenant-ui": "^1.0.0"
    },
    "exportDirs": [
        "plugins/myplugin/",
        "plugins/myplugininit.go"
    ],
    "exportDirsFrontend": [
        "src/plugins/myplugin/"
    ],
    "menus": [
        {
            "path": "/myplugin",
            "type": 1,
            "title": "我的插件",
            "icon": "icon-name",
            "component": "myplugin/index"
        }
    ],
    "databaseTable": [
        "plugin_myplugin",
        "plugin_myplugin_detail"
    ]
}
```

### 配置字段说明

| 字段 | 说明 | 必填 |
|------|------|------|
| `name` | 插件名称（唯一标识） | 是 |
| `version` | 插件版本号 | 是 |
| `description` | 插件描述 | 是 |
| `author` | 作者名称 | 是 |
| `email` | 作者邮箱 | 否 |
| `url` | 插件主页 | 否 |
| `dependencies` | 依赖的插件和版本 | 否 |
| `exportDirs` | 后端导出目录列表 | 是 |
| `exportDirsFrontend` | 前端导出目录列表 | 否 |
| `menus` | 菜单配置 | 否 |
| `databaseTable` | 数据库表名列表 | 否 |

---

## 插件开发

### 控制器

```go
// plugins/myplugin/controllers/myplugincontroller.go
package controllers

import (
    "gin-fast/app/controllers"
    "gin-fast/plugins/myplugin/models"
    "gin-fast/plugins/myplugin/service"

    "github.com/gin-gonic/gin"
)

// MyPluginController 我的插件控制器
type MyPluginController struct {
    controllers.Common
    MyPluginService *service.MyPluginService
}

// NewMyPluginController 创建我的插件控制器
func NewMyPluginController() *MyPluginController {
    return &MyPluginController{
        Common:          controllers.Common{},
        MyPluginService: service.NewMyPluginService(),
    }
}

// Create 创建
func (c *MyPluginController) Create(ctx *gin.Context) {
    var req models.CreateRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    myplugin, err := c.MyPluginService.Create(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "创建失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "id": myplugin.ID,
    })
}

// Update 更新
func (c *MyPluginController) Update(ctx *gin.Context) {
    var req models.UpdateRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    err := c.MyPluginService.Update(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "更新失败", err)
        return
    }

    c.SuccessWithMessage(ctx, "更新成功")
}

// Delete 删除
func (c *MyPluginController) Delete(ctx *gin.Context) {
    var req models.DeleteRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    err := c.MyPluginService.Delete(ctx, req.ID)
    if err != nil {
        c.FailAndAbort(ctx, "删除失败", err)
        return
    }

    c.SuccessWithMessage(ctx, "删除成功", nil)
}

// GetByID 根据ID获取
func (c *MyPluginController) GetByID(ctx *gin.Context) {
    var req models.GetByIDRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    myplugin, err := c.MyPluginService.GetByID(ctx, req.ID)
    if err != nil {
        c.FailAndAbort(ctx, "记录不存在", err)
        return
    }

    c.Success(ctx, myplugin)
}

// List 列表（分页查询）
func (c *MyPluginController) List(ctx *gin.Context) {
    var req models.ListRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    mypluginList, total, err := c.MyPluginService.List(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "获取列表失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "list":  mypluginList,
        "total": total,
    })
}
```

### 模型

```go
// plugins/myplugin/models/myplugin.go
package models

import (
    "context"
    "gin-fast/app/global/app"
    "gorm.io/gorm"
)

// MyPlugin 我的插件模型
type MyPlugin struct {
    BaseModel
    Name        string `gorm:"column:name;size:100;not null;comment:名称" json:"name"`
    Description string `gorm:"column:description;size:500;comment:描述" json:"description"`
    Status      int8   `gorm:"column:status;default:1;comment:状态 0禁用 1启用" json:"status"`
    TenantID    uint   `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
}

// TableName 设置表名
func (MyPlugin) TableName() string {
    return "plugin_myplugin"
}

// NewMyPlugin 创建实例
func NewMyPlugin() *MyPlugin {
    return &MyPlugin{}
}

// IsEmpty 检查是否为空
func (m *MyPlugin) IsEmpty() bool {
    return m == nil || m.ID == 0
}

// Find 查询
func (m *MyPlugin) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(m).Error
}

// GetByID 根据ID获取
func (m *MyPlugin) GetByID(ctx context.Context, id uint) error {
    return m.Find(ctx, func(db *gorm.DB) *gorm.DB {
        return db.Where("id = ?", id)
    })
}

// Create 创建
func (m *MyPlugin) Create(ctx context.Context) error {
    return app.DB().WithContext(ctx).Create(m).Error
}

// Update 更新
func (m *MyPlugin) Update(ctx context.Context) error {
    return app.DB().WithContext(ctx).Save(m).Error
}

// Delete 删除
func (m *MyPlugin) Delete(ctx context.Context) error {
    return app.DB().WithContext(ctx).Delete(m).Error
}

// MyPluginList 列表
type MyPluginList []*MyPlugin

// NewMyPluginList 创建列表实例
func NewMyPluginList() MyPluginList {
    return MyPluginList{}
}

// Find 查询列表
func (list *MyPluginList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

// GetTotal 获取总数
func (list *MyPluginList) GetTotal(ctx context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
    var total int64
    err := app.DB().WithContext(ctx).Model(&MyPlugin{}).Scopes(query...).Count(&total).Error
    if err != nil {
        return 0, err
    }
    return total, nil
}
```

### 参数结构体

```go
// plugins/myplugin/models/mypluginparam.go
package models

import (
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
)

// CreateRequest 创建请求参数
type CreateRequest struct {
    Validator
    Name        string `form:"name" validate:"required" message:"名称不能为空"`
    Description string `form:"description" validate:"max_len:500" message:"描述最多500字"`
}

func (r *CreateRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

// UpdateRequest 更新请求参数
type UpdateRequest struct {
    Validator
    ID          uint   `form:"id" validate:"required" message:"ID不能为空"`
    Name        string `form:"name" validate:"required" message:"名称不能为空"`
    Description string `form:"description" validate:"max_len:500" message:"描述最多500字"`
}

func (r *UpdateRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

// DeleteRequest 删除请求参数
type DeleteRequest struct {
    Validator
    ID uint `form:"id" validate:"required" message:"ID不能为空"`
}

func (r *DeleteRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

// GetByIDRequest 获取单条请求参数
type GetByIDRequest struct {
    Validator
    ID uint `form:"id" validate:"required" message:"ID不能为空"`
}

func (r *GetByIDRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

// ListRequest 列表查询请求参数
type ListRequest struct {
    BasePaging
    Validator
    Name   string `form:"name" validate:"max_len:100" message:"名称最多100字"`
    Status string `form:"status" validate:"in:0,1" message:"状态值不正确"`
}

func (r *ListRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

// Handle 返回GORM查询条件函数
func (r *ListRequest) Handle() func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        if r.Name != "" {
            db = db.Where("name LIKE ?", "%"+r.Name+"%")
        }
        if r.Status != "" {
            db = db.Where("status = ?", r.Status)
        }
        return db
    }
}
```

### 服务层

```go
// plugins/myplugin/service/mypluginservice.go
package service

import (
    "gin-fast/plugins/myplugin/models"

    "github.com/gin-gonic/gin"
)

// MyPluginService 我的服务
type MyPluginService struct{}

// NewMyPluginService 创建服务实例
func NewMyPluginService() *MyPluginService {
    return &MyPluginService{}
}

// Create 创建
func (s *MyPluginService) Create(c *gin.Context, req models.CreateRequest) (*models.MyPlugin, error) {
    myplugin := models.NewMyPlugin()
    myplugin.Name = req.Name
    myplugin.Description = req.Description

    if err := myplugin.Create(c); err != nil {
        return nil, err
    }

    return myplugin, nil
}

// Update 更新
func (s *MyPluginService) Update(c *gin.Context, req models.UpdateRequest) error {
    myplugin := models.NewMyPlugin()
    if err := myplugin.GetByID(c, req.ID); err != nil {
        return err
    }

    myplugin.Name = req.Name
    myplugin.Description = req.Description

    return myplugin.Update(c)
}

// Delete 删除
func (s *MyPluginService) Delete(c *gin.Context, id uint) error {
    myplugin := models.NewMyPlugin()
    if err := myplugin.GetByID(c, id); err != nil {
        return err
    }

    return myplugin.Delete(c)
}

// GetByID 根据ID获取
func (s *MyPluginService) GetByID(c *gin.Context, id uint) (*models.MyPlugin, error) {
    myplugin := models.NewMyPlugin()
    if err := myplugin.GetByID(c, id); err != nil {
        return nil, err
    }

    return myplugin, nil
}

// List 列表（分页查询）
func (s *MyPluginService) List(c *gin.Context, req models.ListRequest) (*models.MyPluginList, int64, error) {
    mypluginList := models.NewMyPluginList()

    total, err := mypluginList.GetTotal(c, req.Handle())
    if err != nil {
        return nil, 0, err
    }

    err = mypluginList.Find(c, req.Handle(), req.Paginate())
    if err != nil {
        return nil, 0, err
    }

    return mypluginList, total, nil
}
```

### 路由

```go
// plugins/myplugin/routes/mypluginroutes.go
package routes

import (
    "gin-fast/app/global/app"
    "gin-fast/app/middleware"
    "gin-fast/app/utils/ginhelper"
    "gin-fast/plugins/myplugin/controllers"

    "github.com/gin-gonic/gin"
)

func init() {
    var mypluginControllers = controllers.NewMyPluginController()

    // 注册插件路由
    ginhelper.RegisterPluginRoutes(func(engine *gin.Engine) {
        // 我的插件路由组
        myplugin := engine.Group("/api/plugins/myplugin")
        myplugin.Use(middleware.JWTAuthMiddleware())
        myplugin.Use(middleware.DemoAccountMiddleware())
        myplugin.Use(middleware.CasbinMiddleware())
        {
            // 创建
            myplugin.POST("/add", mypluginControllers.Create)
            // 更新
            myplugin.PUT("/edit", mypluginControllers.Update)
            // 删除
            myplugin.DELETE("/delete", mypluginControllers.Delete)
            // 列表
            myplugin.GET("/list", mypluginControllers.List)
            // 根据ID获取
            myplugin.GET("/:id", mypluginControllers.GetByID)
        }

        app.ZapLog.Info("我的插件路由注册成功")
    })
}
```

### 插件初始化

```go
// plugins/myplugininit.go
package plugins

import (
    _ "gin-fast/plugins/myplugin/routes"
)
```

---

## 插件打包

### 使用插件管理器打包

1. 登录系统，访问「系统工具」→「插件管理」
2. 点击「导出插件」
3. 选择插件文件夹名称
4. 系统自动打包为 ZIP 文件

### 手动打包

将以下文件打包为 ZIP：

```
myplugin/
├── controllers/
├── models/
├── routes/
├── service/
├── scheduler/（如果有）
└── plugin_export.json
```

---

## 插件导入

### 使用插件管理器导入

1. 登录系统，访问「系统工具」→「插件管理」
2. 点击「导入插件」
3. 上传插件 ZIP 文件
4. 系统自动解压并安装

### 手动导入

1. 解压插件 ZIP 文件到 `plugins/` 目录
2. 创建 `plugins/插件名init.go` 文件
3. 重启应用

---

## 最佳实践

### 1. 插件命名规范

- 插件文件夹名使用小写字母和连字符：`my-plugin`
- 插件配置中的 name 使用小写字母：`myplugin`

### 2. 表名规范

插件表使用 `plugin_` 前缀：

```go
func (MyPlugin) TableName() string {
    return "plugin_myplugin"
}
```

### 3. 路由前缀规范

插件路由使用 `/api/plugins/插件名` 前缀：

```go
myplugin := engine.Group("/api/plugins/myplugin")
```

### 4. 依赖管理

在 `plugin_export.json` 中声明依赖：

```json
{
    "dependencies": {
        "ginfast-tenant": "^1.0.0"
    }
}
```

### 5. 版本管理

使用语义化版本号：`主版本.次版本.修订版本`

- `1.0.0` - 初始版本
- `1.1.0` - 添加新功能
- `1.1.1` - 修复 bug
- `2.0.0` - 破坏性变更

### 6. 菜单配置

在 `plugin_export.json` 中配置菜单：

```json
{
    "menus": [
        {
            "path": "/myplugin",
            "type": 1,
            "title": "我的插件",
            "icon": "icon-name"
        }
    ]
}
```

### 7. 数据库表

在 `plugin_export.json` 中声明数据库表：

```json
{
    "databaseTable": [
        "plugin_myplugin",
        "plugin_myplugin_detail"
    ]
}
```

### 8. 定时任务（可选）

如果插件需要定时任务：

```go
// plugins/myplugin/scheduler/register.go
package scheduler

import (
    "gin-fast/app/global/app"
    "gin-fast/plugins/myplugin/scheduler/executors"
)

func RegisterMyPluginExecutors() {
    // 注册执行器
    app.Scheduler.RegisterExecutor("myplugin_task", executors.NewMyPluginExecutor())
}

// plugins/myplugin/scheduler/executors/myplugin_executor.go
package executors

import (
    "context"
)

type MyPluginExecutor struct{}

func NewMyPluginExecutor() *MyPluginExecutor {
    return &MyPluginExecutor{}
}

func (e *MyPluginExecutor) Execute(ctx context.Context, params map[string]interface{}) error {
    // 执行定时任务逻辑
    return nil
}
```

---

## 参考资源

### 项目内部资源

- [`plugins/example/`](../plugins/example/) - 示例插件
- [`plugins/exampleinit.go`](../plugins/exampleinit.go) - 示例插件初始化
- [`app/controllers/pluginsmanager.go`](../app/controllers/pluginsmanager.go) - 插件管理控制器
- [`app/service/pluginsmanagerservice.go`](../app/service/pluginsmanagerservice.go) - 插件管理服务
