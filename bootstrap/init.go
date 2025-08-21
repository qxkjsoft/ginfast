package bootstrap

import (
	"gin-fast/app/global/consts"
	"gin-fast/app/global/g"
	"gin-fast/app/global/myerrors"
	"gin-fast/app/service/zaphook"
	"gin-fast/app/utils/gormhelper"
	"gin-fast/app/utils/ymlconfig"
	"gin-fast/app/utils/zaphelper"
	"log"
	"os"
	"strings"
)

func init() {
	checkRequiredFolders()
	// 初始化一些全局变量
	g.ConfigYml = ymlconfig.CreateYamlFactory()
	g.ConfigYml.ConfigFileChangeListen()
	g.ZapLog = zaphelper.CreateZapFactory(zaphook.ZapLogHandler)
	// 初始化数据库
	// mysql
	if g.ConfigYml.GetInt("Gormv2.Mysql.IsInitGlobalGormMysql") == 1 {
		if dbMysql, err := gormhelper.GetOneMysqlClient(); err != nil {
			log.Fatal(myerrors.ErrorsGormInitFail + err.Error())
		} else {
			g.GormDbMysql = dbMysql
		}
	}
	//sqlserver
	if g.ConfigYml.GetInt("Gormv2.Sqlserver.IsInitGlobalGormSqlserver") == 1 {
		if dbSqlserver, err := gormhelper.GetOneSqlserverClient(); err != nil {
			log.Fatal(myerrors.ErrorsGormInitFail + err.Error())
		} else {
			g.GormDbSqlserver = dbSqlserver
		}
	}
	//postgresql
	if g.ConfigYml.GetInt("Gormv2.Postgresql.IsInitGlobalGormPostgresql") == 1 {
		if dbPostgresql, err := gormhelper.GetOnePostgreSqlClient(); err != nil {
			log.Fatal(myerrors.ErrorsGormInitFail + err.Error())
		} else {
			g.GormDbPostgreSql = dbPostgresql
		}
	}

}
func checkRequiredFolders() {
	// 初始化程序根目录
	if path, err := os.Getwd(); err == nil {
		// 路径进行处理，兼容单元测试程序程序启动时的奇怪路径
		if len(os.Args) > 1 && strings.HasPrefix(os.Args[1], "-test") {
			g.BasePath = strings.Replace(strings.Replace(path, `\test`, "", 1), `/test`, "", 1)
		} else {
			g.BasePath = path
		}
		log.Println("当前项目根目录:", g.BasePath)
	} else {
		log.Fatal("获取当前目录失败")
	}
	//检查配置文件是否存在
	if _, err := os.Stat(g.BasePath + consts.ConfigFilePath); err != nil {
		log.Fatal(consts.ConfigFilePath + " not exists: " + err.Error())
	}
}
