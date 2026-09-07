package controllers

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestIsAllowedImageExt(t *testing.T) {
	cases := []struct {
		name     string
		filename string
		allowed  bool
	}{
		{"jpg", "avatar.jpg", true},
		{"jpeg", "avatar.jpeg", true},
		{"png", "avatar.png", true},
		{"gif", "avatar.gif", true},
		{"bmp", "avatar.bmp", true},
		{"大写扩展名", "avatar.PNG", true},
		{"混合大小写", "avatar.JpEg", true},
		// 上传服务 FileType 为小写带点格式，同样应通过
		{"仅扩展名（FileType 格式）", ".jpg", true},
		// 非图片必须拒绝
		{"pdf", "avatar.pdf", false},
		{"无扩展名", "avatar", false},
		{"双扩展名伪装", "avatar.php.jpg", true}, // 按最后扩展名判定，与上传服务行为一致
		{"html", "avatar.html", false},
		{"svg", "avatar.svg", false},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.allowed, isAllowedImageExt(tc.filename))
		})
	}
}
