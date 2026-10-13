package controllers

import (
	"gin-fast/app/utils/common"
	"gin-fast/app/utils/tenanthelper"

	"github.com/gin-gonic/gin"
)

// CanManageTenant 判断当前登录用户是否有权操作目标租户的数据（跨租户归属校验）。
// 适用于以请求体 tenantID 为操作目标的租户管理接口，防止租户 A 管理员操作租户 B：
//   - 超管豁免用户（server.notcheckuser / initadmin）恒放行
//   - 多租户关闭（单体模式）恒放行
//   - 全局租户用户（登录租户为 0 的平台级账号）恒放行
//   - 当前登录租户与目标租户相同放行
//   - 其余跨租户操作拒绝
func (cm *Common) CanManageTenant(c *gin.Context, targetTenantID uint) bool {
	return canManageTenant(
		common.IsSkipAuthUser(cm.GetCurrentUserID(c)),
		cm.GetCurrentTenantID(c),
		tenanthelper.MultiTenantEnabled(),
		targetTenantID,
	)
}

// canManageTenant 为 CanManageTenant 的纯逻辑核心，skipAuth 由调用方预先计算，
// 便于在无配置/无 DB 的单测环境中覆盖各分支
func canManageTenant(skipAuth bool, currentTenantID uint, multiTenantEnabled bool, targetTenantID uint) bool {
	if skipAuth {
		return true
	}
	if !multiTenantEnabled {
		return true
	}
	// 全局租户用户（平台级账号）
	if currentTenantID == 0 {
		return true
	}
	return currentTenantID == targetTenantID
}
