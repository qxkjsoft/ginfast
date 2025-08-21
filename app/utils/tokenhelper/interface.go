package tokenhelper

// TokenService Token服务接口
type TokenServiceInterface interface {
	// GenerateToken 生成JWT令牌
	GenerateToken(user *ClaimsUser) (string, error)

	// GenerateTokenWithCache 生成JWT令牌并存储到缓存
	GenerateTokenWithCache(user *ClaimsUser) (string, error)

	// StoreToken 存储Token到Redis
	StoreToken(info *TokenInfo) error

	// ValidateTokenWithCache 验证JWT令牌（带缓存检查）
	ValidateTokenWithCache(tokenString string) bool

	// RevokeToken 撤销Token（从缓存中移除）
	RevokeToken(tokenString string) error

	// ParseToken 解析JWT令牌
	ParseToken(tokenString string) (*Claims, error)

	// ValidateToken 验证JWT令牌
	ValidateToken(tokenString string) bool

	// GenerateRefreshToken 生成Refresh Token
	GenerateRefreshToken(userID uint) (string, error)

	// StoreRefreshToken 存储Refresh Token到Redis
	StoreRefreshToken(info *RefreshTokenInfo) error

	// ParseRefreshToken 解析Refresh Token
	ParseRefreshToken(tokenString string) (*RefreshTokenClaims, error)

	// ValidateRefreshToken 验证Refresh Token
	ValidateRefreshToken(tokenString string) bool

	// RevokeRefreshToken 撤销Refresh Token
	RevokeRefreshToken(userID uint) error

	// RefreshAccessToken 使用Refresh Token刷新Access Token
	RefreshAccessToken(refreshTokenString string, user *ClaimsUser) (string, error)
}
