package cachehelper

import (
	"context"
	"errors"
	"gin-fast/app/global/app"
	"time"

	"github.com/go-redis/redis/v8"
)

// redisHelper Redis助手实现
type redisHelper struct {
	client *redis.Client
	ctx    context.Context
}

// NewRedisHelper 创建Redis助手实例
func NewRedisHelper(addr, password string, db int) (app.CacheInterf, error) {
	rdb := redis.NewClient(&redis.Options{
		Addr:     addr,     // Redis服务器地址
		Password: password, // 密码
		DB:       db,       // 数据库
	})

	// 测试连接是否成功
	ctx := context.Background()
	_, err := rdb.Ping(ctx).Result()
	if err != nil {
		return nil, err
	}

	return &redisHelper{
		client: rdb,
		ctx:    ctx,
	}, nil
}

// Set 设置键值对，并指定过期时间
func (r *redisHelper) Set(ctx context.Context, key string, value string, expiration time.Duration) error {
	return r.client.Set(ctx, key, value, expiration).Err()
}

// Get 获取键值
// 键不存在时返回 ("", app.ErrKeyNotFound)
func (r *redisHelper) Get(ctx context.Context, key string) (string, error) {
	val, err := r.client.Get(ctx, key).Result()
	if errors.Is(err, redis.Nil) {
		return "", app.ErrKeyNotFound
	}
	return val, err
}

// Del 删除键
func (r *redisHelper) Del(ctx context.Context, keys ...string) error {
	return r.client.Del(ctx, keys...).Err()
}

// Exists 检查键是否存在
func (r *redisHelper) Exists(ctx context.Context, keys ...string) (int64, error) {
	return r.client.Exists(ctx, keys...).Result()
}

// Expire 设置键的过期时间
func (r *redisHelper) Expire(ctx context.Context, key string, expiration time.Duration) error {
	return r.client.Expire(ctx, key, expiration).Err()
}

// GetAll 获取所有缓存项（使用SCAN命令分批遍历，避免KEYS *阻塞Redis）
func (r *redisHelper) GetAll(ctx context.Context) ([]app.CacheItem, error) {
	var items []app.CacheItem
	var cursor uint64

	for {
		// 分批扫描，每次取100条，避免一次性加载所有键
		keys, nextCursor, err := r.client.Scan(ctx, cursor, "*", 100).Result()
		if err != nil {
			return nil, err
		}

		for _, key := range keys {
			val, err := r.client.Get(ctx, key).Result()
			if err == redis.Nil {
				continue // key在SCAN和GET之间被删除（竞态），跳过
			}
			if err != nil {
				return nil, err
			}

			ttl, err := r.client.TTL(ctx, key).Result()
			if err != nil {
				return nil, err
			}

			var expiresAt time.Time
			if ttl == -2 {
				continue // key已不存在（竞态），跳过
			} else if ttl == -1 {
				expiresAt = time.Time{} // 永不过期，零值表示
			} else {
				expiresAt = time.Now().Add(ttl)
			}

			items = append(items, app.CacheItem{
				Key:       key,
				Value:     val,
				ExpiresAt: expiresAt,
			})
		}

		cursor = nextCursor
		if cursor == 0 {
			break // 遍历完成
		}
	}

	return items, nil
}

// GetInt 获取键对应的整数值
// 键不存在时返回 (0, app.ErrKeyNotFound)
func (r *redisHelper) GetInt(ctx context.Context, key string) (int64, error) {
	val, err := r.client.Get(ctx, key).Int64()
	if errors.Is(err, redis.Nil) {
		return 0, app.ErrKeyNotFound
	}
	return val, err
}

// SetInt 设置整数值，并指定过期时间
func (r *redisHelper) SetInt(ctx context.Context, key string, value int64, expiration time.Duration) error {
	return r.client.Set(ctx, key, value, expiration).Err()
}

// Incr 指定 key 的数值加 1
func (r *redisHelper) Incr(ctx context.Context, key string) (int64, error) {
	return r.client.Incr(ctx, key).Result()
}

// Decr 指定 key 的数值减 1
func (r *redisHelper) Decr(ctx context.Context, key string) (int64, error) {
	return r.client.Decr(ctx, key).Result()
}

// Close 关闭连接
func (r *redisHelper) Close() error {
	return r.client.Close()
}
