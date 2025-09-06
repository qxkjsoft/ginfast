package app

import (
	"context"
	"time"
)

// CacheInterf 缓存接口
// 定义了缓存操作的标准接口，支持Redis和内存缓存的统一抽象
type CacheInterf interface {
	// Set 设置键值对，并指定过期时间
	Set(ctx context.Context, key string, value string, expiration time.Duration) error

	// Get 获取键值
	Get(ctx context.Context, key string) (string, error)

	// Del 删除键
	Del(ctx context.Context, keys ...string) error

	// Exists 检查键是否存在
	Exists(ctx context.Context, keys ...string) (int64, error)

	// Expire 设置键的过期时间
	Expire(ctx context.Context, key string, expiration time.Duration) error

	// Close 关闭连接
	Close() error
}
