package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"
	"strconv"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type SysRoleController struct {
}

func (sc *SysRoleController) GetRoles(c *gin.Context) {
	sysRoleList := models.NewSysRoleList()
	err := sysRoleList.Find()
	if err != nil {
		app.ZapLog.Error("获取角色列表失败", zap.Error(err))
		app.Response.Fail(c, "获取角色列表失败")
		return
	}
	if !sysRoleList.IsEmpty() {
		sysRoleList = sysRoleList.BuildTree().TreeSort()
	}
	app.Response.Success(c, gin.H{
		"list": sysRoleList,
	})
}

// List 角色列表（支持分页和过滤）
func (sc *SysRoleController) List(c *gin.Context) {
	var req models.SysRoleListRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 统计总数
	var count int64
	err := app.DB().Model(&models.SysRole{}).Scopes(req.Handler()).Count(&count).Error
	if err != nil {
		app.ZapLog.Error("统计角色数量失败", zap.Error(err))
		app.Response.Fail(c, "统计角色数量失败")
		return
	}

	// 查询列表数据
	sysRoleList := models.NewSysRoleList()
	err = sysRoleList.Find(req.Paginate(), req.Handler())
	if err != nil {
		app.ZapLog.Error("获取角色列表失败", zap.Error(err))
		app.Response.Fail(c, "获取角色列表失败")
		return
	}

	app.Response.Success(c, gin.H{
		"list":  sysRoleList,
		"total": count,
	})
}

// GetByID 根据ID获取角色信息
func (sc *SysRoleController) GetByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		app.ZapLog.Error("角色ID格式错误", zap.Error(err))
		app.Response.Fail(c, "角色ID格式错误")
		return
	}

	// 查询角色信息
	role := models.NewSysRole()
	err = role.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", uint(id))
	})
	if err != nil {
		app.ZapLog.Error("查询角色失败", zap.Error(err))
		app.Response.Fail(c, "查询角色失败")
		return
	}
	if role.IsEmpty() {
		app.ZapLog.Error("角色不存在")
		app.Response.Fail(c, "角色不存在")
		return
	}

	app.Response.Success(c, role)
}

// Add 新增角色
func (sc *SysRoleController) Add(c *gin.Context) {
	var req models.SysRoleAddRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查角色名称是否已存在
	existRole := models.NewSysRole()
	err := existRole.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ?", req.Name)
	})
	if err != nil {
		app.ZapLog.Error("检查角色名称失败", zap.Error(err))
		app.Response.Fail(c, "检查角色名称失败")
		return
	}
	if !existRole.IsEmpty() {
		app.ZapLog.Error("角色名称已存在")
		app.Response.Fail(c, "角色名称已存在")
		return
	}

	// 如果指定了父级ID，检查父级角色是否存在
	if req.ParentID > 0 {
		parentRole := models.NewSysRole()
		err := parentRole.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", req.ParentID)
		})
		if err != nil {
			app.ZapLog.Error("检查父级角色失败", zap.Error(err))
			app.Response.Fail(c, "检查父级角色失败")
			return
		}
		if parentRole.IsEmpty() {
			app.ZapLog.Error("父级角色不存在")
			app.Response.Fail(c, "父级角色不存在")
			return
		}
	}

	// 创建角色
	role := models.NewSysRole()
	role.Name = req.Name
	role.Sort = req.Sort
	role.Status = req.Status
	role.Description = req.Description
	role.ParentID = req.ParentID
	role.CreatedBy = common.GetCurrentUserID(c)

	err = app.DB().Create(role).Error
	if err != nil {
		app.ZapLog.Error("新增角色失败", zap.Error(err))
		app.Response.Fail(c, "新增角色失败")
		return
	}

	app.Response.Success(c, role, "角色创建成功")
}

// Update 更新角色
func (sc *SysRoleController) Update(c *gin.Context) {
	var req models.SysRoleUpdateRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查角色是否存在
	role := models.NewSysRole()
	err := role.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		app.ZapLog.Error("查询角色失败", zap.Error(err))
		app.Response.Fail(c, "查询角色失败")
		return
	}
	if role.IsEmpty() {
		app.ZapLog.Error("角色不存在")
		app.Response.Fail(c, "角色不存在")
		return
	}

	// 检查角色名称是否与其他角色冲突（排除当前角色）
	existRole := models.NewSysRole()
	err = existRole.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("name = ? AND id != ?", req.Name, req.ID)
	})
	if err != nil {
		app.ZapLog.Error("检查角色名称失败", zap.Error(err))
		app.Response.Fail(c, "检查角色名称失败")
		return
	}
	if !existRole.IsEmpty() {
		app.ZapLog.Error("角色名称已被其他角色使用")
		app.Response.Fail(c, "角色名称已被其他角色使用")
		return
	}

	// 如果指定了父级ID，检查父级角色是否存在且不能是自己
	if req.ParentID > 0 {
		if req.ParentID == req.ID {
			app.ZapLog.Error("不能将自己设置为父级角色")
			app.Response.Fail(c, "不能将自己设置为父级角色")
			return
		}
		parentRole := models.NewSysRole()
		err := parentRole.Find(func(d *gorm.DB) *gorm.DB {
			return d.Where("id = ?", req.ParentID)
		})
		if err != nil {
			app.ZapLog.Error("检查父级角色失败", zap.Error(err))
			app.Response.Fail(c, "检查父级角色失败")
			return
		}
		if parentRole.IsEmpty() {
			app.ZapLog.Error("父级角色不存在")
			app.Response.Fail(c, "父级角色不存在")
			return
		}
	}

	// 更新角色信息
	role.Name = req.Name
	role.Sort = req.Sort
	role.Status = req.Status
	role.Description = req.Description
	role.ParentID = req.ParentID

	err = app.DB().Save(role).Error
	if err != nil {
		app.ZapLog.Error("更新角色失败", zap.Error(err))
		app.Response.Fail(c, "更新角色失败")
		return
	}

	app.Response.Success(c, role, "角色更新成功")
}

// Delete 删除角色
func (sc *SysRoleController) Delete(c *gin.Context) {
	var req models.SysRoleDeleteRequest
	if err := req.Validate(c); err != nil {
		app.Response.Fail(c, err.Error())
		return
	}

	// 检查角色是否存在
	role := models.NewSysRole()
	err := role.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("id = ?", req.ID)
	})
	if err != nil {
		app.ZapLog.Error("查询角色失败", zap.Error(err))
		app.Response.Fail(c, "查询角色失败")
		return
	}
	if role.IsEmpty() {
		app.ZapLog.Error("角色不存在")
		app.Response.Fail(c, "角色不存在")
		return
	}

	// 检查是否有子角色
	childRoles := models.NewSysRoleList()
	err = childRoles.Find(func(d *gorm.DB) *gorm.DB {
		return d.Where("parent_id = ?", req.ID)
	})
	if err != nil {
		app.ZapLog.Error("检查子角色失败", zap.Error(err))
		app.Response.Fail(c, "检查子角色失败")
		return
	}
	if !childRoles.IsEmpty() {
		app.ZapLog.Error("存在子角色，无法删除")
		app.Response.Fail(c, "存在子角色，无法删除")
		return
	}

	// 检查是否有用户关联此角色
	var userRoleCount int64
	err = app.DB().Model(&models.SysUserRole{}).Where("role_id = ?", req.ID).Count(&userRoleCount).Error
	if err != nil {
		app.ZapLog.Error("检查用户角色关联失败", zap.Error(err))
		app.Response.Fail(c, "检查用户角色关联失败")
		return
	}
	if userRoleCount > 0 {
		app.ZapLog.Error("存在用户关联此角色，无法删除")
		app.Response.Fail(c, "存在用户关联此角色，无法删除")
		return
	}

	// 使用事务删除角色和相关数据
	err = app.DB().Transaction(func(tx *gorm.DB) error {
		// 删除角色菜单关联
		if err := tx.Where("role_id = ?", req.ID).Delete(&models.SysRoleMenu{}).Error; err != nil {
			return err
		}

		// 软删除角色
		if err := tx.Where("id = ?", req.ID).Delete(role).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		app.ZapLog.Error("删除角色失败", zap.Error(err))
		app.Response.Fail(c, "删除角色失败")
		return
	}

	app.Response.Success(c, nil, "角色删除成功")
}
