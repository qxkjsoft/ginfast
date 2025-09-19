package models

import (
	"fmt"
	"gin-fast/app/global/app"
	"sort"

	"gorm.io/gorm"
)

// SysRole 系统角色模型
type SysRole struct {
	BaseModel
	Name        string      `gorm:"column:name;size:255;default:'';comment:角色名称" json:"name"`
	Sort        int         `gorm:"column:sort;default:0;comment:排序" json:"sort"`
	Status      int8        `gorm:"column:status;default:0;comment:状态" json:"status"`
	Description string      `gorm:"column:description;size:255;comment:描述" json:"description"`
	ParentID    uint        `gorm:"column:parent_id;default:0;comment:父级ID" json:"parentId"`
	CreatedBy   uint        `gorm:"column:created_by;comment:创建人" json:"createdBy"`
	Users       UserList    `gorm:"many2many:sys_user_role;foreignKey:id;joinForeignKey:role_id;References:id;joinReferences:user_id" json:"users"`
	Children    SysRoleList `gorm:"-" json:"children"`
}

// TableName 设置表名
func (SysRole) TableName() string {
	return "sys_role"
}

func NewSysRole() *SysRole {
	return &SysRole{}
}

func (r *SysRole) IsEmpty() bool {
	return r == nil || r.ID == 0
}

func (r *SysRole) Find(funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().Scopes(funcs...).Find(r).Error
}

type SysRoleList []*SysRole

func NewSysRoleList() SysRoleList {
	return SysRoleList{}
}

func (list SysRoleList) IsEmpty() bool {
	return len(list) == 0
}

func (list SysRoleList) Map(fn func(*SysRole) interface{}) []interface{} {
	var roles []interface{}
	for _, role := range list {
		roles = append(roles, fn(role))
	}
	return roles
}

func (list SysRoleList) GetRoleIDs() []uint {
	var roleIDs []uint
	for _, role := range list {
		roleIDs = append(roleIDs, role.ID)
	}
	return roleIDs
}

func (list *SysRoleList) Find(funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).Find(list).Error
	return
}

// BuildTree
func (list SysRoleList) BuildTree() SysRoleList {
	// 哈希表存储所有节点
	nodeMap := make(map[uint]*SysRole)
	// 存储顶层节点
	roots := SysRoleList{}

	// 第一次遍历: 注册所有节点 & 检测重复
	for _, node := range list {
		id := node.ID

		// 循环引用检测
		if node.ID == node.ParentID {
			app.ZapLog.Error(fmt.Sprintf("角色循环引用: %d -> %d", node.ID, node.ParentID))
			continue
		}

		// 初始化子节点为nil
		node.Children = nil
		nodeMap[id] = node
	}

	// 第二次遍历: 构建树结构
	for _, node := range nodeMap {
		// ParentID为0表示顶层节点
		if node.ParentID == 0 {
			roots = append(roots, node) // 顶层节点
		} else {
			parentID := node.ParentID
			parent, exists := nodeMap[parentID]
			if exists {
				// 初始化父节点的children为数组（若为nil）
				if parent.Children == nil {
					parent.Children = SysRoleList{}
				}
				parent.Children = append(parent.Children, node)
			} else {
				app.ZapLog.Warn(fmt.Sprintf("独立角色节点 %d: parentId=%d 不存在", node.ID, parentID))
			}
		}
	}

	// 对构建好的树进行排序
	return roots.TreeSort()
}

func (list SysRoleList) TreeSort() SysRoleList {
	if len(list) == 0 {
		return list
	}

	// 对当前层级进行排序
	sort.Slice(list, func(i, j int) bool {
		a, b := list[i], list[j]

		// 获取排序值
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
