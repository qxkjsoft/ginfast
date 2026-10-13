package models

import "testing"

// TestMenuTreeSort 验证菜单树排序：sort 升序（0 为合法值排最前），相同值按 ID 升序，子级递归生效
func TestMenuTreeSort(t *testing.T) {
	newMenu := func(id, parentID uint, sort int) *SysMenu {
		return &SysMenu{BaseModel: BaseModel{ID: id}, ParentID: parentID, Sort: sort}
	}
	// 根级：home(0)、system(99)、demo(99)、jobs(99)；system 子级：2、1、0、1（含相同值）
	list := SysMenuList{
		newMenu(140350, 0, 99),
		newMenu(140427, 0, 99),
		newMenu(140432, 0, 99),
		newMenu(140440, 0, 0),
		newMenu(140351, 140350, 2),
		newMenu(140355, 140350, 1),
		newMenu(140363, 140350, 1),
		newMenu(140367, 140350, 0),
	}
	tree := list.BuildTree().TreeSort()

	if len(tree) != 4 {
		t.Fatalf("根节点数量错误: 期望 4, 实际 %d", len(tree))
	}
	// 根级期望：home(0) 最前，三个 99 按 ID 升序稳定排列
	wantRoots := []uint{140440, 140350, 140427, 140432}
	for i, m := range tree {
		if m.ID != wantRoots[i] {
			t.Fatalf("根级排序错误: 期望 %v, 实际首项 %d（第 %d 位为 %d）", wantRoots, tree[0].ID, i, m.ID)
		}
	}

	children := tree[1].Children // system(140350) 的子级
	if len(children) != 4 {
		t.Fatalf("子节点数量错误: 期望 4, 实际 %d", len(children))
	}
	// 子级期望：0(140367) < 1(140355) < 1(140363，相同值按ID) < 2(140351)
	wantChildren := []uint{140367, 140355, 140363, 140351}
	for i, c := range children {
		if c.ID != wantChildren[i] {
			t.Fatalf("子级排序错误: 期望 %v, 实际 [%d %d %d %d]", wantChildren,
				children[0].ID, children[1].ID, children[2].ID, children[3].ID)
		}
	}
}
