package app

import (
	"github.com/casbin/casbin/v2"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// CasbinInterf Casbin权限管理接口
// 由使用者定义，实现者只需要实现该接口即可
type CasbinInterf interface {
	// InitCasbin 初始化Casbin
	InitCasbin(db *gorm.DB, config string) error

	// Enforce 检查权限
	Enforce(sub, obj, act string, domain ...string) (bool, error)

	// GetEnforcer 获取Casbin执行器
	GetEnforcer() *casbin.Enforcer

	// CasbinMiddleware Casbin权限中间件
	CasbinMiddleware() gin.HandlerFunc

	// AddRolesForUserByID 为用户ID添加多个角色（带前缀）
	AddRolesForUserByID(userID uint, roleIDs []uint, domain ...string) error

	// DeleteRolesForUserByID 删除用户ID的多个角色（带前缀）
	DeleteRolesForUserByID(userID uint, roleIDs []uint, domain ...string) error

	// AddRoleInheritance 添加角色继承关系
	AddRoleInheritance(childRoleID, parentRoleID uint, domain ...string) error

	// DeleteRoleInheritance 删除角色继承关系
	DeleteRoleInheritance(childRoleID, parentRoleID uint, domain ...string) error

	// AddPolicyForRole 为角色添加权限策略
	AddPolicyForRole(roleID uint, obj, act string, domain ...string) error

	// RemovePolicyForRole 删除角色的权限策略
	RemovePolicyForRole(roleID uint, obj, act string, domain ...string) error

	// AddPoliciesForRole 为角色批量添加权限策略
	AddPoliciesForRole(roleID uint, policies [][]string, domain ...string) error

	// RemoveAllPoliciesForRole 删除角色的所有权限策略
	RemoveAllPoliciesForRole(roleID uint, domain ...string) error

	// GetRolesForUserByID 获取用户ID的所有角色
	GetRolesForUserByID(userID uint, domain ...string) ([]uint, error)

	// GetUsersForRole 获取拥有指定角色的所有用户ID
	GetUsersForRole(roleID uint, domain ...string) ([]uint, error)

	// HasRoleForUser 检查用户是否拥有指定角色
	HasRoleForUser(userID uint, roleID uint, domain ...string) (bool, error)

	// GetPermissionsForUser 获取用户的所有权限
	GetPermissionsForUser(userID uint, domain ...string) ([][]string, error)

	// StopAutoLoadPolicy 停止定期重载策略
	StopAutoLoadPolicy()

	// NewTxCasbin 构造绑定指定数据库事务的临时casbin操作视图，
	// 用于将策略写入纳入DB事务，与业务表写原子提交/回滚（提交后需ReloadPolicy刷新全局内存）
	NewTxCasbin(tx *gorm.DB) (CasbinInterf, error)

	// ReloadPolicy 重新加载全部策略到enforcer内存
	ReloadPolicy() error

	// PrefixDomain
	PrefixDomain(tenantID uint) string
}
