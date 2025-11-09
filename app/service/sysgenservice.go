package service

import (
	"context"
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"regexp"
	"strings"

	"go.uber.org/zap"
	"gorm.io/gorm"
)

// SysGenService 代码生成配置服务
type SysGenService struct{}

// NewSysGenService 创建代码生成配置服务
func NewSysGenService() *SysGenService {
	return &SysGenService{}
}

// BatchInsert 批量插入代码生成配置和字段信息
func (sgs *SysGenService) BatchInsert(ctx context.Context, req *models.SysGenBatchInsertRequest) (*models.BatchInsertResult, error) {
	var dbType, database string
	if req.Database == "" {
		// 获取当前使用的数据库类型
		dbType = app.ConfigYml.GetString("gormv2.usedbtype")
		// 从配置文件中获取当前数据库类型的写库名称
		database = app.ConfigYml.GetString("gormv2." + dbType + ".write.database")
	} else {
		database = req.Database
	}

	// 获取数据库连接
	db := app.DB()

	// 开始事务
	tx := db.WithContext(ctx).Begin()
	if tx.Error != nil {
		return nil, fmt.Errorf("开始事务失败: %v", tx.Error)
	}
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
			app.ZapLog.Error("批量插入代码生成配置事务回滚", zap.Any("recover", r))
		}
	}()

	// 创建代码生成服务实例
	codeGenService := NewCodeGenService()

	// 记录成功和失败的表
	successTables := make([]string, 0)
	failedTables := make(map[string]string)

	// 遍历表名称集合
	for _, tableName := range req.Tables {
		// 获取表注释
		describe, err := codeGenService.GetTableComment(database, tableName)
		if err != nil {
			failedTables[tableName] = fmt.Sprintf("获取表注释失败: %v", err)
			continue
		}

		// 处理模块名称：只保留字母且全小写
		moduleName := strings.ToLower(regexp.MustCompile("[^a-zA-Z]").ReplaceAllString(tableName, ""))

		// 检查是否已存在相同的记录
		var existingGen models.SysGen
		err = tx.Where("name = ? AND module_name = ?", tableName, moduleName).First(&existingGen).Error
		if err != nil && err != gorm.ErrRecordNotFound {
			failedTables[tableName] = fmt.Sprintf("查询记录失败: %v", err)
			continue
		}

		var genID uint
		// 如果记录不存在，则插入新记录
		if existingGen.IsEmpty() {
			gen := models.NewSysGen()
			gen.Name = tableName
			gen.ModuleName = moduleName
			gen.Describe = describe
			// 插入记录
			if err := tx.Create(gen).Error; err != nil {
				failedTables[tableName] = fmt.Sprintf("插入记录失败: %v", err)
				continue
			}
			genID = gen.ID
		} else {
			genID = existingGen.ID
		}

		// 获取表的字段信息并插入到sys_gen_field表
		if err := sgs.insertTableFields(ctx, tx, codeGenService, database, tableName, genID); err != nil {
			failedTables[tableName] = fmt.Sprintf("插入字段信息失败: %v", err)
			continue
		}

		// 添加到成功列表
		successTables = append(successTables, tableName)
	}

	// 提交事务
	if err := tx.Commit().Error; err != nil {
		return nil, fmt.Errorf("提交事务失败: %v", err)
	}

	// 返回成功响应
	return &models.BatchInsertResult{
		SuccessCount:  len(successTables),
		SuccessTables: successTables,
		FailedCount:   len(failedTables),
		FailedTables:  failedTables,
	}, nil
}

// insertTableFields 插入表的字段信息到sys_gen_field表
func (sgs *SysGenService) insertTableFields(ctx context.Context, tx *gorm.DB, codeGenService *CodeGenService, database, tableName string, genID uint) error {
	// 获取表的字段信息
	columns, err := codeGenService.GetTableColumns(database, tableName)
	if err != nil {
		return fmt.Errorf("获取表字段信息失败: %v", err)
	}

	// 生成字段模板
	columnTemplates := codeGenService.ColumnTemplate(columns)

	// 遍历字段信息，插入到sys_gen_field表
	for i, column := range columns {
		// 检查是否已存在相同的字段记录
		var existingField models.SysGenField
		err = tx.Where("gen_id = ? AND data_name = ?", genID, column.ColumnName).First(&existingField).Error
		if err != nil && err != gorm.ErrRecordNotFound {
			return fmt.Errorf("查询字段记录失败: %v", err)
		}

		// 如果字段记录不存在，则插入新记录
		if existingField.IsEmpty() {
			field := models.NewSysGenField()
			field.GenID = genID
			field.DataName = column.ColumnName
			field.DataType = column.DataType
			field.DataComment = column.ColumnComment.String
			field.DataExtra = column.Extra.String
			
			// 设置是否主键（使用字段模板中的信息）
			isPrimary := 0
			if i < len(columnTemplates) && columnTemplates[i].IsPrimary {
				isPrimary = 1
			}
			field.IsPrimary = &isPrimary
			
			// 设置转换后的字段信息
			if i < len(columnTemplates) {
				field.GoType = columnTemplates[i].GoType
				field.FrontType = columnTemplates[i].FrontendType
			}

			// 插入字段记录
			if err := tx.WithContext(ctx).Create(field).Error; err != nil {
				return fmt.Errorf("插入字段记录失败: %v", err)
			}
		}
	}

	return nil
}

// toCamelCase 将字符串转换为驼峰命名（辅助方法）
func (sgs *SysGenService) toCamelCase(s string) string {
	// 简单的驼峰转换实现
	parts := strings.Split(s, "_")
	for i := range parts {
		if i > 0 && len(parts[i]) > 0 {
			parts[i] = strings.ToUpper(parts[i][:1]) + parts[i][1:]
		}
	}
	return strings.Join(parts, "")
}
