# Gin-Fast 文档

## 文档目录

- [系统介绍](introduction.md)
- [环境搭建](environment.md)
- [系统安装](installation.md)
- [目录结构](catalog.md)
- [开发规范](exploit.md)
- [前端开发文档](frontend-introduction.md)
  - [前端介绍](frontend-introduction.md)
  - [前端环境](frontend-environment.md)
  - [前端目录](frontend-catalog.md)
  - [前端指南](frontend-guide.md)
- [部署指南](deployment.md)
- [常见问题](faq.md)

## 快速开始

### 1. 环境要求

- **Go**: 版本 >= 1.18 (推荐 1.20+)
- **Node.js**: 版本 >= 18.12.0 (推荐 20.12.0+)
- **pnpm**: 版本 >= 8.7.0
- **MySQL**: 版本 >= 5.7
- **Redis**: 版本 >= 5.0
- **Git**: 最新版本

### 2. 安装步骤

1. 克隆项目

```bash
git clone <repository-url>
cd gin-fast
```

2. 安装后端依赖

```bash
go mod tidy
```

3. 安装前端依赖

```bash
cd gin-fast-front/SnowAdmin
pnpm install
```

4. 初始化数据库

```bash
mysql -u root -p
CREATE DATABASE gin_fast CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit;
mysql -u root -p gin_fast < resource/database/gin-fast.sql
```

5. 修改配置

```bash
# 复制配置文件
cp config/config.copy.yml config/config.yml

# 编辑配置文件
vim config/config.yml
```

6. 启动后端服务

```bash
cd ../../
go run main.go
```

7. 启动前端服务

```bash
cd gin-fast-front/SnowAdmin
pnpm run dev
```

8. 访问系统

打开浏览器，访问 http://localhost:8001，使用默认账号登录：
- 用户名：admin
- 密码：123456

## 文档说明

### 系统介绍

[系统介绍](introduction.md) 文档包含项目概述、核心特性、技术栈、系统架构、功能模块、适用场景等内容，帮助您快速了解 Gin-Fast 系统。

### 环境搭建

[环境搭建](environment.md) 文档包含环境要求、开发工具、环境配置、验证环境等内容，帮助您搭建开发环境。

### 系统安装

[系统安装](installation.md) 文档包含安装概述、后端安装、前端安装、数据库初始化、系统配置、启动系统、验证安装等内容，帮助您安装 Gin-Fast 系统。

### 目录结构

[目录结构](catalog.md) 文档包含项目结构、目录说明、文件说明、模块说明等内容，帮助您了解项目结构。

### 开发规范

[开发规范](exploit.md) 文档包含代码规范、Git规范、API规范、数据库规范、前端规范、文档规范等内容，帮助您遵循开发规范。

<!-- 删除API接口文档部分 -->

### 前端开发文档

[前端开发文档](frontend-introduction.md) 包含前端介绍、前端环境、前端目录、前端指南等内容，帮助您了解前端开发。

### 部署指南

[部署指南](deployment.md) 文档包含部署概述、环境准备、后端部署、前端部署、Nginx配置、Docker部署、常见问题等内容，帮助您部署 Gin-Fast 系统。

### 常见问题

[常见问题](faq.md) 文档包含开发环境问题、后端问题、前端问题、部署问题、数据库问题、权限问题、性能问题、其他问题等内容，帮助您解决常见问题。

## 贡献指南

如果您想为 Gin-Fast 项目贡献代码，请遵循以下步骤：

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 许可证

Gin-Fast 采用 MIT 许可证，详情请参阅 [LICENSE](../LICENSE) 文件。