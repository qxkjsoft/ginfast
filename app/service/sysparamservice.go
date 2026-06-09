package service

import (
	"context"
	"errors"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
)

type SysParamService struct {
}

// NewSysParamService 创建并返回一个新的 SysParamService 实例
func NewSysParamService() *SysParamService {
	return &SysParamService{}
}

// Add 新增系统参数，创建前会校验参数唯一标识（Code）是否已存在
func (s *SysParamService) Add(c context.Context, req *models.SysParamAddRequest) (*models.SysParam, error) {
	existParam := models.NewSysParam()
	if err := existParam.FindByCode(c, req.Code); err == nil && !existParam.IsEmpty() {
		return nil, errors.New("参数唯一标识已存在")
	}

	param := models.NewSysParam()
	param.Name = &req.Name
	param.Code = &req.Code
	param.Value = &req.Value
	param.Status = &req.Status
	param.Description = &req.Description

	if err := param.Create(c); err != nil {
		return nil, err
	}
	return param, nil
}

// Update 更新系统参数，更新前会校验参数是否存在以及唯一标识是否与其他参数冲突
func (s *SysParamService) Update(c context.Context, req *models.SysParamUpdateRequest) (*models.SysParam, error) {
	param := models.NewSysParam()
	if err := param.FindByID(c, req.ID); err != nil {
		return nil, errors.New("参数不存在")
	}

	existParam := models.NewSysParam()
	if err := app.DB().WithContext(c).Where("code = ? AND id != ?", req.Code, req.ID).First(existParam).Error; err == nil && !existParam.IsEmpty() {
		return nil, errors.New("参数唯一标识已被其他参数使用")
	}

	param.Name = &req.Name
	param.Code = &req.Code
	param.Value = &req.Value
	param.Status = &req.Status
	param.Description = &req.Description

	if err := param.Update(c); err != nil {
		return nil, err
	}
	return param, nil
}

// Delete 根据 ID 删除系统参数，删除前会校验参数是否存在
func (s *SysParamService) Delete(c context.Context, id uint) error {
	param := models.NewSysParam()
	if err := param.FindByID(c, id); err != nil {
		return errors.New("参数不存在")
	}
	return param.Delete(c)
}

// GetByID 根据 ID 查询系统参数详情
func (s *SysParamService) GetByID(c context.Context, id uint) (*models.SysParam, error) {
	param := models.NewSysParam()
	if err := param.FindByID(c, id); err != nil {
		return nil, errors.New("参数不存在")
	}
	return param, nil
}

// GetByCode 根据参数唯一标识（Code）查询系统参数详情
func (s *SysParamService) GetByCode(c context.Context, code string) (*models.SysParam, error) {
	param := models.NewSysParam()
	if err := param.FindByCode(c, code); err != nil {
		return nil, errors.New("参数不存在")
	}
	return param, nil
}

// List 分页查询系统参数列表，返回参数列表、总数及错误信息
func (s *SysParamService) List(c context.Context, req *models.SysParamListRequest) ([]*models.SysParam, int64, error) {
	var count int64
	if err := app.DB().WithContext(c).Model(&models.SysParam{}).Scopes(req.Handler()).Count(&count).Error; err != nil {
		return nil, 0, err
	}

	list := models.NewSysParamList()
	if err := list.Find(c, req.Paginate(), req.Handler()); err != nil {
		return nil, 0, err
	}
	return list, count, nil
}

// ListByCodePrefix 根据参数唯一标识前缀查询系统参数列表
func (s *SysParamService) ListByCodePrefix(c context.Context, prefix string) ([]*models.SysParam, error) {
	list, err := models.FindByCodePrefix(c, prefix)
	if err != nil {
		return nil, err
	}
	return list, nil
}
