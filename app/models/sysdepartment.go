package models

import (
	"fmt"
	"gin-fast/app/global/app"
	"sort"

	"gorm.io/gorm"
)

// SysDepartment 部门模型
type SysDepartment struct {
	BaseModel
	ParentID  *uint             `gorm:"column:parent_id;comment:父级部门ID" json:"parentId"`
	Name      string            `gorm:"column:name;size:255;comment:部门名称" json:"name"`
	Status    *int8             `gorm:"column:status;comment:状态： 0 停用 1 启用" json:"status"`
	Leader    string            `gorm:"column:leader;size:255;comment:负责人" json:"leader"`
	Phone     string            `gorm:"column:phone;size:255;comment:联系电话" json:"phone"`
	Email     string            `gorm:"column:email;size:255;comment:邮箱" json:"email"`
	Sort      *int              `gorm:"column:sort;comment:排序" json:"sort"`
	Describe  string            `gorm:"column:describe;size:255;comment:描述" json:"describe"`
	CreatedBy *uint             `gorm:"column:created_by;comment:创建人" json:"createdBy"`
	Children  SysDepartmentList `gorm:"-" json:"children"`
}

// TableName 设置SysDepartment表名
func (SysDepartment) TableName() string {
	return "sys_department"
}

func NewSysDepartment() *SysDepartment {
	return &SysDepartment{}
}

func (d *SysDepartment) IsEmpty() bool {
	return d == nil || d.ID == 0
}

func (d *SysDepartment) Find(funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().Scopes(funcs...).Find(d).Error
}

func (d *SysDepartment) GetDepartmentByID(id uint) (err error) {
	return d.Find(func(db *gorm.DB) *gorm.DB {
		return db.Where("id = ?", id)
	})
}

func (d *SysDepartment) Create(funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	return app.DB().Scopes(funcs...).Create(d).Error
}

type SysDepartmentList []*SysDepartment

func NewSysDepartmentList() SysDepartmentList {
	return SysDepartmentList{}
}

func (list *SysDepartmentList) Find(funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).Find(list).Error
	return
}

func (list SysDepartmentList) IsEmpty() bool {
	return len(list) == 0
}

func (list SysDepartmentList) BuildTree() SysDepartmentList {
	// 哈希表存储所有节点
	nodeMap := make(map[uint]*SysDepartment)
	// 存储顶层节点
	roots := SysDepartmentList{}

	// 第一次遍历: 注册所有节点 & 检测重复
	for _, node := range list {
		id := node.ID

		// 循环引用检测 - 处理ParentID为指针类型
		if node.ParentID != nil && node.ID == *node.ParentID {
			app.ZapLog.Error(fmt.Sprintf("部门循环引用: %d -> %d", node.ID, *node.ParentID))
			continue
		}

		// 初始化子节点为nil
		node.Children = nil
		nodeMap[id] = node
	}

	// 第二次遍历: 构建树结构
	for _, node := range nodeMap {
		// 处理ParentID为指针类型，nil表示顶层节点
		if node.ParentID == nil || *node.ParentID == 0 {
			roots = append(roots, node) // 顶层节点
		} else {
			parentID := *node.ParentID
			parent, exists := nodeMap[parentID]
			if exists {
				// 初始化父节点的children为数组（若为nil）
				if parent.Children == nil {
					parent.Children = SysDepartmentList{}
				}
				parent.Children = append(parent.Children, node)
			} else {
				app.ZapLog.Warn(fmt.Sprintf("独立部门节点 %d: parentId=%d 不存在", node.ID, parentID))
			}
		}
	}

	// 对构建好的树进行排序
	return roots.TreeSort()
}

func (list SysDepartmentList) TreeSort() SysDepartmentList {
	if len(list) == 0 {
		return list
	}

	// 对当前层级进行排序
	sort.Slice(list, func(i, j int) bool {
		a, b := list[i], list[j]

		// 处理Sort字段为指针类型的情况
		var aSort, bSort int

		// 获取排序值，nil或0表示未设置排序值
		if a.Sort != nil {
			aSort = *a.Sort
		}
		if b.Sort != nil {
			bSort = *b.Sort
		}

		// a和b都是0或nil（未设置）则按ID排序保证稳定性
		if aSort == 0 && bSort == 0 {
			return a.ID < b.ID
		}
		// a是0或nil（未设置）则a被排在b之后
		if aSort == 0 {
			return false
		}
		// b是0或nil（未设置）则b被排在a之后
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
