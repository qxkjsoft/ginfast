## 目录结构

目录

- 项目结构
- 目录说明
- 文件说明
- 模块说明

### 项目结构

```
gin-fast/
├── app/                     # 应用目录
│   ├── controllers/         # 控制器目录
│   │   ├── auth.go          # 认证控制器
│   │   ├── common.go        # 公共控制器
│   │   ├── config.go        # 配置控制器
│   │   ├── sysaffix.go      # 系统附件控制器
│   │   ├── sysapi.go        # 系统API控制器
│   │   ├── sysdepartment.go # 系统部门控制器
│   │   ├── sysdict.go       # 系统字典控制器
│   │   ├── sysdictitem.go   # 系统字典项控制器
│   │   ├── sysmenu.go       # 系统菜单控制器
│   │   ├── sysrole.go       # 系统角色控制器
│   │   └── user.go          # 用户控制器
│   ├── global/              # 全局目录
│   │   ├── app/             # 应用全局
│   │   │   ├── cache_interface.go      # 缓存接口
│   │   │   ├── casbin_interface.go     # Casbin接口
│   │   │   ├── config_interface.go     # 配置接口
│   │   │   ├── response_interface.go   # 响应接口
│   │   │   ├── token_interface.go      # 令牌接口
│   │   │   ├── upload_interface.go     # 上传接口
│   │   │   └── variable.go             # 全局变量
│   │   ├── consts/           # 常量目录
│   │   │   └── consts.go      # 常量定义
│   │   ├── myerrors/         # 错误目录
│   │   │   └── myerrors.go   # 错误定义
│   ├── middleware/          # 中间件目录
│   │   ├── captcha.go       # 验证码中间件
│   │   ├── casbin.go        # Casbin中间件
│   │   ├── cors.go          # 跨域中间件
│   │   ├── jwt.go           # JWT中间件
│   │   ├── password.go      # 密码中间件
│   │   └── requestaborted.go # 请求中止中间件
│   ├── models/              # 模型目录
│   │   ├── base.go          # 基础模型
│   │   ├── configparam.go   # 配置参数模型
│   │   ├── sysaffix.go      # 系统附件模型
│   │   ├── sysaffixparam.go # 系统附件参数模型
│   │   ├── sysapi.go        # 系统API模型
│   │   ├── sysapiparam.go   # 系统API参数模型
│   │   ├── sysdepartment.go # 系统部门模型
│   │   ├── sysdepartmentparam.go # 系统部门参数模型
│   │   ├── sysdict.go       # 系统字典模型
│   │   ├── sysdictitem.go   # 系统字典项模型
│   │   ├── sysdictitemparam.go # 系统字典项参数模型
│   │   ├── sysdictparam.go # 系统字典参数模型
│   │   ├── sysmenu.go       # 系统菜单模型
│   │   ├── sysmenuapi.go    # 系统菜单API模型
│   │   ├── sysmenuparam.go  # 系统菜单参数模型
│   │   ├── sysrole.go       # 系统角色模型
│   │   ├── sysrolemenu.go   # 系统角色菜单模型
│   │   ├── sysroleparam.go  # 系统角色参数模型
│   │   ├── sysuserrole.go   # 系统用户角色模型
│   │   ├── user.go          # 用户模型
│   │   └── userparam.go     # 用户参数模型
│   ├── routes/              # 路由目录
│   │   └── routes.go        # 路由定义
│   ├── service/             # 服务目录
│   │   ├── casbinservice.go # Casbin服务
│   │   ├── userservice.go   # 用户服务
│   │   └── zaphooks.go      # Zap钩子
│   └── utils/               # 工具目录
│       ├── cachehelper/     # 缓存工具
│       │   ├── memory.go    # 内存缓存
│       │   ├── memory_test.go # 内存缓存测试
│       │   ├── redishelper.go # Redis缓存
│       │   └── README_TESTS.md # 缓存测试说明
│       ├── casbinhelper/    # Casbin工具
│       │   └── casbinhelper.go # Casbin工具
│       ├── common/          # 公共工具
│       │   └── common.go    # 公共工具
│       ├── datascope/       # 数据权限
│       │   └── datascope.go # 数据权限
│       ├── filehelper/      # 文件工具
│       │   ├── filetype.go  # 文件类型
│       │   └── filetype_test.go # 文件类型测试
│       ├── ginhelper/       # Gin工具
│       │   └── ginhelper.go # Gin工具
│       ├── gormhelper/      # GORM工具
│       │   ├── client.go   # GORM客户端
│       │   ├── hook.go     # GORM钩子
│       │   ├── log.go      # GORM日志
│       │   └── params.go    # GORM参数
│       ├── passwordhelper/  # 密码工具
│       │   └── passwordhelper.go # 密码工具
│       ├── response/        # 响应工具
│       │   └── response.go  # 响应工具
│       ├── tokenhelper/     # 令牌工具
│       │   ├── tokenhelper.go # 令牌工具
│       │   ├── tokenhelper_test.go # 令牌工具测试
│       │   └── README_TESTS.md # 令牌工具测试说明
│       ├── uploadhelper/    # 上传工具
│       │   ├── local_upload.go # 本地上传
│       │   ├── qiniu_upload.go # 七牛云上传
│       │   └── upload.go    # 上传接口
│       └── ymlconfig/       # YAML配置
│           └── ymlconfig.go # YAML配置
├── bootstrap/               # 引导目录
│   └── init.go              # 初始化
├── config/                  # 配置目录
│   └── config.copy.yml      # 配置文件模板
├── docs/                    # 文档目录
│   ├── README.md            # 文档说明
│   ├── introduction.md      # 系统介绍
│   ├── environment.md       # 环境搭建
│   ├── installation.md      # 系统安装
│   ├── catalog.md           # 目录结构
│   ├── exploit.md           # 开发规范
│   <!-- 删除API文档文件引用 -->
│   ├── frontend-introduction.md # 前端介绍
│   ├── frontend-environment.md # 前端环境
│   ├── frontend-catalog.md  # 前端目录
│   ├── frontend-guide.md    # 前端指南
│   ├── deployment.md        # 部署指南
│   └── faq.md               # 常见问题
├── plugins/                 # 插件目录
│   ├── exampleinit.go       # 示例插件初始化
│   └── example/             # 示例插件
│       ├── controllers/     # 插件控制器
│       │   └── example.go  # 示例控制器
│       ├── models/          # 插件模型
│       │   ├── example.go  # 示例模型
│       │   └── exampleparam.go # 示例参数模型
│       └── routes/         # 插件路由
│           └── routes.go    # 插件路由定义
├── resource/                # 资源目录
│   ├── database/            # 数据库资源
│   │   └── gin-fast.sql     # 数据库结构
│   └── public/              # 公共资源
│       └── uploads/         # 上传文件
├── go.mod                   # Go模块文件
├── go.sum                   # Go模块校验文件
├── main.go                  # 主程序入口
├── README.md                # 项目说明
└── .gitignore               # Git忽略文件
```

### 目录说明

#### app

应用目录，包含项目的所有应用代码。

##### controllers

控制器目录，包含项目的所有控制器，负责处理HTTP请求，调用业务逻辑，返回响应结果。

##### global

全局目录，包含项目的全局定义，如接口、常量、错误等。

##### middleware

中间件目录，包含项目的所有中间件，负责处理请求拦截、响应拦截、权限验证等。

##### models

模型目录，包含项目的所有模型，负责与数据库交互，包括数据的增删改查。

##### routes

路由目录，包含项目的所有路由定义，负责将URL映射到控制器。

##### service

服务目录，包含项目的所有服务，负责业务逻辑处理，包括数据验证、业务规则等。

##### utils

工具目录，包含项目的所有工具类和辅助方法，如缓存、日志、文件上传等。

#### bootstrap

引导目录，包含项目的初始化代码，负责启动应用。

#### config

配置目录，包含项目的配置文件，负责系统配置管理。

#### docs

文档目录，包含项目的所有文档，如系统介绍、环境搭建、系统安装等。

#### plugins

插件目录，包含项目的所有插件，负责提供可插拔的功能模块。

#### resource

资源目录，包含项目的所有资源文件，如数据库结构、上传文件等。

### 文件说明

#### main.go

主程序入口，负责启动应用。

```go
package main

import (
	"gin-fast/bootstrap"
	"gin-fast/global"
	"gin-fast/utils/ymlconfig"
)

func main() {
	// 加载配置
	ymlconfig.InitConfig()
	
	// 初始化全局变量
	global.VARIABLE = ymlconfig.GetConfig()
	
	// 初始化应用
	bootstrap.Init()
	
	// 启动应用
	bootstrap.Run()
}
```

#### go.mod

Go模块文件，定义项目的依赖关系。

```go
module gin-fast

go 1.20

require (
	github.com/gin-gonic/gin v1.9.1
	github.com/go-redis/redis/v8 v8.11.5
	github.com/golang-jwt/jwt/v4 v4.5.0
	github.com/spf13/viper v1.16.0
	github.com/swaggo/files v1.0.1
	github.com/swaggo/gin-swagger v1.6.0
	github.com/swaggo/swag v1.16.2
	golang.org/x/crypto v0.14.0
	gorm.io/driver/mysql v1.5.2
	gorm.io/gorm v1.25.5
)
```

#### go.sum

Go模块校验文件，记录依赖的校验和。

#### README.md

项目说明文件，包含项目的说明。

#### .gitignore

Git忽略文件，定义Git需要忽略的文件和目录。

### 模块说明

#### 认证模块

认证模块包含登录、退出登录、刷新令牌等功能，主要文件包括：

- `app/controllers/auth.go`: 认证控制器
- `app/middleware/jwt.go`: JWT中间件
- `app/service/userservice.go`: 用户服务
- `app/utils/tokenhelper/tokenhelper.go`: 令牌工具

#### 用户模块

用户模块包含用户管理、用户详情等功能，主要文件包括：

- `app/controllers/user.go`: 用户控制器
- `app/models/user.go`: 用户模型
- `app/models/userparam.go`: 用户参数模型
- `app/service/userservice.go`: 用户服务

#### 系统管理模块

系统管理模块包含菜单管理、角色管理、部门管理、字典管理、API管理等功能，主要文件包括：

- `app/controllers/sysmenu.go`: 系统菜单控制器
- `app/controllers/sysrole.go`: 系统角色控制器
- `app/controllers/sysdepartment.go`: 系统部门控制器
- `app/controllers/sysdict.go`: 系统字典控制器
- `app/controllers/sysapi.go`: 系统API控制器
- `app/models/sysmenu.go`: 系统菜单模型
- `app/models/sysrole.go`: 系统角色模型
- `app/models/sysdepartment.go`: 系统部门模型
- `app/models/sysdict.go`: 系统字典模型
- `app/models/sysapi.go`: 系统API模型

#### 工具模块

工具模块包含缓存工具、Casbin工具、公共工具、数据权限、文件工具、Gin工具、GORM工具、密码工具、响应工具、令牌工具、上传工具、YAML配置等，主要文件包括：

- `app/utils/cachehelper/`: 缓存工具
- `app/utils/casbinhelper/`: Casbin工具
- `app/utils/common/`: 公共工具
- `app/utils/datascope/`: 数据权限
- `app/utils/filehelper/`: 文件工具
- `app/utils/ginhelper/`: Gin工具
- `app/utils/gormhelper/`: GORM工具
- `app/utils/passwordhelper/`: 密码工具
- `app/utils/response/`: 响应工具
- `app/utils/tokenhelper/`: 令牌工具
- `app/utils/uploadhelper/`: 上传工具
- `app/utils/ymlconfig/`: YAML配置

#### 插件模块

插件模块包含示例插件，主要文件包括：

- `plugins/exampleinit.go`: 示例插件初始化
- `plugins/example/controllers/example.go`: 示例控制器
- `plugins/example/models/example.go`: 示例模型
- `plugins/example/routes/routes.go`: 示例路由

### 总结

Gin-Fast 项目采用模块化架构设计，各个模块职责明确，便于开发和维护。通过合理的目录结构和文件组织，使得项目具有良好的可读性和可扩展性。