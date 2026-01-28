package tokeneasy

import (
	"context"
	"gin-fast/app/global/app"
	"gin-fast/app/utils/tokenhelper"
	"sync"
)

var (
	tokenServiceInstance app.TokenServiceInterface
	tokenServiceOnce     sync.Once
)

// GetTokenService 获取TokenServiceInterface单例
func GetTokenService() app.TokenServiceInterface {
	tokenServiceOnce.Do(func() {
		tokenServiceInstance = NewTokenService(app.Cache)
	})
	return tokenServiceInstance
}

func NewTokenService(cache app.CacheInterf) app.TokenServiceInterface {
	tokenExpire := GetTokenConfig().GetDuration("token.jwttokenexpire")
	refreshExpire := GetTokenConfig().GetDuration("token.jwttokenrefreshexpire")

	return &tokenhelper.TokenService{
		RedisHelper:    cache,
		JWTSecret:      GetTokenConfig().GetString("token.jwttokensignkey"),
		Ctx:            context.Background(),
		TokenExpire:    tokenExpire,
		RefreshExpire:  refreshExpire,
		CacheKeyPrefix: GetTokenConfig().GetString("token.cachekeyprefix"),
		IsCache:        GetTokenConfig().GetBool("token.isCache"),
	}
}
