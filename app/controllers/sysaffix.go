package controllers

import (
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"
	"gin-fast/app/utils/filehelper"
	"strconv"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// SysAffixController 文件附件控制器
type SysAffixController struct {
	Common
}

// Upload 上传文件
func (ac *SysAffixController) Upload(c *gin.Context) {
	var req models.UploadRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, err.Error(), err)
		return
	}

	// 处理文件上传
	response, err := app.UploadService.HandleUpload(c, "file")
	if err != nil {
		ac.FailAndAbort(c, "文件上传失败", err)
		return
	}

	// 创建文件记录
	affix := models.NewSysAffix()
	affix.Name = response.FileName
	affix.Path = response.Path
	affix.Url = response.Url
	affix.Size = int(response.Size)
	affix.Suffix = response.FileType
	affix.Ftype = filehelper.GetFileTypeBySuffix(response.FileType) // 根据后缀判断文件类型
	affix.CreatedBy = common.GetCurrentUserID(c)

	// 保存到数据库
	if err := affix.Create(); err != nil {
		ac.FailAndAbort(c, "保存文件记录失败", err)
		return
	}

	// 返回成功响应
	ac.Success(c, gin.H{
		"id":    affix.ID,
		"name":  affix.Name,
		"path":  affix.Path,
		"size":  affix.Size,
		"ftype": affix.Ftype,
		"url":   affix.Url,
	})
}

// Delete 删除文件
func (ac *SysAffixController) Delete(c *gin.Context) {
	var req models.AffixDeleteRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, err.Error(), err)
		return
	}

	// 查找文件记录
	affix := models.NewSysAffix()
	if err := affix.GetByID(req.ID); err != nil {
		ac.FailAndAbort(c, "文件不存在", err)
		return
	}

	// 删除物理文件
	if err := app.UploadService.DeleteFile(affix.Path); err != nil {
		// 报错后继续删除数据库记录
		app.ZapLog.Error("删除物理文件失败", zap.Error(err))
	}

	// 删除数据库记录
	if err := affix.Delete(); err != nil {
		ac.FailAndAbort(c, "删除文件记录失败", err)
		return
	}

	// 返回成功响应
	ac.SuccessWithMessage(c, "删除成功", nil)
}

// UpdateName 修改文件名
func (ac *SysAffixController) UpdateName(c *gin.Context) {
	var req models.UpdateNameRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, err.Error(), err)
		return
	}

	// 查找文件记录
	affix := models.NewSysAffix()
	if err := affix.GetByID(req.ID); err != nil {
		ac.FailAndAbort(c, "文件不存在", err)
		return
	}

	// 更新文件名
	affix.Name = req.Name
	if err := affix.Update(); err != nil {
		ac.FailAndAbort(c, "更新文件名失败", err)
		return
	}

	// 返回成功响应
	ac.Success(c, gin.H{
		"id":    affix.ID,
		"name":  affix.Name,
		"path":  affix.Path,
		"size":  affix.Size,
		"ftype": affix.Ftype,
	})
}

// List 文件列表（分页查询）
func (ac *SysAffixController) List(c *gin.Context) {
	var req models.ListRequest
	if err := req.Validate(c); err != nil {
		ac.FailAndAbort(c, err.Error(), err)
		return
	}

	// 获取查询条件
	query := req.Handle()

	// 获取总数
	affixList := models.NewSysAffixList()
	total, err := affixList.GetTotal(query)
	if err != nil {
		ac.FailAndAbort(c, "获取文件总数失败", err)
		return
	}

	// 获取了分页数据及数据权限
	err = affixList.Find(req.Paginate(), query, func(d *gorm.DB) *gorm.DB {
		return d.Preload("User", func(d *gorm.DB) *gorm.DB {
			return d.Preload("Department")
		})
	}, common.GetDataScope(c))
	if err != nil {
		ac.FailAndAbort(c, "获取文件列表失败", err)
		return
	}

	// 返回成功响应
	ac.Success(c, gin.H{
		"list":  affixList,
		"total": total,
	})
}

// GetByID 根据ID获取文件信息
func (ac *SysAffixController) GetByID(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		ac.FailAndAbort(c, "无效的文件ID", err)
		return
	}

	// 查找文件记录
	affix := models.NewSysAffix()
	if err := affix.GetByID(uint(id)); err != nil {
		ac.FailAndAbort(c, "文件不存在", err)
		return
	}

	// 返回成功响应
	ac.Success(c, gin.H{
		"id":        affix.ID,
		"name":      affix.Name,
		"path":      affix.Path,
		"size":      affix.Size,
		"ftype":     affix.Ftype,
		"createdBy": affix.CreatedBy,
	})
}

// 获取文件URL
func (ac *SysAffixController) Download(c *gin.Context) {
	// 获取路径参数
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		ac.FailAndAbort(c, "无效的文件ID", err)
		return
	}

	// 查找文件记录
	affix := models.NewSysAffix()
	if err := affix.GetByID(uint(id)); err != nil {
		ac.FailAndAbort(c, "文件不存在", err)
		return
	}

	// 从URL中提取文件路径
	// 注意：这里需要根据实际的上传方式（本地或七牛云）来处理文件下载
	// 由于项目已有完整的上传服务，我们可以直接返回文件URL，让前端处理下载
	ac.Success(c, gin.H{
		"id":   affix.ID,
		"name": affix.Name,
		"url":  affix.Path,
	})
}
