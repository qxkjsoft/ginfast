package tokenhelper

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
)

// ClaimsUser 用户声明信息
type ClaimsUser struct {
	UserID   uint        `json:"user_id"`
	Username string      `json:"username"`
	RawData  interface{} `json:"raw_data"` // 原始数据
}

// Claims JWT声明结构
type Claims struct {
	ClaimsUser
	jwt.RegisteredClaims
}

// RefreshTokenClaims Refresh Token声明结构
type RefreshTokenClaims struct {
	UserID uint `json:"user_id"`
	jwt.RegisteredClaims
}

// RefreshTokenInfo Refresh Token信息
type RefreshTokenInfo struct {
	UserID    uint      `json:"user_id"`
	Token     string    `json:"token"`
	ExpiresAt time.Time `json:"expires_at"`
	CreatedAt time.Time `json:"created_at"`
}

// TokenInfo Token信息
type TokenInfo struct {
	UserID    uint      `json:"user_id"`
	Token     string    `json:"token"`
	ExpiresAt time.Time `json:"expires_at"`
	CreatedAt time.Time `json:"created_at"`
}
