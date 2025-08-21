package casbinhelper

import (
	"fmt"
	"gin-fast/app/global/g"
	"log"
	"net/http"
	"sync"

	"github.com/casbin/casbin/v2"
	"github.com/casbin/casbin/v2/model"
	gormadapter "github.com/casbin/gorm-adapter/v3"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// CasbinService Casbin服务
type CasbinService struct {
	enforcer *casbin.Enforcer
}

var (
	casbinInstance *CasbinService
	casbinOnce     sync.Once
)

// GetCasbinService 获取Casbin服务单例
func GetCasbinService() *CasbinService {
	casbinOnce.Do(func() {
		casbinInstance = &CasbinService{}
		err := casbinInstance.InitCasbin(g.DB())
		if err != nil {
			log.Fatal("Failed to initialize Casbin service: ", err)
		}
	})
	return casbinInstance
}

// NewCasbinService 创建Casbin服务实例
func NewCasbinService() *CasbinService {
	return &CasbinService{}
}

// InitCasbin 初始化Casbin
func (s *CasbinService) InitCasbin(db *gorm.DB) error {

	m, err := model.NewModelFromString(g.ConfigYml.GetString("Casbin.ModelConfig"))
	if err != nil {
		return fmt.Errorf("failed to create model: %v", err)
	}

	// 创建Gorm适配器，指定表名为tb_auth_casbin_rule
	// 首先检查数据库连接是否正常
	sqlDB, err := db.DB()
	if err != nil {
		return fmt.Errorf("failed to get database instance: %v", err)
	}

	// 检查数据库连接是否正常
	if err = sqlDB.Ping(); err != nil {
		return fmt.Errorf("database connection is not alive: %v", err)
	}

	// 使用自定义表结构初始化适配器，避免索引过长问题
	adapter, err := gormadapter.NewAdapterByDBWithCustomTable(db, &gormadapter.CasbinRule{
		Ptype: "varchar(50)",
		V0:    "varchar(50)",
		V1:    "varchar(50)",
		V2:    "varchar(50)",
		V3:    "varchar(50)",
		V4:    "varchar(50)",
		V5:    "varchar(50)",
	}, "casbin_rule")
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

	return nil
}

// Enforce 检查权限
func (s *CasbinService) Enforce(sub, obj, act string) (bool, error) {
	if s.enforcer == nil {
		return false, fmt.Errorf("casbin enforcer not initialized")
	}
	return s.enforcer.Enforce(sub, obj, act)
}

// GetEnforcer 获取Casbin执行器
func (s *CasbinService) GetEnforcer() *casbin.Enforcer {
	return s.enforcer
}

// CasbinMiddleware Casbin权限中间件
func (s *CasbinService) CasbinMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 从上下文中获取用户角色
		role, exists := c.Get("role")
		if !exists {
			c.JSON(http.StatusForbidden, gin.H{"error": "Role not found"})
			c.Abort()
			return
		}

		// 获取请求路径和方法
		path := c.Request.URL.Path
		method := c.Request.Method

		// 检查权限
		ok, err := s.Enforce(role.(string), path, method)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error occurred when authorizing user"})
			c.Abort()
			return
		}

		if !ok {
			c.JSON(http.StatusForbidden, gin.H{"error": "You don't have permission to access this resource"})
			c.Abort()
			return
		}

		c.Next()
	}
}

// AddPolicy 添加策略
func (s *CasbinService) AddPolicy(sub, obj, act string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	_, err := s.enforcer.AddPolicy(sub, obj, act)
	return err
}

// RemovePolicy 删除策略
func (s *CasbinService) RemovePolicy(sub, obj, act string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	_, err := s.enforcer.RemovePolicy(sub, obj, act)
	return err
}

// AddRoleForUser 为用户添加角色
func (s *CasbinService) AddRoleForUser(user, role string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	_, err := s.enforcer.AddRoleForUser(user, role)
	return err
}

// DeleteRoleForUser 删除用户的角色
func (s *CasbinService) DeleteRoleForUser(user, role string) error {
	if s.enforcer == nil {
		return fmt.Errorf("casbin enforcer not initialized")
	}
	_, err := s.enforcer.DeleteRoleForUser(user, role)
	return err
}
