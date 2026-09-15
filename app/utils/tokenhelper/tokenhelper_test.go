package tokenhelper

import (
	"context"
	"gin-fast/app/global/app"
	"testing"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// newTestTokenService 构造带内存缓存的测试用TokenService
func newTestTokenService() *TokenService {
	return &TokenService{
		Ctx:            context.Background(),
		RedisHelper:    NewMockCacheInterf(),
		JWTSecret:      "test_secret",
		TokenExpire:    3600,
		RefreshExpire:  86400,
		CacheKeyPrefix: "test:",
	}
}

// MockCacheInterf 模拟缓存接口
type MockCacheInterf struct {
	mock.Mock
	storage map[string]string // 简单的内存存储模拟Redis
}

func NewMockCacheInterf() *MockCacheInterf {
	return &MockCacheInterf{
		storage: make(map[string]string),
	}
}

func (m *MockCacheInterf) Set(ctx context.Context, key string, value string, expiration time.Duration) error {
	m.storage[key] = value
	return nil
}

func (m *MockCacheInterf) Get(ctx context.Context, key string) (string, error) {
	if value, exists := m.storage[key]; exists {
		return value, nil
	}
	return "", nil
}

func (m *MockCacheInterf) Del(ctx context.Context, keys ...string) error {
	for _, key := range keys {
		delete(m.storage, key)
	}
	return nil
}

func (m *MockCacheInterf) Exists(ctx context.Context, keys ...string) (int64, error) {
	count := int64(0)
	for _, key := range keys {
		if _, exists := m.storage[key]; exists {
			count++
		}
	}
	return count, nil
}

func (m *MockCacheInterf) Expire(ctx context.Context, key string, expiration time.Duration) error {
	return nil
}

func (m *MockCacheInterf) Close() error {
	return nil
}

func (m *MockCacheInterf) GetAll(ctx context.Context) ([]app.CacheItem, error) {
	return nil, nil
}

func (m *MockCacheInterf) GetInt(ctx context.Context, key string) (int64, error) {
	return 0, nil
}

func (m *MockCacheInterf) SetInt(ctx context.Context, key string, value int64, expiration time.Duration) error {
	return nil
}

func (m *MockCacheInterf) Incr(ctx context.Context, key string) (int64, error) {
	return 0, nil
}

func (m *MockCacheInterf) Decr(ctx context.Context, key string) (int64, error) {
	return 0, nil
}

func TestRotateRefreshToken(t *testing.T) {
	// 设置测试环境
	mockCache := NewMockCacheInterf()
	tokenService := &TokenService{
		Ctx:            context.Background(),
		RedisHelper:    mockCache,
		JWTSecret:      "test_secret",
		TokenExpire:    3600,
		RefreshExpire:  86400,
		CacheKeyPrefix: "test:",
	}

	userID := uint(1)

	// 生成初始refresh token
	originalRefreshToken, err := tokenService.GenerateRefreshToken(userID, 1, "test_tenant")
	assert.NoError(t, err)
	assert.NotEmpty(t, originalRefreshToken)

	// 等待一小段时间确保时间戳不同
	time.Sleep(1 * time.Second)

	// 测试轮换refresh token
	newRefreshToken, err := tokenService.RotateRefreshToken(originalRefreshToken)
	assert.NoError(t, err)
	assert.NotEmpty(t, newRefreshToken)
	assert.NotEqual(t, originalRefreshToken, newRefreshToken)

	// 验证新token的有效性
	newClaims, err := tokenService.ParseRefreshToken(newRefreshToken)
	assert.NoError(t, err)
	assert.Equal(t, userID, newClaims.UserID)

	// 验证原token的claims
	originalClaims, err := tokenService.ParseRefreshToken(originalRefreshToken)
	assert.NoError(t, err)

	// 检查过期时间相近（允许2秒误差，因为有sleep和计算误差）
	timeDiff := newClaims.ExpiresAt.Time.Sub(originalClaims.ExpiresAt.Time)
	assert.True(t, timeDiff < 2*time.Second && timeDiff > -2*time.Second,
		"新token的过期时间应该与原token相近，时间差: %v", timeDiff)

	// 验证原token已从缓存中移除
	originalKey := tokenService.getRefreshTokenKey(userID)
	storedToken, err := mockCache.Get(context.Background(), originalKey)
	assert.NoError(t, err)
	assert.Equal(t, newRefreshToken, storedToken, "缓存中应该存储新的refresh token")
}

func TestRotateRefreshToken_ExpiredToken(t *testing.T) {
	mockCache := NewMockCacheInterf()
	tokenService := &TokenService{
		Ctx:            context.Background(),
		RedisHelper:    mockCache,
		JWTSecret:      "test_secret",
		TokenExpire:    3600,
		RefreshExpire:  1, // 1秒过期，用于测试
		CacheKeyPrefix: "test:",
	}

	userID := uint(1)

	// 生成一个很快过期的refresh token
	shortExpiryToken, err := tokenService.GenerateRefreshToken(userID, 1, "test_tenant")
	assert.NoError(t, err)

	// 等待token过期
	time.Sleep(2 * time.Second)

	// 尝试轮换已过期的token，应该失败
	_, err = tokenService.RotateRefreshToken(shortExpiryToken)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "expired")
}

func TestRotateRefreshToken_InvalidToken(t *testing.T) {
	mockCache := NewMockCacheInterf()
	tokenService := &TokenService{
		Ctx:            context.Background(),
		RedisHelper:    mockCache,
		JWTSecret:      "test_secret",
		TokenExpire:    3600,
		RefreshExpire:  86400,
		CacheKeyPrefix: "test:",
	}

	// 尝试轮换无效的token
	_, err := tokenService.RotateRefreshToken("invalid_token")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "invalid")
}

func TestTokenTypeSeparation(t *testing.T) {
	tokenService := newTestTokenService()

	access, err := tokenService.GenerateToken(&app.ClaimsUser{UserID: 1, Username: "admin"})
	assert.NoError(t, err)

	refresh, err := tokenService.GenerateRefreshToken(1, 1, "tenant")
	assert.NoError(t, err)

	t.Run("正常流access token可解析且类型正确", func(t *testing.T) {
		claims, err := tokenService.ParseToken(access)
		assert.NoError(t, err)
		assert.Equal(t, app.TokenTypeAccess, claims.TokenType)
	})

	t.Run("正常流refresh token可解析且类型正确", func(t *testing.T) {
		claims, err := tokenService.ParseRefreshToken(refresh)
		assert.NoError(t, err)
		assert.Equal(t, app.TokenTypeRefresh, claims.TokenType)
	})

	t.Run("refresh token不能当access token使用", func(t *testing.T) {
		_, err := tokenService.ParseToken(refresh)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), "invalid token type")
	})

	t.Run("access token不能当refresh token使用", func(t *testing.T) {
		_, err := tokenService.ParseRefreshToken(access)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), "invalid refresh token type")
	})

	t.Run("ValidateTokenWithCache同样拒绝refresh token", func(t *testing.T) {
		_, err := tokenService.ValidateTokenWithCache(refresh)
		assert.Error(t, err)
	})
}

func TestLegacyTokenWithoutTypeRejected(t *testing.T) {
	tokenService := newTestTokenService()
	now := time.Now()

	// 模拟升级前签发的旧token（无tokenType字段），升级部署后应被拒绝，强制重新登录
	legacyAccess, err := jwt.NewWithClaims(jwt.SigningMethodHS256, &app.Claims{
		ClaimsUser: app.ClaimsUser{UserID: 1},
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(now.Add(time.Hour)),
			IssuedAt:  jwt.NewNumericDate(now),
		},
	}).SignedString([]byte(tokenService.JWTSecret))
	assert.NoError(t, err)

	legacyRefresh, err := jwt.NewWithClaims(jwt.SigningMethodHS256, &app.RefreshTokenClaims{
		UserID: 1,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(now.Add(time.Hour)),
			IssuedAt:  jwt.NewNumericDate(now),
		},
	}).SignedString([]byte(tokenService.JWTSecret))
	assert.NoError(t, err)

	_, err = tokenService.ParseToken(legacyAccess)
	assert.Error(t, err)

	_, err = tokenService.ParseRefreshToken(legacyRefresh)
	assert.Error(t, err)
}
