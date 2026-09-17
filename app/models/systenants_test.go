package models

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestMenuPermissionIDs(t *testing.T) {
	cases := []struct {
		name string
		csv  string
		want []uint
	}{
		{"空串返回nil", "", nil},
		{"正常逗号分隔", "1,2,15", []uint{1, 2, 15}},
		{"容忍空格", " 1 , 2 ,3", []uint{1, 2, 3}},
		{"跳过空片段", "1,,2,", []uint{1, 2}},
		{"跳过非法片段", "1,abc,,x3,4", []uint{1, 4}},
		{"仅非法内容返回空切片", "a,b", []uint{}},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			tenant := NewTenant()
			tenant.MenuPermission = tc.csv
			assert.Equal(t, tc.want, tenant.MenuPermissionIDs())
		})
	}
}
