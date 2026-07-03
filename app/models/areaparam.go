package models

import "github.com/gin-gonic/gin"

// AreaAddRequest 新增地区请求结构
type AreaAddRequest struct {
	Validator
	Value  string `form:"value" validate:"required" message:"地区编码不能为空"`
	Label  string `form:"label" validate:"required" message:"地区名称不能为空"`
	Parent string `form:"parent"`
	Sort   *int   `form:"sort"`
}

func (r *AreaAddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// AreaUpdateRequest 更新地区请求结构（用主键 id 定位）
type AreaUpdateRequest struct {
	Validator
	ID    uint   `form:"id" validate:"required" message:"地区ID不能为空"`
	Value string `form:"value" validate:"required" message:"地区编码不能为空"`
	Label string `form:"label" validate:"required" message:"地区名称不能为空"`
	Sort  *int   `form:"sort"`
}

func (r *AreaUpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// AreaDeleteRequest 删除地区请求结构
type AreaDeleteRequest struct {
	Validator
	Value string `form:"value" validate:"required" message:"地区编码不能为空"`
}

func (r *AreaDeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// AreaGetRequest 根据编码获取地区请求结构
type AreaGetRequest struct {
	Validator
	Value string `form:"value" uri:"value" validate:"required" message:"地区编码不能为空"`
}

func (r *AreaGetRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// AreaSearchRequest 搜索地区请求结构
type AreaSearchRequest struct {
	Validator
	Keyword string `form:"keyword" validate:"required" message:"搜索关键词不能为空"`
}

func (r *AreaSearchRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
