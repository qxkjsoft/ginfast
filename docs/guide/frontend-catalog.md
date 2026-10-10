## 前端项目结构

目录

- 项目结构
- 目录说明
- 文件说明
- 模块说明

### 项目结构

```
/gin-fast-front/
├── public/                  # 静态资源（不参与打包）
│   ├── favicon.ico          # 网站图标
│   └── logo.png             # Logo
├── src/
│   ├── api/                 # 所有接口请求定义，按模块分类
│   │   ├── auth.ts          # 认证相关接口
│   │   ├── user.ts          # 用户相关接口
│   │   ├── system.ts        # 系统管理相关接口
│   │   └── index.ts         # 接口导出
│   ├── assets/              # 图片、字体等静态资源
│   │   ├── images/          # 图片资源
│   │   └── fonts/           # 字体资源
│   ├── components/          # 全局通用组件
│   │   ├── common/          # 通用组件
│   │   │   ├── Icon/        # 图标组件
│   │   │   ├── Table/       # 表格组件
│   │   │   └── Form/        # 表单组件
│   │   ├── layout/          # 布局组件
│   │   │   ├── Header/      # 头部组件
│   │   │   ├── Sidebar/     # 侧边栏组件
│   │   │   └── Footer/      # 底部组件
│   │   └── business/        # 业务组件
│   │       ├── UserSelect/ # 用户选择组件
│   │       └── DictSelect/ # 字典选择组件
│   ├── config/              # 全局常量配置
│   │   ├── default.ts       # 默认配置
│   │   ├── env.ts           # 环境配置
│   │   └── index.ts         # 配置导出
│   ├── directives/          # 自定义指令
│   │   ├── permission/      # 权限指令
│   │   ├── loading/         # 加载指令
│   │   └── copy/            # 复制指令
│   ├── globals/             # 全局挂载函数或属性
│   │   ├── utils.ts         # 全局工具函数
│   │   └── index.ts         # 全局挂载
│   ├── hooks/               # Composition API 封装
│   │   ├── useAuth.ts       # 认证相关钩子
│   │   ├── useUser.ts       # 用户相关钩子
│   │   ├── useTable.ts      # 表格相关钩子
│   │   ├── useForm.ts       # 表单相关钩子
│   │   └── index.ts         # 钩子导出
│   ├── lang/                # 多语言配置
│   │   ├── en-US.ts         # 英文语言包
│   │   ├── zh-CN.ts         # 中文语言包
│   │   └── index.ts         # 语言包导出
│   ├── layout/              # 主布局组件
│   │   ├── components/      # 布局子组件
│   │   │   ├── AppMain.vue  # 主内容区
│   │   │   ├── Navbar.vue   # 导航栏
│   │   │   ├── Sidebar.vue  # 侧边栏
│   │   │   └── TagsView.vue # 标签页
│   │   └── index.vue        # 布局入口
│   ├── mock/                # 本地 Mock 数据服务
│   │   ├── auth.ts          # 认证相关 Mock
│   │   ├── user.ts          # 用户相关 Mock
│   │   ├── system.ts        # 系统管理相关 Mock
│   │   └── index.ts         # Mock 导出
│   ├── router/              # 路由配置
│   │   ├── modules/         # 路由模块
│   │   │   ├── auth.ts      # 认证路由
│   │   │   ├── user.ts      # 用户路由
│   │   │   ├── system.ts    # 系统管理路由
│   │   │   └── error.ts     # 错误页面路由
│   │   ├── guards.ts        # 路由守卫
│   │   ├── helper.ts        # 路由辅助函数
│   │   └── index.ts         # 路由导出
│   ├── store/               # Pinia 状态管理
│   │   ├── modules/         # 状态模块
│   │   │   ├── app.ts       # 应用状态
│   │   │   ├── user.ts      # 用户状态
│   │   │   ├── permission.ts # 权限状态
│   │   │   ├── settings.ts  # 设置状态
│   │   │   └── tagsView.ts  # 标签页状态
│   │   └── index.ts         # 状态导出
│   ├── style/               # 全局样式与 SCSS 变量
│   │   ├── variables.scss   # SCSS 变量
│   │   ├── mixins.scss      # SCSS 混合
│   │   ├── global.scss      # 全局样式
│   │   ├── transition.scss  # 过渡动画
│   │   └── index.scss       # 样式入口
│   ├── typings/             # TypeScript 类型声明扩展
│   │   ├── api.d.ts         # API 类型声明
│   │   ├── components.d.ts  # 组件类型声明
│   │   ├── env.d.ts         # 环境变量类型声明
│   │   ├── router.d.ts      # 路由类型声明
│   │   ├── store.d.ts       # 状态类型声明
│   │   └── utils.d.ts       # 工具类型声明
│   ├── utils/               # 工具函数库
│   │   ├── request.ts       # Axios 请求封装
│   │   ├── auth.ts          # 认证工具
│   │   ├── validate.ts      # 验证工具
│   │   ├── format.ts        # 格式化工具
│   │   ├── date.ts          # 日期工具
│   │   ├── common.ts        # 通用工具
│   │   └── index.ts         # 工具导出
│   ├── views/               # 页面视图组件
│   │   ├── auth/            # 认证相关页面
│   │   │   ├── Login.vue    # 登录页面
│   │   │   └── Redirect.vue # 重定向页面
│   │   ├── dashboard/       # 仪表盘页面
│   │   │   └── index.vue    # 仪表盘首页
│   │   ├── error/           # 错误页面
│   │   │   ├── 404.vue      # 404页面
│   │   │   └── 403.vue      # 403页面
│   │   ├── user/            # 用户管理页面
│   │   │   ├── index.vue    # 用户列表
│   │   │   └── detail.vue   # 用户详情
│   │   ├── system/          # 系统管理页面
│   │   │   ├── menu/        # 菜单管理
│   │   │   ├── role/        # 角色管理
│   │   │   ├── department/  # 部门管理
│   │   │   ├── dict/        # 字典管理
│   │   │   └── api/         # API管理
│   │   └── profile/         # 个人中心
│   │       └── index.vue    # 个人中心页面
│   ├── main.ts              # 应用入口
│   ├── App.vue              # 根组件
│   └── vite-env.d.ts        # 类型声明
├── build/                   # Vite 构建相关配置
│   ├── plugins/             # 构建插件
│   │   ├── compress.ts      # 压缩插件
│   │   ├── visualizer.ts    # 打包分析插件
│   │   └── index.ts         # 插件导出
│   ├── utils/               # 构建工具函数
│   │   ├── proxy.ts         # 代理配置
│   │   └── index.ts         # 工具导出
│   └── index.ts             # 构建配置
├── .husky/                  # Git 提交钩子
│   ├── _/                   # Husky 内部文件
│   ├── commit-msg           # 提交信息检查
│   └── pre-commit           # 提交前检查
├── .vscode/                 # 推荐编辑器配置
│   ├── extensions.json      # 推荐插件
│   └── settings.json        # 编辑器设置
├── env 文件系列             # 环境变量配置
│   ├── .env                 # 默认环境变量
│   ├── .env.development     # 开发环境变量
│   ├── .env.test            # 测试环境变量
│   └── .env.production      # 生产环境变量
├── 各类 lint 配置文件       # ESLint, Prettier, Stylelint, commitlint 等
│   ├── .eslintrc.js         # ESLint 配置
│   ├── .eslintignore        # ESLint 忽略文件
│   ├── .prettierrc.js       # Prettier 配置
│   ├── .prettierignore      # Prettier 忽略文件
│   ├── .stylelintrc.js      # Stylelint 配置
│   ├── .stylelintignore     # Stylelint 忽略文件
│   ├── commitlint.config.js # Commitlint 配置
│   └── .editorconfig        # 编辑器配置
├── index.html               # HTML 模板
├── package.json             # 项目依赖和脚本
├── pnpm-lock.yaml           # 依赖锁定文件
├── tsconfig.json            # TypeScript 配置
├── tsconfig.node.json       # Node.js TypeScript 配置
├── vite.config.ts           # Vite 配置
└── README.md                # 项目说明
```

### 目录说明

#### public

静态资源目录，存放不参与打包的静态资源，如网站图标、Logo等。

#### src

源代码目录，包含项目的所有源代码。

##### api

所有接口请求定义，按模块分类。每个模块对应一个文件，统一导出。

##### assets

图片、字体等静态资源目录，存放项目中使用的图片、字体等资源。

##### components

全局通用组件目录，包含项目中使用的所有通用组件。

- **common**: 通用组件，如图标、表格、表单等。
- **layout**: 布局组件，如头部、侧边栏、底部等。
- **business**: 业务组件，如用户选择、字典选择等。

##### config

全局常量配置目录，包含项目的全局配置。

##### directives

自定义指令目录，包含项目中使用的所有自定义指令。

##### globals

全局挂载函数或属性目录，包含需要全局挂载的函数或属性。

##### hooks

Composition API 封装目录，包含项目中使用的所有钩子函数。

##### lang

多语言配置目录，包含项目的多语言配置。

##### layout

主布局组件目录，包含项目的主布局组件。

##### mock

本地 Mock 数据服务目录，包含项目的 Mock 数据。

##### router

路由配置目录，包含项目的路由配置。

##### store

Pinia 状态管理目录，包含项目的状态管理。

##### style

全局样式与 SCSS 变量目录，包含项目的全局样式。

##### typings

TypeScript 类型声明扩展目录，包含项目的类型声明。

##### utils

工具函数库目录，包含项目中使用的所有工具函数。

##### views

页面视图组件目录，包含项目的所有页面组件。

#### build

Vite 构建相关配置目录，包含项目的构建配置。

#### .husky

Git 提交钩子目录，包含项目的 Git 提交钩子。

#### .vscode

推荐编辑器配置目录，包含项目的编辑器配置。

#### env 文件系列

环境变量配置文件，包含项目的环境变量配置。

#### 各类 lint 配置文件

ESLint, Prettier, Stylelint, commitlint 等配置文件，包含项目的代码规范配置。

### 文件说明

#### index.html

HTML 模板文件，是项目的入口 HTML 文件。

#### package.json

项目依赖和脚本文件，包含项目的依赖和脚本。

#### pnpm-lock.yaml

依赖锁定文件，确保依赖版本的一致性。

#### tsconfig.json

TypeScript 配置文件，包含 TypeScript 的配置。

#### tsconfig.node.json

Node.js TypeScript 配置文件，包含 Node.js 环境的 TypeScript 配置。

#### vite.config.ts

Vite 配置文件，包含 Vite 的配置。

#### README.md

项目说明文件，包含项目的说明。

### 模块说明

#### 认证模块

认证模块包含登录、退出登录、刷新令牌等功能，主要文件包括：

- `src/api/auth.ts`: 认证相关接口
- `src/views/auth/`: 认证相关页面
- `src/store/modules/user.ts`: 用户状态管理
- `src/hooks/useAuth.ts`: 认证相关钩子

#### 用户模块

用户模块包含用户管理、用户详情等功能，主要文件包括：

- `src/api/user.ts`: 用户相关接口
- `src/views/user/`: 用户管理页面
- `src/components/business/UserSelect/`: 用户选择组件
- `src/hooks/useUser.ts`: 用户相关钩子

#### 系统管理模块

系统管理模块包含菜单管理、角色管理、部门管理、字典管理、API管理等功能，主要文件包括：

- `src/api/system.ts`: 系统管理相关接口
- `src/views/system/`: 系统管理页面
- `src/components/business/DictSelect/`: 字典选择组件
- `src/store/modules/permission.ts`: 权限状态管理

#### 工具模块

工具模块包含请求封装、认证工具、验证工具、格式化工具、日期工具、通用工具等，主要文件包括：

- `src/utils/request.ts`: Axios 请求封装
- `src/utils/auth.ts`: 认证工具
- `src/utils/validate.ts`: 验证工具
- `src/utils/format.ts`: 格式化工具
- `src/utils/date.ts`: 日期工具
- `src/utils/common.ts`: 通用工具

#### 布局模块

布局模块包含主布局、头部、侧边栏、标签页等，主要文件包括：

- `src/layout/`: 主布局组件
- `src/components/layout/`: 布局子组件
- `src/store/modules/settings.ts`: 设置状态管理
- `src/store/modules/tagsView.ts`: 标签页状态管理

#### 国际化模块

国际化模块包含多语言配置，主要文件包括：

- `src/lang/`: 多语言配置
- `src/store/modules/settings.ts`: 设置状态管理

#### 权限模块

权限模块包含路由权限、按钮权限等，主要文件包括：

- `src/router/guards.ts`: 路由守卫
- `src/directives/permission/`: 权限指令
- `src/store/modules/permission.ts`: 权限状态管理

#### Mock 模块

Mock 模块包含本地 Mock 数据服务，主要文件包括：

- `src/mock/`: 本地 Mock 数据服务
- `build/utils/proxy.ts`: 代理配置

### 总结

GinFast 前端项目采用模块化架构设计，各个模块职责明确，便于开发和维护。通过合理的目录结构和文件组织，使得项目具有良好的可读性和可扩展性。