package g

import (
	"gin-fast/app/global/consts"
	"gin-fast/app/utils/ymlconfig/interf"
	"log"

	"go.uber.org/zap"
	"gorm.io/gorm"
)

var (
	BasePath         string                 // 定义项目的根目录
	ConfigYml        interf.YmlConfigInterf // 全局配置文件指针
	GormDbMysql      *gorm.DB               // mysql数据库连接
	GormDbSqlserver  *gorm.DB               // sqlserver数据库连接
	GormDbPostgreSql *gorm.DB               // postgresql数据库连接
	ZapLog           *zap.Logger            // 全局日志指针
)

// DB 获取默认的数据库连接
func DB(sqlType ...string) *gorm.DB {
	var dbType string
	if len(sqlType) > 0 {
		dbType = sqlType[0]
	} else {
		dbType = ConfigYml.GetString("Gormv2.UseDbType")
	}
	var db *gorm.DB
	switch dbType {
	case consts.DbTypeMySql:
		db = GormDbMysql
	case consts.DbTypeSqlServer:
		db = GormDbSqlserver
	case consts.DbTypePostgreSql:
		db = GormDbPostgreSql
	default:
		db = GormDbMysql
	}
	if db == nil {
		log.Fatal("数据库连接失败")
	}

	return db
}
