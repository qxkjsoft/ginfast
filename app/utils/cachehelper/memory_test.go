package cachehelper

import (
	"context"
	"errors"
	"gin-fast/app/global/app"
	"reflect"
	"sync"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestMemoryHelper_GetAll(t *testing.T) {
	// 创建内存缓存实例
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	// 设置一些测试数据
	err := cache.Set(ctx, "key1", "value1", time.Minute)
	assert.NoError(t, err)

	err = cache.Set(ctx, "key2", "value2", time.Minute)
	assert.NoError(t, err)

	// 设置一个即将过期的项
	err = cache.Set(ctx, "key3", "value3", time.Millisecond*100)
	assert.NoError(t, err)

	// 等待key3过期
	time.Sleep(time.Millisecond * 150)

	// 获取所有缓存项
	items, err := cache.GetAll(ctx)
	assert.NoError(t, err)

	// 验证结果
	assert.Equal(t, 2, len(items))

	// 检查包含的项
	foundKey1 := false
	foundKey2 := false
	for _, item := range items {
		if item.Key == "key1" {
			assert.Equal(t, "value1", item.Value)
			foundKey1 = true
		} else if item.Key == "key2" {
			assert.Equal(t, "value2", item.Value)
			foundKey2 = true
		}
	}

	assert.True(t, foundKey1)
	assert.True(t, foundKey2)
}

// TestNewMemoryHelper 测试创建内存缓存助手
func TestNewMemoryHelper(t *testing.T) {
	cache := NewMemoryHelper()
	if cache == nil {
		t.Fatal("NewMemoryHelper() 返回 nil")
	}

	// 验证返回的是正确的接口类型
	// 由于 NewMemoryHelper() 已经返回了 app.CacheInterf 接口类型，无需类型断言
	_ = cache
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

	// 获取应该返回 ErrKeyNotFound
	result, err = cache.Get(ctx, key)
	if !errors.Is(err, app.ErrKeyNotFound) {
		t.Fatalf("Get() after expiry error = %v, want ErrKeyNotFound", err)
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
		if i < 2 {
			// 前两个应该被删除，返回 ErrKeyNotFound
			if !errors.Is(err, app.ErrKeyNotFound) {
				t.Errorf("Get() deleted key %s error = %v, want ErrKeyNotFound", key, err)
			}
		} else {
			// 第三个应该还存在
			if err != nil {
				t.Fatalf("Get() error = %v", err)
			}
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
	if !errors.Is(err, app.ErrKeyNotFound) {
		t.Fatalf("Get() after re-expire error = %v, want ErrKeyNotFound", err)
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
		if !errors.Is(err, app.ErrKeyNotFound) {
			t.Errorf("Get() key %s error = %v, want ErrKeyNotFound", key, err)
		}
		if value != "" {
			t.Errorf("Expected key %s to be expired, but got value: %v", key, value)
		}
	}
}

// TestMemoryHelper_SetVal_NeverExpire 测试 expiration < 0 时永不过期
func TestMemoryHelper_SetVal_NeverExpire(t *testing.T) {
	cache := NewMemoryHelper().(*memoryHelper)
	defer cache.Close()

	ctx := context.Background()

	// 用 -1 设置永不过期
	err := cache.SetVal(ctx, "forever_key", "forever_value", -1)
	assert.NoError(t, err)

	// 验证值存在
	val, err := cache.GetVal(ctx, "forever_key")
	assert.NoError(t, err)
	assert.Equal(t, "forever_value", val)

	// 验证不在过期堆中
	cache.mutex.RLock()
	item := cache.data["forever_key"]
	assert.True(t, item.expiration.IsZero(), "永不过期的项 expiration 应为零值")
	queueLen := cache.expiryQueue.Len()
	cache.mutex.RUnlock()
	assert.Equal(t, 0, queueLen, "永不过期的项不应加入过期堆")

	// 等待一段时间后仍然存在
	time.Sleep(50 * time.Millisecond)
	val, err = cache.GetVal(ctx, "forever_key")
	assert.NoError(t, err)
	assert.Equal(t, "forever_value", val)

	// Exists 也应该返回 1
	count, err := cache.Exists(ctx, "forever_key")
	assert.NoError(t, err)
	assert.Equal(t, int64(1), count)
}

// TestMemoryHelper_Expire_Negative_DeletesKey 测试 Expire 传入负数时立即删除键
func TestMemoryHelper_Expire_Negative_DeletesKey(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	// 设置一个正常的键
	err := cache.Set(ctx, "to_delete", "value", 5*time.Second)
	assert.NoError(t, err)

	// 用 -1 调用 Expire 应立即删除
	err = cache.Expire(ctx, "to_delete", -1)
	assert.NoError(t, err)

	// 验证键已被删除
	result, err := cache.Get(ctx, "to_delete")
	assert.ErrorIs(t, err, app.ErrKeyNotFound)
	assert.Equal(t, "", result)

	// 对永不过期的键调用 Expire(-1) 也应删除
	err = cache.Set(ctx, "forever_del", "value", -1)
	assert.NoError(t, err)

	err = cache.Expire(ctx, "forever_del", -1)
	assert.NoError(t, err)

	result, err = cache.Get(ctx, "forever_del")
	assert.ErrorIs(t, err, app.ErrKeyNotFound)
	assert.Equal(t, "", result)
}

// TestMemoryHelper_Del_NeverExpire 测试删除永不过期的键（不在堆中）
func TestMemoryHelper_Del_NeverExpire(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	// 设置永不过期的键
	err := cache.Set(ctx, "forever1", "v1", -1)
	assert.NoError(t, err)
	err = cache.Set(ctx, "forever2", "v2", -1)
	assert.NoError(t, err)

	// 删除不应 panic
	err = cache.Del(ctx, "forever1", "forever2", "nonexistent")
	assert.NoError(t, err)

	// 验证已删除
	count, err := cache.Exists(ctx, "forever1", "forever2")
	assert.NoError(t, err)
	assert.Equal(t, int64(0), count)
}

// TestMemoryHelper_GetAll_WithNeverExpire 测试 GetAll 包含永不过期的项
func TestMemoryHelper_GetAll_WithNeverExpire(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	err := cache.Set(ctx, "normal", "v1", time.Minute)
	assert.NoError(t, err)
	err = cache.Set(ctx, "forever", "v2", -1)
	assert.NoError(t, err)
	err = cache.Set(ctx, "expiring", "v3", 50*time.Millisecond)
	assert.NoError(t, err)

	// 等待 expiring 过期
	time.Sleep(100 * time.Millisecond)

	items, err := cache.GetAll(ctx)
	assert.NoError(t, err)
	assert.Equal(t, 2, len(items))

	keys := make(map[string]bool)
	for _, item := range items {
		keys[item.Key] = true
	}
	assert.True(t, keys["normal"])
	assert.True(t, keys["forever"])
	assert.False(t, keys["expiring"])
}

// TestMemoryHelper_SetVal_UpdateFromNeverExpire 测试从永不过期更新为有过期时间
func TestMemoryHelper_SetVal_UpdateFromNeverExpire(t *testing.T) {
	cache := NewMemoryHelper().(*memoryHelper)
	defer cache.Close()

	ctx := context.Background()

	// 先设置永不过期
	err := cache.SetVal(ctx, "key", "v1", -1)
	assert.NoError(t, err)

	// 更新为有过期时间
	err = cache.SetVal(ctx, "key", "v2", 50*time.Millisecond)
	assert.NoError(t, err)

	// 验证值已更新
	val, err := cache.GetVal(ctx, "key")
	assert.NoError(t, err)
	assert.Equal(t, "v2", val)

	// 验证已加入过期堆
	cache.mutex.RLock()
	queueLen := cache.expiryQueue.Len()
	cache.mutex.RUnlock()
	assert.Equal(t, 1, queueLen)

	// 等待过期
	time.Sleep(100 * time.Millisecond)
	val, err = cache.GetVal(ctx, "key")
	assert.NoError(t, err)
	assert.Nil(t, val)
}

// TestMemoryHelper_Expire_FromNeverExpire 测试给永不过期的键设置过期时间
func TestMemoryHelper_Expire_FromNeverExpire(t *testing.T) {
	cache := NewMemoryHelper().(*memoryHelper)
	defer cache.Close()

	ctx := context.Background()

	// 设置永不过期
	err := cache.SetVal(ctx, "key", "value", -1)
	assert.NoError(t, err)

	// 设置过期时间
	err = cache.Expire(ctx, "key", 50*time.Millisecond)
	assert.NoError(t, err)

	// 验证已加入堆
	cache.mutex.RLock()
	queueLen := cache.expiryQueue.Len()
	cache.mutex.RUnlock()
	assert.Equal(t, 1, queueLen)

	// 立即获取应该成功
	val, err := cache.GetVal(ctx, "key")
	assert.NoError(t, err)
	assert.Equal(t, "value", val)

	// 等待过期
	time.Sleep(100 * time.Millisecond)
	val, err = cache.GetVal(ctx, "key")
	assert.NoError(t, err)
	assert.Nil(t, val)
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

// TestMemoryHelper_SetInt_GetInt 测试整数类型的写入与读取
func TestMemoryHelper_SetInt_GetInt(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	// 正常写入与读取
	err := cache.SetInt(ctx, "int_key", 42, 5*time.Second)
	assert.NoError(t, err)

	v, err := cache.GetInt(ctx, "int_key")
	assert.NoError(t, err)
	assert.Equal(t, int64(42), v)

	// 负数
	err = cache.SetInt(ctx, "neg_key", -7, 5*time.Second)
	assert.NoError(t, err)
	v, err = cache.GetInt(ctx, "neg_key")
	assert.NoError(t, err)
	assert.Equal(t, int64(-7), v)

	// 零值
	err = cache.SetInt(ctx, "zero_key", 0, 5*time.Second)
	assert.NoError(t, err)
	v, err = cache.GetInt(ctx, "zero_key")
	assert.NoError(t, err)
	assert.Equal(t, int64(0), v)

	// 不存在的 key 返回 ErrKeyNotFound
	v, err = cache.GetInt(ctx, "no_such_key")
	assert.ErrorIs(t, err, app.ErrKeyNotFound)
	assert.Equal(t, int64(0), v)

	// 永不过期（expiration < 0）的项也应能正常读写
	err = cache.SetInt(ctx, "forever_int", 100, -1)
	assert.NoError(t, err)
	v, err = cache.GetInt(ctx, "forever_int")
	assert.NoError(t, err)
	assert.Equal(t, int64(100), v)
}

// TestMemoryHelper_GetInt_ExpiredKey 测试 GetInt 对已过期键返回 ErrKeyNotFound
func TestMemoryHelper_GetInt_ExpiredKey(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	err := cache.SetInt(ctx, "exp_int", 99, 50*time.Millisecond)
	assert.NoError(t, err)

	v, err := cache.GetInt(ctx, "exp_int")
	assert.NoError(t, err)
	assert.Equal(t, int64(99), v)

	time.Sleep(100 * time.Millisecond)

	v, err = cache.GetInt(ctx, "exp_int")
	assert.ErrorIs(t, err, app.ErrKeyNotFound)
	assert.Equal(t, int64(0), v, "过期键应返回 0")
}

// TestMemoryHelper_GetInt_FromString 测试 GetInt 能解析由 Set 写入的数字字符串
func TestMemoryHelper_GetInt_FromString(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	err := cache.Set(ctx, "str_num", "12345", 5*time.Second)
	assert.NoError(t, err)

	v, err := cache.GetInt(ctx, "str_num")
	assert.NoError(t, err)
	assert.Equal(t, int64(12345), v)
}

// TestMemoryHelper_GetInt_NotInteger 测试 GetInt 对非整数值返回错误
func TestMemoryHelper_GetInt_NotInteger(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	err := cache.Set(ctx, "not_int", "hello", 5*time.Second)
	assert.NoError(t, err)

	_, err = cache.GetInt(ctx, "not_int")
	assert.Error(t, err, "非整数值应返回错误")
}

// TestMemoryHelper_Incr 测试 Incr 的基本行为
func TestMemoryHelper_Incr(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	// 不存在的 key，按 0 处理 → 加 1 后为 1
	v, err := cache.Incr(ctx, "counter")
	assert.NoError(t, err)
	assert.Equal(t, int64(1), v)

	// 再次加 1 → 2
	v, err = cache.Incr(ctx, "counter")
	assert.NoError(t, err)
	assert.Equal(t, int64(2), v)

	// 第三次 → 3
	v, err = cache.Incr(ctx, "counter")
	assert.NoError(t, err)
	assert.Equal(t, int64(3), v)

	// 验证 GetInt 能正确读取
	got, err := cache.GetInt(ctx, "counter")
	assert.NoError(t, err)
	assert.Equal(t, int64(3), got)
}

// TestMemoryHelper_Decr 测试 Decr 的基本行为
func TestMemoryHelper_Decr(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	// 不存在的 key，按 0 处理 → 减 1 后为 -1
	v, err := cache.Decr(ctx, "dcounter")
	assert.NoError(t, err)
	assert.Equal(t, int64(-1), v)

	// 再次减 1 → -2
	v, err = cache.Decr(ctx, "dcounter")
	assert.NoError(t, err)
	assert.Equal(t, int64(-2), v)
}

// TestMemoryHelper_IncrDecr_Combined 测试 Incr 与 Decr 交替使用
func TestMemoryHelper_IncrDecr_Combined(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	v, err := cache.Incr(ctx, "x")
	assert.NoError(t, err)
	assert.Equal(t, int64(1), v)

	v, err = cache.Incr(ctx, "x")
	assert.NoError(t, err)
	assert.Equal(t, int64(2), v)

	v, err = cache.Decr(ctx, "x")
	assert.NoError(t, err)
	assert.Equal(t, int64(1), v)

	v, err = cache.Decr(ctx, "x")
	assert.NoError(t, err)
	assert.Equal(t, int64(0), v)

	v, err = cache.Decr(ctx, "x")
	assert.NoError(t, err)
	assert.Equal(t, int64(-1), v)
}

// TestMemoryHelper_Incr_PreservesExpiration 测试 Incr 应保留原有过期时间
func TestMemoryHelper_Incr_PreservesExpiration(t *testing.T) {
	cache := NewMemoryHelper().(*memoryHelper)
	defer cache.Close()

	ctx := context.Background()

	err := cache.SetInt(ctx, "ttl_counter", 10, 50*time.Millisecond)
	assert.NoError(t, err)

	v, err := cache.Incr(ctx, "ttl_counter")
	assert.NoError(t, err)
	assert.Equal(t, int64(11), v)

	// 验证过期时间非零（在堆中）
	cache.mutex.RLock()
	item := cache.data["ttl_counter"]
	exp := item.expiration
	cache.mutex.RUnlock()
	assert.False(t, exp.IsZero(), "Incr 应保留原有过期时间")

	// 等待过期
	time.Sleep(100 * time.Millisecond)

	got, err := cache.GetInt(ctx, "ttl_counter")
	assert.ErrorIs(t, err, app.ErrKeyNotFound)
	assert.Equal(t, int64(0), got, "键应已过期")
}

// TestMemoryHelper_Incr_ExpiredKey 测试对已过期 key 执行 Incr 按 0 处理
func TestMemoryHelper_Incr_ExpiredKey(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	err := cache.SetInt(ctx, "exp_counter", 100, 50*time.Millisecond)
	assert.NoError(t, err)

	time.Sleep(100 * time.Millisecond)

	v, err := cache.Incr(ctx, "exp_counter")
	assert.NoError(t, err)
	assert.Equal(t, int64(1), v, "已过期 key 的 Incr 应从 0 开始")
}

// TestMemoryHelper_Incr_NonIntegerValue 测试对非整数值执行 Incr 应返回错误
func TestMemoryHelper_Incr_NonIntegerValue(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	err := cache.Set(ctx, "str_key", "not-a-number", 5*time.Second)
	assert.NoError(t, err)

	_, err = cache.Incr(ctx, "str_key")
	assert.Error(t, err, "对非整数值执行 Incr 应返回错误")
}

// TestMemoryHelper_Incr_FromNumericString 测试对数字字符串执行 Incr 应成功
func TestMemoryHelper_Incr_FromNumericString(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()

	err := cache.Set(ctx, "str_counter", "10", 5*time.Second)
	assert.NoError(t, err)

	v, err := cache.Incr(ctx, "str_counter")
	assert.NoError(t, err)
	assert.Equal(t, int64(11), v)
}

// TestMemoryHelper_Incr_Concurrent 测试 Incr 的并发安全性
func TestMemoryHelper_Incr_Concurrent(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()

	ctx := context.Background()
	key := "concurrent_counter"

	goroutines := 10
	opsPerGoroutine := 100
	var wg sync.WaitGroup
	wg.Add(goroutines)
	for i := 0; i < goroutines; i++ {
		go func() {
			defer wg.Done()
			for j := 0; j < opsPerGoroutine; j++ {
				_, _ = cache.Incr(ctx, key)
			}
		}()
	}
	wg.Wait()

	v, err := cache.GetInt(ctx, key)
	assert.NoError(t, err)
	assert.Equal(t, int64(goroutines*opsPerGoroutine), v, "并发 Incr 结果应为 goroutines * opsPerGoroutine")
}

// TestToInt64 测试 toInt64 辅助函数对各种类型的处理
func TestToInt64(t *testing.T) {
	tests := []struct {
		name   string
		input  interface{}
		want   int64
		wantOk bool
	}{
		{"int64", int64(42), 42, true},
		{"int", int(7), 7, true},
		{"int32", int32(-3), -3, true},
		{"numeric string", "12345", 12345, true},
		{"negative numeric string", "-9", -9, true},
		{"non-numeric string", "hello", 0, false},
		{"empty string", "", 0, false},
		{"float64", float64(1.5), 0, false},
		{"bool", true, 0, false},
		{"nil", nil, 0, false},
		{"slice", []int{1, 2}, 0, false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, ok := toInt64(tt.input)
			assert.Equal(t, tt.wantOk, ok)
			if tt.wantOk {
				assert.Equal(t, tt.want, got)
			}
		})
	}
}
