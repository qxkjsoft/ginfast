---
name: casbin
description: 配置权限时
modeSlugs:
  - code
  - architect
---

# 权限管理开发指南

GinFast 使用 Casbin 实现基于 RBAC（基于角色的访问控制）的权限管理。

## 目录

- [快速开始](#快速开始)
- [权限模型](#权限模型)
- [策略管理](#策略管理)
- [菜单权限关联](#菜单权限关联)
- [最佳实践](#最佳实践)

---

## 快速开始

### Casbin 中间件

使用 Casbin 中间件进行权限控制：

```go
import "gin-fast/app/middleware"

protected := engine.Group("/api")
protected.Use(middleware.CasbinMiddleware())
{
    // 需要权限验证的路由
}
```

### 权限检查

在代码中检查权限：

```go
import "gin-fast/app/global/app"

// 检查用户是否有权限
ok, err := app.Casbin.Enforce(userID, "/api/users/list", "GET")
if err != nil || !ok {
    return errors.New("无权限访问")
}
```

---

## 权限模型

### RBAC 模型

Casbin 使用 RBAC 模型定义权限规则：

```
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act

[role_definition]
g = _, _

[policy_effect]
e = some(where (p.eft == allow))

[matchers]
m = g(r.sub, p.sub) && r.obj == p.obj && r.act == p.act
```

### 权限规则说明

| 元素 | 说明 | 示例 |
|------|------|------|
| `sub` | 主体（用户ID） | `1` |
| `obj` | 对象（API路径） | `/api/users/list` |
| `act` | 动作（HTTP方法） | `GET` |
| `p` | 策略 | `p = 1, /api/users/list, GET` |
| `g` | 角色继承 | `g = 1, 2` (用户1属于角色2) |

### 权限策略示例

```
# 用户权限
p, 1, /api/users/list, GET
p, 1, /api/users/:id, GET
p, 2, /api/users/add, POST

# 角色继承
g, 1, 2
g, 2, 3
```

---

## 策略管理

### 添加权限策略

```go
import "gin-fast/app/service"

func (s *CasbinService) AddPolicy(userID uint, path, method string) error {
    // 添加权限策略
    return app.Casbin.AddPolicy(userID, path, method)
}
```

### 删除权限策略

```go
func (s *CasbinService) RemovePolicy(userID uint, path, method string) error {
    // 删除权限策略
    return app.Casbin.RemovePolicy(userID, path, method)
}
```

### 添加角色继承

```go
func (s *CasbinService) AddRoleForUser(userID, roleID uint) error {
    // 添加角色继承
    return app.Casbin.AddRoleForUser(userID, roleID)
}
```

### 删除角色继承

```go
func (s *CasbinService) DeleteRoleForUser(userID, roleID uint) error {
    // 删除角色继承
    return app.Casbin.DeleteRoleForUser(userID, roleID)
}
```

### 获取用户的所有权限

```go
func (s *CasbinService) GetUserPermissions(userID uint) ([]string, error) {
    permissions := []string{}

    // 获取用户的所有角色ID
    roleIDs := s.getUserRoleIDs(userID)

    // 获取角色关联的菜单ID
    menuIDs := s.getMenuIDsByRoleIDs(roleIDs)

    // 查询按钮类型的菜单（type=3）
    buttonMenus := models.NewSysMenuList()
    buttonMenus.Find(c, func(db *gorm.DB) *gorm.DB {
        return db.Select("permission").
               Where("id IN ? AND type = ? AND permission != ''", menuIDs, 3)
    })

    // 提取权限标识
    for _, menu := range *buttonMenus {
        permissions = append(permissions, menu.Permission)
    }

    return permissions, nil
}
```

---

## 菜单权限关联

### SysRoleMenu 模型

角色菜单关联模型：

```go
// app/models/sysrolemenu.go
package models

import (
    "context"
    "gin-fast/app/global/app"
)

// SysRoleMenu 角色菜单关联模型
type SysRoleMenu struct {
    RoleID uint `gorm:"column:role_id;not null;primaryKey;comment:角色ID" json:"roleId"`
    MenuID uint `gorm:"column:menu_id;not null;primaryKey;comment:菜单ID" json:"menuId"`
}

// TableName 设置表名
func (SysRoleMenu) TableName() string {
    return "sys_role_menu"
}

// NewSysRoleMenu 创建角色菜单关联实例
func NewSysRoleMenu() *SysRoleMenu {
    return &SysRoleMenu{}
}

// Create 创建角色菜单关联
func (rm *SysRoleMenu) Create(ctx context.Context) error {
    return app.DB().WithContext(ctx).Create(rm).Error
}

// Delete 删除角色菜单关联
func (rm *SysRoleMenu) Delete(ctx context.Context) error {
    return app.DB().WithContext(ctx).Delete(rm).Error
}

// SysRoleMenuList 角色菜单关联列表
type SysRoleMenuList []*SysRoleMenu

// NewSysRoleMenuList 创建角色菜单关联列表实例
func NewSysRoleMenuList() SysRoleRoleMenuList {
    return SysRoleMenuList{}
}

// Find 查询角色菜单关联列表
func (list *SysRoleMenuList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

// GetMenuIDs 获取菜单ID列表
func (list *SysRoleMenuList) GetMenuIDs() []uint {
    menuIDs := make([]uint, len(list))
    for i, rm := range list {
        menuIDs[i] = rm.MenuID
    }
    return menuIDs
}
```

### SysMenuApi 模型

菜单API关联模型：

```go
// app/models/sysmenuapi.go
package models

import (
    "context"
    "gin-fast/app/global/app"
)

// SysMenuApi 菜单API关联模型
type SysMenuApi struct {
    MenuID uint `gorm:"column:menu_id;not null;primaryKey;comment:菜单ID" json:"menuId"`
    ApiID  uint `gorm:"column:api_id;not null;primaryKey;comment:APIID" json:"apiId"`
}

// TableName 设置表名
func (SysMenuApi) TableName() string {
    return "sys_menu_api"
}

// NewSysMenuApi 创建菜单API关联实例
func NewSysMenuApi() *SysMenuApi {
    return &SysMenuApi{}
}

// Create 创建菜单API关联
func (ma *SysMenuApi) Create(ctx context.Context) error {
    return app.DB().WithContext(ctx).Create(ma).Error
}

// Delete 删除菜单API关联
func (ma *SysMenuApi) Delete(ctx context.Context) error {
    return app.DB().WithContext(ctx).Delete(ma).Error
}

// SysMenuApiList 菜单API关联列表
type SysMenuApiList []*SysMenuApi

// NewSysMenuApiList 创建菜单API关联列表实例
func NewSysMenuApiList() SysMenuApiList {
    return SysMenuApiList{}
}

// Find 查询菜单API关联列表
func (list *SysMenuApiList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

// GetApiIDs 获取API ID列表
func (list *SysMenuApiList) GetApiIDs() []uint {
    apiIDs := make([]uint, len(list))
    for i, ma := range list {
        apiIDs[i] = ma.ApiID
    }
    return apiIDs
}
```

### 为角色分配菜单

```go
func (s *SysRoleService) AssignMenus(c *gin.Context, roleID uint, menuIDs []uint) error {
    return app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
        // 删除角色的所有菜单关联
        tx.Where("role_id = ?", roleID).Delete(&models.SysRoleMenu{})

        // 添加新的菜单关联
        for _, menuID := range menuIDs {
            roleMenu := models.NewSysRoleMenu()
            roleMenu.RoleID = roleID
            roleMenu.MenuID = menuID
            if err := tx.Create(roleMenu).Error; err != nil {
                return err
            }
        }

        return nil
    })
}
```

### 为菜单分配API

```go
func (s *SysMenuService) AssignApis(c *gin.Context, menuID uint, apiIDs []uint) error {
    return app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
        // 删除菜单的所有API关联
        tx.Where("menu_id = ?", menuID).Delete(&models.SysMenuApi{})

        // 添加新的API关联
        for _, apiID := range apiIDs {
            menuApi := models.NewSysMenuApi()
            menuApi.MenuID = menuID
            menuApi.ApiID = apiID
            if err := tx.Create(menuApi).Error; err != nil {
                return err
            }
        }

        return nil
    })
}
```

---

## 最佳实践

### 1. 菜单类型规范

| 类型 | 值 | 说明 | 权限标识 |
|------|---|------|---------|
| 目录 | 1 | 用于组织菜单结构 | 无 |
| 菜单 | 2 | 具体的功能菜单 | 无 |
| 按钮 | 3 | 操作按钮 | 有 |

```go
// 菜单模型
type SysMenu struct {
    BaseModel
    Name       string `gorm:"column:name;size:50;not null;comment:菜单名称" json:"name"`
    Type       int8   `gorm:"column:type;not null;comment:类型 1目录 2菜单 3按钮" json:"type"`
    Permission string `gorm:"column:permission;size:100;comment:权限标识" json:"permission"`
}
```

### 2. 权限标识命名规范

使用 `模块:功能:操作` 格式：

```
system:user:add      # 添加用户
system:user:edit     # 编辑用户
system:user:delete   # 删除用户
system:user:list     # 查询用户列表
system:user:export   # 导出用户
```

### 3. 跳过权限检查

对于超级管理员，跳过权限检查：

```go
func IsSkipAuthUser(userID uint) bool {
    // 超级管理员ID为1
    return userID == 1
}
```

### 4. 动态权限加载

用户登录后动态加载权限：

```go
func (s *UserService) GetUserProfile(c *gin.Context, userID uint) (*models.UserProfile, error) {
    user := models.NewUser()
    if err := user.GetByID(c, userID); err != nil {
        return nil, err
    }

    permissions := []string{}

    // 跳过权限检查的用户
    if common.IsSkipAuthUser(userID) {
        permissions = append(permissions, "*:*:*")
    } else {
        // 获取用户的所有角色ID
        roleIDs := user.Roles.GetRoleIDs()

        // 获取角色关联的菜单ID
        roleMenuList := models.NewSysRoleMenuList()
        roleMenuList.Find(c, func(db *gorm.DB) *gorm.DB {
            return db.Where("role_id IN ?", roleIDs)
        })

        menuIDs := roleMenuList.GetMenuIDs()

        // 查询按钮类型的菜单
        buttonMenus := models.NewSysMenuList()
        buttonMenus.Find(c, func(db *gorm.DB) *gorm.DB {
            return db.Select("permission").
                   Where("id IN ? AND type = ? AND permission != ''", menuIDs, 3)
        })

        // 提取权限标识
        for _, menu := range *buttonMenus {
            permissions = append(permissions, menu.Permission)
        }
    }

    return &models.UserProfile{
        User:        *user,
        Permissions: permissions,
    }, nil
}
```

### 5. 权限缓存

使用缓存提高权限检查性能：

```go
func (s *CasbinService) EnforceWithCache(userID uint, path, method string) (bool, error) {
    // 构建缓存键
    cacheKey := fmt.Sprintf("casbin:%d:%s:%s", userID, path, method)

    // 从缓存获取
    if cached, err := app.Cache.Get(context.Background(), cacheKey); err == nil {
        return cached.(bool), nil
    }

    // 检查权限
    allowed, err := app.Casbin.Enforce(userID, path, method)
    if err != nil {
        return false, err
    }

    // 存入缓存
    app.Cache.Set(context.Background(), cacheKey, allowed, 5*time.Minute)

    return allowed, nil
}
```

### 6. 权限继承

角色支持继承父角色的权限：

```go
func (s *SysRoleService) GetAllAncestorRoleIDs(c *gin.Context, roleIDs []uint) ([]uint, error) {
    allRoleIDs := make([]uint, 0)
    visited := make(map[uint]bool)

    for _, roleID := range roleIDs {
        if err := s.collectAncestorRoles(c, roleID, &allRoleIDs, visited); err != nil {
            return nil, err
        }
    }

    return allRoleIDs, nil
}

func (s *SysRoleService) collectAncestorRoles(c *gin.Context, roleID uint, roleIDs *[]uint, visited map[uint]bool) error {
    if visited[roleID] {
        return nil
    }
    visited[roleID] = true
    *roleIDs = append(*roleIDs, roleID)

    role := models.NewSysRole()
    if err := role.GetByID(c, roleID); err != nil {
        return err
    }

    if role.ParentID != 0 {
        return s.collectAncestorRoles(c, role.ParentID, roleIDs, visited)
    }

    return nil
}
```

---

## 参考资源

### 项目内部资源

- [`app/middleware/casbin.go`](../app/middleware/casbin.go) - Casbin 中间件
- [`app/service/casbinservice.go`](../app/service/casbinservice.go) - Casbin 服务
- [`app/models/sysrolemenu.go`](../app/models/sysrolemenu.go) - 角色菜单关联模型
- [`app/models/sysmenuapi.go`](../app/models/sysmenuapi.go) - 菜单API关联模型
- [`app/models/sysmenu.go`](../app/models/sysmenu.go) - 菜单模型
