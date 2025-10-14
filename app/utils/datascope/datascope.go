package datascope

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// 获取用户角色列表
func getUserRoles(userID uint) ([]*models.SysRole, error) {
	var user models.User
	err := app.DB().Preload("Roles").Where("id = ?", userID).First(&user).Error
	if err != nil {
		return nil, err
	}
	return user.Roles, nil
}

// 获取部门及其所有子部门ID
func getDepartmentAndChildrenIDs(departmentTree models.SysDepartmentList, deptID uint) ([]uint, error) {

	if departmentTree.IsEmpty() {
		return []uint{deptID}, nil
	}
	// 递归查找目标部门（支持任意层级）
	var findDepartment func(depts models.SysDepartmentList, targetID uint) *models.SysDepartment
	findDepartment = func(depts models.SysDepartmentList, targetID uint) *models.SysDepartment {
		for _, dept := range depts {
			if dept.ID == targetID {
				return dept
			}
			if len(dept.Children) > 0 {
				if found := findDepartment(dept.Children, targetID); found != nil {
					return found
				}
			}
		}
		return nil
	}

	// 查找目标部门
	targetDept := findDepartment(departmentTree, deptID)

	if targetDept == nil {
		return []uint{deptID}, nil
	}

	// 递归获取所有子部门ID
	var getAllChildrenIDs func(dept *models.SysDepartment, ids *[]uint)
	getAllChildrenIDs = func(dept *models.SysDepartment, ids *[]uint) {
		*ids = append(*ids, dept.ID)
		if len(dept.Children) > 0 {
			for _, child := range dept.Children {
				getAllChildrenIDs(child, ids)
			}
		}
	}

	var deptIDs []uint
	getAllChildrenIDs(targetDept, &deptIDs)
	return deptIDs, nil
}

// 字符串转uint切片
func stringToUintSlice(s string) ([]uint, error) {
	if s == "" {
		return []uint{}, nil
	}

	parts := strings.Split(s, ",")
	var result []uint
	for _, part := range parts {
		part = strings.TrimSpace(part)
		if part != "" {
			id, err := strconv.ParseUint(part, 10, 32)
			if err != nil {
				return nil, err
			}
			result = append(result, uint(id))
		}
	}
	return result, nil
}

// 获取用户所属部门ID
func getUserDepartmentID(userID uint) (uint, error) {
	var user models.User
	err := app.DB().Select("dept_id").Where("id = ?", userID).First(&user).Error
	if err != nil {
		return 0, err
	}
	return user.DeptID, nil
}

// 根据部门ID获取用户ID列表
func getUserIDsByDepartmentIDs(deptIDs []uint) ([]uint, error) {
	if len(deptIDs) == 0 {
		return []uint{}, nil
	}

	var users []models.User
	err := app.DB().Select("id").Where("dept_id IN ?", deptIDs).Find(&users).Error
	if err != nil {
		return nil, err
	}

	var userIDs []uint
	for _, user := range users {
		userIDs = append(userIDs, user.ID)
	}
	return userIDs, nil
}

// 数据权限(默认可以查看自己创建的数据)
func GetDataScope(c *gin.Context) func(db *gorm.DB) *gorm.DB {
	// 定义数据权限函数
	return func(db *gorm.DB) *gorm.DB {
		claims := common.GetClaims(c)
		if claims == nil {
			return db.Where("1 = 0")
		}

		userID := claims.UserID
		if userID == 0 {
			return db.Where("1 = 0")
		}
		notCheckUserIds := app.ConfigYml.GetUintSlice("server.notcheckuser")
		// 检查用户是否在不检查权限的用户列表中
		for _, notCheckUserID := range notCheckUserIds {
			if notCheckUserID == userID {
				// 如果用户在不检查权限的用户列表中，直接返回所有数据
				return db
			}
		}

		// 获取用户角色
		roles, err := getUserRoles(userID)
		if err != nil || len(roles) == 0 {
			// 如果没有角色或查询失败，默认只能查看自己的数据
			return db.Where("created_by = ?", userID)
		}

		// 检查是否有全表权限的角色
		hasFullPermission := false
		for _, role := range roles {
			if role.DataScope == 1 {
				hasFullPermission = true
				break
			}
		}

		if hasFullPermission {
			// 有全表权限，不添加任何限制
			return db
		}

		// 收集所有需要查询的部门ID
		allowedDeptIDs := make(map[uint]bool)

		// 获取用户所属部门ID（只查询一次）
		userDeptID, _ := getUserDepartmentID(userID)

		// 构建部门树
		var allDepartments models.SysDepartmentList
		err = app.DB().Find(&allDepartments).Error
		if err != nil {
			// 查询失败，默认只能查看自己的数据
			return db.Where("created_by = ?", userID)
		}
		// 构建部门树
		departmentTree := allDepartments.BuildTree()

		// 收集所有需要处理的部门ID
		var allDeptIDs []uint
		for _, role := range roles {
			switch role.DataScope {
			case 2: // 查询checked_depts字段定义的部门所属用户创建的数据
				if role.CheckedDepts != "" {
					deptIDs, err := stringToUintSlice(role.CheckedDepts)
					if err == nil && len(deptIDs) > 0 {
						allDeptIDs = append(allDeptIDs, deptIDs...)
					}
				}

			case 3: // 查询自身所属部门的所属用户创建的数据
				if userDeptID != 0 {
					allDeptIDs = append(allDeptIDs, userDeptID)
				}

			case 4: // 查询自身所属部门及该部门下所有子级部门的所属用户创建的数据
				if userDeptID != 0 {
					deptIDs, err := getDepartmentAndChildrenIDs(departmentTree, userDeptID)
					if err == nil && len(deptIDs) > 0 {
						allDeptIDs = append(allDeptIDs, deptIDs...)
					}
				}
			}
		}

		// 去重部门ID
		for _, deptID := range allDeptIDs {
			allowedDeptIDs[deptID] = true
		}

		// 将部门ID转换为切片
		var deptIDSlice []uint
		for deptID := range allowedDeptIDs {
			deptIDSlice = append(deptIDSlice, deptID)
		}

		// 批量查询所有相关部门的用户ID
		var allowedUserIDs []uint
		if len(deptIDSlice) > 0 {
			userIDs, err := getUserIDsByDepartmentIDs(deptIDSlice)
			if err == nil {
				allowedUserIDs = append(allowedUserIDs, userIDs...)
			}
		}

		// 添加当前用户ID（默认可以查看自己的数据）
		allowedUserIDs = append(allowedUserIDs, userID)

		// 去重用户ID
		userIDMap := make(map[uint]bool)
		var userIDSlice []uint
		for _, uid := range allowedUserIDs {
			if !userIDMap[uid] {
				userIDMap[uid] = true
				userIDSlice = append(userIDSlice, uid)
			}
		}

		// 添加数据权限过滤条件
		return db.Where("created_by IN ?", userIDSlice)
	}
}
