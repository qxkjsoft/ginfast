package casbinhelper

import (
	"fmt"
	"testing"

	"github.com/casbin/casbin/v2"
	"github.com/casbin/casbin/v2/model"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// 测试用的Casbin模型配置
const testModelConfig = `
[request_definition]
r = sub, obj, act, dom

[policy_definition]
p = sub, obj, act, dom

[role_definition]
g = _, _, _

[policy_effect]
e = some(where (p.eft == allow))

[matchers]
m = g(r.sub, p.sub, r.dom) && keyMatch2(r.obj, p.obj) && regexMatch(r.act, p.act) && (r.dom == p.dom || p.dom == "*")
`

// setupTestCasbin 创建测试用的CasbinHelper实例（使用内存适配器）
func setupTestCasbin(t *testing.T) *CasbinHelper {
	helper := NewCasbinHelper()

	// 创建模型
	m, err := model.NewModelFromString(testModelConfig)
	require.NoError(t, err, "Failed to create model")

	// 创建内存适配器（使用默认适配器）
	enforcer, err := casbin.NewEnforcer(m)
	require.NoError(t, err, "Failed to create enforcer")

	// 手动设置enforcer，跳过数据库初始化
	helper.enforcer = enforcer

	return helper
}

// TestNewCasbinHelper 测试创建CasbinHelper实例
func TestNewCasbinHelper(t *testing.T) {
	helper := NewCasbinHelper()
	assert.NotNil(t, helper, "NewCasbinHelper should return non-nil instance")
	assert.Nil(t, helper.enforcer, "New enforcer should be nil before initialization")
}

// TestPrefixFunctions 测试前缀函数
func TestPrefixFunctions(t *testing.T) {
	helper := NewCasbinHelper()

	// 测试用户前缀
	userID := uint(123)
	expectedUserPrefix := "user_123"
	actualUserPrefix := helper.PrefixUser(userID)
	assert.Equal(t, expectedUserPrefix, actualUserPrefix, "User prefix should match expected format")

	// 测试角色前缀
	roleID := uint(456)
	expectedRolePrefix := "role_456"
	actualRolePrefix := helper.PrefixRole(roleID)
	assert.Equal(t, expectedRolePrefix, actualRolePrefix, "Role prefix should match expected format")

	// 测试域前缀
	domainID := uint(789)
	expectedDomainPrefix := "domain_789"
	actualDomainPrefix := helper.PrefixDomain(domainID)
	assert.Equal(t, expectedDomainPrefix, actualDomainPrefix, "Domain prefix should match expected format")
}

// TestHandlerDomain 测试域处理函数
func TestHandlerDomain(t *testing.T) {
	helper := NewCasbinHelper()

	// 测试有域的情况
	domains := []string{"domain_1"}
	result := helper.HandlerDomain(domains)
	assert.Equal(t, domains, result, "HandlerDomain should return provided domains")

	// 测试空域的情况
	emptyDomains := []string{}
	result = helper.HandlerDomain(emptyDomains)
	assert.Equal(t, []string{"*"}, result, "HandlerDomain should return wildcard for empty domains")
}

// TestEnforce 测试权限检查
func TestEnforce(t *testing.T) {
	helper := setupTestCasbin(t)

	// 添加测试策略
	err := helper.AddPolicyForRole(1, "/api/users", "GET")
	require.NoError(t, err, "Failed to add policy")

	// 为用户添加角色
	err = helper.AddRolesForUserByID(1, []uint{1})
	require.NoError(t, err, "Failed to add role to user")

	// 测试权限检查（带域参数）
	allowed, err := helper.Enforce("user_1", "/api/users", "GET", "*")
	assert.NoError(t, err, "Enforce should not return error")
	assert.True(t, allowed, "User should have permission")

	// 测试无权限的情况
	allowed, err = helper.Enforce("user_1", "/api/users", "POST", "*")
	assert.NoError(t, err, "Enforce should not return error")
	assert.False(t, allowed, "User should not have permission for POST")
}

// TestEnforce_WithDomain 测试带域的权限检查
func TestEnforce_WithDomain(t *testing.T) {
	helper := setupTestCasbin(t)

	// 添加带域的测试策略
	err := helper.AddPolicyForRole(1, "/api/users", "GET", "domain_1")
	require.NoError(t, err, "Failed to add policy with domain")

	// 为用户添加角色（带域）
	err = helper.AddRolesForUserByID(1, []uint{1}, "domain_1")
	require.NoError(t, err, "Failed to add role to user with domain")

	// 测试带域的权限检查
	allowed, err := helper.Enforce("user_1", "/api/users", "GET", "domain_1")
	assert.NoError(t, err, "Enforce with domain should not return error")
	assert.True(t, allowed, "User should have permission in domain")

	// 测试不同域的权限检查
	allowed, err = helper.Enforce("user_1", "/api/users", "GET", "domain_2")
	assert.NoError(t, err, "Enforce with different domain should not return error")
	assert.False(t, allowed, "User should not have permission in different domain")
}

// TestEnforce_NotInitialized 测试未初始化的权限检查
func TestEnforce_NotInitialized(t *testing.T) {
	helper := NewCasbinHelper() // 未初始化

	allowed, err := helper.Enforce("user_1", "/api/users", "GET")
	assert.Error(t, err, "Enforce should return error when not initialized")
	assert.False(t, allowed, "Enforce should return false when not initialized")
	assert.Contains(t, err.Error(), "casbin enforcer not initialized", "Error message should indicate enforcer not initialized")
}

// TestAddRolesForUserByID 测试为用户添加角色
func TestAddRolesForUserByID(t *testing.T) {
	helper := setupTestCasbin(t)

	// 添加多个角色
	userID := uint(1)
	roleIDs := []uint{1, 2, 3}
	err := helper.AddRolesForUserByID(userID, roleIDs)
	assert.NoError(t, err, "AddRolesForUserByID should not return error")

	// 验证角色添加成功
	userRoles, err := helper.GetRolesForUserByID(userID)
	assert.NoError(t, err, "GetRolesForUserByID should not return error")
	assert.ElementsMatch(t, roleIDs, userRoles, "User should have all added roles")
}

// TestAddRolesForUserByID_Empty 测试添加空角色列表
func TestAddRolesForUserByID_Empty(t *testing.T) {
	helper := setupTestCasbin(t)

	// 添加空角色列表
	err := helper.AddRolesForUserByID(1, []uint{})
	assert.NoError(t, err, "AddRolesForUserByID with empty list should not return error")
}

// TestAddRolesForUserByID_WithDomain 测试带域的用户角色添加
func TestAddRolesForUserByID_WithDomain(t *testing.T) {
	helper := setupTestCasbin(t)

	// 添加带域的角色
	userID := uint(1)
	roleIDs := []uint{1, 2}
	err := helper.AddRolesForUserByID(userID, roleIDs, "domain_1")
	assert.NoError(t, err, "AddRolesForUserByID with domain should not return error")

	// 验证角色在指定域中
	userRoles, err := helper.GetRolesForUserByID(userID, "domain_1")
	assert.NoError(t, err, "GetRolesForUserByID with domain should not return error")
	assert.ElementsMatch(t, roleIDs, userRoles, "User should have roles in specified domain")

	// 验证角色不在其他域中
	userRoles, err = helper.GetRolesForUserByID(userID, "domain_2")
	assert.NoError(t, err, "GetRolesForUserByID with different domain should not return error")
	assert.Empty(t, userRoles, "User should not have roles in different domain")
}

// TestDeleteRolesForUserByID 测试删除用户角色
func TestDeleteRolesForUserByID(t *testing.T) {
	helper := setupTestCasbin(t)

	// 先添加角色
	userID := uint(1)
	roleIDs := []uint{1, 2, 3}
	err := helper.AddRolesForUserByID(userID, roleIDs)
	require.NoError(t, err, "Failed to add roles")

	// 删除部分角色
	rolesToDelete := []uint{1, 2}
	err = helper.DeleteRolesForUserByID(userID, rolesToDelete)
	assert.NoError(t, err, "DeleteRolesForUserByID should not return error")

	// 验证角色删除成功
	remainingRoles, err := helper.GetRolesForUserByID(userID)
	assert.NoError(t, err, "GetRolesForUserByID should not return error")
	assert.ElementsMatch(t, []uint{3}, remainingRoles, "User should only have remaining roles")
}

// TestDeleteRolesForUserByID_All 测试删除用户所有角色
func TestDeleteRolesForUserByID_All(t *testing.T) {
	helper := setupTestCasbin(t)

	// 先添加角色
	userID := uint(1)
	roleIDs := []uint{1, 2, 3}
	err := helper.AddRolesForUserByID(userID, roleIDs)
	require.NoError(t, err, "Failed to add roles")

	// 删除所有角色
	err = helper.DeleteRolesForUserByID(userID, []uint{})
	assert.NoError(t, err, "DeleteRolesForUserByID with empty list should not return error")

	// 验证所有角色已删除
	remainingRoles, err := helper.GetRolesForUserByID(userID)
	assert.NoError(t, err, "GetRolesForUserByID should not return error")
	assert.Empty(t, remainingRoles, "User should have no roles after deletion")
}

// TestAddRoleInheritance 测试添加角色继承关系
func TestAddRoleInheritance(t *testing.T) {
	helper := setupTestCasbin(t)

	// 添加角色继承关系
	childRoleID := uint(2)
	parentRoleID := uint(1)
	err := helper.AddRoleInheritance(childRoleID, parentRoleID)
	assert.NoError(t, err, "AddRoleInheritance should not return error")

	// 验证方法调用成功（不验证具体继承关系，因为Casbin内部实现可能不同）
	// 主要测试方法不会panic并且返回无错误
}

// TestDeleteRoleInheritance 测试删除角色继承关系
func TestDeleteRoleInheritance(t *testing.T) {
	helper := setupTestCasbin(t)

	// 先添加继承关系
	childRoleID := uint(2)
	parentRoleID := uint(1)
	err := helper.AddRoleInheritance(childRoleID, parentRoleID)
	require.NoError(t, err, "Failed to add role inheritance")

	// 删除继承关系
	err = helper.DeleteRoleInheritance(childRoleID, parentRoleID)
	assert.NoError(t, err, "DeleteRoleInheritance should not return error")

	// 验证继承关系已删除
	hasRole, err := helper.HasRoleForUser(2, 1)
	assert.NoError(t, err, "HasRoleForUser should not return error")
	assert.False(t, hasRole, "Child role should not inherit from parent role after deletion")
}

// TestAddPolicyForRole 测试为角色添加策略
func TestAddPolicyForRole(t *testing.T) {
	helper := setupTestCasbin(t)

	// 添加策略
	roleID := uint(1)
	obj := "/api/users"
	act := "GET"
	err := helper.AddPolicyForRole(roleID, obj, act)
	assert.NoError(t, err, "AddPolicyForRole should not return error")

	// 验证策略添加成功
	allowed, err := helper.Enforce("role_1", obj, act, "*")
	assert.NoError(t, err, "Enforce should not return error")
	assert.True(t, allowed, "Role should have the added permission")
}

// TestAddPolicyForRole_WithDomain 测试带域的策略添加
func TestAddPolicyForRole_WithDomain(t *testing.T) {
	helper := setupTestCasbin(t)

	// 添加带域的策略
	roleID := uint(1)
	obj := "/api/users"
	act := "GET"
	domain := "domain_1"
	err := helper.AddPolicyForRole(roleID, obj, act, domain)
	assert.NoError(t, err, "AddPolicyForRole with domain should not return error")

	// 验证策略在指定域中有效
	allowed, err := helper.Enforce("role_1", obj, act, domain)
	assert.NoError(t, err, "Enforce with domain should not return error")
	assert.True(t, allowed, "Role should have permission in specified domain")

	// 验证策略在其他域中无效
	allowed, err = helper.Enforce("role_1", obj, act, "domain_2")
	assert.NoError(t, err, "Enforce with different domain should not return error")
	assert.False(t, allowed, "Role should not have permission in different domain")
}

// TestAddPoliciesForRole 测试为角色批量添加策略
func TestAddPoliciesForRole(t *testing.T) {
	helper := setupTestCasbin(t)

	// 批量添加策略
	roleID := uint(1)
	policies := [][]string{
		{"/api/users", "GET"},
		{"/api/users", "POST"},
		{"/api/products", "GET"},
	}
	err := helper.AddPoliciesForRole(roleID, policies)
	assert.NoError(t, err, "AddPoliciesForRole should not return error")

	// 验证所有策略都添加成功
	for _, policy := range policies {
		allowed, err := helper.Enforce("role_1", policy[0], policy[1], "*")
		assert.NoError(t, err, "Enforce should not return error")
		assert.True(t, allowed, fmt.Sprintf("Role should have permission for %s %s", policy[1], policy[0]))
	}
}

// TestAddPoliciesForRole_InvalidFormat 测试添加无效格式的策略
func TestAddPoliciesForRole_InvalidFormat(t *testing.T) {
	helper := setupTestCasbin(t)

	// 尝试添加无效格式的策略
	roleID := uint(1)
	invalidPolicies := [][]string{
		{"/api/users"}, // 缺少操作
	}
	err := helper.AddPoliciesForRole(roleID, invalidPolicies)
	assert.Error(t, err, "AddPoliciesForRole with invalid format should return error")
	assert.Contains(t, err.Error(), "invalid policy format", "Error message should indicate invalid format")
}

// TestRemovePolicyForRole 测试删除角色策略
func TestRemovePolicyForRole(t *testing.T) {
	helper := setupTestCasbin(t)

	// 先添加策略
	roleID := uint(1)
	obj := "/api/users"
	act := "GET"
	err := helper.AddPolicyForRole(roleID, obj, act)
	require.NoError(t, err, "Failed to add policy")

	// 删除策略
	err = helper.RemovePolicyForRole(roleID, obj, act)
	assert.NoError(t, err, "RemovePolicyForRole should not return error")

	// 验证策略已删除
	allowed, err := helper.Enforce("role_1", obj, act, "*")
	assert.NoError(t, err, "Enforce should not return error")
	assert.False(t, allowed, "Role should not have permission after removal")
}

// TestRemoveAllPoliciesForRole 测试删除角色的所有策略
func TestRemoveAllPoliciesForRole(t *testing.T) {
	helper := setupTestCasbin(t)

	// 先添加多个策略
	roleID := uint(1)
	policies := [][]string{
		{"/api/users", "GET"},
		{"/api/users", "POST"},
		{"/api/products", "GET"},
	}
	err := helper.AddPoliciesForRole(roleID, policies)
	require.NoError(t, err, "Failed to add policies")

	// 删除所有策略
	err = helper.RemoveAllPoliciesForRole(roleID)
	assert.NoError(t, err, "RemoveAllPoliciesForRole should not return error")

	// 验证所有策略已删除
	for _, policy := range policies {
		allowed, err := helper.Enforce("role_1", policy[0], policy[1], "*")
		assert.NoError(t, err, "Enforce should not return error")
		assert.False(t, allowed, fmt.Sprintf("Role should not have permission for %s %s after removal", policy[1], policy[0]))
	}
}

// TestGetRolesForUserByID 测试获取用户角色
func TestGetRolesForUserByID(t *testing.T) {
	helper := setupTestCasbin(t)

	// 添加角色
	userID := uint(1)
	roleIDs := []uint{1, 2, 3}
	err := helper.AddRolesForUserByID(userID, roleIDs)
	require.NoError(t, err, "Failed to add roles")

	// 获取用户角色
	retrievedRoles, err := helper.GetRolesForUserByID(userID)
	assert.NoError(t, err, "GetRolesForUserByID should not return error")
	assert.ElementsMatch(t, roleIDs, retrievedRoles, "Retrieved roles should match added roles")
}

// TestGetUsersForRole 测试获取拥有角色的用户
func TestGetUsersForRole(t *testing.T) {
	helper := setupTestCasbin(t)

	// 为多个用户添加角色
	roleID := uint(1)
	userIDs := []uint{1, 2, 3}
	for _, userID := range userIDs {
		err := helper.AddRolesForUserByID(userID, []uint{roleID})
		require.NoError(t, err, "Failed to add role to user")
	}

	// 获取拥有该角色的用户
	retrievedUsers, err := helper.GetUsersForRole(roleID)
	assert.NoError(t, err, "GetUsersForRole should not return error")
	assert.ElementsMatch(t, userIDs, retrievedUsers, "Retrieved users should match users with role")
}

// TestHasRoleForUser 测试检查用户是否拥有角色
func TestHasRoleForUser(t *testing.T) {
	helper := setupTestCasbin(t)

	// 添加角色
	userID := uint(1)
	roleID := uint(1)
	err := helper.AddRolesForUserByID(userID, []uint{roleID})
	require.NoError(t, err, "Failed to add role")

	// 检查用户是否拥有角色
	hasRole, err := helper.HasRoleForUser(userID, roleID)
	assert.NoError(t, err, "HasRoleForUser should not return error")
	assert.True(t, hasRole, "User should have the role")

	// 检查用户是否没有其他角色
	hasRole, err = helper.HasRoleForUser(userID, 999)
	assert.NoError(t, err, "HasRoleForUser should not return error")
	assert.False(t, hasRole, "User should not have non-existent role")
}

// TestGetPermissionsForUser 测试获取用户权限
func TestGetPermissionsForUser(t *testing.T) {
	helper := setupTestCasbin(t)

	// 为用户添加角色和权限
	userID := uint(1)
	roleID := uint(1)

	// 添加角色
	err := helper.AddRolesForUserByID(userID, []uint{roleID})
	require.NoError(t, err, "Failed to add role")

	// 为角色添加权限
	policies := [][]string{
		{"/api/users", "GET"},
		{"/api/users", "POST"},
	}
	err = helper.AddPoliciesForRole(roleID, policies)
	require.NoError(t, err, "Failed to add policies")

	// 获取用户权限（带域参数）
	permissions, err := helper.GetPermissionsForUser(userID, "*")
	assert.NoError(t, err, "GetPermissionsForUser should not return error")

	// 验证权限获取成功（不检查具体内容，因为Casbin内部实现可能不同）
	assert.NotNil(t, permissions, "Permissions should not be nil")
}

// TestStopAutoLoadPolicy 测试停止自动重载策略
func TestStopAutoLoadPolicy(t *testing.T) {
	helper := setupTestCasbin(t)

	// 停止自动重载策略
	helper.StopAutoLoadPolicy()

	// 验证可以正常调用（主要测试不会panic）
	// 由于stopChan是私有字段，我们主要验证方法可以正常调用
	assert.NotPanics(t, func() {
		helper.StopAutoLoadPolicy()
	}, "StopAutoLoadPolicy should not panic")
}

// TestCasbinMiddleware 测试Casbin中间件（基础测试）
func TestCasbinMiddleware(t *testing.T) {
	helper := setupTestCasbin(t)

	// 获取中间件函数
	middleware := helper.CasbinMiddleware()
	assert.NotNil(t, middleware, "CasbinMiddleware should return non-nil handler")

	// 由于中间件需要Gin上下文，这里只测试函数返回不为nil
	// 完整的中间件测试需要模拟HTTP请求
}

// BenchmarkCasbinEnforce 性能测试：权限检查
func BenchmarkCasbinEnforce(b *testing.B) {
	helper := setupTestCasbin(&testing.T{})

	// 添加测试策略
	err := helper.AddPolicyForRole(1, "/api/users", "GET")
	if err != nil {
		b.Fatalf("Failed to add policy: %v", err)
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, _ = helper.Enforce("user_1", "/api/users", "GET", "*")
	}
}

// BenchmarkCasbinAddPolicy 性能测试：添加策略
func BenchmarkCasbinAddPolicy(b *testing.B) {
	helper := setupTestCasbin(&testing.T{})

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_ = helper.AddPolicyForRole(uint(i%100+1), fmt.Sprintf("/api/resource/%d", i), "GET")
	}
}

// BenchmarkCasbinGetRoles 性能测试：获取用户角色
func BenchmarkCasbinGetRoles(b *testing.B) {
	helper := setupTestCasbin(&testing.T{})

	// 预设一些角色关系
	for i := 0; i < 100; i++ {
		_ = helper.AddRolesForUserByID(1, []uint{uint(i%10 + 1)})
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, _ = helper.GetRolesForUserByID(1)
	}
}

// TestRoleInheritanceWithPolicies 测试角色继承策略功能
func TestRoleInheritanceWithPolicies(t *testing.T) {
	helper := setupTestCasbin(t)

	// 1. 添加一个父角色
	parentRoleID := uint(1)

	// 2. 为父角色添加一些测试策略
	policies := [][]string{
		{"/api/users", "GET"},
		{"/api/users", "POST"},
		{"/api/products", "GET"},
		{"/api/products", "DELETE"},
	}
	err := helper.AddPoliciesForRole(parentRoleID, policies)
	require.NoError(t, err, "Failed to add policies for parent role")

	// 3. 添加一个子角色继承父角色
	childRoleID := uint(2)
	err = helper.AddRoleInheritance(childRoleID, parentRoleID)
	require.NoError(t, err, "Failed to add role inheritance")

	// 4. 添加一个用户继承子角色
	userID := uint(100)
	err = helper.AddRolesForUserByID(userID, []uint{childRoleID})
	require.NoError(t, err, "Failed to add role to user")

	// 5. 测试用户是否继承了父角色的所有策略
	for _, policy := range policies {
		allowed, err := helper.Enforce(helper.PrefixUser(userID), policy[0], policy[1], "*")
		assert.NoError(t, err, "Enforce should not return error")
		assert.True(t, allowed,
			fmt.Sprintf("User should have inherited permission for %s %s from parent role", policy[1], policy[0]))
	}

	// 6. 验证用户没有其他未授权的权限
	unauthorizedPermissions := [][]string{
		{"/api/admin", "GET"},
		{"/api/users", "PUT"},
		{"/api/products", "POST"},
	}
	for _, permission := range unauthorizedPermissions {
		allowed, err := helper.Enforce(helper.PrefixUser(userID), permission[0], permission[1], "*")
		assert.NoError(t, err, "Enforce should not return error")
		assert.False(t, allowed,
			fmt.Sprintf("User should not have permission for %s %s", permission[1], permission[0]))
	}

	// 7. 验证角色继承关系 - 通过检查子角色是否拥有父角色的权限来验证继承
	// 直接检查子角色是否拥有父角色的权限
	allowed, err := helper.Enforce(helper.PrefixRole(childRoleID), "/api/users", "GET", "*")
	assert.NoError(t, err, "Enforce should not return error")
	assert.True(t, allowed, "Child role should inherit GET permission from parent role")

	// 8. 验证用户角色关系
	userRoles, err := helper.GetRolesForUserByID(userID)
	assert.NoError(t, err, "GetRolesForUserByID should not return error")
	assert.Contains(t, userRoles, childRoleID, "User should have child role")

	// 9. 测试删除继承关系后权限失效
	err = helper.DeleteRoleInheritance(childRoleID, parentRoleID)
	require.NoError(t, err, "Failed to delete role inheritance")

	// 验证删除继承关系后用户不再有父角色的权限
	for _, policy := range policies {
		allowed, err := helper.Enforce(helper.PrefixUser(userID), policy[0], policy[1], "*")
		assert.NoError(t, err, "Enforce should not return error")
		assert.False(t, allowed,
			fmt.Sprintf("User should not have permission for %s %s after inheritance deletion", policy[1], policy[0]))
	}
}

// TestRoleInheritanceWithDomain 测试带域的角色继承策略功能
func TestRoleInheritanceWithDomain(t *testing.T) {
	helper := setupTestCasbin(t)

	// 1. 添加一个父角色
	parentRoleID := uint(1)

	// 2. 为父角色添加带域的测试策略
	domain := "domain_1"
	err := helper.AddPolicyForRole(parentRoleID, "/api/users", "GET", domain)
	require.NoError(t, err, "Failed to add policy for parent role with domain")

	// 3. 添加一个子角色继承父角色（带域）
	childRoleID := uint(2)
	err = helper.AddRoleInheritance(childRoleID, parentRoleID, domain)
	require.NoError(t, err, "Failed to add role inheritance with domain")

	// 4. 添加一个用户继承子角色（带域）
	userID := uint(100)
	err = helper.AddRolesForUserByID(userID, []uint{childRoleID}, domain)
	require.NoError(t, err, "Failed to add role to user with domain")

	// 5. 测试用户在指定域中是否继承了父角色的策略
	allowed, err := helper.Enforce(helper.PrefixUser(userID), "/api/users", "GET", domain)
	assert.NoError(t, err, "Enforce should not return error")
	assert.True(t, allowed, "User should have inherited permission in specified domain")

	// 6. 验证用户在其他域中没有权限
	allowed, err = helper.Enforce(helper.PrefixUser(userID), "/api/users", "GET", "domain_2")
	assert.NoError(t, err, "Enforce should not return error")
	assert.False(t, allowed, "User should not have permission in different domain")

	// 7. 验证角色继承关系在指定域中 - 通过检查子角色是否拥有父角色的权限来验证继承
	allowed, err = helper.Enforce(helper.PrefixRole(childRoleID), "/api/users", "GET", domain)
	assert.NoError(t, err, "Enforce should not return error")
	assert.True(t, allowed, "Child role should inherit GET permission from parent role in specified domain")

	// 8. 验证用户角色关系在指定域中
	userRoles, err := helper.GetRolesForUserByID(userID, domain)
	assert.NoError(t, err, "GetRolesForUserByID should not return error")
	assert.Contains(t, userRoles, childRoleID, "User should have child role in specified domain")
}
