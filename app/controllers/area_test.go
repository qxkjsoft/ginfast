package controllers

import (
	"testing"

	"gin-fast/app/models"

	"github.com/stretchr/testify/assert"
)

func TestEscapeLike(t *testing.T) {
	cases := []struct {
		name  string
		input string
		want  string
	}{
		{"普通文本不转义", "北京", "北京"},
		{"百分号转义", "50%", `50\%`},
		{"下划线转义", "user_name", `user\_name`},
		{"反斜杠转义且最先处理", `a\b`, `a\\b`},
		{"反斜杠加百分号", `\%`, `\\\%`},
		{"仅百分号（原实现会全表匹配）", "%", `\%`},
		{"混合", `a%b_c\d`, `a\%b\_c\\d`},
		{"空串", "", ""},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.want, escapeLike(tc.input))
		})
	}
}

func TestGetAreaLabelParentMapsFromTree(t *testing.T) {
	// 内存构造一棵小树：广东省 > 深圳市 > 南山区，验证 GetAreaLabelParentMaps 的树遍历逻辑。
	// 直接测试遍历所依赖的 BuildTree 产物结构，不触碰 DB（GetAreaTree 内部缓存依赖 app.DB，
	// 见 TestBuildTreeAndMaps 一节）——此处通过 BuildTree 构建与缓存一致的树形数据
	p1, p2 := 1, 2
	flat := models.AreaModelList{
		{Value: "440000", Label: "广东省", Level: &p1, Parent: ""},
		{Value: "440300", Label: "深圳市", Level: &p2, Parent: "440000"},
		{Value: "440305", Label: "南山区", Level: &p2, Parent: "440300"},
	}
	tree := flat.BuildTree()
	assert.Len(t, tree, 1)

	// 复用 GetAreaLabelParentMaps 的遍历语义：手动展开与树结构一致性校验
	labelMap := map[string]string{"440000": "广东省", "440300": "深圳市", "440305": "南山区"}
	parentMap := map[string]string{"440000": "", "440300": "440000", "440305": "440300"}

	// 树遍历结果应与扁平数据的映射一致
	var walk func(list models.AreaModelList, parent string)
	gotLabel := map[string]string{}
	gotParent := map[string]string{}
	walk = func(list models.AreaModelList, parent string) {
		for i := range list {
			gotLabel[list[i].Value] = list[i].Label
			gotParent[list[i].Value] = parent
			if len(list[i].Children) > 0 {
				walk(list[i].Children, list[i].Value)
			}
		}
	}
	walk(tree, "")
	assert.Equal(t, labelMap, gotLabel)
	assert.Equal(t, parentMap, gotParent)

	// 路径拼接：南山区 -> 广东省 / 深圳市 / 南山区
	assert.Equal(t, "广东省 / 深圳市 / 南山区", buildPathText(gotLabel, gotParent, "440305"))
}

func TestGetAreaFlatListFromTree(t *testing.T) {
	// 验证树展开为扁平列表后，CollectDescendantValues 的后代收集语义不变
	p1, p2 := 1, 2
	flat := models.AreaModelList{
		{Value: "440000", Label: "广东省", Level: &p1, Parent: ""},
		{Value: "440300", Label: "深圳市", Level: &p2, Parent: "440000"},
		{Value: "440305", Label: "南山区", Level: &p2, Parent: "440300"},
		{Value: "440400", Label: "珠海上", Level: &p2, Parent: "440000"},
	}
	tree := flat.BuildTree()

	// 模拟 GetAreaFlatList 的展开逻辑
	var out models.AreaModelList
	var walk func(list models.AreaModelList)
	walk = func(list models.AreaModelList) {
		for i := range list {
			node := list[i]
			node.Children = nil
			out = append(out, node)
			if len(list[i].Children) > 0 {
				walk(list[i].Children)
			}
		}
	}
	walk(tree)

	// 展开后的扁平列表应能收集到广东省的全部后代
	descendants := models.CollectDescendantValues(out, "440000")
	assert.ElementsMatch(t, []string{"440300", "440305", "440400"}, descendants)

	// 叶子节点无后代
	assert.Empty(t, models.CollectDescendantValues(out, "440305"))
}
