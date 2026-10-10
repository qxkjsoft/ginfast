## 前端环境搭建

目录

- 环境要求
- 开发工具
- 环境配置
- 验证环境

### 环境要求

- **Node.js**: 版本 >= 18.12.0 (推荐 20.12.0+)
- **pnpm**: 版本 >= 8.7.0
- **Git**: 最新版本

### 开发工具

#### 编辑器

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

- **WebStorm**: JetBrains 出品的前端 IDE，内置 Vue 和 TypeScript 支持

#### 浏览器

- **Chrome**: 推荐使用，配合以下插件：
  - Vue.js devtools
  - Redux DevTools (用于 Pinia 调试)
  - JSONView

#### 其他工具

- **Git**: 版本控制工具
- **Node.js**: JavaScript 运行时环境
- **pnpm**: 包管理工具

### 环境配置

#### 1. 安装 Node.js

1. 前往 [Node.js 官网](https://nodejs.org/zh-cn/) 下载最新 LTS 版本
2. 安装 Node.js，确保安装路径不包含中文和空格
3. 验证安装：

```bash
node -v
npm -v
```

#### 2. 安装 pnpm

```bash
npm install -g pnpm
```

验证安装：

```bash
pnpm -v
```

#### 3. 配置 Git

1. 安装 Git
2. 配置用户信息：

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

3. 配置 SSH 密钥（可选）：

```bash
ssh-keygen -t rsa -C "your.email@example.com"
```

#### 4. 配置 VS Code

1. 安装 VS Code
2. 安装推荐插件
3. 配置 VS Code 设置（.vscode/settings.json）：

```json
{
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

#### 5. 配置环境变量

在项目根目录下创建以下环境变量文件：

- `.env`: 默认环境变量
- `.env.development`: 开发环境变量
- `.env.test`: 测试环境变量
- `.env.production`: 生产环境变量

示例 `.env.development`:

```env
# 开发环境配置
VITE_APP_TITLE = SnowAdmin
VITE_APP_BASE_API = /api
VITE_APP_BASE_URL = http://localhost:8080
VITE_APP_MOCK_ENABLE = true
VITE_APP_MOCK_URL = http://localhost:8080/mock
```

### 验证环境

#### 1. 验证 Node.js 环境

```bash
node -v
npm -v
```

确保 Node.js 版本 >= 18.12.0

#### 2. 验证 pnpm 环境

```bash
pnpm -v
```

确保 pnpm 版本 >= 8.7.0

#### 3. 验证 Git 环境

```bash
git --version
```

#### 4. 验证项目环境

1. 克隆项目：

```bash
git clone <repository-url>
cd gin-fast-front/SnowAdmin
```

2. 安装依赖：

```bash
pnpm install
```

3. 启动开发服务器：

```bash
pnpm run dev
```

4. 访问 http://localhost:8001，确认项目正常运行

### 常见问题

#### 1. Node.js 版本问题

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

#### 2. pnpm 安装失败

如果 pnpm 安装失败，可以尝试以下方法：

```bash
# 清除缓存
npm cache clean --force

# 重新安装 pnpm
npm install -g pnpm --registry=https://registry.npmmirror.com
```

#### 3. 依赖安装失败

如果依赖安装失败，可以尝试以下方法：

```bash
# 清除 node_modules 和 pnpm-lock.yaml
rm -rf node_modules
rm -rf pnpm-lock.yaml

# 重新安装依赖
pnpm install --registry=https://registry.npmmirror.com
```

#### 4. TypeScript 类型错误

如果遇到 TypeScript 类型错误，可以尝试以下方法：

```bash
# 重新生成类型声明
pnpm run type:check

# 重新安装依赖
pnpm install
```

#### 5. ESLint 或 Stylelint 错误

如果遇到 ESLint 或 Stylelint 错误，可以尝试以下方法：

```bash
# 自动修复 ESLint 错误
pnpm run lint:eslint

# 自动修复 Stylelint 错误
pnpm run lint:stylelint
```

### 环境优化

#### 1. 配置镜像源

```bash
# 配置 npm 镜像源
npm config set registry https://registry.npmmirror.com

# 配置 pnpm 镜像源
pnpm config set registry https://registry.npmmirror.com
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

通过以上步骤，您应该已经成功搭建了 GinFast 前端开发环境。如果遇到问题，请参考常见问题部分或提交 Issue。