package casbinhelper

import (
	"github.com/casbin/casbin/v2"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// CasbinInterf Casbin权限管理接口
type CasbinInterf interface {
	// InitCasbin 初始化Casbin
	InitCasbin(db *gorm.DB, config string) error

	// Enforce 检查权限
	Enforce(sub, obj, act string) (bool, error)

	// GetEnforcer 获取Casbin执行器
	GetEnforcer() *casbin.Enforcer

	// CasbinMiddleware Casbin权限中间件
	CasbinMiddleware() gin.HandlerFunc

	// AddPolicy 添加策略
	AddPolicy(sub, obj, act string) error

	// RemovePolicy 删除策略
	RemovePolicy(sub, obj, act string) error

	// AddRoleForUser 为用户添加角色
	AddRoleForUser(user, role string) error

	// DeleteRoleForUser 删除用户的角色
	DeleteRoleForUser(user, role string) error
}
