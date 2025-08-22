package app

import (
	"gin-fast/app/global/consts"
	"gin-fast/app/utils/cachehelper"
	"gin-fast/app/utils/casbinhelper"
	"gin-fast/app/utils/tokenhelper"
	"gin-fast/app/utils/ymlconfig"

	"log"

	"go.uber.org/zap"
	"gorm.io/gorm"
)

var (
	BasePath         string                            // 定义项目的根目录
	ConfigYml        ymlconfig.YmlConfigInterf         // 全局配置文件指针
	GormDbMysql      *gorm.DB                          // mysql数据库连接
	GormDbSqlserver  *gorm.DB                          // sqlserver数据库连接
	GormDbPostgreSql *gorm.DB                          // postgresql数据库连接
	ZapLog           *zap.Logger                       // 全局日志指针
	CasbinV2         casbinhelper.CasbinInterf         // casbin指针
	Cache            cachehelper.CacheInterf           // 缓存指针
	TokenService     tokenhelper.TokenServiceInterface // token管理
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
