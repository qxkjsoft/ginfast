package models

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"gin-fast/app/global/app"

	"go.uber.org/zap"
	"gorm.io/gorm"
)

// AreaSeedPath 行政区划种子数据 JSON 路径（相对项目根目录）
const AreaSeedPath = "/resource/database/area.json"

// AreaModel 行政区划模型
type AreaModel struct {
	BaseModel
	Value    string        `gorm:"column:value;size:20;uniqueIndex;comment:地区编码" json:"value"`
	Label    string        `gorm:"column:label;size:100;comment:地区名称" json:"label"`
	Level    *int          `gorm:"column:level;comment:层级 1省2市3区县4街道" json:"level"`
	Parent   string        `gorm:"column:parent;size:20;index;default:'';comment:父级编码" json:"parent"`
	Sort     *int          `gorm:"column:sort;comment:排序" json:"sort"`
	Children AreaModelList `gorm:"-" json:"children,omitempty"`
}

// TableName 设置表名
func (AreaModel) TableName() string {
	return "sys_area"
}

func NewAreaModel() *AreaModel {
	return &AreaModel{}
}

// IsEmpty 判断是否为空
func (m *AreaModel) IsEmpty() bool {
	return m == nil || m.ID == 0
}

// Find 查询单条记录
func (m *AreaModel) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).First(m).Error
}

// FindByValue 根据编码查询
func (m *AreaModel) FindByValue(ctx context.Context, value string) error {
	return m.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("value = ?", value)
	})
}

// FindByID 根据主键ID查询
func (m *AreaModel) FindByID(ctx context.Context, id uint) error {
	return m.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("id = ?", id)
	})
}

// Create 新增
func (m *AreaModel) Create(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Create(m).Error
}

// Update 更新
func (m *AreaModel) Update(ctx context.Context) error {
	return app.DB().WithContext(ctx).Save(m).Error
}

// Delete 删除
func (m *AreaModel) Delete(ctx context.Context) error {
	return app.DB().WithContext(ctx).Delete(m).Error
}

// AreaModelList 行政区划列表
type AreaModelList []AreaModel

func NewAreaList() AreaModelList {
	return AreaModelList{}
}

// IsEmpty 判断列表是否为空
func (l AreaModelList) IsEmpty() bool {
	return len(l) == 0
}

// Find 查询列表
func (l *AreaModelList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Find(l).Error
}

// FindByValue 列表中根据编码查找节点指针
func (l AreaModelList) FindByValue(value string) *AreaModel {
	for i := range l {
		if l[i].Value == value {
			return &l[i]
		}
		if l[i].Children != nil {
			if found := l[i].Children.FindByValue(value); found != nil {
				return found
			}
		}
	}
	return nil
}

// ValueExists 判断编码是否已存在
func (l AreaModelList) ValueExists(value string) bool {
	return l.FindByValue(value) != nil
}

// BuildTree 根据 parent 字段构建树结构
// 使用 childrenMap + 自底向上递归，保证每个节点的 Children 在拷贝到父级前已完整
func (l AreaModelList) BuildTree() AreaModelList {
	childrenMap := make(map[string]AreaModelList)

	// 第一遍：按 Parent 分组，保留数据库查询的排序顺序（sort ASC, id ASC）
	for i := range l {
		node := l[i]
		node.Children = nil
		childrenMap[node.Parent] = append(childrenMap[node.Parent], node)
	}

	// 递归自底向上构建：先叶子后根，确保完整性
	var buildChildren func(parentValue string) AreaModelList
	buildChildren = func(parentValue string) AreaModelList {
		children := childrenMap[parentValue]
		for i := range children {
			children[i].Children = buildChildren(children[i].Value)
		}
		return children
	}

	return buildChildren("")
}

// CollectDescendantValues 从扁平列表中递归收集指定 value 的所有后代 value（不含自身）
func CollectDescendantValues(allList AreaModelList, parentValue string) []string {
	var result []string
	for i := range allList {
		if allList[i].Parent == parentValue {
			result = append(result, allList[i].Value)
			result = append(result, CollectDescendantValues(allList, allList[i].Value)...)
		}
	}
	return result
}

// AreaSearchItem 搜索结果项（含完整路径文本）
type AreaSearchItem struct {
	ID       uint   `json:"id"`
	Value    string `json:"value"`
	Label    string `json:"label"`
	Level    *int   `json:"level"`
	Parent   string `json:"parent"`
	Sort     *int   `json:"sort"`
	PathText string `json:"pathText"`
}

// ===== 完整树缓存 =====

var (
	areaTreeCache    *AreaModelList
	areaTreeCacheAt  time.Time
	areaTreeCacheTTL = 5 * time.Minute
)

// InvalidateAreaTreeCache 失效树缓存
func InvalidateAreaTreeCache() {
	areaTreeCache = nil
}

// GetAreaTree 获取完整行政区划树（带 5 分钟内存缓存）
func GetAreaTree(ctx context.Context) (AreaModelList, error) {
	if areaTreeCache != nil && time.Since(areaTreeCacheAt) < areaTreeCacheTTL {
		return *areaTreeCache, nil
	}
	all := NewAreaList()
	if err := all.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Order("sort ASC, id ASC")
	}); err != nil {
		return nil, err
	}
	tree := all.BuildTree()
	areaTreeCache = &tree
	areaTreeCacheAt = time.Now()
	return tree, nil
}

// AreaText 地区编码转换为地区文本（向后兼容）
// area 为逗号分隔的编码（如 "11,1101,110101"）
func AreaText(ctx context.Context, area string, split string) string {
	if area == "" {
		return ""
	}
	tree, err := GetAreaTree(ctx)
	if err != nil || len(tree) == 0 {
		return ""
	}
	codes := strings.Split(area, ",")
	areaText := ""
	current := tree
	for _, code := range codes {
		found := false
		for i := range current {
			if current[i].Value == code {
				areaText += current[i].Label + split
				current = current[i].Children
				found = true
				break
			}
		}
		if !found {
			break
		}
	}
	return strings.TrimRight(areaText, split)
}

// ===== 种子数据导入 =====

// areaJSONNode 匹配 area.json 的临时结构（level 为字符串）
type areaJSONNode struct {
	Value    string         `json:"value"`
	Label    string         `json:"label"`
	Level    string         `json:"level"`
	Parent   string         `json:"parent"`
	Children []areaJSONNode `json:"children"`
}

// InitFromJSON 从 area.json 导入行政区划数据到数据库
// 返回成功导入的记录数
func InitFromJSON(ctx context.Context) (int64, error) {
	// 幂等检查：已有数据则拒绝
	var count int64
	if err := app.DB().WithContext(ctx).Model(&AreaModel{}).Count(&count).Error; err != nil {
		return 0, err
	}
	if count > 0 {
		return 0, fmt.Errorf("行政区划数据已初始化(%d条)，如需重新导入请先清空 sys_area 表", count)
	}

	// 定位种子文件
	seedFile := filepath.Join(app.BasePath, AreaSeedPath)
	file, err := os.Open(seedFile)
	if err != nil {
		app.ZapLog.Error("打开行政区划种子文件失败",
			zap.String("path", seedFile),
			zap.Error(err))
		return 0, fmt.Errorf("打开种子文件失败: %w", err)
	}
	defer file.Close()

	var nodes []areaJSONNode
	if err := json.NewDecoder(file).Decode(&nodes); err != nil {
		app.ZapLog.Error("解析行政区划种子文件失败", zap.Error(err))
		return 0, fmt.Errorf("解析种子文件失败: %w", err)
	}

	// 递归扁平化树为列表
	var flat []AreaModel
	flattenAreaJSON(nodes, "", &flat)

	// 事务批量插入，每批 1000
	var inserted int64
	err = app.DB().WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		batchSize := 1000
		now := time.Now()
		for i := 0; i < len(flat); i += batchSize {
			end := i + batchSize
			if end > len(flat) {
				end = len(flat)
			}
			batch := flat[i:end]
			for j := range batch {
				if batch[j].CreatedAt.IsZero() {
					batch[j].CreatedAt = now
					batch[j].UpdatedAt = now
				}
			}
			if err := tx.Create(&batch).Error; err != nil {
				return err
			}
			inserted += int64(len(batch))
		}
		return nil
	})
	if err != nil {
		return 0, err
	}

	InvalidateAreaTreeCache()
	return inserted, nil
}

// flattenAreaJSON 递归扁平化 JSON 树结构为 AreaModel 列表
func flattenAreaJSON(nodes []areaJSONNode, parentValue string, out *[]AreaModel) {
	for _, node := range nodes {
		item := AreaModel{
			Value:  node.Value,
			Label:  node.Label,
			Parent: parentValue,
		}
		if node.Level != "" {
			if lv, err := strconv.Atoi(node.Level); err == nil {
				item.Level = &lv
			}
		}
		*out = append(*out, item)
		if len(node.Children) > 0 {
			flattenAreaJSON(node.Children, node.Value, out)
		}
	}
}
