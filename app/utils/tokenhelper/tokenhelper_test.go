package tokenhelper

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

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
	originalRefreshToken, err := tokenService.GenerateRefreshToken(userID)
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
	shortExpiryToken, err := tokenService.GenerateRefreshToken(userID)
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
