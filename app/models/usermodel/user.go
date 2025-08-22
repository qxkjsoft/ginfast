package usermodel

import (
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// User 用户模型
type User struct {
	gorm.Model
	Username string `gorm:"uniqueIndex;not null" json:"username"`
	Password string `gorm:"not null" json:"password"`
	Role     string `gorm:"not null" json:"role"` // 用户角色，用于casbin权限控制
	Email    string `json:"email"`
	IsActive bool   `gorm:"default:true" json:"is_active"`
}

// TableName 设置User表名
func (User) TableName() string {
	return "users"
}

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
	if err := app.GormDbMysql.First(&user, id).Error; err != nil {
		return nil, err
	}
	return &user, nil
}
