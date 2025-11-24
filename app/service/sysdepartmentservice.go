package service

import (
	"context"
	"errors"
	"gin-fast/app/models"

	"gorm.io/gorm"
)

type SysDepartmentService struct {
}

// NewSysDepartmentService 创建系统部门服务
func NewSysDepartmentService() *SysDepartmentService {
	return &SysDepartmentService{}
}

func (s *SysDepartmentService) Update(c context.Context, req *models.SysDepartmentUpdateRequest) (*models.SysDepartment, error) {
	// 检查部门是否存在
	dept := models.NewSysDepartment()
	err := dept.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		return nil, err
	}
	if dept.IsEmpty() {
		return nil, errors.New("部门不存在")
	}

	// 检查部门名称是否与其他部门冲突（排除当前部门）
	existDept := models.NewSysDepartment()
	err = existDept.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ? AND id != ?", req.Name, req.ID)
	})
	if err != nil {
		return nil, err
	}
	if !existDept.IsEmpty() {
		return nil, errors.New("部门名称已被其他部门使用")
	}

	// 如果指定了父级ID，检查父级部门是否存在且不能是自己
	if req.ParentID != nil && *req.ParentID > 0 {
		if *req.ParentID == req.ID {
			return nil, errors.New("不能将自己设置为父级部门")
		}
		parentDept := models.NewSysDepartment()
		err := parentDept.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", *req.ParentID)
		})
		if err != nil {
			return nil, err
		}
		if parentDept.IsEmpty() {
			return nil, errors.New("父级部门不存在")
		}
		// 检查是否会形成循环引用
		if err := s.checkCircularReference(c, req.ID, *req.ParentID); err != nil {
			return nil, err
		}
	}

	// 更新部门信息
	dept.ParentID = req.ParentID
	dept.Name = req.Name
	dept.Status = req.Status
	dept.Leader = req.Leader
	dept.Phone = req.Phone
	dept.Email = req.Email
	dept.Sort = req.Sort
	dept.Describe = req.Describe

	err = dept.Update(c)
	if err != nil {
		return nil, err
	}
	return dept, nil
}

// checkCircularReference 检查是否存在循环引用
func (s *SysDepartmentService) checkCircularReference(c context.Context, currentDeptID uint, parentID uint) error {
	if parentID == 0 {
		return nil // 如果父级ID为0，不需要检查
	}

	// 获取所有部门用于构建部门树
	allDepts := models.NewSysDepartmentList()
	err := allDepts.Find(c, func(db *gorm.DB) *gorm.DB {
		return db
	})
	if err != nil {
		return err
	}

	// 创建部门ID到部门的映射
	deptMap := make(map[uint]*models.SysDepartment)
	for _, dept := range allDepts {
		deptMap[dept.ID] = dept
	}

	// 从父级部门开始递归检查，确保没有一条路径最终指向currentDeptID
	var checkParent func(uint) bool
	checkParent = func(deptID uint) bool {
		if deptID == 0 {
			return false // 已到达根节点
		}
		if deptID == currentDeptID {
			return true // 发现循环引用
		}

		dept, exists := deptMap[deptID]
		if !exists {
			return false // 部门不存在
		}

		// 递归检查父级（处理ParentID为指针类型）
		if dept.ParentID == nil || *dept.ParentID == 0 {
			return false
		}
		return checkParent(*dept.ParentID)
	}

	// 从指定的父级开始检查
	if checkParent(parentID) {
		return errors.New("不能设置为父级部门：会导致循环引用")
	}

	return nil
}
