package models

import (
	"context"
	"gin-fast/app/global/app"
)

// SysAffixChunk 分片上传临时记录
type SysAffixChunk struct {
	BaseModel
	UploadId    string `gorm:"type:varchar(64);index;comment:上传会话ID" json:"uploadId"`
	FileMd5     string `gorm:"type:varchar(32);index;comment:文件MD5" json:"fileMd5"`
	FileName    string `gorm:"type:varchar(255);comment:原始文件名" json:"fileName"`
	FileSize    int64  `gorm:"type:bigint;comment:文件总大小" json:"fileSize"`
	ChunkSize   int    `gorm:"type:int;comment:分片大小" json:"chunkSize"`
	TotalChunks int    `gorm:"type:int;comment:总分片数" json:"totalChunks"`
	ChunkIndex  int    `gorm:"type:int;comment:当前分片序号" json:"chunkIndex"`
	ChunkPath   string `gorm:"type:varchar(255);comment:分片文件路径" json:"chunkPath"`
	Status      int    `gorm:"type:tinyint;default:0;comment:0-上传中 1-已合并 2-已取消" json:"status"`
	CreatedBy   uint   `gorm:"type:int(11);comment:创建者ID" json:"createdBy"`
	TenantID    uint   `gorm:"type:int(11);column:tenant_id;comment:租户ID" json:"tenantID"`
}

// SysAffixChunkList 分片上传记录列表
type SysAffixChunkList []SysAffixChunk

// NewSysAffixChunk 创建分片记录实例
func NewSysAffixChunk() *SysAffixChunk {
	return &SysAffixChunk{}
}

// NewSysAffixChunkList 创建分片记录列表实例
func NewSysAffixChunkList() *SysAffixChunkList {
	return &SysAffixChunkList{}
}

// TableName 指定表名
func (SysAffixChunk) TableName() string {
	return "sys_affix_chunk"
}

// Create 创建分片记录
func (m *SysAffixChunk) Create(c context.Context) error {
	return app.DB().WithContext(c).Create(m).Error
}

// GetUploadedChunkIndexes 获取指定uploadId已上传的分片序号列表
func GetUploadedChunkIndexes(c context.Context, uploadId string, tenantID uint) ([]int, error) {
	var indexes []int
	err := app.DB().WithContext(c).Model(&SysAffixChunk{}).
		Where("upload_id = ? AND status = 0 AND tenant_id = ?", uploadId, tenantID).
		Pluck("chunk_index", &indexes).Error
	return indexes, err
}

// GetChunksByUploadId 获取指定uploadId的所有分片记录
func GetChunksByUploadId(c context.Context, uploadId string, tenantID uint) (*SysAffixChunkList, error) {
	list := NewSysAffixChunkList()
	err := app.DB().WithContext(c).
		Where("upload_id = ? AND status = 0 AND tenant_id = ?", uploadId, tenantID).
		Order("chunk_index ASC").
		Find(list).Error
	return list, err
}

// UpdateChunkStatus 更新指定uploadId的所有分片状态
func UpdateChunkStatus(c context.Context, uploadId string, tenantID uint, status int) error {
	return app.DB().WithContext(c).
		Model(&SysAffixChunk{}).
		Where("upload_id = ? AND tenant_id = ?", uploadId, tenantID).
		Update("status", status).Error
}

// DeleteChunksByUploadId 删除指定uploadId的所有分片记录
func DeleteChunksByUploadId(c context.Context, uploadId string, tenantID uint) error {
	return app.DB().WithContext(c).
		Where("upload_id = ? AND tenant_id = ?", uploadId, tenantID).
		Delete(&SysAffixChunk{}).Error
}

// GetAffixByMd5 根据MD5查找是否已有完整文件（秒传检测）
func GetAffixByMd5(c context.Context, fileMd5 string, fileSize int64, tenantID uint) (*SysAffix, error) {
	affix := NewSysAffix()
	err := app.DB().WithContext(c).
		Where("file_md5 = ? AND size = ? AND tenant_id = ?", fileMd5, fileSize, tenantID).
		First(affix).Error
	if err != nil {
		return nil, err
	}
	return affix, nil
}
