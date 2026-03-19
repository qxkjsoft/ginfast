---
name: tenant
description: 开发多租户功能时
modeSlugs:
  - code
  - architect
---

# 多租户开发指南

GinFast 支持完整的多租户架构，包括租户管理、用户租户关联、数据隔离等功能。

## 目录

- [快速开始](#快速开始)
- [租户模型](#租户模型)
- [数据隔离](#数据隔离)
- [用户租户关联](#用户租户关联)
- [最佳实践](#最佳实践)

---

## 快速开始

### 租户ID获取

在控制器中获取当前租户ID：

```go
func (c *ExampleController) Create(ctx *gin.Context) {
    tenantID := c.GetCurrentTenantID(ctx)

    // 使用 tenantID
    // ...
}
```

### 租户数据隔离

使用 `TenantScope` 自动过滤租户数据：

```go
import "gin-fast/app/utils/tenanthelper"

func (s *ExampleService) List(c *gin.Context, req models.ListRequest) (*models.ExampleList, int64, error) {
    exampleList := models.NewExampleList()

    // 自动添加租户过滤条件
    total, err := exampleList.GetTotal(c, tenanthelper.TenantScope(c), req.Handle())
    if err != nil {
        return nil, 0, err
    }

    err = exampleList.Find(c, tenanthelper.TenantScope(c), req.Handle(), req.Paginate())
    if err != nil {
        return nil, 0, err
    }

    return exampleList, total, nil
}
```

---

## 租户模型

### Tenant 模型

```go
// app/models/systenants.go
package models

import (
    "context"
    "gin-fast/app/global/app"
)

// Tenant 租户模型
type Tenant struct {
    BaseModel
    Name        string `gorm:"column:name;size:100;not null;comment:租户名称" json:"name"`
    Code        string `gorm:"column:code;size:50;not null;uniqueIndex;comment:租户编码" json:"code"`
    Description string `gorm:"column:description;size:500;comment:描述" json:"description"`
    Status      int8   `gorm:"column:status;default:1;comment:状态 0禁用 1启用" json:"status"`
    ExpireTime  *JSONTime `gorm:"column:expire_time;comment:过期时间" json:"expireTime"`
}

// TableName 设置表名
func (Tenant) TableName() string {
    return "sys_tenant"
}

// NewTenant 创建租户实例
func NewTenant() *Tenant {
    return &Tenant{}
}

// Find 查询租户
func (t *Tenant) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(t).Error
}

// GetByID 根据ID获取租户
func (t *Tenant) GetByID(ctx context.Context, id uint) error {
    return t.Find(ctx, func(db *gorm.DB) *gorm.DB {
        return db.Where("id = ?", id)
    })
}

// GetByCode 根据编码获取租户
func (t *Tenant) GetByCode(ctx context.Context, code string) error {
    return t.Find(ctx, func(db *gorm.DB) *gorm.DB {
        return db.Where("code = ?", code)
    })
}

// Create 创建租户
func (t *Tenant) Create(ctx context.Context) error {
    return app.DB().WithContext(ctx).Create(t).Error
}

// Update 更新租户
func (t *Tenant) Update(ctx context.Context) error {
    return app.DB().WithContext(ctx).Save(t).Error
}

// Delete 删除租户
func (t *Tenant) Delete(ctx context.Context) error {
    return app.DB().WithContext(ctx).Delete(t).Error
}
```

### SysUserTenant 模型

用户租户关联模型：

```go
// app/models/sysusertenant.go
package models

import (
    "context"
    "gin-fast/app/global/app"
)

// SysUserTenant 用户租户关联模型
type SysUserTenant struct {
    BaseModel
    UserID     uint   `gorm:"column:user_id;not null;comment:用户ID" json:"userId"`
    TenantID   uint   `gorm:"column:tenant_id;not null;comment:租户ID" json:"tenantId"`
    IsDefault  int8   `gorm:"column:is_default;default:0;comment:是否默认租户 0否 1是" json:"isDefault"`
    Status     int8   `gorm:"column:status;default:1;comment:状态 0禁用 1启用" json:"status"`
}

// TableName 设置表名
func (SysUserTenant) TableName() string {
    return "sys_user_tenant"
}

// NewSysUserTenant 创建用户租户关联实例
func NewSysUserTenant() *SysUserTenant {
    return &SysUserTenant{}
}

// Find 查询用户租户关联
func (ut *SysUserTenant) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(ut).Error
}

// GetByUserAndTenant 根据用户ID和租户ID获取关联
func (ut *SysUserTenant) GetByUserAndTenant(ctx context.Context, userID, tenantID uint) error {
    return ut.Find(ctx, func(db *gorm.DB) *gorm.DB {
        return db.Where("user_id = ? AND tenant_id = ?", userID, tenantID)
    })
}

// Create 创建用户租户关联
func (ut *SysUserTenant) Create(ctx context.Context) error {
    return app.DB().WithContext(ctx).Create(ut).Error
}

// Delete 删除用户租户关联
func (ut *SysUserTenant) Delete(ctx context.Context) error {
    return app.DB().WithContext(ctx).Delete(ut).Error
}

// SysUserTenantList 用户租户关联列表
type SysUserTenantList []*SysUserTenant

// NewSysUserTenantList 创建用户租户关联列表实例
func NewSysUserTenantList() SysUserTenantList {
    return SysUserTenantList{}
}

// Find 查询用户租户关联列表
func (list *SysUserTenantList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

// GetTenantIDs 获取租户ID列表
func (list *SysUserTenantList) GetTenantIDs() []uint {
    tenantIDs := make([]uint, len(list))
    for i, ut := range list {
        tenantIDs[i] = ut.TenantID
    }
    return tenantIDs
}
```

---

## 数据隔离

### TenantScope 租户作用域

使用 `TenantScope` 自动过滤租户数据：

```go
// app/utils/tenanthelper/tenanthelper.go
package tenanthelper

import (
    "gin-fast/app/utils/common"

    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
)

// TenantScope 租户数据隔离作用域
func TenantScope(c *gin.Context) func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        // 获取租户ID
        claims := common.GetClaims(c)
        if claims != nil {
            return db.Where("tenant_id = ?", claims.TenantID)
        } else {
            // 没有权限
            return db.Where("1 = 0")
        }
    }
}
```

### 在模型中使用租户字段

所有需要租户隔离的模型都应包含 `tenant_id` 字段：

```go
type Example struct {
    BaseModel
    Name     string `gorm:"column:name;size:100;not null;comment:名称" json:"name"`
    TenantID uint   `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
}
```

### 在查询中使用租户隔离

```go
import "gin-fast/app/utils/tenanthelper"

func (s *ExampleService) List(c *gin.Context, req models.ListRequest) (*models.ExampleList, int64, error) {
    exampleList := models.NewExampleList()

    // 自动添加租户过滤条件
    total, err := exampleList.GetTotal(c, tenanthelper.TenantScope(c), req.Handle())
    if err != nil {
        return nil, 0, err
    }

    err = exampleList.Find(c, tenanthelper.TenantScope(c), req.Handle(), req.Paginate())
    if err != nil {
        return nil, 0, err
    }

    return exampleList, total, nil
}
```

---

## 用户租户关联

### 获取用户的租户列表

```go
func (s *UserService) GetUserTenants(c *gin.Context, userID uint) (*models.SysUserTenantList, error) {
    userTenants := models.NewSysUserTenantList()

    // 查询用户的租户关联
    err := userTenants.Find(c, func(db *gorm.DB) *gorm.DB {
        return db.Where("user_id = ? AND status = ?", userID, 1).
               Preload("Tenant").
               Order("is_default DESC, created_at DESC")
    })
    if err != nil {
        return nil, err
    }

    return userTenants, nil
}
```

### 切换租户

```go
func (c *UserController) SwitchTenant(ctx *gin.Context) {
    tenantID, err := strconv.ParseUint(ctx.Param("tenantId"), 10, 64)
    if err != nil {
        c.FailAndAbort(ctx, "租户ID格式错误", err)
        return
    }

    // 获取当前用户ID
    userID := c.GetCurrentUserID(ctx)

    // 验证用户是否有该租户的访问权限
    userTenant := models.NewSysUserTenant()
    err = userTenant.GetByUserAndTenant(ctx, userID, uint(tenantID))
    if err != nil {
        c.FailAndAbort(ctx, "无权访问该租户", err)
        return
    }

    if userTenant.Status != 1 {
        c.FailAndAbort(ctx, "该租户已被禁用", nil)
        return
    }

    // 生成新的Token
    claims := c.GetClaims(ctx)
    claims.TenantID = uint(tenantID)

    newToken, err := app.TokenService.GenerateToken(claims)
    if err != nil {
        c.FailAndAbort(ctx, "生成Token失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "token": newToken,
    })
}
```

### 为用户分配租户

```go
func (s *UserService) AssignTenant(c *gin.Context, userID, tenantID uint, isDefault bool) error {
    // 检查租户是否存在
    tenant := models.NewTenant()
    if err := tenant.GetByID(c, tenantID); err != nil {
        return errors.New("租户不存在")
    }

    // 如果设置为默认租户，先取消其他默认租户
    if isDefault {
        userTenants := models.NewSysUserTenantList()
        userTenants.Find(c, func(db *gorm.DB) *gorm.DB {
            return db.Where("user_id = ? AND is_default = ?", userID, 1)
        })
        for _, ut := range *userTenants {
            ut.IsDefault = 0
            ut.Update(c)
        }
    }

    // 创建用户租户关联
    userTenant := models.NewSysUserTenant()
    userTenant.UserID = userID
    userTenant.TenantID = tenantID
    if isDefault {
        userTenant.IsDefault = 1
    }

    return userTenant.Create(c)
}
```

---

## 最佳实践

### 1. 所有业务表都应包含租户字段

```go
type Example struct {
    BaseModel
    Name     string `gorm:"column:name;size:100;not null;comment:名称" json:"name"`
    TenantID uint   `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
}
```

### 2. 使用 TenantScope 自动过滤

```go
// 好的做法：使用 TenantScope
exampleList.Find(c, tenanthelper.TenantScope(c), req.Handle())

// 不好的做法：手动添加租户条件
exampleList.Find(c, func(db *gorm.DB) *gorm.DB {
    return db.Where("tenant_id = ?", tenantID)
})
```

### 3. 创建记录时自动设置租户ID

```go
func (s *ExampleService) Create(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    example := models.NewExample()
    example.Name = req.Name

    // 自动设置租户ID
    example.TenantID = common.GetTenantID(c)

    return example, example.Create(c)
}
```

### 4. 全局租户（租户ID为0）的处理

全局租户的数据对所有租户可见：

```go
func GlobalTenantScope(c *gin.Context) func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        claims := common.GetClaims(c)
        if claims != nil {
            return db.Where("tenant_id = ? OR tenant_id = 0", claims.TenantID)
        }
        return db.Where("1 = 0")
    }
}
```

### 5. 租户过期检查

在登录时检查租户是否过期：

```go
func (s *AuthService) Login(c *gin.Context, req models.LoginRequest) (*LoginResponse, error) {
    // 查询用户
    user := models.NewUser()
    if err := user.GetUserByUsername(c, req.Username); err != nil {
        return nil, errors.New("用户不存在")
    }

    // 检查租户是否过期
    if user.Tenant.ExpireTime != nil && user.Tenant.ExpireTime.Before(time.Now()) {
        return nil, errors.New("租户已过期")
    }

    // 继续登录流程
    // ...
}
```

### 6. 租户数据统计

按租户统计数据时需要排除全局租户：

```go
func (s *ExampleService) GetTenantStats(c *gin.Context) (*TenantStats, error) {
    tenantID := common.GetTenantID(c)

    var stats TenantStats
    db := app.DB().WithContext(c).Model(&models.Example{})

    // 只统计当前租户的数据，排除全局租户
    db = db.Where("tenant_id = ?", tenantID)

    // 统计
    db.Count(&stats.Total)

    return &stats, nil
}
```

### 7. 跨租户数据查询

管理员查询所有租户数据时需要特殊处理：

```go
func (s *ExampleService) ListAllTenants(c *gin.Context, req models.ListRequest) (*models.ExampleList, int64, error) {
    // 只有管理员才能执行此操作
    if !common.IsAdmin(c) {
        return nil, 0, errors.New("无权限")
    }

    exampleList := models.NewExampleList()

    // 不使用 TenantScope，查询所有租户的数据
    total, err := exampleList.GetTotal(c, req.Handle())
    if err != nil {
        return nil, 0, err
    }

    err = exampleList.Find(c, req.Handle(), req.Paginate())
    if err != nil {
        return nil, 0, err
    }

    return exampleList, total, nil
}
```

---

## 参考资源

### 项目内部资源

- [`app/models/systenants.go`](../app/models/systenants.go) - 租户模型
- [`app/models/sysusertenant.go`](../app/models/sysusertenant.go) - 用户租户关联模型
- [`app/utils/tenanthelper/tenanthelper.go`](../app/utils/tenanthelper/tenanthelper.go) - 租户辅助函数
- [`app/controllers/systenant.go`](../app/controllers/systenant.go) - 租户控制器
- [`app/controllers/sysusertenant.go`](../app/controllers/sysusertenant.go) - 用户租户关联控制器
