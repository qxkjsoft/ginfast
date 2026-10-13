# 演示账号功能说明

## 功能概述

演示账号功能允许系统管理员设置一个或多个特殊的用户账号，这些账号只能执行GET请求（查看操作），无法执行POST、PUT、DELETE等修改数据的操作。这个功能特别适用于向客户展示系统功能时，防止客户误操作修改系统数据。

**新增功能**：支持配置路径前缀白名单，允许演示账号对特定路径执行非GET请求。

## 配置说明

### 配置项位置

演示账号相关配置位于 `config/config.yml` 文件的 `server` 节点下：

```yaml
server:
  # ... 其他配置项
  demoaccount:
    enabled: false              # 是否启用演示账号功能
    userids: []                 # 演示账号的用户ID列表，例如：[1, 2, 3]
    allowpathprefixes: []       # 允许演示账号执行非GET请求的路径前缀列表（白名单）
```

### 配置项说明

1. `enabled`: 布尔值，控制是否启用演示账号功能
   - `true`: 启用演示账号限制
   - `false`: 禁用演示账号限制

2. `userids`: 整数数组，指定演示账号的用户ID列表
   - 设置为具体的用户ID数组（如[1, 2, 3]）来启用该功能
   - 设置为空数组[]表示不启用

3. `allowpathprefixes`: 字符串数组，指定允许演示账号执行非GET请求的路径前缀列表
   - 设置为具体的路径前缀数组（如["/api/demo/", "/api/public/"]）来启用白名单
   - 设置为空数组[]表示不启用白名单，演示账号只能执行GET请求
   - 路径前缀匹配使用 `strings.HasPrefix()`，例如 `/api/demo/` 会匹配 `/api/demo/test` 和 `/api/demo/list`

## 使用方法

### 1. 创建演示账号

首先在系统中创建一个或多个专门用于演示的用户账号，记录下这些用户的ID。

### 2. 配置演示账号

在 `config/config.yml` 文件中设置：

```yaml
server:
  demoaccount:
    enabled: true              # 启用演示账号功能
    userids: [2, 3, 5]         # 设置多个演示账号的用户ID
    allowpathprefixes:         # 设置路径白名单
      - "/api/demo/"           # 演示相关API
      - "/api/public/"         # 公开API
      - "/api/plugins/test/"   # 测试插件API
```

### 3. 重启服务

修改配置后需要重启服务使配置生效。

### 4. 测试功能

使用演示账号登录系统，尝试执行各种操作：
- GET请求（查看操作）：应该可以正常执行
- POST/PUT/DELETE请求（修改操作）：应该被拒绝，并返回403错误
- 对白名单路径的POST/PUT/DELETE请求：应该可以正常执行

## 功能特点

1. **安全性**: 只限制指定的演示账号，不影响其他正常用户
2. **灵活性**: 可以随时启用或禁用该功能，支持设置多个演示账号
3. **路径白名单**: 支持配置路径前缀白名单，允许演示账号对特定路径执行修改操作
4. **透明性**: 被拒绝的请求会返回明确的错误信息
5. **日志记录**: 被拒绝的操作和白名单访问都会被记录在系统日志中

## 错误响应

当演示账号尝试执行非GET请求时，系统会返回以下JSON响应：

```json
{
  "code": 403,
  "message": "演示账号仅允许查看操作，禁止修改数据"
}
```

## 日志记录

所有被拒绝的演示账号操作都会在系统日志中记录，便于管理员监控：

```
WARN    middleware/demoaccount.go:xx  演示账号尝试执行非GET操作  {"userID": 2, "method": "POST", "path": "/api/users/add"}
```

演示账号访问白名单路径时也会记录信息日志：

```
INFO    middleware/demoaccount.go:xx  演示账号访问白名单路径  {"userID": 2, "method": "POST", "path": "/api/demo/test", "matchedPrefix": "/api/demo/"}
```

## 注意事项

1. 演示账号功能只对通过JWT认证的受保护路由生效
2. 配置更改后需要重启服务才能生效
3. 建议为演示账号分配只读角色，以提供双重保护
4. 在生产环境中使用时，请确保演示账号没有敏感数据访问权限
5. 路径白名单使用前缀匹配，配置时请注意路径的精确性（建议以 `/` 结尾）
6. 白名单路径仍然需要通过其他中间件（如JWT认证、Casbin权限）的验证

## 路径白名单使用场景

路径白名单功能适用于以下场景：

1. **演示数据管理**: 允许演示账号在演示区域创建、修改、删除演示数据
2. **临时文件上传**: 允许演示账号上传文件到临时目录
3. **插件测试**: 允许演示账号测试特定插件的功能
4. **公开接口**: 允许演示账号调用某些公开的API接口

## 配置示例

### 示例1：基本配置

只限制演示账号执行GET请求：

```yaml
server:
  demoaccount:
    enabled: true
    userids: [4]
    allowpathprefixes: []  # 空白名单，只允许GET请求
```

### 示例2：启用路径白名单

允许演示账号在特定路径执行修改操作：

```yaml
server:
  demoaccount:
    enabled: true
    userids: [4]
    allowpathprefixes:
      - "/api/demo/"          # 演示数据API
      - "/api/upload/temp/"   # 临时文件上传
```

### 示例3：多租户环境

在多租户环境中，可以限制演示账号只能操作特定租户的数据：

```yaml
server:
  demoaccount:
    enabled: true
    userids: [4]
    allowpathprefixes:
      - "/api/tenant/demo/"   # 只能操作演示租户的数据
```