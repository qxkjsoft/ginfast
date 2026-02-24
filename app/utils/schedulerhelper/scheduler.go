package schedulerhelper

import (
	"context"
	"fmt"
	"log"
	"sync"
	"time"

	"github.com/robfig/cron/v3"
)

// 任务调度器
type JobScheduler struct {
	mu         sync.RWMutex
	cron       *cron.Cron
	jobs       map[string]*Job     // 任务存储
	executors  map[string]Executor // 执行器存储
	jobResults chan *JobResult     // 任务结果通道
	logger     JobLogger           // 日志记录器
	wg         sync.WaitGroup      // 等待正在执行的任务完成
}

// NewJobScheduler 创建新的调度器
// 使用函数选项模式进行配置，例如：
//
//	scheduler := NewJobScheduler(
//	    WithLoggerConfig("/var/log/jobs", LevelDebug),
//	    WithJobResultsBufferSize(2000),
//	    WithCronOptions(cron.WithSeconds(), cron.WithLogger(log.New(os.Stdout, "cron: ", log.LstdFlags))),
//	)
func NewJobScheduler(opts ...Option) *JobScheduler {
	// 默认配置
	s := &JobScheduler{
		cron:       cron.New(cron.WithSeconds()),
		jobs:       make(map[string]*Job),
		executors:  make(map[string]Executor),
		jobResults: make(chan *JobResult, 1000),
	}

	// 应用选项函数
	for _, opt := range opts {
		opt(s)
	}

	// 如果没有设置日志记录器，使用默认配置
	if s.logger == nil {
		logger, err := NewFileJobLogger("/resource/logs/scheduler", LevelInfo)
		if err != nil {
			log.Fatalf("Failed to create logger: %v", err)
		}
		s.logger = logger
	}

	return s
}

// 启动调度器
func (s *JobScheduler) Start() {
	s.cron.Start()
	s.logger.Info("system", "调度器已启动")
}

// 停止调度器
func (s *JobScheduler) Stop() {
	s.cron.Stop()
	s.logger.Info("system", "调度器已停止")

	// 等待所有正在执行的任务完成
	s.wg.Wait()

	close(s.jobResults)
	// 关闭日志记录器
	if err := s.logger.Close(); err != nil {
		log.Printf("Failed to close logger: %v", err)
	}
}

// 注册执行器
func (s *JobScheduler) RegisterExecutor(executor Executor) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.executors[executor.Name()] = executor
	s.logger.Info("system", "注册执行器: %s", executor.Name())
}

// 添加/更新任务
func (s *JobScheduler) AddOrUpdateJob(job *Job) (string, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	action := "更新"
	if _, exists := s.jobs[job.ID]; !exists {
		action = "创建"
		if job.ID == "" {
			job.ID = generateJobID()
		}
		job.CreatedAt = time.Now()
	}

	// 验证任务配置
	if err := validateJob(job); err != nil {
		return "", err
	}

	job.UpdatedAt = time.Now()

	// 如果任务已存在且已调度，先移除
	if existingJob, exists := s.jobs[job.ID]; exists && existingJob.cronEntryID != 0 {
		s.cron.Remove(existingJob.cronEntryID)
	}

	// 如果任务启用状态，添加到cron调度
	if job.Status == StatusEnabled {
		entryID, err := s.cron.AddFunc(job.CronExpression, s.createJobFunc(job))
		if err != nil {
			return "", fmt.Errorf("failed to add job to cron: %v", err)
		}
		job.cronEntryID = entryID
	}

	s.jobs[job.ID] = job
	s.logger.LogJobLifecycle(job, action)
	return job.ID, nil
}

// 创建任务执行函数
func (s *JobScheduler) createJobFunc(job *Job) func() {
	return func() {
		// 检查阻塞策略
		if !s.canExecute(job) {
			s.logger.LogJobLifecycle(job, "跳过")
			return
		}

		// 增加运行计数
		s.incrementRunningCount(job.ID)
		defer s.decrementRunningCount(job.ID)

		// 执行任务
		s.executeJob(job)
	}
}

// 检查任务是否可以执行
func (s *JobScheduler) canExecute(job *Job) bool {
	s.mu.RLock()
	defer s.mu.RUnlock()

	currentJob, exists := s.jobs[job.ID]
	if !exists {
		s.logger.Warn(job.ID, "任务不存在，无法执行")
		return false
	}

	// 获取当前运行中的任务数量
	runningCount := currentJob.RunningCount

	switch job.BlockingPolicy {
	case BlockDiscard:
		// 丢弃：如果任务正在执行中则丢弃当前任务（同一时间只能有一个任务执行）
		if runningCount == 0 {
			return true
		}
		s.logger.Warn(job.ID, "任务被丢弃（BlockDiscard策略）：任务正在执行中，当前运行数(%d)", runningCount)
		return false

	case BlockParallel:

		if job.ParallelNum <= 0 {
			return true
		}
		// 并行：如果超过并行数则丢弃
		if runningCount < job.ParallelNum {
			return true
		}
		s.logger.Warn(job.ID, "任务被丢弃（BlockParallel策略）：当前运行数(%d) >= 并行数(%d)", runningCount, job.ParallelNum)
		return false

	default:
		// 默认策略与 BlockDiscard 相同：如果任务正在执行中则丢弃
		if runningCount == 0 {
			return true
		}
		s.logger.Warn(job.ID, "任务被丢弃（默认策略）：任务正在执行中，当前运行数(%d)", runningCount)
		return false
	}
}

// 立即执行一次任务
func (s *JobScheduler) ExecuteNow(jobID string) error {
	s.mu.RLock()
	job, exists := s.jobs[jobID]
	s.mu.RUnlock()

	if !exists {
		return fmt.Errorf("job not found: %s", jobID)
	}

	if !s.canExecute(job) {
		return fmt.Errorf("job cannot execute due to blocking policy")
	}

	// 异步执行
	go func() {
		s.incrementRunningCount(job.ID)
		defer s.decrementRunningCount(job.ID)
		s.executeJob(job)
	}()

	return nil
}

// 执行任务（非递归版本）
func (s *JobScheduler) executeJob(job *Job) {
	s.wg.Add(1)
	defer s.wg.Done()

	startTime := time.Now()
	jobExecutionID := fmt.Sprintf("%s-%d", job.ID, startTime.UnixNano())

	var err error
	for currentRetry := 0; currentRetry <= job.MaxRetry; currentRetry++ {
		s.logger.Debug(job.ID, "开始执行 | 执行ID: %s | 重试次数: %d", jobExecutionID, currentRetry)

		result := &JobResult{
			JobID:           job.ID,
			StartTime:       time.Now(),
			RetryCount:      currentRetry,
			ExecutionPolicy: job.ExecutionPolicy,
		}

		// 获取执行器（加读锁保护）
		s.mu.RLock()
		executor, exists := s.executors[job.ExecutorName]
		s.mu.RUnlock()

		if !exists {
			result.Status = "FAILED"
			result.Error = fmt.Errorf("executor not found: %s", job.ExecutorName)
			s.sendResult(result)
			return
		}

		// 创建带超时的上下文
		ctx, cancel := context.WithTimeout(context.Background(), job.Timeout)

		// 执行任务（传递 job 的深拷贝，避免并发修改）
		jobCopy := job.Clone()
		err = executor.Execute(ctx, jobCopy)
		cancel()

		result.EndTime = time.Now()
		result.Duration = result.EndTime.Sub(result.StartTime)

		if err != nil {
			result.Status = "FAILED"
			result.Error = err
			s.logger.Warn(job.ID, "执行失败 | 错误: %v", err)

			if currentRetry < job.MaxRetry {
				s.logger.Info(job.ID, "准备重试 | 第%d次重试 | 等待 %v", currentRetry+1, job.RetryInterval)
				time.Sleep(job.RetryInterval)
				continue
			} else {
				s.logger.Error(job.ID, "达到最大重试次数")
				s.sendResult(result)
				return
			}
		} else {
			result.Status = "SUCCESS"
			s.logger.Info(job.ID, "执行成功")
			s.sendResult(result)

			// 单次执行策略：执行成功后自动禁用
			if job.ExecutionPolicy == PolicyOnce {
				if disableErr := s.DisableJob(job.ID); disableErr != nil {
					s.logger.Error(job.ID, "自动禁用任务失败: %v", disableErr)
				} else {
					s.logger.Info(job.ID, "单次执行任务已完成，已自动禁用")
				}
			}
			return
		}
	}
}

// 新增：安全发送结果
func (s *JobScheduler) sendResult(result *JobResult) {
	select {
	case s.jobResults <- result:
	default:
		return
	}
}

// 启用任务
func (s *JobScheduler) EnableJob(jobID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	job, exists := s.jobs[jobID]
	if !exists {
		return fmt.Errorf("job not found: %s", jobID)
	}

	if job.Status == StatusEnabled {
		return nil
	}

	// 添加到cron调度
	entryID, err := s.cron.AddFunc(job.CronExpression, s.createJobFunc(job))
	if err != nil {
		s.logger.Error(job.ID, "启用任务失败: %v", err)
		return fmt.Errorf("failed to enable job: %v", err)
	}

	job.cronEntryID = entryID
	job.Status = StatusEnabled
	job.UpdatedAt = time.Now()
	s.logger.LogJobLifecycle(job, "启用")
	return nil
}

// 禁用任务
func (s *JobScheduler) DisableJob(jobID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	job, exists := s.jobs[jobID]
	if !exists {
		return fmt.Errorf("job not found: %s", jobID)
	}

	if job.Status == StatusDisabled {
		return nil
	}

	// 从cron调度移除
	if job.cronEntryID != 0 {
		s.cron.Remove(job.cronEntryID)
		job.cronEntryID = 0
	}

	job.Status = StatusDisabled
	job.UpdatedAt = time.Now()
	s.logger.LogJobLifecycle(job, "禁用")
	return nil
}

// 删除任务
func (s *JobScheduler) DeleteJob(jobID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	job, exists := s.jobs[jobID]
	if !exists {
		return fmt.Errorf("job not found: %s", jobID)
	}

	// 如果任务已启用，先从cron移除
	if job.Status == StatusEnabled && job.cronEntryID != 0 {
		s.cron.Remove(job.cronEntryID)
	}

	delete(s.jobs, jobID)
	s.logger.LogJobLifecycle(job, "删除")
	return nil
}

// JobExists 检查任务是否存在
func (s *JobScheduler) JobExists(jobID string) bool {
	s.mu.RLock()
	defer s.mu.RUnlock()

	_, exists := s.jobs[jobID]
	return exists
}

// 获取任务列表
func (s *JobScheduler) ListJobs() []*Job {
	s.mu.RLock()
	defer s.mu.RUnlock()

	jobs := make([]*Job, 0, len(s.jobs))
	for _, job := range s.jobs {
		jobs = append(jobs, job)
	}
	return jobs
}

// 获取所有执行器
func (s *JobScheduler) ListExecutors() []Executor {
	s.mu.RLock()
	defer s.mu.RUnlock()

	executors := make([]Executor, 0, len(s.executors))
	for _, executor := range s.executors {
		executors = append(executors, executor)
	}
	return executors
}

// 获取任务结果通道
func (s *JobScheduler) GetResults() <-chan *JobResult {
	return s.jobResults
}

// 更新运行计数
func (s *JobScheduler) incrementRunningCount(jobID string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if job, exists := s.jobs[jobID]; exists {
		job.RunningCount++
	}
}

func (s *JobScheduler) decrementRunningCount(jobID string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if job, exists := s.jobs[jobID]; exists && job.RunningCount > 0 {
		job.RunningCount--
	}
}
