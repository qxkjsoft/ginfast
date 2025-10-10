package cachehelper

import (
	"context"
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
func (r *redisHelper) Get(ctx context.Context, key string) (string, error) {
	return r.client.Get(ctx, key).Result()
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

// GetAll 获取所有缓存项（Redis实现中不支持直接获取所有键值对）
func (r *redisHelper) GetAll(ctx context.Context) ([]app.CacheItem, error) {
	// Redis没有简单的方法获取所有键值对，这里返回空数组
	// 如果需要实现此功能，需要使用SCAN命令遍历所有键，然后逐个获取值
	return []app.CacheItem{}, nil
}

// Close 关闭连接
func (r *redisHelper) Close() error {
	return r.client.Close()
}
