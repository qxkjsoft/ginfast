package bootstrap

import (
	"context"
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"
	"gin-fast/app/models"
	"gin-fast/app/utils/passwordhelper"
	"log"

	"gorm.io/gorm"
	"go.uber.org/zap"
)

// initAdmin 初始化超管账号（全新部署时使用）
// 按 config.yml 的 server.initadmin 配置：enabled=true 且目标用户不存在时，自动向 sys_users 插入超管。
// 超管ID显式插入，插入后按数据库类型处理自增/序列，保证后续正常创建用户不冲突。
func initAdmin() {
	if !app.ConfigYml.GetBool("server.initadmin.enabled") {
		return
	}
	id := uint(app.ConfigYml.GetInt("server.initadmin.id"))
	username := app.ConfigYml.GetString("server.initadmin.username")
	password := app.ConfigYml.GetString("server.initadmin.password")
	if id == 0 || username == "" || password == "" {
		log.Fatal("超管初始化配置错误：server.initadmin.enabled=true 时，id、username、password 均不能为空，请检查 config.yml")
	}

	ctx := context.Background()
	// 启动期没有请求上下文，GORM 钩子不会自动填充 TenantID/CreatedBy，查询结果按 IsEmpty 判断
	byID := models.NewUser()
	if err := byID.GetUserByID(ctx, id); err != nil {
		log.Fatal("超管初始化失败：查询用户异常 " + err.Error())
	}
	byName := models.NewUser()
	if err := byName.GetUserByUsername(ctx, username); err != nil {
		log.Fatal("超管初始化失败：查询用户异常 " + err.Error())
	}

	switch {
	case !byID.IsEmpty() && byID.Username == username:
		log.Println("超管账号已存在（ID、用户名均匹配），跳过初始化")
		return
	case !byID.IsEmpty():
		app.ZapLog.Warn("超管初始化跳过：配置的用户ID已被占用",
			zap.Uint("配置ID", id),
			zap.String("已占用用户名", byID.Username),
			zap.String("配置用户名", username),
		)
		return
	case !byName.IsEmpty():
		app.ZapLog.Warn("超管初始化跳过：配置的用户名已存在",
			zap.String("配置用户名", username),
			zap.Uint("已存在用户ID", byName.ID),
			zap.Uint("配置ID", id),
		)
		return
	}

	hashed, err := passwordhelper.HashPassword(password)
	if err != nil {
		log.Fatal("超管初始化失败：密码加密异常 " + err.Error())
	}
	user := &models.User{
		BaseModel:   models.BaseModel{ID: id},
		Username:    username,
		Password:    hashed,
		Status:      1,
		NickName:    "超级管理员",
		Description: "超级管理员",
		TenantID:    0,
	}

	usedbtype := app.ConfigYml.GetString("gormv2.usedbtype")
	err = app.DB().Transaction(func(tx *gorm.DB) error {
		if usedbtype == consts.DbTypeSqlServer {
			// SQL Server 显式插入自增主键需开启 IDENTITY_INSERT，事务内保证同一连接会话
			if err := tx.Exec("SET IDENTITY_INSERT sys_users ON").Error; err != nil {
				return err
			}
			if err := tx.Create(user).Error; err != nil {
				return err
			}
			return tx.Exec("SET IDENTITY_INSERT sys_users OFF").Error
		}
		return tx.Create(user).Error
	})
	if err != nil {
		log.Fatal("超管初始化失败：" + err.Error())
	}

	// PostgreSQL 序列不会随显式插入自动推进，需手动校准，否则后续创建用户会主键冲突
	if usedbtype == consts.DbTypePostgreSql {
		if err := app.DB().Exec("SELECT setval(pg_get_serial_sequence('sys_users', 'id'), COALESCE((SELECT MAX(id) FROM sys_users), 1))").Error; err != nil {
			log.Fatal("超管初始化失败：校准 sys_users 序列异常 " + err.Error())
		}
	}

	app.ZapLog.Info("超管账号初始化完成",
		zap.Uint("用户ID", id),
		zap.String("用户名", username),
		zap.String("数据库类型", usedbtype),
	)
}
