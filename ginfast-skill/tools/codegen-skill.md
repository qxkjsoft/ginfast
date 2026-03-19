---
name: codegen
description: 使用代码生成器时
modeSlugs:
  - code
  - architect
---

# 代码生成器使用指南

GinFast 提供了强大的代码生成器，可以根据数据库表一键生成完整的后端和前端代码。

## 目录

- [快速开始](#快速开始)
- [生成配置](#生成配置)
- [代码生成](#代码生成)
- [模板定制](#模板定制)
- [最佳实践](#最佳实践)

---

## 快速开始

### 1. 访问代码生成器

登录系统后，访问「系统工具」→「代码生成」菜单。

### 2. 选择数据库和表

1. 选择数据库
2. 选择要生成代码的表
3. 点击「导入」按钮

### 3. 配置生成信息

1. **基本信息**：设置模块名称、业务名称、功能名称
2. **字段信息**：配置字段显示类型、查询方式等
3. **生成信息**：选择生成的模板类型

### 4. 预览和生成

1. 点击「预览」查看生成的代码
2. 点击「生成代码」下载代码包
3. 解压并复制到项目中

---

## 生成配置

### 基本信息配置

| 字段 | 说明 | 示例 |
|------|------|------|
| 模块名称 | 代码生成的包路径 | `gin-fast/app` |
| 业务名称 | 业务模块名称 | `example` |
| 功能名称 | 功能描述 | `示例管理` |
| 作者 | 作者名称 | `ginfast` |
| 表前缀 | 需要去掉的表前缀 | `sys_` |

### 字段信息配置

| 字段 | 说明 | 可选值 |
|------|------|--------|
| 字段名称 | 数据库字段名 | - |
| 字段描述 | 字段显示名称 | - |
| 显示类型 | 前端显示控件 | 文本框、下拉框、日期选择等 |
| 查询方式 | 查询条件类型 | 等于、不等于、包含、范围等 |
| 必填 | 是否必填 | 是/否 |
| 列表显示 | 是否在列表中显示 | 是/否 |
| 查询显示 | 是否作为查询条件 | 是/否 |

### 显示类型说明

| 显示类型 | 说明 | 适用场景 |
|----------|------|---------|
| 文本框 | 单行文本输入 | 用户名、邮箱等 |
| 文本域 | 多行文本输入 | 描述、备注等 |
| 下拉框 | 单选下拉选择 | 状态、类型等 |
| 单选框 | 单选按钮 | 性别、是否等 |
| 复选框 | 多选复选框 | 权限、标签等 |
| 日期选择 | 日期时间选择 | 创建时间、更新时间等 |
| 图片上传 | 图片上传组件 | 头像、封面等 |
| 文件上传 | 文件上传组件 | 附件等 |
| 富文本 | 富文本编辑器 | 内容详情等 |

### 查询方式说明

| 查询方式 | 说明 | 示例 |
|----------|------|------|
| 等于 | 精确匹配 | `WHERE status = 1` |
| 不等于 | 不等于匹配 | `WHERE status != 0` |
| 包含 | 模糊匹配 | `WHERE name LIKE '%keyword%'` |
| 不包含 | 不包含匹配 | `WHERE name NOT LIKE '%keyword%'` |
| 大于 | 大于匹配 | `WHERE age > 18` |
| 小于 | 小于匹配 | `WHERE age < 60` |
| 之间 | 范围匹配 | `WHERE age BETWEEN 18 AND 60` |

---

## 代码生成

### 生成的文件结构

```
codegen-output/
├── backend/
│   ├── controllers/
│   │   └── example.go          # 控制器
│   ├── models/
│   │   ├── example.go          # 模型
│   │   └── exampleparam.go     # 参数结构体
│   ├── routes/
│   │   └── example.go          # 路由注册
│   └── service/
│       └── exampleservice.go   # 服务层
└── frontend/
    ├── api/
    │   └── example.js          # API 接口
    ├── views/
    │   └── example/
    │       ├── form.vue        # 表单页面
    │       └── index.vue       # 列表页面
    └── hooks/
        └── useExample.js       # 组合式函数
```

### 后端代码

#### 控制器

```go
// app/controllers/example.go
package controllers

import (
    "github.com/gin-gonic/gin"
)

type ExampleController struct {
    Common
    service *service.ExampleService
}

func NewExampleController() *ExampleController {
    return &ExampleController{
        Common:  Common{},
        service: service.NewExampleService(),
    }
}

// Create 创建示例
func (c *ExampleController) Create(ctx *gin.Context) {
    var req models.CreateRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    example, err := c.service.Create(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "创建示例失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "id": example.ID,
    })
}

// Update 更新示例
func (c *ExampleController) Update(ctx *gin.Context) {
    var req models.UpdateRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    err := c.service.Update(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "更新示例失败", err)
        return
    }

    c.SuccessWithMessage(ctx, "更新成功")
}

// Delete 删除示例
func (c *ExampleController) Delete(ctx *gin.Context) {
    var req models.DeleteRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    err := c.service.Delete(ctx, req.ID)
    if err != nil {
        c.FailAndAbort(ctx, "删除示例失败", err)
        return
    }

    c.SuccessWithMessage(ctx, "删除成功", nil)
}

// GetByID 根据ID获取示例信息
func (c *ExampleController) GetByID(ctx *gin.Context) {
    var req models.GetByIDRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    example, err := c.service.GetByID(ctx, req.ID)
    if err != nil {
        c.FailAndAbort(ctx, "示例不存在", err)
        return
    }

    c.Success(ctx, example)
}

// List 示例列表（分页查询）
func (c *ExampleController) List(ctx *gin.Context) {
    var req models.ListRequest
    if err := req.Validate(ctx); err != nil {
        c.FailAndAbort(ctx, err.Error(), err)
        return
    }

    exampleList, total, err := c.service.List(ctx, req)
    if err != nil {
        c.FailAndAbort(ctx, "获取示例列表失败", err)
        return
    }

    c.Success(ctx, gin.H{
        "list":  exampleList,
        "total": total,
    })
}
```

#### 模型

```go
// app/models/example.go
package models

import (
    "context"
    "gin-fast/app/global/app"
    "gorm.io/gorm"
)

type Example struct {
    BaseModel
    Name        string `gorm:"column:name;size:100;not null;comment:名称" json:"name"`
    Description string `gorm:"column:description;size:500;comment:描述" json:"description"`
    Status      int8   `gorm:"column:status;default:1;comment:状态" json:"status"`
    TenantID    uint   `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
}

func (Example) TableName() string {
    return "sys_example"
}

func NewExample() *Example {
    return &Example{}
}

func (e *Example) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(e).Error
}

func (e *Example) GetByID(ctx context.Context, id uint) error {
    return e.Find(ctx, func(db *gorm.DB) *gorm.DB {
        return db.Where("id = ?", id)
    })
}

func (e *Example) Create(ctx context.Context) error {
    return app.DB().WithContext(ctx).Create(e).Error
}

func (e *Example) Update(ctx context.Context) error {
    return app.DB().WithContext(ctx).Save(e).Error
}

func (e *Example) Delete(ctx context.Context) error {
    return app.DB().WithContext(ctx).Delete(e).Error
}

type ExampleList []*Example

func NewExampleList() ExampleList {
    return ExampleList{}
}

func (list *ExampleList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

func (list *ExampleList) GetTotal(ctx context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
    var total int64
    err := app.DB().WithContext(ctx).Model(&Example{}).Scopes(query...).Count(&total).Error
    if err != nil {
        return 0, err
    }
    return total, nil
}
```

#### 参数结构体

```go
// app/models/exampleparam.go
package models

import (
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
)

type CreateRequest struct {
    Validator
    Name        string `form:"name" validate:"required" message:"名称不能为空"`
    Description string `form:"description" validate:"max_len:500" message:"描述最多500字"`
}

func (r *CreateRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

type UpdateRequest struct {
    Validator
    ID          uint   `form:"id" validate:"required" message:"ID不能为空"`
    Name        string `form:"name" validate:"required" message:"名称不能为空"`
    Description string `form:"description" validate:"max_len:500" message:"描述最多500字"`
}

func (r *UpdateRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

type DeleteRequest struct {
    Validator
    ID uint `form:"id" validate:"required" message:"ID不能为空"`
}

func (r *DeleteRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

type GetByIDRequest struct {
    Validator
    ID uint `form:"id" validate:"required" message:"ID不能为空"`
}

func (r *GetByIDRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

type ListRequest struct {
    BasePaging
    Validator
    Name   string `form:"name" validate:"max_len:100" message:"名称最多100字"`
    Status string `form:"status" validate:"in:0,1" message:"状态值不正确"`
}

func (r *ListRequest) Validate(c *gin.Context) error {
    return r.Check(c, r)
}

func (r *ListRequest) Handle() func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        if r.Name != "" {
            db = db.Where("name LIKE ?", "%"+r.Name+"%")
        }
        if r.Status != "" {
            db = db.Where("status = ?", r.Status)
        }
        return db
    }
}
```

#### 服务层

```go
// app/service/exampleservice.go
package service

import (
    "gin-fast/app/models"
    "github.com/gin-gonic/gin"
)

type ExampleService struct{}

func NewExampleService() *ExampleService {
    return &ExampleService{}
}

func (s *ExampleService) Create(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    example := models.NewExample()
    example.Name = req.Name
    example.Description = req.Description

    if err := example.Create(c); err != nil {
        return nil, err
    }

    return example, nil
}

func (s *ExampleService) Update(c *gin.Context, req models.UpdateRequest) error {
    example := models.NewExample()
    if err := example.GetByID(c, req.ID); err != nil {
        return err
    }

    example.Name = req.Name
    example.Description = req.Description

    return example.Update(c)
}

func (s *ExampleService) Delete(c *gin.Context, id uint) error {
    example := models.NewExample()
    if err := example.GetByID(c, id); err != nil {
        return err
    }

    return example.Delete(c)
}

func (s *ExampleService) GetByID(c *gin.Context, id uint) (*models.Example, error) {
    example := models.NewExample()
    if err := example.GetByID(c, id); err != nil {
        return nil, err
    }

    return example, nil
}

func (s *ExampleService) List(c *gin.Context, req models.ListRequest) (*models.ExampleList, int64, error) {
    exampleList := models.NewExampleList()

    total, err := exampleList.GetTotal(c, req.Handle())
    if err != nil {
        return nil, 0, err
    }

    err = exampleList.Find(c, req.Handle(), req.Paginate())
    if err != nil {
        return nil, 0, err
    }

    return exampleList, total, nil
}
```

#### 路由注册

```go
// app/routes/example.go
package routes

import (
    "gin-fast/app/controllers"
    "gin-fast/app/middleware"
    "github.com/gin-gonic/gin"
)

var exampleControllers = controllers.NewExampleController()

func RegisterExampleRoutes(engine *gin.Engine) {
    example := engine.Group("/api/example")
    example.Use(middleware.JWTAuthMiddleware())
    example.Use(middleware.CasbinMiddleware())
    {
        example.POST("/add", exampleControllers.Create)
        example.PUT("/edit", exampleControllers.Update)
        example.DELETE("/delete", exampleControllers.Delete)
        example.GET("/list", exampleControllers.List)
        example.GET("/:id", exampleControllers.GetByID)
    }
}
```

### 前端代码

#### API 接口

```javascript
// src/api/example.js
import request from '@/utils/request'

export function getExampleList(params) {
  return request({
    url: '/example/list',
    method: 'get',
    params
  })
}

export function getExampleById(id) {
  return request({
    url: `/example/${id}`,
    method: 'get'
  })
}

export function createExample(data) {
  return request({
    url: '/example/add',
    method: 'post',
    data
  })
}

export function updateExample(data) {
  return request({
    url: '/example/edit',
    method: 'put',
    data
  })
}

export function deleteExample(id) {
  return request({
    url: '/example/delete',
    method: 'delete',
    data: { id }
  })
}
```

#### 列表页面

```vue
<!-- src/views/example/index.vue -->
<template>
  <div class="example-container">
    <!-- 查询表单 -->
    <el-form :model="queryParams" inline>
      <el-form-item label="名称">
        <el-input v-model="queryParams.name" placeholder="请输入名称" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleQuery">查询</el-button>
        <el-button @click="handleReset">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 操作按钮 -->
    <el-row :gutter="10">
      <el-col :span="1.5">
        <el-button type="primary" @click="handleAdd">新增</el-button>
      </el-col>
    </el-row>

    <!-- 数据表格 -->
    <el-table :data="tableData" v-loading="loading">
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="description" label="描述" />
      <el-table-column prop="status" label="状态" />
      <el-table-column label="操作">
        <template #default="{ row }">
          <el-button link @click="handleEdit(row)">编辑</el-button>
          <el-button link @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <el-pagination
      v-model:current-page="queryParams.pageNum"
      v-model:page-size="queryParams.pageSize"
      :total="total"
      @change="handleQuery"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getExampleList, deleteExample } from '@/api/example'

const tableData = ref([])
const loading = ref(false)
const total = ref(0)

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  name: ''
})

const getList = async () => {
  loading.value = true
  try {
    const { data } = await getExampleList(queryParams.value)
    tableData.value = data.list
    total.value = data.total
  } finally {
    loading.value = false
  }
}

const handleQuery = () => {
  queryParams.value.pageNum = 1
  getList()
}

const handleReset = () => {
  queryParams.value = {
    pageNum: 1,
    pageSize: 10,
    name: ''
  }
  handleQuery()
}

const handleAdd = () => {
  // 打开新增对话框
}

const handleEdit = (row) => {
  // 打开编辑对话框
}

const handleDelete = async (row) => {
  await deleteExample(row.id)
  getList()
}

onMounted(() => {
  getList()
})
</script>
```

---

## 模板定制

### 模板位置

代码生成器模板位于 `gen/templates/` 目录：

```
gen/templates/
├── controller.tpl          # 控制器模板
├── model.tpl               # 模型模板
├── modelparam.tpl          # 参数结构体模板
├── service.tpl             # 服务层模板
├── routes.tpl              # 路由模板
├── frontend/
│   ├── api.tpl             # API 接口模板
│   ├── views.tpl           # 视图模板
│   └── hooks.tpl           # 组合式函数模板
```

### 自定义模板

1. 复制默认模板到自定义目录
2. 修改模板内容
3. 在生成配置中选择自定义模板

---

## 最佳实践

### 1. 表设计规范

- 表名使用 `sys_` 前缀（系统表）
- 必须包含主键 `id`
- 必须包含 `created_at`、`updated_at` 字段
- 多租户表必须包含 `tenant_id` 字段
- 使用注释说明字段用途

### 2. 字段命名规范

- 使用小写字母和下划线
- 避免使用数据库关键字
- 布尔类型使用 `is_` 前缀

### 3. 生成前预览

生成代码前先预览，检查代码是否符合要求。

### 4. 分步生成

1. 先生成后端代码，测试通过后再生成前端代码
2. 或者先生成基础功能，再添加高级功能

### 5. 代码调整

生成的代码可能需要根据实际需求调整：
- 添加业务逻辑
- 调整验证规则
- 优化查询性能

---

## 参考资源

### 项目内部资源

- [`app/controllers/codegen.go`](../app/controllers/codegen.go) - 代码生成控制器
- [`app/service/codegenservice.go`](../app/service/codegenservice.go) - 代码生成服务
- [`gen/templates/`](../gen/templates/) - 代码生成模板
