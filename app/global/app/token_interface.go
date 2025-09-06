package app

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
)

// TokenServiceInterface Token服务接口
type TokenServiceInterface interface {
	// GenerateToken 生成JWT令牌
	GenerateToken(user *ClaimsUser) (string, error)

	// GenerateTokenWithCache 生成JWT令牌并存储到缓存
	GenerateTokenWithCache(user *ClaimsUser) (string, error)

	// StoreToken 存储Token到Redis
	StoreToken(info *TokenInfo) error

	// ValidateTokenWithCache 验证JWT令牌（带缓存检查）
	ValidateTokenWithCache(tokenString string) (*Claims, error)

	// RevokeToken 撤销Token（从缓存中移除）
	RevokeToken(tokenString string) error

	// ParseToken 解析JWT令牌
	ParseToken(tokenString string) (*Claims, error)

	// ValidateToken 验证JWT令牌
	ValidateToken(tokenString string) (*Claims, error)

	// GenerateRefreshToken 生成Refresh Token
	GenerateRefreshToken(userID uint) (string, error)

	// StoreRefreshToken 存储Refresh Token到Redis
	StoreRefreshToken(info *RefreshTokenInfo) error

	// ParseRefreshToken 解析Refresh Token
	ParseRefreshToken(tokenString string) (*RefreshTokenClaims, error)

	// ValidateRefreshToken 验证Refresh Token
	ValidateRefreshToken(tokenString string) (*RefreshTokenClaims, error)

	// RevokeRefreshToken 撤销Refresh Token
	RevokeRefreshToken(userID uint) error

	// RefreshAccessToken 使用Refresh Token刷新Access Token
	RefreshAccessToken(refreshTokenString string, user *ClaimsUser) (string, error)
}

// ClaimsUser 用户声明信息
type ClaimsUser struct {
	UserID   uint   `json:"userId"`   // 用户ID
	Username string `json:"username"` // 用户名
}

// Claims JWT声明结构
type Claims struct {
	ClaimsUser
	jwt.RegisteredClaims
}

// RefreshTokenClaims Refresh Token声明结构
type RefreshTokenClaims struct {
	UserID uint `json:"userId"`
	jwt.RegisteredClaims
}

// RefreshTokenInfo Refresh Token信息
type RefreshTokenInfo struct {
	UserID    uint      `json:"userId"`
	Token     string    `json:"token"`
	ExpiresAt time.Time `json:"expiresAt"`
	CreatedAt time.Time `json:"createdAt"`
}

// TokenInfo Token信息
type TokenInfo struct {
	UserID    uint      `json:"userId"`
	Token     string    `json:"token"`
	ExpiresAt time.Time `json:"expiresAt"`
	CreatedAt time.Time `json:"createdAt"`
}
