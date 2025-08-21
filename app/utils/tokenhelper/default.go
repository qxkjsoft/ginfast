package tokenhelper

import (
	"context"
	"gin-fast/app/global/g"
	"gin-fast/app/utils/cachehelper"
	"sync"
)

var (
	tokenInstance TokenServiceInterface
	tokenOnce     sync.Once
)

// GetTokenService 获取Token服务单例
func GetTokenService() TokenServiceInterface {
	tokenOnce.Do(func() {
		tokenInstance = NewDefault()
	})
	return tokenInstance
}

// NewTokenService 创建Token服务实例
func NewDefault() TokenServiceInterface {
	return &TokenService{
		redisHelper:    cachehelper.GetCacheHelper(),
		JWTSecret:      g.ConfigYml.GetString("Token.JwtTokenSignKey"),
		ctx:            context.Background(),
		TokenExpire:    g.ConfigYml.GetDuration("Token.JwtTokenExpire"),
		RefreshExpire:  g.ConfigYml.GetDuration("Token.JwtTokenRefreshExpire"),
		CacheKeyPrefix: g.ConfigYml.GetString("Token.CacheKeyPrefix"),
	}
}
