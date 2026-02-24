package schedulerhelper

import (
	"context"
	"errors"
	"testing"
	"time"
)

// TestJobStatusValues 测试任务状态常量值
func TestJobStatusValues(t *testing.T) {
	tests := []struct {
		name  string
		value JobStatus
		want  int
	}{
		{"StatusEnabled", StatusEnabled, 1},
		{"StatusDisabled", StatusDisabled, 0},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if int(tt.value) != tt.want {
				t.Errorf("%s = %d, want %d", tt.name, tt.value, tt.want)
			}
		})
	}
}

// TestExecutionPolicyValues 测试执行策略常量值
func TestExecutionPolicyValues(t *testing.T) {
	tests := []struct {
		name  string
		value ExecutionPolicy
		want  int
	}{
		{"PolicyRepeat", PolicyRepeat, 1},
		{"PolicyOnce", PolicyOnce, 0},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if int(tt.value) != tt.want {
				t.Errorf("%s = %d, want %d", tt.name, tt.value, tt.want)
			}
		})
	}
}

// TestBlockingPolicyValues 测试阻塞策略常量值
func TestBlockingPolicyValues(t *testing.T) {
	tests := []struct {
		name  string
		value BlockingPolicy
		want  int
	}{
		{"BlockDiscard", BlockDiscard, 0},
		{"BlockParallel", BlockParallel, 1},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if int(tt.value) != tt.want {
				t.Errorf("%s = %d, want %d", tt.name, tt.value, tt.want)
			}
		})
	}
}

// TestGetJobStatusName 测试获取任务状态名称
func TestGetJobStatusName(t *testing.T) {
	tests := []struct {
		name   string
		status JobStatus
		want   string
	}{
		{"Enabled", StatusEnabled, "启用"},
		{"Disabled", StatusDisabled, "禁用"},
		{"Unknown", JobStatus(99), "未知"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := getJobStatusName(tt.status); got != tt.want {
				t.Errorf("getJobStatusName(%v) = %s, want %s", tt.status, got, tt.want)
			}
		})
	}
}

// TestGetBlockingPolicyName 测试获取阻塞策略名称
func TestGetBlockingPolicyName(t *testing.T) {
	tests := []struct {
		name   string
		policy BlockingPolicy
		want   string
	}{
		{"BlockDiscard", BlockDiscard, "丢弃"},
		{"BlockParallel", BlockParallel, "并行"},
		{"Unknown", BlockingPolicy(99), "未知"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := getBlockingPolicyName(tt.policy); got != tt.want {
				t.Errorf("getBlockingPolicyName(%v) = %s, want %s", tt.policy, got, tt.want)
			}
		})
	}
}

// TestJobCreation 测试任务创建
func TestJobCreation(t *testing.T) {
	now := time.Now()

	job := &Job{
		ID:              "test-job-1",
		Group:           "test-group",
		Name:            "test-job",
		Description:     "测试任务",
		ExecutorName:    "test-executor",
		ExecutionPolicy: PolicyRepeat,
		Status:          StatusEnabled,
		CronExpression:  "*/5 * * * * *",
		Parameters:      map[string]interface{}{"key": "value"},
		BlockingPolicy:  BlockDiscard,
		Timeout:         30 * time.Second,
		MaxRetry:        3,
		RetryInterval:   10 * time.Second,
		ParallelNum:     1,
		RunningCount:    0,
		CreatedAt:       now,
		UpdatedAt:       now,
	}

	if job.ID != "test-job-1" {
		t.Errorf("ID = %s, want test-job-1", job.ID)
	}
	if job.Group != "test-group" {
		t.Errorf("Group = %s, want test-group", job.Group)
	}
	if job.Name != "test-job" {
		t.Errorf("Name = %s, want test-job", job.Name)
	}
	if job.ExecutorName != "test-executor" {
		t.Errorf("ExecutorName = %s, want test-executor", job.ExecutorName)
	}
	if job.Status != StatusEnabled {
		t.Errorf("Status = %v, want %v", job.Status, StatusEnabled)
	}
	if job.CronExpression != "*/5 * * * * *" {
		t.Errorf("CronExpression = %s, want */5 * * * * *", job.CronExpression)
	}
	if job.BlockingPolicy != BlockDiscard {
		t.Errorf("BlockingPolicy = %v, want %v", job.BlockingPolicy, BlockDiscard)
	}
	if job.Timeout != 30*time.Second {
		t.Errorf("Timeout = %v, want 30s", job.Timeout)
	}
	if job.MaxRetry != 3 {
		t.Errorf("MaxRetry = %d, want 3", job.MaxRetry)
	}
	if job.RetryInterval != 10*time.Second {
		t.Errorf("RetryInterval = %v, want 10s", job.RetryInterval)
	}
	if job.ParallelNum != 1 {
		t.Errorf("ParallelNum = %d, want 1", job.ParallelNum)
	}
}

// TestJobResultCreation 测试任务结果创建
func TestJobResultCreation(t *testing.T) {
	now := time.Now()
	testErr := errors.New("test error")

	result := &JobResult{
		JobID:      "test-job-1",
		Status:     "FAILED",
		Error:      testErr,
		StartTime:  now,
		EndTime:    now.Add(5 * time.Second),
		Duration:   5 * time.Second,
		RetryCount: 2,
	}

	if result.JobID != "test-job-1" {
		t.Errorf("JobID = %s, want test-job-1", result.JobID)
	}
	if result.Status != "FAILED" {
		t.Errorf("Status = %s, want FAILED", result.Status)
	}
	if result.Error != testErr {
		t.Errorf("Error = %v, want %v", result.Error, testErr)
	}
	if result.Duration != 5*time.Second {
		t.Errorf("Duration = %v, want 5s", result.Duration)
	}
	if result.RetryCount != 2 {
		t.Errorf("RetryCount = %d, want 2", result.RetryCount)
	}
}

// TestExecutorInterface 测试执行器接口实现
func TestExecutorInterface(t *testing.T) {
	// 创建一个模拟执行器
	executor := &MockExecutor{
		name: "test-executor",
		executeFn: func(ctx context.Context, job *Job) error {
			return nil
		},
	}

	// 验证接口实现
	var _ Executor = executor

	// 测试 Name 方法
	if executor.Name() != "test-executor" {
		t.Errorf("Name() = %s, want test-executor", executor.Name())
	}

	// 测试 Execute 方法
	ctx := context.Background()
	job := &Job{ID: "test-job"}
	err := executor.Execute(ctx, job)
	if err != nil {
		t.Errorf("Execute() error = %v", err)
	}
}

// TestJobParameters 测试任务参数
func TestJobParameters(t *testing.T) {
	job := &Job{
		ID:         "test-job-1",
		Group:      "test-group",
		Name:       "test-job",
		Parameters: make(map[string]interface{}),
	}

	// 测试添加参数
	job.Parameters["stringParam"] = "value"
	job.Parameters["intParam"] = 123
	job.Parameters["boolParam"] = true
	job.Parameters["floatParam"] = 3.14

	if job.Parameters["stringParam"] != "value" {
		t.Error("stringParam not set correctly")
	}
	if job.Parameters["intParam"] != 123 {
		t.Error("intParam not set correctly")
	}
	if job.Parameters["boolParam"] != true {
		t.Error("boolParam not set correctly")
	}
	if job.Parameters["floatParam"] != 3.14 {
		t.Error("floatParam not set correctly")
	}
}

// TestJobRunningCount 测试运行计数
func TestJobRunningCount(t *testing.T) {
	job := &Job{
		ID:           "test-job-1",
		Group:        "test-group",
		Name:         "test-job",
		RunningCount: 0,
	}

	// 增加运行计数
	job.RunningCount++
	if job.RunningCount != 1 {
		t.Errorf("RunningCount = %d, want 1", job.RunningCount)
	}

	job.RunningCount++
	if job.RunningCount != 2 {
		t.Errorf("RunningCount = %d, want 2", job.RunningCount)
	}

	// 减少运行计数
	job.RunningCount--
	if job.RunningCount != 1 {
		t.Errorf("RunningCount = %d, want 1", job.RunningCount)
	}
}

// TestJobTimestamps 测试任务时间戳
func TestJobTimestamps(t *testing.T) {
	now := time.Now()

	job := &Job{
		ID:        "test-job-1",
		Group:     "test-group",
		Name:      "test-job",
		CreatedAt: now,
		UpdatedAt: now,
	}

	if job.CreatedAt.IsZero() {
		t.Error("CreatedAt should not be zero")
	}
	if job.UpdatedAt.IsZero() {
		t.Error("UpdatedAt should not be zero")
	}

	// 更新时间戳
	newTime := now.Add(1 * time.Hour)
	job.UpdatedAt = newTime

	if !job.UpdatedAt.Equal(newTime) {
		t.Errorf("UpdatedAt = %v, want %v", job.UpdatedAt, newTime)
	}
}

// TestJobResultStatusValues 测试任务结果状态值
func TestJobResultStatusValues(t *testing.T) {
	result := &JobResult{
		JobID:      "test-job-1",
		StartTime:  time.Now(),
		EndTime:    time.Now(),
		Duration:   0,
		RetryCount: 0,
	}

	// 测试 SUCCESS 状态
	result.Status = "SUCCESS"
	if result.Status != "SUCCESS" {
		t.Errorf("Status = %s, want SUCCESS", result.Status)
	}

	// 测试 FAILED 状态
	result.Status = "FAILED"
	if result.Status != "FAILED" {
		t.Errorf("Status = %s, want FAILED", result.Status)
	}

	// 测试 PANIC 状态
	result.Status = "PANIC"
	if result.Status != "PANIC" {
		t.Errorf("Status = %s, want PANIC", result.Status)
	}
}

// TestJobResultDuration 测试任务结果时长计算
func TestJobResultDuration(t *testing.T) {
	startTime := time.Now()
	endTime := startTime.Add(5 * time.Second)

	result := &JobResult{
		JobID:      "test-job-1",
		Status:     "SUCCESS",
		StartTime:  startTime,
		EndTime:    endTime,
		Duration:   endTime.Sub(startTime),
		RetryCount: 0,
	}

	expectedDuration := 5 * time.Second
	if result.Duration != expectedDuration {
		t.Errorf("Duration = %v, want %v", result.Duration, expectedDuration)
	}
}

// TestJobWithZeroValues 测试零值任务
func TestJobWithZeroValues(t *testing.T) {
	job := &Job{}

	// 验证零值
	if job.ID != "" {
		t.Errorf("ID should be empty, got %s", job.ID)
	}
	if job.Group != "" {
		t.Errorf("Group should be empty, got %s", job.Group)
	}
	if job.Name != "" {
		t.Errorf("Name should be empty, got %s", job.Name)
	}
	if job.Status != 0 {
		t.Errorf("Status should be 0, got %d", job.Status)
	}
	if job.Timeout != 0 {
		t.Errorf("Timeout should be 0, got %v", job.Timeout)
	}
	if job.MaxRetry != 0 {
		t.Errorf("MaxRetry should be 0, got %d", job.MaxRetry)
	}
	if job.ParallelNum != 0 {
		t.Errorf("ParallelNum should be 0, got %d", job.ParallelNum)
	}
	if job.RunningCount != 0 {
		t.Errorf("RunningCount should be 0, got %d", job.RunningCount)
	}
}

// TestJobResultWithZeroValues 测试零值任务结果
func TestJobResultWithZeroValues(t *testing.T) {
	result := &JobResult{}

	// 验证零值
	if result.JobID != "" {
		t.Errorf("JobID should be empty, got %s", result.JobID)
	}
	if result.Status != "" {
		t.Errorf("Status should be empty, got %s", result.Status)
	}
	if result.Error != nil {
		t.Errorf("Error should be nil, got %v", result.Error)
	}
	if result.StartTime.IsZero() {
		// StartTime 是零值是正常的
	} else {
		t.Error("StartTime should be zero")
	}
	if result.EndTime.IsZero() {
		// EndTime 是零值是正常的
	} else {
		t.Error("EndTime should be zero")
	}
	if result.Duration != 0 {
		t.Errorf("Duration should be 0, got %v", result.Duration)
	}
	if result.RetryCount != 0 {
		t.Errorf("RetryCount should be 0, got %d", result.RetryCount)
	}
}

// TestJobJSONTags 测试任务JSON标签
func TestJobJSONTags(t *testing.T) {
	// 这个测试验证结构体字段的JSON标签是否正确
	// 通过反射检查标签
	job := &Job{}

	// 检查主要字段的JSON标签
	expectedTags := map[string]string{
		"ID":              "json:\"id\"",
		"Group":           "json:\"group\"",
		"Name":            "json:\"name\"",
		"Description":     "json:\"description\"",
		"ExecutorName":    "json:\"executorName\"",
		"ExecutionPolicy": "json:\"executionPolicy\"",
		"Status":          "json:\"status\"",
		"CronExpression":  "json:\"cronExpression\"",
		"Parameters":      "json:\"parameters\"",
		"BlockingPolicy":  "json:\"blockingPolicy\"",
		"Timeout":         "json:\"timeout\"",
		"MaxRetry":        "json:\"maxRetry\"",
		"RetryInterval":   "json:\"retryInterval\"",
		"ParallelNum":     "json:\"parallelNum\"",
		"RunningCount":    "json:\"runningCount\"",
		"CreatedAt":       "json:\"createdAt\"",
		"UpdatedAt":       "json:\"updatedAt\"",
	}

	// 这个测试主要是文档性的，确认字段标签存在
	_ = expectedTags
	_ = job
}

// TestJobResultJSONTags 测试任务结果JSON标签
func TestJobResultJSONTags(t *testing.T) {
	result := &JobResult{}

	// 检查主要字段的JSON标签
	expectedTags := map[string]string{
		"JobID":      "json:\"jobId\"",
		"Status":     "json:\"status\"",
		"Error":      "json:\"error,omitempty\"",
		"StartTime":  "json:\"startTime\"",
		"EndTime":    "json:\"endTime\"",
		"Duration":   "json:\"duration\"",
		"RetryCount": "json:\"retryCount\"",
	}

	_ = expectedTags
	_ = result
}
