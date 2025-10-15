# Gin-Fast

基于 Gin 框架的快速开发脚手架，集成了 JWT 认证、权限控制、数据库操作等常用功能，帮助开发者快速构建 RESTful API 服务。

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
│   │   └── sysrole.go      # 角色管理控制器
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
git clone <repository-url>
cd gin-fast
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

## 开发指南

### 添加新的控制器

1. 在 `app/controllers/` 目录下创建新的控制器文件
2. 继承 `Common` 结构体并实现控制器方法
3. 在 `app/routes/routes.go` 中添加路由
4. 为控制器方法添加 Swagger 注释

示例：
```go
// app/controllers/product.go
type ProductController struct {
    Common
}

// GetProducts 获取产品列表
// @Summary 获取产品列表
// @Description 获取所有产品列表
// @Tags 产品管理
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{} "成功返回产品列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /products [get]
// @Security ApiKeyAuth
func (pc *ProductController) GetProducts(c *gin.Context) {
    // 使用 Common 结构体的方法进行响应处理
    pc.Success(c, "获取产品列表成功", products)
}

// app/routes/routes.go
var productControllers = &controllers.ProductController{}

func InitRoutes(engine *gin.Engine) {
    // 其他路由...
    
    protected := engine.Group("/api")
    protected.Use(middleware.JWTAuthMiddleware())
    protected.Use(middleware.CasbinMiddleware())
    {
        protected.GET("/products", productControllers.GetProducts)
    }
}
```

### 添加新的数据模型

1. 在 `app/models/` 目录下创建新的模型文件
2. 继承 `BaseModel` 并定义模型结构体
3. 使用 GORM 标签定义数据库字段
4. 为模型添加 Swagger 注释

示例：
```go
// app/models/product.go
// Product 产品模型
// @Description 产品信息
type Product struct {
    BaseModel
    Name        string  `gorm:"column:name;size:255;not null;comment:产品名称" json:"name" example:"iPhone 13"`
    Price       float64 `gorm:"column:price;type:decimal(10,2);comment:价格" json:"price" example:"6999.00"`
    Description string  `gorm:"column:description;size:500;comment:描述" json:"description" example:"最新款iPhone手机"`
    Status      int8    `gorm:"column:status;default:1;comment:状态 0下架 1上架" json:"status" example:"1"`
    CreatedBy   uint    `gorm:"column:created_by;default:0;comment:创建人" json:"createdBy" example:"1"`
}
```

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