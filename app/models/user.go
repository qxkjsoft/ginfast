package models

import (
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// User 用户模型
type User struct {
	BaseModel
	Username    string        `gorm:"column:username;uniqueIndex;not null;size:50;comment:用户名" json:"userName"`
	Password    string        `gorm:"column:password;not null;size:255;comment:密码" json:"passWord"`
	Email       string        `gorm:"column:email;size:100;comment:邮箱" json:"email"`
	Status      int8          `gorm:"column:status;default:1;comment:是否启用 0停用 1启用" json:"status"`
	Description string        `gorm:"column:description;not null;size:500;comment:描述" json:"description"`
	DeptID      uint          `gorm:"column:dept_id;default:0;comment:部门ID" json:"deptId"`
	Phone       string        `gorm:"column:phone;size:64;comment:电话" json:"phone"`
	Sex         string        `gorm:"column:sex;size:64;comment:性别" json:"sex"`
	NickName    string        `gorm:"column:nick_name;size:100;comment:昵称" json:"nickName"`
	Avatar      string        `gorm:"column:avatar;size:255;comment:头像" json:"avatar"`
	CreatedBy   uint          `gorm:"column:created_by;default:0;comment:创建人" json:"createdBy"`
	Roles       SysRoleList   `gorm:"many2many:sys_user_role;foreignKey:id;joinForeignKey:user_id;references:id;joinReferences:role_id" json:"roles"`
	Department  SysDepartment `gorm:"foreignKey:id;references:dept_id" json:"department"`
}

// TableName 设置User表名
func (User) TableName() string {
	return "users"
}

func NewUser() *User {
	return &User{}
}

func (u *User) IsEmpty() bool {
	return u == nil || u.ID == 0
}

func (u *User) Find(funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().Scopes(funcs...).Find(u).Error
}

func (u *User) GetUserByID(id uint) (err error) {
	return u.Find(func(db *gorm.DB) *gorm.DB {
		return db.Where("id = ?", id)
	})
}

func (u *User) GetUserByUsername(username string) (err error) {
	return u.Find(func(db *gorm.DB) *gorm.DB {
		return db.Where("username = ?", username)
	})
}

// GetUserByPhone 根据手机号获取用户
func (u *User) GetUserByPhone(phone string) (err error) {
	return u.Find(func(db *gorm.DB) *gorm.DB {
		return db.Where("phone = ?", phone)
	})
}

// GetUserByEmail 根据邮箱获取用户
func (u *User) GetUserByEmail(email string) (err error) {
	return u.Find(func(db *gorm.DB) *gorm.DB {
		return db.Where("email = ?", email)
	})
}

func (u *User) Create(funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	return app.DB().Scopes(funcs...).Create(u).Error
}

// DeleteByID 根据ID软删除用户
func (u *User) DeleteByID(id uint) error {
	return app.DB().Where("id = ?", id).Delete(u).Error
}

type UserList []*User

func NewUserList() UserList {
	return UserList{}
}

func (list *UserList) Find(funcs ...func(*gorm.DB) *gorm.DB) (err error) {
	err = app.DB().Scopes(funcs...).Find(list).Error
	return

}

func (list *UserList) GetTotal(query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var total int64
	err := app.DB().Model(&User{}).Scopes(query...).Count(&total).Error
	if err != nil {
		return 0, err
	}
	return total, nil
}
