package models

import (
	"context"
	"encoding/json"
	"fmt"
	"gin-fast/app/global/app"
	"sort"
	"strings"

	"gorm.io/gorm"
)

// SysMenu 系统菜单路由模型
type SysMenu struct {
	BaseModel
	ParentID   uint        `gorm:"column:parent_id;not null;default:0;comment:父级路由ID，顶层为0" json:"parentId"`
	Path       string      `gorm:"column:path;not null;size:255;comment:路由路径" json:"path"`
	Name       string      `gorm:"column:name;not null;size:100;comment:路由名称" json:"name"`
	Component  string      `gorm:"column:component;size:255;comment:组件文件路径" json:"component"`
	Title      string      `gorm:"column:title;size:100;comment:菜单标题，国际化key" json:"title"`
	IsFull     bool        `gorm:"column:is_full;default:false;comment:是否全屏显示" json:"isFull"`
	Hide       bool        `gorm:"column:hide;default:false;comment:是否隐藏" json:"hide"`
	Disable    bool        `gorm:"column:disable;default:false;comment:是否停用" json:"disable"`
	KeepAlive  bool        `gorm:"column:keep_alive;default:false;comment:是否缓存" json:"keepAlive"`
	Affix      bool        `gorm:"column:affix;default:false;comment:是否固定" json:"affix"`
	Redirect   string      `gorm:"column:redirect;size:255;comment:跳转地址" json:"redirect"`
	IsLink     bool        `gorm:"column:is_link;default:false;comment:是否外链" json:"isLink"`
	Link       string      `gorm:"column:link;default:'';size:500;comment:外链地址" json:"link"`
	Iframe     bool        `gorm:"column:iframe;default:false;comment:是否内嵌" json:"iframe"`
	SvgIcon    string      `gorm:"column:svg_icon;default:'';size:100;comment:svg图标名称" json:"svgIcon"`
	Icon       string      `gorm:"column:icon;default:'';size:100;comment:普通图标名称" json:"icon"`
	Sort       int         `gorm:"column:sort;default:0;comment:排序字段" json:"sort"`
	Type       int8        `gorm:"column:type;default:2;comment:类型：1-目录，2-菜单，3-按钮" json:"type"`
	Permission string      `gorm:"column:permission;default:'';size:100;comment:权限标识" json:"permission"`
	CreatedBy  uint        `gorm:"column:created_by;comment:创建人" json:"createdBy"`
	Apis       SysApiList  `gorm:"many2many:sys_menu_api;foreignKey:id;joinForeignKey:menu_id;References:id;joinReferences:api_id" json:"apis"`
	Children   SysMenuList `gorm:"-" json:"children"`
}

// TableName 设置表名
func (SysMenu) TableName() string {
	return "sys_menu"
}

func NewSysMenu() *SysMenu {
	return &SysMenu{}
}

// IsEmpty 检查单个菜单是否为空
func (menu *SysMenu) IsEmpty() bool {
	return menu.ID == 0
}

// Find 查找单个菜单
func (menu *SysMenu) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).WithContext(c).First(menu).Error
	if err == gorm.ErrRecordNotFound {
		err = nil // 将记录未找到的错误转换为nil，通过IsEmpty()方法判断
	}
	return
}

type SysMenuList []*SysMenu

func NewSysMenuList() SysMenuList {
	return SysMenuList{}
}

func (list SysMenuList) IsEmpty() bool {
	return len(list) == 0

}

func (list SysMenuList) GetApis() (res SysApiList) {
	for _, menu := range list {
		res = append(res, menu.Apis...)
	}
	return
}

func (list *SysMenuList) Find(c context.Context, funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).WithContext(c).Find(list).Error
	return
}

func (list SysMenuList) BuildTree() SysMenuList {
	// 哈希表存储所有节点
	nodeMap := make(map[uint]*SysMenu)
	// 存储顶层节点
	roots := SysMenuList{}

	// 第一次遍历: 注册所有节点 & 检测重复
	for _, node := range list {
		id := node.ID

		// 循环引用检测
		if node.ID == node.ParentID {
			app.ZapLog.Error(fmt.Sprintf("循环引用: %d -> %d", node.ID, node.ParentID))
			continue
		}

		// 初始化子节点为nil
		node.Children = nil
		nodeMap[id] = node
	}

	// 第二次遍历: 构建树结构
	for _, node := range nodeMap {
		parentID := node.ParentID

		if parentID == 0 {
			roots = append(roots, node) // 顶层节点
		} else {
			parent, exists := nodeMap[parentID]
			if exists {
				// 初始化父节点的children为数组（若为nil）
				if parent.Children == nil {
					parent.Children = SysMenuList{}
				}
				parent.Children = append(parent.Children, node)
			} else {
				app.ZapLog.Warn(fmt.Sprintf("独立节点 %d: parentId=%d 不存在", node.ID, parentID))
			}
		}
	}

	return roots
}

// TreeSort 对菜单列表进行树状排序
func (list SysMenuList) TreeSort() SysMenuList {
	if len(list) == 0 {
		return list
	}

	// 对当前层级进行排序
	sort.Slice(list, func(i, j int) bool {
		a, b := list[i], list[j]

		// 处理Sort字段为0或未设置的情况
		// 在Go中，int的零值是0，所以我们需要区分0和未设置
		// 这里假设Sort为0表示未设置排序值，应该排在最后
		aSort, bSort := a.Sort, b.Sort

		// a和b都是0（未设置）则按ID排序保证稳定性
		if aSort == 0 && bSort == 0 {
			return a.ID < b.ID
		}
		// a是0（未设置）则a被排在b之后
		if aSort == 0 {
			return false
		}
		// b是0（未设置）则b被排在a之后
		if bSort == 0 {
			return true
		}

		return aSort < bSort
	})

	// 深层递归排序子节点
	for _, item := range list {
		if len(item.Children) > 0 {
			item.Children = item.Children.TreeSort()
		}
	}

	return list
}

func (list SysMenuList) Map(fn func(*SysMenu) uint) []uint {
	res := make([]uint, len(list))
	for i, v := range list {
		res[i] = fn(v)
	}
	return res
}

// GetMenusWithChildern 根据多个菜单ID获取包含这些ID及所有子级元素的数据
func (list SysMenuList) GetMenusWithChildern(menuIds ...uint) SysMenuList {
	if len(list) == 0 || len(menuIds) == 0 {
		return nil
	}

	// 创建一个map便于快速查找
	menuMap := make(map[uint]*SysMenu)
	for _, menu := range list {
		menuMap[menu.ID] = menu
	}

	// 构建子节点映射
	childrenMap := make(map[uint]SysMenuList)
	for _, menu := range list {
		childrenMap[menu.ParentID] = append(childrenMap[menu.ParentID], menu)
	}

	// 存储结果
	result := SysMenuList{}

	// 用于避免重复添加
	added := make(map[uint]bool)

	// 定义递归函数，收集指定菜单及其所有子节点
	var collectMenuAndChildren func(menuId uint)
	collectMenuAndChildren = func(menuId uint) {
		menu, exists := menuMap[menuId]
		if !exists || added[menuId] {
			return
		}

		// 标记为已添加
		added[menuId] = true
		// 添加到结果中
		result = append(result, menu)

		// 递归添加所有子节点
		for _, child := range childrenMap[menuId] {
			collectMenuAndChildren(child.ID)
		}
	}

	// 遍历所有指定的菜单ID
	for _, menuId := range menuIds {
		collectMenuAndChildren(menuId)
	}

	return result
}

// GetMenusWithParents 根据多个菜单ID获取包含这些ID及所有父级元素的数据
func (list SysMenuList) GetMenusWithParents(menuIds ...uint) SysMenuList {

	if len(list) == 0 {
		return nil
	}
	// 创建一个map便于快速查找
	menuMap := make(map[uint]*SysMenu)
	for _, menu := range list {
		menuMap[menu.ID] = menu
	}

	// 存储结果
	result := SysMenuList{}

	// 用于避免重复添加
	added := make(map[uint]bool)

	// 遍历所有指定的菜单ID
	for _, menuId := range menuIds {
		// 从指定菜单开始向上追溯
		currentId := menuId
		tempPath := SysMenuList{}

		for currentId != 0 {
			menu, exists := menuMap[currentId]
			if !exists {
				break
			}

			// 如果已经添加过，跳过
			if added[menu.ID] {
				break
			}

			// 添加到临时路径中
			tempPath = append(tempPath, menu)
			// 标记为已添加
			added[menu.ID] = true

			// 移动到父级
			currentId = menu.ParentID
		}

		// 反转临时路径并添加到结果中
		for i := len(tempPath) - 1; i >= 0; i-- {
			result = append(result, tempPath[i])
		}
	}

	// 去重并保持顺序
	uniqueResult := SysMenuList{}
	uniqueAdded := make(map[uint]bool)
	for _, menu := range result {
		if !uniqueAdded[menu.ID] {
			uniqueResult = append(uniqueResult, menu)
			uniqueAdded[menu.ID] = true
		}
	}

	return uniqueResult
}

func (list SysMenuList) Json() (string, error) {
	if list.IsEmpty() {
		return "", nil
	}
	jsonStr, err := json.Marshal(list)
	if err != nil {
		return "", err
	}
	return string(jsonStr), nil
}

// 递归遍历
func (list SysMenuList) Each(fn func(menu *SysMenu)) {
	for _, menu := range list {
		fn(menu)
		if len(menu.Children) > 0 {
			menu.Children.Each(fn)
		}
	}
}

// FixOrphanParentIDs 修复孤立节点，将找不到父级元素的节点的ParentID设置为0
func (list SysMenuList) FixOrphanParentIDs() SysMenuList {
	if len(list) == 0 {
		return list
	}

	// 创建一个map便于快速查找所有存在的ID
	idMap := make(map[uint]bool)
	for _, menu := range list {
		idMap[menu.ID] = true
	}

	// 遍历所有菜单，修复孤立节点
	for _, menu := range list {
		// 如果ParentID不为0，且父级ID在列表中不存在，则设置为0
		if menu.ParentID != 0 && !idMap[menu.ParentID] {
			menu.ParentID = 0
		}
	}

	return list
}

// ValidationError 树形数据验证错误信息
type ValidationError struct {
	MenuID   uint
	MenuName string
	Error    string
}

type ValidationErrors []ValidationError

func (ve ValidationErrors) Error() string {
	return strings.Join(ve.GetErrorMessages(), "\n")
}

func (ve ValidationErrors) GetErrorMessages() []string {
	var messages []string
	for _, err := range ve {
		messages = append(messages, fmt.Sprintf("菜单ID %d 名称 %s：%s", err.MenuID, err.MenuName, err.Error))
	}
	return messages
}

func (ve ValidationErrors) IsEmpty() bool {
	return len(ve) == 0
}

// ValidateTree 检查SysMenuList（树形数据）的合法性
// 检查内容包括：循环引用、父级与子级之间id关系、类型层级关系、根级类型
func (list SysMenuList) ValidateTree() ValidationErrors {
	var errors []ValidationError

	if len(list) == 0 {
		return errors
	}

	// 创建ID映射，便于快速查找
	idMap := make(map[uint]*SysMenu)
	list.Each(func(menu *SysMenu) {
		idMap[menu.ID] = menu
	})

	// 递归验证函数
	var validateNode func(menu *SysMenu, parent *SysMenu)
	validateNode = func(menu *SysMenu, parent *SysMenu) {
		// 检查1: 循环引用（子节点ID不能等于节点ID或父节点ID）
		if menu.ID == menu.ParentID {
			errors = append(errors, ValidationError{
				MenuID:   menu.ID,
				MenuName: menu.Name,
				Error:    fmt.Sprintf("循环引用：节点ID %d 等于 ParentID", menu.ID),
			})
			return
		}

		// 检查2: 父级与子级之间的ID关系是否正确
		if parent != nil {
			if menu.ParentID != parent.ID {
				errors = append(errors, ValidationError{
					MenuID:   menu.ID,
					MenuName: menu.Name,
					Error:    fmt.Sprintf("父级关系错误：子节点ParentID %d 与实际父级ID %d 不匹配", menu.ParentID, parent.ID),
				})
			}
		}

		// 检查3: 类型层级关系
		if parent != nil {
			switch parent.Type {
			case 1: // 目录
				// 目录下只能添加目录(1)或菜单(2)
				if menu.Type != 1 && menu.Type != 2 {
					errors = append(errors, ValidationError{
						MenuID:   menu.ID,
						MenuName: menu.Name,
						Error:    fmt.Sprintf("类型层级错误：目录下只能添加目录或菜单，不能添加类型%d", menu.Type),
					})
				}
			case 2: // 菜单
				// 菜单下只能添加按钮(3)
				if menu.Type != 3 {
					errors = append(errors, ValidationError{
						MenuID:   menu.ID,
						MenuName: menu.Name,
						Error:    fmt.Sprintf("类型层级错误：菜单下只能添加按钮，不能添加类型%d", menu.Type),
					})
				}
			case 3: // 按钮
				// 按钮下不能添加子项
				errors = append(errors, ValidationError{
					MenuID:   menu.ID,
					MenuName: menu.Name,
					Error:    "类型层级错误：按钮下不能添加子项",
				})
			}
		}

		// 递归验证子节点
		if len(menu.Children) > 0 {
			for _, child := range menu.Children {
				validateNode(child, menu)
			}
		}
	}

	// 验证根级节点
	for _, rootMenu := range list {
		// 根级只能是目录(1)或菜单(2)
		if rootMenu.Type != 1 && rootMenu.Type != 2 {
			errors = append(errors, ValidationError{
				MenuID:   rootMenu.ID,
				MenuName: rootMenu.Name,
				Error:    fmt.Sprintf("根级类型错误：根级只能是目录或菜单，不能是类型%d", rootMenu.Type),
			})
		}

		// 从根级节点开始验证
		validateNode(rootMenu, nil)
	}

	return errors
}

// GetAllComponentPaths 获取所有组件文件路径
func (list SysMenuList) GetAllComponentPaths() (paths []string) {
	list.Each(func(menu *SysMenu) {
		if menu.Type == 2 && menu.Component != "" {
			paths = append(paths, menu.Component)
		}
	})
	return
}

// GetAllPermission 获取所有按钮权限标识
func (list SysMenuList) GetAllPermission() (permissions []string) {
	list.Each(func(menu *SysMenu) {
		if menu.Type == 3 && menu.Permission != "" {
			permissions = append(permissions, menu.Permission)
		}
	})
	return
}
