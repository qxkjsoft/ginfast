package cachehelper

import (
	"gin-fast/app/global/g"
	"sync"
)

var (
	cacheInstance CacheHelper
	cacheOnce     sync.Once
)

// 默认的缓存
func GetCacheHelper() CacheHelper {
	cacheOnce.Do(func() {
		cacheInstance = NewDefault()
	})
	return cacheInstance
}

// NewDefault 创建默认Redis助手实例
func NewDefault() CacheHelper {
	cacheType := g.ConfigYml.GetString("Server.CacheType")
	if cacheType == "redis" {
		redisHelper, err := NewRedisHelper(
			g.ConfigYml.GetString("Redis.Host")+":"+g.ConfigYml.GetString("Redis.Port"),
			g.ConfigYml.GetString("Redis.Password"),
			g.ConfigYml.GetInt("Redis.IndexDb"),
		)
		if err != nil {
			panic(err)
		}

		return redisHelper

	}

	return NewMemoryHelper()
}
