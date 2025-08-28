package models

import (
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// User 用户模型
type User struct {
	gorm.Model
	Username  string      `gorm:"column:username;uniqueIndex;not null;size:50;comment:用户名" json:"username"`
	Password  string      `gorm:"column:password;not null;size:255;comment:密码" json:"password"`
	Email     string      `gorm:"column:email;size:100;comment:邮箱" json:"email"`
	Status    int8        `gorm:"column:status;default:1;comment:是否启用 0停用 1启用" json:"status"`
	DeptID    uint        `gorm:"column:dept_id;default:0;comment:部门ID" json:"dept_id"`
	Phone     string      `gorm:"column:phone;size:64;comment:电话" json:"phone"`
	Sex       string      `gorm:"column:sex;size:64;comment:性别" json:"sex"`
	NickName  string      `gorm:"column:nick_name;size:100;comment:昵称" json:"nick_name"`
	Avatar    string      `gorm:"column:avatar;size:255;comment:头像" json:"avatar"`
	CreatedBy uint        `gorm:"column:created_by;default:0;comment:创建人" json:"created_by"`
	Roles     SysRoleList `gorm:"many2many:sys_user_role;foreignKey:id;joinForeignKey:user_id;References:id;joinReferences:role_id" json:"roles"`
}

// TableName 设置User表名
func (User) TableName() string {
	return "users"
}

type UserList []*User

// GetUserByUsername 根据用户名获取用户
func GetUserByUsername(username string) (*User, error) {
	var user User
	if err := app.GormDbMysql.Where("username = ?", username).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

// CreateUser 创建用户
func CreateUser(user *User) error {
	return app.GormDbMysql.Create(user).Error
}

// GetUserByID 根据ID获取用户
func GetUserByID(id uint) (*User, error) {
	var user User
	if err := app.GormDbMysql.Preload("Roles").First(&user, id).Error; err != nil {
		return nil, err
	}
	return &user, nil
}
