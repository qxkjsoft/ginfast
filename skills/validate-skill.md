# 验证器使用指南

本项目使用 [github.com/gookit/validate](https://github.com/gookit/validate) 作为数据验证库。

## 目录

- [快速开始](#快速开始)
- [验证结构体](#验证结构体)
- [验证Map数据](#验证map数据)
- [验证HTTP请求](#验证http请求)
- [内置验证器规则](#内置验证器规则)
- [内置过滤器](#内置过滤器)
- [自定义验证器](#自定义验证器)
- [在ginfast框架中使用](#在ginfast框架中使用)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [参考资源](#参考资源)

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

## 验证结构体

### 使用标签快速配置验证

在结构体上添加 `validate` 标签，可以快速对结构体进行验证设置。

```go
type UserForm struct {
    Name     string    `validate:"required|min_len:7" message:"required:{field}不能为空" label:"用户名称"`
    Email    string    `validate:"email" message:"邮箱格式不正确" label:"用户邮箱"`
    Age      int       `validate:"required|int|min:1|max:99" message:"年龄必须在1-99之间"`
    Safe     int       `validate:"-"` // 标记字段安全无需验证
}
```

### 支持的标签

| 标签 | 说明 |
|------|------|
| `validate` | 定义验证规则，多个规则用 `|` 分隔 |
| `message` | 自定义错误消息，支持 `{field}` 占位符 |
| `label` | 定义字段的中文名称，用于错误消息显示 |
| `filter` | 定义过滤规则，在验证前对数据进行处理 |

### 使用结构体方法配置验证

结构体可以实现以下接口方法：

```go
type UserForm struct {
    Name  string `validate:"required|min_len:7"`
    Email string `validate:"email"`
}

// ConfigValidation 配置验证场景
func (f UserForm) ConfigValidation(v *validate.Validation) {
    v.WithScenes(validate.SValues{
        "create": []string{"Name", "Email"},
        "update": []string{"Name"},
    })
}

// Messages 自定义验证器错误消息
func (f UserForm) Messages() map[string]string {
    return validate.MS{
        "required":     "{field}是必填项",
        "Name.required": "用户名不能为空",
    }
}

// Translates 自定义字段翻译
func (f UserForm) Translates() map[string]string {
    return validate.MS{
        "Name":  "用户名称",
        "Email": "用户邮箱",
    }
}
```

### 创建和调用验证

```go
func main() {
    u := &UserForm{
        Name: "inhere",
    }
    
    // 创建 Validation 实例
    v := validate.Struct(u)
    
    if v.Validate() { // 验证成功
        // 处理业务逻辑
    } else {
        fmt.Println(v.Errors)        // 所有的错误消息
        fmt.Println(v.Errors.One())  // 返回随机一条错误消息
        fmt.Println(v.Errors.Field("Name")) // 返回该字段的错误消息
    }
}
```

---

## 验证Map数据

```go
m := map[string]any{
    "name":  "inhere",
    "age":   100,
    "email": "some@email.com",
}

v := validate.Map(m)
v.AddRule("name", "required")
v.AddRule("name", "minLen", 7)
v.StringRule("age", "required|int|min:1|max:99")

if v.Validate() {
    // 验证成功
} else {
    fmt.Println(v.Errors)
}
```

---

## 验证HTTP请求

传入 `*http.Request`，会自动根据请求方法和请求数据类型收集相应的数据：

- `GET/DELETE` 等：搜集 url query 数据
- `POST/PUT/PATCH` 且 `application/json`：搜集JSON数据
- `POST/PUT/PATCH` 且 `multipart/form-data`：搜集表单和文件数据
- `POST/PUT/PATCH` 且 `application/x-www-form-urlencoded`：搜集表单数据

```go
func handler(w http.ResponseWriter, r *http.Request) {
    data, err := validate.FromRequest(r)
    if err != nil {
        panic(err)
    }
    
    v := data.Create()
    v.StringRule("name", "required|minLen:7")
    v.StringRule("age", "required|int|min:1|max:99")
    
    if v.Validate() {
        userForm := &UserForm{}
        v.BindSafeData(userForm)
        // 处理业务逻辑
    } else {
        fmt.Println(v.Errors)
    }
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
| `required_without_all` | 只有在其他指定字段全部不出现时才必填 | `validate:"required_without_all:field1,field2"` |
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

### 路径验证

| 验证器 | 说明 | 示例 |
|--------|------|------|
| `file_path` / `isFilePath` | 检查值是一个存在的文件路径 | `validate:"file_path"` |
| `unix_path` / `isUnixPath` | 检查值是Unix路径字符串 | `validate:"unix_path"` |
| `win_path` / `isWinPath` | 检查值是Windows路径字符串 | `validate:"win_path"` |

---

## 内置过滤器

过滤器在验证前对数据进行处理和净化。

| 过滤器 | 说明 | 示例 |
|--------|------|------|
| `trim` / `trimSpace` | 去除字符串两边的空格 | `filter:"trim"` |
| `ltrim` / `trimLeft` | 去除字符串左边的空格 | `filter:"ltrim"` |
| `rtrim` / `trimRight` | 去除字符串右边的空格 | `filter:"rtrim"` |
| `int` / `toInt` | 转换值为int类型 | `filter:"int"` |
| `uint` / `toUint` | 转换值为uint类型 | `filter:"uint"` |
| `int64` / `toInt64` | 转换值为int64类型 | `filter:"int64"` |
| `float` / `toFloat` | 转换值为float类型 | `filter:"float"` |
| `bool` / `toBool` | 转换字符串为bool | `filter:"bool"` |
| `lower` / `lowercase` | 转换为小写 | `filter:"lower"` |
| `upper` / `uppercase` | 转换为大写 | `filter:"upper"` |
| `camel` / `camelCase` | 转换为驼峰命名 | `filter:"camel"` |
| `snake` / `snakeCase` | 转换为蛇形命名 | `filter:"snake"` |
| `escapeHtml` / `escapeHTML` | 转义HTML字符串 | `filter:"escapeHtml"` |
| `escapeJs` / `escapeJS` | 转义JS字符串 | `filter:"escapeJs"` |

---

## 自定义验证器

### 添加全局验证器

```go
func init() {
    validate.AddValidator("cnPhone", func(val any) bool {
        str, ok := val.(string)
        if !ok {
            return false
        }
        // 验证中国手机号
        matched, _ := regexp.MatchString(`^1[3-9]\d{9}$`, str)
        return matched
    })
}

// 使用
type UserForm struct {
    Phone string `validate:"cnPhone"`
}
```

### 添加临时验证器

```go
v := validate.Struct(data)
v.AddValidator("myValidator", func(val any) bool {
    // 自定义验证逻辑
    return true
})
```

### 在结构体中定义验证器

```go
type UserForm struct {
    Code string `validate:"customValidator"`
}

// CustomValidator 定义在结构体中的自定义验证器
func (f UserForm) CustomValidator(val string) bool {
    return len(val) == 4
}
```

---

## 在ginfast框架中使用

本项目封装了统一的验证器，位于 [`app/models/base.go`](app/models/base.go)。

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
    "your-project/app/models"
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

### 完整示例

```go
// app/models/userparam.go
package models

import "github.com/gin-gonic/gin"

// AddRequest 添加用户请求参数
type AddRequest struct {
    Validator
    UserName    string   `form:"userName" validate:"required" message:"用户名不能为空"`
    NickName    string   `form:"nickName" validate:"required" message:"昵称不能为空"`
    Phone       string   `form:"phone" validate:"cn_mobile" message:"手机号格式不正确"`
    Email       string   `form:"email" validate:"email" message:"邮箱格式不正确"`
    Password    string   `form:"password" validate:"required|min_len:6" message:"密码至少6位"`
    Sex         string   `form:"sex" validate:"required|in:男,女" message:"性别不能为空"`
    DeptId      uint     `form:"deptId" validate:"required" message:"部门ID不能为空"`
    Roles       []uint   `form:"roles" validate:"required" message:"角色不能为空"`
    Status      int8     `form:"status" validate:"in:0,1" message:"状态值不正确"`
    Description string   `form:"description" validate:"max_len:200" message:"描述最多200字"`
}

func (r *AddRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

// UpdateRequest 更新用户请求参数
type UpdateRequest struct {
    Validator
    Id          uint   `form:"id" validate:"required" message:"ID不能为空"`
    UserName    string `form:"userName" validate:"required" message:"用户名不能为空"`
    NickName    string `form:"nickName" validate:"required" message:"昵称不能为空"`
    Phone       string `form:"phone" validate:"cn_mobile" message:"手机号格式不正确"`
    Email       string `form:"email" validate:"email" message:"邮箱格式不正确"`
    Password    string `form:"password" validate:"min_len:6" message:"密码至少6位"`
    Sex         string `form:"sex" validate:"required|in:男,女" message:"性别不能为空"`
    DeptId      uint   `form:"deptId" validate:"required" message:"部门ID不能为空"`
    Roles       []uint `form:"roles" validate:"required" message:"角色不能为空"`
    Status      int8   `form:"status" validate:"in:0,1" message:"状态值不正确"`
    Description string `form:"description" validate:"max_len:200" message:"描述最多200字"`
}

func (r *UpdateRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

// UserListRequest 用户列表请求参数
type UserListRequest struct {
    BasePaging
    Validator
    DeptIds    []uint   `form:"deptIds"`
    Name       string   `form:"name" validate:"max_len:50"`
    Phone      string   `form:"phone" validate:"max_len:20"`
    Status     string   `form:"status" validate:"in:0,1"`
    CreateTime []string `form:"createTime"`
}

func (r *UserListRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
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

### 5. 全局配置

在应用初始化时配置全局验证选项：

```go
// bootstrap/init.go
package bootstrap

import (
    "github.com/gookit/validate"
    "github.com/gookit/validate/locales/zhcn"
)

func Init() {
    // 配置全局验证选项
    validate.Config(func(opt *validate.GlobalOption) {
        opt.StopOnError = false // 收集所有错误而不在第一个错误时停止
        opt.SkipOnEmpty = false // 不跳过空值检查
        opt.ValidateTag = "validate"
        opt.MessageTag = "message"
    })
    
    // 注册中文错误消息
    zhcn.RegisterGlobal()
    
    // 添加全局自定义验证器
    validate.AddValidator("cn_mobile", func(val any) bool {
        str, ok := val.(string)
        if !ok {
            return false
        }
        matched, _ := regexp.MatchString(`^1[3-9]\d{9}$`, str)
        return matched
    })
}
```

### 6. 标签使用规范

| 标签 | 用途 | 示例 |
|------|------|------|
| `form` | 定义表单字段名 | `form:"userName"` |
| `validate` | 定义验证规则 | `validate:"required\|min_len:6"` |
| `message` | 定义错误消息 | `message:"用户名不能为空"` |
| `label` | 定义字段中文名（用于错误消息） | `label:"用户名"` |
| `filter` | 定义过滤器 | `filter:"trim\|lower"` |

### 7. 常用验证模式

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

## 常见问题

### Q: 如何在ginfast框架中获取验证后的数据？

在ginfast框架中，`Check` 方法会自动将请求数据绑定到结构体，验证通过后直接使用结构体字段即可：

```go
// app/controllers/user.go
func AddUser(c *gin.Context) {
    var param models.AddRequest
    if err := param.Validate(c); err != nil {
        c.JSON(400, gin.H{"code": 400, "msg": err.Error()})
        return
    }
    
    // 验证通过后，直接使用param中的字段
    user := &models.User{
        UserName: param.UserName,
        Email:    param.Email,
        Age:      param.Age,
    }
    // ...
}
```

### Q: 如何自定义错误消息？

在ginfast框架中，推荐使用 `message` 标签定义错误消息：

```go
// 方式1：使用message标签（推荐）
type AddRequest struct {
    Validator
    UserName string `form:"userName" validate:"required|min_len:2" message:"用户名不能为空且至少2位"`
    Email    string `form:"email" validate:"email" message:"邮箱格式不正确"`
}

// 方式2：实现Messages方法
func (r AddRequest) Messages() map[string]string {
    return validate.MS{
        "required":     "{field}不能为空",
        "UserName.required": "用户名是必填项",
    }
}

// 方式3：添加全局消息
// bootstrap/init.go
validate.AddGlobalMessages(map[string]string{
    "required": "{field}不能为空",
    "email":    "{field}格式不正确",
})
```

### Q: 如何处理可选字段的验证？

对于可选字段，不添加 `required` 验证即可：

```go
// Phone是可选字段，但如果提供则必须是有效的手机号
type UpdateRequest struct {
    Validator
    Id    uint   `form:"id" validate:"required" message:"ID不能为空"`
    Name  string `form:"name" validate:"required" message:"名称不能为空"`
    Phone string `form:"phone" validate:"cn_mobile" message:"手机号格式不正确"` // 可选
}
```

### Q: 如何验证数组参数？

框架支持数组参数的自动解析：

```go
type UserListRequest struct {
    Validator
    DeptIds []uint `form:"deptIds"` // 支持ids=1&ids=2或ids[0]=1&ids[1]=2
    Status  string `form:"status"`
}

func (r *UserListRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}
```

### Q: 如何实现条件验证？

在 `Validate` 方法中添加自定义验证逻辑：

```go
type RegisterRequest struct {
    Validator
    User_type string `form:"userType" validate:"required|in:personal,company" message:"用户类型不能为空"`
    Company_name string `form:"companyName"` // 企业用户必填
}

func (r *RegisterRequest) Validate(c *gin.Context) error {
    // 先进行基础验证
    if err := r.Check(c, r); err != nil {
        return err
    }
    
    // 条件验证：企业用户必须填写公司名称
    if r.User_type == "company" && r.Company_name == "" {
        return errors.New("企业用户必须填写公司名称")
    }
    
    return nil
}
```

### Q: 如何验证嵌套结构体？

```go
type AddressInfo struct {
    City    string `form:"city" validate:"required" message:"城市不能为空"`
    Address string `form:"address" validate:"required" message:"地址不能为空"`
}

type AddUserRequest struct {
    Validator
    Name    string      `form:"name" validate:"required" message:"姓名不能为空"`
    Address AddressInfo `form:"address"` // 嵌套结构体
}

func (r *AddUserRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}
```

### Q: 如何处理分页参数？

使用 `BasePaging` 结构体：

```go
type UserListRequest struct {
    BasePaging    // 包含 pageNum, pageSize, order 字段
    Validator
    Name string `form:"name"`
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

### Q: 如何添加全局自定义验证器？

```go
// bootstrap/init.go
package bootstrap

import (
    "regexp"
    "github.com/gookit/validate"
)

func Init() {
    // 添加中国手机号验证器
    validate.AddValidator("cn_mobile", func(val any) bool {
        str, ok := val.(string)
        if !ok {
            return false
        }
        matched, _ := regexp.MatchString(`^1[3-9]\d{9}$`, str)
        return matched
    })
    
    // 添加身份证号验证器
    validate.AddValidator("cn_id_card", func(val any) bool {
        str, ok := val.(string)
        if !ok {
            return false
        }
        matched, _ := regexp.MatchString(`^\d{17}[\dXx]$`, str)
        return matched
    })
}
```

---

## 参考资源

### 外部资源

- [gookit/validate GitHub](https://github.com/gookit/validate)
- [gookit/validate GoDoc](https://pkg.go.dev/github.com/gookit/validate)
- [gookit/filter GitHub](https://github.com/gookit/filter)

### 项目内部资源

- [`app/models/base.go`](app/models/base.go) - Validator和BaseRequest定义
- [`app/models/userparam.go`](app/models/userparam.go) - 用户参数示例
- [`内置验证器规则.md`](../内置验证器规则.md) - 内置验证器规则列表
- [`app/controllers/user.go`](app/controllers/user.go) - Controller使用示例
