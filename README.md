# GinFast 多租户版

开源、免费、轻量级 Gin 前后分离快速开发基础框架，基于主流技术，集成了 JWT 认证、权限控制、数据库操作等功能，帮助开发者快速搭建一个支持多租户的后台管理系统。

本项目由[Gfast](https://github.com/tiger1103/gfast)团队（[奇讯科技](https://www.qjit.cn)）开发

项目为前后端分离，前端地址：

github地址：[https://github.com/qxkjsoft/ginfast-ui](https://github.com/qxkjsoft/ginfast-ui)

## 使用文档

[文档](docs/README.md)

[安装使用视频](https://www.bilibili.com/video/BV14gsgzXEGM/)

[多租户版的使用视频](https://www.bilibili.com/video/BV1Kk1wBaELb/)

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

## 技术栈

- **Web 框架**：Gin
- **ORM 框架**：GORM
- **认证授权**：JWT (golang-jwt/jwt/v5)
- **权限控制**：Casbin
- **日志系统**：Zap + Lumberjack
- **配置管理**：Viper
- **数据库**：MySQL、SQL Server、PostgreSQL
- **缓存**：Redis
- **验证码**：Captcha (dchest/captcha)
- **参数验证**：Gookit Validate
- **密码加密**：Bcrypt
- **性能监控**：Pprof
- **API文档**：Swagger (swaggo)

## 项目结构

```
gin-fast/
├── app/                    # 应用核心代码
│   ├── controllers/        # 控制器层
│   │   ├── auth.go         # 认证控制器
│   │   ├── common.go       # 通用控制器基类
│   │   ├── user.go         # 用户控制器
│   │   ├── sysapi.go       # 系统API管理控制器
│   │   ├── sysdepartment.go # 部门管理控制器
│   │   ├── sysdict.go      # 字典管理控制器
│   │   ├── sysdictitem.go  # 字典项管理控制器
│   │   ├── sysmenu.go      # 菜单管理控制器
│   │   ├── sysrole.go      # 角色管理控制器
│   │   ├── systenant.go    # 租户管理控制器
│   │   └── sysusertenant.go # 用户租户关联控制器
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
│   │   ├── user.go         # 用户模型
│   │   ├── sysapi.go       # 系统API模型
│   │   ├── sysdepartment.go # 部门模型
│   │   ├── sysdict.go      # 字典模型
│   │   ├── sysdictitem.go  # 字典项模型
│   │   ├── sysmenu.go      # 菜单模型
│   │   ├── sysrole.go      # 角色模型
│   │   ├── systenants.go   # 租户模型
│   │   ├── sysusertenant.go # 用户租户关联模型
│   │   └── *param.go       # 各种参数模型
│   ├── routes/             # 路由配置
│   │   └── routes.go       # 路由定义
│   ├── service/            # 服务层
│   │   ├── casbinservice.go # 权限服务
│   │   ├── userservice.go  # 用户服务
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
├── resource/               # 资源文件
│   ├── database/           # 数据库脚本
│   │   └── gin-fast.sql    # 数据库初始化脚本
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

## 插件开发规范

本项目支持插件化开发，允许开发者在不影响核心代码的情况下扩展功能。插件遵循与主应用相同的架构模式和规范。

### 插件目录结构

插件统一放在 `plugins/` 目录下，每个插件应具有以下标准结构：

```
plugins/
└── {plugin_name}/
    ├── controllers/     # 插件控制器
    ├── models/          # 插件数据模型和参数验证
    ├── routes/          # 插件路由注册
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

![微信群](docs/mdFile/wx2.jpg)

### QQ群

QQ群：967593545