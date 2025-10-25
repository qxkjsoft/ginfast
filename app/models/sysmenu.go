package models

import (
	"context"
	"encoding/json"
	"fmt"
	"gin-fast/app/global/app"
	"sort"

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
	Sort       int         `gorm:"column:sort;default:1;comment:排序字段" json:"sort"`
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

// GetAllComponentPaths 获取所有组件文件路径
func (list SysMenuList) GetAllComponentPaths() (paths []string) {
	list.Each(func(menu *SysMenu) {
		if menu.Type == 2 && menu.Component != "" {
			paths = append(paths, menu.Component)
		}
	})
	return
}
