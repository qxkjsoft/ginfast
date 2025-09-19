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
├── resource/               # 资源文件
│   ├── database/           # 数据库脚本
│   │   └── gin-fast.sql    # 数据库初始化脚本
│   ├── logs/               # 日志文件目录
│   └── public/             # 静态资源
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

### JWT 配置
```yaml
Token:
  JwtTokenSignKey: "gin-fast"          # JWT 签名密钥
  JwtTokenExpire: 10                   # Token 过期时间（秒）
  JwtTokenRefreshExpire: 2592000       # 刷新 Token 过期时间（秒）
  CacheKeyPrefix: "gin-fast:"          # 缓存前缀
```

### 数据库配置
```yaml
Gormv2:
  UseDbType: "mysql"    # 数据库类型：mysql、sqlserver、postgresql
  Mysql:
    IsInitGlobalGormMysql: 1
    Write:
      Host: "127.0.0.1"
      DataBase: "gin-fast"
      Port: 3306
      User: "root"
      Pass: "root"
```

### 验证码配置
```yaml
Captcha:
  open: false    # 是否开启验证码功能
  length: 4      # 验证码生成时的长度
```

### Casbin 权限配置
```yaml
Casbin:
  AutoLoadPolicySeconds: 120 # 扫描数据库策略的频率（单位：秒）
  TablePrefix: ""
  TableName: "casbin_rule"
  ModelConfig: |
    [request_definition]
    r = sub, obj, act
    [policy_definition]
    p = sub, obj, act
    [role_definition]
    g = _, _
    [policy_effect]
    e = some(where (p.eft == allow))
    [matchers]
    m = g(r.sub, p.sub) && keyMatch2(r.obj, p.obj) && r.act == p.act
```

### Redis 配置
```yaml
Redis:
  Host: "127.0.0.1"
  Port: 6379
  Password: ""  # 设置你的redis密码
  IndexDb: 1    # 默认连接的redis是1号数据库
```

## API 接口

### 认证接口

#### 获取验证码ID
```
GET /api/captcha/id
```

#### 获取验证码图片
```
GET /api/captcha/image?captchaId=xxx&width=130&height=30
```

#### 用户登录
```
POST /api/login
Content-Type: application/json

{
  "username": "admin",
  "password": "password",
  "captchaId": "captcha-id",
  "captcha": "1234"
}
```

#### 刷新 Token
```
POST /api/refreshToken
Content-Type: application/json

{
  "refreshToken": "your-refresh-token"
}
```

### 用户管理接口

#### 获取当前用户信息
```
GET /api/users/profile
Authorization: Bearer your-access-token
```

#### 用户列表
```
GET /api/users/list?page=1&pageSize=10
Authorization: Bearer your-access-token
```

#### 新增用户
```
POST /api/users/add
Authorization: Bearer your-access-token
Content-Type: application/json

{
  "username": "newuser",
  "password": "password",
  "email": "user@example.com"
}
```

#### 更新用户信息
```
PUT /api/users/edit
Authorization: Bearer your-access-token
Content-Type: application/json

{
  "id": 1,
  "email": "new-email@example.com"
}
```

#### 删除用户
```
DELETE /api/users/delete
Authorization: Bearer your-access-token
Content-Type: application/json

{
  "ids": [1, 2, 3]
}
```

### 系统管理接口

#### 菜单管理
```
# 获取用户菜单数据
GET /api/sysMenu/getRouters

# 获取完整菜单列表
GET /api/sysMenu/getMenuList

# 为菜单分配API权限
POST /api/sysMenu/setApis
```

#### 角色管理
```
# 获取所有角色数据
GET /api/sysRole/getRoles

# 为角色分配菜单权限
POST /api/sysRole/addRoleMenu

# 获取角色权限
GET /api/sysRole/getUserPermission/:roleId
```

#### 部门管理
```
# 获取部门列表
GET /api/sysDepartment/getDivision

# 新增部门
POST /api/sysDepartment/add
```

#### 字典管理
```
# 获取所有字典数据
GET /api/sysDict/getAllDicts

# 根据编码获取字典
GET /api/sysDict/getByCode/:code

# 获取字典项列表
GET /api/sysDictItem/getByDictCode/:dictCode
```

#### API管理
```
# API列表
GET /api/sysApi/list

# 新增API
POST /api/sysApi/add
```

## 开发指南

### 添加新的控制器

1. 在 `app/controllers/` 目录下创建新的控制器文件
2. 继承 `Common` 结构体并实现控制器方法
3. 在 `app/routes/routes.go` 中添加路由

示例：
```go
// app/controllers/product.go
type ProductController struct {
    Common
}

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

示例：
```go
// app/models/product.go
type Product struct {
    BaseModel
    Name  string  `gorm:"column:name;not null;size:100" json:"name"`
    Price float64 `gorm:"column:price;not null" json:"price"`
}

func (Product) TableName() string {
    return "products"
}

func (p *Product) IsEmpty() bool {
    return p.ID <= 0
}

func (p *Product) Create() error {
    return app.DB().Create(p).Error
}

func (p *Product) Find(id uint) error {
    return app.DB().Where("id = ?", id).First(p).Error
}
```

### 添加中间件

1. 在 `app/middleware/` 目录下创建新的中间件文件
2. 实现中间件函数
3. 在路由中应用中间件

示例：
```go
// app/middleware/logger.go
func LoggerMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        
        c.Next()
        
        latency := time.Since(start)
        app.ZapLog.Info("请求日志",
            zap.String("method", c.Request.Method),
            zap.String("path", c.Request.URL.Path),
            zap.Duration("latency", latency),
        )
    }
}

// app/routes/routes.go
func InitRoutes(engine *gin.Engine) {
    engine.Use(middleware.LoggerMiddleware())
    // 其他路由...
}
```

### 添加新的服务

1. 在 `app/service/` 目录下创建新的服务文件
2. 实现业务逻辑方法
3. 在控制器中调用服务方法

示例：
```go
// app/service/productservice.go
type ProductService struct{}

func (ps *ProductService) GetProducts(page, pageSize int) ([]models.Product, int64, error) {
    var products []models.Product
    var total int64
    
    db := app.DB().Model(&models.Product{})
    db.Count(&total)
    
    offset := (page - 1) * pageSize
    err := db.Offset(offset).Limit(pageSize).Find(&products).Error
    
    return products, total, err
}
```

## 部署

### 使用 Docker 部署

1. 创建 Dockerfile
```dockerfile
FROM golang:1.20-alpine AS builder

WORKDIR /app
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o gin-fast .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/gin-fast .
COPY --from=builder /app/config ./config

CMD ["./gin-fast"]
```

2. 构建镜像
```bash
docker build -t gin-fast .
```

3. 运行容器
```bash
docker run -p 8080:8080 gin-fast
```

### 直接部署

1. 编译应用
```bash
go build -o gin-fast .
```

2. 运行应用
```bash
./gin-fast
```

## 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系方式

如有问题或建议，请通过以下方式联系：

- 提交 Issue
- 发送邮件至：your-email@example.com