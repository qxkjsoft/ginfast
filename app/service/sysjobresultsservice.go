package service

import (
	"gin-fast/app/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SysJobResultsService sys_job_results服务
type SysJobResultsService struct{}

// NewSysJobResultsService 创建sys_job_results服务
func NewSysJobResultsService() *SysJobResultsService {
	return &SysJobResultsService{}
}

// Delete 删除sys_job_results
func (s *SysJobResultsService) Delete(c *gin.Context, id uint64) error {
	// 查找sys_job_results记录
	sysJobResults := models.NewSysJobResults()
	if err := sysJobResults.GetByID(c, id); err != nil {
		return err
	}

	// 删除数据库记录
	if err := sysJobResults.Delete(c); err != nil {
		return err
	}

	return nil
}

// GetByID 根据ID获取sys_job_results
func (s *SysJobResultsService) GetByID(c *gin.Context, id uint64) (*models.SysJobResults, error) {
	// 查找sys_job_results记录
	sysJobResults := models.NewSysJobResults()
	if err := sysJobResults.GetByID(c, id); err != nil {
		return nil, err
	}

	return sysJobResults, nil
}

// List sys_job_results列表（分页查询）
func (s *SysJobResultsService) List(c *gin.Context, req models.SysJobResultsListRequest) (*models.SysJobResultsList, int64, error) {
	// 获取总数
	sysJobResultsList := models.NewSysJobResultsList()
	scopes := []func(*gorm.DB) *gorm.DB{req.Handle()}
	total, err := sysJobResultsList.GetTotal(c, scopes...)
	if err != nil {
		return nil, 0, err
	}
	scopes = append(scopes, req.Paginate())
	// 获取分页数据
	err = sysJobResultsList.Find(c, scopes...)
	if err != nil {
		return nil, 0, err
	}

	return sysJobResultsList, total, nil
}
