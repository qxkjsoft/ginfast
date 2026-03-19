---
name: gorm
description: 使用 GORM 时
modeSlugs:
  - code
  - architect
---

# GORM 使用指南

GinFast 使用 GORM 作为 ORM 框架，支持 MySQL、SQL Server、PostgreSQL 数据库。

## 目录

- [快速开始](#快速开始)
- [数据库连接](#数据库连接)
- [模型定义](#模型定义)
- [查询操作](#查询操作)
- [创建更新删除](#创建更新删除)
- [关联关系](#关联关系)
- [事务处理](#事务处理)
- [钩子函数](#钩子函数)
- [最佳实践](#最佳实践)

---

## 快速开始

### 获取数据库实例

```go
import "gin-fast/app/global/app"

// 获取数据库实例
db := app.DB()

// 带上下文的数据库实例
db := app.DB().WithContext(ctx)
```

### 基本查询

```go
// 查询单条记录
user := models.NewUser()
err := user.GetByID(ctx, 1)

// 查询列表
users := models.NewUserList()
err = users.Find(ctx)
```

---

## 数据库连接

### 数据库配置

在 `config/config.yml` 中配置数据库：

```yaml
database:
  default: # 默认数据库
    dbtype: mysql
    host: 127.0.0.1
    port: 3306
    dbname: ginfast
    username: root
    password: password
    maxopenconns: 100
    maxidleconns: 10
    logmode: true
```

### 多数据库支持

```yaml
database:
  default:
    dbtype: mysql
    # ...
  postgres: # PostgreSQL 数据库
    dbtype: postgres
    host: 127.0.0.1
    port: 5432
    # ...
```

### 初始化数据库

```go
// app/utils/gormhelper/client.go
func InitGORM() {
    // 初始化默认数据库
    app.DB = initDB("default")

    // 初始化其他数据库
    app.PostgresDB = initDB("postgres")
}
```

---

## 模型定义

### 模型标签

```go
type User struct {
    BaseModel
    Username string `gorm:"column:username;size:50;not null;uniqueIndex;comment:用户名" json:"username"`
    Email    string `gorm:"column:email;size:100;comment:邮箱" json:"email"`
    Status   int8   `gorm:"column:status;default:1;comment:状态" json:"status"`
}
```

### 常用标签

| 标签 | 说明 | 示例 |
|------|------|------|
| `column` | 字段名 | `gorm:"column:user_name"` |
| `size` | 字段大小 | `gorm:"size:100"` |
| `not null` | 非空 | `gorm:"not null"` |
| `default` | 默认值 | `gorm:"default:1"` |
| `unique` | 唯一索引 | `gorm:"unique"` |
| `uniqueIndex` | 唯一索引命名 | `gorm:"uniqueIndex:idx_username"` |
| `index` | 普通索引 | `gorm:"index"` |
| `comment` | 字段注释 | `gorm:"comment:用户名"` |
| `primaryKey` | 主键 | `gorm:"primaryKey"` |
| `autoIncrement` | 自增 | `gorm:"autoIncrement"` |
| `autoCreateTime` | 自动创建时间 | `gorm:"autoCreateTime"` |
| `autoUpdateTime` | 自动更新时间 | `gorm:"autoUpdateTime"` |

### 表名约定

```go
// 自定义表名
func (User) TableName() string {
    return "sys_users"
}

// 使用结构体名的蛇形形式
type UserOrder struct {} // 表名: user_orders
```

---

## 查询操作

### 基本查询

```go
// 查询单条记录
user := models.NewUser()
err := app.DB().WithContext(ctx).Where("id = ?", 1).First(user).Error

// 查询多条记录
users := models.NewUserList()
err = app.DB().WithContext(ctx).Find(users).Error
```

### 条件查询

```go
// Where 条件
db.Where("name = ?", "john")
db.Where("name LIKE ?", "%john%")
db.Where("age > ?", 18)
db.Where("age IN ?", []int{18, 20, 25})

// 多条件
db.Where("name = ? AND age > ?", "john", 18)

// Or 条件
db.Where("name = ?", "john").Or("name = ?", "jane")
```

### 排序和分页

```go
// 排序
db.Order("created_at DESC")
db.Order("id DESC, name ASC")

// 分页
db.Offset(0).Limit(10)
```

### 聚合查询

```go
// 计数
var count int64
db.Model(&User{}).Count(&count)

// 求和
var sum int
db.Model(&User{}).Select("SUM(age)").Scan(&sum)

// 平均值
var avg float64
db.Model(&User{}).Select("AVG(age)").Scan(&avg)
```

### 预加载关联

```go
// 预加载单个关联
db.Preload("Department").First(user)

// 预加载多个关联
db.Preload("Department").Preload("Roles").First(user)

// 预加载嵌套关联
db.Preload("Roles.Permissions").First(user)
```

### 使用 Scopes

```go
// 定义 Scope
func ActiveUsers(db *gorm.DB) *gorm.DB {
    return db.Where("status = ?", 1)
}

func CreatedAfter(db *gorm.DB, date time.Time) *gorm.DB {
    return db.Where("created_at > ?", date)
}

// 使用 Scope
db.Scopes(ActiveUsers, CreatedAfter(time.Now().AddDate(-1, 0, 0))).Find(users)
```

---

## 创建更新删除

### 创建记录

```go
user := models.NewUser()
user.Username = "john"
user.Email = "john@example.com"

err := app.DB().WithContext(ctx).Create(user).Error
```

### 批量创建

```go
users := []models.User{
    {Username: "john", Email: "john@example.com"},
    {Username: "jane", Email: "jane@example.com"},
}

err := app.DB().WithContext(ctx).Create(&users).Error
```

### 更新记录

```go
// 更新单个字段
app.DB().WithContext(ctx).Model(user).Update("email", "new@example.com")

// 更新多个字段
app.DB().WithContext(ctx).Model(user).Updates(map[string]interface{}{
    "email": "new@example.com",
    "status": 1,
})

// 更新整个结构体
app.DB().WithContext(ctx).Save(user)
```

### 删除记录

```go
// 软删除
app.DB().WithContext(ctx).Delete(user)

// 硬删除
app.DB().WithContext(ctx).Unscoped().Delete(user)

// 批量删除
app.DB().WithContext(ctx).Where("age < ?", 18).Delete(&User{})
```

---

## 关联关系

### 一对一

```go
type User struct {
    BaseModel
    Profile     Profile `gorm:"foreignKey:UserID;references:ID" json:"profile"`
}

type Profile struct {
    BaseModel
    UserID uint `gorm:"column:user_id;comment:用户ID" json:"userId"`
    User   User `gorm:"foreignKey:UserID" json:"user"`
}
```

### 一对多

```go
type Department struct {
    BaseModel
    Name   string `gorm:"column:name;size:50;comment:部门名称" json:"name"`
    Users  []User `gorm:"foreignKey:DeptID;references:ID" json:"users"`
}

type User struct {
    BaseModel
    DeptID     uint       `gorm:"column:dept_id;comment:部门ID" json:"deptId"`
    Department Department `gorm:"foreignKey:DeptID" json:"department"`
}
```

### 多对多

```go
type User struct {
    BaseModel
    Roles []Role `gorm:"many2many:sys_user_role;foreignKey:id;joinForeignKey:user_id;references:id;joinReferences:role_id" json:"roles"`
}

type Role struct {
    BaseModel
    Name  string `gorm:"column:name;size:50;comment:角色名称" json:"name"`
    Users []User `gorm:"many2many:sys_user_role" json:"users"`
}
```

---

## 事务处理

### 基本事务

```go
err := app.DB().WithContext(ctx).Transaction(func(tx *gorm.DB) error {
    // 创建用户
    if err := tx.Create(&user).Error; err != nil {
        return err
    }

    // 创建用户角色关联
    if err := tx.Create(&userRole).Error; err != nil {
        return err
    }

    return nil
})
```

### 嵌套事务

```go
err := app.DB().WithContext(ctx).Transaction(func(tx *gorm.DB) error {
    return tx.Transaction(func(tx2 *gorm.DB) error {
        // 嵌套事务逻辑
        return nil
    })
})
```

---

## 钩子函数

### 模型钩子

```go
type User struct {
    BaseModel
    Username string `gorm:"column:username;size:50;not null" json:"username"`
}

// 创建前
func (u *User) BeforeCreate(tx *gorm.DB) error {
    println("创建前")
    return nil
}

// 创建后
func (u *User) AfterCreate(tx *gorm.DB) error {
    println("创建后")
    return nil
}

// 更新前
func (u *User) BeforeUpdate(tx *gorm.DB) error {
    println("更新前")
    return nil
}

// 更新后
func (u *User) AfterUpdate(tx *gorm.DB) error {
    println("更新后")
    return nil
}

// 删除前
func (u *User) BeforeDelete(tx *gorm.DB) error {
    println("删除前")
    return nil
}

// 删除后
func (u *User) AfterDelete(tx *gorm.DB) error {
    println("删除后")
    return nil
}
```

---

## 最佳实践

### 1. 使用 WithContext

始终使用 `WithContext` 传递上下文：

```go
// 好的做法
app.DB().WithContext(ctx).Where("id = ?", 1).First(user)

// 不好的做法
app.DB().Where("id = ?", 1).First(user)
```

### 2. 错误处理

始终检查错误：

```go
if err := app.DB().WithContext(ctx).First(user).Error; err != nil {
    if errors.Is(err, gorm.ErrRecordNotFound) {
        return errors.New("记录不存在")
    }
    return err
}
```

### 3. 使用模型方法

在模型中封装数据库操作：

```go
// 好的做法
user := models.NewUser()
err := user.GetByID(ctx, 1)

// 不好的做法
user := &models.User{}
err := app.DB().WithContext(ctx).Where("id = ?", 1).First(user).Error
```

### 4. 使用事务

对于多个数据库操作，使用事务：

```go
err := app.DB().WithContext(ctx).Transaction(func(tx *gorm.DB) error {
    // 多个操作
    return nil
})
```

### 5. 预加载关联

使用 `Preload` 避免 N+1 查询：

```go
// 好的做法
db.Preload("Department").Preload("Roles").First(user)

// 不好的做法
db.First(user)
// 然后单独查询关联
```

### 6. 使用 Scopes

使用 Scopes 复用查询逻辑：

```go
// 定义 Scope
func ActiveUsers(db *gorm.DB) *gorm.DB {
    return db.Where("status = ?", 1)
}

// 使用 Scope
db.Scopes(ActiveUsers).Find(users)
```

### 7. 租户数据隔离

使用租户作用域自动过滤数据：

```go
import "gin-fast/app/utils/tenanthelper"

db.Scopes(tenanthelper.TenantScope(c)).Find(users)
```

### 8. 日志记录

在开发环境开启 SQL 日志：

```yaml
database:
  default:
    logmode: true
```

---

## 参考资源

### 项目内部资源

- [`app/models/base.go`](../app/models/base.go) - BaseModel 定义
- [`app/models/user.go`](../app/models/user.go) - 用户模型示例
- [`app/utils/gormhelper/client.go`](../app/utils/gormhelper/client.go) - GORM 客户端初始化
- [`app/utils/gormhelper/hook.go`](../app/utils/gormhelper/hook.go) - GORM 钩子

### 外部资源

- [GORM 官方文档](https://gorm.io/zh_CN/docs/)
- [GORM GitHub](https://github.com/go-gorm/gorm)
