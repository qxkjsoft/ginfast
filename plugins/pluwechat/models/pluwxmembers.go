package models

import (
	"context"
	"gin-fast/app/global/app"
	"gin-fast/app/models"

	"time"

	"gorm.io/gorm"
)

// Member
type Member struct {
	ID          uint            `gorm:"column:id;primaryKey;autoIncrement;comment:会员ID" json:"id"`
	Username    string          `gorm:"column:username;uniqueIndex;not null;size:50;comment:用户名" json:"username"`
	Password    string          `gorm:"column:password;not null;size:255;comment:密码" json:"-"`
	NickName    string          `gorm:"column:nick_name;size:100;comment:昵称" json:"nickName"`
	Avatar      string          `gorm:"column:avatar;size:255;comment:头像" json:"avatar"`
	Phone       string          `gorm:"column:phone;size:20;comment:手机号" json:"phone"`
	Email       string          `gorm:"column:email;size:100;comment:邮箱" json:"email"`
	Status      int             `gorm:"column:status;default:0;comment:状态：0-禁用，1-启用" json:"status"`
	LastLoginAt models.JSONTime `gorm:"column:last_login_at;comment:最后登录时间" json:"lastLoginAt"`
	LastLoginIP string          `gorm:"column:last_login_ip;size:45;comment:最后登录IP" json:"lastLoginIp"`
	LoginCount  int             `gorm:"column:login_count;default:0;comment:登录次数" json:"loginCount"`
	CreatedAt   time.Time       `gorm:"column:created_at;autoCreateTime;comment:创建时间" json:"createdAt"`
	UpdatedAt   time.Time       `gorm:"column:updated_at;autoUpdateTime;comment:更新时间" json:"updatedAt"`
	DeletedAt   gorm.DeletedAt  `gorm:"column:deleted_at;index;comment:删除时间" json:"-"`
	CreatedBy   uint            `gorm:"column:created_by;not null;default:0" json:"createdBy"` // 创建人
	TenantID    uint            `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
	Tenant      models.Tenant   `gorm:"foreignKey:tenant_id;references:id" json:"tenant"`
	OpenID      string          `gorm:"column:open_id;size:255;comment:微信OpenID" json:"openID"`
	UnionID     string          `gorm:"column:union_id;size:255;comment:微信UnionID" json:"unionID"`
}

// TableName 设置表名
func (Member) TableName() string {
	return "plu_wx_members"
}

func NewMember() *Member {
	return &Member{}
}

func (m *Member) IsEmpty() bool {
	return m == nil || m.ID == 0
}

// 基础CRUD方法
func (m *Member) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Find(m).Error
}

func (m *Member) Create(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Create(m).Error
}

func (m *Member) Update(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Save(m).Error
}

// Delete 软删除plu_members记录
func (m *Member) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(m).Error
}

// 查询方法
func (m *Member) GetByID(ctx context.Context, id uint) error {
	return m.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Preload("Tenant").Where("id = ?", id)
	})
}

func (m *Member) GetByUsername(ctx context.Context, username string) error {
	return m.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Preload("Tenant").Where("username = ?", username)
	})
}

func (m *Member) GetByPhone(ctx context.Context, phone string) error {
	return m.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Preload("Tenant").Where("phone = ?", phone)
	})
}

func (m *Member) GetByEmail(ctx context.Context, email string) error {
	return m.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Preload("Tenant").Where("email = ?", email)
	})
}

func (m *Member) GetByOpenID(ctx context.Context, openID string) error {
	return m.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Preload("Tenant").Where("open_id = ?", openID)
	})
}

// 列表类型
type MemberList []*Member

func NewMemberList() MemberList {
	return MemberList{}
}

func (list *MemberList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

// GetTotal 获取plu_members总数
func (list *MemberList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(c).Model(&Member{}).Scopes(query...).Count(&count).Error
	return count, err
}
