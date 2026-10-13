package gormhelper

import (
	"errors"

	"gorm.io/gorm"
)

// IsDuplicateKeyError 判断错误是否为唯一索引/唯一约束冲突
// 需 gorm.Config 开启 TranslateError，由各数据库驱动将原始冲突错误翻译为 gorm.ErrDuplicatedKey
// （mysql 1062、postgresql 23505、sqlserver 2627；sqlserver 2601 唯一索引冲突在 v1.5.3 驱动未映射）
func IsDuplicateKeyError(err error) bool {
	return errors.Is(err, gorm.ErrDuplicatedKey)
}
