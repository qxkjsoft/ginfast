package schedulerhelper

import (
	"context"
	"errors"
	"sync/atomic"
	"testing"
	"time"
)

// MockExecutor 模拟执行器
type MockExecutor struct {
	name      string
	executeFn func(ctx context.Context, job *Job) error
	delay     time.Duration
	execCount int32
}

func NewMockExecutor(name string) *MockExecutor {
	return &MockExecutor{
		name: name,
		executeFn: func(ctx context.Context, job *Job) error {
			return nil
		},
	}
}

func (m *MockExecutor) Execute(ctx context.Context, job *Job) error {
	atomic.AddInt32(&m.execCount, 1)
	if m.delay > 0 {
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-time.After(m.delay):
		}
	}
	if m.executeFn != nil {
		return m.executeFn(ctx, job)
	}
	return nil
}

func (m *MockExecutor) Name() string {
	return m.name
}

func (m *MockExecutor) GetExecCount() int32 {
	return atomic.LoadInt32(&m.execCount)
}

func (m *MockExecutor) SetExecuteFn(fn func(ctx context.Context, job *Job) error) {
	m.executeFn = fn
}

func (m *MockExecutor) SetDelay(delay time.Duration) {
	m.delay = delay
}

// TestNewJobScheduler 测试调度器创建
func TestNewJobScheduler(t *testing.T) {
	scheduler := NewJobScheduler()
	if scheduler == nil {
		t.Fatal("NewJobScheduler returned nil")
	}
	if scheduler.cron == nil {
		t.Error("cron scheduler not initialized")
	}
	if scheduler.jobs == nil {
		t.Error("jobs map not initialized")
	}
	if scheduler.executors == nil {
		t.Error("executors map not initialized")
	}
	if scheduler.jobResults == nil {
		t.Error("jobResults channel not initialized")
	}
	if scheduler.logger == nil {
		t.Error("logger not initialized")
	}
}

// TestRegisterExecutor 测试注册执行器
func TestRegisterExecutor(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	scheduler.mu.RLock()
	_, exists := scheduler.executors["test-executor"]
	scheduler.mu.RUnlock()

	if !exists {
		t.Error("executor not registered")
	}
}

// TestAddJob 测试添加任务
func TestAddJob(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		Description:    "测试任务",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
		Timeout:        10 * time.Second,
		MaxRetry:       2,
		ParallelNum:    1,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	if job.ID == "" {
		t.Error("job ID not generated")
	}

	scheduler.mu.RLock()
	storedJob, exists := scheduler.jobs[job.ID]
	scheduler.mu.RUnlock()

	if !exists {
		t.Error("job not stored")
	}

	if storedJob.Name != job.Name {
		t.Errorf("job name mismatch: got %s, want %s", storedJob.Name, job.Name)
	}
}

// TestAddJobWithValidation 测试任务验证
func TestAddJobWithValidation(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	tests := []struct {
		name    string
		job     *Job
		wantErr bool
	}{
		{
			name: "empty group",
			job: &Job{
				Name:           "test-job",
				ExecutorName:   "test-executor",
				CronExpression: "* * * * *",
			},
			wantErr: true,
		},
		{
			name: "empty name",
			job: &Job{
				Group:          "test-group",
				ExecutorName:   "test-executor",
				CronExpression: "* * * * *",
			},
			wantErr: true,
		},
		{
			name: "empty executor name",
			job: &Job{
				Group:          "test-group",
				Name:           "test-job",
				CronExpression: "* * * * *",
			},
			wantErr: true,
		},
		{
			name: "empty cron expression",
			job: &Job{
				Group:        "test-group",
				Name:         "test-job",
				ExecutorName: "test-executor",
			},
			wantErr: true,
		},
		{
			name: "valid job",
			job: &Job{
				Group:          "test-group",
				Name:           "test-job",
				ExecutorName:   "test-executor",
				CronExpression: "* * * * *",
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, err := scheduler.AddOrUpdateJob(tt.job)
			if (err != nil) != tt.wantErr {
				t.Errorf("AddOrUpdateJob() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

// TestUpdateJob 测试更新任务
func TestUpdateJob(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	// 添加任务
	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
	}

	jobID, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	if jobID == "" {
		t.Error("AddOrUpdateJob returned empty ID")
	}
	originalCreatedAt := job.CreatedAt

	// 等待一毫秒确保时间不同
	time.Sleep(1 * time.Millisecond)

	// 更新任务
	job.Description = "updated description"
	updatedID, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob (update) failed: %v", err)
	}

	if updatedID != jobID {
		t.Errorf("AddOrUpdateJob returned different ID on update: got %s, want %s", updatedID, jobID)
	}

	if job.ID != jobID {
		t.Error("job ID changed after update")
	}

	if job.CreatedAt != originalCreatedAt {
		t.Error("CreatedAt changed after update")
	}

	if job.Description != "updated description" {
		t.Error("job not updated")
	}
}

// TestEnableDisableJob 测试启用/禁用任务
func TestEnableDisableJob(t *testing.T) {
	scheduler := NewJobScheduler()
	scheduler.Start()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	// 启用任务
	err = scheduler.EnableJob(job.ID)
	if err != nil {
		t.Fatalf("EnableJob failed: %v", err)
	}

	scheduler.mu.RLock()
	if job.Status != StatusEnabled {
		t.Error("job not enabled")
	}
	if job.cronEntryID == 0 {
		t.Error("cron entry ID not set")
	}
	scheduler.mu.RUnlock()

	// 禁用任务
	err = scheduler.DisableJob(job.ID)
	if err != nil {
		t.Fatalf("DisableJob failed: %v", err)
	}

	scheduler.mu.RLock()
	if job.Status != StatusDisabled {
		t.Error("job not disabled")
	}
	if job.cronEntryID != 0 {
		t.Error("cron entry ID not cleared")
	}
	scheduler.mu.RUnlock()
}

// TestDeleteJob 测试删除任务
func TestDeleteJob(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
	}

	jobID, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	if jobID == "" {
		t.Error("AddOrUpdateJob returned empty ID")
	}

	err = scheduler.DeleteJob(jobID)
	if err != nil {
		t.Fatalf("DeleteJob failed: %v", err)
	}

	scheduler.mu.RLock()
	_, exists := scheduler.jobs[jobID]
	scheduler.mu.RUnlock()

	if exists {
		t.Error("job not deleted")
	}
}

// TestListJobs 测试列出任务
func TestListJobs(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	// 添加多个任务（使用不同的名称）
	for i := 0; i < 3; i++ {
		job := &Job{
			Group:          "test-group",
			Name:           "test-job", // 每次循环会生成不同的ID（由于时间戳）
			ExecutorName:   "test-executor",
			CronExpression: "*/5 * * * * *",
			Status:         StatusDisabled,
		}
		_, err := scheduler.AddOrUpdateJob(job)
		if err != nil {
			t.Fatalf("AddOrUpdateJob failed: %v", err)
		}
		// 添加小延迟确保时间戳不同
		time.Sleep(1 * time.Millisecond)
	}

	jobs := scheduler.ListJobs()
	if len(jobs) != 3 {
		t.Errorf("expected 3 jobs, got %d", len(jobs))
	}
}

// TestBlockDiscardPolicy 测试丢弃阻塞策略
func TestBlockDiscardPolicy(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	executor.SetDelay(500 * time.Millisecond)
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
		BlockingPolicy: BlockDiscard,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	// 第一次执行应该成功
	if !scheduler.canExecute(job) {
		t.Error("first execution should be allowed")
	}

	scheduler.incrementRunningCount(job.ID)

	// 第二次执行应该被丢弃
	if scheduler.canExecute(job) {
		t.Error("second execution should be blocked with BlockDiscard policy")
	}
}

// TestBlockParallelPolicy 测试并行阻塞策略
func TestBlockParallelPolicy(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
		BlockingPolicy: BlockParallel,
		ParallelNum:    3,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	// 在并行数内应该允许执行
	for i := 0; i < 3; i++ {
		if !scheduler.canExecute(job) {
			t.Errorf("execution %d should be allowed", i+1)
		}
		scheduler.incrementRunningCount(job.ID)
	}

	// 超过并行数应该被丢弃
	if scheduler.canExecute(job) {
		t.Error("execution should be blocked when parallel limit reached")
	}
}

// TestExecuteNow 测试立即执行任务
func TestExecuteNow(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	err = scheduler.ExecuteNow(job.ID)
	if err != nil {
		t.Fatalf("ExecuteNow failed: %v", err)
	}

	// 等待任务执行完成
	time.Sleep(100 * time.Millisecond)

	if executor.GetExecCount() != 1 {
		t.Errorf("expected 1 execution, got %d", executor.GetExecCount())
	}
}

// TestExecuteNowWithBlockingPolicy 测试立即执行时的阻塞策略
func TestExecuteNowWithBlockingPolicy(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	executor.SetDelay(500 * time.Millisecond)
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
		BlockingPolicy: BlockDiscard,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	// 第一次执行
	err = scheduler.ExecuteNow(job.ID)
	if err != nil {
		t.Fatalf("ExecuteNow failed: %v", err)
	}

	// 等待一小段时间确保任务开始执行
	time.Sleep(50 * time.Millisecond)

	// 第二次执行应该被阻塞
	err = scheduler.ExecuteNow(job.ID)
	if err == nil {
		t.Error("second ExecuteNow should be blocked")
	}
}

// TestJobRetry 测试任务重试
func TestJobRetry(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	retryCount := int32(0)
	executor.SetExecuteFn(func(ctx context.Context, job *Job) error {
		count := atomic.AddInt32(&retryCount, 1)
		if count < 3 {
			return errors.New("simulated error")
		}
		return nil
	})
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
		MaxRetry:       3,
		RetryInterval:  100 * time.Millisecond,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	err = scheduler.ExecuteNow(job.ID)
	if err != nil {
		t.Fatalf("ExecuteNow failed: %v", err)
	}

	// 等待重试完成
	time.Sleep(500 * time.Millisecond)

	// 执行函数在 count < 3 时失败，即前2次失败，第3次成功
	// 所以总共执行 3 次
	if executor.GetExecCount() != 3 {
		t.Errorf("expected 3 executions (2 failed + 1 success), got %d", executor.GetExecCount())
	}
}

// TestJobTimeout 测试任务超时
func TestJobTimeout(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	executor.SetDelay(5 * time.Second)
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
		Timeout:        100 * time.Millisecond,
		MaxRetry:       0,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	err = scheduler.ExecuteNow(job.ID)
	if err != nil {
		t.Fatalf("ExecuteNow failed: %v", err)
	}

	// 等待超时
	time.Sleep(200 * time.Millisecond)

	// 检查结果通道
	select {
	case result := <-scheduler.GetResults():
		if result.Status != "FAILED" {
			t.Errorf("expected FAILED status, got %s", result.Status)
		}
	case <-time.After(1 * time.Second):
		t.Error("timeout waiting for job result")
	}
}

// TestRunningCount 测试运行计数
func TestRunningCount(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	// 增加运行计数
	scheduler.incrementRunningCount(job.ID)
	scheduler.incrementRunningCount(job.ID)

	scheduler.mu.RLock()
	if job.RunningCount != 2 {
		t.Errorf("expected running count 2, got %d", job.RunningCount)
	}
	scheduler.mu.RUnlock()

	// 减少运行计数
	scheduler.decrementRunningCount(job.ID)

	scheduler.mu.RLock()
	if job.RunningCount != 1 {
		t.Errorf("expected running count 1, got %d", job.RunningCount)
	}
	scheduler.mu.RUnlock()
}

// TestGetResults 测试获取结果通道
func TestGetResults(t *testing.T) {
	scheduler := NewJobScheduler()
	defer scheduler.Stop()

	results := scheduler.GetResults()
	if results == nil {
		t.Error("GetResults returned nil")
	}

	// 验证通道是只读的（通过检查类型）
	// GetResults 返回 <-chan *JobResult，是只读通道
	// 我们通过实际执行任务来验证通道工作正常

	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/5 * * * * *",
		Status:         StatusDisabled,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	err = scheduler.ExecuteNow(job.ID)
	if err != nil {
		t.Fatalf("ExecuteNow failed: %v", err)
	}

	// 等待结果
	select {
	case result := <-results:
		if result == nil {
			t.Error("received nil result")
		}
	case <-time.After(1 * time.Second):
		t.Error("timeout waiting for job result")
	}
}

// TestStartStop 测试启动和停止调度器
func TestStartStop(t *testing.T) {
	scheduler := NewJobScheduler()

	// 启动调度器
	scheduler.Start()

	// 添加一个启用的任务
	executor := NewMockExecutor("test-executor")
	scheduler.RegisterExecutor(executor)

	job := &Job{
		Group:          "test-group",
		Name:           "test-job",
		ExecutorName:   "test-executor",
		CronExpression: "*/1 * * * * *",
		Status:         StatusEnabled,
	}

	_, err := scheduler.AddOrUpdateJob(job)
	if err != nil {
		t.Fatalf("AddOrUpdateJob failed: %v", err)
	}

	// 等待任务执行
	time.Sleep(2 * time.Second)

	// 停止调度器
	scheduler.Stop()

	// 等待所有任务完成
	time.Sleep(100 * time.Millisecond)
}
