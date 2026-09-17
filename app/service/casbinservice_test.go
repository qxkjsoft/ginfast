package service

import (
	"context"
	"errors"
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

// stubCasbinOps 通过嵌入接口覆写所需方法，模拟全局/事务两种 casbin 操作目标
type stubCasbinOps struct {
	app.CasbinInterf // 嵌入nil接口以实现完整接口，未覆写的方法不应被调用

	removeAllErr   error
	removeAllCalls [][]string // 每次调用的domain参数

	addPoliciesCalls []stubAddPoliciesCall
	addPoliciesErr   error

	deleteUserCalls []stubUserRolesCall
	addUserCalls    []stubUserRolesCall

	deleteInheritCalls []stubInheritCall
	addInheritCalls    []stubInheritCall
}

type stubAddPoliciesCall struct {
	roleID   uint
	policies [][]string
	domain   []string
}

type stubUserRolesCall struct {
	userID uint
	roles  []uint
	domain []string
}

type stubInheritCall struct {
	child  uint
	parent uint
	domain []string
}

func (s *stubCasbinOps) PrefixDomain(tenantID uint) string {
	return fmt.Sprintf("domain_%d", tenantID)
}

func (s *stubCasbinOps) RemoveAllPoliciesForRole(roleID uint, domain ...string) error {
	s.removeAllCalls = append(s.removeAllCalls, domain)
	return s.removeAllErr
}

func (s *stubCasbinOps) AddPoliciesForRole(roleID uint, policies [][]string, domain ...string) error {
	s.addPoliciesCalls = append(s.addPoliciesCalls, stubAddPoliciesCall{roleID: roleID, policies: policies, domain: domain})
	return s.addPoliciesErr
}

func (s *stubCasbinOps) DeleteRolesForUserByID(userID uint, roleIDs []uint, domain ...string) error {
	s.deleteUserCalls = append(s.deleteUserCalls, stubUserRolesCall{userID: userID, roles: roleIDs, domain: domain})
	return nil
}

func (s *stubCasbinOps) AddRolesForUserByID(userID uint, roleIDs []uint, domain ...string) error {
	s.addUserCalls = append(s.addUserCalls, stubUserRolesCall{userID: userID, roles: roleIDs, domain: domain})
	return nil
}

func (s *stubCasbinOps) DeleteRoleInheritance(childRoleID, parentRoleID uint, domain ...string) error {
	s.deleteInheritCalls = append(s.deleteInheritCalls, stubInheritCall{child: childRoleID, parent: parentRoleID, domain: domain})
	return nil
}

func (s *stubCasbinOps) AddRoleInheritance(childRoleID, parentRoleID uint, domain ...string) error {
	s.addInheritCalls = append(s.addInheritCalls, stubInheritCall{child: childRoleID, parent: parentRoleID, domain: domain})
	return nil
}

// setupStubCasbin 将全局 CasbinV2 替换为 stub（handleTenantID 依赖其 PrefixDomain），测试结束后恢复
func setupStubCasbin(t *testing.T) *stubCasbinOps {
	t.Helper()
	old := app.CasbinV2
	stub := &stubCasbinOps{}
	app.CasbinV2 = stub
	t.Cleanup(func() { app.CasbinV2 = old })
	return stub
}

func TestHandleTenantID(t *testing.T) {
	setupStubCasbin(t)

	t.Run("显式指定租户", func(t *testing.T) {
		assert.Equal(t, []string{"domain_5"}, handleTenantID(context.Background(), 5))
	})

	t.Run("显式传0表示全局租户", func(t *testing.T) {
		assert.Nil(t, handleTenantID(context.Background(), 0))
	})

	t.Run("缺省且非gin上下文回退全局", func(t *testing.T) {
		assert.Nil(t, handleTenantID(context.Background()))
	})

	t.Run("缺省且gin上下文无claims回退全局", func(t *testing.T) {
		gin.SetMode(gin.TestMode)
		ctx, _ := gin.CreateTestContext(nil)
		assert.Nil(t, handleTenantID(ctx))
	})
}

func TestDeleteRoleApis(t *testing.T) {
	setupStubCasbin(t)

	t.Run("正常清空并传递租户域", func(t *testing.T) {
		ops := &stubCasbinOps{}
		assert.NoError(t, deleteRoleApis(ops, context.Background(), 7, 5))
		assert.Len(t, ops.removeAllCalls, 1)
		assert.Equal(t, []string{"domain_5"}, ops.removeAllCalls[0])
	})

	t.Run("清空失败错误向上传播", func(t *testing.T) {
		ops := &stubCasbinOps{removeAllErr: errors.New("remove failed")}
		err := deleteRoleApis(ops, context.Background(), 7, 5)
		assert.EqualError(t, err, "remove failed")
	})
}

func TestAddPoliciesForRole(t *testing.T) {
	setupStubCasbin(t)

	t.Run("先清空再添加并去重", func(t *testing.T) {
		ops := &stubCasbinOps{}
		apis := models.SysApiList{
			&models.SysApi{Path: "/api/a", Method: "GET"},
			&models.SysApi{Path: "/api/a", Method: "GET"},
			&models.SysApi{Path: "/api/b", Method: "POST"},
		}
		assert.NoError(t, addPoliciesForRole(ops, context.Background(), 3, apis, 5))
		assert.Len(t, ops.removeAllCalls, 1)
		assert.Len(t, ops.addPoliciesCalls, 1)
		assert.Equal(t, uint(3), ops.addPoliciesCalls[0].roleID)
		assert.Equal(t, [][]string{{"/api/a", "GET"}, {"/api/b", "POST"}}, ops.addPoliciesCalls[0].policies)
		assert.Equal(t, []string{"domain_5"}, ops.addPoliciesCalls[0].domain)
	})

	t.Run("空API列表只清空不添加", func(t *testing.T) {
		ops := &stubCasbinOps{}
		assert.NoError(t, addPoliciesForRole(ops, context.Background(), 3, models.SysApiList{}, 5))
		assert.Len(t, ops.removeAllCalls, 1)
		assert.Empty(t, ops.addPoliciesCalls)
	})

	t.Run("清空旧权限失败向上传播", func(t *testing.T) {
		ops := &stubCasbinOps{removeAllErr: errors.New("remove failed")}
		apis := models.SysApiList{&models.SysApi{Path: "/api/a", Method: "GET"}}
		err := addPoliciesForRole(ops, context.Background(), 3, apis, 5)
		assert.EqualError(t, err, "remove failed")
		assert.Empty(t, ops.addPoliciesCalls)
	})
}

func TestEditUserRoles_DeleteBeforeAdd(t *testing.T) {
	setupStubCasbin(t)
	ops := &stubCasbinOps{}

	assert.NoError(t, editUserRoles(ops, context.Background(), 9, []uint{1, 2}, 5))

	// 先删全部（roles=nil）再加新角色，两步使用同一租户域
	assert.Equal(t, []stubUserRolesCall{
		{userID: 9, roles: nil, domain: []string{"domain_5"}},
	}, ops.deleteUserCalls)
	assert.Equal(t, []stubUserRolesCall{
		{userID: 9, roles: []uint{1, 2}, domain: []string{"domain_5"}},
	}, ops.addUserCalls)
}

func TestEditRoleInheritance_DeleteThenAdd(t *testing.T) {
	setupStubCasbin(t)
	ops := &stubCasbinOps{}

	assert.NoError(t, editRoleInheritance(ops, context.Background(), 3, 5, 7))

	assert.Equal(t, []stubInheritCall{
		{child: 3, parent: 0, domain: []string{"domain_7"}},
	}, ops.deleteInheritCalls)
	assert.Equal(t, []stubInheritCall{
		{child: 3, parent: 5, domain: []string{"domain_7"}},
	}, ops.addInheritCalls)
}

func TestEditRoleInheritance_ZeroParentOnlyDelete(t *testing.T) {
	setupStubCasbin(t)
	ops := &stubCasbinOps{}

	// parentRoleID=0：只清空继承关系，不添加新的
	assert.NoError(t, editRoleInheritance(ops, context.Background(), 3, 0, 7))
	assert.Len(t, ops.deleteInheritCalls, 1)
	assert.Empty(t, ops.addInheritCalls)
}

func TestScopedPermissionService_DelegatesToOps(t *testing.T) {
	setupStubCasbin(t)
	ops := &stubCasbinOps{}
	ps := NewPermissionService()

	assert.NoError(t, ps.Use(ops).AddRoleForUser(context.Background(), 9, []uint{1}, 5))
	assert.Len(t, ops.addUserCalls, 1)
	assert.Equal(t, uint(9), ops.addUserCalls[0].userID)

	assert.NoError(t, ps.Use(ops).DeleteRoleApis(context.Background(), 8, 5))
	assert.Len(t, ops.removeAllCalls, 1)
}

// 公开方法委托全局 CasbinV2，不应触碰传入的其他ops目标
func TestPermissionService_PublicMethodsUseGlobal(t *testing.T) {
	stub := setupStubCasbin(t)

	assert.NoError(t, NewPermissionService().DeleteRoleApis(context.Background(), 7, 5))
	assert.Len(t, stub.removeAllCalls, 1)
}

// buildRoleTenantMap 构建 roleID → TenantID 映射，用于 casbin 域以角色自身租户为准
func TestBuildRoleTenantMap(t *testing.T) {
	roles := models.SysRoleList{
		{BaseModel: models.BaseModel{ID: 1}, TenantID: 10},
		{BaseModel: models.BaseModel{ID: 2}, TenantID: 20},
		// 同租户多个角色
		{BaseModel: models.BaseModel{ID: 3}, TenantID: 10},
		// 全局租户角色（TenantID=0）
		{BaseModel: models.BaseModel{ID: 4}, TenantID: 0},
	}

	m := buildRoleTenantMap(roles)
	assert.Len(t, m, 4)
	assert.Equal(t, uint(10), m[1])
	assert.Equal(t, uint(20), m[2])
	assert.Equal(t, uint(10), m[3])
	assert.Equal(t, uint(0), m[4])

	// 空列表返回空映射（非 nil）
	empty := buildRoleTenantMap(models.SysRoleList{})
	assert.NotNil(t, empty)
	assert.Len(t, empty, 0)
}
