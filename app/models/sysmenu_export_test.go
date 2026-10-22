package models

import "testing"

// TestGetMenusByIDs 验证按ID精确过滤：仅命中指定ID（不含子级），重复ID与不存在ID不产生额外数据，空入参返回nil
func TestGetMenusByIDs(t *testing.T) {
	newMenu := func(id, parentID uint) *SysMenu {
		return &SysMenu{BaseModel: BaseModel{ID: id}, ParentID: parentID}
	}
	// 结构：1(根) -> 2 -> 3；4(根)
	list := SysMenuList{
		newMenu(1, 0),
		newMenu(2, 1),
		newMenu(3, 2),
		newMenu(4, 0),
	}

	// 勾选中间节点 2：仅返回 2 本身，不包含子级 3，也不包含父级 1
	got := list.GetMenusByIDs(2)
	if len(got) != 1 || got[0].ID != 2 {
		t.Fatalf("仅勾选节点自身: 期望 [2], 实际 %v", got.Map(func(m *SysMenu) uint { return m.ID }))
	}

	// 多ID + 不存在ID + 重复ID：只返回存在的且不重复
	got = list.GetMenusByIDs(4, 2, 999, 4)
	if len(got) != 2 {
		t.Fatalf("多ID过滤: 期望 2 条, 实际 %d 条", len(got))
	}
	if got[0].ID != 2 || got[1].ID != 4 {
		t.Fatalf("多ID过滤: 期望按原列表顺序 [2 4], 实际 [%d %d]", got[0].ID, got[1].ID)
	}

	// 全部不存在的ID：返回空列表
	if got := list.GetMenusByIDs(999); len(got) != 0 {
		t.Fatalf("全部不存在ID: 期望空, 实际 %v", got.Map(func(m *SysMenu) uint { return m.ID }))
	}

	// 空入参：返回 nil
	if got := list.GetMenusByIDs(); got != nil {
		t.Fatalf("空入参: 期望 nil, 实际 %v", got.Map(func(m *SysMenu) uint { return m.ID }))
	}

	// 空列表：返回 nil
	if got := (SysMenuList{}).GetMenusByIDs(1); got != nil {
		t.Fatalf("空列表: 期望 nil, 实际 %v", got.Map(func(m *SysMenu) uint { return m.ID }))
	}
}

// TestExportIncludeChildrenBranch 验证导出两种模式的最终树结果：
// 包含子级（GetMenusWithChildern）导出全部子孙；仅勾选节点（GetMenusByIDs）导出单个节点，
// 且孤儿父级经 FixOrphanParentIDs 修复后 parentId 置 0
func TestExportIncludeChildrenBranch(t *testing.T) {
	newMenu := func(id, parentID uint) *SysMenu {
		return &SysMenu{BaseModel: BaseModel{ID: id}, ParentID: parentID}
	}
	list := SysMenuList{
		newMenu(1, 0),
		newMenu(2, 1),
		newMenu(3, 2),
	}

	// 模式一：包含子级（默认行为），勾选 1 应得到 1、2、3 三层树
	withChildren := list.GetMenusWithChildern(1)
	if len(withChildren) != 3 {
		t.Fatalf("包含子级: 期望 3 条, 实际 %d 条", len(withChildren))
	}
	tree := withChildren.BuildTree()
	if len(tree) != 1 || len(tree[0].Children) != 1 || len(tree[0].Children[0].Children) != 1 {
		t.Fatalf("包含子级: 期望三层嵌套树, 实际结构不符")
	}

	// 模式二：仅勾选节点，勾选 3 应只得到 3 本身，父级 2 不在集内，parentId 被修复为 0
	onlyChecked := list.GetMenusByIDs(3)
	if len(onlyChecked) != 1 || onlyChecked[0].ID != 3 {
		t.Fatalf("仅勾选节点: 期望 [3], 实际 %v", onlyChecked.Map(func(m *SysMenu) uint { return m.ID }))
	}
	fixed := onlyChecked.FixOrphanParentIDs()
	if fixed[0].ParentID != 0 {
		t.Fatalf("孤儿父级修复: 期望 parentId=0, 实际 %d", fixed[0].ParentID)
	}
	if tree := fixed.BuildTree(); len(tree) != 1 || tree[0].ID != 3 {
		t.Fatalf("仅勾选节点建树: 期望单根节点 3, 实际不符")
	}
}
