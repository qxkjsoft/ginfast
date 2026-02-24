# SchedulerHelper - Go 任务调度器

一个功能强大的 Go 语言任务调度库，基于 `robfig/cron` 构建，支持任务管理、执行策略、阻塞策略、重试机制、超时控制和日志记录。

## 目录

- [特性](#特性)
- [安装](#安装)
- [快速开始](#快速开始)
- [核心概念](#核心概念)
  - [任务状态](#任务状态)
  - [执行策略](#执行策略)
  - [阻塞策略](#阻塞策略)
- [API 文档](#api-文档)
  - [JobScheduler 调度器](#jobscheduler-调度器)
  - [Job 任务结构体](#job-任务结构体)
  - [Executor 执行器接口](#executor-执行器接口)
  - [Logger 日志记录器](#logger-日志记录器)
- [使用示例](#使用示例)
- [配置说明](#配置说明)
- [日志系统](#日志系统)

## 特性

- ✅ 基于 Cron 表达式的任务调度（支持秒级）
- ✅ 任务启用/禁用管理
- ✅ 多种阻塞策略（丢弃、覆盖、并行）
- ✅ 任务超时控制
- ✅ 自动重试机制
- ✅ 并发执行支持
- ✅ 文件日志记录（按日期轮转）
- ✅ 任务执行结果通道

## 安装

```bash
go get github.com/robfig/cron/v3
```

将 `schedulerhelper` 目录复制到您的项目中。

## 快速开始

```go
package main

import (
    "context"
    "fmt"
    "time"
    
    "your-project/schedulerhelper"
)

// 1. 定义执行器
type MyExecutor struct{}

func (e *MyExecutor) Execute(ctx context.Context, job *schedulerhelper.Job) error {
    fmt.Printf("执行任务: %s\n", job.Name)
    // 您的业务逻辑
    return nil
}

func (e *MyExecutor) Name() string {
    return "my-executor"
}

func main() {
    // 2. 创建调度器
    scheduler := schedulerhelper.NewJobScheduler()
    
    // 3. 注册执行器
    scheduler.RegisterExecutor(&MyExecutor{})
    
    // 4. 创建任务
    job := &schedulerhelper.Job{
        Group:          "default",
        Name:           "hello-job",
        Description:    "示例任务",
        ExecutorName:   "my-executor",
        CronExpression: "*/5 * * * * *", // 每5秒执行一次
        Status:         schedulerhelper.StatusEnabled,
        Timeout:        30 * time.Second,
        MaxRetry:       3,
        RetryInterval:  5 * time.Second,
        BlockingPolicy: schedulerhelper.BlockDiscard,
    }
    
    // 5. 添加任务
    if err := scheduler.AddOrUpdateJob(job); err != nil {
        panic(err)
    }
    
    // 6. 启动调度器
    scheduler.Start()
    
    // 7. 监听任务结果（可选）
    go func() {
        for result := range scheduler.GetResults() {
            fmt.Printf("任务 %s 执行状态: %s, 耗时: %v\n", 
                result.JobID, result.Status, result.Duration)
        }
    }()
    
    // 运行一段时间后停止
    time.Sleep(1 * time.Minute)
    scheduler.Stop()
}
```

## 核心概念

### 任务状态

| 状态 | 常量 | 值 | 说明 |
|------|------|-----|------|
| 启用 | `StatusEnabled` | 1 | 任务将被调度执行 |
| 禁用 | `StatusDisabled` | 0 | 任务不会被调度 |

### 执行策略

| 策略 | 常量 | 值 | 说明 |
|------|------|-----|------|
| 重复执行 | `PolicyRepeat` | 1 | 按照 Cron 表达式重复执行 |
| 单次执行 | `PolicyOnce` | 0 | 仅执行一次后自动禁用 |

### 阻塞策略

当任务执行时间超过调度间隔时，可配置以下阻塞策略：

| 策略 | 常量 | 值 | 说明 |
|------|------|-----|------|
| 丢弃 | `BlockDiscard` | 0 | 如果任务正在执行，跳过本次执行 |
| 覆盖 | `BlockReplace` | 1 | 始终执行新任务（不跳过） |
| 并行 | `BlockParallel` | 2 | 允许多个实例并行执行（受 `ParallelNum` 限制） |

```
阻塞策略示意图：

BlockDiscard（丢弃）:
时间轴: ----|----|----|----|---->
任务1:  [=====]           (执行中)
任务2:       [跳过]       (被丢弃，因为任务1正在执行)

BlockReplace（覆盖）:
时间轴: ----|----|----|----|---->
任务1:  [=====]           (继续执行)
任务2:       [=====]      (同时执行，不受影响)

BlockParallel（并行，ParallelNum=2）:
时间轴: ----|----|----|----|---->
任务1:  [==========]      (执行中)
任务2:       [=====]      (并行执行)
任务3:            [跳过]  (超过并行数限制)
```

## API 文档

### JobScheduler 调度器

#### 创建调度器

```go
scheduler := schedulerhelper.NewJobScheduler()
```

#### 主要方法

| 方法 | 说明 |
|------|------|
| `Start()` | 启动调度器 |
| `Stop()` | 停止调度器（等待正在执行的任务完成） |
| `RegisterExecutor(executor Executor)` | 注册执行器 |
| `AddOrUpdateJob(job *Job) error` | 添加或更新任务 |
| `EnableJob(jobID string) error` | 启用任务 |
| `DisableJob(jobID string) error` | 禁用任务 |
| `DeleteJob(jobID string) error` | 删除任务 |
| `ExecuteNow(jobID string) error` | 立即执行一次任务（异步） |
| `ListJobs() []*Job` | 获取所有任务列表 |
| `GetResults() <-chan *JobResult` | 获取任务结果通道 |

### Job 任务结构体

```go
type Job struct {
    ID              string                 // 任务ID（自动生成）
    Group           string                 // 任务分组名称（必填）
    Name            string                 // 任务名称（必填）
    Description     string                 // 任务描述
    ExecutorName    string                 // 执行器名称（必填）
    ExecutionPolicy ExecutionPolicy        // 执行策略
    Status          JobStatus              // 任务状态
    CronExpression  string                 // Cron表达式（必填，支持秒级）
    Parameters      map[string]interface{} // 任务参数
    BlockingPolicy  BlockingPolicy         // 阻塞策略
    Timeout         time.Duration          // 超时时间（默认30秒）
    MaxRetry        int                    // 最大重试次数
    RetryInterval   time.Duration          // 重试间隔（默认10秒）
    ParallelNum     int                    // 并行数（默认1）
    RunningCount    int                    // 当前运行中的任务数
    CreatedAt       time.Time              // 创建时间
    UpdatedAt       time.Time              // 更新时间
}
```

#### Cron 表达式格式

支持 6 位表达式（秒 分 时 日 月 周）：

```
* * * * * *
│ │ │ │ │ │
│ │ │ │ │ └─── 星期几 (0-6, 0=周日)
│ │ │ │ └───── 月份 (1-12)
│ │ │ └─────── 日期 (1-31)
│ │ └───────── 小时 (0-23)
│ └─────────── 分钟 (0-59)
└───────────── 秒 (0-59)
```

常用示例：

| 表达式 | 说明 |
|--------|------|
| `*/5 * * * * *` | 每5秒执行 |
| `0 * * * * *` | 每分钟执行 |
| `0 0 * * * *` | 每小时执行 |
| `0 0 0 * * *` | 每天凌晨执行 |
| `0 30 9 * * 1-5` | 周一到周五 9:30 执行 |

### Executor 执行器接口

```go
type Executor interface {
    Execute(ctx context.Context, job *Job) error
    Name() string
}
```

实现示例：

```go
type EmailExecutor struct{}

func (e *EmailExecutor) Execute(ctx context.Context, job *schedulerhelper.Job) error {
    // 从任务参数获取配置
    to := job.Parameters["to"].(string)
    subject := job.Parameters["subject"].(string)
    
    // 检查上下文是否已取消（超时或停止）
    select {
    case <-ctx.Done():
        return ctx.Err()
    default:
    }
    
    // 执行发送邮件逻辑
    return sendEmail(to, subject)
}

func (e *EmailExecutor) Name() string {
    return "email-executor"
}
```

### JobResult 任务执行结果

```go
type JobResult struct {
    JobID      string        // 任务ID
    Status     string        // 执行状态: SUCCESS, FAILED, PANIC
    Error      error         // 错误信息（如果有）
    StartTime  time.Time     // 开始时间
    EndTime    time.Time     // 结束时间
    Duration   time.Duration // 执行时长
    RetryCount int           // 重试次数
}
```

## Logger 日志记录器

### 日志级别

| 级别 | 常量 | 值 | 说明 |
|------|------|-----|------|
| Debug | `LevelDebug` | 0 | 调试信息 |
| Info | `LevelInfo` | 1 | 一般信息 |
| Warn | `LevelWarn` | 2 | 警告信息 |
| Error | `LevelError` | 3 | 错误信息 |
| Fatal | `LevelFatal` | 4 | 致命错误 |

### 创建日志记录器

```go
logger, err := schedulerhelper.NewFileJobLogger("./logs", schedulerhelper.LevelInfo)
if err != nil {
    panic(err)
}
defer logger.Close()
```

### 日志方法

```go
// 基础日志
logger.Debug("job-id", "调试信息: %s", data)
logger.Info("job-id", "任务开始执行")
logger.Warn("job-id", "任务执行时间过长: %v", duration)
logger.Error("job-id", "任务执行失败: %v", err)

// 记录任务执行结果
logger.LogJobExecution(result)

// 记录任务生命周期事件
logger.LogJobLifecycle(job, "创建")  // 支持: 创建, 更新, 启用, 禁用, 删除, 手动触发, 执行中, 跳过
```

### 日志文件格式

- 文件名：`job-scheduler-YYYY-MM-DD.log`
- 位置：默认 `./logs/` 目录
- 轮转：每日自动创建新文件
- 输出：同时输出到文件和控制台

日志示例：
```
2026/02/11 08:30:00.123456 [INFO] [JOB:system] 调度器已启动
2026/02/11 08:30:05.234567 [INFO] [JOB:test-job-1] ✨ 任务[test-job] 创建 | 分组: default | 状态: 启用 | 策略: 丢弃 | CRON: */5 * * * * *
2026/02/11 08:30:10.345678 [INFO] [JOB:test-job-1] 执行成功
2026/02/11 08:30:10.345679 [INFO] [JOB:test-job-1] ✅ 执行SUCCESS | 耗时: 1.5s | 重试: 0次
```

## 使用示例

### 示例1：带参数的任务

```go
job := &schedulerhelper.Job{
    Group:          "notification",
    Name:           "send-notification",
    ExecutorName:   "notification-executor",
    CronExpression: "0 9 * * * *", // 每小时9分执行
    Status:         schedulerhelper.StatusEnabled,
    Parameters: map[string]interface{}{
        "template": "daily_report",
        "recipients": []string{"user1@example.com", "user2@example.com"},
    },
}
```

### 示例2：并行执行任务

```go
job := &schedulerhelper.Job{
    Group:           "data-sync",
    Name:            "sync-data",
    ExecutorName:    "sync-executor",
    CronExpression:  "*/10 * * * * *",
    Status:          schedulerhelper.StatusEnabled,
    BlockingPolicy:  schedulerhelper.BlockParallel,
    ParallelNum:     5, // 最多5个并行实例
}
```

### 示例3：带重试的任务

```go
job := &schedulerhelper.Job{
    Group:          "api-call",
    Name:           "call-external-api",
    ExecutorName:   "api-executor",
    CronExpression: "0 */5 * * * *", // 每5分钟执行
    Status:         schedulerhelper.StatusEnabled,
    MaxRetry:       3,
    RetryInterval:  10 * time.Second,
    Timeout:        30 * time.Second,
}
```

### 示例4：监听任务结果

```go
scheduler.Start()

// 启动结果监听协程
go func() {
    for result := range scheduler.GetResults() {
        switch result.Status {
        case "SUCCESS":
            log.Printf("任务 %s 执行成功，耗时 %v", result.JobID, result.Duration)
        case "FAILED":
            log.Printf("任务 %s 执行失败: %v", result.JobID, result.Error)
        case "PANIC":
            log.Printf("任务 %s 发生 panic: %v", result.JobID, result.Error)
        }
    }
}()
```

### 示例5：动态管理任务

```go
// 启用任务
if err := scheduler.EnableJob(jobID); err != nil {
    log.Printf("启用任务失败: %v", err)
}

// 禁用任务
if err := scheduler.DisableJob(jobID); err != nil {
    log.Printf("禁用任务失败: %v", err)
}

// 手动触发执行
if err := scheduler.ExecuteNow(jobID); err != nil {
    log.Printf("手动执行失败: %v", err)
}

// 删除任务
if err := scheduler.DeleteJob(jobID); err != nil {
    log.Printf("删除任务失败: %v", err)
}

// 列出所有任务
jobs := scheduler.ListJobs()
for _, job := range jobs {
    fmt.Printf("任务: %s, 状态: %d, 运行数: %d\n", job.Name, job.Status, job.RunningCount)
}
```

## 配置说明

### 默认值

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `ParallelNum` | 1 | 并行执行数 |
| `Timeout` | 30s | 任务超时时间 |
| `RetryInterval` | 10s | 重试间隔 |
| `日志目录` | `./logs` | 日志文件存储目录 |
| `日志级别` | `LevelInfo` | 默认日志级别 |

### 任务验证规则

添加任务时会自动进行以下验证：

- `Group` 不能为空
- `Name` 不能为空
- `ExecutorName` 不能为空
- `CronExpression` 不能为空且必须有效

## 注意事项

1. **资源释放**：使用完毕后务必调用 `scheduler.Stop()` 和 `logger.Close()` 释放资源

2. **执行器注册**：必须在添加任务之前注册对应的执行器

3. **任务ID**：任务ID由系统自动生成，格式为 `{group}-{name}-{timestamp}`

4. **并发安全**：调度器内部使用读写锁保护，支持并发访问

5. **优雅停止**：调用 `Stop()` 后会等待所有正在执行的任务完成

6. **结果通道**：结果通道缓冲区大小为1000，满时会丢弃新结果

## 依赖

- [github.com/robfig/cron/v3](https://github.com/robfig/cron) - Cron 表达式解析和调度

## 许可证

MIT License
