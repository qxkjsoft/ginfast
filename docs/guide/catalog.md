# 目录结构

本文档描述 GinFast 多租户版的目录结构与模块划分。项目代码严格分层：`controllers`（参数校验/响应）→ `service`（业务）→ `models`（GORM 模型），路由集中在 `app/routes` 注册。

- 项目结构
- 目录说明
- 启动流程说明
- 模块说明

### 项目结构

```
ginfast-tenant/
├── app/                    # 应用核心代码
│   ├── controllers/        # 控制器层（参数校验、调用服务、统一响应）
│   │   ├── auth.go         # 认证控制器
│   │   ├── area.go         # 地区管理控制器
│   │   ├── codegen.go      # 代码生成控制器
│   │   ├── common.go       # 通用控制器基类
│   │   ├── config.go       # 系统配置控制器
│   │   ├── user.go         # 用户控制器
│   │   ├── sysaffix.go     # 文件管理控制器
│   │   ├── sysapi.go       # 系统API管理控制器
│   │   ├── sysdepartment.go # 部门管理控制器
│   │   ├── sysdict.go      # 字典管理控制器
│   │   ├── sysdictitem.go  # 字典项管理控制器
│   │   ├── sysgen.go       # 代码生成配置控制器
│   │   ├── sysmenu.go      # 菜单管理控制器
│   │   ├── sysoperationlog.go # 操作日志控制器
│   │   ├── sysparam.go     # 参数管理控制器
│   │   ├── sysrole.go      # 角色管理控制器
│   │   ├── systenant.go    # 租户管理控制器
│   │   ├── tenant.go       # 租户控制器（含切换租户）
│   │   ├── sysusertenant.go # 用户租户关联控制器
│   │   ├── sysjobscontroller.go # 定时任务控制器
│   │   ├── sysjobresultscontroller.go # 定时任务执行结果控制器
│   │   └── pluginsmanager.go # 插件管理控制器
│   ├── global/             # 全局定义
│   │   ├── app/            # 全局接口与单例（ConfigYml/DB()/ZapLog/Cache/TokenService/JobScheduler 等）
│   │   ├── consts/         # 常量定义
│   │   └── myerrors/       # 全局错误定义
│   ├── middleware/         # 中间件
│   │   ├── captcha.go      # 验证码中间件
│   │   ├── casbin.go       # Casbin 权限控制中间件
│   │   ├── cors.go         # 跨域中间件
│   │   ├── demoaccount.go  # 演示账号限制中间件
│   │   ├── jwt.go          # JWT 认证中间件
│   │   ├── operationlog.go # 操作日志中间件
│   │   ├── password.go     # 密码中间件
│   │   ├── superadmin.go   # 超管豁免中间件
│   │   └── timeout.go      # 请求超时中间件
│   ├── models/             # 数据模型层（GORM 模型 + 请求参数模型）
│   │   ├── base.go         # 基础模型
│   │   ├── area.go         # 地区模型
│   │   ├── codegen.go      # 代码生成模型
│   │   ├── user.go         # 用户模型
│   │   ├── sysapi.go       # 系统API模型
│   │   ├── sysdepartment.go # 部门模型
│   │   ├── sysdict.go / sysdictitem.go # 字典/字典项模型
│   │   ├── sysgen.go / sysgenfield.go  # 代码生成配置/字段模型
│   │   ├── sysmenu.go / sysmenuapi.go  # 菜单/菜单API关联模型
│   │   ├── sysoperationlog.go # 操作日志模型
│   │   ├── sysparam.go     # 系统参数模型
│   │   ├── sysrole.go / sysrolemenu.go / sysuserrole.go # 角色/角色菜单/用户角色模型
│   │   ├── systenants.go / sysusertenant.go # 租户/用户租户关联模型
│   │   ├── sysjobs.go / sysjobresults.go    # 定时任务/任务执行结果模型
│   │   ├── sysaffix.go / sysaffix_chunk.go  # 附件/分片上传模型
│   │   ├── pluginexport.go # 插件导出配置模型
│   │   └── *param.go       # 各种请求参数模型
│   ├── routes/             # 路由配置
│   │   ├── routes.go       # 业务路由注册（/api 分组）
│   │   └── globalmiddleware.go # 全局中间件、静态目录与调试路由注册
│   ├── scheduler/          # 任务调度模块
│   │   ├── register.go     # 执行器与预置任务注册（演示任务、操作日志清理）
│   │   ├── jobs.go         # 任务加载（LoadJobsFromDB）与持久化（PersistJobToDB/RegisterAndPersistJob）
│   │   ├── result_handler.go # 任务结果处理器
│   │   └── executors/      # 任务执行器（demo_executor、operationlog_cleanup_executor）
│   ├── service/            # 服务层（业务逻辑）
│   │   ├── casbinservice.go # Casbin 权限服务
│   │   ├── codegenservice.go # 代码生成服务
│   │   ├── sysgenservice.go # 代码生成配置服务
│   │   ├── sysmenuservice.go # 菜单服务
│   │   ├── sysroleservice.go # 角色服务
│   │   ├── sysapiservice.go # 系统API服务
│   │   ├── sysdepartmentservice.go # 部门服务
│   │   ├── sysparamservice.go # 参数服务
│   │   ├── sysaffixservice.go # 文件管理服务
│   │   ├── sysjobsservice.go # 定时任务服务
│   │   ├── sysjobresultsservice.go # 任务结果服务
│   │   ├── userservice.go  # 用户服务
│   │   ├── pluginsmanagerservice.go # 插件管理服务（含 SQL 校验）
│   │   └── zaphooks.go     # 日志钩子
│   └── utils/              # 工具类
│       ├── cachehelper/    # 缓存助手（memory/redis）
│       ├── captchahelper/  # 验证码助手
│       ├── casbinhelper/   # Casbin 助手
│       ├── common/         # 通用工具
│       ├── datascope/      # 数据权限
│       ├── filehelper/     # 文件工具（类型校验、MD5、路径）
│       ├── ginhelper/      # Gin 助手（引擎初始化/启动、插件路由注册）
│       ├── gormhelper/     # GORM 助手（多库连接、读写分离、租户钩子、查无数据屏蔽）
│       ├── goroutinehelper/ # 安全协程封装
│       ├── imagehelper/    # 图片处理助手
│       ├── passwordhelper/ # 密码助手（bcrypt）
│       ├── response/       # 统一响应助手
│       ├── schedulerhelper/ # 任务调度器核心（Cron 调度、阻塞策略、重试）
│       ├── tenanthelper/   # 多租户助手
│       ├── tokenhelper/    # JWT Token 助手
│       ├── uploadhelper/   # 上传助手（local/qiniu）
│       └── ymlconfig/      # Viper 配置助手
├── bootstrap/              # 应用初始化
│   ├── init.go             # 启动初始化（配置→日志→DB→超管→Casbin→缓存→Token→上传→调度器）
│   └── initadmin.go        # 超管账号自动初始化（全新部署按 server.initadmin 创建）
├── config/                 # 配置目录
│   ├── config.example.yml  # 配置示例文件（复制为 config.yml 使用，含全部配置项注释）
│   └── config.yml          # 主配置文件（已 gitignore，不入库）
├── docs/                   # 文档目录（总入口 docs/README.md）
│   ├── README.md           # 文档总入口（索引）
│   ├── guide/              # 各主题文档
│   │   ├── introduction.md # 系统介绍
│   │   ├── environment.md  # 环境搭建
│   │   ├── installation.md # 系统安装
│   │   ├── catalog.md      # 目录结构（本文档）
│   │   ├── exploit.md      # 开发规范
│   │   ├── demo_account.md # 演示账号说明
│   │   ├── deployment.md   # 部署指南
│   │   ├── faq.md          # 常见问题
│   │   └── frontend-*.md   # 前端系列文档（介绍/环境/目录/指南）
│   ├── mdFile/             # 文档图片
│   └── swagger/            # Swagger API 文档产物
├── gen/                    # 代码生成模板
│   └── templates/          # 控制器/模型/服务/路由模板及前端模板
├── plugins/                # 插件目录（除 example 外本地插件不入库）
│   ├── example/            # 示例插件
│   │   ├── controllers/    # 插件控制器
│   │   ├── models/         # 插件模型
│   │   ├── routes/         # 插件路由
│   │   └── scheduler/      # 插件定时任务执行器（可选）
│   └── exampleinit.go      # 插件初始化（init() 注册，main.go blank import 生效）
├── resource/               # 资源目录
│   ├── database/           # 数据库脚本
│   │   ├── gin-fast-tenant.sql # MySQL 主库结构脚本（仅表结构，不含数据）
│   │   ├── postgresql_converted.sql # PostgreSQL 转换版
│   │   └── sqlserver_converted.sql  # SQL Server 转换版
│   ├── logs/               # 运行日志目录
│   └── public/             # 静态资源与上传文件
├── scripts/                # 脚本文件
│   ├── swagger.sh / swagger.bat           # Swagger 文档生成
│   └── build-to-windows / build-to-linux  # 交叉编译脚本
├── main.go                 # 应用入口
└── go.mod                  # Go 模块定义（module gin-fast）
```

### 目录说明

#### app

应用目录，包含项目的所有应用代码，严格分层：controllers → service → models。

##### controllers

控制器目录，负责 HTTP 请求参数校验、调用 service 业务逻辑、通过 `app/utils/response` 统一返回响应。

##### global

全局定义目录：`app/` 存放全局接口与单例（经 `gin-fast/app/global/app` 包访问，如 `app.ConfigYml`、`app.DB()`、`app.ZapLog`、`app.Cache`、`app.JobScheduler`）；`consts/` 常量；`myerrors/` 全局错误。

##### middleware

中间件目录，负责认证（JWT）、权限（Casbin）、跨域、操作日志、超时、演示账号限制等请求拦截。

##### models

模型目录，GORM 数据模型与请求参数模型。注意：本项目通过 `gormhelper` 全局屏蔽了查无数据错误，判空必须用模型 `IsEmpty()`，详见 `exploit.md` 数据库规范。

##### routes

路由目录。`routes.go` 注册 `/api` 业务路由；`globalmiddleware.go` 注册全局中间件、静态目录（含 `extra_static` 额外静态映射）与调试路由（Swagger、内存缓存查看）。

##### scheduler

任务调度目录：`register.go` 注册执行器与预置任务；`jobs.go` 负责从 `sys_jobs` 加载任务与持久化；`result_handler.go` 处理执行结果；`executors/` 为具体执行器。

##### service

服务目录，负责业务逻辑处理，包括数据验证、业务规则等。

##### utils

工具目录，包含缓存、权限、GORM、调度器、多租户、Token、上传、配置等助手包。

#### bootstrap

引导目录。`init.go` 的包级 `init()` 完成全部启动初始化；`initadmin.go` 按配置自动创建超管账号。

#### config

配置目录。`config.example.yml` 为示例与说明文档，部署时复制为 `config.yml`（不入库）。

#### docs

文档目录。`README.md` 为总入口与索引，各主题文档统一存放在 `guide/` 子目录，`swagger/` 为 Swagger 生成产物，`mdFile/` 存放文档图片。

#### gen

代码生成模板目录，存放代码生成器使用的后端与前端模板。

#### plugins

插件目录。插件经 `XxxInit.go` 的 `init()` 注册（执行器/路由），由 `main.go` blank import `gin-fast/plugins` 生效。除 `example` 示例插件外，本地插件不入库。

#### resource

资源目录：数据库初始化脚本（MySQL 主文件 + PostgreSQL/SQL Server 转换版）、日志、静态资源。

#### scripts

脚本目录：Swagger 文档生成、Windows/Linux 交叉编译脚本。

### 启动流程说明

`main.go` 通过 blank import `gin-fast/bootstrap` 触发其包级 `init()` 完成全部初始化，`main()` 本身只负责组装路由并启动 HTTP 服务：

```go
func main() {
    // 获取Gin引擎实例
    engine := ginhelper.GetEngine()
    // 初始化系统路由
    routes.InitRoutes(engine)
    // 初始化插件路由
    ginhelper.InitPluginRoutes(engine)
    // 保存全局 Gin 引擎实例
    ginhelper.SetEngine(engine)
    // 启动服务器
    _ = ginhelper.StartServer(engine)
}
```

bootstrap 包级 `init()` 的初始化顺序（`bootstrap/init.go`）：

1. 检查必要目录与配置文件（`config/config.yml` 不存在直接启动失败）
2. 加载版本信息
3. 加载配置（Viper 封装 `app.ConfigYml`）
4. 初始化日志（`app.ZapLog`）
5. 初始化数据库（按 `gormv2.usedbtype` 强校验对应连接已初始化）
6. 初始化超管账号（`server.initadmin`，仅全新部署）
7. 初始化 Casbin 权限
8. 初始化缓存（memory/redis）
9. 初始化 Token 服务
10. 初始化文件上传服务
11. 初始化任务调度器并注册执行器/预置任务、从 `sys_jobs` 加载启用的任务
12. 初始化统一响应处理器

### 模块说明

#### 认证模块

登录、退出登录、刷新令牌等功能：

- `app/controllers/auth.go`: 认证控制器
- `app/middleware/jwt.go`: JWT 中间件
- `app/service/userservice.go`: 用户服务
- `app/utils/tokenhelper/`: 令牌工具

#### 多租户模块

租户管理、用户租户关联、切换租户等功能，数据隔离基于 GORM 钩子自动注入租户条件：

- `app/controllers/systenant.go` / `tenant.go`: 租户管理/切换控制器
- `app/controllers/sysusertenant.go`: 用户租户关联控制器
- `app/models/systenants.go`: 租户模型
- `app/utils/tenanthelper/`: 租户助手

#### 系统管理模块

用户、菜单、角色、部门、字典、API、参数、操作日志等管理功能：

- `app/controllers/sysmenu.go` / `sysrole.go` / `sysdepartment.go` / `sysdict.go` / `sysapi.go` / `sysparam.go` / `sysoperationlog.go`: 各管理控制器
- 对应 `app/models/`、`app/service/` 下的同名模型与服务

#### 任务调度模块

基于 Cron 表达式的定时任务调度（含系统预置的操作日志清理任务），支持执行策略、阻塞策略、超时控制与自动重试：

- `app/scheduler/register.go`: 执行器与预置任务注册
- `app/scheduler/jobs.go`: 任务加载与持久化
- `app/scheduler/executors/`: 执行器实现
- `app/utils/schedulerhelper/`: 调度器核心
- `app/controllers/sysjobscontroller.go` / `sysjobresultscontroller.go`: 任务管理/结果接口

#### 操作日志模块

记录用户操作日志，支持查询、导出与定时清理：

- `app/middleware/operationlog.go`: 操作日志中间件
- `app/controllers/sysoperationlog.go`: 操作日志控制器
- `app/models/sysoperationlog.go`: 操作日志模型
- `app/scheduler/executors/operationlog_cleanup_executor.go`: 日志清理执行器

#### 插件模块

插件化功能扩展，支持插件的上传、下载、导入导出与卸载：

- `plugins/exampleinit.go`: 示例插件初始化
- `plugins/example/`: 示例插件（控制器/模型/路由/调度器）
- `app/controllers/pluginsmanager.go` / `app/service/pluginsmanagerservice.go`: 插件管理
- 插件开发全流程见 `exploit.md` 插件开发规范

#### 代码生成模块

基于模板的后端/前端代码生成：

- `app/controllers/codegen.go` / `sysgen.go`: 代码生成控制器
- `app/service/codegenservice.go`: 代码生成服务
- `gen/templates/`: 代码生成模板

### 总结

GinFast 多租户版采用分层架构与插件化设计，各层职责明确：控制器负责出入参、服务负责业务、模型负责数据；路由集中在 `app/routes`，启动初始化集中在 `bootstrap`，可插拔能力经 `plugins` 扩展，便于开发与维护。
