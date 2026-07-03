package controllers

import (
	"errors"
	"fmt"
	"strings"

	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// AreaController 地区管理控制器
// @Summary 地区管理API
// @Description 基于sys_area表的行政区划增删改查
// @Tags 地区管理
// @Accept json
// @Produce json
// @Router /sysArea [get]
type AreaController struct {
	Common
}

// NewAreaController 创建地区管理控制器
func NewAreaController() *AreaController {
	return &AreaController{Common: Common{}}
}

// GetList 获取根节点列表（懒加载入口）
// @Summary 获取根节点列表
// @Description 获取顶层行政区划（省级），不含子节点
// @Tags 地区管理
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{}
// @Router /sysArea/list [get]
// @Security ApiKeyAuth
func (ac *AreaController) GetList(c *gin.Context) {
	list := models.NewAreaList()
	err := list.Find(c, func(db *gorm.DB) *gorm.DB {
		return db.Where("parent = ?", "").Order("sort ASC, id ASC")
	})
	if err != nil {
		ac.FailAndAbort(c, "获取地区列表失败", err)
	}
	for i := range list {
		list[i].Children = nil
	}
	ac.Success(c, gin.H{"list": list})
}

// GetChildren 获取指定节点的直接子节点（懒加载）
// @Summary 获取子节点
// @Description 根据父级编码获取直接子节点（不含孙节点）
// @Tags 地区管理
// @Accept json
// @Produce json
// @Param value path string true "父级地区编码"
// @Success 200 {object} map[string]interface{}
// @Router /sysArea/children/{value} [get]
// @Security ApiKeyAuth
func (ac *AreaController) GetChildren(c *gin.Context) {
	var req models.AreaGetRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, err.Error(), err)
	}
	list := models.NewAreaList()
	err := list.Find(c, func(db *gorm.DB) *gorm.DB {
		return db.Where("parent = ?", req.Value).Order("sort ASC, id ASC")
	})
	if err != nil {
		ac.FailAndAbort(c, "获取子节点失败", err)
	}
	ac.Success(c, gin.H{"list": list})
}

// GetTree 获取完整树（公开接口，供级联选择器使用，带5分钟缓存）
// @Summary 获取完整树
// @Description 返回完整的行政区划树形结构（公开接口，无需认证）
// @Tags 地区管理
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{}
// @Router /sysArea/tree [get]
func (ac *AreaController) GetTree(c *gin.Context) {
	tree, err := models.GetAreaTree(c)
	if err != nil {
		ac.FailAndAbort(c, "获取地区树失败", err)
	}
	ac.Success(c, gin.H{"list": tree})
}

// Search 搜索地区（返回扁平列表+完整路径）
// @Summary 搜索地区
// @Description 按编码或名称模糊搜索，返回扁平列表及完整路径
// @Tags 地区管理
// @Accept json
// @Produce json
// @Param keyword query string true "搜索关键词"
// @Success 200 {object} map[string]interface{}
// @Router /sysArea/search [get]
// @Security ApiKeyAuth
func (ac *AreaController) Search(c *gin.Context) {
	var req models.AreaSearchRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, err.Error(), err)
	}

	keyword := "%" + req.Keyword + "%"
	list := models.NewAreaList()
	err := list.Find(c, func(db *gorm.DB) *gorm.DB {
		return db.Where("value LIKE ? OR label LIKE ?", keyword, keyword).Order("sort ASC, id ASC")
	})
	if err != nil {
		ac.FailAndAbort(c, "搜索地区失败", err)
	}

	// 查询全量数据构建 value->label、value->parent 映射，用于拼接完整路径
	all := models.NewAreaList()
	if err := all.Find(c); err != nil {
		ac.FailAndAbort(c, "构建路径失败", err)
	}
	labelMap := make(map[string]string, len(all))
	parentMap := make(map[string]string, len(all))
	for i := range all {
		labelMap[all[i].Value] = all[i].Label
		parentMap[all[i].Value] = all[i].Parent
	}

	var result []models.AreaSearchItem
	for i := range list {
		item := models.AreaSearchItem{
			ID:       list[i].ID,
			Value:    list[i].Value,
			Label:    list[i].Label,
			Level:    list[i].Level,
			Parent:   list[i].Parent,
			Sort:     list[i].Sort,
		}
		item.PathText = buildPathText(labelMap, parentMap, list[i].Value)
		result = append(result, item)
	}

	ac.Success(c, gin.H{"list": result})
}

// buildPathText 从目标节点向上追溯祖先，拼接完整路径文本
func buildPathText(labelMap, parentMap map[string]string, value string) string {
	var parts []string
	cur := value
	for cur != "" {
		if label, ok := labelMap[cur]; ok {
			parts = append([]string{label}, parts...)
		}
		cur = parentMap[cur]
	}
	return strings.Join(parts, " / ")
}

// Add 新增地区
// @Summary 新增地区
// @Tags 地区管理
// @Param body body models.AreaAddRequest true "地区信息"
// @Success 200 {object} map[string]interface{}
// @Router /sysArea/add [post]
// @Security ApiKeyAuth
func (ac *AreaController) Add(c *gin.Context) {
	var req models.AreaAddRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, err.Error(), err)
	}

	exist := models.NewAreaModel()
	_ = exist.FindByValue(c, req.Value)
	if !exist.IsEmpty() {
		ac.FailAndAbort(c, "地区编码已存在", nil)
	}

	// 根据 parent 自动计算 level
	level := 1
	if req.Parent != "" {
		parent := models.NewAreaModel()
		_ = parent.FindByValue(c, req.Parent)
		if parent.IsEmpty() {
			ac.FailAndAbort(c, "父级地区不存在", nil)
		}
		if parent.Level != nil {
			level = *parent.Level + 1
		}
	}

	area := models.NewAreaModel()
	area.Value = req.Value
	area.Label = req.Label
	area.Level = &level
	area.Parent = req.Parent
	area.Sort = req.Sort

	if err := area.Create(c); err != nil {
		ac.FailAndAbort(c, "新增地区失败", err)
	}
	models.InvalidateAreaTreeCache()
	ac.SuccessWithMessage(c, "地区创建成功", area)
}

// Update 更新地区（支持修改编码，事务内级联更新子节点 parent）
// @Summary 更新地区
// @Tags 地区管理
// @Param body body models.AreaUpdateRequest true "地区信息"
// @Success 200 {object} map[string]interface{}
// @Router /sysArea/edit [put]
// @Security ApiKeyAuth
func (ac *AreaController) Update(c *gin.Context) {
	var req models.AreaUpdateRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, err.Error(), err)
	}

	// 用主键 id 定位记录
	area := models.NewAreaModel()
	if err := area.FindByID(c, req.ID); err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			ac.FailAndAbort(c, "地区不存在", nil)
		}
		ac.FailAndAbort(c, "查询地区失败", err)
	}

	// 编码变化时校验新编码不冲突
	if req.Value != area.Value {
		exist := models.NewAreaModel()
		_ = exist.FindByValue(c, req.Value)
		if !exist.IsEmpty() {
			ac.FailAndAbort(c, "地区编码已被使用", nil)
		}
	}

	// 记录原编码用于级联更新
	oldValue := area.Value

	err := app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
		area.Value = req.Value
		area.Label = req.Label
		area.Sort = req.Sort
		if err := tx.Save(area).Error; err != nil {
			return err
		}
		// 编码变化时级联更新直接子节点的 parent
		if req.Value != oldValue {
			if err := tx.Model(&models.AreaModel{}).
				Where("parent = ?", oldValue).
				Update("parent", req.Value).Error; err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		ac.FailAndAbort(c, "更新地区失败", err)
	}
	models.InvalidateAreaTreeCache()
	ac.SuccessWithMessage(c, "地区更新成功", area)
}

// Delete 删除地区（含整棵子树）
// @Summary 删除地区
// @Tags 地区管理
// @Param body body models.AreaDeleteRequest true "地区删除请求"
// @Success 200 {object} map[string]interface{}
// @Router /sysArea/delete [delete]
// @Security ApiKeyAuth
func (ac *AreaController) Delete(c *gin.Context) {
	var req models.AreaDeleteRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, err.Error(), err)
	}

	area := models.NewAreaModel()
	if err := area.FindByValue(c, req.Value); err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			ac.FailAndAbort(c, "地区不存在", nil)
		}
		ac.FailAndAbort(c, "查询地区失败", err)
	}

	// 收集所有后代编码（含自身）
	all := models.NewAreaList()
	if err := all.Find(c); err != nil {
		ac.FailAndAbort(c, "查询地区数据失败", err)
	}
	valuesToDelete := append([]string{req.Value}, models.CollectDescendantValues(all, req.Value)...)

	err := app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
		return tx.Where("value IN ?", valuesToDelete).Delete(&models.AreaModel{}).Error
	})
	if err != nil {
		ac.FailAndAbort(c, "删除地区失败", err)
	}
	models.InvalidateAreaTreeCache()
	ac.SuccessWithMessage(c, fmt.Sprintf("删除成功，共删除 %d 条记录", len(valuesToDelete)), nil)
}

// InitData 初始化行政区划数据（从 area.json 导入）
// @Summary 初始化行政区划数据
// @Description 从种子文件 area.json 导入行政区划数据到数据库
// @Tags 地区管理
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{}
// @Router /sysArea/initData [post]
// @Security ApiKeyAuth
func (ac *AreaController) InitData(c *gin.Context) {
	count, err := models.InitFromJSON(c)
	if err != nil {
		ac.FailAndAbort(c, err.Error(), err)
	}
	ac.SuccessWithMessage(c, fmt.Sprintf("初始化成功，共导入 %d 条行政区划数据", count), gin.H{
		"count": count,
	})
}
