package models

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// RefreshRequest 刷新token请求结构
type RefreshRequest struct {
	RefreshToken string `form:"refreshToken" validate:"required"`
}

type AddRequest struct {
	Validator
	UserName    string `form:"userName" validate:"required" message:"用户名不能为空"`
	NickName    string `form:"nickName" validate:"required" message:"昵称不能为空"`
	Phone       string `form:"phone"`
	Email       string `form:"email"`
	Password    string `form:"password" validate:"required|min_len:6" message:"密码至少6位"`
	Sex         string `form:"sex" validate:"required" message:"性别不能为空"`
	DeptId      uint   `form:"deptId" validate:"required" message:"部门ID不能为空"`
	Roles       []uint `form:"roles" validate:"required" message:"角色不能为空"`
	Status      int8   `form:"status"`
	Description string `form:"description"`
}

func (r *AddRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

type UpdateRequest struct {
	Validator
	Id          uint   `form:"id"  validate:"required" message:"ID不能为空"`
	UserName    string `form:"userName" validate:"required" message:"用户名不能为空"`
	NickName    string `form:"nickName" validate:"required" message:"昵称不能为空"`
	Phone       string `form:"phone"`
	Email       string `form:"email"`
	Sex         string `form:"sex" validate:"required" message:"性别不能为空"`
	DeptId      uint   `form:"deptId" validate:"required" message:"部门ID不能为空"`
	Roles       []uint `form:"roles" validate:"required" message:"角色不能为空"`
	Status      int8   `form:"status" `
	Description string `form:"description"`
}

func (r *UpdateRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

type LoginRequest struct {
	Validator
	Username   string `form:"username" validate:"required" message:"用户名不能为空"`
	Password   string `form:"password" validate:"required" message:"密码不能为空"`
	TenantCode string `form:"tenantCode"`
}

func (r *LoginRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

type CaptchaImgRequest struct {
	Validator
	CaptchaId string `form:"captchaId" validate:"required" message:"验证码ID不能为空"`
	Time      string `form:"time"`
	Width     int    `form:"width"`
	Height    int    `form:"height"`
}

func (r *CaptchaImgRequest) Validate(c *gin.Context) error {
	err := r.Check(c, r)
	if err != nil {
		return err
	}
	if r.Width == 0 {
		r.Width = 160
	}
	if r.Height == 0 {
		r.Height = 50
	}
	return nil
}

type UserListRequest struct {
	BasePaging
	Validator
	Ids         []uint   `form:"ids"`
	DeptIds     []uint   `form:"deptIds"`
	Name        string   `form:"name"`
	Phone       string   `form:"phone"`
	Status      string   `form:"status"`
	CreateTime  []string `form:"createTime"`
	NotTenantId *uint    `form:"notTenantId"`
	NotGlobal   bool     `form:"notGlobal"`
	TenantId    *uint    `form:"tenantId"`
}

func (r *UserListRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

func (r *UserListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if len(r.Ids) > 0 {
			db = db.Where("id IN ?", r.Ids)
		}
		if len(r.DeptIds) > 0 {
			db = db.Where("dept_id IN ?", r.DeptIds)
		}
		if r.Name != "" {
			db = db.Where("username LIKE ? OR nick_name LIKE ?", "%"+r.Name+"%", "%"+r.Name+"%")
		}
		if r.Phone != "" {
			db = db.Where("phone LIKE ?", "%"+r.Phone+"%")
		}
		if r.Status != "" {
			db = db.Where("status = ?", r.Status)
		}
		if len(r.CreateTime) > 1 {
			db = db.Where("created_at BETWEEN ? AND ?", r.CreateTime[0], r.CreateTime[1])
		}
		if r.NotTenantId != nil {
			// 添加子查询，排除当前租户ID为*r.NotTenantId的非默认租户用户及*r.NotTenantId 租户下的用户
			subQuery := db.Session(&gorm.Session{NewDB: true}).Model(&SysUserTenant{}).
				Select("user_id").
				Where("tenant_id = ? and is_default = ?", *r.NotTenantId, 0)
			db = db.Where("id NOT IN (?) and tenant_id <> ?", subQuery, *r.NotTenantId)
		}
		if r.TenantId != nil {
			db = db.Where("tenant_id = ?", *r.TenantId)
		}

		// 如果NotGlobal为true，排除全局租户用户
		if r.NotGlobal {
			db = db.Where("tenant_id <> ?", 0)
		}

		return db
	}
}

// DeleteRequest 删除用户请求结构
type DeleteRequest struct {
	Validator
	Id uint `form:"id" validate:"required" message:"用户ID不能为空"`
}

func (r *DeleteRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}

// 用户权限信息
type UserProfile struct {
	User
	Permissions []string `json:"permissions"`
}

// UpdateAccountRequest 更新用户账户信息请求结构
type UpdateAccountRequest struct {
	Validator
	ID       uint   `form:"id" validate:"required" message:"用户ID不能为空"`
	Password string `form:"password"`
	Phone    string `form:"phone" validate:"required" message:"手机号不能为空"`
	Email    string `form:"email" validate:"email" message:"邮箱格式不正确"`
}

func (r *UpdateAccountRequest) Validate(c *gin.Context) error {
	return r.Check(c, r)
}
