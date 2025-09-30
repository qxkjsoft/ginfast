package models

import (
	"gin-fast/app/global/app"

	"gorm.io/gorm"
)

// SysAffix 文件附件模型
type SysAffix struct {
	BaseModel
	Name      string `gorm:"type:varchar(255);comment:文件名" json:"name"`
	Path      string `gorm:"type:varchar(255);comment:文件路径" json:"path"`
	Size      int    `gorm:"type:int(10);comment:文件大小(字节)" json:"size"`
	Ftype     string `gorm:"type:varchar(100);comment:文件类型" json:"ftype"`
	CreatedBy uint   `gorm:"type:int(11);comment:创建者ID" json:"createdBy"`
	Suffix    string `gorm:"type:varchar(100);comment:文件后缀" json:"suffix"`
	// 添加与User模型的关联
	User User `gorm:"foreignKey:id;references:created_by" json:"user"`
}

// SysAffixList 文件附件列表
type SysAffixList []SysAffix

// NewSysAffix 创建文件附件实例
func NewSysAffix() *SysAffix {
	return &SysAffix{}
}

// NewSysAffixList 创建文件附件列表实例
func NewSysAffixList() *SysAffixList {
	return &SysAffixList{}
}

// TableName 指定表名
func (SysAffix) TableName() string {
	return "sys_affix"
}

// GetByID 根据ID获取文件附件
func (m *SysAffix) GetByID(id uint) error {
	return app.DB().First(m, id).Error
}

// Create 创建文件附件记录
func (m *SysAffix) Create() error {
	return app.DB().Create(m).Error
}

// Update 更新文件附件记录
func (m *SysAffix) Update() error {
	return app.DB().Save(m).Error
}

// Delete 软删除文件附件记录
func (m *SysAffix) Delete() error {
	return app.DB().Delete(m).Error
}

// IsEmpty 检查模型是否为空
func (m *SysAffix) IsEmpty() bool {
	return m.ID == 0
}

// Find 查询文件附件列表
func (l *SysAffixList) Find(funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().Model(&SysAffix{}).Scopes(funcs...).Find(l).Error
}

// GetTotal 获取文件附件总数
func (l *SysAffixList) GetTotal(query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().Model(&SysAffix{}).Scopes(query...).Count(&count).Error
	return count, err
}
