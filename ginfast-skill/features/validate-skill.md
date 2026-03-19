---
name: validate
description: 验证前端参数时
modeSlugs:
  - code
  - architect
---

# 参数验证指南

本项目使用 [github.com/gookit/validate](https://github.com/gookit/validate) 作为数据验证库。

## 目录

- [快速开始](#快速开始)
- [在ginfast框架中使用](#在ginfast框架中使用)
- [内置验证器规则](#内置验证器规则)
- [最佳实践](#最佳实践)

---

## 快速开始

### 安装

```bash
go get github.com/gookit/validate
```

### 基本使用

```go
import "github.com/gookit/validate"

// 快速验证单个值
ok := validate.Val("xyz@mail.com", "required|email")
```

---

## 在ginfast框架中使用

本项目封装了统一的验证器，位于 [`app/models/base.go`](../app/models/base.go)。

### 核心组件

#### 1. Validator 验证器

```go
// Validator 验证器结构
type Validator struct {
    BaseRequest
}

// Check 验证参数方法
func (vt *Validator) Check(c *gin.Context, obj interface{}) error {
    // 1. 绑定请求参数
    if err := vt.Bind(c, obj); err != nil {
        return err
    }

    // 2. 使用gookit/validate验证参数
    v := validate.Struct(obj)
    if !v.Validate() {
        return v.Errors.OneError()
    }
    return nil
}
```

#### 2. BaseRequest 基础请求

```go
// BaseRequest 基础请求结构
type BaseRequest struct{}

// Bind 绑定请求参数
func (r *BaseRequest) Bind(c *gin.Context, obj interface{}) error {
    // 根据请求方法和Content-Type自动选择绑定方式：
    // - GET请求：绑定query和uri参数
    // - JSON请求：绑定JSON body
    // - 表单请求：绑定form数据
    // - 支持数组参数解析（如 ids[0]=1&ids[1]=2）
}
```

### 定义Param结构体

在 `app/models` 目录下创建Param结构体，嵌入 `Validator`：

```go
// app/models/userparam.go
package models

import "github.com/gin-gonic/gin"

// LoginRequest 登录请求参数
type LoginRequest struct {
    Validator
    Username   string `form:"username" validate:"required" message:"用户名不能为空"`
    Password   string `form:"password" validate:"required|min_len:6" message:"密码至少6位"`
    TenantCode string `form:"tenantCode"`
}

// Validate 实现验证接口
func (r *LoginRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}
```

### 在Controller中使用

```go
// app/controllers/user.go
package controllers

import (
    "github.com/gin-gonic/gin"
    "gin-fast/app/models"
)

// Login 用户登录
func Login(c *gin.Context) {
    var param models.LoginRequest
    
    // 验证参数
    if err := param.Validate(c); err != nil {
        // 返回错误响应
        c.JSON(400, gin.H{"code": 400, "msg": err.Error()})
        return
    }
    
    // 参数验证通过，处理业务逻辑
    // ...
}
```

### 支持的参数绑定方式

| 请求方式 | Content-Type | 绑定方式 |
|----------|--------------|----------|
| GET | - | Query参数 + URI参数 |
| POST | application/json | JSON Body + URI参数 |
| POST | application/x-www-form-urlencoded | Form数据 + Query参数 + URI参数 |
| POST | multipart/form-data | Form数据 + Query参数 + URI参数 |

### 数组参数支持

框架支持数组参数的自动解析，支持以下格式：

```
ids=1&ids=2&ids=3
ids[0]=1&ids[1]=2&ids[2]=3
```

```go
type UserListRequest struct {
    Validator
    Ids []uint `form:"ids"` // 自动解析为数组
}
```

---

## 内置验证器规则

### 必填验证

| 验证器 | 说明 | 示例 |
|--------|------|------|
| `required` | 字段为必填项，值不能为空 | `validate:"required"` |
| `required_if` | 如果其他字段为指定值，则当前字段必填 | `validate:"required_if:field,value"` |
| `required_unless` | 如果其他字段不为指定值，则当前字段必填 | `validate:"required_unless:field,value"` |
| `required_with` | 在其他任一指定字段出现时必填 | `validate:"required_with:field1,field2"` |
| `required_with_all` | 只有在其他指定字段全部出现时才必填 | `validate:"required_with_all:field1,field2"` |
| `required_without` | 在其他指定任一字段不出现时必填 | `validate:"required_without:field1,field2"` |
| `required_without_all` | 只有在其他指定字段全部不出现时必填 | `validate:"required_without_all:field1,field2"` |
| `safe` / `-` | 标记当前字段是安全的，无需验证 | `validate:"-"` |

### 类型验证

| 验证器 | 说明 | 示例 |
|--------|------|------|
| `int` / `isInt` | 检查值是int类型，支持范围检查 | `validate:"int"` `validate:"int:1,100"` |
| `uint` / `isUint` | 检查值是uint类型 | `validate:"uint"` |
| `bool` / `isBool` | 检查值是布尔字符串 | `validate:"bool"` |
| `string` / `isString` | 检查值是字符串类型，支持长度检查 | `validate:"string"` `validate:"string:2,12"` |
| `float` / `isFloat` | 检查值是float类型 | `validate:"float"` |
| `slice` / `isSlice` | 检查值是slice类型 | `validate:"slice"` |
| `array` / `isArray` | 检查值是array或slice类型 | `validate:"array"` |
| `map` / `isMap` | 检查值是map类型 | `validate:"map"` |
| `strings` / `isStrings` | 检查值是字符串切片类型 | `validate:"strings"` |
| `ints` / `isInts` | 检查值是int切片类型 | `validate:"ints"` |

### 大小、长度验证

| 验证器 | 说明 | 示例 |
|--------|------|------|
| `min` / `gte` | 检查值大于或等于给定值 | `validate:"min:1"` |
| `max` / `lte` | 检查值小于或等于给定值 | `validate:"max:99"` |
| `gt` / `greaterThan` | 检查值大于给定值 | `validate:"gt:0"` |
| `lt` / `lessThan` | 检查值小于给定值 | `validate:"lt:100"` |
| `len` / `length` | 检查值长度等于给定大小 | `validate:"len:6"` |
| `min_len` / `minLength` | 检查值的最小长度 | `validate:"min_len:6"` |
| `max_len` / `maxLength` | 检查值的最大长度 | `validate:"max_len:20"` |
| `range` / `between` | 检查值是否在给定范围内 | `validate:"range:1,100"` |

### 字段值比较验证

| 验证器 | 说明 | 示例 |
|--------|------|------|
| `eq` / `equal` | 检查值是否等于给定值 | `validate:"eq:active"` |
| `ne` / `notEqual` | 检查值是否不等于给定值 | `validate:"ne:inactive"` |
| `eq_field` | 检查字段值是否等于另一个字段的值 | `validate:"eq_field:PasswordConfirm"` |
| `ne_field` | 检查字段值是否不等于另一个字段的值 | `validate:"ne_field:OldPassword"` |
| `gt_field` | 检查字段值是否大于另一个字段的值 | `validate:"gt_field:MinValue"` |
| `gte_field` | 检查字段值是否大于或等于另一个字段的值 | `validate:"gte_field:MinValue"` |
| `lt_field` | 检查字段值是否小于另一个字段的值 | `validate:"lt_field:MaxValue"` |
| `lte_field` | 检查字段值是否小于或等于另一个字段的值 | `validate:"lte_field:MaxValue"` |

### 字符串检查验证

| 验证器 | 说明 | 示例 |
|--------|------|------|
| `email` / `isEmail` | 检查值是Email地址 | `validate:"email"` |
| `url` / `isURL` | 检查值是URL字符串 | `validate:"url"` |
| `full_url` / `isFullURL` | 检查值是完整的URL(必须以http/https开头) | `validate:"full_url"` |
| `ip` / `isIP` | 检查值是IP(v4或v6)字符串 | `validate:"ip"` |
| `ipv4` / `isIPv4` | 检查值是IPv4字符串 | `validate:"ipv4"` |
| `ipv6` / `isIPv6` | 检查值是IPv6字符串 | `validate:"ipv6"` |
| `alpha` / `isAlpha` | 验证值仅包含字母字符 | `validate:"alpha"` |
| `alpha_num` / `isAlphaNum` | 验证仅包含字母、数字 | `validate:"alpha_num"` |
| `alpha_dash` / `isAlphaDash` | 验证仅包含字母、数字、破折号、下划线 | `validate:"alpha_dash"` |
| `ascii` / `isASCII` | 检查值是ASCII字符串 | `validate:"ascii"` |
| `contains` | 检查值是否包含给定的值 | `validate:"contains:keyword"` |
| `not_contains` | 检查值是否不包含给定值 | `validate:"not_contains:keyword"` |
| `starts_with` | 检查字符串是否以给定值开始 | `validate:"starts_with:prefix"` |
| `ends_with` | 检查字符串是否以给定值结束 | `validate:"ends_with:suffix"` |
| `regex` / `regexp` | 检查值是否通过正则验证 | `validate:"regexp:^\\d+$"` |

### 枚举验证

| 验证器 | 说明 | 示例 |
|--------|------|------|
| `in` / `enum` | 检查值是否在给定的枚举列表中 | `validate:"in:active,pending,deleted"` |
| `not_in` / `notIn` | 检查值是否不在给定的枚举列表中 | `validate:"not_in:banned,blocked"` |

### 日期验证

| 验证器 | 说明 | 示例 |
|--------|------|------|
| `date` / `isDate` | 检查值是否为日期字符串 | `validate:"date"` |
| `gt_date` / `afterDate` | 检查值是否大于给定的日期 | `validate:"gt_date:2024-01-01"` |
| `lt_date` / `beforeDate` | 检查值是否小于给定的日期 | `validate:"lt_date:2024-12-31"` |
| `gte_date` / `afterOrEqualDate` | 检查值是否大于或等于给定的日期 | `validate:"gte_date:2024-01-01"` |
| `lte_date` / `beforeOrEqualDate` | 检查值是否小于或等于给定的日期 | `validate:"lte_date:2024-12-31"` |

### 文件验证

| 验证器 | 说明 | 示例 |
|--------|------|------|
| `file` / `isFile` | 验证是否是上传的文件 | `validate:"file"` |
| `image` / `isImage` | 验证是否是上传的图片文件 | `validate:"image"` |
| `mime` / `mimeType` | 验证文件是否在指定的MIME类型中 | `validate:"mime:image/jpeg,image/png"` |

### 特殊格式验证

| 验证器 | 说明 | 示例 |
|--------|------|------|
| `uuid` / `isUUID` | 检查值是UUID字符串 | `validate:"uuid"` |
| `uuid3` / `isUUID3` | 检查值是UUID3字符串 | `validate:"uuid3"` |
| `uuid4` / `isUUID4` | 检查值是UUID4字符串 | `validate:"uuid4"` |
| `uuid5` / `isUUID5` | 检查值是UUID5字符串 | `validate:"uuid5"` |
| `json` / `isJSON` | 检查值是JSON字符串 | `validate:"json"` |
| `base64` / `isBase64` | 检查值是Base64字符串 | `validate:"base64"` |
| `hex_color` / `isHexColor` | 检查值是16进制颜色字符串 | `validate:"hex_color"` |
| `rgb_color` / `isRGBColor` | 检查值是RGB颜色字符串 | `validate:"rgb_color"` |
| `mac` / `isMAC` | 检查值是MAC字符串 | `validate:"mac"` |
| `cn_mobile` / `isCnMobile` | 检查值是中国11位手机号码 | `validate:"cn_mobile"` |
| `lat` / `isLatitude` | 检查值是纬度坐标 | `validate:"lat"` |
| `lon` / `isLongitude` | 检查值是经度坐标 | `validate:"lon"` |
| `isbn10` / `isISBN10` | 检查值是ISBN10字符串 | `validate:"isbn10"` |
| `isbn13` / `isISBN13` | 检查值是ISBN13字符串 | `validate:"isbn13"` |
| `dns_name` / `isDNSName` | 检查值是DNS名称字符串 | `validate:"dns_name"` |
| `cidr` / `isCIDR` | 检查值是CIDR字符串 | `validate:"cidr"` |

---

## 最佳实践

### 1. 统一的Param结构

创建请求参数结构体时，建议统一使用 `Request` 后缀，并嵌入 `Validator`：

```go
// app/models/userparam.go
package models

import "github.com/gin-gonic/gin"

// AddRequest 添加用户请求参数
type AddRequest struct {
    Validator
    UserName string `form:"userName" validate:"required" message:"用户名不能为空"`
    Email    string `form:"email" validate:"required|email" message:"邮箱格式不正确"`
    Age      int    `form:"age" validate:"required|int|min:1|max:150" message:"年龄必须在1-150之间"`
}

func (r *AddRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}
```

### 2. 使用BasePaging分页

对于列表查询，嵌入 `BasePaging` 实现分页功能：

```go
// app/models/userparam.go
type UserListRequest struct {
    BasePaging    // 嵌入分页结构
    Validator
    Name   string `form:"name" validate:"max_len:50"`
    Status string `form:"status" validate:"in:0,1"`
}

func (r *UserListRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

// 在Controller中使用
func GetUserList(c *gin.Context) {
    var param models.UserListRequest
    if err := param.Validate(c); err != nil {
        c.JSON(400, gin.H{"code": 400, "msg": err.Error()})
        return
    }
    
    // 使用分页
    db := param.Paginate()(gormDB)
    // ...
}
```

### 3. 自定义验证逻辑

在 `Validate` 方法中添加自定义验证逻辑：

```go
// app/models/userparam.go
type UpdatePasswordRequest struct {
    Validator
    OldPassword string `form:"oldPassword" validate:"required" message:"原密码不能为空"`
    NewPassword string `form:"newPassword" validate:"required|min_len:6" message:"新密码至少6位"`
    ConfirmPwd  string `form:"confirmPwd" validate:"required" message:"确认密码不能为空"`
}

func (r *UpdatePasswordRequest) Validate(c *gin.Context) error {
    // 先进行基础验证
    if err := r.Check(c, r); err != nil {
        return err
    }
    
    // 自定义验证：确认密码必须一致
    if r.NewPassword != r.ConfirmPwd {
        return errors.New("两次输入的密码不一致")
    }
    
    return nil
}
```

### 4. 使用Handle方法处理查询逻辑

对于复杂的查询条件，实现 `Handle` 方法：

```go
// app/models/userparam.go
type UserListRequest struct {
    BasePaging
    Validator
    DeptIds []uint  `form:"deptIds"`
    Name    string  `form:"name"`
    Status  string  `form:"status"`
}

func (r *UserListRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

// Handle 返回GORM查询条件函数
func (r *UserListRequest) Handle() func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        if len(r.DeptIds) > 0 {
            db = db.Where("dept_id IN ?", r.DeptIds)
        }
        if r.Name != "" {
            db = db.Where("name LIKE ?", "%"+r.Name+"%")
        }
        if r.Status != "" {
            db = db.Where("status = ?", r.Status)
        }
        return db
    }
}

// 在Controller中使用
func GetUserList(c *gin.Context) {
    var param models.UserListRequest
    if err := param.Validate(c); err != nil {
        c.JSON(400, gin.H{"code": 400, "msg": err.Error()})
        return
    }
    
    // 使用Handle方法应用查询条件
    users := []models.User{}
    db := param.Handle()(gormDB)
    db = param.Paginate()(db)
    db.Find(&users)
    // ...
}
```

### 5. 标签使用规范

| 标签 | 用途 | 示例 |
|------|------|------|
| `form` | 定义表单字段名 | `form:"userName"` |
| `validate` | 定义验证规则 | `validate:"required|min_len:6"` |
| `message` | 定义错误消息 | `message:"用户名不能为空"` |
| `label` | 定义字段中文名（用于错误消息） | `label:"用户名"` |
| `filter` | 定义过滤器 | `filter:"trim|lower"` |

### 6. 常用验证模式

```go
// 必填字段
Name string `form:"name" validate:"required" message:"名称不能为空"`

// 可选字段
Phone string `form:"phone" validate:"cn_mobile" message:"手机号格式不正确"`

// 枚举验证
Status string `form:"status" validate:"required|in:0,1" message:"状态值不正确"`

// 数值范围
Age int `form:"age" validate:"int|min:1|max:150" message:"年龄必须在1-150之间"`

// 字符串长度
Password string `form:"password" validate:"required|min_len:6|max_len:20" message:"密码长度必须在6-20位之间"`

// 邮箱验证
Email string `form:"email" validate:"email" message:"邮箱格式不正确"`

// 数组验证
Roles []uint `form:"roles" validate:"required" message:"角色不能为空"`

// 日期范围
CreateTime []string `form:"createTime"` // 配合Handle方法处理
```

---

## 参考资源

### 外部资源

- [gookit/validate GitHub](https://github.com/gookit/validate)
- [gookit/validate GoDoc](https://pkg.go.dev/github.com/gookit/validate)

### 项目内部资源

- [`app/models/base.go`](../app/models/base.go) - Validator和BaseRequest定义
- [`app/models/userparam.go`](../app/models/userparam.go) - 用户参数示例
- [`app/controllers/user.go`](../app/controllers/user.go) - Controller使用示例
