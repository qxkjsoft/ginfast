package cachehelper

import (
	"context"
	"gin-fast/app/global/app"
	"reflect"
	"sync"
	"testing"
	"time"
)

// TestNewMemoryHelper 测试创建内存缓存助手
func TestNewMemoryHelper(t *testing.T) {
	cache := NewMemoryHelper()
	if cache == nil {
		t.Fatal("NewMemoryHelper() 返回 nil")
	}

	// 验证返回的是正确的接口类型
	_, ok := cache.(app.CacheInterf)
	if !ok {
		t.Fatal("NewMemoryHelper() 返回的不是 CacheInterf 接口")
	}
}

// TestMemoryHelper_SetAndGet 测试设置和获取操作
func TestMemoryHelper_SetAndGet(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	tests := []struct {
		name       string
		key        string
		value      string
		expiration time.Duration
		wantErr    bool
	}{
		{
			name:       "正常设置和获取",
			key:        "test_key",
			value:      "test_value",
			expiration: 5 * time.Second,
			wantErr:    false,
		},
		{
			name:       "空键设置",
			key:        "",
			value:      "test_value",
			expiration: 5 * time.Second,
			wantErr:    false,
		},
		{
			name:       "空值设置",
			key:        "empty_value_key",
			value:      "",
			expiration: 5 * time.Second,
			wantErr:    false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := cache.Set(ctx, tt.key, tt.value, tt.expiration)
			if (err != nil) != tt.wantErr {
				t.Errorf("Set() error = %v, wantErr %v", err, tt.wantErr)
				return
			}

			if !tt.wantErr {
				value, err := cache.Get(ctx, tt.key)
				if err != nil {
					t.Errorf("Get() error = %v", err)
					return
				}
				if value != tt.value {
					t.Errorf("Get() = %v, want %v", value, tt.value)
				}
			}
		})
	}
}

// TestMemoryHelper_SetVal 测试设置任意类型值
func TestMemoryHelper_SetVal(t *testing.T) {
	cache := NewMemoryHelper().(*memoryHelper)
	defer cache.Close()

	ctx := context.Background()

	tests := []struct {
		name       string
		key        string
		value      interface{}
		expiration time.Duration
		wantErr    bool
	}{
		{
			name:       "设置字符串",
			key:        "string_key",
			value:      "string_value",
			expiration: 5 * time.Second,
			wantErr:    false,
		},
		{
			name:       "设置整数",
			key:        "int_key",
			value:      123,
			expiration: 5 * time.Second,
			wantErr:    false,
		},
		{
			name:       "设置map",
			key:        "map_key",
			value:      map[string]interface{}{"test": "value"},
			expiration: 5 * time.Second,
			wantErr:    false,
		},
		{
			name:       "设置nil值",
			key:        "nil_key",
			value:      nil,
			expiration: 5 * time.Second,
			wantErr:    false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := cache.SetVal(ctx, tt.key, tt.value, tt.expiration)
			if (err != nil) != tt.wantErr {
				t.Errorf("SetVal() error = %v, wantErr %v", err, tt.wantErr)
				return
			}

			if !tt.wantErr {
				value, err := cache.GetVal(ctx, tt.key)
				if err != nil {
					t.Errorf("GetVal() error = %v", err)
					return
				}
				// 对于nil值的特殊处理
				if tt.value == nil {
					if value != nil {
						t.Errorf("GetVal() = %v, want nil", value)
					}
				} else if !reflect.DeepEqual(value, tt.value) {
					t.Errorf("GetVal() = %v, want %v", value, tt.value)
				}
			}
		})
	}
}

// TestMemoryHelper_Expiration 测试过期功能
func TestMemoryHelper_Expiration(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()
	key := "expire_test_key"
	value := "expire_test_value"

	// 设置短过期时间
	err := cache.Set(ctx, key, value, 100*time.Millisecond)
	if err != nil {
		t.Fatalf("Set() error = %v", err)
	}

	// 立即获取应该成功
	result, err := cache.Get(ctx, key)
	if err != nil {
		t.Fatalf("Get() error = %v", err)
	}
	if result != value {
		t.Errorf("Get() = %v, want %v", result, value)
	}

	// 等待过期
	time.Sleep(150 * time.Millisecond)

	// 获取应该返回空值
	result, err = cache.Get(ctx, key)
	if err != nil {
		t.Fatalf("Get() after expiry error = %v", err)
	}
	if result != "" {
		t.Errorf("Get() after expiry = %v, want empty string", result)
	}
}

// TestMemoryHelper_Del 测试删除操作
func TestMemoryHelper_Del(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	// 设置多个键值对
	keys := []string{"del_key1", "del_key2", "del_key3"}
	for i, key := range keys {
		err := cache.Set(ctx, key, "value"+string(rune('1'+i)), 5*time.Second)
		if err != nil {
			t.Fatalf("Set() error = %v", err)
		}
	}

	// 删除部分键
	err := cache.Del(ctx, keys[0], keys[1])
	if err != nil {
		t.Fatalf("Del() error = %v", err)
	}

	// 验证删除结果
	for i, key := range keys {
		value, err := cache.Get(ctx, key)
		if err != nil {
			t.Fatalf("Get() error = %v", err)
		}
		if i < 2 {
			// 前两个应该被删除
			if value != "" {
				t.Errorf("Get() deleted key %s = %v, want empty", key, value)
			}
		} else {
			// 第三个应该还存在
			expectedValue := "value" + string(rune('1'+i))
			if value != expectedValue {
				t.Errorf("Get() existing key %s = %v, want %v", key, value, expectedValue)
			}
		}
	}

	// 删除不存在的键应该不报错
	err = cache.Del(ctx, "non_existent_key")
	if err != nil {
		t.Errorf("Del() non-existent key error = %v", err)
	}
}

// TestMemoryHelper_Exists 测试存在性检查
func TestMemoryHelper_Exists(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	// 设置一些键值对
	keys := []string{"exist_key1", "exist_key2", "expire_key"}
	for _, key := range keys {
		var expiration time.Duration
		if key == "expire_key" {
			expiration = 50 * time.Millisecond // 短过期时间
		} else {
			expiration = 5 * time.Second
		}
		err := cache.Set(ctx, key, "value", expiration)
		if err != nil {
			t.Fatalf("Set() error = %v", err)
		}
	}

	// 测试存在的键
	count, err := cache.Exists(ctx, "exist_key1", "exist_key2")
	if err != nil {
		t.Fatalf("Exists() error = %v", err)
	}
	if count != 2 {
		t.Errorf("Exists() existing keys = %v, want 2", count)
	}

	// 测试混合情况（存在和不存在的键）
	count, err = cache.Exists(ctx, "exist_key1", "non_existent_key", "exist_key2")
	if err != nil {
		t.Fatalf("Exists() error = %v", err)
	}
	if count != 2 {
		t.Errorf("Exists() mixed keys = %v, want 2", count)
	}

	// 等待过期键过期
	time.Sleep(100 * time.Millisecond)

	// 测试过期键
	count, err = cache.Exists(ctx, "expire_key")
	if err != nil {
		t.Fatalf("Exists() error = %v", err)
	}
	if count != 0 {
		t.Errorf("Exists() expired key = %v, want 0", count)
	}
}

// TestMemoryHelper_Expire 测试重新设置过期时间
func TestMemoryHelper_Expire(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()
	key := "expire_reset_key"
	value := "expire_reset_value"

	// 设置较长的过期时间
	err := cache.Set(ctx, key, value, 5*time.Second)
	if err != nil {
		t.Fatalf("Set() error = %v", err)
	}

	// 重新设置更短的过期时间
	err = cache.Expire(ctx, key, 100*time.Millisecond)
	if err != nil {
		t.Fatalf("Expire() error = %v", err)
	}

	// 立即获取应该成功
	result, err := cache.Get(ctx, key)
	if err != nil {
		t.Fatalf("Get() error = %v", err)
	}
	if result != value {
		t.Errorf("Get() = %v, want %v", result, value)
	}

	// 等待新的过期时间
	time.Sleep(150 * time.Millisecond)

	// 应该已经过期
	result, err = cache.Get(ctx, key)
	if err != nil {
		t.Fatalf("Get() after re-expire error = %v", err)
	}
	if result != "" {
		t.Errorf("Get() after re-expire = %v, want empty", result)
	}

	// 对不存在的键设置过期时间应该不报错
	err = cache.Expire(ctx, "non_existent_key", 1*time.Second)
	if err != nil {
		t.Errorf("Expire() non-existent key error = %v", err)
	}
}

// TestMemoryHelper_ConcurrentAccess 测试并发访问安全性
func TestMemoryHelper_ConcurrentAccess(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()
	var wg sync.WaitGroup
	numGoroutines := 10
	numOperations := 100

	// 并发写入
	wg.Add(numGoroutines)
	for i := 0; i < numGoroutines; i++ {
		go func(id int) {
			defer wg.Done()
			for j := 0; j < numOperations; j++ {
				key := "concurrent_key_" + string(rune('0'+id)) + "_" + string(rune('0'+j%10))
				value := "value_" + string(rune('0'+id)) + "_" + string(rune('0'+j%10))
				err := cache.Set(ctx, key, value, 1*time.Second)
				if err != nil {
					t.Errorf("Concurrent Set() error = %v", err)
				}
			}
		}(i)
	}
	wg.Wait()

	// 并发读取
	wg.Add(numGoroutines)
	for i := 0; i < numGoroutines; i++ {
		go func(id int) {
			defer wg.Done()
			for j := 0; j < numOperations; j++ {
				key := "concurrent_key_" + string(rune('0'+id)) + "_" + string(rune('0'+j%10))
				_, err := cache.Get(ctx, key)
				if err != nil {
					t.Errorf("Concurrent Get() error = %v", err)
				}
			}
		}(i)
	}
	wg.Wait()

	// 并发删除
	wg.Add(numGoroutines)
	for i := 0; i < numGoroutines; i++ {
		go func(id int) {
			defer wg.Done()
			for j := 0; j < numOperations/2; j++ {
				key := "concurrent_key_" + string(rune('0'+id)) + "_" + string(rune('0'+j%10))
				err := cache.Del(ctx, key)
				if err != nil {
					t.Errorf("Concurrent Del() error = %v", err)
				}
			}
		}(i)
	}
	wg.Wait()
}

// TestMemoryHelper_UpdateExistingKey 测试更新已存在的键
func TestMemoryHelper_UpdateExistingKey(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()
	key := "update_key"

	// 首次设置
	err := cache.Set(ctx, key, "original_value", 5*time.Second)
	if err != nil {
		t.Fatalf("First Set() error = %v", err)
	}

	// 更新值
	err = cache.Set(ctx, key, "updated_value", 5*time.Second)
	if err != nil {
		t.Fatalf("Update Set() error = %v", err)
	}

	// 验证更新后的值
	value, err := cache.Get(ctx, key)
	if err != nil {
		t.Fatalf("Get() after update error = %v", err)
	}
	if value != "updated_value" {
		t.Errorf("Get() after update = %v, want %v", value, "updated_value")
	}
}

// TestMemoryHelper_Close 测试关闭操作
func TestMemoryHelper_Close(t *testing.T) {
	cache := NewMemoryHelper()

	ctx := context.Background()

	// 设置一些数据
	err := cache.Set(ctx, "close_test_key", "close_test_value", 5*time.Second)
	if err != nil {
		t.Fatalf("Set() before close error = %v", err)
	}

	// 关闭缓存
	err = cache.Close()
	if err != nil {
		t.Fatalf("Close() error = %v", err)
	}

	// 关闭后数据应该被清空
	// 注意：由于Close()后goroutine被停止，我们需要小心测试
	// 这里主要测试Close()方法本身不报错
}

// TestMemoryHelper_AutoCleanup 测试自动清理功能
func TestMemoryHelper_AutoCleanup(t *testing.T) {
	cache := NewMemoryHelper().(*memoryHelper)
	defer cache.Close()

	ctx := context.Background()

	// 设置多个不同过期时间的键
	keys := []string{"cleanup_key1", "cleanup_key2", "cleanup_key3"}
	expirations := []time.Duration{50 * time.Millisecond, 100 * time.Millisecond, 200 * time.Millisecond}

	for i, key := range keys {
		err := cache.Set(ctx, key, "value", expirations[i])
		if err != nil {
			t.Fatalf("Set() key %s error = %v", key, err)
		}
	}

	// 验证初始状态
	cache.mutex.RLock()
	initialCount := len(cache.data)
	cache.mutex.RUnlock()

	if initialCount != 3 {
		t.Errorf("Initial data count = %v, want 3", initialCount)
	}

	// 等待所有键过期
	time.Sleep(250 * time.Millisecond)

	// 触发清理（通过访问来间接触发）
	for _, key := range keys {
		_, _ = cache.Get(ctx, key)
	}

	// 再等待一下让清理完成
	time.Sleep(50 * time.Millisecond)

	// 检查所有键都应该过期了
	for _, key := range keys {
		value, err := cache.Get(ctx, key)
		if err != nil {
			t.Errorf("Get() key %s error = %v", key, err)
		}
		if value != "" {
			t.Errorf("Expected key %s to be expired, but got value: %v", key, value)
		}
	}
}

// BenchmarkMemoryHelper_Set 性能测试：设置操作
func BenchmarkMemoryHelper_Set(b *testing.B) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		key := "bench_key_" + string(rune('0'+(i%10)))
		value := "bench_value_" + string(rune('0'+(i%10)))
		cache.Set(ctx, key, value, 1*time.Minute)
	}
}

// BenchmarkMemoryHelper_Get 性能测试：获取操作
func BenchmarkMemoryHelper_Get(b *testing.B) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	// 预设一些数据
	for i := 0; i < 100; i++ {
		key := "bench_key_" + string(rune('0'+(i%10)))
		value := "bench_value_" + string(rune('0'+(i%10)))
		cache.Set(ctx, key, value, 1*time.Minute)
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		key := "bench_key_" + string(rune('0'+(i%10)))
		cache.Get(ctx, key)
	}
}

// BenchmarkMemoryHelper_ConcurrentAccess 性能测试：并发访问
func BenchmarkMemoryHelper_ConcurrentAccess(b *testing.B) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	b.RunParallel(func(pb *testing.PB) {
		i := 0
		for pb.Next() {
			key := "concurrent_bench_key_" + string(rune('0'+(i%10)))
			value := "concurrent_bench_value_" + string(rune('0'+(i%10)))

			// 50% 写操作，50% 读操作
			if i%2 == 0 {
				cache.Set(ctx, key, value, 1*time.Minute)
			} else {
				cache.Get(ctx, key)
			}
			i++
		}
	})
}
