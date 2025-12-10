package gormhelper

import (
	"errors"
	"fmt"
	"gin-fast/app/global/app"
	"gin-fast/app/global/myerrors"
	"strings"
	"time"

	"go.uber.org/zap"
	"gorm.io/driver/mysql"
	"gorm.io/driver/postgres"
	"gorm.io/driver/sqlserver"
	"gorm.io/gorm"
	gormLog "gorm.io/gorm/logger"
	"gorm.io/plugin/dbresolver"
)

// 获取一个 mysql 客户端
func GetOneMysqlClient() (*gorm.DB, error) {
	sqlType := "mysql"
	readDbIsOpen := app.ConfigYml.GetInt("gormv2." + sqlType + ".isopenreaddb")
	return GetSqlDriver(sqlType, readDbIsOpen)
}

// 获取一个 sqlserver 客户端
func GetOneSqlserverClient() (*gorm.DB, error) {
	sqlType := "sqlserver"
	readDbIsOpen := app.ConfigYml.GetInt("gormv2." + sqlType + ".isopenreaddb")
	return GetSqlDriver(sqlType, readDbIsOpen)
}

// 获取一个 postgresql 客户端
func GetOnePostgreSqlClient() (*gorm.DB, error) {
	sqlType := "postgresql"
	readDbIsOpen := app.ConfigYml.GetInt("gormv2." + sqlType + ".isopenreaddb")
	return GetSqlDriver(sqlType, readDbIsOpen)
}

// 获取数据库驱动, 可以通过options 动态参数连接任意多个数据库
func GetSqlDriver(sqlType string, readDbIsOpen int, dbConf ...ConfigParams) (*gorm.DB, error) {

	var dbDialector gorm.Dialector
	if val, err := getDbDialector(sqlType, "Write", dbConf...); err != nil {
		app.ZapLog.Error(myerrors.ErrorsDialectorDbInitFail+sqlType, zap.Error(err))
	} else {
		dbDialector = val
	}
	gormDb, err := gorm.Open(dbDialector, &gorm.Config{
		SkipDefaultTransaction: true,
		PrepareStmt:            true,
		Logger:                 redefineLog(sqlType), //拦截、接管 gorm v2 自带日志
	})
	if err != nil {
		//gorm 数据库驱动初始化失败
		return nil, err
	}

	// 如果开启了读写分离，配置读数据库（resource、read、replicas）
	// 读写分离配置只
	if readDbIsOpen == 1 {
		if val, err := getDbDialector(sqlType, "Read", dbConf...); err != nil {
			app.ZapLog.Error(myerrors.ErrorsDialectorDbInitFail+sqlType, zap.Error(err))
		} else {
			dbDialector = val
		}
		resolverConf := dbresolver.Config{
			Replicas: []gorm.Dialector{dbDialector}, //  读 操作库，查询类
			Policy:   dbresolver.RandomPolicy{},     // sources/replicas 负载均衡策略适用于
		}
		err = gormDb.Use(dbresolver.Register(resolverConf).
			SetConnMaxIdleTime(time.Duration(app.ConfigYml.GetInt("gormv2."+sqlType+".read.setconnmaxidletime")) * time.Second).
			SetConnMaxLifetime(time.Duration(app.ConfigYml.GetInt("gormv2."+sqlType+".read.setconnmaxlifetime")) * time.Second).
			SetMaxIdleConns(app.ConfigYml.GetInt("gormv2." + sqlType + ".read.setmaxidleconns")).
			SetMaxOpenConns(app.ConfigYml.GetInt("gormv2." + sqlType + ".read.setmaxopenconns")))
		if err != nil {
			return nil, err
		}
	}

	// 查询没有数据，屏蔽 gorm v2 包中会爆出的错误
	// https://github.com/go-gorm/gorm/issues/3789  此 issue 所反映的问题就是我们本次解决掉的
	_ = gormDb.Callback().Query().Before("gorm:query").Register("disable_raise_record_not_found", MaskNotDataError)

	// https://github.com/go-gorm/gorm/issues/4838
	_ = gormDb.Callback().Create().Before("gorm:before_create").Register("CreateBeforeHook", CreateBeforeHook)
	// 为了完美支持gorm的一系列回调函数
	_ = gormDb.Callback().Update().Before("gorm:before_update").Register("UpdateBeforeHook", UpdateBeforeHook)

	// 为主连接设置连接池(43行返回的数据库驱动指针)
	if rawDb, err := gormDb.DB(); err != nil {
		return nil, err
	} else {
		rawDb.SetConnMaxIdleTime(time.Duration(app.ConfigYml.GetInt("gormv2."+sqlType+".write.setconnmaxidletime")) * time.Second)
		rawDb.SetConnMaxLifetime(time.Duration(app.ConfigYml.GetInt("gormv2."+sqlType+".write.setconnmaxlifetime")) * time.Second)
		rawDb.SetMaxIdleConns(app.ConfigYml.GetInt("gormv2." + sqlType + ".write.setmaxidleconns"))
		rawDb.SetMaxOpenConns(app.ConfigYml.GetInt("gormv2." + sqlType + ".write.setmaxopenconns"))
		return gormDb, nil
	}
}

// 获取一个数据库方言(Dialector),通俗的说就是根据不同的连接参数，获取具体的一类数据库的连接指针
func getDbDialector(sqlType, readWrite string, dbConf ...ConfigParams) (gorm.Dialector, error) {
	var dbDialector gorm.Dialector
	dsn := getDsn(sqlType, readWrite, dbConf...)
	switch strings.ToLower(sqlType) {
	case "mysql":
		dbDialector = mysql.Open(dsn)
	case "sqlserver", "mssql":
		dbDialector = sqlserver.Open(dsn)
	case "postgres", "postgresql", "postgre":
		dbDialector = postgres.Open(dsn)
	default:
		return nil, errors.New(myerrors.ErrorsDbDriverNotExists + sqlType)
	}
	return dbDialector, nil
}

// 根据配置参数生成数据库驱动 dsn
func getDsn(sqlType, readWrite string, dbConf ...ConfigParams) string {
	Host := app.ConfigYml.GetString("gormv2." + sqlType + "." + readWrite + ".host")
	DataBase := app.ConfigYml.GetString("gormv2." + sqlType + "." + readWrite + ".database")
	Port := app.ConfigYml.GetInt("gormv2." + sqlType + "." + readWrite + ".port")
	User := app.ConfigYml.GetString("gormv2." + sqlType + "." + readWrite + ".user")
	Pass := app.ConfigYml.GetString("gormv2." + sqlType + "." + readWrite + ".pass")
	Charset := app.ConfigYml.GetString("gormv2." + sqlType + "." + readWrite + ".charset")

	if len(dbConf) > 0 {
		if strings.ToLower(readWrite) == "write" {
			if len(dbConf[0].Write.Host) > 0 {
				Host = dbConf[0].Write.Host
			}
			if len(dbConf[0].Write.DataBase) > 0 {
				DataBase = dbConf[0].Write.DataBase
			}
			if dbConf[0].Write.Port > 0 {
				Port = dbConf[0].Write.Port
			}
			if len(dbConf[0].Write.User) > 0 {
				User = dbConf[0].Write.User
			}
			if len(dbConf[0].Write.Pass) > 0 {
				Pass = dbConf[0].Write.Pass
			}
			if len(dbConf[0].Write.Charset) > 0 {
				Charset = dbConf[0].Write.Charset
			}
		} else {
			if len(dbConf[0].Read.Host) > 0 {
				Host = dbConf[0].Read.Host
			}
			if len(dbConf[0].Read.DataBase) > 0 {
				DataBase = dbConf[0].Read.DataBase
			}
			if dbConf[0].Read.Port > 0 {
				Port = dbConf[0].Read.Port
			}
			if len(dbConf[0].Read.User) > 0 {
				User = dbConf[0].Read.User
			}
			if len(dbConf[0].Read.Pass) > 0 {
				Pass = dbConf[0].Read.Pass
			}
			if len(dbConf[0].Read.Charset) > 0 {
				Charset = dbConf[0].Read.Charset
			}
		}
	}

	switch strings.ToLower(sqlType) {
	case "mysql":
		return fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=%s&parseTime=true&loc=Local", User, Pass, Host, Port, DataBase, Charset)
	case "sqlserver", "mssql":
		// UseRowNumberForPaging=true 这个参数会告诉GORM的驱动，在为分页生成SQL时，使用兼容旧版本（SQL Server 2008）的ROW_NUMBER()语法，而不是OFFSET...FETCH
		return fmt.Sprintf("server=%s;port=%d;database=%s;user id=%s;password=%s;encrypt=disable;UseRowNumberForPaging=true", Host, Port, DataBase, User, Pass)
	case "postgresql", "postgre", "postgres":
		return fmt.Sprintf("host=%s port=%d dbname=%s user=%s password=%s sslmode=disable TimeZone=Asia/Shanghai", Host, Port, DataBase, User, Pass)
	}
	return ""
}

// 创建自定义日志模块，对 gorm 日志进行拦截、
func redefineLog(sqlType string) gormLog.Interface {
	return createCustomGormLog(sqlType,
		SetInfoStrFormat("[info] %s\n"), SetWarnStrFormat("[warn] %s\n"), SetTraceErrStrFormat("[error] %s\n"),
		SetTraceStrFormat("[traceStr] %s [%.3fms] [rows:%v] %s\n"), SetTraceWarnStrFormat("[traceWarn] %s %s [%.3fms] [rows:%v] %s\n"), SetTracErrStrFormat("[traceErr] %s %s [%.3fms] [rows:%v] %s\n"))
}
