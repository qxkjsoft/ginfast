## 前端开发指南

目录

- 开发流程
- 组件开发
- 页面开发
- API 调用
- 状态管理
- 路由配置
- 权限控制
- 国际化
- 主题定制
- 构建部署

### 开发流程

#### 1. 克隆项目

```bash
git clone https://github.com/qxkjsoft/ginfast-front.git
cd ginfast-front
```

#### 2. 安装依赖

```bash
pnpm install
```

#### 3. 启动开发服务器

```bash
pnpm run dev
```

#### 4. 开发新功能

1. 创建分支
2. 开发功能
3. 提交代码
4. 创建 PR
5. 代码审查
6. 合并代码

#### 5. 提交规范

提交信息格式：

```
<type>(<scope>): <subject>

<body>

<footer>
```

Type 类型：

- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档更新
- `style`: 代码格式（不影响代码运行的变动）
- `refactor`: 重构（既不是新增功能，也不是修改bug的代码变动）
- `perf`: 性能优化
- `test`: 增加测试
- `chore`: 构建过程或辅助工具的变动

### 组件开发

#### 1. 组件命名规范

- 组件名使用 PascalCase 命名
- 组件文件名使用 kebab-case 命名
- 组件目录名使用 kebab-case 命名

#### 2. 组件结构

```vue
<template>
  <!-- 组件模板 -->
</template>

<script setup lang="ts">
// 组件逻辑
</script>

<style lang="scss" scoped>
// 组件样式
</style>
```

#### 3. 组件属性

```typescript
// 定义属性
interface Props {
  title: string;
  visible?: boolean;
  type?: 'primary' | 'success' | 'warning' | 'danger';
}

// 定义属性默认值
const props = withDefaults(defineProps<Props>(), {
  visible: false,
  type: 'primary'
});

// 定义事件
const emit = defineEmits<{
  (e: 'update:visible', visible: boolean): void;
  (e: 'confirm'): void;
  (e: 'cancel'): void;
}>();
```

#### 4. 组件插槽

```vue
<template>
  <div class="component">
    <!-- 默认插槽 -->
    <slot></slot>
    
    <!-- 具名插槽 -->
    <slot name="header"></slot>
    
    <!-- 作用域插槽 -->
    <slot name="footer" :text="footerText"></slot>
  </div>
</template>
```

#### 5. 组件示例

```vue
<template>
  <div class="my-button" :class="`my-button--${type}`" @click="handleClick">
    <slot></slot>
  </div>
</template>

<script setup lang="ts">
interface Props {
  type?: 'primary' | 'success' | 'warning' | 'danger';
}

const props = withDefaults(defineProps<Props>(), {
  type: 'primary'
});

const emit = defineEmits<{
  (e: 'click'): void;
}>();

const handleClick = () => {
  emit('click');
};
</script>

<style lang="scss" scoped>
.my-button {
  display: inline-block;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
  
  &--primary {
    background-color: #1890ff;
    color: #fff;
  }
  
  &--success {
    background-color: #52c41a;
    color: #fff;
  }
  
  &--warning {
    background-color: #faad14;
    color: #fff;
  }
  
  &--danger {
    background-color: #f5222d;
    color: #fff;
  }
}
</style>
```

### 页面开发

#### 1. 页面结构

```vue
<template>
  <div class="page-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <h1 class="page-title">页面标题</h1>
      <div class="page-actions">
        <a-button type="primary" @click="handleAdd">新增</a-button>
      </div>
    </div>
    
    <!-- 页面内容 -->
    <div class="page-content">
      <!-- 搜索表单 -->
      <a-form :model="searchForm" layout="inline">
        <a-form-item label="名称">
          <a-input v-model:value="searchForm.name" placeholder="请输入名称" />
        </a-form-item>
        <a-form-item>
          <a-button type="primary" @click="handleSearch">查询</a-button>
          <a-button @click="handleReset">重置</a-button>
        </a-form-item>
      </a-form>
      
      <!-- 数据表格 -->
      <a-table
        :columns="columns"
        :data-source="tableData"
        :loading="loading"
        :pagination="pagination"
        @change="handleTableChange"
      >
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'action'">
            <a-space>
              <a-button type="link" @click="handleEdit(record)">编辑</a-button>
              <a-button type="link" danger @click="handleDelete(record)">删除</a-button>
            </a-space>
          </template>
        </template>
      </a-table>
    </div>
    
    <!-- 新增/编辑弹窗 -->
    <a-modal
      v-model:visible="modalVisible"
      :title="modalTitle"
      @ok="handleModalOk"
      @cancel="handleModalCancel"
    >
      <a-form :model="form" :rules="rules" ref="formRef">
        <a-form-item label="名称" name="name">
          <a-input v-model:value="form.name" placeholder="请输入名称" />
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import type { FormInstance, TableProps } from 'ant-design-vue';

// 搜索表单
const searchForm = reactive({
  name: ''
});

// 表格数据
const tableData = ref([]);
const loading = ref(false);
const pagination = reactive({
  current: 1,
  pageSize: 10,
  total: 0,
  showSizeChanger: true,
  showQuickJumper: true
});

// 表格列
const columns = [
  {
    title: 'ID',
    dataIndex: 'id',
    key: 'id'
  },
  {
    title: '名称',
    dataIndex: 'name',
    key: 'name'
  },
  {
    title: '创建时间',
    dataIndex: 'createdAt',
    key: 'createdAt'
  },
  {
    title: '操作',
    key: 'action',
    width: 150
  }
];

// 弹窗
const modalVisible = ref(false);
const modalTitle = ref('新增');
const formRef = ref<FormInstance>();
const form = reactive({
  id: undefined,
  name: ''
});
const rules = {
  name: [{ required: true, message: '请输入名称', trigger: 'blur' }]
};

// 获取表格数据
const getTableData = async () => {
  loading.value = true;
  try {
    // 调用API获取数据
    // const res = await api.getList({
    //   page: pagination.current,
    //   pageSize: pagination.pageSize,
    //   ...searchForm
    // });
    // tableData.value = res.data.list;
    // pagination.total = res.data.total;
    
    // 模拟数据
    tableData.value = [
      { id: 1, name: '测试1', createdAt: '2023-01-01' },
      { id: 2, name: '测试2', createdAt: '2023-01-02' }
    ];
    pagination.total = 2;
  } catch (error) {
    console.error(error);
  } finally {
    loading.value = false;
  }
};

// 搜索
const handleSearch = () => {
  pagination.current = 1;
  getTableData();
};

// 重置
const handleReset = () => {
  searchForm.name = '';
  handleSearch();
};

// 表格变化
const handleTableChange = (pag: any) => {
  pagination.current = pag.current;
  pagination.pageSize = pag.pageSize;
  getTableData();
};

// 新增
const handleAdd = () => {
  modalTitle.value = '新增';
  form.id = undefined;
  form.name = '';
  modalVisible.value = true;
};

// 编辑
const handleEdit = (record: any) => {
  modalTitle.value = '编辑';
  form.id = record.id;
  form.name = record.name;
  modalVisible.value = true;
};

// 删除
const handleDelete = (record: any) => {
  Modal.confirm({
    title: '确认删除',
    content: '确定要删除这条数据吗？',
    onOk: async () => {
      try {
        // 调用API删除数据
        // await api.delete(record.id);
        message.success('删除成功');
        getTableData();
      } catch (error) {
        console.error(error);
      }
    }
  });
};

// 弹窗确认
const handleModalOk = async () => {
  try {
    await formRef.value?.validate();
    // 调用API保存数据
    // if (form.id) {
    //   await api.update(form);
    //   message.success('更新成功');
    // } else {
    //   await api.add(form);
    //   message.success('新增成功');
    // }
    modalVisible.value = false;
    getTableData();
  } catch (error) {
    console.error(error);
  }
};

// 弹窗取消
const handleModalCancel = () => {
  modalVisible.value = false;
};

// 初始化
onMounted(() => {
  getTableData();
});
</script>

<style lang="scss" scoped>
.page-container {
  padding: 16px;
  
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    
    .page-title {
      margin: 0;
      font-size: 20px;
      font-weight: 500;
    }
  }
  
  .page-content {
    background-color: #fff;
    padding: 16px;
    border-radius: 4px;
  }
}
</style>
```

### API 调用

#### 1. API 封装

```typescript
// src/utils/request.ts
import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse } from 'axios';
import { useUserStore } from '@/store/modules/user';
import { message } from 'ant-design-vue';

// 创建axios实例
const service: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_APP_BASE_API,
  timeout: 10000
});

// 请求拦截器
service.interceptors.request.use(
  (config: AxiosRequestConfig) => {
    const userStore = useUserStore();
    if (userStore.token) {
      config.headers = config.headers || {};
      config.headers['Authorization'] = `Bearer ${userStore.token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// 响应拦截器
service.interceptors.response.use(
  (response: AxiosResponse) => {
    const res = response.data;
    
    // 如果返回的状态码不是0，说明接口请求失败
    if (res.code !== 0) {
      message.error(res.msg || '请求失败');
      
      // 401: 未登录或token过期
      if (res.code === 401) {
        const userStore = useUserStore();
        userStore.resetToken();
        window.location.reload();
      }
      
      return Promise.reject(new Error(res.msg || '请求失败'));
    } else {
      return res;
    }
  },
  (error) => {
    message.error(error.message || '请求失败');
    return Promise.reject(error);
  }
);

export default service;
```

#### 2. API 定义

```typescript
// src/api/user.ts
import request from '@/utils/request';
import type { User, UserListParams } from '@/typings/api';

// 获取用户列表
export function getUserList(params: UserListParams) {
  return request({
    url: '/api/users/list',
    method: 'get',
    params
  });
}

// 新增用户
export function addUser(data: Partial<User>) {
  return request({
    url: '/api/users/add',
    method: 'post',
    data
  });
}

// 更新用户
export function updateUser(data: Partial<User>) {
  return request({
    url: '/api/users/edit',
    method: 'put',
    data
  });
}

// 删除用户
export function deleteUser(ids: number[]) {
  return request({
    url: '/api/users/delete',
    method: 'delete',
    data: { ids }
  });
}

// 获取用户详情
export function getUserDetail(id: number) {
  return request({
    url: `/api/users/detail`,
    method: 'get',
    params: { id }
  });
}

// 修改密码
export function changePassword(data: { userId: number; oldPassword: string; newPassword: string }) {
  return request({
    url: '/api/users/changePassword',
    method: 'put',
    data
  });
}

// 重置密码
export function resetPassword(data: { userId: number; newPassword: string }) {
  return request({
    url: '/api/users/resetPassword',
    method: 'put',
    data
  });
}
```

#### 3. API 调用

```typescript
// 在组件中调用API
import { getUserList, addUser, updateUser, deleteUser } from '@/api/user';
import { ref, reactive, onMounted } from 'vue';
import { message } from 'ant-design-vue';

// 获取用户列表
const getUserListData = async () => {
  loading.value = true;
  try {
    const res = await getUserList({
      page: pagination.current,
      pageSize: pagination.pageSize,
      ...searchForm
    });
    tableData.value = res.data.list;
    pagination.total = res.data.total;
  } catch (error) {
    console.error(error);
  } finally {
    loading.value = false;
  }
};

// 新增用户
const handleAddUser = async () => {
  try {
    await formRef.value?.validate();
    await addUser(form);
    message.success('新增成功');
    modalVisible.value = false;
    getUserListData();
  } catch (error) {
    console.error(error);
  }
};

// 更新用户
const handleUpdateUser = async () => {
  try {
    await formRef.value?.validate();
    await updateUser(form);
    message.success('更新成功');
    modalVisible.value = false;
    getUserListData();
  } catch (error) {
    console.error(error);
  }
};

// 删除用户
const handleDeleteUser = async (record: any) => {
  Modal.confirm({
    title: '确认删除',
    content: '确定要删除这条数据吗？',
    onOk: async () => {
      try {
        await deleteUser([record.id]);
        message.success('删除成功');
        getUserListData();
      } catch (error) {
        console.error(error);
      }
    }
  });
};
```

### 状态管理

#### 1. Pinia 状态管理

```typescript
// src/store/modules/user.ts
import { defineStore } from 'pinia';
import { login, logout, getUserInfo, refreshToken } from '@/api/auth';
import { getToken, setToken, removeToken } from '@/utils/auth';
import type { UserInfo } from '@/typings/api';

interface UserState {
  token: string;
  refreshToken: string;
  userInfo: UserInfo | null;
  roles: string[];
  permissions: string[];
}

export const useUserStore = defineStore('user', {
  state: (): UserState => ({
    token: getToken() || '',
    refreshToken: '',
    userInfo: null,
    roles: [],
    permissions: []
  }),
  
  getters: {
    isLogin: (state) => !!state.token,
    username: (state) => state.userInfo?.username || '',
    nickname: (state) => state.userInfo?.nickname || '',
    avatar: (state) => state.userInfo?.avatar || '',
    email: (state) => state.userInfo?.email || '',
    isAdmin: (state) => state.roles.includes('admin')
  },
  
  actions: {
    // 登录
    async login(userInfo: { username: string; password: string; captchaId: string; captcha: string }) {
      try {
        const res = await login(userInfo);
        this.token = res.data.accessToken;
        this.refreshToken = res.data.refreshToken;
        setToken(this.token);
        return Promise.resolve();
      } catch (error) {
        return Promise.reject(error);
      }
    },
    
    // 获取用户信息
    async getUserInfo() {
      try {
        const res = await getUserInfo();
        this.userInfo = res.data.userInfo;
        this.roles = res.data.roles.map((role: any) => role.roleKey);
        this.permissions = res.data.permissions;
        return Promise.resolve();
      } catch (error) {
        return Promise.reject(error);
      }
    },
    
    // 刷新令牌
    async refreshToken() {
      try {
        const res = await refreshToken({ refreshToken: this.refreshToken });
        this.token = res.data.accessToken;
        setToken(this.token);
        return Promise.resolve();
      } catch (error) {
        return Promise.reject(error);
      }
    },
    
    // 退出登录
    async logout() {
      try {
        await logout();
        this.resetToken();
        return Promise.resolve();
      } catch (error) {
        return Promise.reject(error);
      }
    },
    
    // 重置令牌
    resetToken() {
      this.token = '';
      this.refreshToken = '';
      this.userInfo = null;
      this.roles = [];
      this.permissions = [];
      removeToken();
    }
  },
  
  persist: {
    enabled: true,
    strategies: [
      {
        key: 'user',
        storage: localStorage,
        paths: ['token', 'refreshToken']
      }
    ]
  }
});
```

#### 2. 使用状态

```typescript
// 在组件中使用状态
import { useUserStore } from '@/store/modules/user';

const userStore = useUserStore();

// 获取用户信息
const username = computed(() => userStore.username);
const nickname = computed(() => userStore.nickname);
const avatar = computed(() => userStore.avatar);
const isLogin = computed(() => userStore.isLogin);
const isAdmin = computed(() => userStore.isAdmin);

// 调用状态方法
const handleLogin = async () => {
  try {
    await userStore.login({
      username: 'admin',
      password: '123456',
      captchaId: 'captcha-id',
      captcha: '1234'
    });
    await userStore.getUserInfo();
    router.push('/');
  } catch (error) {
    console.error(error);
  }
};

const handleLogout = async () => {
  try {
    await userStore.logout();
    router.push('/login');
  } catch (error) {
    console.error(error);
  }
};
```

### 路由配置

#### 1. 路由定义

```typescript
// src/router/modules/system.ts
import type { RouteRecordRaw } from 'vue-router';

const systemRoutes: RouteRecordRaw[] = [
  {
    path: '/system',
    name: 'System',
    component: () => import('@/layout/index.vue'),
    meta: {
      title: '系统管理',
      icon: 'system',
      roles: ['admin']
    },
    children: [
      {
        path: 'user',
        name: 'User',
        component: () => import('@/views/user/index.vue'),
        meta: {
          title: '用户管理',
          icon: 'user',
          roles: ['admin'],
          keepAlive: true
        }
      },
      {
        path: 'role',
        name: 'Role',
        component: () => import('@/views/system/role/index.vue'),
        meta: {
          title: '角色管理',
          icon: 'role',
          roles: ['admin'],
          keepAlive: true
        }
      },
      {
        path: 'menu',
        name: 'Menu',
        component: () => import('@/views/system/menu/index.vue'),
        meta: {
          title: '菜单管理',
          icon: 'menu',
          roles: ['admin'],
          keepAlive: true
        }
      },
      {
        path: 'department',
        name: 'Department',
        component: () => import('@/views/system/department/index.vue'),
        meta: {
          title: '部门管理',
          icon: 'department',
          roles: ['admin'],
          keepAlive: true
        }
      },
      {
        path: 'dict',
        name: 'Dict',
        component: () => import('@/views/system/dict/index.vue'),
        meta: {
          title: '字典管理',
          icon: 'dict',
          roles: ['admin'],
          keepAlive: true
        }
      },
      {
        path: 'api',
        name: 'Api',
        component: () => import('@/views/system/api/index.vue'),
        meta: {
          title: 'API管理',
          icon: 'api',
          roles: ['admin'],
          keepAlive: true
        }
      }
    ]
  }
];

export default systemRoutes;
```

#### 2. 路由守卫

```typescript
// src/router/guards.ts
import router from '@/router';
import { useUserStore } from '@/store/modules/user';
import { usePermissionStore } from '@/store/modules/permission';
import NProgress from 'nprogress';
import 'nprogress/nprogress.css';

NProgress.configure({ showSpinner: false });

// 白名单路由
const whiteList = ['/login', '/auth-redirect'];

router.beforeEach(async (to, from, next) => {
  NProgress.start();
  
  const userStore = useUserStore();
  const permissionStore = usePermissionStore();
  
  // 已登录
  if (userStore.token) {
    if (to.path === '/login') {
      next({ path: '/' });
      NProgress.done();
    } else {
      // 判断是否已获取用户信息
      if (userStore.roles.length === 0) {
        try {
          // 获取用户信息
          await userStore.getUserInfo();
          
          // 根据角色生成可访问路由表
          const accessRoutes = await permissionStore.generateRoutes(userStore.roles);
          
          // 动态添加可访问路由
          accessRoutes.forEach(route => {
            router.addRoute(route);
          });
          
          // 设置replace: true，以便不会留下历史记录
          next({ ...to, replace: true });
        } catch (error) {
          // 移除token并跳转登录页
          await userStore.resetToken();
          next(`/login?redirect=${to.path}`);
          NProgress.done();
        }
      } else {
        next();
      }
    }
  } else {
    // 未登录
    if (whiteList.includes(to.path)) {
      next();
    } else {
      next(`/login?redirect=${to.path}`);
      NProgress.done();
    }
  }
});

router.afterEach(() => {
  NProgress.done();
});
```

### 权限控制

#### 1. 路由权限

```typescript
// src/store/modules/permission.ts
import { defineStore } from 'pinia';
import { asyncRoutes, constantRoutes } from '@/router';
import type { RouteRecordRaw } from 'vue-router';

/**
 * 使用meta.roles判断当前用户是否有权限
 * @param roles
 * @param route
 */
function hasPermission(roles: string[], route: RouteRecordRaw) {
  if (route.meta && route.meta.roles) {
    return roles.some(role => route.meta?.roles?.includes(role));
  } else {
    return true;
  }
}

/**
 * 通过递归过滤异步路由表
 * @param routes asyncRoutes
 * @param roles
 */
function filterAsyncRoutes(routes: RouteRecordRaw[], roles: string[]) {
  const res: RouteRecordRaw[] = [];
  
  routes.forEach(route => {
    const tmp = { ...route };
    if (hasPermission(roles, tmp)) {
      if (tmp.children) {
        tmp.children = filterAsyncRoutes(tmp.children, roles);
      }
      res.push(tmp);
    }
  });
  
  return res;
}

interface PermissionState {
  routes: RouteRecordRaw[];
  addRoutes: RouteRecordRaw[];
}

export const usePermissionStore = defineStore('permission', {
  state: (): PermissionState => ({
    routes: [],
    addRoutes: []
  }),
  
  getters: {
    permissionRoutes: (state) => state.routes
  },
  
  actions: {
    // 生成路由
    async generateRoutes(roles: string[]) {
      let accessedRoutes;
      
      if (roles.includes('admin')) {
        accessedRoutes = asyncRoutes || [];
      } else {
        accessedRoutes = filterAsyncRoutes(asyncRoutes, roles);
      }
      
      this.addRoutes = accessedRoutes;
      this.routes = constantRoutes.concat(accessedRoutes);
      
      return accessedRoutes;
    }
  }
});
```

#### 2. 按钮权限

```typescript
// src/directives/permission/index.ts
import type { Directive, DirectiveBinding } from 'vue';
import { useUserStore } from '@/store/modules/user';

function checkPermission(el: HTMLElement, binding: DirectiveBinding) {
  const { value } = binding;
  const userStore = useUserStore();
  const { roles } = userStore;
  
  if (value && value instanceof Array && value.length > 0) {
    const permissionRoles = value;
    const hasPermission = roles.some(role => permissionRoles.includes(role));
    
    if (!hasPermission) {
      el.parentNode && el.parentNode.removeChild(el);
    }
  } else {
    throw new Error(`need roles! Like v-permission="['admin','editor']"`);
  }
}

const permission: Directive = {
  mounted(el: HTMLElement, binding: DirectiveBinding) {
    checkPermission(el, binding);
  },
  updated(el: HTMLElement, binding: DirectiveBinding) {
    checkPermission(el, binding);
  }
};

export default permission;
```

#### 3. 使用权限指令

```vue
<template>
  <div>
    <!-- 只有admin角色才能看到这个按钮 -->
    <a-button v-permission="['admin']" type="primary">管理员按钮</a-button>
    
    <!-- 只有admin和editor角色才能看到这个按钮 -->
    <a-button v-permission="['admin', 'editor']" type="primary">编辑按钮</a-button>
  </div>
</template>
```

### 国际化

#### 1. 语言包定义

```typescript
// src/lang/zh-CN.ts
export default {
  common: {
    confirm: '确认',
    cancel: '取消',
    submit: '提交',
    reset: '重置',
    search: '查询',
    add: '新增',
    edit: '编辑',
    delete: '删除',
    export: '导出',
    import: '导入',
    detail: '详情',
    operation: '操作',
    status: '状态',
    createTime: '创建时间',
    updateTime: '更新时间'
  },
  user: {
    title: '用户管理',
    username: '用户名',
    nickname: '昵称',
    email: '邮箱',
    phone: '手机号',
    avatar: '头像',
    password: '密码',
    oldPassword: '原密码',
    newPassword: '新密码',
    confirmPassword: '确认密码',
    role: '角色',
    department: '部门',
    status: {
      1: '启用',
      2: '禁用'
    }
  },
  auth: {
    login: '登录',
    logout: '退出登录',
    usernamePlaceholder: '请输入用户名',
    passwordPlaceholder: '请输入密码',
    captchaPlaceholder: '请输入验证码',
    rememberMe: '记住我',
    forgotPassword: '忘记密码？',
    loginSuccess: '登录成功',
    loginFailed: '登录失败',
    logoutSuccess: '退出登录成功',
    logoutFailed: '退出登录失败'
  }
};
```

#### 2. 语言包注册

```typescript
// src/lang/index.ts
import { createI18n } from 'vue-i18n';
import zhCN from './zh-CN';
import enUS from './en-US';

const messages = {
  'zh-CN': zhCN,
  'en-US': enUS
};

const i18n = createI18n({
  legacy: false,
  locale: localStorage.getItem('language') || 'zh-CN',
  fallbackLocale: 'zh-CN',
  messages
});

export default i18n;
```

#### 3. 使用国际化

```vue
<template>
  <div>
    <a-button @click="changeLanguage">切换语言</a-button>
    <p>{{ $t('common.confirm') }}</p>
    <p>{{ $t('user.title') }}</p>
  </div>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n';

const { locale } = useI18n();

const changeLanguage = () => {
  locale.value = locale.value === 'zh-CN' ? 'en-US' : 'zh-CN';
  localStorage.setItem('language', locale.value);
};
</script>
```

### 主题定制

#### 1. 主题配置

```typescript
// src/config/default.ts
export default {
  // 主题配置
  theme: {
    // 主色
    primaryColor: '#1890ff',
    // 是否暗黑模式
    isDark: false,
    // 导航模式：vertical-左侧菜单，horizontal-顶部菜单，mix-混合菜单
    layout: 'vertical',
    // 内容区域宽度：fluid-流式，fixed-定宽
    contentWidth: 'fluid',
    // 固定头部
    fixedHeader: true,
    // 固定侧边栏
    fixedSidebar: true,
    // 显示标签页
    showTags: true,
    // 显示面包屑
    showBreadcrumb: true,
    // 显示页脚
    showFooter: false,
    // 色弱模式
    colorWeak: false
  }
};
```

#### 2. 主题切换

```typescript
// src/store/modules/settings.ts
import { defineStore } from 'pinia';
import defaultSettings from '@/config/default';

interface SettingsState {
  theme: {
    primaryColor: string;
    isDark: boolean;
    layout: 'vertical' | 'horizontal' | 'mix';
    contentWidth: 'fluid' | 'fixed';
    fixedHeader: boolean;
    fixedSidebar: boolean;
    showTags: boolean;
    showBreadcrumb: boolean;
    showFooter: boolean;
    colorWeak: boolean;
  };
}

export const useSettingsStore = defineStore('settings', {
  state: (): SettingsState => ({
    theme: {
      ...defaultSettings.theme
    }
  }),
  
  getters: {
    primaryColor: (state) => state.theme.primaryColor,
    isDark: (state) => state.theme.isDark,
    layout: (state) => state.theme.layout,
    contentWidth: (state) => state.theme.contentWidth,
    fixedHeader: (state) => state.theme.fixedHeader,
    fixedSidebar: (state) => state.theme.fixedSidebar,
    showTags: (state) => state.theme.showTags,
    showBreadcrumb: (state) => state.theme.showBreadcrumb,
    showFooter: (state) => state.theme.showFooter,
    colorWeak: (state) => state.theme.colorWeak
  },
  
  actions: {
    // 切换主题
    toggleTheme() {
      this.theme.isDark = !this.theme.isDark;
      document.documentElement.classList.toggle('dark');
    },
    
    // 切换布局
    changeLayout(layout: 'vertical' | 'horizontal' | 'mix') {
      this.theme.layout = layout;
    },
    
    // 切换内容区域宽度
    changeContentWidth(contentWidth: 'fluid' | 'fixed') {
      this.theme.contentWidth = contentWidth;
    },
    
    // 切换固定头部
    toggleFixedHeader() {
      this.theme.fixedHeader = !this.theme.fixedHeader;
    },
    
    // 切换固定侧边栏
    toggleFixedSidebar() {
      this.theme.fixedSidebar = !this.theme.fixedSidebar;
    },
    
    // 切换标签页
    toggleShowTags() {
      this.theme.showTags = !this.theme.showTags;
    },
    
    // 切换面包屑
    toggleShowBreadcrumb() {
      this.theme.showBreadcrumb = !this.theme.showBreadcrumb;
    },
    
    // 切换页脚
    toggleShowFooter() {
      this.theme.showFooter = !this.theme.showFooter;
    },
    
    // 切换色弱模式
    toggleColorWeak() {
      this.theme.colorWeak = !this.theme.colorWeak;
      if (this.theme.colorWeak) {
        document.documentElement.classList.add('color-weak');
      } else {
        document.documentElement.classList.remove('color-weak');
      }
    },
    
    // 设置主题色
    setPrimaryColor(color: string) {
      this.theme.primaryColor = color;
    },
    
    // 重置设置
    resetSettings() {
      this.theme = {
        ...defaultSettings.theme
      };
      document.documentElement.classList.remove('dark', 'color-weak');
    }
  },
  
  persist: {
    enabled: true,
    strategies: [
      {
        key: 'settings',
        storage: localStorage
      }
    ]
  }
});
```

#### 3. 使用主题

```vue
<template>
  <div>
    <a-button @click="toggleTheme">切换主题</a-button>
    <a-button @click="changeLayout('vertical')">左侧菜单</a-button>
    <a-button @click="changeLayout('horizontal')">顶部菜单</a-button>
    <a-button @click="changeLayout('mix')">混合菜单</a-button>
  </div>
</template>

<script setup lang="ts">
import { useSettingsStore } from '@/store/modules/settings';

const settingsStore = useSettingsStore();

const toggleTheme = () => {
  settingsStore.toggleTheme();
};

const changeLayout = (layout: 'vertical' | 'horizontal' | 'mix') => {
  settingsStore.changeLayout(layout);
};
</script>
```

### 构建部署

#### 1. 开发环境构建

```bash
# 启动开发服务器
pnpm run dev

# 构建开发环境
pnpm run build:dev
```

#### 2. 测试环境构建

```bash
# 构建测试环境
pnpm run build:test
```

#### 3. 生产环境构建

```bash
# 构建生产环境
pnpm run build:prod
```

#### 4. 构建分析

```bash
# 构建并分析
pnpm run build:analyze
```

#### 5. 预览构建结果

```bash
# 预览构建结果
pnpm run preview
```

#### 6. 部署配置

```typescript
// vite.config.ts
import { defineConfig, loadEnv } from 'vite';
import { resolve } from 'path';
import { createVitePlugins } from './build/plugins';

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd());
  
  return {
    base: '/',
    plugins: createVitePlugins(env),
    resolve: {
      alias: {
        '@': resolve(__dirname, 'src')
      }
    },
    server: {
      host: '0.0.0.0',
      port: 8001,
      open: true,
      proxy: {
        '/api': {
          target: env.VITE_APP_BASE_URL,
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, '')
        }
      }
    },
    build: {
      target: 'es2015',
      cssTarget: 'chrome80',
      outDir: 'dist',
      assetsDir: 'assets',
      minify: 'terser',
      terserOptions: {
        compress: {
          drop_console: true,
          drop_debugger: true
        }
      },
      rollupOptions: {
        output: {
          manualChunks: {
            'vue-vendor': ['vue', 'vue-router', 'pinia'],
            'arco-vendor': ['@arco-design/web-vue'],
            'utils-vendor': ['axios', 'dayjs', 'lodash-es']
          }
        }
      },
      chunkSizeWarningLimit: 2000
    }
  };
});
```

### 总结

通过以上指南，您应该已经了解了 GinFast 前端项目的开发流程和最佳实践。在实际开发中，请遵循项目的代码规范和架构设计，以确保代码质量和可维护性。