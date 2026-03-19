---
name: ginfast-skill
description: AI助手技能索引 - 当用户询问开发技能、查找指南、需要技术文档时使用。支持GinFast框架相关的模型、服务、控制器、路由、中间件、验证、响应、权限、多租户、定时任务、代码生成等开发场景。
modeSlugs:
  - code
  - architect
---

# GinFast 技能索引

本文档提供结构化的技能元数据，供 AI 助手使用。

## 技能分类

### 核心开发层 (core)

| 技能 | 文件 | 标签 | 优先级 | 依赖 |
|------|------|------|--------|------|
| model | core/model-skill.md | model, database, gorm, crud | 1 | - |
| service | core/service-skill.md | service, business, logic | 2 | model |
| controller | core/controller-skill.md | controller, api, http | 3 | service, validate, response |
| routes | core/routes-skill.md | routes, api, restful | 4 | controller, middleware |

### 功能特性 (features)

| 技能 | 文件 | 标签 | 优先级 | 依赖 |
|------|------|------|--------|------|
| middleware | features/middleware-skill.md | middleware, auth, cors, logging | 5 | - |
| validate | features/validate-skill.md | validate, validation, params | 6 | - |
| response | features/response-skill.md | response, json, api | 7 | - |
| casbin | features/casbin-skill.md | casbin, rbac, permission, auth | 8 | middleware |
| tenant | features/tenant-skill.md | tenant, multi-tenant, isolation | 9 | model, middleware |
| scheduler | features/scheduler-skill.md | scheduler, cron, job, task | 10 | - |

### 工具支持 (tools)

| 技能 | 文件 | 标签 | 优先级 | 依赖 |
|------|------|------|--------|------|
| codegen | tools/codegen-skill.md | codegen, generator, crud | 11 | - |
| gorm | tools/gorm-skill.md | gorm, orm, database, mysql | 12 | model |
| plugin-dev | tools/plugin-dev-skill.md | plugin, extension, module | 13 | model, service, controller, routes |

## 开发场景

### 创建新功能 (create_feature)

**描述**：从头创建一个新的业务功能

**所需技能**：model, validate, service, controller, routes, casbin

**执行步骤**：
1. 定义数据模型 → [model](core/model-skill.md)
2. 创建参数验证 → [validate](features/validate-skill.md)
3. 实现服务层逻辑 → [service](core/service-skill.md)
4. 创建控制器 → [controller](core/controller-skill.md)
5. 注册路由 → [routes](core/routes-skill.md)
6. 配置权限 → [casbin](features/casbin-skill.md)

### 开发插件 (develop_plugin)

**描述**：开发一个可复用的插件

**所需技能**：plugin-dev

**执行步骤**：
1. 了解插件结构 → [plugin-dev](tools/plugin-dev-skill.md)
2. 创建插件目录
3. 实现插件功能
4. 配置插件元数据
5. 测试和打包

### 添加定时任务 (add_scheduled_task)

**描述**：创建一个新的定时任务

**所需技能**：scheduler

**执行步骤**：
1. 创建执行器 → [scheduler](features/scheduler-skill.md)
2. 注册执行器
3. 配置 Cron 表达式
4. 在管理界面创建任务

### 使用代码生成器 (use_codegen)

**描述**：使用代码生成器快速生成 CRUD 代码

**所需技能**：codegen

**执行步骤**：
1. 选择数据库表 → [codegen](tools/codegen-skill.md)
2. 配置生成信息
3. 预览生成代码
4. 下载并集成到项目

## 技能查找

### 按标签查找

**数据库相关**：model, gorm
- [model](core/model-skill.md)
- [gorm](tools/gorm-skill.md)

**API 相关**：controller, routes, response, validate
- [controller](core/controller-skill.md)
- [routes](core/routes-skill.md)
- [response](features/response-skill.md)
- [validate](features/validate-skill.md)

**认证授权**：auth, permission, casbin, tenant
- [casbin](features/casbin-skill.md)
- [tenant](features/tenant-skill.md)
- [middleware](features/middleware-skill.md)

**业务逻辑**：service, business
- [service](core/service-skill.md)

**开发工具**：codegen, plugin
- [codegen](tools/codegen-skill.md)
- [plugin-dev](tools/plugin-dev-skill.md)

### 按模式查找

**code 模式**：所有技能都支持
**architect 模式**：所有技能都支持

## 元数据说明

每个技能文档包含以下元数据：

```yaml
---
name: 技能名称
description: 使用场景描述
modeSlugs:
  - code      # 代码模式
  - architect # 架构模式
---
```

## 使用建议

### 对于 AI 助手

1. 解析本文档获取技能分类和依赖关系
2. 根据用户任务匹配对应的开发场景
3. 按照依赖顺序加载相关技能文档
4. 提供上下文相关的帮助

---

**版本**：1.0.0
**最后更新**：2026-03-19
