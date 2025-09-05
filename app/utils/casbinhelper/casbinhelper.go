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
	gormadapter "github.com/casbin/gorm-adapter/v3"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// 定义前缀常量
const (
	UserPrefix = "user_"
	RolePrefix = "role_"
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

// InitCasbin 初始化Casbin
func (s *CasbinHelper) InitCasbin(db *gorm.DB, config string) error {

	//m, err := model.NewModelFromString(app.ConfigYml.GetString("Casbin.ModelConfig"))
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
	adapter, err := gormadapter.NewAdapterByDBUseTableName(db, app.ConfigYml.GetString("Casbin.TablePrefix"), app.ConfigYml.GetString("Casbin.TableName"))
	if err != nil {
		return fmt.Errorf("failed to create Casbin adapter: %v\nTable: casbin_rule", err)
	}

	// 创建Casbin执行器，使用数据库适配器
	s.enforcer, err = casbin.NewEnforcer(m, adapter)
	if err != nil {
		return fmt.Errorf("failed to create enforcer: %v", err)
	}

	// 加载策略
	err = s.enforcer.LoadPolicy()
	if err != nil {
		return fmt.Errorf("failed to load policy: %v", err)
	}

	// 启动定期重载策略的goroutine
	s.startAutoLoadPolicy()

	return nil
}

// Enforce 检查权限
func (s *CasbinHelper) Enforce(sub, obj, act string) (bool, error) {
	if s.enforcer == nil {
		return false, fmt.Errorf("casbin enforcer not initialized")
	}
	return s.enforcer.Enforce(sub, obj, act)
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
			c.JSON(http.StatusForbidden, gin.H{"message": "User ID not found"})
			c.Abort()
			return
		}

		// 获取请求路径和方法
		path := c.Request.URL.Path
		method := c.Request.Method

		// 使用带前缀的用户ID进行权限检查
		userSubject := fmt.Sprintf("%s%d", UserPrefix, userID)
		app.ZapLog.Info("Permission check", zap.String("uid", userSubject), zap.String("path", path), zap.String("method", method))
		ok, err := s.Enforce(userSubject, path, method)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Error occurred when authorizing user"})
			c.Abort()
			return
		}

		if !ok {
			c.JSON(http.StatusForbidden, gin.H{"message": "You don't have permission to access this resource"})
			c.Abort()
			return
		}

		c.Next()
	}
}

// AddRolesForUserByID 为用户ID添加多个角色（带前缀）
func (s *CasbinHelper) AddRolesForUserByID(userID uint, roleIDs []uint) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}

	if len(roleIDs) == 0 {
		return nil // 没有角色需要添加
	}

	userSubject := fmt.Sprintf("%s%d", UserPrefix, userID)

	// 构建角色主体列表
	roleSubjects := make([]string, len(roleIDs))
	for i, roleID := range roleIDs {
		roleSubjects[i] = fmt.Sprintf("%s%d", RolePrefix, roleID)
	}

	// 批量添加角色
	_, err := s.enforcer.AddRolesForUser(userSubject, roleSubjects)
	if err != nil {
		return fmt.Errorf("failed to add roles for user %d: %v", userID, err)
	}

	return nil
}

// DeleteRolesForUserByID 删除用户ID的多个角色（带前缀）
func (s *CasbinHelper) DeleteRolesForUserByID(userID uint, roleIDs []uint) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}

	userSubject := fmt.Sprintf("%s%d", UserPrefix, userID)
	if len(roleIDs) == 0 {
		_, err := s.enforcer.DeleteRolesForUser(userSubject)
		if err != nil {
			return fmt.Errorf("failed to delete roles for user %d: %v", userID, err)
		}
		return nil
	}

	// 批量删除角色
	for _, roleID := range roleIDs {
		roleSubject := fmt.Sprintf("%s%d", RolePrefix, roleID)
		_, err := s.enforcer.DeleteRoleForUser(userSubject, roleSubject)
		if err != nil {
			return fmt.Errorf("failed to delete role %d for user %d: %v", roleID, userID, err)
		}
	}

	return nil
}

// AddRoleInheritance 添加角色继承关系（子角色继承父角色）
func (s *CasbinHelper) AddRoleInheritance(childRoleID, parentRoleID uint) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	childRole := fmt.Sprintf("%s%d", RolePrefix, childRoleID)
	parentRole := fmt.Sprintf("%s%d", RolePrefix, parentRoleID)
	_, err := s.enforcer.AddRoleForUser(childRole, parentRole)
	return err
}

// DeleteRoleInheritance 删除角色继承关系
func (s *CasbinHelper) DeleteRoleInheritance(childRoleID, parentRoleID uint) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	childRole := fmt.Sprintf("%s%d", RolePrefix, childRoleID)
	parentRole := fmt.Sprintf("%s%d", RolePrefix, parentRoleID)

	if parentRoleID == 0 {
		_, err := s.enforcer.DeleteRolesForUser(childRole)
		if err != nil {
			return fmt.Errorf("failed to delete roles for user %d: %v", childRoleID, err)
		}
		return nil
	}
	_, err := s.enforcer.DeleteRoleForUser(childRole, parentRole)
	return err
}

// AddPolicyForRole 为角色添加权限策略
func (s *CasbinHelper) AddPolicyForRole(roleID uint, obj, act string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	roleSubject := fmt.Sprintf("%s%d", RolePrefix, roleID)
	_, err := s.enforcer.AddPolicy(roleSubject, obj, act)
	return err
}

// AddPoliciesForRole 为角色批量添加权限策略
func (s *CasbinHelper) AddPoliciesForRole(roleID uint, policies [][]string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}

	if len(policies) == 0 {
		return nil // 没有策略需要添加
	}

	roleSubject := fmt.Sprintf("%s%d", RolePrefix, roleID)

	// 构建完整的策略列表，每个策略的第一个元素是角色主体
	fullPolicies := make([][]string, len(policies))
	for i, policy := range policies {
		// 验证策略格式：每个策略至少包含 obj 和 act
		if len(policy) < 2 {
			return fmt.Errorf("invalid policy format: policy must contain at least obj and act, got %v", policy)
		}
		// 创建完整策略：[roleSubject, obj, act, ...]
		fullPolicy := make([]string, len(policy)+1)
		fullPolicy[0] = roleSubject
		copy(fullPolicy[1:], policy)
		fullPolicies[i] = fullPolicy
	}

	// 批量添加策略
	_, err := s.enforcer.AddPolicies(fullPolicies)
	if err != nil {
		return fmt.Errorf("failed to add policies for role %d: %v", roleID, err)
	}

	return nil
}

// RemovePolicyForRole 删除角色的权限策略
func (s *CasbinHelper) RemovePolicyForRole(roleID uint, obj, act string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	roleSubject := fmt.Sprintf("%s%d", RolePrefix, roleID)
	_, err := s.enforcer.RemovePolicy(roleSubject, obj, act)
	return err
}

// RemoveAllPoliciesForRole 删除角色的所有权限策略
func (s *CasbinHelper) RemoveAllPoliciesForRole(roleID uint) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	roleSubject := fmt.Sprintf("%s%d", RolePrefix, roleID)
	_, err := s.enforcer.RemoveFilteredPolicy(0, roleSubject)
	if err != nil {
		return fmt.Errorf("failed to remove all policies for role %d: %v", roleID, err)
	}
	return nil
}

// GetRolesForUserByID 获取用户ID的所有角色（去除前缀，返回角色ID）
func (s *CasbinHelper) GetRolesForUserByID(userID uint) ([]uint, error) {
	if s.enforcer == nil {
		return nil, fmt.Errorf("casbin enforcer not initialized")
	}
	userSubject := fmt.Sprintf("%s%d", UserPrefix, userID)
	roles, err := s.enforcer.GetRolesForUser(userSubject)
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

// GetUsersForRole 获取拥有指定角色的所有用户ID（去除前缀）
func (s *CasbinHelper) GetUsersForRole(roleID uint) ([]uint, error) {
	if s.enforcer == nil {
		return nil, fmt.Errorf("casbin enforcer not initialized")
	}
	roleSubject := fmt.Sprintf("%s%d", RolePrefix, roleID)
	users, err := s.enforcer.GetUsersForRole(roleSubject)
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
func (s *CasbinHelper) HasRoleForUser(userID uint, roleID uint) (bool, error) {
	if s.enforcer == nil {
		return false, fmt.Errorf("casbin enforcer not initialized")
	}
	userSubject := fmt.Sprintf("%s%d", UserPrefix, userID)
	roleSubject := fmt.Sprintf("%s%d", RolePrefix, roleID)
	return s.enforcer.HasRoleForUser(userSubject, roleSubject)
}

// GetPermissionsForUser 获取用户的所有权限
func (s *CasbinHelper) GetPermissionsForUser(userID uint) ([][]string, error) {
	if s.enforcer == nil {
		return nil, fmt.Errorf("casbin enforcer not initialized")
	}
	userSubject := fmt.Sprintf("%s%d", UserPrefix, userID)
	return s.enforcer.GetPermissionsForUser(userSubject)
}

// startAutoLoadPolicy 启动定期重载策略的goroutine
func (s *CasbinHelper) startAutoLoadPolicy() {
	// 从配置文件读取自动重载间隔
	autoLoadSeconds := app.ConfigYml.GetInt("Casbin.AutoLoadPolicySeconds")
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
