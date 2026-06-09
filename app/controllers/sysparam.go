package controllers

import (
	"gin-fast/app/models"
	"gin-fast/app/service"
	"strconv"

	"github.com/gin-gonic/gin"
)

type SysParamController struct {
	Common
}

func NewSysParamController() *SysParamController {
	return &SysParamController{
		Common: Common{},
	}
}

var sysParamService = service.NewSysParamService()

func (spc *SysParamController) List(c *gin.Context) {
	var req models.SysParamListRequest
	if err := req.Validate(c); err != nil {
		spc.FailAndAbort(c, err.Error(), err)
	}

	list, count, err := sysParamService.List(c, &req)
	if err != nil {
		spc.FailAndAbort(c, "获取参数列表失败", err)
	}

	spc.Success(c, gin.H{
		"list":  list,
		"total": count,
	})
}

func (spc *SysParamController) GetByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		spc.FailAndAbort(c, "参数ID格式错误", err)
	}

	param, err := sysParamService.GetByID(c, uint(id))
	if err != nil {
		spc.FailAndAbort(c, "查询参数失败", err)
	}

	spc.Success(c, param)
}

func (spc *SysParamController) GetByCode(c *gin.Context) {
	code := c.Param("code")
	if code == "" {
		spc.FailAndAbort(c, "参数唯一标识不能为空", nil)
	}

	param, err := sysParamService.GetByCode(c, code)
	if err != nil {
		spc.FailAndAbort(c, "查询参数失败", err)
	}

	spc.Success(c, param)
}

func (spc *SysParamController) Add(c *gin.Context) {
	var req models.SysParamAddRequest
	if err := req.Validate(c); err != nil {
		spc.FailAndAbort(c, err.Error(), err)
	}

	param, err := sysParamService.Add(c, &req)
	if err != nil {
		spc.FailAndAbort(c, err.Error(), err)
	}

	spc.SuccessWithMessage(c, "参数创建成功", param)
}

func (spc *SysParamController) Update(c *gin.Context) {
	var req models.SysParamUpdateRequest
	if err := req.Validate(c); err != nil {
		spc.FailAndAbort(c, err.Error(), err)
	}

	param, err := sysParamService.Update(c, &req)
	if err != nil {
		spc.FailAndAbort(c, err.Error(), err)
	}

	spc.SuccessWithMessage(c, "参数更新成功", param)
}

func (spc *SysParamController) Delete(c *gin.Context) {
	var req models.SysParamDeleteRequest
	if err := req.Validate(c); err != nil {
		spc.FailAndAbort(c, err.Error(), err)
	}

	if err := sysParamService.Delete(c, req.ID); err != nil {
		spc.FailAndAbort(c, err.Error(), err)
	}

	spc.SuccessWithMessage(c, "参数删除成功", nil)
}
