package tokenhelper

import (
	"context"
	"errors"
	"fmt"
	"gin-fast/app/utils/cachehelper"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

// TokenService Token服务
type TokenService struct {
	Ctx            context.Context
	RedisHelper    cachehelper.CacheInterf
	JWTSecret      string
	TokenExpire    time.Duration
	RefreshExpire  time.Duration
	CacheKeyPrefix string
}

/**
	token管理，非缓存模式
**/
// GenerateToken 生成JWT令牌
func (s *TokenService) GenerateToken(user *ClaimsUser) (string, error) {
	claims := &Claims{
		ClaimsUser: *user,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(s.TokenExpire * time.Second)), // 过期时间
			IssuedAt:  jwt.NewNumericDate(time.Now()),                                  // 签发时间
			NotBefore: jwt.NewNumericDate(time.Now()),                                  // 生效时间
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(s.JWTSecret))
}

// ParseToken 解析JWT令牌
func (s *TokenService) ParseToken(tokenString string) (*Claims, error) {
	claims := &Claims{}
	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return []byte(s.JWTSecret), nil
	})

	if err != nil {
		return nil, err
	}
	if !token.Valid {
		return nil, errors.New("invalid token")
	}
	return claims, nil
}

// ValidateToken 验证JWT令牌
func (s *TokenService) ValidateToken(tokenString string) bool {
	_, err := s.ParseToken(tokenString)
	return err == nil
}

/**
	token管理，缓存模式
**/
// GenerateTokenWithCache 生成JWT令牌并存储到缓存
func (s *TokenService) GenerateTokenWithCache(user *ClaimsUser) (string, error) {
	tokenString, err := s.GenerateToken(user)
	if err != nil {
		return "", err
	}

	// 存储token到Redis
	tokenInfo := &TokenInfo{
		UserID:    user.UserID,
		Token:     tokenString,
		ExpiresAt: time.Now().Add(s.TokenExpire * time.Second),
		CreatedAt: time.Now(),
	}

	err = s.StoreToken(tokenInfo)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

// StoreToken 存储Token到Redis
func (s *TokenService) StoreToken(info *TokenInfo) error {
	key := s.getTokenKey(info.UserID, info.Token)
	return s.RedisHelper.Set(s.Ctx, key, "1", time.Until(info.ExpiresAt))
}

// ValidateTokenWithCache 验证JWT令牌（带缓存检查）
func (s *TokenService) ValidateTokenWithCache(tokenString string) bool {
	// 先验证JWT签名
	claims, err := s.ParseToken(tokenString)
	if err != nil {
		return false
	}

	// 检查缓存中是否存在该token（白名单模式）
	key := s.getTokenKey(claims.UserID, tokenString)
	exists, err := s.RedisHelper.Exists(s.Ctx, key)
	if err != nil || exists == 0 {
		return false
	}

	return true
}

// RevokeToken 撤销Token（从缓存中移除）
func (s *TokenService) RevokeToken(tokenString string) error {
	claims, err := s.ParseToken(tokenString)
	if err != nil {
		return err
	}

	key := s.getTokenKey(claims.UserID, tokenString)
	return s.RedisHelper.Del(s.Ctx, key)
}

// getTokenKey 获取Redis中存储Token的key
func (s *TokenService) getTokenKey(userID uint, tokenString string) string {
	// 使用token的简短哈希作为key的一部分，避免key过长
	tokenHash := fmt.Sprintf("%x", len(tokenString))
	return fmt.Sprintf("%stoken:%d:%s", s.CacheKeyPrefix, userID, tokenHash)
}

/**
	refreshToken管理
**/
// GenerateRefreshToken 生成Refresh Token
func (s *TokenService) GenerateRefreshToken(userID uint) (string, error) {
	expirationTime := time.Now().Add(s.RefreshExpire * time.Second)
	claims := &RefreshTokenClaims{
		UserID: userID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			NotBefore: jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString([]byte(s.JWTSecret))
	if err != nil {
		return "", err
	}

	// 存储refresh token到Redis
	refreshTokenInfo := &RefreshTokenInfo{
		UserID:    userID,
		Token:     tokenString,
		ExpiresAt: expirationTime,
		CreatedAt: time.Now(),
	}

	err = s.StoreRefreshToken(refreshTokenInfo)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

// StoreRefreshToken 存储Refresh Token到Redis
func (s *TokenService) StoreRefreshToken(info *RefreshTokenInfo) error {
	key := s.getRefreshTokenKey(info.UserID)
	return s.RedisHelper.Set(s.Ctx, key, info.Token, time.Until(info.ExpiresAt))
}

// ParseRefreshToken 解析Refresh Token
func (s *TokenService) ParseRefreshToken(tokenString string) (*RefreshTokenClaims, error) {
	claims := &RefreshTokenClaims{}
	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return []byte(s.JWTSecret), nil
	})
	if err != nil {
		return nil, err
	}
	if !token.Valid {
		return nil, errors.New("invalid refresh token")
	}
	return claims, nil
}

// ValidateRefreshToken 验证Refresh Token
func (s *TokenService) ValidateRefreshToken(tokenString string) bool {
	claims, err := s.ParseRefreshToken(tokenString)
	if err != nil {
		return false
	}

	// 检查Redis中是否存在该token
	key := s.getRefreshTokenKey(claims.UserID)
	storedToken, err := s.RedisHelper.Get(s.Ctx, key)
	if err != nil {
		return false
	}

	return storedToken == tokenString
}

// RevokeRefreshToken 撤销Refresh Token
func (s *TokenService) RevokeRefreshToken(userID uint) error {
	key := s.getRefreshTokenKey(userID)
	return s.RedisHelper.Del(s.Ctx, key)
}

// RefreshAccessToken 使用Refresh Token刷新Access Token
func (s *TokenService) RefreshAccessToken(refreshTokenString string, user *ClaimsUser) (string, error) {
	// 验证refresh token
	if !s.ValidateRefreshToken(refreshTokenString) {
		return "", jwt.ErrTokenInvalidClaims
	}

	newAccessToken, err := s.GenerateToken(user)
	if err != nil {
		return "", err
	}

	return newAccessToken, nil
}

// getRefreshTokenKey 获取Redis中存储Refresh Token的key
func (s *TokenService) getRefreshTokenKey(userID uint) string {
	return fmt.Sprintf("%srefresh_token:%d", s.CacheKeyPrefix, userID)

}
