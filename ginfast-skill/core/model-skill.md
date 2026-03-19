---
name: model
description: 创建模型时
modeSlugs:
  - code
  - architect
---

# 模型开发指南

模型（Model）负责数据持久化和数据访问，是应用与数据库交互的核心层。

## 目录

- [快速开始](#快速开始)
- [App 目录开发](#app-目录开发)
- [Plugin 目录开发](#plugin-目录开发)
- [参数结构体](#参数结构体)
- [最佳实践](#最佳实践)

---

## 快速开始

### 模型基本结构

```go
package models

import (
    "context"
    "gin-fast/app/global/app"

    "gorm.io/gorm"
)

// Example 示例模型
type Example struct {
    BaseModel
    Name        string `gorm:"column:name;size:100;not null;comment:名称" json:"name"`
    Description string `gorm:"column:description;size:500;comment:描述" json:"description"`
}

// TableName 设置表名
func (Example) TableName() string {
    return "examples"
}

// NewExample 创建示例实例
func NewExample() *Example {
    return &Example{}
}
```

### BaseModel 基础模型

所有模型都应嵌入 `BaseModel`，它提供了常用字段：

```go
type BaseModel struct {
    ID        uint           `gorm:"column:id;primaryKey;autoIncrement" json:"id"`
    CreatedAt time.Time      `gorm:"column:created_at;autoCreateTime;comment:创建时间" json:"createdAt"`
    UpdatedAt time.Time      `gorm:"column:updated_at;autoUpdateTime;comment:更新时间" json:"updatedAt"`
    DeletedAt gorm.DeletedAt `gorm:"column:deleted_at;index;comment:删除时间" json:"deletedAt,omitempty"`
}
```

---

## App 目录开发

### 文件位置

```
app/models/
├── example.go       # 模型定义
└── exampleparam.go  # 参数结构体
```

### 模型定义

```go
// app/models/example.go
package models

import (
    "context"
    "gin-fast/app/global/app"

    "gorm.io/gorm"
)

// Example 示例模型
type Example struct {
    BaseModel
    Name        string `gorm:"column:name;size:100;not null;comment:名称" json:"name"`
    Description string `gorm:"column:description;size:500;comment:描述" json:"description"`
    Status      int8   `gorm:"column:status;default:1;comment:状态 0禁用 1启用" json:"status"`
    CreatedBy   uint   `gorm:"column:created_by;default:0;comment:创建人" json:"createdBy"`
    TenantID    uint   `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
}

// TableName 设置表名
func (Example) TableName() string {
    return "sys_example"
}

// NewExample 创建示例实例
func NewExample() *Example {
    return &Example{}
}

// IsEmpty 检查模型是否为空
func (e *Example) IsEmpty() bool {
    return e == nil || e.ID == 0
}

// Find 查询单条记录
func (e *Example) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(e).Error
}

// GetByID 根据ID获取记录
func (e *Example) GetByID(ctx context.Context, id uint) error {
    return e.Find(ctx, func(db *gorm.DB) *gorm.DB {
        return db.Where("id = ?", id)
    })
}

// GetByName 根据名称获取记录
func (e *Example) GetByName(ctx context.Context, name string) error {
    return e.Find(ctx, func(db *gorm.DB) *gorm.DB {
        return db.Where("name = ?", name)
    })
}

// Create 创建记录
func (e *Example) Create(ctx context.Context) error {
    return app.DB().WithContext(ctx).Create(e).Error
}

// Update 更新记录
func (e *Example) Update(ctx context.Context) error {
    return app.DB().WithContext(ctx).Save(e).Error
}

// Delete 删除记录（软删除）
func (e *Example) Delete(ctx context.Context) error {
    return app.DB().WithContext(ctx).Delete(e).Error
}

// DeleteByID 根据ID删除记录
func (e *Example) DeleteByID(ctx context.Context, id uint) error {
    return app.DB().WithContext(ctx).Where("id = ?", id).Delete(e).Error
}

// ExampleList 示例列表
type ExampleList []*Example

// NewExampleList 创建示例列表实例
func NewExampleList() ExampleList {
    return ExampleList{}
}

// Find 查询列表
func (list *ExampleList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

// GetTotal 获取总数
func (list *ExampleList) GetTotal(ctx context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
    var total int64
    err := app.DB().WithContext(ctx).Model(&Example{}).Scopes(query...).Count(&total).Error
    if err != nil {
        return 0, err
    }
    return total, nil
}
```

---

## Plugin 目录开发

### 文件位置

```
plugins/
└── example/
    └── models/
        ├── example.go       # 模型定义
        └── exampleparam.go  # 参数结构体
```

### 模型定义

```go
// plugins/example/models/example.go
package models

import (
    "context"
    "gin-fast/app/global/app"

    "gorm.io/gorm"
)

// Example 示例模型
type Example struct {
    BaseModel
    Name        string `gorm:"column:name;size:100;not null;comment:名称" json:"name"`
    Description string `gorm:"column:description;size:500;comment:描述" json:"description"`
    Status      int8   `gorm:"column:status;default:1;comment:状态 0禁用 1启用" json:"status"`
    CreatedBy   uint   `gorm:"column:created_by;default:0;comment:创建人" json:"createdBy"`
    TenantID    uint   `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
}

// TableName 设置表名
func (Example) TableName() string {
    return "plugin_example"
}

// NewExample 创建示例实例
func NewExample() *Example {
    return &Example{}
}

// IsEmpty 检查模型是否为空
func (e *Example) IsEmpty() bool {
    return e == nil || e.ID == 0
}

// Find 查询单条记录
func (e *Example) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(e).Error
}

// GetByID 根据ID获取记录
func (e *Example) GetByID(ctx context.Context, id uint) error {
    return e.Find(ctx, func(db *gorm.DB) *gorm.DB {
        return db.Where("id = ?", id)
    })
}

// GetByName 根据名称获取记录
func (e *Example) GetByName(ctx context.Context, name string) error {
    return e.Find(ctx, func(db *gorm.DB) *gorm.DB {
        return db.Where("name = ?", name)
    })
}

// Create 创建记录
func (e *Example) Create(ctx context.Context) error {
    return app.DB().WithContext(ctx).Create(e).Error
}

// Update 更新记录
func (e *Example) Update(ctx context.Context) error {
    return app.DB().WithContext(ctx).Save(e).Error
}

// Delete 删除记录（软删除）
func (e *Example) Delete(ctx context.Context) error {
    return app.DB().WithContext(ctx).Delete(e).Error
}

// DeleteByID 根据ID删除记录
func (e *Example) DeleteByID(ctx context.Context, id uint) error {
    return app.DB().WithContext(ctx).Where("id = ?", id).Delete(e).Error
}

// ExampleList 示例列表
type ExampleList []*Example

// NewExampleList 创建示例列表实例
func NewExampleList() ExampleList {
    return ExampleList{}
}

// Find 查询列表
func (list *ExampleList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

// GetTotal 获取总数
func (list *ExampleList) GetTotal(ctx context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
    var total int64
    err := app.DB().WithContext(ctx).Model(&Example{}).Scopes(query...).Count(&total).Error
    if err != nil {
        return 0, err
    }
    return total, nil
}
```

---

## 参数结构体

### 参数结构体定义

参数结构体用于接收和验证请求参数，通常与模型放在同一个目录下。

```go
// app/models/exampleparam.go
package models

import (
    "github.com/gin-gonic/gin"
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

---

## 最佳实践

### 1. 表名命名规范

- 系统表使用 `sys_` 前缀：`sys_example`
- 插件表使用 `plugin_` 前缀：`plugin_example`

```go
func (Example) TableName() string {
    return "sys_example"  // 系统表
}
```

### 2. 字段标签规范

| 标签 | 说明 | 示例 |
|------|------|------|
| `gorm` | GORM 字段定义 | `gorm:"column:name;size:100;not null;comment:名称"` |
| `json` | JSON 序列化名称 | `json:"name"` |
| `form` | 表单字段名称 | `form:"name"` |

```go
type Example struct {
    Name string `gorm:"column:name;size:100;not null;comment:名称" json:"name" form:"name"`
}
```

### 3. 租户字段

多租户表必须包含 `tenant_id` 字段：

```go
type Example struct {
    BaseModel
    TenantID uint `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
}
```

### 4. 软删除

使用 `DeletedAt` 字段实现软删除：

```go
import "gorm.io/gorm"

type BaseModel struct {
    ID        uint           `gorm:"column:id;primaryKey;autoIncrement" json:"id"`
    DeletedAt gorm.DeletedAt `gorm:"column:deleted_at;index;comment:删除时间" json:"deletedAt,omitempty"`
}
```

### 5. 模型方法命名

| 方法名 | 说明 | 示例 |
|--------|------|------|
| `NewXxx()` | 创建实例 | `NewExample()` |
| `GetXxx()` | 根据字段获取 | `GetByID()`, `GetByName()` |
| `Find()` | 通用查询方法 | `Find(ctx, funcs...)` |
| `Create()` | 创建记录 | `Create(ctx)` |
| `Update()` | 更新记录 | `Update(ctx)` |
| `Delete()` | 删除记录 | `Delete(ctx)` |

### 6. 列表模型

使用切片类型定义列表模型：

```go
// ExampleList 示例列表
type ExampleList []*Example

func NewExampleList() ExampleList {
    return ExampleList{}
}

func (list *ExampleList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

func (list *ExampleList) GetTotal(ctx context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
    var total int64
    err := app.DB().WithContext(ctx).Model(&Example{}).Scopes(query...).Count(&total).Error
    if err != nil {
        return 0, err
    }
    return total, nil
}
```

### 7. 关联关系

使用 GORM 标签定义关联关系：

```go
type Example struct {
    BaseModel
    Name     string        `gorm:"column:name;size:100;not null;comment:名称" json:"name"`
    UserID   uint          `gorm:"column:user_id;comment:用户ID" json:"userId"`
    User     User          `gorm:"foreignKey:UserID;references:ID" json:"user"`
    Comments []Comment     `gorm:"foreignKey:ExampleID;references:ID" json:"comments"`
}
```

### 8. 参数验证

参数结构体必须嵌入 `Validator`：

```go
type CreateRequest struct {
    Validator
    Name string `form:"name" validate:"required" message:"名称不能为空"`
}

func (r *CreateRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}
```

### 9. 分页参数

列表查询参数嵌入 `BasePaging`：

```go
type ListRequest struct {
    BasePaging
    Validator
    Name string `form:"name"`
}
```

### 10. 查询条件处理

实现 `Handle()` 方法处理查询条件：

```go
func (r *ListRequest) Handle() func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        if r.Name != "" {
            db = db.Where("name LIKE ?", "%"+r.Name+"%")
        }
        return db
    }
}
```

---

## 参考资源

### 项目内部资源

- [`app/models/base.go`](../app/models/base.go) - BaseModel 定义
- [`app/models/user.go`](../app/models/user.go) - 用户模型示例
- [`app/models/userparam.go`](../app/models/userparam.go) - 用户参数示例
- [`plugins/example/models/example.go`](../plugins/example/models/example.go) - 插件模型示例
