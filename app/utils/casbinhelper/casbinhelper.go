package casbinhelper

import (
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/utils/common"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/casbin/casbin/v2"
	"github.com/casbin/casbin/v2/model"
	"github.com/casbin/casbin/v2/util"
	gormadapter "github.com/casbin/gorm-adapter/v3"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// 定义前缀常量
const (
	UserPrefix   = "user_"
	RolePrefix   = "role_"
	DomainPrefix = "domain_" // 添加域前缀常量
)

// CasbinService Casbin服务
// 实现 app.CasbinInterf 接口
type CasbinHelper struct {
	enforcer *casbin.Enforcer
	stopChan chan struct{} // 用于停止定期重载goroutine
}

// 编译时检查是否实现了接口
var _ app.CasbinInterf = (*CasbinHelper)(nil)

// NewCasbinService 创建Casbin服务实例
func NewCasbinHelper() *CasbinHelper {
	return &CasbinHelper{}
}

// Close 关闭CasbinHelper，释放资源
func (s *CasbinHelper) Close() {
	s.StopAutoLoadPolicy()
}

// InitCasbin 初始化Casbin
func (s *CasbinHelper) InitCasbin(db *gorm.DB, config string) error {
	m, err := model.NewModelFromString(config)
	if err != nil {
		return fmt.Errorf("failed to create model: %v", err)
	}

	// 首先检查数据库连接是否正常
	sqlDB, err := db.DB()
	if err != nil {
		return fmt.Errorf("failed to get database instance: %v", err)
	}

	// 检查数据库连接是否正常
	if err = sqlDB.Ping(); err != nil {
		return fmt.Errorf("database connection is not alive: %v", err)
	}

	// 创建Casbin适配器
	tablePrefix := app.ConfigYml.GetString("casbin.tableprefix")
	tableName := app.ConfigYml.GetString("casbin.tablename")
	// 禁用自动迁移，避免SQL Server因索引导致ALTER失败
	//gormadapter.TurnOffAutoMigrate(db)
	adapter, err := gormadapter.NewAdapterByDBUseTableName(db, tablePrefix, tableName)
	if err != nil {
		return fmt.Errorf("failed to create Casbin adapter: %v\nTable: %s%s", err, tablePrefix, tableName)
	}

	// 创建Casbin执行器，使用数据库适配器
	s.enforcer, err = casbin.NewEnforcer(m, adapter)
	if err != nil {
		return fmt.Errorf("failed to create enforcer: %v", err)
	}

	// 为角色关系(g)启用域模式匹配
	s.enforcer.AddNamedDomainMatchingFunc("g", "KeyMatch2", util.KeyMatch2)

	// 加载策略
	err = s.enforcer.LoadPolicy()
	if err != nil {
		return fmt.Errorf("failed to load policy: %v", err)
	}

	// 启动定期重载策略的goroutine
	s.startAutoLoadPolicy()

	return nil
}

func (s *CasbinHelper) PrefixUser(userID uint) string {
	return fmt.Sprintf("%s%d", UserPrefix, userID)
}

func (s *CasbinHelper) PrefixRole(roleID uint) string {
	return fmt.Sprintf("%s%d", RolePrefix, roleID)
}

// PrefixDomain 为租户ID添加域前缀
func (s *CasbinHelper) PrefixDomain(domainID uint) string {
	return fmt.Sprintf("%s%d", DomainPrefix, domainID)
}

func (s *CasbinHelper) HandlerDomain(domain []string) []string {
	if len(domain) > 0 {
		return domain
	}
	return []string{"*"}
}

// Enforce 检查权限
func (s *CasbinHelper) Enforce(sub, obj, act string, domain ...string) (bool, error) {
	if s.enforcer == nil {
		return false, fmt.Errorf("casbin enforcer not initialized")
	}
	// 统一使用HandlerDomain处理域参数
	domains := s.HandlerDomain(domain)
	return s.enforcer.Enforce(sub, obj, act, domains[0])
}

// GetEnforcer 获取Casbin执行器
func (s *CasbinHelper) GetEnforcer() *casbin.Enforcer {
	return s.enforcer
}

// CasbinMiddleware Casbin权限中间件
func (s *CasbinHelper) CasbinMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 从上下文中获取用户ID
		userID := common.GetCurrentUserID(c)
		if userID == 0 {
			// 403 禁止访问
			c.JSON(http.StatusForbidden, gin.H{"message": "user ID not found"})
			c.Abort()
			return
		}

		// 检查是否需要跳过权限检查
		notCheckUsers := app.ConfigYml.GetUintSlice("server.notcheckuser")
		for _, uid := range notCheckUsers {
			if userID == uid {
				c.Next()
				return
			}
		}

		// 获取请求路径和方法
		path := c.Request.URL.Path
		method := c.Request.Method

		// 使用带前缀的用户ID进行权限检查
		userSubject := s.PrefixUser(userID)
		// 获取租户ID（如果存在）
		var domain string
		claims := common.GetClaims(c)
		if claims != nil && claims.TenantID > 0 {
			domain = s.PrefixDomain(claims.TenantID)
		}
		var ok bool
		var err error

		// 带租户的权限检查
		app.ZapLog.Info("Permission check with tenant",
			zap.String("uid", userSubject),
			zap.String("domain", domain),
			zap.String("path", path),
			zap.String("method", method))
		// domain为空时，代表全局权限
		ok, err = s.Enforce(userSubject, path, method, domain)

		if err != nil {
			app.ZapLog.Error("Permission check error", zap.Error(err))
			// 500 服务器内部错误
			c.JSON(http.StatusInternalServerError, gin.H{"message": "权限检查时出现错误"})
			c.Abort()
			return
		}

		if !ok {
			app.ZapLog.Warn("Permission denied",
				zap.String("uid", userSubject),
				zap.String("path", path),
				zap.String("method", method))
			// 403 禁止访问
			c.JSON(http.StatusForbidden, gin.H{"message": "您没有权限访问此资源"})
			c.Abort()
			return
		}

		c.Next()
	}
}

// AddRolesForUserByID 为用户ID添加多个角色（带前缀）
func (s *CasbinHelper) AddRolesForUserByID(userID uint, roleIDs []uint, domain ...string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}

	if len(roleIDs) == 0 {
		return nil // 没有角色需要添加
	}

	userSubject := s.PrefixUser(userID)

	// 构建角色主体列表
	roleSubjects := make([]string, len(roleIDs))
	for i, roleID := range roleIDs {
		roleSubjects[i] = s.PrefixRole(roleID)
	}
	var err error
	_, err = s.enforcer.AddRolesForUser(userSubject, roleSubjects, s.HandlerDomain(domain)...)
	if err != nil {
		return fmt.Errorf("failed to add roles for user %d: %v", userID, err)
	}

	return nil
}

// DeleteRolesForUserByID 删除用户ID的多个角色（带前缀）
func (s *CasbinHelper) DeleteRolesForUserByID(userID uint, roleIDs []uint, domain ...string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}

	userSubject := s.PrefixUser(userID)
	// 如果没有角色ID，根据是否有域（租户）来删除所有角色
	if len(roleIDs) == 0 {
		_, err := s.enforcer.DeleteRolesForUser(userSubject, s.HandlerDomain(domain)...)
		if err != nil {
			return fmt.Errorf("failed to delete roles for user %d: %v", userID, err)
		}
		return nil
	}

	// 批量删除角色 - 使用批量操作提高性能
	domains := s.HandlerDomain(domain)
	for _, roleID := range roleIDs {
		roleSubject := s.PrefixRole(roleID)
		// 带域（租户）的角色删除
		_, err := s.enforcer.DeleteRoleForUser(userSubject, roleSubject, domains...)
		if err != nil {
			return fmt.Errorf("failed to delete role %d for user %d: %v", roleID, userID, err)
		}
	}

	return nil
}

// AddRoleInheritance 添加角色继承关系（子角色继承父角色）
func (s *CasbinHelper) AddRoleInheritance(childRoleID, parentRoleID uint, domain ...string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}

	childRole := s.PrefixRole(childRoleID)
	parentRole := s.PrefixRole(parentRoleID)

	_, err := s.enforcer.AddRoleForUser(childRole, parentRole, s.HandlerDomain(domain)...)
	if err != nil {
		return fmt.Errorf("failed to add role inheritance from %d to %d: %v", childRoleID, parentRoleID, err)
	}
	return nil
}

// DeleteRoleInheritance 删除角色继承关系
func (s *CasbinHelper) DeleteRoleInheritance(childRoleID, parentRoleID uint, domain ...string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	childRole := s.PrefixRole(childRoleID)
	parentRole := s.PrefixRole(parentRoleID)

	// 如果没有父角色ID，根据是否有域（租户）来删除所有角色
	if parentRoleID == 0 {
		_, err := s.enforcer.DeleteRolesForUser(childRole, s.HandlerDomain(domain)...)
		if err != nil {
			return fmt.Errorf("failed to delete roles for user %d: %v", childRoleID, err)
		}
		return nil
	}
	// 如果有父角色ID，根据是否有域（租户）来删除继承关系
	_, err := s.enforcer.DeleteRoleForUser(childRole, parentRole, s.HandlerDomain(domain)...)
	if err != nil {
		return fmt.Errorf("failed to delete role inheritance from %d to %d: %v", childRoleID, parentRoleID, err)
	}
	return nil
}

// AddPolicyForRole 为角色添加权限策略
func (s *CasbinHelper) AddPolicyForRole(roleID uint, obj, act string, domain ...string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	roleSubject := s.PrefixRole(roleID)
	// 统一使用HandlerDomain处理域参数
	domains := s.HandlerDomain(domain)
	_, err := s.enforcer.AddPolicy(roleSubject, obj, act, domains[0])
	return err
}

// AddPoliciesForRole 为角色批量添加权限策略
func (s *CasbinHelper) AddPoliciesForRole(roleID uint, policies [][]string, domain ...string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}

	if len(policies) == 0 {
		return nil // 没有策略需要添加
	}

	roleSubject := s.PrefixRole(roleID)

	// 构建完整的策略列表，每个策略的第一个元素是角色主体
	var fullPolicies [][]string
	if len(domain) > 0 {
		// 带域（租户）的策略
		domainStr := domain[0]
		fullPolicies = make([][]string, len(policies))
		for i, policy := range policies {
			// 验证策略格式
			if len(policy) < 2 {
				return fmt.Errorf("invalid policy format: policy must contain at least obj and act, got %v", policy)
			}
			// 创建完整策略：[roleSubject, obj, act, domain...]
			fullPolicy := make([]string, len(policy)+2)
			fullPolicy[0] = roleSubject
			copy(fullPolicy[1:], []string{policy[0], policy[1], domainStr})
			fullPolicies[i] = fullPolicy
		}
	} else {
		// 不带域的策略
		fullPolicies = make([][]string, len(policies))
		for i, policy := range policies {
			// 验证策略格式：每个策略至少包含 obj 和 act
			if len(policy) < 2 {
				return fmt.Errorf("invalid policy format: policy must contain at least obj and act, got %v", policy)
			}
			// 创建完整策略：[roleSubject, obj, act, ...]
			fullPolicy := make([]string, len(policy)+2)
			fullPolicy[0] = roleSubject
			copy(fullPolicy[1:], []string{policy[0], policy[1], "*"})
			fullPolicies[i] = fullPolicy
		}
	}

	// 批量添加策略
	_, err := s.enforcer.AddPolicies(fullPolicies)
	if err != nil {
		return fmt.Errorf("failed to add policies for role %d: %v", roleID, err)
	}

	return nil
}

// RemovePolicyForRole 删除角色的权限策略
func (s *CasbinHelper) RemovePolicyForRole(roleID uint, obj, act string, domain ...string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	roleSubject := s.PrefixRole(roleID)
	// 统一使用HandlerDomain处理域参数
	domains := s.HandlerDomain(domain)
	_, err := s.enforcer.RemovePolicy(roleSubject, obj, act, domains[0])
	return err
}

// RemoveAllPoliciesForRole 删除角色的所有权限策略
func (s *CasbinHelper) RemoveAllPoliciesForRole(roleID uint, domain ...string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	roleSubject := s.PrefixRole(roleID)
	if len(domain) > 0 {
		// 带域（租户）的策略
		_, err := s.enforcer.RemoveFilteredPolicy(0, roleSubject, "", "", domain[0])
		if err != nil {
			return fmt.Errorf("failed to remove all policies for role %d: %v", roleID, err)
		}
		return nil
	}
	// 不带域的策略
	_, err := s.enforcer.RemoveFilteredPolicy(0, roleSubject, "", "", "*")
	if err != nil {
		return fmt.Errorf("failed to remove all policies for role %d: %v", roleID, err)
	}
	return nil
}

// GetRolesForUserByID 获取用户ID的所有角色（去除前缀，返回角色ID）
func (s *CasbinHelper) GetRolesForUserByID(userID uint, domain ...string) ([]uint, error) {
	if s.enforcer == nil {
		return nil, fmt.Errorf("casbin enforcer not initialized")
	}
	userSubject := s.PrefixUser(userID)
	roles, err := s.enforcer.GetRolesForUser(userSubject, s.HandlerDomain(domain)...)
	if err != nil {
		return nil, err
	}

	// 去除角色前缀并转换为uint
	var roleIDs []uint
	for _, role := range roles {
		if strings.HasPrefix(role, RolePrefix) {
			roleIDStr := role[len(RolePrefix):]
			if roleID, err := strconv.ParseUint(roleIDStr, 10, 32); err == nil {
				roleIDs = append(roleIDs, uint(roleID))
			}
		}
	}
	return roleIDs, nil
}

// GetUsersForRole 获取拥有指定角色的所有用户ID（去除前缀，返回用户ID）
func (s *CasbinHelper) GetUsersForRole(roleID uint, domain ...string) ([]uint, error) {
	if s.enforcer == nil {
		return nil, fmt.Errorf("casbin enforcer not initialized")
	}
	roleSubject := s.PrefixRole(roleID)
	users, err := s.enforcer.GetUsersForRole(roleSubject, s.HandlerDomain(domain)...)
	if err != nil {
		return nil, err
	}

	// 去除用户前缀并转换为uint
	var userIDs []uint
	for _, user := range users {
		if strings.HasPrefix(user, UserPrefix) {
			userIDStr := user[len(UserPrefix):]
			if userID, err := strconv.ParseUint(userIDStr, 10, 32); err == nil {
				userIDs = append(userIDs, uint(userID))
			}
		}
	}
	return userIDs, nil
}

// HasRoleForUser 检查用户是否拥有指定角色
func (s *CasbinHelper) HasRoleForUser(userID uint, roleID uint, domain ...string) (bool, error) {
	if s.enforcer == nil {
		return false, fmt.Errorf("casbin enforcer not initialized")
	}
	userSubject := s.PrefixUser(userID)
	roleSubject := s.PrefixRole(roleID)
	return s.enforcer.HasRoleForUser(userSubject, roleSubject, s.HandlerDomain(domain)...)
}

// GetPermissionsForUser 获取用户的所有权限
func (s *CasbinHelper) GetPermissionsForUser(userID uint, domain ...string) ([][]string, error) {
	if s.enforcer == nil {
		return nil, fmt.Errorf("casbin enforcer not initialized")
	}
	userSubject := s.PrefixUser(userID)
	return s.enforcer.GetPermissionsForUser(userSubject, s.HandlerDomain(domain)...)
}

// startAutoLoadPolicy 启动定期重载策略的goroutine
func (s *CasbinHelper) startAutoLoadPolicy() {
	// 从配置文件读取自动重载间隔
	autoLoadSeconds := app.ConfigYml.GetInt("casbin.autoloadpolicyseconds")
	if autoLoadSeconds <= 0 {
		app.ZapLog.Info("AutoLoadPolicySeconds not configured or invalid, skip auto reload policy")
		return
	}

	// 初始化停止通道
	s.stopChan = make(chan struct{})

	go func() {
		ticker := time.NewTicker(time.Duration(autoLoadSeconds) * time.Second)
		defer ticker.Stop()

		app.ZapLog.Info("Started auto reload policy goroutine",
			zap.Int("interval_seconds", autoLoadSeconds))

		for {
			select {
			case <-ticker.C:
				if s.enforcer != nil {
					if err := s.enforcer.LoadPolicy(); err != nil {
						app.ZapLog.Error("Failed to auto reload policy", zap.Error(err))
					} else {
						app.ZapLog.Debug("Auto reload policy successfully")
					}
				}
			case <-s.stopChan:
				app.ZapLog.Info("Auto reload policy goroutine stopped")
				return
			}
		}
	}()
}

// StopAutoLoadPolicy 停止定期重载策略的goroutine
func (s *CasbinHelper) StopAutoLoadPolicy() {
	if s.stopChan != nil {
		close(s.stopChan)
		s.stopChan = nil
	}
}
