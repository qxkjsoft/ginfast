## 常见问题

目录

- 开发环境问题
- 后端问题
- 前端问题
- 部署问题
- 数据库问题
- 权限问题
- 性能问题
- 其他问题

### 开发环境问题

#### 1. Go 版本不兼容

**问题**：编译时提示 Go 版本不兼容。

**解决方案**：
1. 检查项目要求的 Go 版本
2. 升级或降级 Go 版本

```bash
# 检查 Go 版本
go version

# 使用 gvm 管理 Go 版本
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source ~/.gvm/scripts/gvm

# 安装指定版本的 Go
gvm install go1.20.5
gvm use go1.20.5 --default
```

#### 2. Node.js 版本不兼容

**问题**：安装依赖时提示 Node.js 版本不兼容。

**解决方案**：
1. 检查项目要求的 Node.js 版本
2. 升级或降级 Node.js 版本

```bash
# 检查 Node.js 版本
node -v

# 使用 nvm 管理 Node.js 版本
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc

# 安装指定版本的 Node.js
nvm install 20.12.0
nvm use 20.12.0
nvm alias default 20.12.0
```

#### 3. pnpm 安装失败

**问题**：安装 pnpm 时失败。

**解决方案**：
1. 清除 npm 缓存
2. 使用镜像源安装

```bash
# 清除 npm 缓存
npm cache clean --force

# 使用镜像源安装 pnpm
npm install -g pnpm --registry=https://registry.npmmirror.com
```

#### 4. 依赖安装失败

**问题**：安装依赖时失败。

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

### 后端问题

#### 1. 数据库连接失败

**问题**：启动后端服务时提示数据库连接失败。

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

#### 2. Redis 连接失败

**问题**：启动后端服务时提示 Redis 连接失败。

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

#### 3. 端口被占用

**问题**：启动后端服务时提示端口被占用。

**解决方案**：
1. 查找占用端口的进程
2. 终止占用端口的进程
3. 修改配置文件中的端口

```bash
# 查找占用端口的进程
netstat -tunlp | grep 8080
lsof -i:8080

# 终止占用端口的进程
kill -9 <PID>
```

#### 4. JWT 签名失败

**问题**：生成 JWT 时提示签名失败。

**解决方案**：
1. 检查 JWT 密钥是否正确
2. 检查 JWT 密钥长度是否足够
3. 重新生成 JWT 密钥

```go
// 生成随机密钥
package main

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
)

func generateRandomKey(length int) (string, error) {
	bytes := make([]byte, length)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

func main() {
	key, err := generateRandomKey(32)
	if err != nil {
		fmt.Println("Error generating key:", err)
		return
	}
	fmt.Println("Generated key:", key)
}
```

### 前端问题

#### 1. TypeScript 类型错误

**问题**：编译时提示 TypeScript 类型错误。

**解决方案**：
1. 检查类型定义是否正确
2. 使用类型断言或类型守卫
3. 更新类型定义文件

```typescript
// 类型断言
const element = document.getElementById('my-element') as HTMLInputElement;

// 类型守卫
function isString(value: any): value is string {
  return typeof value === 'string';
}

if (isString(value)) {
  // 在这里 value 被认为是 string 类型
}
```

#### 2. 样式冲突

**问题**：组件样式被全局样式覆盖。

**解决方案**：
1. 使用 scoped 样式
2. 使用 CSS Modules
3. 使用 BEM 命名规范

```vue
<template>
  <div class="my-component">
    <!-- 组件内容 -->
  </div>
</template>

<style lang="scss" scoped>
// 使用 scoped 样式
.my-component {
  // 组件样式
}
</style>
```

#### 3. 路由跳转失败

**问题**：路由跳转时提示找不到路由。

**解决方案**：
1. 检查路由配置是否正确
2. 检查路由名称是否正确
3. 检查路由权限是否正确

```typescript
// 检查路由配置
const routes = [
  {
    path: '/user',
    name: 'User',
    component: () => import('@/views/user/index.vue')
  }
];

// 检查路由跳转
router.push({ name: 'User' });
```

#### 4. API 请求失败

**问题**：API 请求时提示网络错误或跨域错误。

**解决方案**：
1. 检查 API 地址是否正确
2. 检查请求头是否正确
3. 检查跨域配置是否正确

```typescript
// 检查 API 请求
import request from '@/utils/request';

export function getUserList(params: any) {
  return request({
    url: '/api/users/list',
    method: 'get',
    params
  });
}
```

### 部署问题

#### 1. 后端服务启动失败

**问题**：部署后后端服务启动失败。

**解决方案**：
1. 检查配置文件是否正确
2. 检查日志文件中的错误信息
3. 检查环境变量是否正确

```bash
# 检查服务状态
systemctl status gin-fast

# 查看日志
journalctl -u gin-fast -f
```

#### 2. 前端页面访问 404

**问题**：部署后前端页面刷新后出现 404 错误。

**解决方案**：
1. 检查 Nginx 配置中的 `try_files` 指令是否正确
2. 确保 `try_files $uri $uri/ /index.html;` 配置正确

```nginx
location / {
    root /var/www/snow-admin;
    index index.html;
    try_files $uri $uri/ /index.html;
}
```

#### 3. 前端请求后端 API 失败

**问题**：部署后前端请求后端 API 失败。

**解决方案**：
1. 检查 Nginx 配置中的 API 代理是否正确
2. 检查后端服务是否正常运行
3. 检查防火墙是否阻止了 API 请求

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

**问题**：Docker 容器启动失败。

**解决方案**：
1. 检查 Dockerfile 是否正确
2. 检查 docker-compose.yml 是否正确
3. 查看容器日志

```bash
# 查看容器状态
docker-compose ps

# 查看容器日志
docker-compose logs -f
```

### 数据库问题

#### 1. 数据库连接超时

**问题**：数据库连接超时。

**解决方案**：
1. 检查数据库服务是否正常运行
2. 检查数据库连接池配置
3. 检查网络连接是否正常

```yaml
# 检查数据库连接池配置
database:
  max_idle_conns: 10
  max_open_conns: 100
  conn_max_lifetime: 3600
```

#### 2. 数据库表不存在

**问题**：启动后端服务时提示数据库表不存在。

**解决方案**：
1. 检查数据库是否已初始化
2. 检查数据库迁移是否已执行
3. 手动导入数据库结构

```bash
# 导入数据库结构
mysql -u gin_fast -p gin_fast < resource/gin-fast.sql
```

#### 3. 数据库字符集问题

**问题**：插入中文数据时提示字符集错误。

**解决方案**：
1. 检查数据库字符集是否为 utf8mb4
2. 检查表字符集是否为 utf8mb4
3. 检查连接字符集是否为 utf8mb4

```sql
-- 检查数据库字符集
SHOW VARIABLES LIKE 'character_set_database';

-- 修改数据库字符集
ALTER DATABASE gin_fast CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 修改表字符集
ALTER TABLE table_name CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 权限问题

#### 1. 权限不足

**问题**：访问页面或接口时提示权限不足。

**解决方案**：
1. 检查用户角色是否正确
2. 检查角色权限是否正确
3. 检查菜单权限是否正确

```typescript
// 检查用户角色
const userStore = useUserStore();
console.log(userStore.roles);

// 检查角色权限
const permissionStore = usePermissionStore();
console.log(permissionStore.permissionRoutes);
```

#### 2. 动态路由不生效

**问题**：动态路由不生效。

**解决方案**：
1. 检查路由守卫是否正确
2. 检查路由生成是否正确
3. 检查路由添加是否正确

```typescript
// 检查路由守卫
router.beforeEach(async (to, from, next) => {
  // 路由守卫逻辑
});

// 检查路由生成
const accessRoutes = await permissionStore.generateRoutes(userStore.roles);

// 检查路由添加
accessRoutes.forEach(route => {
  router.addRoute(route);
});
```

#### 3. 按钮权限不生效

**问题**：按钮权限不生效。

**解决方案**：
1. 检查权限指令是否正确
2. 检查用户权限是否正确
3. 检查按钮权限配置是否正确

```vue
<template>
  <div>
    <!-- 检查权限指令 -->
    <a-button v-permission="['admin']" type="primary">管理员按钮</a-button>
  </div>
</template>
```

### 性能问题

#### 1. 页面加载慢

**问题**：页面加载慢。

**解决方案**：
1. 启用路由懒加载
2. 启用组件懒加载
3. 启用图片懒加载
4. 启用代码分割

```typescript
// 路由懒加载
const routes = [
  {
    path: '/user',
    name: 'User',
    component: () => import('@/views/user/index.vue')
  }
];

// 组件懒加载
const AsyncComponent = defineAsyncComponent(() => import('@/components/AsyncComponent.vue'));
```

#### 2. API 请求慢

**问题**：API 请求慢。

**解决方案**：
1. 启用 API 缓存
2. 启用数据分页
3. 优化数据库查询
4. 启用 CDN 加速

```typescript
// 启用 API 缓存
import { useStorage } from '@vueuse/core';

const cachedData = useStorage('cachedData', {});

export async function getUserList(params: any) {
  const cacheKey = JSON.stringify(params);
  
  if (cachedData.value[cacheKey]) {
    return cachedData.value[cacheKey];
  }
  
  const res = await request({
    url: '/api/users/list',
    method: 'get',
    params
  });
  
  cachedData.value[cacheKey] = res;
  return res;
}
```

#### 3. 内存泄漏

**问题**：页面切换后内存不释放。

**解决方案**：
1. 在组件销毁时清除定时器
2. 在组件销毁时清除事件监听
3. 在组件销毁时清除订阅

```vue
<script setup lang="ts">
import { onBeforeUnmount } from 'vue';

// 定时器
const timer = setInterval(() => {
  // 定时器逻辑
}, 1000);

// 事件监听
const handleResize = () => {
  // 事件处理逻辑
};
window.addEventListener('resize', handleResize);

// 组件销毁前清除
onBeforeUnmount(() => {
  clearInterval(timer);
  window.removeEventListener('resize', handleResize);
});
</script>
```

### 其他问题

#### 1. 验证码不显示

**问题**：登录页面验证码不显示。

**解决方案**：
1. 检查验证码配置是否正确
2. 检查验证码接口是否正常
3. 检查验证码图片路径是否正确

```yaml
# 检查验证码配置
captcha:
  enabled: true
  length: 4
  width: 130
  height: 30
```

#### 2. 文件上传失败

**问题**：文件上传失败。

**解决方案**：
1. 检查上传目录是否存在
2. 检查上传目录权限是否正确
3. 检查文件大小限制是否正确

```bash
# 创建上传目录
mkdir -p public/uploads

# 设置权限
chmod 755 public/uploads
```

#### 3. 国际化不生效

**问题**：切换语言后页面内容不更新。

**解决方案**：
1. 检查语言包是否正确
2. 检查语言切换逻辑是否正确
3. 检查语言存储是否正确

```typescript
// 检查语言切换逻辑
const { locale } = useI18n();

const changeLanguage = () => {
  locale.value = locale.value === 'zh-CN' ? 'en-US' : 'zh-CN';
  localStorage.setItem('language', locale.value);
};
```

#### 4. 主题切换不生效

**问题**：切换主题后页面样式不更新。

**解决方案**：
1. 检查主题配置是否正确
2. 检查主题切换逻辑是否正确
3. 检查主题样式是否正确

```typescript
// 检查主题切换逻辑
const settingsStore = useSettingsStore();

const toggleTheme = () => {
  settingsStore.toggleTheme();
};
```

### 总结

以上是 Gin-Fast 系统开发和使用过程中常见的问题及解决方案。如果您遇到其他问题，请参考相关文档或提交 Issue。