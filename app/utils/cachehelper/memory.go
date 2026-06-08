package cachehelper

import (
	"container/heap"
	"context"
	"errors"
	"gin-fast/app/global/app"
	"strconv"
	"sync"
	"time"
)

// memoryHelper 内存缓存助手实现
// 使用 map + 最小堆 的组合结构：
//   - map 提供 O(1) 的键值查找
//   - 最小堆按过期时间排序，配合定时器实现高效的过期清理
type memoryHelper struct {
	data        map[string]*cacheItem // 键 → 缓存项的映射表，用于 O(1) 查找
	expiryQueue expiryHeap            // 按过期时间排序的最小堆，堆顶是最近要过期的项
	mutex       sync.RWMutex          // 读写锁，保证并发安全；读操作用 RLock，写操作用 Lock
	ctx         context.Context       // 基础上下文（保留字段，当前未使用）
	stopChan    chan struct{}         // 关闭信号通道，用于通知后台清理 goroutine 退出
	cleanupTick *time.Timer           // 清理定时器，到期时触发 cleanupExpired 清理过期项
}

// cacheItem 缓存项结构
// 每个缓存键对应一个 cacheItem，同时记录过期时间和在堆中的位置
type cacheItem struct {
	key        string      // 缓存键，冗余存储以便从堆中反查 map 时能定位
	value      interface{} // 缓存值，支持任意类型
	expiration time.Time   // 过期时间点；零值（IsZero()==true）表示永不过期
	index      int         // 该项在 expiryHeap 中的索引，由堆操作维护，用于 heap.Remove
}

// expiryHeap 过期时间最小堆
// 实现 heap.Interface 接口，堆顶始终是过期时间最早的项
// 永不过期的项（expiration 为零值）不会被加入此堆
type expiryHeap []*cacheItem

// Len 返回堆中元素数量，heap.Interface 要求
func (h expiryHeap) Len() int { return len(h) }

// Less 比较两个元素的过期时间，越早过期的排在越前面（最小堆）
func (h expiryHeap) Less(i, j int) bool { return h[i].expiration.Before(h[j].expiration) }

// Swap 交换两个元素的位置，并同步更新它们的 index 字段
func (h expiryHeap) Swap(i, j int) { h[i], h[j] = h[j], h[i]; h[i].index = i; h[j].index = j }

// Push 向堆中添加一个元素（由 heap.Push 调用）
// 新元素追加到切片末尾，index 设为当前位置
func (h *expiryHeap) Push(x interface{}) {
	n := len(*h)           // 获取当前堆长度，即新元素的索引位置
	item := x.(*cacheItem) // 类型断言为缓存项指针
	item.index = n         // 记录该项在堆中的索引
	*h = append(*h, item)  // 追加到堆切片末尾
}

// Pop 从堆中弹出最后一个元素（由 heap.Pop 调用）
// 注意：heap.Pop 会先把堆顶和末尾交换，再调用此方法，所以这里取的是末尾元素
func (h *expiryHeap) Pop() interface{} {
	old := *h         // 获取当前堆切片
	n := len(old)     // 获取堆长度
	item := old[n-1]  // 取最后一个元素（即被弹出的项）
	old[n-1] = nil    // 置空引用，防止内存泄漏
	item.index = -1   // 标记索引为 -1，表示已不在堆中
	*h = old[0 : n-1] // 缩小堆切片，移除末尾元素
	return item       // 返回被弹出的缓存项
}

// NewMemoryHelper 创建内存缓存助手实例
// 初始化 map 和信号通道，并启动后台过期清理 goroutine
// 返回 CacheInterf 接口，可直接替代 Redis 缓存使用
func NewMemoryHelper() app.CacheInterf {
	mh := &memoryHelper{
		data:     make(map[string]*cacheItem), // 初始化空的键值映射表
		ctx:      context.Background(),        // 设置基础上下文
		stopChan: make(chan struct{}),         // 初始化关闭信号通道
	}

	// 启动后台清理 goroutine，定时清理过期缓存项
	mh.startCleanup()
	return mh // 返回接口类型，调用方无需关心底层实现
}

// Set 设置字符串类型的键值对，实现 CacheInterf 接口
// 内部委托给 SetVal 处理，将 string 类型的 value 自动装箱为 interface{}
func (m *memoryHelper) Set(ctx context.Context, key string, value string, expiration time.Duration) error {
	return m.SetVal(ctx, key, value, expiration) // 转发给 SetVal 统一处理
}

// SetVal 设置键值对，并指定过期时间
// expiration >= 0 时设置具体过期时间，并加入过期堆
// expiration < 0 表示永不过期（类似 Redis SET 不带 EX），不加入过期堆
func (m *memoryHelper) SetVal(ctx context.Context, key string, value interface{}, expiration time.Duration) error {
	m.mutex.Lock()         // 加写锁，保证并发安全
	defer m.mutex.Unlock() // 函数退出时释放锁

	item := &cacheItem{ // 创建新的缓存项
		key:   key,   // 设置键
		value: value, // 设置值
		// expiration 默认为零值（time.Time{}），表示永不过期
	}

	if expiration >= 0 { // 仅当过期时间非负时设置具体过期时间
		item.expiration = time.Now().Add(expiration) // 计算绝对过期时间点
	}

	// 如果键已存在，先从堆中移除旧项
	// 旧项可能是永不过期的（不在堆中），所以需要判断
	if oldItem, exists := m.data[key]; exists { // 检查旧键是否存在
		if !oldItem.expiration.IsZero() { // 旧项有过期时间，说明它在堆中
			heap.Remove(&m.expiryQueue, oldItem.index) // 从堆中移除旧项
		}
	}

	m.data[key] = item // 将新项写入 map（覆盖旧项）

	// 仅有过期时间的项才加入堆，永不过期的项不占堆空间
	if !item.expiration.IsZero() { // 该项有具体过期时间
		heap.Push(&m.expiryQueue, item) // 加入最小堆

		// 如果新项的过期时间最早（成为堆顶），需要重置定时器
		if m.expiryQueue.Len() > 0 && m.expiryQueue[0] == item { // 判断是否为堆顶
			m.resetCleanupTimer() // 重置定时器以匹配最近过期时间
		}
	}

	return nil // 操作成功
}

// Get 获取字符串类型的键值，实现 CacheInterf 接口
// 内部委托给 GetVal 获取值后做类型断言
// 键不存在或已过期时返回 ("", app.ErrKeyNotFound)
func (m *memoryHelper) Get(ctx context.Context, key string) (string, error) {
	val, err := m.GetVal(ctx, key) // 调用 GetVal 获取 interface{} 类型的值
	if err != nil {
		return "", err // 返回错误
	}
	if val == nil {
		return "", app.ErrKeyNotFound // 键不存在或已过期
	}
	return val.(string), nil // 类型断言为 string 并返回
}

// GetVal 获取键值，支持任意类型
// 键不存在或已过期返回 (nil, nil)
// 永不过期的项（expiration 为零值）不会被判定为过期
func (m *memoryHelper) GetVal(ctx context.Context, key string) (interface{}, error) {
	m.mutex.RLock()         // 加读锁，允许多个并发读
	defer m.mutex.RUnlock() // 函数退出时释放锁

	item, exists := m.data[key] // 从 map 中查找键
	if !exists {
		return nil, nil // 键不存在，返回 nil
	}

	// 零值表示永不过期，跳过过期检查
	// 仅当 expiration 非零且当前时间已超过过期时间时，才认为已过期
	if !item.expiration.IsZero() && time.Now().After(item.expiration) {
		return nil, nil // 已过期，返回 nil（惰性删除，由后台 goroutine 清理）
	}

	return item.value, nil // 返回缓存值
}

// Del 删除一个或多个键
// 支持同时删除多个键，不存在的键会被静默忽略
// 永不过期的项不在堆中，删除时跳过 heap.Remove 操作
func (m *memoryHelper) Del(ctx context.Context, keys ...string) error {
	m.mutex.Lock()         // 加写锁，保证并发安全
	defer m.mutex.Unlock() // 函数退出时释放锁

	for _, key := range keys { // 遍历所有要删除的键
		if item, exists := m.data[key]; exists { // 键存在才处理
			// 永不过期的项不在堆中，需要先判断再决定是否从堆中移除
			if !item.expiration.IsZero() { // 该项有具体过期时间，说明它在堆中
				heap.Remove(&m.expiryQueue, item.index) // 从堆中移除
			}
			delete(m.data, key) // 从 map 中删除
		}
	}

	// 删除后堆可能发生变化，需要重置定时器以匹配新的最近过期时间
	if m.expiryQueue.Len() > 0 { // 堆中还有元素才需要重置
		m.resetCleanupTimer() // 重置清理定时器
	}

	return nil // 操作成功
}

// Exists 检查一个或多个键是否存在
// 返回存在的键的数量（已过期的不算存在）
// 永不过期的项（expiration 为零值）始终被视为存在
func (m *memoryHelper) Exists(ctx context.Context, keys ...string) (int64, error) {
	m.mutex.RLock()         // 加读锁，允许多个并发读
	defer m.mutex.RUnlock() // 函数退出时释放锁

	count := int64(0)          // 计数器，记录存在的键数量
	for _, key := range keys { // 遍历所有要检查的键
		if item, exists := m.data[key]; exists { // 键在 map 中存在
			// 零值表示永不过期，跳过过期检查
			// 仅当 expiration 非零且已过期时，才跳过计数
			if !item.expiration.IsZero() && time.Now().After(item.expiration) {
				continue // 已过期，不计入
			}
			count++ // 键存在且未过期，计数器 +1
		}
	}
	return count, nil // 返回存在的键数量
}

// Expire 设置键的过期时间
// expiration >= 0 时设置新的过期时间
// expiration < 0 时立即删除键（与 Redis EXPIRE 行为一致）
// 键不存在时静默返回，不报错
func (m *memoryHelper) Expire(ctx context.Context, key string, expiration time.Duration) error {
	m.mutex.Lock()         // 加写锁，保证并发安全
	defer m.mutex.Unlock() // 函数退出时释放锁

	item, exists := m.data[key] // 查找目标键
	if !exists {
		return nil // 键不存在，直接返回
	}

	// 负数过期时间：立即删除键（与 Redis 行为一致）
	if expiration < 0 {
		if !item.expiration.IsZero() { // 该项之前有过期时间，在堆中
			heap.Remove(&m.expiryQueue, item.index) // 从堆中移除
		}
		delete(m.data, key)          // 从 map 中删除
		if m.expiryQueue.Len() > 0 { // 堆中还有元素时
			m.resetCleanupTimer() // 重置定时器
		}
		return nil // 操作成功
	}

	// 先从堆中移除旧项（如果之前有过期时间，说明它在堆中）
	if !item.expiration.IsZero() { // 旧项在堆中
		heap.Remove(&m.expiryQueue, item.index) // 从堆中移除旧项
	}

	// 设置新的过期时间并重新加入堆
	item.expiration = time.Now().Add(expiration) // 计算新的绝对过期时间点
	heap.Push(&m.expiryQueue, item)              // 重新加入最小堆

	// 重置定时器以匹配新的最近过期时间
	m.resetCleanupTimer()

	return nil // 操作成功
}

// GetAll 获取所有未过期的缓存项
// 返回包含键、值、过期时间的 CacheItem 切片
// 永不过期的项（expiration 为零值）也会被返回，其 ExpiresAt 为零值
func (m *memoryHelper) GetAll(ctx context.Context) ([]app.CacheItem, error) {
	m.mutex.RLock()         // 加读锁，允许多个并发读
	defer m.mutex.RUnlock() // 函数退出时释放锁

	var items []app.CacheItem // 初始化结果切片（nil 切片，无数据时返回 nil）
	now := time.Now()         // 缓存当前时间，避免循环中重复调用

	for _, item := range m.data { // 遍历 map 中所有缓存项
		// 零值表示永不过期，跳过过期检查
		// 仅当 expiration 非零且已过期时，才跳过该项
		if !item.expiration.IsZero() && now.After(item.expiration) {
			continue // 已过期，跳过
		}
		items = append(items, app.CacheItem{ // 将未过期的项加入结果
			Key:       item.key,        // 缓存键
			Value:     item.value,      // 缓存值
			ExpiresAt: item.expiration, // 过期时间（零值表示永不过期）
		})
	}

	return items, nil // 返回所有未过期的缓存项
}

// GetInt 获取键对应的整数值
// 键不存在或已过期时返回 (0, app.ErrKeyNotFound)；值类型不是整数且无法解析为整数时返回错误
func (m *memoryHelper) GetInt(ctx context.Context, key string) (int64, error) {
	m.mutex.RLock()         // 加读锁，允许多个并发读
	defer m.mutex.RUnlock() // 函数退出时释放锁

	item, exists := m.data[key] // 从 map 中查找键
	if !exists {
		return 0, app.ErrKeyNotFound // 键不存在
	}
	// 零值表示永不过期，跳过过期检查
	if !item.expiration.IsZero() && time.Now().After(item.expiration) {
		return 0, app.ErrKeyNotFound // 已过期
	}
	v, ok := toInt64(item.value) // 尝试将值转换为 int64
	if !ok {
		return 0, errors.New("cache value is not an integer")
	}
	return v, nil
}

// SetInt 设置整数值，并指定过期时间
// 内部委托给 SetVal；注意不要对同一个 key 混用 Set 与 SetInt，否则类型断言会出错
func (m *memoryHelper) SetInt(ctx context.Context, key string, value int64, expiration time.Duration) error {
	return m.SetVal(ctx, key, value, expiration)
}

// Incr 指定 key 的数值加 1（key 不存在或已过期时按 0 处理）
// 已存在但值不是整数时返回错误
func (m *memoryHelper) Incr(ctx context.Context, key string) (int64, error) {
	return m.incrBy(ctx, key, 1)
}

// Decr 指定 key 的数值减 1（key 不存在或已过期时按 0 处理）
// 已存在但值不是整数时返回错误
func (m *memoryHelper) Decr(ctx context.Context, key string) (int64, error) {
	return m.incrBy(ctx, key, -1)
}

// incrBy 是 Incr/Decr 共用的内部实现，delta 为 +1 或 -1
func (m *memoryHelper) incrBy(ctx context.Context, key string, delta int64) (int64, error) {
	m.mutex.Lock()         // 加写锁，保证并发安全
	defer m.mutex.Unlock() // 函数退出时释放锁

	var current int64        // 当前值，默认 0（用于 key 不存在或已过期的情况）
	var expiration time.Time // 保留原有过期时间，零值表示永不过期

	if item, exists := m.data[key]; exists {
		// 仅当 expiration 非零且已过期时，视为不存在
		if item.expiration.IsZero() || !time.Now().After(item.expiration) {
			expiration = item.expiration // 保留原有过期时间
			v, ok := toInt64(item.value)
			if !ok {
				return 0, errors.New("cache value is not an integer")
			}
			current = v
			// 旧项在堆中时，先移除（后面会用新项替换）
			if !item.expiration.IsZero() {
				heap.Remove(&m.expiryQueue, item.index)
			}
		} else {
			// 已过期：从堆和 map 中清理，按不存在处理；新项从零值 expiration（永不过期）开始
			if !item.expiration.IsZero() {
				heap.Remove(&m.expiryQueue, item.index)
			}
			delete(m.data, key)
			expiration = time.Time{} // 重置为零值，避免新项继承已过期时间
		}
	}

	newVal := current + delta // 执行加减

	newItem := &cacheItem{
		key:        key,
		value:      newVal,
		expiration: expiration, // 沿用原有过期时间；新 key 为零值（永不过期）
	}
	m.data[key] = newItem

	if !newItem.expiration.IsZero() { // 有过期时间才入堆
		heap.Push(&m.expiryQueue, newItem)
		if m.expiryQueue.Len() > 0 && m.expiryQueue[0] == newItem {
			m.resetCleanupTimer()
		}
	}

	return newVal, nil
}

// toInt64 将 interface{} 值转换为 int64
// 支持 int64、int 直接转换，以及 string 的十进制解析
func toInt64(v interface{}) (int64, bool) {
	switch n := v.(type) {
	case int64:
		return n, true
	case int:
		return int64(n), true
	case int32:
		return int64(n), true
	case string:
		if i, err := strconv.ParseInt(n, 10, 64); err == nil {
			return i, true
		}
	}
	return 0, false
}

// startCleanup 启动后台清理 goroutine
// 该 goroutine 持续监听定时器通道和停止信号：
//   - 定时器触发时，调用 cleanupExpired 清理已过期的项
//   - 收到停止信号时，停止定时器并退出 goroutine
func (m *memoryHelper) startCleanup() {
	m.resetCleanupTimer() // 初始化定时器（根据堆顶过期时间设置）
	go func() {           // 启动后台 goroutine
		for { // 无限循环，直到收到停止信号
			select { // 多路复用，监听多个通道
			case <-m.cleanupTick.C: // 定时器到期，触发清理
				m.cleanupExpired() // 执行过期项清理
			case <-m.stopChan: // 收到停止信号（Close 时触发）
				if m.cleanupTick != nil { // 安全检查，防止空指针
					m.cleanupTick.Stop() // 停止定时器，释放资源
				}
				return // 退出 goroutine
			}
		}
	}()
}

// resetCleanupTimer 重置清理定时器
// 根据过期堆的堆顶时间设置下一次清理的触发时间：
//   - 堆为空时，设置 1 小时的空闲定时器
//   - 堆顶已过期时，立即触发清理（定时器设为 0）
//   - 堆顶未过期时，定时器设为堆顶过期时间与当前时间的差值
//
// 注意：调用方必须持有写锁或在初始化阶段调用
func (m *memoryHelper) resetCleanupTimer() {
	if m.cleanupTick != nil { // 如果已有定时器
		m.cleanupTick.Stop() // 先停止旧定时器，防止泄漏
	}

	if m.expiryQueue.Len() == 0 { // 堆中没有元素（可能全是永不过期的项）
		// 没有数据，设置一个较长的定时器，避免无谓的 CPU 开销
		m.cleanupTick = time.NewTimer(1 * time.Hour)
		return // 直接返回
	}

	nextExpiry := m.expiryQueue[0].expiration // 堆顶元素的过期时间（最近的过期时间）
	now := time.Now()                         // 当前时间
	if nextExpiry.Before(now) {               // 堆顶已过期
		// 已经过期，立即触发清理（定时器设为 0）
		m.cleanupTick = time.NewTimer(0)
	} else {
		// 设置定时器到下一个过期时间，精确触发清理
		m.cleanupTick = time.NewTimer(nextExpiry.Sub(now))
	}
}

// cleanupExpired 清理所有已过期的缓存项
// 由定时器触发，循环弹出堆顶已过期元素，同时从 map 中删除
// 清理完成后重置定时器，安排下一次清理
func (m *memoryHelper) cleanupExpired() {
	m.mutex.Lock()         // 加写锁，保证并发安全
	defer m.mutex.Unlock() // 函数退出时释放锁

	now := time.Now()             // 缓存当前时间
	for m.expiryQueue.Len() > 0 { // 堆不为空时继续检查
		item := m.expiryQueue[0]         // 查看堆顶元素（最近要过期的项）
		if now.Before(item.expiration) { // 堆顶未过期
			break // 由于是最小堆，后面的也不会过期，停止清理
		}

		// 从堆中移除（heap.Pop 会弹出堆顶并重新调整堆结构）
		heap.Pop(&m.expiryQueue)
		// 从 map 中移除对应键
		delete(m.data, item.key)
	}

	// 清理完成后重置定时器，安排下一次清理时间
	m.resetCleanupTimer()
}

// Close 关闭缓存实例，释放所有资源
// 停止后台清理 goroutine，清空所有缓存数据
// 关闭后不应再使用该实例
func (m *memoryHelper) Close() error {
	m.mutex.Lock()         // 加写锁，保证并发安全
	defer m.mutex.Unlock() // 函数退出时释放锁

	// 停止清理 goroutine：关闭 stopChan 后，goroutine 的 select 会进入 stopChan 分支并退出
	close(m.stopChan)

	// 清空所有数据，释放内存
	m.data = make(map[string]*cacheItem) // 重建空 map，旧数据等待 GC 回收
	m.expiryQueue = expiryHeap{}         // 清空过期堆

	return nil // 操作成功
}
