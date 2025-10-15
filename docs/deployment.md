## 部署指南

目录

- 部署概述
- 环境准备
- 后端部署
- 前端部署
- Nginx 配置
- Docker 部署
- 常见问题

### 部署概述

Gin-Fast 是一个基于 Gin 框架的后台管理系统，前端采用 Vue3 + Vite6 + TypeScript + Arco Design 构建。本指南将详细介绍如何部署 Gin-Fast 系统，包括环境准备、后端部署、前端部署、Nginx 配置和 Docker 部署等内容。

### 环境准备

#### 服务器要求

- **操作系统**: Linux (推荐 CentOS 7+ 或 Ubuntu 18.04+)
- **CPU**: 2核及以上
- **内存**: 4GB及以上
- **硬盘**: 40GB及以上

#### 软件要求

- **Go**: 版本 >= 1.18
- **Node.js**: 版本 >= 18.12.0 (推荐 20.12.0+)
- **pnpm**: 版本 >= 8.7.0
- **MySQL**: 版本 >= 5.7
- **Redis**: 版本 >= 5.0
- **Nginx**: 版本 >= 1.18

#### 安装 Go

```bash
# 下载 Go 安装包
wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz

# 解压到 /usr/local
tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz

# 配置环境变量
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
echo 'export GOPATH=/root/go' >> /etc/profile
echo 'export GO111MODULE=on' >> /etc/profile
echo 'export GOPROXY=https://goproxy.cn,direct' >> /etc/profile

# 使环境变量生效
source /etc/profile

# 验证安装
go version
```

#### 安装 Node.js 和 pnpm

```bash
# 下载 Node.js 安装包
wget https://nodejs.org/dist/v20.12.0/node-v20.12.0-linux-x64.tar.xz

# 解压到 /usr/local
tar -xf node-v20.12.0-linux-x64.tar.xz -C /usr/local

# 配置环境变量
echo 'export PATH=$PATH:/usr/local/node-v20.12.0-linux-x64/bin' >> /etc/profile

# 使环境变量生效
source /etc/profile

# 验证安装
node -v
npm -v

# 安装 pnpm
npm install -g pnpm

# 验证安装
pnpm -v
```

#### 安装 MySQL

```bash
# CentOS 7+
yum install -y mariadb-server mariadb

# 启动 MySQL
systemctl start mariadb
systemctl enable mariadb

# 安全配置
mysql_secure_installation

# 登录 MySQL
mysql -u root -p

# 创建数据库
CREATE DATABASE gin_fast CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 创建用户
CREATE USER 'gin_fast'@'%' IDENTIFIED BY 'your_password';

# 授权
GRANT ALL PRIVILEGES ON gin_fast.* TO 'gin_fast'@'%';

# 刷新权限
FLUSH PRIVILEGES;

# 退出
exit;
```

#### 安装 Redis

```bash
# CentOS 7+
yum install -y redis

# 启动 Redis
systemctl start redis
systemctl enable redis

# 配置 Redis 密码
sed -i 's/# requirepass foobared/requirepass your_redis_password/g' /etc/redis.conf

# 重启 Redis
systemctl restart redis
```

#### 安装 Nginx

```bash
# CentOS 7+
yum install -y nginx

# 启动 Nginx
systemctl start nginx
systemctl enable nginx
```

### 后端部署

#### 1. 克隆项目

```bash
cd /opt
git clone <repository-url>
cd gin-fast
```

#### 2. 修改配置

```bash
# 复制配置文件
cp config/config.copy.yml config/config.yml

# 编辑配置文件
vim config/config.yml
```

配置文件示例：

```yaml
captcha:
    length: 4
    open: false
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
    postgresql:
        isinitglobalgormpostgresql: 0
        isopenreaddb: 0
        read:
            database: gin-fast
            host: 127.0.0.1
            pass: ""
            port: 5432
            prefix: ""
            setconnmaxidletime: 30
            setconnmaxlifetime: 60
            setmaxidleconns: 10
            setmaxopenconns: 128
            user: ""
        slowthreshold: 30
        write:
            database: gin-fast
            host: 127.0.0.1
            pass: ""
            port: 5432
            prefix: ""
            setconnmaxidletime: 30
            setconnmaxlifetime: 60
            setmaxidleconns: 10
            setmaxopenconns: 128
            user: ""
    sqlserver:
        isinitglobalgormsqlserver: 0
        isopenreaddb: 0
        read:
            database: gin-fast
            host: 127.0.0.1
            pass: ""
            port: 1433
            prefix: ""
            setconnmaxidletime: 30
            setconnmaxlifetime: 60
            setmaxidleconns: 10
            setmaxopenconns: 128
            user: ""
        slowthreshold: 30
        write:
            database: gin-fast
            host: 127.0.0.1
            pass: ""
            port: 1433
            prefix: ""
            setconnmaxidletime: 30
            setconnmaxlifetime: 60
            setmaxidleconns: 10
            setmaxopenconns: 128
            user: ""
    usedbtype: mysql
httpserver:
    allowcrossdomain: true
    port: :8080
    serverroot: ./resource/public
    serverrootpath: /public
logs:
    compress: false
    ginlogname: /resource/logs/gin.log
    maxage: 15
    maxbackups: 7
    maxsize: 10
    textformat: console
    timeprecision: second
    zaplogname: /resource/logs/ginfast.log
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
safe:
    loginlockduration: 600
    loginlockexpire: 30
    loginlockthreshold: 3
    minpasswordlength: 6
    requirespecialchar: false
server:
    appdebug: true
    cachetype: memory
    notcheckuser: []
system:
    systemcopyright: Copyright © 2022 - present gin-fast 版权所有
    systemicon: /public/uploads/2025-10-11/20251011_3b06f7c4-2abe-48ac-9630-8deb11ceda01.ico
    systemlogo: /public/uploads/2025-10-11/20251011_45438318-e5ac-4fe0-8e64-beb3a81e71b8.svg
    systemname: GinFast
    systemrecordno: 粤ICP备12345678号
token:
    cachekeyprefix: 'gin-fast:'
    jwttokenexpire: 3600
    jwttokenrefreshexpire: 2592000
    jwttokensignkey: gin-fast
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
        access_key: ""
        bucket: "gin-fast"
        domain: ""
        secret_key: ""
        zone: ZoneHuanan
    upload_type: local
```

#### 3. 初始化数据库

```bash
# 导入数据库结构
mysql -u gin_fast -p gin_fast < resource/gin-fast.sql
```

#### 4. 编译和运行

```bash
# 编译
go build -o gin-fast main.go

# 运行
./gin-fast
```

#### 5. 使用 systemd 管理服务

```bash
# 创建服务文件
vim /etc/systemd/system/gin-fast.service
```

服务文件内容：

```ini
[Unit]
Description=Gin-Fast Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/gin-fast
ExecStart=/opt/gin-fast/gin-fast
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

```bash
# 启动服务
systemctl start gin-fast
systemctl enable gin-fast

# 查看服务状态
systemctl status gin-fast
```

### 前端部署

#### 1. 克隆项目

```bash
cd /opt
git clone <repository-url>
cd gin-fast-front/GinFast
```

#### 2. 安装依赖

```bash
pnpm install
```

#### 3. 修改配置

```bash
# 编辑环境配置文件
vim .env.production
```

环境配置文件示例：

```env
# 生产环境配置
VITE_APP_TITLE = ginfast
VITE_APP_BASE_API = /api
VITE_APP_BASE_URL = http://your-domain.com
VITE_APP_MOCK_ENABLE = false
```

#### 4. 构建项目

```bash
pnpm run build:prod
```

#### 5. 部署到 Nginx

```bash
# 创建部署目录
mkdir -p /var/www/ginfast

# 复制构建文件
cp -r dist/* /var/www/ginfast/
```

### Nginx 配置

#### 1. 创建 Nginx 配置文件

```bash
vim /etc/nginx/conf.d/snow-admin.conf
```

配置文件内容：

```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 前端静态资源
    location / {
        root /var/www/ginfast;
        index index.html;
        try_files $uri $uri/ /index.html;
        
        # 缓存静态资源
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # 后端 API 代理
    location /api {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # 禁止访问隐藏文件
    location ~ /\. {
        deny all;
    }

    # 错误页面
    error_page 404 /index.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```

#### 2. 重启 Nginx

```bash
# 检查配置文件
nginx -t

# 重启 Nginx
systemctl restart nginx
```

#### 3. 配置 HTTPS（可选）

```bash
# 安装 Certbot
yum install -y certbot python2-certbot-nginx

# 获取证书
certbot --nginx -d your-domain.com

# 自动续期
echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | tee -a /etc/crontab > /dev/null 2>&1
```

### Docker 部署

#### 1. 创建 Dockerfile

后端 Dockerfile：

```dockerfile
# 构建阶段
FROM golang:1.20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制 go mod 文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 编译
RUN CGO_ENABLED=0 GOOS=linux go build -o gin-fast main.go

# 运行阶段
FROM alpine:latest

# 安装 ca-certificates 和 timezone
RUN apk --no-cache add ca-certificates tzdata

# 设置时区
ENV TZ=Asia/Shanghai

# 设置工作目录
WORKDIR /root/

# 从构建阶段复制二进制文件
COPY --from=builder /app/gin-fast .

# 复制配置文件
COPY --from=builder /app/config ./config

# 复制资源文件
COPY --from=builder /app/resource ./resource

# 创建日志目录
RUN mkdir -p logs

# 暴露端口
EXPOSE 8080

# 运行应用
CMD ["./gin-fast"]
```

前端 Dockerfile：

```dockerfile
# 构建阶段
FROM node:20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# 安装 pnpm
RUN npm install -g pnpm

# 安装依赖
RUN pnpm install

# 复制源代码
COPY . .

# 构建项目
RUN pnpm run build:prod

# 运行阶段
FROM nginx:alpine

# 复制构建文件
COPY --from=builder /app/dist /usr/share/nginx/html

# 复制 Nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
```

#### 2. 创建 docker-compose.yml

```
version: '3.8'

services:
  mysql:
    image: mysql:5.7
    container_name: gin-fast-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: gin_fast
      MYSQL_USER: gin_fast
      MYSQL_PASSWORD: your_password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./resource/gin-fast.sql:/docker-entrypoint-initdb.d/gin-fast.sql
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

  redis:
    image: redis:6-alpine
    container_name: gin-fast-redis
    restart: always
    command: redis-server --requirepass your_redis_password
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  backend:
    build:
      context: ./gin-fast
      dockerfile: Dockerfile
    container_name: gin-fast-backend
    restart: always
    ports:
      - "8080:8080"
    depends_on:
      - mysql
      - redis
    volumes:
      - ./gin-fast/logs:/root/logs
      - ./gin-fast/public/uploads:/root/public/uploads
    environment:
      - GIN_MODE=release

  frontend:
    build:
      context: ./gin-fast-front/SnowAdmin
      dockerfile: Dockerfile
    container_name: gin-fast-frontend
    restart: always
    ports:
      - "80:80"
    depends_on:
      - backend

volumes:
  mysql_data:
  redis_data:
```

#### 3. 部署

```bash
# 启动服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 常见问题

#### 1. 后端启动失败

**问题**：后端服务启动失败，提示数据库连接失败。

**解决方案**：
1. 检查数据库配置是否正确
2. 检查数据库服务是否正常运行
3. 检查数据库用户权限是否正确
4. 检查防火墙是否阻止了数据库连接

```bash
# 检查数据库服务状态
systemctl status mariadb

# 检查数据库连接
mysql -u gin_fast -p -h 127.0.0.1
```

#### 2. 前端访问 404

**问题**：前端页面刷新后出现 404 错误。

**解决方案**：
1. 检查 Nginx 配置中的 `try_files` 指令是否正确
2. 确保 `try_files $uri $uri/ /index.html;` 配置正确

```nginx
location / {
    root /var/www/ginfast;
    index index.html;
    try_files $uri $uri/ /index.html;
}
```

#### 3. 前端请求后端 API 失败

**问题**：前端请求后端 API 失败，提示跨域错误。

**解决方案**：
1. 检查 Nginx 配置中的 API 代理是否正确
2. 检查后端 CORS 配置是否正确
3. 检查前端 API 基础路径配置是否正确

```nginx
location /api {
    proxy_pass http://127.0.0.1:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

#### 4. Docker 容器启动失败

**问题**：Docker 容器启动失败，提示端口被占用。

**解决方案**：
1. 检查端口是否被其他服务占用
2. 修改 docker-compose.yml 中的端口映射
3. 停止占用端口的服务

```bash
# 检查端口占用
netstat -tunlp | grep 8080

# 停止占用端口的服务
systemctl stop nginx
```

#### 5. 上传文件失败

**问题**：上传文件失败，提示目录不存在或权限不足。

**解决方案**：
1. 检查上传目录是否存在
2. 检查上传目录权限是否正确
3. 创建上传目录并设置权限

```bash
# 创建上传目录
mkdir -p public/uploads

# 设置权限
chmod 755 public/uploads
```

#### 6. Redis 连接失败

**问题**：后端服务启动失败，提示 Redis 连接失败。

**解决方案**：
1. 检查 Redis 服务是否正常运行
2. 检查 Redis 配置是否正确
3. 检查防火墙是否阻止了 Redis 连接

```bash
# 检查 Redis 服务状态
systemctl status redis

# 检查 Redis 连接
redis-cli -h 127.0.0.1 -p 6379 -a your_redis_password ping
```

### 总结

通过以上步骤，您应该已经成功部署了 Gin-Fast 系统。在实际部署过程中，请根据实际情况调整配置，确保系统稳定运行。如果遇到问题，请参考常见问题部分或提交 Issue。