package tokenhelper

import (
	"context"
	"crypto/md5"
	"errors"
	"fmt"
	"gin-fast/app/global/app"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

// TokenService Token服务
type TokenService struct {
	Ctx            context.Context
	RedisHelper    app.CacheInterf
	JWTSecret      string
	TokenExpire    time.Duration
	RefreshExpire  time.Duration
	CacheKeyPrefix string
	IsCache        bool
}

/**
	token管理（非缓存模式）
**/
// GenerateToken 生成JWT令牌
func (s *TokenService) GenerateToken(user *app.ClaimsUser) (string, error) {
	claims := &app.Claims{
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
func (s *TokenService) ParseToken(tokenString string) (*app.Claims, error) {
	claims := &app.Claims{}
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
func (s *TokenService) ValidateToken(tokenString string) (*app.Claims, error) {
	return s.ParseToken(tokenString)
}

/**
	token管理（缓存模式, 可配置是否开启缓存）
**/
// GenerateTokenWithCache 生成JWT令牌并存储到缓存
func (s *TokenService) GenerateTokenWithCache(user *app.ClaimsUser) (string, error) {
	tokenString, err := s.GenerateToken(user)
	if err != nil {
		return "", err
	}

	// 如果开启缓存，存储token到Redis
	if s.IsCache {
		tokenInfo := &app.TokenInfo{
			UserID:    user.UserID,
			Token:     tokenString,
			ExpiresAt: time.Now().Add(s.TokenExpire * time.Second),
			CreatedAt: time.Now(),
		}
		err = s.storeTokenWithCache(tokenInfo)
		if err != nil {
			return "", err
		}
	}

	return tokenString, nil
}

// StoreToken 存储Token到Redis
func (s *TokenService) storeTokenWithCache(info *app.TokenInfo) error {
	key := s.getTokenKeyWithCache(info.UserID, info.Token)
	return s.RedisHelper.Set(s.Ctx, key, info.Token, time.Until(info.ExpiresAt))
}

// ValidateTokenWithCache 验证JWT令牌（带缓存检查）
func (s *TokenService) ValidateTokenWithCache(tokenString string) (*app.Claims, error) {
	// 先验证JWT签名
	claims, err := s.ParseToken(tokenString)
	if err != nil {
		return nil, err
	}
	// 检查缓存中是否存在该token（白名单模式）
	if s.IsCache {
		key := s.getTokenKeyWithCache(claims.UserID, tokenString)
		exists, err := s.RedisHelper.Exists(s.Ctx, key)
		if err != nil || exists == 0 {
			return nil, errors.New("token not found")
		}
	}
	return claims, nil
}

// RevokeToken 撤销Token（从缓存中移除）
func (s *TokenService) RevokeTokenWithCache(tokenString string) error {
	claims, err := s.ParseToken(tokenString)
	if err != nil {
		return err
	}
	// 如果开启缓存，从Redis中删除该token
	if s.IsCache {
		key := s.getTokenKeyWithCache(claims.UserID, tokenString)
		return s.RedisHelper.Del(s.Ctx, key)
	}
	return nil
}

// getTokenKey 获取Redis中存储Token的key
func (s *TokenService) getTokenKeyWithCache(userID uint, tokenString string) string {
	// 使用MD5哈希算法生成安全的token标识，避免key冲突
	hash := md5.Sum([]byte(tokenString))
	tokenHash := fmt.Sprintf("%x", hash)[:8] // 取前8位作为简短标识
	return fmt.Sprintf("%stoken:%d:%s", s.CacheKeyPrefix, userID, tokenHash)
}

/*****************************************refreshToken管理****************************************************/
// GenerateRefreshToken 生成Refresh Token
func (s *TokenService) GenerateRefreshToken(userID uint) (string, error) {
	expirationTime := time.Now().Add(s.RefreshExpire * time.Second)
	claims := &app.RefreshTokenClaims{
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
	refreshTokenInfo := &app.RefreshTokenInfo{
		UserID:    userID,
		Token:     tokenString,
		ExpiresAt: expirationTime,
		CreatedAt: time.Now(),
	}

	err = s.storeRefreshToken(refreshTokenInfo)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

// StoreRefreshToken 存储Refresh Token到Redis
func (s *TokenService) storeRefreshToken(info *app.RefreshTokenInfo) error {
	key := s.getRefreshTokenKey(info.UserID)
	return s.RedisHelper.Set(s.Ctx, key, info.Token, time.Until(info.ExpiresAt))
}

// ParseRefreshToken 解析Refresh Token
func (s *TokenService) ParseRefreshToken(tokenString string) (*app.RefreshTokenClaims, error) {
	claims := &app.RefreshTokenClaims{}
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
func (s *TokenService) ValidateRefreshToken(tokenString string) (*app.RefreshTokenClaims, error) {
	claims, err := s.ParseRefreshToken(tokenString)
	if err != nil {
		return nil, err
	}

	// 检查Redis中是否存在该token
	key := s.getRefreshTokenKey(claims.UserID)
	storedToken, err := s.RedisHelper.Get(s.Ctx, key)
	if err != nil {
		return nil, errors.New("refresh Token not found")
	}
	if storedToken == tokenString {
		return claims, nil
	}
	return nil, errors.New("invalid refresh token")
}

// RevokeRefreshToken 撤销Refresh Token
func (s *TokenService) RevokeRefreshToken(userID uint) error {
	key := s.getRefreshTokenKey(userID)
	return s.RedisHelper.Del(s.Ctx, key)
}

// RefreshAccessTokenWithCache 使用Refresh Token刷新Access Token 并记录到缓存中
func (s *TokenService) RefreshAccessTokenWithCache(refreshTokenString string, user *app.ClaimsUser) (string, error) {
	// 验证refresh token
	if _, err := s.ValidateRefreshToken(refreshTokenString); err != nil {
		return "", err
	}

	newAccessToken, err := s.GenerateTokenWithCache(user)
	if err != nil {
		return "", err
	}

	return newAccessToken, nil
}

// RotateRefreshToken 轮换Refresh Token（撤销旧的，生成新的，保持相同的剩余过期时间）
func (s *TokenService) RotateRefreshToken(oldRefreshToken string) (string, error) {
	// 1. 验证旧的refresh token
	claims, err := s.ValidateRefreshToken(oldRefreshToken)
	if err != nil {
		return "", fmt.Errorf("invalid old refresh token: %w", err)
	}

	// 2. 计算剩余有效时间
	now := time.Now()
	remainingDuration := claims.ExpiresAt.Time.Sub(now)
	if remainingDuration <= 0 {
		return "", errors.New("refresh token has expired")
	}

	// 3. 撤销旧的refresh token
	if err := s.RevokeRefreshToken(claims.UserID); err != nil {
		return "", fmt.Errorf("failed to revoke old refresh token: %w", err)
	}

	// 4. 生成新的refresh token，使用剩余的有效时间
	expirationTime := now.Add(remainingDuration)
	newClaims := &app.RefreshTokenClaims{
		UserID: claims.UserID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
			IssuedAt:  jwt.NewNumericDate(now),
			NotBefore: jwt.NewNumericDate(now),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, newClaims)
	newTokenString, err := token.SignedString([]byte(s.JWTSecret))
	if err != nil {
		return "", fmt.Errorf("failed to sign new refresh token: %w", err)
	}

	// 5. 存储新的refresh token到Redis
	newRefreshTokenInfo := &app.RefreshTokenInfo{
		UserID:    claims.UserID,
		Token:     newTokenString,
		ExpiresAt: expirationTime,
		CreatedAt: now,
	}

	if err := s.storeRefreshToken(newRefreshTokenInfo); err != nil {
		return "", fmt.Errorf("failed to store new refresh token: %w", err)
	}

	return newTokenString, nil
}

// getRefreshTokenKey 获取Redis中存储Refresh Token的key
func (s *TokenService) getRefreshTokenKey(userID uint) string {
	return fmt.Sprintf("%srefresh_token:%d", s.CacheKeyPrefix, userID)

}
