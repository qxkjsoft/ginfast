package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type SysDepartmentController struct {
}

func (sc *SysDepartmentController) GetDivision(c *gin.Context) {
	sysDepartmentList := models.NewSysDepartmentList()
	err := sysDepartmentList.Find()
	if err != nil {
		app.ZapLog.Error("获取部门列表失败", zap.Error(err))
		app.Response.Fail(c, "获取部门列表失败")
		return
	}
	if !sysDepartmentList.IsEmpty() {
		sysDepartmentList = sysDepartmentList.BuildTree().TreeSort()
	}
	app.Response.Success(c, gin.H{
		"list": sysDepartmentList,
	})
}

// Add 新增部门
func (sc *SysDepartmentController) Add(c *gin.Context) {
	var req models.SysDepartmentAddRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查部门名称是否已存在
	existDept := models.NewSysDepartment()
	err := existDept.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ?", req.Name)
	})
	if err != nil {
		app.ZapLog.Error("检查部门名称失败", zap.Error(err))
		app.Response.Fail(c, "检查部门名称失败")
		return
	}
	if !existDept.IsEmpty() {
		app.ZapLog.Error("部门名称已存在")
		app.Response.Fail(c, "部门名称已存在")
		return
	}

	// 如果指定了父级ID，检查父级部门是否存在
	if req.ParentID != nil && *req.ParentID > 0 {
		parentDept := models.NewSysDepartment()
		err := parentDept.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", *req.ParentID)
		})
		if err != nil {
			app.ZapLog.Error("检查父级部门失败", zap.Error(err))
			app.Response.Fail(c, "检查父级部门失败")
			return
		}
		if parentDept.IsEmpty() {
			app.ZapLog.Error("父级部门不存在")
			app.Response.Fail(c, "父级部门不存在")
			return
		}
	}

	// 创建部门
	dept := models.NewSysDepartment()
	dept.ParentID = req.ParentID
	dept.Name = req.Name
	dept.Status = req.Status
	dept.Leader = req.Leader
	dept.Phone = req.Phone
	dept.Email = req.Email
	dept.Sort = req.Sort
	dept.Describe = req.Describe
	dept.CreatedBy = &[]uint{common.GetCurrentUserID(c)}[0]

	err = dept.Create()
	if err != nil {
		app.ZapLog.Error("新增部门失败", zap.Error(err))
		app.Response.Fail(c, "新增部门失败")
		return
	}

	app.Response.Success(c, dept, "部门创建成功")
}

// Update 更新部门
func (sc *SysDepartmentController) Update(c *gin.Context) {
	var req models.SysDepartmentUpdateRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查部门是否存在
	dept := models.NewSysDepartment()
	err := dept.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		app.ZapLog.Error("查询部门失败", zap.Error(err))
		app.Response.Fail(c, "查询部门失败")
		return
	}
	if dept.IsEmpty() {
		app.ZapLog.Error("部门不存在")
		app.Response.Fail(c, "部门不存在")
		return
	}

	// 检查部门名称是否与其他部门冲突（排除当前部门）
	existDept := models.NewSysDepartment()
	err = existDept.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ? AND id != ?", req.Name, req.ID)
	})
	if err != nil {
		app.ZapLog.Error("检查部门名称失败", zap.Error(err))
		app.Response.Fail(c, "检查部门名称失败")
		return
	}
	if !existDept.IsEmpty() {
		app.ZapLog.Error("部门名称已被其他部门使用")
		app.Response.Fail(c, "部门名称已被其他部门使用")
		return
	}

	// 如果指定了父级ID，检查父级部门是否存在且不能是自己
	if req.ParentID != nil && *req.ParentID > 0 {
		if *req.ParentID == req.ID {
			app.ZapLog.Error("不能将自己设置为父级部门")
			app.Response.Fail(c, "不能将自己设置为父级部门")
			return
		}
		parentDept := models.NewSysDepartment()
		err := parentDept.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", *req.ParentID)
		})
		if err != nil {
			app.ZapLog.Error("检查父级部门失败", zap.Error(err))
			app.Response.Fail(c, "检查父级部门失败")
			return
		}
		if parentDept.IsEmpty() {
			app.ZapLog.Error("父级部门不存在")
			app.Response.Fail(c, "父级部门不存在")
			return
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

	err = dept.Update()
	if err != nil {
		app.ZapLog.Error("更新部门失败", zap.Error(err))
		app.Response.Fail(c, "更新部门失败")
		return
	}

	app.Response.Success(c, dept, "部门更新成功")
}

// Delete 删除部门
func (sc *SysDepartmentController) Delete(c *gin.Context) {
	var req models.SysDepartmentDeleteRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查部门是否存在
	dept := models.NewSysDepartment()
	err := dept.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		app.ZapLog.Error("查询部门失败", zap.Error(err))
		app.Response.Fail(c, "查询部门失败")
		return
	}
	if dept.IsEmpty() {
		app.ZapLog.Error("部门不存在")
		app.Response.Fail(c, "部门不存在")
		return
	}

	// 检查是否有子部门
	childDepts := models.NewSysDepartmentList()
	err = childDepts.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("parent_id = ?", req.ID)
	})
	if err != nil {
		app.ZapLog.Error("检查子部门失败", zap.Error(err))
		app.Response.Fail(c, "检查子部门失败")
		return
	}
	if !childDepts.IsEmpty() {
		app.ZapLog.Error("存在子部门，无法删除")
		app.Response.Fail(c, "存在子部门，无法删除")
		return
	}

	// 检查是否有用户关联此部门
	var userCount int64
	err = app.DB().Model(&models.User{}).Where("dept_id = ?", req.ID).Count(&userCount).Error
	if err != nil {
		app.ZapLog.Error("检查用户部门关联失败", zap.Error(err))
		app.Response.Fail(c, "检查用户部门关联失败")
		return
	}
	if userCount > 0 {
		app.ZapLog.Error("存在用户关联此部门，无法删除")
		app.Response.Fail(c, "存在用户关联此部门，无法删除")
		return
	}

	// 软删除部门
	err = dept.Delete()
	if err != nil {
		app.ZapLog.Error("删除部门失败", zap.Error(err))
		app.Response.Fail(c, "删除部门失败")
		return
	}

	app.Response.Success(c, nil, "部门删除成功")
}

// GetByID 根据ID获取部门信息
func (sc *SysDepartmentController) GetByID(c *gin.Context) {
	var req models.SysDepartmentGetRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	dept := models.NewSysDepartment()
	err := dept.GetDepartmentByID(req.ID)
	if err != nil {
		app.ZapLog.Error("获取部门信息失败", zap.Error(err))
		app.Response.Fail(c, "获取部门信息失败")
		return
	}
	if dept.IsEmpty() {
		app.ZapLog.Error("部门不存在")
		app.Response.Fail(c, "部门不存在")
		return
	}

	app.Response.Success(c, dept)
}
