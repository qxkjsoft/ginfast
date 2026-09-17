package service

import (
	"testing"

	"gin-fast/app/models"

	"github.com/stretchr/testify/assert"
)

// buildBackupTestMenus 构造测试用平铺菜单：
// 1-系统管理(目录) -> 2-用户管理(菜单) -> 3-新增用户(按钮)、4-删除用户(按钮)；5-系统监控(目录)
func buildBackupTestMenus() models.SysMenuList {
	return models.SysMenuList{
		{BaseModel: models.BaseModel{ID: 1}, ParentID: 0, Type: 1, Path: "/system", Title: "系统管理"},
		{BaseModel: models.BaseModel{ID: 2}, ParentID: 1, Type: 2, Path: "user", Title: "用户管理"},
		{BaseModel: models.BaseModel{ID: 3}, ParentID: 2, Type: 3, Permission: "system:user:add", Title: "新增用户"},
		{BaseModel: models.BaseModel{ID: 4}, ParentID: 2, Type: 3, Permission: "system:user:del", Title: "删除用户"},
		{BaseModel: models.BaseModel{ID: 5}, ParentID: 0, Type: 1, Path: "/monitor", Title: "系统监控"},
	}
}

func TestMergeBackupMenus(t *testing.T) {
	ids := func(list models.SysMenuList) []uint {
		result := make([]uint, 0, len(list))
		for _, menu := range list {
			result = append(result, menu.ID)
		}
		return result
	}

	t.Run("勾选目录-包含全部子级", func(t *testing.T) {
		merged := mergeBackupMenus(buildBackupTestMenus(), []uint{1})
		assert.ElementsMatch(t, []uint{1, 2, 3, 4}, ids(merged))
	})

	t.Run("只勾按钮-补充父级链且不含兄弟节点", func(t *testing.T) {
		merged := mergeBackupMenus(buildBackupTestMenus(), []uint{3})
		assert.ElementsMatch(t, []uint{1, 2, 3}, ids(merged))
	})

	t.Run("父子同时勾选-去重无重复", func(t *testing.T) {
		merged := mergeBackupMenus(buildBackupTestMenus(), []uint{1, 2, 3})
		assert.Len(t, merged, 4)
		assert.ElementsMatch(t, []uint{1, 2, 3, 4}, ids(merged))
	})

	t.Run("勾选不存在的菜单-返回空", func(t *testing.T) {
		merged := mergeBackupMenus(buildBackupTestMenus(), []uint{999})
		assert.True(t, merged.IsEmpty())
	})

	t.Run("只勾按钮的合并结果-建树后树校验通过", func(t *testing.T) {
		merged := mergeBackupMenus(buildBackupTestMenus(), []uint{3})
		tree := merged.FixOrphanParentIDs().BuildTree()
		// 根级只应有目录节点 1（按钮 3 挂在菜单 2 下），树校验无错误
		assert.Len(t, tree, 1)
		assert.Empty(t, tree.ValidateTree())
	})
}
