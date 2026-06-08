package app

import (
	"context"
	"errors"
	"time"
)

// ErrKeyNotFound 缓存键不存在的哨兵错误
// Get / GetInt 在键不存在时返回此错误；调用方可通过 errors.Is(err, ErrKeyNotFound) 判断
var ErrKeyNotFound = errors.New("cache: key not found")

// CacheItem 缓存项结构
type CacheItem struct {
	Key       string      `json:"key"`
	Value     interface{} `json:"value"`
	ExpiresAt time.Time   `json:"expires_at"`
}

// CacheInterf 缓存接口
// 定义了缓存操作的标准接口，支持Redis和内存缓存的统一抽象
type CacheInterf interface {
	// Set 设置键值对，并指定过期时间
	Set(ctx context.Context, key string, value string, expiration time.Duration) error

	// Get 获取键值
	// 键不存在时返回 ("", ErrKeyNotFound)
	Get(ctx context.Context, key string) (string, error)

	// Del 删除键
	Del(ctx context.Context, keys ...string) error

	// Exists 检查键是否存在
	Exists(ctx context.Context, keys ...string) (int64, error)

	// Expire 设置键的过期时间
	Expire(ctx context.Context, key string, expiration time.Duration) error

	// GetAll 获取所有缓存项
	GetAll(ctx context.Context) ([]CacheItem, error)

	// GetInt 获取键对应的整数值
	// 键不存在时返回 (0, ErrKeyNotFound)
	GetInt(ctx context.Context, key string) (int64, error)

	// SetInt 设置整数值，并指定过期时间
	SetInt(ctx context.Context, key string, value int64, expiration time.Duration) error

	// Incr 指定 key 的数值加 1（key 不存在时按 0 处理）
	Incr(ctx context.Context, key string) (int64, error)

	// Decr 指定 key 的数值减 1（key 不存在时按 0 处理）
	Decr(ctx context.Context, key string) (int64, error)

	// Close 关闭连接
	Close() error
}
