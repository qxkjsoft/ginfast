package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysDepartmentController 系统部门控制器
// @Summary 系统部门管理API
// @Description 系统部门管理相关接口
// @Tags 部门管理
// @Accept json
// @Produce json
// @Router /sysDepartment [get]
type SysDepartmentController struct {
	Common
}

// NewSysDepartmentController 创建系统部门控制器
func NewSysDepartmentController() *SysDepartmentController {
	return &SysDepartmentController{
		Common: Common{},
	}
}

// GetDivision 获取部门列表（树形结构）
// @Summary 获取部门列表
// @Description 获取所有部门列表（树形结构）
// @Tags 部门管理
// @Accept json
// @Produce json
// @Success 200 {object} map[string]interface{} "成功返回部门列表"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysDepartment/getDivision [get]
// @Security ApiKeyAuth
func (sc *SysDepartmentController) GetDivision(c *gin.Context) {
	sysDepartmentList := models.NewSysDepartmentList()
	err := sysDepartmentList.Find(c, func(db *gorm.DB) *gorm.DB {
		return db.Where("status = ?", 1)
	})
	if err != nil {
		sc.FailAndAbort(c, "获取部门列表失败", err)
	}
	if !sysDepartmentList.IsEmpty() {
		sysDepartmentList = sysDepartmentList.BuildTree().TreeSort()
	}
	sc.Success(c, gin.H{
		"list": sysDepartmentList,
	})
}

// Add 新增部门
// @Summary 新增部门
// @Description 创建新部门
// @Tags 部门管理
// @Accept json
// @Produce json
// @Param dept body models.SysDepartmentAddRequest true "部门信息"
// @Success 200 {object} map[string]interface{} "部门创建成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysDepartment/add [post]
// @Security ApiKeyAuth
func (sc *SysDepartmentController) Add(c *gin.Context) {
	var req models.SysDepartmentAddRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 检查部门名称是否已存在
	existDept := models.NewSysDepartment()
	err := existDept.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ?", req.Name)
	})
	if err != nil {
		sc.FailAndAbort(c, "检查部门名称失败", err)
	}
	if !existDept.IsEmpty() {
		sc.FailAndAbort(c, "部门名称已存在", nil)
	}

	// 如果指定了父级ID，检查父级部门是否存在
	if req.ParentID != nil && *req.ParentID > 0 {
		parentDept := models.NewSysDepartment()
		err := parentDept.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", *req.ParentID)
		})
		if err != nil {
			sc.FailAndAbort(c, "检查父级部门失败", err)
		}
		if parentDept.IsEmpty() {
			sc.FailAndAbort(c, "父级部门不存在", nil)
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

	err = dept.Create(c)
	if err != nil {
		sc.FailAndAbort(c, "新增部门失败", err)
	}

	sc.SuccessWithMessage(c, "部门创建成功", dept)
}

// Update 更新部门
// @Summary 更新部门
// @Description 更新部门信息
// @Tags 部门管理
// @Accept json
// @Produce json
// @Param dept body models.SysDepartmentUpdateRequest true "部门信息"
// @Success 200 {object} map[string]interface{} "部门更新成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysDepartment/edit [put]
// @Security ApiKeyAuth
func (sc *SysDepartmentController) Update(c *gin.Context) {
	var req models.SysDepartmentUpdateRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 检查部门是否存在
	dept := models.NewSysDepartment()
	err := dept.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		sc.FailAndAbort(c, "查询部门失败", err)
	}
	if dept.IsEmpty() {
		sc.FailAndAbort(c, "部门不存在", nil)
	}

	// 检查部门名称是否与其他部门冲突（排除当前部门）
	existDept := models.NewSysDepartment()
	err = existDept.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ? AND id != ?", req.Name, req.ID)
	})
	if err != nil {
		sc.FailAndAbort(c, "检查部门名称失败", err)
	}
	if !existDept.IsEmpty() {
		sc.FailAndAbort(c, "部门名称已被其他部门使用", nil)
	}

	// 如果指定了父级ID，检查父级部门是否存在且不能是自己
	if req.ParentID != nil && *req.ParentID > 0 {
		if *req.ParentID == req.ID {
			sc.FailAndAbort(c, "不能将自己设置为父级部门", nil)
		}
		parentDept := models.NewSysDepartment()
		err := parentDept.Find(c, func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", *req.ParentID)
		})
		if err != nil {
			sc.FailAndAbort(c, "检查父级部门失败", err)
		}
		if parentDept.IsEmpty() {
			sc.FailAndAbort(c, "父级部门不存在", nil)
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
		sc.FailAndAbort(c, "更新部门失败", err)
	}

	sc.SuccessWithMessage(c, "部门更新成功", dept)
}

// Delete 删除部门
// @Summary 删除部门
// @Description 删除部门信息
// @Tags 部门管理
// @Accept json
// @Produce json
// @Param dept body models.SysDepartmentDeleteRequest true "部门删除请求参数"
// @Success 200 {object} map[string]interface{} "部门删除成功"
// @Failure 400 {object} map[string]interface{} "请求参数错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysDepartment/delete [delete]
// @Security ApiKeyAuth
func (sc *SysDepartmentController) Delete(c *gin.Context) {
	var req models.SysDepartmentDeleteRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	// 检查部门是否存在
	dept := models.NewSysDepartment()
	err := dept.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		sc.FailAndAbort(c, "查询部门失败", err)
	}
	if dept.IsEmpty() {
		sc.FailAndAbort(c, "部门不存在", nil)
	}

	// 检查是否有子部门
	childDepts := models.NewSysDepartmentList()
	err = childDepts.Find(c, func(d *gorm.DB) *gorm.DB {
		return d.Where("parent_id = ?", req.ID)
	})
	if err != nil {
		sc.FailAndAbort(c, "检查子部门失败", err)
	}
	if !childDepts.IsEmpty() {
		sc.FailAndAbort(c, "存在子部门，无法删除", nil)
	}

	// 检查是否有用户关联此部门
	var userCount int64
	err = app.DB().Model(&models.User{}).Where("dept_id = ?", req.ID).Count(&userCount).Error
	if err != nil {
		sc.FailAndAbort(c, "检查用户部门关联失败", err)
	}
	if userCount > 0 {
		sc.FailAndAbort(c, "存在用户关联此部门，无法删除", nil)
	}

	// 软删除部门
	err = dept.Delete(c)
	if err != nil {
		sc.FailAndAbort(c, "删除部门失败", err)
	}

	sc.SuccessWithMessage(c, "部门删除成功", nil)
}

// GetByID 根据ID获取部门信息
// @Summary 根据ID获取部门信息
// @Description 根据部门ID获取部门详细信息
// @Tags 部门管理
// @Accept json
// @Produce json
// @Param id path int true "部门ID"
// @Success 200 {object} map[string]interface{} "成功返回部门信息"
// @Failure 400 {object} map[string]interface{} "部门ID格式错误"
// @Failure 500 {object} map[string]interface{} "服务器内部错误"
// @Router /sysDepartment/{id} [get]
// @Security ApiKeyAuth
func (sc *SysDepartmentController) GetByID(c *gin.Context) {
	var req models.SysDepartmentGetRequest
	if err := req.Validate(c); err != nil {
		sc.FailAndAbort(c, err.Error(), err)
	}

	dept := models.NewSysDepartment()
	err := dept.GetDepartmentByID(c, req.ID)
	if err != nil {
		sc.FailAndAbort(c, "获取部门信息失败", err)
	}
	if dept.IsEmpty() {
		sc.FailAndAbort(c, "部门不存在", nil)
	}

	sc.Success(c, dept)
}
