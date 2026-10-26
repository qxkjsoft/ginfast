package models

import (
	"context"
	"gin-fast/app/global/app"
	"time"

	"gorm.io/gorm"
)

// SysConfig 系统配置表（后台「系统配置」页面的用户配置项）。
// 存储从 config.yml 分离出来的运行时可改配置（system/safe/captcha/演示账号默认账密），
// config.yml 从此只保留部署级配置、不再被程序改写。
// 不内嵌 BaseModel（无软删除）：配置表无删除语义，且避免软删行长期占用 code 唯一索引
type SysConfig struct {
	ID          uint      `gorm:"primarykey" json:"id"`
	Code        string    `gorm:"column:code;size:100;uniqueIndex;comment:配置键" json:"code"`
	Value       string    `gorm:"column:value;type:text;comment:配置值" json:"value"`
	Description string    `gorm:"column:description;size:500;comment:描述" json:"description"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
}

func (SysConfig) TableName() string {
	return "sys_config"
}

func NewSysConfig() *SysConfig {
	return &SysConfig{}
}

type SysConfigList []*SysConfig

func NewSysConfigList() SysConfigList {
	return SysConfigList{}
}

func (list SysConfigList) IsEmpty() bool {
	return len(list) == 0
}

// LoadAll 加载全部配置行（配置表量级固定在十几行，无需分页）
func (list *SysConfigList) LoadAll(c context.Context) (err error) {
	err = app.DB().WithContext(c).Find(list).Error
	return
}

// IsEmpty 空值判断：零值结构体表示未查到记录（本项目查询不抛 ErrRecordNotFound）
func (s *SysConfig) IsEmpty() bool {
	return s == nil || s.ID == 0
}

// UpsertValue 按配置键写入值（存在则更新，不存在则创建），tx 用于事务。
// 注意：gormhelper/client.go 全局注册了 MaskNotDataError（RaiseErrorOnNotFound=false），
// First 查无数据时不返回 ErrRecordNotFound 而是零值结构体，因此以主键判空决定插入或更新
func (s *SysConfig) UpsertValue(tx *gorm.DB) (err error) {
	var row SysConfig
	if err = tx.Where("code = ?", s.Code).First(&row).Error; err != nil {
		return
	}
	if row.IsEmpty() {
		return tx.Create(s).Error
	}
	return tx.Model(&row).Update("value", s.Value).Error
}
