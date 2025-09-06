package cachehelper

import (
	"container/heap"
	"context"
	"gin-fast/app/global/app"
	"sync"
	"time"
)

// memoryHelper 内存缓存助手实现
type memoryHelper struct {
	data        map[string]*cacheItem // 快速查找
	expiryQueue expiryHeap            // 按过期时间排序的最小堆
	mutex       sync.RWMutex
	ctx         context.Context
	stopChan    chan struct{}
	cleanupTick *time.Timer
}

// cacheItem 缓存项结构
type cacheItem struct {
	key        string // 添加键字段
	value      interface{}
	expiration time.Time
	index      int // 在堆中的索引
}

// expiryHeap 过期时间最小堆
type expiryHeap []*cacheItem

func (h expiryHeap) Len() int           { return len(h) }
func (h expiryHeap) Less(i, j int) bool { return h[i].expiration.Before(h[j].expiration) }
func (h expiryHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i]; h[i].index = i; h[j].index = j }

func (h *expiryHeap) Push(x interface{}) {
	n := len(*h)
	item := x.(*cacheItem)
	item.index = n
	*h = append(*h, item)
}

func (h *expiryHeap) Pop() interface{} {
	old := *h
	n := len(old)
	item := old[n-1]
	old[n-1] = nil
	item.index = -1
	*h = old[0 : n-1]
	return item
}

// NewMemoryHelper 创建内存缓存助手实例
func NewMemoryHelper() app.CacheInterf {
	mh := &memoryHelper{
		data:     make(map[string]*cacheItem),
		ctx:      context.Background(),
		stopChan: make(chan struct{}),
	}

	// 启动后台清理goroutine
	mh.startCleanup()
	return mh
}

func (m *memoryHelper) Set(ctx context.Context, key string, value string, expiration time.Duration) error {
	return m.SetVal(ctx, key, value, expiration)

}

// Set 设置键值对，并指定过期时间
func (m *memoryHelper) SetVal(ctx context.Context, key string, value interface{}, expiration time.Duration) error {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	expirationTime := time.Now().Add(expiration)
	item := &cacheItem{
		key:        key,
		value:      value,
		expiration: expirationTime,
	}

	// 如果键已存在，先从堆中移除
	if oldItem, exists := m.data[key]; exists {
		heap.Remove(&m.expiryQueue, oldItem.index)
	}

	m.data[key] = item
	heap.Push(&m.expiryQueue, item)

	// 如果新项的过期时间最早，重置定时器
	if m.expiryQueue.Len() > 0 && m.expiryQueue[0] == item {
		m.resetCleanupTimer()
	}

	return nil
}

func (m *memoryHelper) Get(ctx context.Context, key string) (string, error) {
	val, err := m.GetVal(ctx, key)
	if err != nil {
		return "", err
	}
	if val == nil {
		return "", nil
	}
	return val.(string), nil
}

// Get 获取键值
func (m *memoryHelper) GetVal(ctx context.Context, key string) (interface{}, error) {
	m.mutex.RLock()
	defer m.mutex.RUnlock()

	item, exists := m.data[key]
	if !exists {
		return nil, nil
	}

	// 检查是否过期
	if time.Now().After(item.expiration) {
		return nil, nil
	}

	return item.value, nil
}

// Del 删除键
func (m *memoryHelper) Del(ctx context.Context, keys ...string) error {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	for _, key := range keys {
		if item, exists := m.data[key]; exists {
			heap.Remove(&m.expiryQueue, item.index)
			delete(m.data, key)
		}
	}

	// 删除后可能需要重置定时器
	if m.expiryQueue.Len() > 0 {
		m.resetCleanupTimer()
	}

	return nil
}

// Exists 检查键是否存在
func (m *memoryHelper) Exists(ctx context.Context, keys ...string) (int64, error) {
	m.mutex.RLock()
	defer m.mutex.RUnlock()

	count := int64(0)
	for _, key := range keys {
		if item, exists := m.data[key]; exists {
			// 检查是否过期
			if time.Now().After(item.expiration) {
				continue
			}
			count++
		}
	}
	return count, nil
}

// Expire 设置键的过期时间
func (m *memoryHelper) Expire(ctx context.Context, key string, expiration time.Duration) error {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	item, exists := m.data[key]
	if !exists {
		return nil
	}

	// 先从堆中移除
	heap.Remove(&m.expiryQueue, item.index)

	// 更新过期时间
	item.expiration = time.Now().Add(expiration)

	// 重新加入堆
	heap.Push(&m.expiryQueue, item)

	// 重置定时器
	m.resetCleanupTimer()

	return nil
}

// startCleanup 启动后台清理goroutine
func (m *memoryHelper) startCleanup() {
	m.resetCleanupTimer()
	go func() {
		for {
			select {
			case <-m.cleanupTick.C:
				m.cleanupExpired()
			case <-m.stopChan:
				if m.cleanupTick != nil {
					m.cleanupTick.Stop()
				}
				return
			}
		}
	}()
}

// resetCleanupTimer 重置清理定时器
func (m *memoryHelper) resetCleanupTimer() {
	if m.cleanupTick != nil {
		m.cleanupTick.Stop()
	}

	if m.expiryQueue.Len() == 0 {
		// 没有数据，设置一个较长的定时器
		m.cleanupTick = time.NewTimer(1 * time.Hour)
		return
	}

	nextExpiry := m.expiryQueue[0].expiration
	now := time.Now()
	if nextExpiry.Before(now) {
		// 已经过期，立即清理
		m.cleanupTick = time.NewTimer(0)
	} else {
		// 设置定时器到下一个过期时间
		m.cleanupTick = time.NewTimer(nextExpiry.Sub(now))
	}
}

// cleanupExpired 清理过期数据
func (m *memoryHelper) cleanupExpired() {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	now := time.Now()
	for m.expiryQueue.Len() > 0 {
		item := m.expiryQueue[0]
		if now.Before(item.expiration) {
			break
		}

		// 从堆中移除
		heap.Pop(&m.expiryQueue)
		// 从map中移除
		delete(m.data, item.key)
	}

	// 重置定时器
	m.resetCleanupTimer()
}

// Close 关闭连接
func (m *memoryHelper) Close() error {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	// 停止清理goroutine
	close(m.stopChan)

	// 清空所有数据
	m.data = make(map[string]*cacheItem)
	m.expiryQueue = expiryHeap{}

	return nil
}
