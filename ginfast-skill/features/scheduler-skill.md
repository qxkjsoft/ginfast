---
name: scheduler
description: 创建定时任务时
modeSlugs:
  - code
  - architect
---

# 任务调度开发指南

GinFast 使用基于 Cron 表达式的任务调度系统，支持多种执行策略、阻塞策略、超时控制和自动重试机制。

## 目录

- [快速开始](#快速开始)
- [任务模型](#任务模型)
- [执行器开发](#执行器开发)
- [任务注册](#任务注册)
- [Cron 表达式](#cron-表达式)
- [最佳实践](#最佳实践)

---

## 快速开始

### 1. 创建执行器

```go
// app/scheduler/executors/my_executor.go
package executors

import (
    "context"
)

type MyExecutor struct{}

func NewMyExecutor() *MyExecutor {
    return &MyExecutor{}
}

func (e *MyExecutor) Execute(ctx context.Context, params map[string]interface{}) error {
    // 执行任务逻辑
    return nil
}
```

### 2. 注册执行器

```go
// app/scheduler/register.go
package scheduler

import (
    "gin-fast/app/global/app"
    "gin-fast/app/scheduler/executors"
)

func RegisterExecutors() {
    app.Scheduler.RegisterExecutor("my_task", executors.NewMyExecutor())
}
```

### 3. 在初始化时注册

```go
// bootstrap/init.go
func Init() {
    // 注册任务执行器
    scheduler.RegisterExecutors()
}
```

### 4. 在管理界面创建任务

登录系统，访问「系统工具」→「定时任务」，创建新任务：
- 任务名称：`我的任务`
- 执行器：`my_task`
- Cron 表达式：`0 0 * * *`（每小时执行）

---

## 任务模型

### SysJobs 模型

```go
// app/models/sysjobs.go
package models

import (
    "context"
    "gin-fast/app/global/app"
)

// SysJobs 定时任务模型
type SysJobs struct {
    BaseModel
    Name            string `gorm:"column:name;size:100;not null;comment:任务名称" json:"name"`
    Executor        string `gorm:"column:executor;size:100;not null;comment:执行器" json:"executor"`
    CronExpression  string `gorm:"column:cron_expression;size:100;not null;comment:Cron表达式" json:"cronExpression"`
    ExecuteStrategy int8   `gorm:"column:execute_strategy;default:1;comment:执行策略 1立即执行 2排队执行" json:"executeStrategy"`
    BlockStrategy   int8   `gorm:"column:block_strategy;default:1;comment:阻塞策略 1跳过 2覆盖 3排队" json:"blockStrategy"`
    Timeout         int    `gorm:"column:timeout;default:0;comment:超时时间(秒) 0不限制" json:"timeout"`
    RetryCount      int    `gorm:"column:retry_count;default:0;comment:重试次数" json:"retryCount"`
    RetryInterval   int    `gorm:"column:retry_interval;default:0;comment:重试间隔(秒)" json:"retryInterval"`
    Status          int8   `gorm:"column:status;default:1;comment:状态 0禁用 1启用" json:"status"`
    Remark          string `gorm:"column:remark;size:500;comment:备注" json:"remark"`
}

// TableName 设置表名
func (SysJobs) TableName() string {
    return "sys_jobs"
}

// NewSysJobs 创建实例
func NewSysJobs() *SysJobs {
    return &SysJobs{}
}

// Find 查询
func (j *SysJobs) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(j).Error
}

// GetByID 根据ID获取
func (j *SysJobs) FindByID(ctx context.Context, id uint) error {
    return j.Find(ctx, func(db *gorm.DB) *gorm.DB {
        return db.Where("id = ?", id)
    })
}

// Create 创建
func (j *SysJobs) Create(ctx context.Context) error {
    return app.DB().WithContext(ctx).Create(j).Error
}

// Update 更新
func (j *SysJobs) Update(ctx context.Context) error {
    return app.DB().WithContext(ctx).Save(j).Error
}

// Delete 删除
func (j *SysJobs) Delete(ctx context.Context) error {
    return app.DB().WithContext(ctx).Delete(j).Error
}
```

### SysJobResults 模型

```go
// app/models/sysjobresults.go
package models

import (
    "context"
    "gin-fast/app/global/app"
)

// SysJobResults 任务执行结果模型
type SysJobResults struct {
    BaseModel
    JobID       uint       `gorm:"column:job_id;not null;comment:任务ID" json:"jobId"`
    ExecuteTime JSONTime   `gorm:"column:execute_time;not null;comment:执行时间" json:"executeTime"`
    Duration    int        `gorm:"column:duration;not null;comment:执行时长(毫秒)" json:"duration"`
    Status      int8       `gorm:"column:status;not null;comment:状态 1成功 2失败" json:"status"`
    ErrorMessage string     `gorm:"column:error_message;size:1000;comment:错误消息" json:"errorMessage"`
}

// TableName 设置表名
func (SysJobResults) TableName() string {
    return "sys_job_results"
}

// NewSysJobResults 创建实例
func NewSysJobResults() *SysJobResults {
    return &SysJobResults{}
}

// Find 查询
func (r *SysJobResults) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
    return app.DB().WithContext(ctx).Scopes(funcs...).Find(r).Error
}

// Create 创建
func (r *SysJobResults) Create(ctx context.Context) error {
    return app.DB().WithContext(ctx).Create(r).Error
}
```

---

## 执行器开发

### 执行器接口

```go
// app/utils/schedulerhelper/job.go
type Executor interface {
    Execute(ctx context.Context, params map[string]interface{}) error
}
```

### 基本执行器

```go
// app/scheduler/executors/cleanup_executor.go
package executors

import (
    "context"
    "fmt"
    "gin-fast/app/global/app"

    "go.uber.org/zap"
)

// CleanupExecutor 清理执行器
type CleanupExecutor struct{}

func NewCleanupExecutor() *CleanupExecutor {
    return &CleanupExecutor{}
}

func (e *CleanupExecutor) Execute(ctx context.Context, params map[string]interface{}) error {
    app.ZapLog.Info("开始执行清理任务")

    // 清理逻辑
    // 例如：清理过期的日志文件

    app.ZapLog.Info("清理任务执行完成")
    return nil
}
```

### 带参数的执行器

```go
// app/scheduler/executors/notification_executor.go
package executors

import (
    "context"
    "gin-fast/app/global/app"
)

// NotificationExecutor 通知执行器
type NotificationExecutor struct{}

func NewNotificationExecutor() *NotificationExecutor {
    return &NotificationExecutor{}
}

func (e *NotificationExecutor) Execute(ctx context.Context, params map[string]interface{}) error {
    // 获取参数
    message, _ := params["message"].(string)
    if message == "" {
        message = "默认通知消息"
    }

    // 发送通知
    app.ZapLog.Info("发送通知", zap.String("message", message))

    return nil
}
```

### 使用数据库的执行器

```go
// app/scheduler/executors/data_sync_executor.go
package executors

import (
    "context"
    "gin-fast/app/global/app"
    "gin-fast/app/models"
)

// DataSyncExecutor 数据同步执行器
type DataSyncExecutor struct{}

func NewDataSyncExecutor() *DataSyncExecutor {
    return &DataSyncExecutor{}
}

func (e *DataSyncExecutor) Execute(ctx context.Context, params map[string]interface{}) error {
    // 查询需要同步的数据
    users := models.NewUserList()
    if err := users.Find(ctx); err != nil {
        return err
    }

    // 同步数据到其他系统
    for _, user := range *users {
        // 同步逻辑
        app.ZapLog.Info("同步用户", zap.Uint("userID", user.ID))
    }

    return nil
}
```

### 插件执行器

```go
// plugins/example/scheduler/executors/example_executor.go
package executors

import (
    "context"
    "gin-fast/app/global/app"
)

// ExampleExecutor 示例执行器
type ExampleExecutor struct{}

func NewExampleExecutor() *ExampleExecutor {
    return &ExampleExecutor{}
}

func (e *ExampleExecutor) Execute(ctx context.Context, params map[string]interface{}) error {
    app.ZapLog.Info("执行示例插件任务")

    // 执行插件特定的任务逻辑

    return nil
}
```

---

## 任务注册

### 注册执行器

```go
// app/scheduler/register.go
package scheduler

import (
    "gin-fast/app/global/app"
    "gin-fast/app/scheduler/executors"
)

func RegisterExecutors() {
    // 注册清理任务执行器
    app.Scheduler.RegisterExecutor("cleanup", executors.NewCleanupExecutor())

    // 注册通知任务执行器
    app.Scheduler.RegisterExecutor("notification", executors.NewNotificationExecutor())

    // 注册数据同步执行器
    app.Scheduler.RegisterExecutor("data_sync", executors.NewDataSyncExecutor())
}
```

### 插件执行器注册

```go
// plugins/example/scheduler/register.go
package scheduler

import (
    "gin-fast/app/global/app"
    "gin-fast/plugins/example/scheduler/executors"
)

func RegisterExampleExecutors() {
    // 注册示例插件执行器
    app.Scheduler.RegisterExecutor("example_task", executors.NewExampleExecutor())
}

// plugins/exampleinit.go
package plugins

import (
    _ "gin-fast/plugins/example/routes"
    "gin-fast/plugins/example/scheduler"
)

func init() {
    // 注册示例执行器
    scheduler.RegisterExampleExecutors()
}
```

---

## Cron 表达式

### Cron 表达式格式

```
秒 分 时 日 月 周
```

### 字段说明

| 字段 | 允许值 | 允许特殊字符 |
|------|--------|-------------|
| 秒 | 0-59 | `, - * /` |
| 分 | 0-59 | `, - * /` |
| 时 | 0-23 | `, - * /` |
| 日 | 1-31 | `, - * / ? L W` |
| 月 | 1-12 | `, - * /` |
| 周 | 0-7 (0和7都表示周日) | `, - * / ? L #` |

### 特殊字符说明

| 字符 | 说明 | 示例 |
|------|------|------|
| `*` | 所有值 | `* * * * *` (每秒) |
| `?` | 不指定值（只能用于日和周） | `0 0 12 * * ?` |
| `-` | 范围 | `0 0 8-18 * * *` (每天8点到18点) |
| `,` | 列表 | `0 0 8,12,18 * * *` (每天8点、12点、18点) |
| `/` | 间隔 | `0 0/5 * * *` (每5分钟) |
| `L` | 最后 | `0 0 L * *` (每月最后一天) |
| `W` | 工作日 | `0 0 10W * *` (每月10号最近的工作日) |
| `#` | 第几个 | `0 0 ? * 1#1` (每月第一个周一) |

### 常用示例

| Cron 表达式 | 说明 |
|------------|------|
| `0 * * * *` | 每分钟的第0秒 |
| `0 0 * * *` | 每小时的第0分 |
| `0 0 0 * *` | 每天0点 |
| `0 0 0 * * 1` | 每周一0点 |
| `0 0 0 1 * *` | 每月1号0点 |
| `0 */5 * * *` | 每5分钟 |
| `0 0 */2 * *` | 每2小时 |
| `0 0 8-18 * *` | 每天8点到18点 |
| `0 0 8,12,18 * * *` | 每天8点、12点、18点 |
| `0 0 0 * * 1-5` | 周一到周五的0点 |
| `0 0 0 L * *` | 每月最后一天0点 |
| `0 0 0 ? * 1#1` | 每月第一个周一0点 |

---

## 最佳实践

### 1. 执行器命名规范

使用小写字母和下划线：

```go
// 好的做法
"data_sync"
"cleanup_cache"
"send_notification"

// 不好的做法
"DataSync"
"CleanupCache"
"sendNotification"
```

### 2. 错误处理

执行器中应该处理所有可能的错误：

```go
func (e *MyExecutor) Execute(ctx context.Context, params map[string]interface{}) error {
    if err := doSomething(); err != nil {
        app.ZapLog.Error("任务执行失败", zap.Error(err))
        return err
    }
    return nil
}
```

### 3. 超时控制

为长时间运行的任务设置超时：

```go
// 在任务配置中设置超时时间
Timeout: 300  // 5分钟
```

### 4. 重试机制

为可能失败的任务配置重试：

```go
// 在任务配置中设置重试次数和间隔
RetryCount: 3
RetryInterval: 60  // 重试间隔60秒
```

### 5. 执行策略

| 策略 | 说明 | 适用场景 |
|------|------|---------|
| 立即执行 | 立即执行新任务 | 短时间任务 |
| 排队执行 | 等待当前任务完成 | 长时间任务 |

### 6. 阻塞策略

| 策略 | 说明 | 适用场景 |
|------|------|---------|
| 跳过 | 跳过本次执行 | 不重要的任务 |
| 覆盖 | 终止当前任务，执行新任务 | 数据同步任务 |
| 排队 | 等待当前任务完成 | 顺序执行的任务 |

### 7. 日志记录

记录任务执行的关键信息：

```go
func (e *MyExecutor) Execute(ctx context.Context, params map[string]interface{}) error {
    app.ZapLog.Info("任务开始执行")
    start := time.Now()

    // 执行任务逻辑

    duration := time.Since(start)
    app.ZapLog.Info("任务执行完成", zap.Duration("duration", duration))
    return nil
}
```

### 8. 参数传递

通过 params 参数传递配置：

```go
func (e *MyExecutor) Execute(ctx context.Context, params map[string]interface{}) error {
    // 获取参数
    retryCount, _ := params["retryCount"].(int)
    timeout, _ := params["timeout"].(int)

    // 使用参数
    // ...

    return nil
}
```

### 9. 上下文使用

使用 context 进行超时控制：

```go
func (e *MyExecutor) Execute(ctx context.Context, params map[string]interface{}) error {
    // 创建带超时的上下文
    timeout := time.Duration(params["timeout"].(int)) * time.Second
    ctx, cancel := context.WithTimeout(ctx, timeout)
    defer cancel()

    // 使用上下文
    select {
    case <-ctx.Done():
        return ctx.Err()
    case result := <-doWork():
        return result
    }
}
```

### 10. 任务结果记录

任务执行结果会自动记录到 `sys_job_results` 表：

```go
// 查询任务执行结果
results := models.NewSysJobResultsList()
results.Find(ctx, func(db *gorm.DB) *gorm.DB {
    return db.Where("job_id = ?", jobID).
           Order("execute_time DESC").
           Limit(10)
})
```

---

## 参考资源

### 项目内部资源

- [`app/models/sysjobs.go`](../app/models/sysjobs.go) - 任务模型
- [`app/models/sysjobresults.go`](../app/models/sysjobresults.go) - 任务结果模型
- [`app/controllers/sysjobscontroller.go`](../app/controllers/sysjobscontroller.go) - 任务控制器
- [`app/service/sysjobsservice.go`](../app/service/sysjobsservice.go) - 任务服务
- [`app/scheduler/register.go`](../app/scheduler/register.go) - 任务注册
- [`app/scheduler/executors/`](../app/scheduler/executors/) - 内置执行器
- [`app/utils/schedulerhelper/scheduler.go`](../app/utils/schedulerhelper/scheduler.go) - 调度器实现

### 外部资源

- [robfig/cron GitHub](https://github.com/robfig/cron)
- [Cron 表达式在线生成器](https://crontab.guru/)
