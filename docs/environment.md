## 环境搭建

目录

- 环境要求
- 开发工具
- 环境配置
- 验证环境

### 环境要求

- **Go**: 版本 >= 1.18 (推荐 1.20+)
- **Node.js**: 版本 >= 18.12.0 (推荐 20.12.0+)
- **pnpm**: 版本 >= 8.7.0
- **MySQL**: 版本 >= 5.7
- **Redis**: 版本 >= 5.0
- **Git**: 最新版本

### 开发工具

#### 后端开发工具

- **GoLand**: JetBrains 出品的 Go 语言 IDE，提供智能代码补全、调试、版本控制等功能。
- **VS Code**: 微软推出的轻量级代码编辑器，配合 Go 插件可以实现高效的 Go 开发。
- **Git**: 版本控制工具，用于代码管理和团队协作。

#### 前端开发工具

- **VS Code**: 推荐使用，配合以下插件：
  - Volar (Vue 3 官方推荐)
  - TypeScript Vue Plugin (Volar)
  - ESLint
  - Prettier - Code formatter
  - Stylelint
  - GitLens
  - Auto Rename Tag
  - Path Intellisense
  - Tailwind CSS IntelliSense

- **WebStorm**: JetBrains 出品的前端 IDE，内置 Vue 和 TypeScript 支持。

#### 数据库工具

- **Navicat**: 强大的数据库管理工具，支持 MySQL、Redis 等多种数据库。
- **DataGrip**: JetBrains 出品的数据库 IDE，提供智能查询、代码补全等功能。
- **Redis Desktop Manager**: Redis 可视化管理工具。

#### 其他工具

- **Postman**: API 测试工具，用于接口调试和测试。
- **Git**: 版本控制工具。
- **Docker**: 容器化工具，用于环境隔离和部署。

### 环境配置

#### 1. 安装 Go

##### Windows

1. 前往 [Go 官网](https://golang.org/dl/) 下载 Windows 版本的 Go 安装包。
2. 双击安装包，按照提示完成安装。
3. 验证安装：

```bash
go version
```

##### macOS

1. 使用 Homebrew 安装：

```bash
brew install go
```

2. 验证安装：

```bash
go version
```

##### Linux

1. 下载 Go 安装包：

```bash
wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz
```

2. 解压到 /usr/local：

```bash
tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
```

3. 配置环境变量：

```bash
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
echo 'export GOPATH=/root/go' >> /etc/profile
echo 'export GO111MODULE=on' >> /etc/profile
echo 'export GOPROXY=https://goproxy.cn,direct' >> /etc/profile
```

4. 使环境变量生效：

```bash
source /etc/profile
```

5. 验证安装：

```bash
go version
```

#### 2. 安装 Node.js 和 pnpm

##### Windows

1. 前往 [Node.js 官网](https://nodejs.org/zh-cn/) 下载 Windows 版本的 Node.js 安装包。
2. 双击安装包，按照提示完成安装。
3. 验证安装：

```bash
node -v
npm -v
```

4. 安装 pnpm：

```bash
npm install -g pnpm
```

5. 验证安装：

```bash
pnpm -v
```

##### macOS

1. 使用 Homebrew 安装：

```bash
brew install node
```

2. 验证安装：

```bash
node -v
npm -v
```

3. 安装 pnpm：

```bash
npm install -g pnpm
```

4. 验证安装：

```bash
pnpm -v
```

##### Linux

1. 下载 Node.js 安装包：

```bash
wget https://nodejs.org/dist/v20.12.0/node-v20.12.0-linux-x64.tar.xz
```

2. 解压到 /usr/local：

```bash
tar -xf node-v20.12.0-linux-x64.tar.xz -C /usr/local
```

3. 配置环境变量：

```bash
echo 'export PATH=$PATH:/usr/local/node-v20.12.0-linux-x64/bin' >> /etc/profile
```

4. 使环境变量生效：

```bash
source /etc/profile
```

5. 验证安装：

```bash
node -v
npm -v
```

6. 安装 pnpm：

```bash
npm install -g pnpm
```

7. 验证安装：

```bash
pnpm -v
```

#### 3. 安装 MySQL

##### Windows

1. 前往 [MySQL 官网](https://dev.mysql.com/downloads/installer/) 下载 MySQL Installer。
2. 双击安装包，按照提示完成安装。
3. 配置 MySQL：
   - 设置 root 用户密码
   - 创建 gin_fast 数据库
   - 创建 gin_fast 用户并授权

##### macOS

1. 使用 Homebrew 安装：

```bash
brew install mysql
```

2. 启动 MySQL：

```bash
brew services start mysql
```

3. 安全配置：

```bash
mysql_secure_installation
```

4. 登录 MySQL：

```bash
mysql -u root -p
```

5. 创建数据库和用户：

```sql
CREATE DATABASE gin_fast CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'gin_fast'@'%' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON gin_fast.* TO 'gin_fast'@'%';
FLUSH PRIVILEGES;
```

##### Linux (CentOS)

1. 安装 MySQL：

```bash
yum install -y mariadb-server mariadb
```

2. 启动 MySQL：

```bash
systemctl start mariadb
systemctl enable mariadb
```

3. 安全配置：

```bash
mysql_secure_installation
```

4. 登录 MySQL：

```bash
mysql -u root -p
```

5. 创建数据库和用户：

```sql
CREATE DATABASE gin_fast CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'gin_fast'@'%' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON gin_fast.* TO 'gin_fast'@'%';
FLUSH PRIVILEGES;
```

#### 4. 安装 Redis

##### Windows

1. 前往 [Redis 官网](https://redis.io/download) 下载 Windows 版本的 Redis。
2. 解压到指定目录。
3. 启动 Redis：

```bash
redis-server.exe redis.windows.conf
```

##### macOS

1. 使用 Homebrew 安装：

```bash
brew install redis
```

2. 启动 Redis：

```bash
brew services start redis
```

##### Linux (CentOS)

1. 安装 Redis：

```bash
yum install -y redis
```

2. 启动 Redis：

```bash
systemctl start redis
systemctl enable redis
```

3. 配置 Redis 密码：

```bash
sed -i 's/# requirepass foobared/requirepass your_redis_password/g' /etc/redis.conf
```

4. 重启 Redis：

```bash
systemctl restart redis
```

#### 5. 配置 Git

##### Windows

1. 下载并安装 Git：[Git 官网](https://git-scm.com/download/win)
2. 配置用户信息：

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

##### macOS

1. 使用 Homebrew 安装：

```bash
brew install git
```

2. 配置用户信息：

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

##### Linux

1. 安装 Git：

```bash
yum install -y git
```

2. 配置用户信息：

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### 6. 配置 VS Code

1. 安装 VS Code：[VS Code 官网](https://code.visualstudio.com/)
2. 安装推荐插件
3. 配置 VS Code 设置（.vscode/settings.json）：

```json
{
  "go.formatTool": "goimports",
  "go.lintTool": "golangci-lint",
  "go.lintOnSave": "file",
  "go.testOnSave": false,
  "go.coverOnSave": false,
  "go.useLanguageServer": true,
  "go.gopath": "/go",
  "go.goroot": "/usr/local/go",
  "go.toolsGopath": "/go/bin",
  "go.autocompleteUnimportedPackages": true,
  "go.docsTool": "godoc",
  "go.inferGopath": true,
  "go.gotoSymbol.includeImports": true,
  "go.useCodeSnippetsOnFunctionSuggest": true,
  "go.useCodeSnippetsOnFunctionSuggestWithoutType": true,
  "go.liveErrors": {
    "enabled": true,
    "delay": 500
  },
  "go.codeLens": {
    "runtest": true
  },
  "go.codeLens.enable": true,
  "go.suggest.snippets": true,
  "go.editor.formatOnSave": true,
  "go.lintFlags": [
    "--fast"
  ],
  "go.buildFlags": [],
  "go.lintFlags": [],
  "go.vetFlags": [],
  "go.testFlags": [
    "-v",
    "-race"
  ],
  "go.testTimeout": "30s",
  "go.testEnvVars": {
    "GO111MODULE": "on"
  },
  "go.testEnvFile": "${workspaceFolder}/.env",
  "go.gocodeAutoBuild": false,
  "go.gocodePackageLookupMode": "go",
  "go.gotoSymbol.includeGoroot": false,
  "go.useCodeSnippetsOnFunctionSuggest": true,
  "go.editor.formatOnSave": true,
  "go.lintOnSave": "file",
  "go.vetOnSave": "workspace",
  "go.buildOnSave": "workspace",
  "go.coverOnSave": false,
  "go.testOnSave": false,
  "go.toolsManagement.autoUpdate": true,
  "go.toolsManagement.checkForUpdates": "daily",
  "go.alternateTools": {
    "go-langserver": "gopls"
  },
  "go.languageServerExperimentalFeatures": {
    "diagnostics": true,
    "documentLink": true
  },
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.fixAll.stylelint": true
  },
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.detectIndentation": false,
  "files.associations": {
    "*.vue": "vue"
  },
  "typescript.tsdk": "node_modules/typescript/lib",
  "vue.codeActions.enabled": true,
  "vue.complete.casing.tags": "pascal",
  "vue.complete.casing.props": "camel",
  "vetur.validation.template": false,
  "vetur.validation.script": false,
  "vetur.validation.style": false,
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue"
  ],
  "stylelint.validate": [
    "css",
    "scss",
    "vue"
  ]
}
```



### 验证环境

#### 1. 验证 Go 环境

```bash
go version
```

确保 Go 版本 >= 1.18

#### 2. 验证 Node.js 环境

```bash
node -v
npm -v
```

确保 Node.js 版本 >= 18.12.0

#### 3. 验证 pnpm 环境

```bash
pnpm -v
```

确保 pnpm 版本 >= 8.7.0

#### 4. 验证 MySQL 环境

```bash
mysql -u gin_fast -p -h 127.0.0.1
```

确保能够连接到 MySQL 数据库

#### 5. 验证 Redis 环境

```bash
redis-cli -h 127.0.0.1 -p 6379 -a your_redis_password ping
```

确保能够连接到 Redis 服务器

#### 6. 验证 Git 环境

```bash
git --version
```

#### 7. 验证项目环境

1. 克隆项目：

```bash
git clone <repository-url>
cd gin-fast
```

2. 安装后端依赖：

```bash
go mod tidy
```

3. 安装前端依赖：

```bash
cd gin-fast-front/SnowAdmin
pnpm install
```

4. 启动后端服务：

```bash
cd ../../
go run main.go
```

5. 启动前端服务：

```bash
cd gin-fast-front/SnowAdmin
pnpm run dev
```

6. 访问 http://localhost:8001，确认项目正常运行

### 常见问题

#### 1. Go 版本问题

如果 Go 版本过低，可以使用 gvm 管理 Go 版本：

```bash
# 安装 gvm
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source ~/.gvm/scripts/gvm

# 安装指定版本的 Go
gvm install go1.20.5
gvm use go1.20.5 --default
```

#### 2. Node.js 版本问题

如果 Node.js 版本过低，可以使用 nvm 管理 Node.js 版本：

```bash
# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 重新加载终端
source ~/.bashrc

# 安装指定版本的 Node.js
nvm install 20.12.0

# 使用指定版本的 Node.js
nvm use 20.12.0

# 设置默认版本
nvm alias default 20.12.0
```

#### 3. pnpm 安装失败

如果 pnpm 安装失败，可以尝试以下方法：

```bash
# 清除缓存
npm cache clean --force

# 重新安装 pnpm
npm install -g pnpm --registry=https://registry.npmmirror.com
```

#### 4. 依赖安装失败

如果依赖安装失败，可以尝试以下方法：

```bash
# 清除 node_modules 和 pnpm-lock.yaml
rm -rf node_modules
rm -rf pnpm-lock.yaml

# 重新安装依赖
pnpm install --registry=https://registry.npmmirror.com
```

#### 5. MySQL 连接失败

如果 MySQL 连接失败，可以尝试以下方法：

```bash
# 检查 MySQL 服务状态
systemctl status mariadb

# 检查 MySQL 连接
mysql -u gin_fast -p -h 127.0.0.1
```

#### 6. Redis 连接失败

如果 Redis 连接失败，可以尝试以下方法：

```bash
# 检查 Redis 服务状态
systemctl status redis

# 检查 Redis 连接
redis-cli -h 127.0.0.1 -p 6379 -a your_redis_password ping
```

### 环境优化

#### 1. 配置镜像源

```bash
# 配置 npm 镜像源
npm config set registry https://registry.npmmirror.com

# 配置 pnpm 镜像源
pnpm config set registry https://registry.npmmirror.com

# 配置 Go 代理
go env -w GOPROXY=https://goproxy.cn,direct
```

#### 2. 配置全局缓存

```bash
# 配置 pnpm 全局缓存目录
pnpm config set global-dir ~/.pnpm/global
pnpm config set cache-dir ~/.pnpm/cache
pnpm config set state-dir ~/.pnpm/state
```

#### 3. 配置 Git 代理

如果需要使用代理访问 GitHub，可以配置 Git 代理：

```bash
# 配置 HTTP 代理
git config --global http.proxy http://proxy-server:port

# 配置 HTTPS 代理
git config --global https.proxy http://proxy-server:port

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

### 总结

通过以上步骤，您应该已经成功搭建了 Gin-Fast 开发环境。如果遇到问题，请参考常见问题部分或提交 Issue。