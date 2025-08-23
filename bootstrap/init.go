package bootstrap

import (
	"context"
	"gin-fast/app/global/app"
	"gin-fast/app/global/consts"
	"gin-fast/app/global/myerrors"
	"gin-fast/app/service/zaphook"
	"gin-fast/app/utils/cachehelper"
	"gin-fast/app/utils/casbinhelper"
	"gin-fast/app/utils/gormhelper"
	"gin-fast/app/utils/response"
	"gin-fast/app/utils/tokenhelper"
	"gin-fast/app/utils/ymlconfig"
	"log"
	"os"
	"strings"
	"time"

	"github.com/natefinch/lumberjack"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

func init() {
	checkRequiredFolders()

	// 配置文件
	app.ConfigYml = ymlconfig.CreateYamlFactory(app.BasePath + "/config")
	app.ConfigYml.ConfigFileChangeListen()
	// 日志
	app.ZapLog = CreateZapFactory(zaphook.ZapLogHandler)
	// 初始化数据库
	InitDB()
	// 初始化casbin
	app.CasbinV2 = casbinhelper.NewCasbinService()
	err := app.CasbinV2.InitCasbin(app.DB(), app.ConfigYml.GetString("Casbin.ModelConfig"))
	if err != nil {
		log.Fatal("CasbinV2.InitCasbin err :" + err.Error())
	}

	// 初始化缓存管理
	app.Cache = NewCache()

	// 初始化token管理
	app.TokenService = NewTokenService(app.Cache)

	// 初始化Response
	app.Response = response.NewResponseHandler()
}

// 初始化数据库
func InitDB() {
	// mysql
	if app.ConfigYml.GetInt("Gormv2.Mysql.IsInitGlobalGormMysql") == 1 {
		if dbMysql, err := gormhelper.GetOneMysqlClient(); err != nil {
			log.Fatal(myerrors.ErrorsGormInitFail + err.Error())
		} else {
			app.GormDbMysql = dbMysql
		}
	}
	//sqlserver
	if app.ConfigYml.GetInt("Gormv2.Sqlserver.IsInitGlobalGormSqlserver") == 1 {
		if dbSqlserver, err := gormhelper.GetOneSqlserverClient(); err != nil {
			log.Fatal(myerrors.ErrorsGormInitFail + err.Error())
		} else {
			app.GormDbSqlserver = dbSqlserver
		}
	}
	//postgresql
	if app.ConfigYml.GetInt("Gormv2.Postgresql.IsInitGlobalGormPostgresql") == 1 {
		if dbPostgresql, err := gormhelper.GetOnePostgreSqlClient(); err != nil {
			log.Fatal(myerrors.ErrorsGormInitFail + err.Error())
		} else {
			app.GormDbPostgreSql = dbPostgresql
		}
	}
}

// 检查必要的文件夹是否存在
func checkRequiredFolders() {
	// 初始化程序根目录
	if path, err := os.Getwd(); err == nil {
		// 路径进行处理，兼容单元测试程序程序启动时的奇怪路径
		if len(os.Args) > 1 && strings.HasPrefix(os.Args[1], "-test") {
			app.BasePath = strings.Replace(strings.Replace(path, `\test`, "", 1), `/test`, "", 1)
		} else {
			app.BasePath = path
		}
		log.Println("当前项目根目录:", app.BasePath)
	} else {
		log.Fatal("获取当前目录失败")
	}
	//检查配置文件是否存在
	if _, err := os.Stat(app.BasePath + consts.ConfigFilePath); err != nil {
		log.Fatal(consts.ConfigFilePath + " not exists: " + err.Error())
	}
}

// CreateZapFactory 创建zap日志工厂
func CreateZapFactory(entry func(zapcore.Entry) error) *zap.Logger {
	// 获取程序所处的模式：  开发调试 、 生产
	appDebug := app.ConfigYml.GetBool("AppDebug")

	// 判断程序当前所处的模式，调试模式直接返回一个便捷的zap日志管理器地址，所有的日志打印到控制台即可
	if appDebug == true {
		if logger, err := zap.NewDevelopment(zap.Hooks(entry)); err == nil {
			return logger
		} else {
			log.Fatal("创建zap日志包失败，详情：" + err.Error())
		}
	}

	// 以下才是 非调试（生产）模式所需要的代码
	encoderConfig := zap.NewProductionEncoderConfig()

	timePrecision := app.ConfigYml.GetString("Logs.TimePrecision")
	var recordTimeFormat string
	switch timePrecision {
	case "second":
		recordTimeFormat = "2006-01-02 15:04:05"
	case "millisecond":
		recordTimeFormat = "2006-01-02 15:04:05.000"
	default:
		recordTimeFormat = "2006-01-02 15:04:05"

	}
	encoderConfig.EncodeTime = func(t time.Time, enc zapcore.PrimitiveArrayEncoder) {
		enc.AppendString(t.Format(recordTimeFormat))
	}
	encoderConfig.EncodeLevel = zapcore.CapitalLevelEncoder
	encoderConfig.TimeKey = "created_at" // 生成json格式日志的时间键字段，默认为 ts,修改以后方便日志导入到 ELK 服务器

	var encoder zapcore.Encoder
	switch app.ConfigYml.GetString("Logs.TextFormat") {
	case "console":
		encoder = zapcore.NewConsoleEncoder(encoderConfig) // 普通模式
	case "json":
		encoder = zapcore.NewJSONEncoder(encoderConfig) // json格式
	default:
		encoder = zapcore.NewConsoleEncoder(encoderConfig) // 普通模式
	}

	//写入器
	fileName := app.BasePath + app.ConfigYml.GetString("Logs.ZapLogName")
	lumberJackLogger := &lumberjack.Logger{
		Filename:   fileName,                                //日志文件的位置
		MaxSize:    app.ConfigYml.GetInt("Logs.MaxSize"),    //在进行切割之前，日志文件的最大大小（以MB为单位）
		MaxBackups: app.ConfigYml.GetInt("Logs.MaxBackups"), //保留旧文件的最大个数
		MaxAge:     app.ConfigYml.GetInt("Logs.MaxAge"),     //保留旧文件的最大天数
		Compress:   app.ConfigYml.GetBool("Logs.Compress"),  //是否压缩/归档旧文件
	}
	writer := zapcore.AddSync(lumberJackLogger)
	// 开始初始化zap日志核心参数，
	//参数一：编码器
	//参数二：写入器
	//参数三：参数级别，debug级别支持后续调用的所有函数写日志，如果是 fatal 高级别，则级别>=fatal 才可以写日志
	zapCore := zapcore.NewCore(encoder, writer, zap.InfoLevel)
	return zap.New(zapCore, zap.AddCaller(), zap.Hooks(entry), zap.AddStacktrace(zap.WarnLevel))
}

// NewCache 初始化缓存
func NewCache() cachehelper.CacheInterf {
	cacheType := app.ConfigYml.GetString("Server.CacheType")
	if cacheType == "redis" {
		redisHelper, err := cachehelper.NewRedisHelper(
			app.ConfigYml.GetString("Redis.Host")+":"+app.ConfigYml.GetString("Redis.Port"),
			app.ConfigYml.GetString("Redis.Password"),
			app.ConfigYml.GetInt("Redis.IndexDb"),
		)
		if err != nil {
			panic(err)
		}

		return redisHelper
	}
	return cachehelper.NewMemoryHelper()
}

func NewTokenService(cache cachehelper.CacheInterf) tokenhelper.TokenServiceInterface {
	return &tokenhelper.TokenService{
		RedisHelper:    cache,
		JWTSecret:      app.ConfigYml.GetString("Token.JwtTokenSignKey"),
		Ctx:            context.Background(),
		TokenExpire:    app.ConfigYml.GetDuration("Token.JwtTokenExpire"),
		RefreshExpire:  app.ConfigYml.GetDuration("Token.JwtTokenRefreshExpire"),
		CacheKeyPrefix: app.ConfigYml.GetString("Token.CacheKeyPrefix"),
	}
}
