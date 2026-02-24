# GinFast 多租户版

开源、免费、轻量级 Gin 前后分离快速开发基础框架，基于主流技术，集成了 JWT 认证、权限控制、数据库操作等功能，帮助开发者快速搭建一个支持多租户的后台管理系统。

本项目由[Gfast](https://github.com/tiger1103/gfast)团队（[奇讯科技](https://www.qjit.cn)）开发，如果您愿意为GinFast贡献代码或提供建议以及商业合作，请加微信：qixun007(备注：ginfast)

项目为前后端分离，前端地址：

github地址：[https://github.com/qxkjsoft/ginfast-ui](https://github.com/qxkjsoft/ginfast-ui)

## 使用文档

[文档](docs/README.md)

[安装使用视频](https://www.bilibili.com/video/BV14gsgzXEGM/)

[多租户版的使用视频](https://www.bilibili.com/video/BV1Kk1wBaELb/)

[多租户版的使用及开发视频](https://www.bilibili.com/video/BV199kaB9EdZ/)

[ginfast宝塔部署教程](https://www.bilibili.com/video/BV1Wi6MBwEYL/)
## 演示地址

[http://gin.g-fast.cn/system](http://gin.g-fast.cn/system)

账号：demo  密码：123456

## 功能特性

- 🔐 **JWT 认证**：基于 JWT 的用户认证系统，支持 Token 刷新机制
- 🛡️ **权限控制**：集成 Casbin 权限管理框架，支持 RBAC 权限模型
- 🗄️ **数据库支持**：支持 MySQL、SQL Server、PostgreSQL 数据库
- 🔧 **配置管理**：基于 YAML 的配置文件管理
- 📝 **日志系统**：集成 Zap 日志框架，支持日志切割和归档
- 🌐 **跨域支持**：内置 CORS 中间件
- 🚀 **性能监控**：集成 pprof 性能分析工具
- 💾 **缓存支持**：支持 Redis 和内存缓存
- 🔢 **验证码支持**：集成图形验证码功能，支持登录安全验证
- 📋 **完整的后台管理**：包含用户管理、角色管理、菜单管理、部门管理、字典管理、API管理等模块
- 🔗 **菜单与API权限关联**：支持菜单与API权限的动态关联管理
- 🏗️ **分层架构**：采用Controller-Service-Model分层架构，代码结构清晰
- 📚 **API文档**：集成 Swagger API 文档，自动生成接口文档
- 🏢 **多租户架构**：支持完整的租户管理、用户租户关联、数据隔离等功能
- 🔒 **数据隔离**：基于GORM钩子函数实现自动租户数据隔离，确保各租户数据安全
- 👥 **租户用户管理**：支持用户与租户的灵活关联，一个用户可关联多个租户
- 🤖 **代码生成**：强大的代码生成器，支持根据数据库表一键生成完整的后端和前端代码，包括模型、控制器、服务和视图层
- 🔌 **插件管理**：完整的插件管理系统，支持插件打包、导入、导出、卸载等功能，支持版本管理和依赖检查
- ⏰ **任务调度**：基于Cron表达式的任务调度系统，支持多种执行策略、阻塞策略、超时控制和自动重试机制

## 技术栈

- **Web 框架**：Gin
- **ORM 框架**：GORM
- **认证授权**：JWT (golang-jwt/jwt/v5)
- **权限控制**：Casbin
- **日志系统**：Zap + Lumberjack
- **配置管理**：Viper
- **数据库**：MySQL、SQL Server、PostgreSQL（多数据库支持）
- **缓存**：Redis、内存缓存
- **验证码**：Captcha (dchest/captcha)
- **参数验证**：Gookit Validate
- **密码加密**：Bcrypt
- **性能监控**：Pprof
- **API文档**：Swagger (swaggo)
- **代码生成**：Go text/template（支持后端和前端代码生成）
- **任务调度**：robfig/cron（基于Cron表达式的任务调度）

## 项目结构

```
ginfast-tenant/
├── app/                    # 应用核心代码
│   ├── controllers/        # 控制器层
│   │   ├── auth.go         # 认证控制器
│   │   ├── codegen.go      # 代码生成控制器
│   │   ├── common.go       # 通用控制器基类
│   │   ├── user.go         # 用户控制器
│   │   ├── sysapi.go       # 系统API管理控制器
│   │   ├── sysdepartment.go # 部门管理控制器
│   │   ├── sysdict.go      # 字典管理控制器
│   │   ├── sysdictitem.go  # 字典项管理控制器
│   │   ├── sysgen.go       # 代码生成配置控制器
│   │   ├── sysmenu.go      # 菜单管理控制器
│   │   ├── sysrole.go      # 角色管理控制器
│   │   ├── systenant.go    # 租户管理控制器
│   │   ├── sysusertenant.go # 用户租户关联控制器
│   │   ├── sysjobs.go      # 任务调度管理控制器
│   │   ├── sysjobresults.go # 任务执行结果控制器
│   │   └── pluginsmanager.go # 插件管理控制器
│   ├── global/             # 全局变量和接口
│   │   ├── app/            # 全局应用接口
│   │   ├── consts/         # 常量定义
│   │   └── myerrors/       # 错误定义
│   ├── middleware/         # 中间件
│   │   ├── captcha.go      # 验证码中间件
│   │   ├── casbin.go       # 权限控制中间件
│   │   ├── cors.go         # 跨域中间件
│   │   ├── jwt.go          # JWT 认证中间件
│   │   └── requestaborted.go # 请求中断处理中间件
│   ├── models/             # 数据模型
│   │   ├── base.go         # 基础模型
│   │   ├── codegen.go      # 代码生成模型
│   │   ├── user.go         # 用户模型
│   │   ├── sysapi.go       # 系统API模型
│   │   ├── sysapiparam.go  # 系统API参数模型
│   │   ├── sysdepartment.go # 部门模型
│   │   ├── sysdict.go      # 字典模型
│   │   ├── sysdictitem.go  # 字典项模型
│   │   ├── sysgen.go       # 代码生成配置模型
│   │   ├── sysgenfield.go  # 代码生成字段模型
│   │   ├── sysmenu.go      # 菜单模型
│   │   ├── sysmenuapi.go   # 菜单API关联模型
│   │   ├── sysrole.go      # 角色模型
│   │   ├── systenants.go   # 租户模型
│   │   ├── sysusertenant.go # 用户租户关联模型
│   │   ├── pluginexport.go # 插件导出配置模型
│   │   └── *param.go       # 各种参数模型
│   ├── routes/             # 路由配置
│   │   └── routes.go       # 路由定义
│   ├── scheduler/          # 任务调度模块
│   │   ├── register.go     # 执行器注册和任务加载
│   │   ├── result_handler.go # 任务结果处理器
│   │   └── executors/      # 任务执行器
│   ├── service/            # 服务层
│   │   ├── casbinservice.go # 权限服务
│   │   ├── codegenservice.go # 代码生成服务
│   │   ├── sysgenservice.go # 代码生成配置服务
│   │   ├── sysmenu.go      # 菜单服务
│   │   ├── userservice.go  # 用户服务
│   │   ├── pluginsmanagerservice.go # 插件管理服务
│   │   └── zaphooks.go     # 日志钩子
│   └── utils/              # 工具类
│       ├── cachehelper/    # 缓存助手
│       ├── casbinhelper/   # 权限助手
│       ├── common/         # 通用工具
│       ├── ginhelper/      # Gin助手
│       ├── gormhelper/     # GORM助手
│       ├── passwordhelper/ # 密码助手
│       ├── response/       # 响应助手
│       ├── tenanthelper/   # 租户助手
│       ├── tokenhelper/    # Token助手
│       └── ymlconfig/      # 配置助手
├── bootstrap/              # 应用初始化
│   └── init.go             # 初始化配置
├── config/                 # 配置文件
│   └── config.yml          # 主配置文件
├── docs/                   # 文档
│   ├── swagger/            # Swagger API 文档
│   └── catalog.md          # 项目目录说明
├── gen/                    # 代码生成模板
│   └── templates/          # 代码生成器使用的模板文件
├── plugins/                # 插件目录
│   ├── example/            # 示例插件
│   └── exampleinit.go      # 插件初始化文件
├── resource/               # 资源文件
│   ├── database/           # 数据库脚本
│   │   └── gin-fast-tenant.sql # 数据库初始化脚本
│   ├── logs/               # 日志文件目录
│   └── public/             # 静态资源
├── scripts/                # 脚本文件
│   ├── swagger.sh          # Swagger文档生成脚本(Linux/Mac)
│   └── swagger.bat         # Swagger文档生成脚本(Windows)
├── main.go                 # 应用入口
└── go.mod                  # 依赖管理
```

## 快速开始

### 环境要求

- Go 1.25+
- MySQL 5.7+ 或其他支持的数据库
- Redis (可选，用于缓存)

### 安装步骤

1. 克隆项目
```bash
git clone https://github.com/qxkjsoft/ginfast.git
cd ginfast
```

2. 安装依赖
```bash
go mod tidy
```

3. 配置数据库
   - 修改 `config/config.yml` 中的数据库配置
   - 导入数据库脚本 `resource/database/gin-fast.sql`

4. 启动应用
```bash
go run main.go
```

应用将在 `http://localhost:8080` 启动。

## API文档

本项目集成了 Swagger API 文档，可以自动生成接口文档。

### 访问API文档

启动应用后，可以通过以下URL访问API文档：
- Swagger UI: http://localhost:8080/swagger/index.html
- Swagger JSON: http://localhost:8080/swagger/doc.json

### 生成API文档

#### Linux/Mac 系统:
```bash
# 进入项目根目录
cd gin-fast

# 运行脚本生成文档
./scripts/swagger.sh
```

#### Windows 系统:
```cmd
# 进入项目根目录
cd gin-fast

# 运行脚本生成文档
scripts\swagger.bat
```

#### 手动安装和生成:
如果系统中未安装 swag 命令行工具，需要先安装:
```bash
go install github.com/swaggo/swag/cmd/swag@latest
```

然后生成文档:
```bash
swag init -g main.go -o docs/swagger
```

## 配置说明

主要配置项位于 `config/config.yml` 文件中：

### 服务器配置
```yaml
Server:
  AppDebug: true          # 调试模式
  CacheType: "redis"      # 缓存类型：memory 或 redis
HttpServer:
  Port: ":8080"          # 服务端口
  AllowCrossDomain: true # 是否允许跨域
  ServerRootPath: "/public" # 静态资源路由路径
  ServerRoot: "./resource/public" # 静态资源根目录
```

### 数据库配置示例
```yaml
Database:
  Type: "mysql"          # 数据库类型
  Host: "127.0.0.1"      # 数据库主机
  Port: 3306             # 数据库端口
  Username: "root"       # 数据库用户名
  Password: "password"   # 数据库密码
  Database: "gin_fast"   # 数据库名
  Charset: "utf8mb4"     # 字符集
  ParseTime: true        # 解析时间
  Loc: "Local"           # 时区
```

## 多租户架构说明

本项目基于标准的多租户架构设计，支持数据隔离和租户管理功能：

### 核心组件

1. **租户管理 (Tenant Management)**
   - 租户创建、更新、删除和查询
   - 租户状态管理（启用/停用）
   - 租户域名绑定

2. **用户租户关联 (User-Tenant Association)**
   - 用户与租户的多对多关系管理
   - 支持用户关联多个租户
   - 默认租户设置
   - 批量关联和取消关联操作

3. **数据隔离 (Data Isolation)**
   - 基于GORM钩子函数自动实现数据隔离
   - 通过TenantID字段实现行级数据隔离
   - JWT中间件自动注入租户信息

### 数据模型

- `Tenant` - 租户模型，包含租户基本信息
- `SysUserTenant` - 用户租户关联模型，管理用户与租户的关系

### 控制器

- `TenantController` - 租户管理控制器
- `SysUserTenantController` - 用户租户关联控制器

### 中间件和工具

- `tenanthelper` - 租户助手函数，提供租户数据隔离作用域
- `gormhelper/hook.go` - GORM钩子函数，自动设置TenantID字段
- `jwt.go` - JWT认证中间件，提取并验证租户信息

### 多租户开发注意事项

1. **数据隔离**
   - 所有需要进行租户隔离的模型都必须包含 `TenantID uint` 字段
   - GORM钩子函数会自动为创建和更新操作设置TenantID
   - 查询时会自动应用租户数据隔离作用域

2. **JWT认证与租户信息**
   - JWT Token中包含租户信息
   - 通过 `tenanthelper.TenantScope(c)` 可以获取当前用户的租户数据作用域

3. **跨租户操作**
   - 特殊管理接口可以绕过租户隔离，但需要谨慎使用
   - 用户租户关联控制器提供了不进行租户过滤的用户和角色查询接口

## 代码生成功能说明

本项目集成了强大的代码生成器，支持根据数据库表自动生成完整的后端和前端代码。

### 代码生成特性

- **后端代码生成**
  - 自动生成Go数据模型（Model）
  - 生成RESTful API控制器（Controller）
  - 生成业务逻辑服务层（Service）
  - 生成路由配置（Routes）
  - 支持参数验证模型生成

- **前端代码生成**
  - 生成Vue 3组件及API接口调用（API）
  - 生成Pinia状态管理模块（Store）
  - 生成完整的CRUD页面视图（View）
  - 自动适配表单校验和表格展示规则

- **智能特性**
  - 支持多数据库类型（MySQL、PostgreSQL、SQL Server）
  - 自动识别数据库字段注释生成代码文档
  - 支持字段级别的显示控制（列表展示、表单展示、查询展示）
  - 自动处理时间字段、主键字段等特殊字段
  - 支持代码预览，可在生成前查看效果
  - 支持覆盖现有文件选项
  - 集成菜单和API权限自动注册

### 代码生成API接口

#### 获取数据库列表
```
GET /api/codegen/databases
```
获取当前连接的数据库服务器中的所有数据库列表

#### 获取表列表
```
GET /api/codegen/tables?database=<database_name>
```
根据数据库名称获取该数据库中的所有表名和表注释

#### 获取表字段信息
```
GET /api/codegen/columns?database=<database_name>&table=<table_name>
```
获取指定表的所有字段信息（包括字段名、类型、注释、是否主键等）

#### 生成代码
```
POST /api/codegen/generate
```
根据代码生成配置ID实际生成后端和前端代码文件

**请求体示例：**
```json
{
  "genId": 1
}
```

#### 预览生成代码
```
GET /api/codegen/preview?genId=<gen_id>
```
预览即将生成的代码内容，不实际创建文件

### 代码生成工作流程

1. **配置代码生成**
   - 在后台管理系统中配置代码生成任务（选择数据库、表、输出模块名等）
   - 配置字段显示规则（是否在列表、表单、查询中显示）
   - 设置字段的自定义名称、表单类型、字典关联等

2. **预览生成代码**
   - 调用预览接口查看生成的代码效果
   - 确认代码无误后再执行生成

3. **执行代码生成**
   - 调用生成接口执行代码生成
   - 系统将自动生成后端代码到 `app/controllers`、`app/models`、`app/service` 等目录
   - 前端代码生成到指定的前端项目目录

4. **集成生成的代码**
   - 自动注册菜单和API权限
   - 自动生成的代码遵循项目规范，可直接使用
   - 如需修改，建议在生成后进行微调

### 代码生成最佳实践

1. **字段设计规范**
   - 为所有需要隔离的字段添加 `TenantID` 字段
   - 为表和字段添加有意义的注释，便于代码文档生成
   - 使用标准的数据类型（VARCHAR、INT、DATETIME等）

2. **生成配置规范**
   - 选择有意义的模块名和文件名
   - 根据业务需求配置字段的显示规则
   - 为不同的字段类型选择合适的表单组件（日期选择器、下拉框等）

3. **生成后处理**
   - 检查生成的代码是否符合项目规范
   - 根据实际业务需求调整校验规则
   - 添加必要的业务逻辑实现
   - 在前端添加特定的交互和样式

### 代码生成配置模型

代码生成配置保存在 `SysGen` 和 `SysGenField` 数据库表中，包含以下主要信息：

| 字段 | 说明 | 示例 |
|------|------|------|
| dbType | 数据库类型 | mysql、postgresql、sqlserver |
| database | 数据库名 | gin-fast |
| name | 表名 | sys_user |
| moduleName | 模块名 | user |
| fileName | 文件名 | user |
| describe | 功能描述 | 用户管理 |
| isCover | 是否覆盖现有文件 | true/false |
| packageName | 包名 | models、controllers 等 |

### Swagger 注释规范

为确保API文档的完整性和一致性，请遵循以下Swagger注释规范：

1. 每个控制器结构体添加概要说明：
```go
// UserController 用户控制器
// @Summary 用户管理API
// @Description 用户管理相关接口
// @Tags 用户管理
// @Accept json
// @Produce json
// @Router /users [get]
type UserController struct {
    Common
}
```

2. 每个控制器方法添加详细注释：
```go
// List 用户列表
// @Summary 用户列表
// @Description 获取用户列表，支持分页和过滤
// @Tags 用户管理
// @Accept json
// @Produce json
// @Param pageNum query int false "页码" default(1)
// @Param pageSize query int false "每页数量" default(10)
// @Success 200 {object} map[string]interface{} "成功返回用户列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /users/list [get]
// @Security ApiKeyAuth
func (uc *UserController) List(c *gin.Context) {
    // 方法实现
}
```

3. 为数据模型添加注释：
```go
// User 用户模型
// @Description 用户信息
type User struct {
    // 字段定义
}
```

4. 为请求参数和响应结构体添加注释：
```go
// LoginRequest 登录请求结构
// @Description 登录请求参数
type LoginRequest struct {
    Username string `validate:"required" message:"用户名不能为空"`
    Password string `validate:"required" message:"密码不能为空"`
}
```

### 安全认证

本项目使用 JWT 进行身份认证，API 请求需要在请求头中添加 Authorization 字段：

```
Authorization: Bearer <access_token>
```

## 插件管理系统

本项目提供完整的插件管理系统，支持插件的上传、下载、安装和卸载，同时集成了强大的插件导出功能，允许开发者将插件打包为可重新分发的压缩包。

### 插件管理API接口

所有插件管理接口需要JWT认证，路由前缀为 `/api/pluginsmanager`

#### 获取插件列表
```
GET /api/pluginsmanager/exports
```
获取plugins文件夹下所有插件的导出配置信息（plugin_export.json）。

**响应示例：**
```json
{
  "code": 0,
  "msg": "ok",
  "data": {
    "list": [
      {
        "name": "example",
        "version": "1.0.0",
        "description": "示例插件",
        "author": "author_name",
        "email": "author@example.com",
        "url": "https://example.com",
        "folderName": "example",
        "dependencies": {},
        "exportDirs": [],
        "exportDirsFrontend": [],
        "menus": [],
        "databaseTable": []
      }
    ]
  }
}
```

#### 导出插件
```
POST /api/pluginsmanager/export
```
将指定插件打包成压缩包进行下载。压缩包包含：
- 后端代码文件（ginfastback目录）
- 前端代码文件（ginfastfront目录）
- plugin.json 插件配置文件
- menus.json 菜单数据（如果有）
- database.sql 数据库脚本（如果有）

**请求体：**
```json
{
  "folderName": "example"
}
```

**响应：** 返回压缩包文件（Content-Type: application/zip）

#### 导入插件
```
POST /api/pluginsmanager/import
```
从上传的压缩包导入插件。支持以下功能：
- 检查导入的插件文件和数据库是否存在
- 导入菜单配置
- 导入数据库脚本
- 覆盖现有文件

**请求参数（multipart/form-data）：**
| 参数 | 类型 | 必需 | 说明 |
|------|------|------|------|
| file | file | 是 | 插件压缩包文件 |
| checkExist | int | 否 | 仅检查文件和数据库是否存在 (0:否, 1:是) |
| overwriteDB | int | 否 | 是否覆盖数据库 (0:否, 1:是) |
| importMenu | int | 否 | 是否导入菜单 (0:否, 1:是) |
| overwriteFiles | int | 否 | 是否覆盖文件 (0:否, 1:是) |
| userId | int | 否 | 用户ID（默认使用当前登录用户） |

**响应示例（检查存在）：**
```json
{
  "code": 1,
  "msg": "以下项已存在，请核查",
  "data": {
    "existingPaths": [
      "plugins/example"
    ],
    "existingTables": [
      "plugin_example"
    ]
  }
}
```

#### 卸载插件
```
DELETE /api/pluginsmanager/uninstall?folderName=example
```
卸载指定插件，包括：
- 删除菜单
- 删除文件
- 删除数据库表

**参数：**
| 参数 | 类型 | 必需 | 说明 |
|------|------|------|------|
| folderName | string | 是 | 插件文件夹名称 |

### 插件配置文件格式

每个插件必须在根目录包含 `plugin_export.json` 文件，定义插件的导出配置。

**plugin_export.json 格式示例：**
```json
{
  "name": "example",
  "version": "1.0.0",
  "description": "示例插件说明",
  "author": "插件作者",
  "email": "author@example.com",
  "url": "https://github.com/example",
  "dependencies": {
    "ginfast": ">=1.0.0"
  },
  "exportDirs": [
    "plugins/example/controllers",
    "plugins/example/models",
    "plugins/example/service",
    "plugins/example/routes"
  ],
  "exportDirsFrontend": [
    "src/modules/example"
  ],
  "menus": [
    {
      "path": "/example",
      "type": 0
    }
  ],
  "databaseTable": [
    "plugin_example",
    "plugin_example_detail"
  ]
}
```

**配置项说明：**
| 字段 | 类型 | 说明 |
|------|------|------|
| name | string | 插件唯一标识名称 |
| version | string | 插件版本号（支持语义化版本） |
| description | string | 插件描述 |
| author | string | 插件作者名称 |
| email | string | 作者邮箱 |
| url | string | 插件主页或代码仓库URL |
| dependencies | object | 插件依赖（键为插件名，值为版本要求） |
| exportDirs | array | 后端代码目录列表（相对路径） |
| exportDirsFrontend | array | 前端代码目录列表（相对于gen.dir） |
| menus | array | 菜单配置列表 |
| databaseTable | array | 数据库表名列表 |

### 插件导出流程

1. **读取配置** - 系统读取插件的 plugin_export.json 配置
2. **验证路径** - 验证exportDirs和exportDirsFrontend中指定的所有路径是否存在
3. **收集文件** - 收集所有需要导出的后端和前端文件
4. **生成菜单数据** - 如果配置了menus，从sys_menu表查询相关菜单并生成树形结构的menus.json
5. **生成数据库脚本** - 如果配置了databaseTable，导出这些表的CREATE和INSERT语句为database.sql
6. **创建压缩包** - 将所有文件和数据打包成ZIP文件
7. **流式传输** - 使用流式传输直接返回压缩包，无需保存到磁盘

### 插件导入流程

1. **解析压缩包** - 从上传的压缩包中读取plugin.json配置
2. **版本检查** - 验证插件版本和依赖是否兼容
3. **存在性检查** - 如果checkExist=true，检查文件和数据库是否已存在
4. **导入数据库** - 如果overwriteDB=true，执行database.sql脚本
5. **导入菜单** - 如果importMenu=true，导入menus.json中的菜单数据
6. **提取文件** - 如果overwriteFiles=true，解压并覆盖文件
7. **返回结果** - 返回导入是否成功或列出已存在的冲突项

### 插件版本兼容性

系统支持以下版本表示法：
- `1.0.0` - 精确版本
- `>=1.0.0` - 大于等于指定版本
- `>1.0.0` - 大于指定版本
- `^1.0.0` - 兼容版本（与1.0.0兼容）
- `~1.0.0` - 大约版本

### 后端配置说明

在config.yml中配置前端项目路径：
```yaml
gen:
  dir: "../ginfast-ui"  # 前端项目根目录相对路径
```

## 插件开发规范

本项目支持插件化开发，允许开发者在不影响核心代码的情况下扩展功能。插件遵循与主应用相同的架构模式和规范。

### 插件目录结构

插件统一放在 `plugins/` 目录下，每个插件应具有以下标准结构：

```
plugins/
├── {plugin_name}/
│   ├── controllers/     # 插件控制器
│   ├── models/          # 插件数据模型和参数验证
│   ├── routes/          # 插件路由注册
└── {plugin_name}init.go  # 插件初始化文件
```

### 插件开发步骤

1. **创建插件目录结构**
   在 `plugins/` 目录下创建插件文件夹，例如 `plugins/example/`

2. **编写数据模型**
   在 `plugins/{plugin_name}/models/` 目录下创建模型文件：
   - 继承 `models.BaseModel` 基础模型
   - 实现标准的 CRUD 方法（Create, Update, Delete, GetByID等）
   - 创建对应的参数验证模型（如 CreateRequest, UpdateRequest等）
   - 注意添加TenantID字段以支持多租户数据隔离

   示例：
   ```go
   // plugins/example/models/example.go
   type Example struct {
       models.BaseModel
       TenantID    uint   `gorm:"column:tenant_id;default:0;comment:租户ID" json:"tenantID"` // 添加租户ID字段
       Name        string `gorm:"type:varchar(255);comment:名称" json:"name"`
       Description string `gorm:"type:varchar(255);comment:描述" json:"description"`
       CreatedBy   uint   `gorm:"type:int(11);comment:创建者ID" json:"createdBy"`
   }
   
   // 实现标准方法
   func (m *Example) GetByID(id uint) error {
       return app.DB().First(m, id).Error
   }
   
   func (m *Example) Create() error {
       return app.DB().Create(m).Error
   }
   ```

3. **编写控制器**
   在 `plugins/{plugin_name}/controllers/` 目录下创建控制器文件：
   - 继承 `controllers.Common` 结构体以复用响应方法
   - 实现标准的 RESTful API 方法（Create, Update, Delete, GetByID, List等）
   - 使用参数验证模型进行输入验证
   - 使用统一的错误处理和响应格式

   示例：
   ```go
   // plugins/example/controllers/example.go
   type ExampleController struct {
       controllers.Common
   }
   
   func (ec *ExampleController) Create(c *gin.Context) {
       var req models.CreateRequest
       if err := req.Validate(c); err != nil {
           ec.FailAndAbort(c, err.Error(), err)
       }
       
       // 业务逻辑处理
       example := models.NewExample()
       example.Name = req.Name
       // ...
       
       if err := example.Create(); err != nil {
           ec.FailAndAbort(c, "创建示例失败", err)
       }
       
       ec.Success(c, gin.H{"id": example.ID})
   }
   ```

4. **注册路由**
   在 `plugins/{plugin_name}/routes/routes.go` 中注册插件路由：
   - 使用统一的路由前缀 `/api/plugins/{plugin_name}`
   - 应用必要的中间件（如 JWT 认证、Casbin 权限验证）
   - 注册控制器方法到对应路由

   示例：
   ```go
   // plugins/example/routes/routes.go
   func RegisterRoutes(engine *gin.Engine) {
       example := engine.Group("/api/plugins/example")
       example.Use(middleware.JWTAuthMiddleware())
       example.Use(middleware.CasbinMiddleware())
       {
           example.POST("/add", exampleControllers.Create)
           example.PUT("/edit", exampleControllers.Update)
           // ...
       }
   }
   ```

5. **插件初始化**
   创建 `plugins/{plugin_name}/{plugin_name}init.go` 文件，在 `init()` 函数中注册插件路由：
   - 使用 `ginhelper.RegisterPluginRoutes` 注册路由
   - 记录插件初始化日志

   示例：
   ```go
   // plugins/example/exampleinit.go
   func init() {
       ginhelper.RegisterPluginRoutes(func(engine *gin.Engine) {
           routes.RegisterRoutes(engine)
       })
       app.ZapLog.Info("示例插件初始化完成")
   }
   ```

6. **参数验证**
   在 `plugins/{plugin_name}/models/` 中创建参数验证模型：
   - 继承 `models.Validator` 和 `models.BasePaging`（分页查询时）
   - 实现 `Validate` 方法进行参数验证
   - 实现 `Handle` 方法处理查询条件

   示例：
   ```go
   // plugins/example/models/exampleparam.go
   type CreateRequest struct {
       models.Validator
       Name        string `json:"name" binding:"required"`
       Description string `json:"description" binding:"required"`
   }
   
   func (r *CreateRequest) Validate(c *gin.Context) error {
       return r.Validator.Check(c, r)
   }
   ```

### 插件导出json配置建议

为了充分利用插件管理系统的功能，编写plugin_export.json时的建议：

1. **version字段** - 使用语义化版本号（如1.0.0），便于版本管理和兼容性检查
2. **dependencies字段** - 明确声明插件依赖的其他插件及最低版本要求
3. **exportDirs字段** - 列举所有需要导出的后端目录，确保完整性
4. **exportDirsFrontend字段** - 列举所有需要导出的前端目录（相对于gen.dir配置）
5. **menus字段** - 如果插件有菜单，配置相关菜单的path和type便于自动导出
6. **databaseTable字段** - 列举所有插件相关的数据库表名，便于导出和导入

### 插件规范要求

1. **命名规范**
   - 插件目录名应使用小写字母和下划线命名
   - 控制器、模型、路由文件名应与功能对应，使用小写字母和下划线
   - 结构体和方法名遵循 Go 语言命名规范

2. **接口一致性**
   - 插件控制器必须继承 `controllers.Common` 结构体
   - 插件模型应继承 `models.BaseModel` 基础模型
   - 使用统一的错误处理和响应格式

3. **路由规范**
   - 插件路由必须以 `/api/plugins/{plugin_name}` 为前缀
   - 必须应用 JWT 认证中间件确保安全性
   - 根据需要应用 Casbin 权限验证中间件

4. **日志记录**
   - 使用 `app.ZapLog` 记录插件相关日志
   - 在关键操作和初始化时添加日志记录

5. **数据库操作**
   - 使用 `app.DB()` 获取数据库连接
   - 遵循 GORM 的操作规范
   - 注意处理数据库错误
   - 添加TenantID字段以支持多租户数据隔离

6. **导出配置**
   - 在插件根目录创建plugin_export.json文件
   - 完整列举所有需要导出的目录和数据库表
   - 配置菜单和依赖信息便于自动化导入导出

## 任务调度系统

本项目集成了强大的任务调度系统，基于Cron表达式实现定时任务的调度和管理，支持多种执行策略、阻塞策略、超时控制和自动重试机制。

### 核心特性

- ⏰ **Cron表达式支持**：支持秒级Cron表达式，灵活配置任务执行时间
- 🔄 **执行策略**：支持重复执行和单次执行两种策略
- 🚫 **阻塞策略**：提供丢弃、覆盖、并行三种阻塞处理策略
- ⏱️ **超时控制**：支持任务执行超时自动终止
- 🔁 **重试机制**：支持任务失败后自动重试，可配置重试次数和间隔
- 📊 **结果记录**：任务执行结果自动保存到数据库，便于追踪和分析
- 📝 **日志记录**：独立的调度器日志系统，按日期轮转
- 🔌 **执行器扩展**：支持自定义执行器，灵活实现各种业务逻辑

### 任务状态

| 状态 | 常量 | 值 | 说明 |
|------|------|-----|------|
| 启用 | `StatusEnabled` | 1 | 任务将被调度执行 |
| 禁用 | `StatusDisabled` | 0 | 任务不会被调度 |

### 执行策略

| 策略 | 常量 | 值 | 说明 |
|------|------|-----|------|
| 重复执行 | `PolicyRepeat` | 1 | 按照Cron表达式重复执行 |
| 单次执行 | `PolicyOnce` | 0 | 仅执行一次后自动禁用 |

### 阻塞策略

当任务执行时间超过调度间隔时，可配置以下阻塞策略：

| 策略 | 常量 | 值 | 说明 |
|------|------|-----|------|
| 丢弃 | `BlockDiscard` | 0 | 如果任务正在执行，跳过本次执行 |
| 并行 | `BlockParallel` | 1 | 允许多个实例并行执行（受ParallelNum限制） |

### 配置说明

在 `config/config.yml` 中配置任务调度器：

```yaml
# 任务调度器配置
scheduler:
  # 日志配置
  log:
    dir: "/resource/logs/scheduler"  # 日志目录
    level: "info"                     # 日志级别: debug, info, warn, error, fatal
  # 任务结果通道缓冲大小
  job_results_buffer_size: 1000       # 任务结果通道缓冲大小，默认1000
```

### 任务数据模型

任务信息存储在 `sys_jobs` 表中，主要字段包括：

| 字段 | 类型 | 说明 |
|------|------|------|
| id | string | 任务ID（主键） |
| group | string | 任务分组名称 |
| name | string | 任务名称 |
| description | string | 任务描述 |
| executor_name | string | 执行器名称 |
| execution_policy | int | 执行策略（0:单次 1:重复） |
| status | int | 任务状态（0:禁用 1:启用） |
| cron_expression | string | Cron表达式 |
| parameters | string | 任务参数（JSON格式） |
| blocking_policy | int | 阻塞策略（0:丢弃 1:并行） |
| timeout | int64 | 超时时间（纳秒） |
| max_retry | int | 最大重试次数 |
| retry_interval | int64 | 重试间隔（纳秒） |
| parallel_num | int | 并行数 |

### Cron表达式格式

支持6位Cron表达式（秒 分 时 日 月 周）：

```
格式: 秒 分 时 日 月 周
示例: 0/5 * * * * *  (每5秒执行一次)
     0 0 2 * * *     (每天凌晨2点执行)
     0 0 0 * * 1     (每周一凌晨执行)
     0 0 12 1 * *    (每月1号中午12点执行)
```

### API接口

#### 任务管理接口

所有任务管理接口需要JWT认证，路由前缀为 `/api/sysjobs`

| 接口 | 方法 | 说明 |
|------|------|------|
| /api/sysjobs/add | POST | 创建任务 |
| /api/sysjobs/edit | PUT | 更新任务 |
| /api/sysjobs/delete | DELETE | 删除任务 |
| /api/sysjobs/getByID | GET | 根据ID获取任务 |
| /api/sysjobs/list | GET | 获取任务列表（分页） |
| /api/sysjobs/enable | PUT | 启用任务 |
| /api/sysjobs/disable | PUT | 禁用任务 |
| /api/sysjobs/executeNow | POST | 立即执行任务 |

#### 任务结果查询接口

路由前缀为 `/api/sysjobresults`

| 接口 | 方法 | 说明 |
|------|------|------|
| /api/sysjobresults/list | GET | 获取任务执行结果列表（分页） |
| /api/sysjobresults/getByID | GET | 根据ID获取执行结果 |

### 执行器开发

执行器是任务的具体执行逻辑实现，需要实现 [`Executor`](app/utils/schedulerhelper/executor.go) 接口：

```go
type Executor interface {
    // Execute 执行任务
    Execute(ctx context.Context, job *Job) error
    
    // Name 返回执行器名称
    Name() string
}
```

#### 执行器示例

```go
package executors

import (
    "context"
    "log"
    "gin-fast/app/utils/schedulerhelper"
)

// MyExecutor 自定义执行器
type MyExecutor struct{}

func (e *MyExecutor) Execute(ctx context.Context, job *schedulerhelper.Job) error {
    log.Printf("执行任务: %s, 参数: %v", job.Name, job.Parameters)
    
    // 实现您的业务逻辑
    // ...
    
    return nil
}

func (e *MyExecutor) Name() string {
    return "my-executor"
}
```

#### 注册执行器

在 [`app/scheduler/register.go`](app/scheduler/register.go:18) 中注册执行器：

```go
func RegisterExecutors() {
    // 注册演示执行器
    app.JobScheduler.RegisterExecutor(&executors.DemoExecutor{})
    
    // 注册自定义执行器
    app.JobScheduler.RegisterExecutor(&executors.MyExecutor{})
}
```

### 任务调度流程

1. **应用启动**
   - 在 [`bootstrap/init.go`](bootstrap/init.go:62) 中初始化任务调度器
   - 调用 [`RegisterExecutors()`](app/scheduler/register.go:18) 注册所有执行器
   - 调用 [`LoadJobsFromDB()`](app/scheduler/register.go:26) 从数据库加载启用的任务

2. **任务调度**
   - 调度器根据Cron表达式触发任务执行
   - 根据阻塞策略决定是否执行任务
   - 执行器执行任务逻辑
   - 任务结果通过结果通道返回

3. **结果处理**
   - [`StartResultHandler()`](app/scheduler/result_handler.go) 监听任务结果
   - 将执行结果保存到 `sys_job_results` 表
   - 记录执行状态、耗时、错误信息等

### 任务结果数据模型

任务执行结果存储在 `sys_job_results` 表中，主要字段包括：

| 字段 | 类型 | 说明 |
|------|------|------|
| id | uint | 结果ID（主键） |
| job_id | string | 关联的任务ID |
| job_name | string | 任务名称 |
| executor_name | string | 执行器名称 |
| status | string | 执行状态（success/failed/timeout） |
| error_message | string | 错误信息 |
| duration | int64 | 执行耗时（纳秒） |
| executed_at | time.Time | 执行时间 |

### 开发建议

1. **执行器设计**
   - 执行器应保持幂等性，避免重复执行导致数据问题
   - 使用上下文超时控制，防止任务长时间阻塞
   - 合理处理错误，记录详细的日志信息

2. **任务配置**
   - 根据业务特点选择合适的阻塞策略
   - 设置合理的超时时间，避免长时间占用资源
   - 配置适当的重试次数和间隔

3. **监控和日志**
   - 定期查看任务执行结果，及时发现异常
   - 通过调度器日志追踪任务执行过程
   - 对失败任务进行分析和优化

### 插件中的任务调度

插件也可以定义自己的任务执行器，参考 [`plugins/example/scheduler/`](plugins/example/scheduler/) 目录：

```go
// plugins/example/scheduler/executors/example_executor.go
package executors

type ExampleExecutor struct{}

func (e *ExampleExecutor) Execute(ctx context.Context, job *schedulerhelper.Job) error {
    // 插件任务逻辑
    return nil
}

func (e *ExampleExecutor) Name() string {
    return "example-executor"
}

// plugins/example/scheduler/register.go
package scheduler

import (
    "gin-fast/app/global/app"
    "gin-fast/plugins/example/scheduler/executors"
)

func init() {
    // 注册插件执行器
    app.JobScheduler.RegisterExecutor(&executors.ExampleExecutor{})
}
```

## 部署说明

### 编译项目
```bash
go build -o gin-fast .
```

### 运行项目
```bash
./gin-fast
```

### Docker 部署

1. 构建 Docker 镜像
```bash
docker build -t gin-fast .
```

2. 运行容器
```bash
docker run -p 8080:8080 gin-fast
```

## 免责声明：
> 1、GIN-FAST仅限自己学习使用，一切商业行为与GIN-FAST无关。

> 2、用户不得利用GIN-FAST从事非法行为，用户应当合法合规的使用，发现用户在使用产品时有任何的非法行为，GIN-FAST有权配合有关机关进行调查或向政府部门举报，GIN-FAST不承担用户因非法行为造成的任何法律责任，一切法律责任由用户自行承担，如因用户使用造成第三方损害的，用户应当依法予以赔偿。

> 3、所有与使用GIN-FAST相关的资源直接风险均由用户承担。

## 交流群

### 微信群
```
如果二维码过期，请添加微信 qixun007 邀请您进群(备注：ginfast)
```
![微信群](docs/mdFile/wx3.png)

### QQ群

QQ群：967593545