package service

import (
	"context"
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/common"
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
			app.ZapLog.Error("获取表注释失败", zap.String("table", tableName), zap.Error(err))
			describe = tableName // 使用表名作为表注释
		}

		// 处理模块名称：只保留字母及下划线，且全小写
		moduleName := common.KeepLettersOnly(tableName)
		// 检查是否已存在相同的记录
		var existingGen models.SysGen
		var query string
		switch strings.ToLower(dbType) {
		case "mysql":
			query = "SELECT * FROM sys_gen WHERE db_type = ? AND `database` = ? AND name = ? LIMIT 1"
		case "postgresql":
			query = "SELECT * FROM sys_gen WHERE db_type = ? AND \"database\" = ? AND name = ? LIMIT 1"
		case "sqlserver":
			query = "SELECT TOP 1 * FROM sys_gen WHERE db_type = ? AND [database] = ? AND name = ?"
		default:
			query = "SELECT * FROM sys_gen WHERE db_type = ? AND `database` = ? AND name = ? LIMIT 1"
		}
		err = tx.Raw(query, dbType, database, tableName).Scan(&existingGen).Error
		if err != nil && err != gorm.ErrRecordNotFound {
			failedTables[tableName] = fmt.Sprintf("查询记录失败: %v", err)
			continue
		}

		var genID uint
		// 如果记录不存在，则插入新记录
		if existingGen.IsEmpty() {
			gen := models.NewSysGen()
			gen.DbType = dbType
			gen.Database = database
			gen.Name = tableName
			gen.ModuleName = moduleName
			gen.Describe = describe
			gen.FileName = moduleName
			gen.IsCover = 1
			gen.IsMenu = 1
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
		if err := sgs.insertTableFields(ctx, tx, database, tableName, genID); err != nil {
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
func (sgs *SysGenService) insertTableFields(ctx context.Context, tx *gorm.DB, database, tableName string, genID uint) error {
	codeGenService := NewCodeGenService()
	// 获取表的字段信息
	columns, err := codeGenService.GetTableColumns(database, tableName)
	if err != nil {
		return fmt.Errorf("获取表字段信息失败: %v", err)
	}

	// 遍历字段信息，插入到sys_gen_field表
	for _, column := range columns {
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
			field.DataColumnKey = column.ColumnKey.String
			field.DataUnsigned = new(int)
			if column.IsUnsigned {
				*field.DataUnsigned = 1
			}
			field.CustomName = common.KeepLettersOnly(column.ColumnName)
			// 设置是否主键（使用字段模板中的信息）
			isPrimary := 0
			if column.IsPrimaryKey() {
				isPrimary = 1
			}
			field.IsPrimary = &isPrimary

			// 设置转换后的字段信息

			field.GoType = column.GoType()
			field.FrontType = column.FrontendType()
			field.GormTag = column.BuildGormTag()
			// 添加逻辑：非created_at updated_at deleted_at created_by tenant_id 字段时 ，require  list_show form_show query_show 为1
			ignoreFields := map[string]bool{
				"created_at": true,
				"updated_at": true,
				"deleted_at": true,
				"created_by": true,
				"tenant_id":  true,
			}

			if !ignoreFields[column.ColumnName] {
				require := 1
				listShow := 1
				formShow := 1
				queryShow := 1
				field.Require = &require
				field.ListShow = &listShow
				field.FormShow = &formShow
				field.QueryShow = &queryShow
			}

			// 插入字段记录
			if err := tx.WithContext(ctx).Create(field).Error; err != nil {
				return fmt.Errorf("插入字段记录失败: %v", err)
			}
		}
	}

	return nil
}

// RefreshFields 根据sys_gen的id刷新数据库表字段信息
func (sgs *SysGenService) RefreshFields(ctx context.Context, id uint) error {
	// 获取数据库连接
	db := app.DB()

	// 根据ID查询sys_gen配置
	var sysGen models.SysGen
	if err := db.WithContext(ctx).Where("id = ?", id).First(&sysGen).Error; err != nil {
		return fmt.Errorf("查询sys_gen配置失败: %v", err)
	}

	// 开始事务
	tx := db.WithContext(ctx).Begin()
	if tx.Error != nil {
		return fmt.Errorf("开始事务失败: %v", tx.Error)
	}
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
			app.ZapLog.Error("刷新字段信息事务回滚", zap.Any("recover", r))
		}
	}()

	// 删除原有的字段信息
	if err := tx.Where("gen_id = ?", id).Delete(&models.SysGenField{}).Error; err != nil {
		tx.Rollback()
		return fmt.Errorf("删除原有字段信息失败: %v", err)
	}

	// 重新插入表的字段信息
	if err := sgs.insertTableFields(ctx, tx, sysGen.Database, sysGen.Name, id); err != nil {
		tx.Rollback()
		return fmt.Errorf("插入字段信息失败: %v", err)
	}

	// 提交事务
	if err := tx.Commit().Error; err != nil {
		return fmt.Errorf("提交事务失败: %v", err)
	}

	return nil
}

// Update 根据ID更新代码生成配置和字段信息
func (sgs *SysGenService) Update(ctx context.Context, req *models.SysGenUpdateRequest) error {

	if len(req.FieldUpdates) == 0 {
		return fmt.Errorf("字段更新列表不能为空")
	}

	// 数据验证：IsTree和IsRelationTree只能2选1
	if req.IsTree == 1 && req.IsRelationTree == 1 {
		return fmt.Errorf("树形表和关联树形数据只能选择一个")
	}

	// 数据验证：当IsRelationTree为1时，RelationTreeTable和RelationField不能为0
	if req.IsRelationTree == 1 {
		if req.RelationTreeTable == 0 {
			return fmt.Errorf("关联树形数据时，关联树形数据表ID不能为空")
		}
		if req.RelationField == 0 {
			return fmt.Errorf("关联树形数据时，关联树形数据字段ID不能为空")
		}
	}

	// 开始事务
	db := app.DB()
	tx := db.WithContext(ctx).Begin()
	if tx.Error != nil {
		return fmt.Errorf("开始事务失败: %v", tx.Error)
	}
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
			app.ZapLog.Error("更新代码生成配置事务回滚", zap.Any("recover", r))
		}
	}()

	// 当IsTree为1时，检查是否包含pid或parent_id字段且类型与主键类型一致，以及是否包含name字段
	if req.IsTree == 1 {
		var fieldList models.SysGenFieldList
		if err := fieldList.Find(ctx, func(db *gorm.DB) *gorm.DB {
			return db.Where("gen_id = ?", req.ID)
		}); err != nil {
			return fmt.Errorf("查询字段列表失败: %v", err)
		}
		if !fieldList.HasPrimaryKeyFieldNamedID() {
			return fmt.Errorf("树形表主键字段名称必须为id")
		}
		// 检查parent_id字段是否与主键类型一致
		_, err := fieldList.HasParentIDWithNumericType()
		if err != nil {
			return err
		}

		if !fieldList.HasNameField() {
			return fmt.Errorf("树形表必须包含name字段")
		}
	}

	// 更新sys_gen表的module_name、describe字段
	gen := models.NewSysGen()
	gen.ID = req.ID
	updates := make(map[string]interface{})
	if req.ModuleName != "" {
		if moduleName := common.KeepLettersOnly(req.ModuleName); moduleName != "" {
			updates["module_name"] = moduleName
		} else {
			return fmt.Errorf("模块名只保留字母和下划线")
		}
	}

	// 更新sys_gen表的file_name字段
	if req.FileName != "" {
		if fileName := common.KeepLettersOnly(req.FileName); fileName != "" {
			updates["file_name"] = fileName
		} else {
			return fmt.Errorf("文件名只保留字母和下划线")
		}
	}

	if req.Describe != "" {
		updates["describe"] = req.Describe
	}
	if req.IsCover == 1 {
		updates["is_cover"] = 1
	} else {
		updates["is_cover"] = 0
	}
	if req.IsMenu == 1 {
		updates["is_menu"] = 1
	} else {
		updates["is_menu"] = 0
	}

	if req.IsTree == 1 {
		updates["is_tree"] = 1
	} else {
		updates["is_tree"] = 0
	}

	// 更新sys_gen表的is_relation_tree、relation_tree_table、relation_field字段
	if req.IsRelationTree == 1 {
		updates["is_relation_tree"] = 1
		updates["relation_tree_table"] = req.RelationTreeTable
		updates["relation_field"] = req.RelationField
	} else {
		updates["is_relation_tree"] = 0
		updates["relation_tree_table"] = 0
		updates["relation_field"] = 0
	}

	if len(updates) > 0 {
		if err := tx.Model(gen).Updates(updates).Error; err != nil {
			tx.Rollback()
			return fmt.Errorf("更新代码生成配置失败: %v", err)
		}
	}

	// 更新sys_gen_field表的data_name、data_comment字段
	for _, fieldUpdate := range req.FieldUpdates {
		field := models.NewSysGenField()
		field.ID = fieldUpdate.ID
		fieldUpdates := make(map[string]interface{})
		if fieldUpdate.DataComment != "" {
			fieldUpdates["data_comment"] = fieldUpdate.DataComment
		}
		if fieldUpdate.CustomName != "" {
			if customName := common.KeepLettersOnly(fieldUpdate.CustomName); customName != "" {
				fieldUpdates["custom_name"] = customName
			} else {
				return fmt.Errorf("自定义字段名只保留字母和下划线")
			}
		}

		if fieldUpdate.Require != nil {
			fieldUpdates["require"] = fieldUpdate.Require
		}
		if fieldUpdate.ListShow != nil {
			fieldUpdates["list_show"] = fieldUpdate.ListShow
		}
		if fieldUpdate.FormShow != nil {
			fieldUpdates["form_show"] = fieldUpdate.FormShow
		}
		if fieldUpdate.QueryShow != nil {
			fieldUpdates["query_show"] = fieldUpdate.QueryShow
		}
		if fieldUpdate.QueryType != "" {
			fieldUpdates["query_type"] = fieldUpdate.QueryType
		}
		if fieldUpdate.FormType != "" {
			fieldUpdates["form_type"] = fieldUpdate.FormType
		}
		if fieldUpdate.DictType != "" {
			fieldUpdates["dict_type"] = fieldUpdate.DictType
		}

		if len(fieldUpdates) > 0 {
			if err := tx.Model(field).Updates(fieldUpdates).Error; err != nil {
				tx.Rollback()
				return fmt.Errorf("更新代码生成字段配置失败: %v", err)
			}
		}
	}

	// 提交事务
	if err := tx.Commit().Error; err != nil {
		return fmt.Errorf("提交事务失败: %v", err)
	}

	return nil
}

// Delete 根据ID删除代码生成配置和关联的字段信息(硬删除)
func (sgs *SysGenService) Delete(ctx context.Context, id uint) error {
	// 开始事务
	db := app.DB()
	tx := db.WithContext(ctx).Begin()
	if tx.Error != nil {
		return fmt.Errorf("开始事务失败: %v", tx.Error)
	}
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
			app.ZapLog.Error("删除代码生成配置事务回滚", zap.Any("recover", r))
		}
	}()

	// 先删除关联的sys_gen_field记录
	field := models.NewSysGenField()
	if err := tx.Where("gen_id = ?", id).Delete(field).Error; err != nil {
		tx.Rollback()
		return fmt.Errorf("删除关联的字段配置失败: %v", err)
	}

	// 再删除sys_gen记录
	gen := models.NewSysGen()
	gen.ID = id
	if err := tx.Unscoped().Delete(gen).Error; err != nil {
		tx.Rollback()
		return fmt.Errorf("删除代码生成配置失败: %v", err)
	}

	// 提交事务
	if err := tx.Commit().Error; err != nil {
		return fmt.Errorf("提交事务失败: %v", err)
	}

	return nil
}
