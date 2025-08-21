package myerrors

const (
	ErrorsGormInitFail             string = "Gorm 数据库驱动、连接初始化失败"
	ErrorsDbDriverNotExists        string = "数据库驱动类型不存在,目前支持的数据库类型：mysql、sqlserver、postgresql，您提交数据库类型："
	ErrorsDialectorDbInitFail      string = "gorm dialector 初始化失败,dbType:"
	ErrorsGormDBCreateParamsNotPtr string = "gorm Create 函数的参数必须是一个指针, 为了完美支持 gorm 的所有回调函数,请在参数前面添加 & "
	ErrorsGormDBUpdateParamsNotPtr string = "gorm 的 Update、Save 函数的参数必须是一个指针(GinSkeleton ≥ v1.5.29 版本新增验证，为了完美支持 gorm 的所有回调函数,请在参数前面添加 & )"
)
