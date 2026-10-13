package gormhelper

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

// ---- 测试用模型结构 ----

type innerMost struct {
	TenantID uint `gorm:"column:tenant_id"`
}

type middleEmbed struct {
	innerMost // 二层匿名内嵌（B-23 核心场景）
}

type deepModel struct {
	ID          uint
	Name        string
	middleEmbed // 三层匿名内嵌链
}

type shallowModel struct {
	BaseModelShallow
	Name string
}

// BaseModelShallow 模拟现有模型的一层匿名内嵌
type BaseModelShallow struct {
	ID        uint
	CreatedBy uint `gorm:"column:created_by"`
}

type relatedModel struct {
	ID uint
	// 非匿名关联字段（非指针 Struct），其内部的 TenantID 不属于本表列，不得误探
	Department struct {
		TenantID uint
	}
}

type taggedModel struct {
	CustomTenant uint `gorm:"column:custom_tenant_col"`
}

func TestStructHasSpecialField_TopLevelField(t *testing.T) {
	m := &shallowModel{}
	b, column := structHasSpecialField("CreatedBy", m)
	assert.True(t, b)
	// gorm tag 解析出的列名
	assert.Equal(t, "created_by", column)
}

func TestStructHasSpecialField_TopLevelWithTaggedColumn(t *testing.T) {
	m := &taggedModel{}
	b, column := structHasSpecialField("CustomTenant", m)
	assert.True(t, b)
	assert.Equal(t, "custom_tenant_col", column)
}

func TestStructHasSpecialField_OneLevelEmbed(t *testing.T) {
	// 一层匿名内嵌（现有模型的普遍形态，回归保障）
	m := &shallowModel{}
	b, column := structHasSpecialField("CreatedBy", m)
	assert.True(t, b)
	assert.Equal(t, "created_by", column)
}

func TestStructHasSpecialField_DeepEmbeds(t *testing.T) {
	// B-23 核心：二、三层匿名内嵌链上的字段也能探到（改前静默找不到）
	m := &deepModel{}
	b, column := structHasSpecialField("TenantID", m)
	assert.True(t, b)
	assert.Equal(t, "tenant_id", column)
}

func TestStructHasSpecialField_RelationFieldNotProbed(t *testing.T) {
	// 非匿名关联 Struct 内部的同名字段不得误命中（不属于本表列）
	m := &relatedModel{}
	b, _ := structHasSpecialField("TenantID", m)
	assert.False(t, b)
}

func TestStructHasSpecialField_MissAndMap(t *testing.T) {
	// 字段不存在
	m := &shallowModel{}
	b, _ := structHasSpecialField("NotExists", m)
	assert.False(t, b)

	// Map 形态按键名匹配（CreateBeforeHook 的 map 分支依赖）
	mp := &map[string]interface{}{"tenant_id": 1}
	b, column := structHasSpecialField("tenant_id", mp)
	assert.True(t, b)
	assert.Equal(t, "tenant_id", column)
}
