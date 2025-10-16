## 系统安装

目录

- 安装概述
- 后端安装
- 前端安装
- 数据库初始化
- 系统配置
- 启动系统
- 验证安装

### 安装概述

Gin-Fast 是一个基于 Gin 框架的后台管理系统，前端采用 Vue3 + Vite6 + TypeScript + Arco Design 构建。本指南将详细介绍如何安装 Gin-Fast 系统，包括后端安装、前端安装、数据库初始化、系统配置、启动系统和验证安装等内容。

### 后端安装

#### 1. 克隆项目

```bash
git clone https://github.com/qxkjsoft/ginfast-back.git
cd ginfast-back
```

#### 2. 安装依赖

```bash
go mod tidy
```

#### 3. 修改配置

```bash
# 复制配置文件
cp config/config.copy.yml config/config.yml

# 编辑配置文件
vim config/config.yml
```

配置文件示例：

```yaml
# 验证码配置
captcha:
  length: 4
  open: false

# Casbin 权限配置
casbin:
  autoloadpolicyseconds: 120
  modelconfig: |
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
  tablename: casbin_rule
  tableprefix: sys_

# 数据库配置
gormv2:
  mysql:
    isinitglobalgormmysql: 1
    isopenreaddb: 0
    read:
      charset: utf8mb4
      database: gin-fast
      host: 127.0.0.1
      pass: root
      port: 3306
      prefix: ""
      setconnmaxidletime: 30
      setconnmaxlifetime: 60
      setmaxidleconns: 10
      setmaxopenconns: 128
      user: root
    slowthreshold: 30
    write:
      charset: utf8mb4
      database: gin-fast
      host: 127.0.0.1
      pass: root
      port: 3306
      prefix: ""
      setconnmaxidletime: 30
      setconnmaxlifetime: 60
      setmaxidleconns: 10
      setmaxopenconns: 128
      user: root
  usedbtype: mysql

# HTTP 服务器配置
httpserver:
  allowcrossdomain: true
  port: :8080
  serverroot: ./resource/public
  serverrootpath: /public

# 日志配置
logs:
  compress: false
  ginlogname: /resource/logs/gin.log
  maxage: 15
  maxbackups: 7
  maxsize: 10
  textformat: console
  timeprecision: second
  zaplogname: /resource/logs/ginfast.log

# Redis 配置
redis:
  connfailretrytimes: 3
  host: 127.0.0.1
  idletimeout: 60
  indexdb: 1
  maxactive: 1000
  maxidle: 10
  password: ""
  port: 6379
  reconnectinterval: 1

# 安全配置
safe:
  loginlockduration: 600
  loginlockexpire: 30
  loginlockthreshold: 3
  minpasswordlength: 6
  requirespecialchar: false

# 服务器配置
server:
  appdebug: true
  cachetype: memory
  notcheckuser: []

# 系统配置
system:
  systemcopyright: Copyright © 2022 - present gin-fast 版权所有
  systemicon: /public/uploads/2025-10-11/20251011_3b06f7c4-2abe-48ac-9630-8deb11ceda01.ico
  systemlogo: /public/uploads/2025-10-11/20251011_45438318-e5ac-4fe0-8e64-beb3a81e71b8.svg
  systemname: GinFast
  systemrecordno: 粤ICP备12345678号

# Token 配置
token:
  cachekeyprefix: 'gin-fast:'
  jwttokenexpire: 3600
  jwttokenrefreshexpire: 2592000
  jwttokensignkey: gin-fast

# 上传配置
upload:
  allowed_types:
    - .jpg
    - .jpeg
    - .png
    - .gif
    - .bmp
    - .pdf
    - .doc
    - .docx
    - .xls
    - .xlsx
    - .txt
    - .zip
    - .rar
    - .svg
    - .ico
  local_path: ./resource/public/uploads
  max_size: 10
  qiniu_config:
    access_key: "your_access_key"
    bucket: "gin-fast"
    domain: "your_domain"
    secret_key: "your_secret_key"
    zone: ZoneHuanan
  upload_type: local
```

#### 4. 编译和运行

```bash
# 编译
go build -o gin-fast main.go

# 运行
./gin-fast
```

或者直接运行：

```bash
go run main.go
```

### 前端安装

#### 1. 克隆项目

```bash
git clone https://github.com/qxkjsoft/ginfast-front.git
cd ginfast-front
```

#### 2. 安装依赖

```bash
pnpm install
```

#### 3. 修改配置

```bash
# 编辑环境配置文件
vim .env.development
```

环境配置文件示例：

```env
# 开发环境配置
VITE_APP_TITLE = GindFast
VITE_APP_BASE_API = /api
VITE_APP_BASE_URL = http://localhost:8080
VITE_APP_MOCK_ENABLE = true
```

#### 4. 启动开发服务器

```bash
pnpm run dev
```

### 数据库初始化

#### 1. 创建数据库

```sql
CREATE DATABASE gin_fast CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 2. 导入数据库结构

```bash
mysql -u gin_fast -p gin_fast < resource/database/gin-fast.sql
```

#### 3. 验证数据库

```bash
mysql -u gin_fast -p gin_fast
```

```sql
SHOW TABLES;
```

### 系统配置

#### 1. 后端配置

编辑 `config/config.yml` 文件，根据实际情况修改以下配置：

```yaml
# 验证码配置
captcha:
  length: 4
  open: false

# Casbin 权限配置
casbin:
  autoloadpolicyseconds: 120
  modelconfig: |
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
  tablename: casbin_rule
  tableprefix: sys_

# 数据库配置
gormv2:
  mysql:
    isinitglobalgormmysql: 1
    isopenreaddb: 0
    read:
      charset: utf8mb4
      database: gin-fast
      host: 127.0.0.1
      pass: root
      port: 3306
      prefix: ""
      setconnmaxidletime: 30
      setconnmaxlifetime: 60
      setmaxidleconns: 10
      setmaxopenconns: 128
      user: root
    slowthreshold: 30
    write:
      charset: utf8mb4
      database: gin-fast
      host: 127.0.0.1
      pass: root
      port: 3306
      prefix: ""
      setconnmaxidletime: 30
      setconnmaxlifetime: 60
      setmaxidleconns: 10
      setmaxopenconns: 128
      user: root
  usedbtype: mysql

# HTTP 服务器配置
httpserver:
  allowcrossdomain: true
  port: :8080
  serverroot: ./resource/public
  serverrootpath: /public

# 日志配置
logs:
  compress: false
  ginlogname: /resource/logs/gin.log
  maxage: 15
  maxbackups: 7
  maxsize: 10
  textformat: console
  timeprecision: second
  zaplogname: /resource/logs/ginfast.log

# Redis 配置
redis:
  connfailretrytimes: 3
  host: 127.0.0.1
  idletimeout: 60
  indexdb: 1
  maxactive: 1000
  maxidle: 10
  password: ""
  port: 6379
  reconnectinterval: 1

# 安全配置
safe:
  loginlockduration: 600
  loginlockexpire: 30
  loginlockthreshold: 3
  minpasswordlength: 6
  requirespecialchar: false

# 服务器配置
server:
  appdebug: true
  cachetype: memory
  notcheckuser: []

# 系统配置
system:
  systemcopyright: Copyright © 2022 - present gin-fast 版权所有
  systemicon: /public/uploads/2025-10-11/20251011_3b06f7c4-2abe-48ac-9630-8deb11ceda01.ico
  systemlogo: /public/uploads/2025-10-11/20251011_45438318-e5ac-4fe0-8e64-beb3a81e71b8.svg
  systemname: GinFast
  systemrecordno: 粤ICP备12345678号

# Token 配置
token:
  cachekeyprefix: 'gin-fast:'
  jwttokenexpire: 3600
  jwttokenrefreshexpire: 2592000
  jwttokensignkey: gin-fast

# 上传配置
upload:
  allowed_types:
    - .jpg
    - .jpeg
    - .png
    - .gif
    - .bmp
    - .pdf
    - .doc
    - .docx
    - .xls
    - .xlsx
    - .txt
    - .zip
    - .rar
    - .svg
    - .ico
  local_path: ./resource/public/uploads
  max_size: 10
  qiniu_config:
    access_key: "your_access_key"
    bucket: "gin-fast"
    domain: "your_domain"
    secret_key: "your_secret_key"
    zone: ZoneHuanan
  upload_type: local
```

#### 2. 前端配置

编辑 `.env.development` 文件，根据实际情况修改以下配置：

```env
# 开发环境配置
VITE_APP_TITLE = GindFast
VITE_APP_BASE_API = /api
VITE_APP_BASE_URL = http://localhost:8080
VITE_APP_MOCK_ENABLE = true
```

### 启动系统

#### 1. 启动后端服务

```bash
cd gin-fast
go run main.go
```

#### 2. 启动前端服务

```bash
cd ginfast-front
pnpm run dev
```

#### 3. 访问系统

打开浏览器，访问 http://localhost:8001，即可看到系统登录页面。

### 验证安装

#### 1. 验证后端服务

```bash
curl http://localhost:8080/ping
```

如果返回 `{"code":0,"msg":"success","data":"pong"}`，说明后端服务启动成功。

#### 2. 验证前端服务

打开浏览器，访问 http://localhost:8001，如果看到系统登录页面，说明前端服务启动成功。

#### 3. 验证数据库连接

```bash
mysql -u gin_fast -p gin_fast
```

```sql
SHOW TABLES;
```

如果看到数据库表列表，说明数据库连接成功。

#### 4. 验证 Redis 连接

```bash
redis-cli -h 127.0.0.1 -p 6379 -a your_redis_password ping
```

如果返回 `PONG`，说明 Redis 连接成功。

#### 5. 验证系统功能

1. 使用默认账号登录系统：
   - 用户名：admin
   - 密码：123456

2. 验证系统功能：
   - 用户管理
   - 角色管理
   - 菜单管理
   - 部门管理
   - 字典管理
   - API管理

### 常见问题

#### 1. 后端启动失败

**问题**：后端服务启动失败，提示数据库连接失败。

**解决方案**：
1. 检查数据库配置是否正确
2. 检查数据库服务是否正常运行
3. 检查数据库用户权限是否正确

```bash
# 检查数据库服务状态
systemctl status mariadb

# 检查数据库连接
mysql -u gin_fast -p -h 127.0.0.1
```

#### 2. 前端启动失败

**问题**：前端服务启动失败，提示依赖安装失败。

**解决方案**：
1. 清除 node_modules 和 pnpm-lock.yaml
2. 重新安装依赖

```bash
# 清除 node_modules 和 pnpm-lock.yaml
rm -rf node_modules
rm -rf pnpm-lock.yaml

# 重新安装依赖
pnpm install --registry=https://registry.npmmirror.com
```

#### 3. 数据库初始化失败

**问题**：数据库初始化失败，提示表已存在。

**解决方案**：
1. 删除已存在的数据库
2. 重新创建数据库
3. 重新导入数据库结构

```sql
DROP DATABASE IF EXISTS gin_fast;
CREATE DATABASE gin_fast CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

```bash
mysql -u gin_fast -p gin_fast < resource/database/gin-fast.sql
```

#### 4. Redis 连接失败

**问题**：后端服务启动失败，提示 Redis 连接失败。

**解决方案**：
1. 检查 Redis 配置是否正确
2. 检查 Redis 服务是否正常运行
3. 检查 Redis 密码是否正确

```bash
# 检查 Redis 服务状态
systemctl status redis

# 检查 Redis 连接
redis-cli -h 127.0.0.1 -p 6379 -a your_redis_password ping
```

#### 5. 前端请求后端 API 失败

**问题**：前端请求后端 API 失败，提示跨域错误。

**解决方案**：
1. 检查前端 API 基础路径配置是否正确
2. 检查后端 CORS 配置是否正确
3. 检查后端服务是否正常运行

```env
# 检查前端 API 基础路径配置
VITE_APP_BASE_API = /api
VITE_APP_BASE_URL = http://localhost:8080
```

### 总结

通过以上步骤，您应该已经成功安装了 Gin-Fast 系统。如果遇到问题，请参考常见问题部分或提交 Issue。