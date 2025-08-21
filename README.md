# Gin-Fast

基于 Gin 框架的快速开发脚手架，集成了 JWT 认证、权限控制、数据库操作等常用功能，帮助开发者快速构建 RESTful API 服务。

## 功能特性

- 🔐 **JWT 认证**：基于 JWT 的用户认证系统，支持 Token 刷新机制
- 🛡️ **权限控制**：集成 Casbin 权限管理框架
- 🗄️ **数据库支持**：支持 MySQL、SQL Server、PostgreSQL 数据库
- 🔧 **配置管理**：基于 YAML 的配置文件管理
- 📝 **日志系统**：集成 Zap 日志框架，支持日志切割和归档
- 🌐 **跨域支持**：内置 CORS 中间件
- 🚀 **性能监控**：集成 pprof 性能分析工具
- 💾 **缓存支持**：支持 Redis 和内存缓存

## 技术栈

- **Web 框架**：Gin
- **ORM 框架**：GORM
- **认证授权**：JWT
- **权限控制**：Casbin
- **日志系统**：Zap
- **配置管理**：Viper
- **数据库**：MySQL、SQL Server、PostgreSQL
- **缓存**：Redis

## 项目结构

```
gin-fast/
├── app/                    # 应用核心代码
│   ├── controllers/        # 控制器层
│   │   ├── auth.go         # 认证控制器
│   │   └── user.go         # 用户控制器
│   ├── global/             # 全局变量和常量
│   │   ├── consts/         # 常量定义
│   │   ├── g/              # 全局变量
│   │   └── myerrors/       # 错误定义
│   ├── middleware/         # 中间件
│   │   ├── casbin.go       # 权限控制中间件
│   │   ├── cors.go         # 跨域中间件
│   │   └── jwt.go          # JWT 认证中间件
│   ├── models/             # 数据模型
│   │   ├── common/         # 通用模型
│   │   └── usermodel/      # 用户模型
│   ├── routes/             # 路由配置
│   ├── service/            # 服务层
│   └── utils/              # 工具类
├── bootstrap/              # 应用初始化
├── config/                 # 配置文件
│   └── config.yml          # 主配置文件
├── resource/               # 资源文件
│   ├── database/           # 数据库脚本
│   ├── logs/               # 日志文件
│   └── public/             # 静态资源
├── main.go                 # 应用入口
└── go.mod                  # 依赖管理
```

## 快速开始

### 环境要求

- Go 1.20+
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
```

### JWT 配置
```yaml
Token:
  JwtTokenSignKey: "gin-fast"          # JWT 签名密钥
  JwtTokenExpire: 43200                # Token 过期时间（秒）
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

## API 接口

### 认证接口

#### 用户登录
```
POST /api/login
Content-Type: application/json

{
  "username": "admin",
  "password": "password"
}
```

#### 刷新 Token
```
POST /api/refresh
Content-Type: application/json

{
  "refreshToken": "your-refresh-token"
}
```

#### 用户登出
```
POST /api/logout
Authorization: Bearer your-access-token
```

### 用户接口

#### 获取当前用户信息
```
GET /api/users/profile
Authorization: Bearer your-access-token
```

#### 更新用户信息
```
PUT /api/users/profile
Authorization: Bearer your-access-token
Content-Type: application/json

{
  "email": "new-email@example.com"
}
```

#### 根据ID获取用户
```
GET /api/users/:id
Authorization: Bearer your-access-token
```

#### 新增用户
```
POST /api/users/add
Authorization: Bearer your-access-token
Content-Type: application/json

{
  "username": "newuser",
  "password": "password"
}
```

## 开发指南

### 添加新的控制器

1. 在 `app/controllers/` 目录下创建新的控制器文件
2. 实现控制器结构体和方法
3. 在 `app/routes/routes.go` 中添加路由

示例：
```go
// app/controllers/product.go
type ProductController struct{}

func (pc *ProductController) GetProducts(c *gin.Context) {
    // 实现获取产品列表逻辑
}

// app/routes/routes.go
var productControllers = &controllers.ProductController{}

func InitRoutes(engine *gin.Engine) {
    // 其他路由...
    
    protected := engine.Group("/api")
    protected.Use(middleware.JWTAuthMiddleware())
    {
        protected.GET("/products", productControllers.GetProducts)
    }
}
```

### 添加新的数据模型

1. 在 `app/models/` 目录下创建新的模型文件
2. 定义模型结构体和方法
3. 使用 GORM 标签定义数据库字段

示例：
```go
// app/models/productmodel/product.go
type Product struct {
    gorm.Model
    Name  string  `gorm:"not null" json:"name"`
    Price float64 `gorm:"not null" json:"price"`
}

func (Product) TableName() string {
    return "products"
}

func CreateProduct(product *Product) error {
    return g.DB().Create(product).Error
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
        // 记录请求日志
        c.Next()
        // 记录响应日志
    }
}

// app/routes/routes.go
func InitRoutes(engine *gin.Engine) {
    engine.Use(middleware.LoggerMiddleware())
    // 其他路由...
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