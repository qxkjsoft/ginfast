package consts

const (
	BindContextKeyName = "userToken"          // token解析值绑定上下文键名
	ConfigFilePath     = "/config/config.yml" // 配置文件路径
	//服务器代码发生错误
	ServerOccurredErrorCode int    = -500100
	ServerOccurredErrorMsg  string = "服务器内部发生代码执行错误,请联系开发者排查错误日志"
	// 数据库类型
	DbTypeMySql      = "mysql"
	DbTypeSqlServer  = "sqlserver"
	DbTypePostgreSql = "postgresql"
	RequestAborted   = "request_aborted"
	// 上传类型
	UploadTypeLocal = "local"
	UploadTypeQiniu = "qiniu"
	// 上传文件类型
	UploadFileTypeImage    = "image"
	UploadFileTypeVideo    = "video"
	UploadFileTypeAudio    = "audio"
	UploadFileTypeDocument = "document"
	UploadFileTypeOther    = "other"
)
