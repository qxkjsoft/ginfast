// Package sysconfighelper 系统配置读写助手。
// 后台「系统配置」页面的用户配置项（system/safe/captcha/演示账号默认账密）存储于
// 数据库 sys_config 表，本包提供带内存缓存的读取与更新。
// sys_config 表由部署时导入 resource/database 下的结构 SQL 创建（本包不自动建表）；
// 各配置项的初始默认值保留在 config.yml 中，启动时据此补种缺失的配置行——
// 数据库为运行时唯一数据源，config.yml 仅提供初始值。
// 注意：缓存为本进程内存，多实例部署时其它实例需重启才能看到变更（单机部署无影响）。
package sysconfighelper

import (
	"context"
	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"strconv"
	"sync"

	"github.com/spf13/cast"
	"gorm.io/gorm"
)

// 配置键常量，沿用从 config.yml 分离前的原点分键，便于与历史配置对应
const (
	CodeSystemLogo         = "system.systemlogo"
	CodeSystemIcon         = "system.systemicon"
	CodeSystemName         = "system.systemname"
	CodeSystemCopyright    = "system.systemcopyright"
	CodeSystemRecordNo     = "system.systemrecordno"
	CodeDemoUsername       = "server.demoaccount.defaultusername"
	CodeDemoPassword       = "server.demoaccount.defaultpassword"
	CodeLoginLockThreshold = "safe.loginlockthreshold"
	CodeLoginLockExpire    = "safe.loginlockexpire"
	CodeLoginLockDuration  = "safe.loginlockduration"
	CodeMinPasswordLength  = "safe.minpasswordlength"
	CodeRequireSpecialChar = "safe.requirespecialchar"
	CodeCaptchaOpen        = "captcha.open"
	CodeCaptchaLength      = "captcha.length"
)

// 配置项类型
const (
	typeString = iota
	typeInt
	typeBool
)

// configItem 单个配置项的元数据：键、类型、描述。
// 初始默认值不在此写死，统一以 config.yml 对应键的现值为准
type configItem struct {
	code string
	typ  int
	desc string
}

// items 全部用户配置项。新增配置项时在此追加，并在 config.yml 补充对应初始值
var items = []configItem{
	{CodeSystemLogo, typeString, "系统LOGO图片地址"},
	{CodeSystemIcon, typeString, "系统图标地址"},
	{CodeSystemName, typeString, "系统名称"},
	{CodeSystemCopyright, typeString, "版权声明信息"},
	{CodeSystemRecordNo, typeString, "网站备案号"},
	{CodeDemoUsername, typeString, "登录页默认账号（演示账号开关开启时显示）"},
	{CodeDemoPassword, typeString, "演示密码（登录页密码框placeholder提示用，用户自行输入）"},
	{CodeLoginLockThreshold, typeInt, "密码错误锁定阈值（指定时间内连续登录失败次数达到该值将锁定账号，0表示不锁定）"},
	{CodeLoginLockExpire, typeInt, "连续登录失败次数记录缓存时间（秒）"},
	{CodeLoginLockDuration, typeInt, "账号锁定时长（秒）"},
	{CodeMinPasswordLength, typeInt, "密码最小长度"},
	{CodeRequireSpecialChar, typeBool, "密码是否必须包含特殊字符"},
	{CodeCaptchaOpen, typeBool, "是否开启验证码功能"},
	{CodeCaptchaLength, typeInt, "验证码字符长度"},
}

// SysConfigHelper 系统配置助手（进程内单例，内存缓存）
type SysConfigHelper struct {
	mu     sync.RWMutex
	values map[string]string
}

var (
	helperInstance *SysConfigHelper
	helperOnce     sync.Once
)

// Instance 获取系统配置助手单例
func Instance() *SysConfigHelper {
	helperOnce.Do(func() {
		helperInstance = &SysConfigHelper{}
	})
	return helperInstance
}

// Init 初始化：加载 sys_config 全部配置行到内存缓存；
// 缺失的配置行按 config.yml 现值补种（全新空表即为全量播种，一次性、只读不回写 config.yml）。
// 表由部署时导入结构 SQL 创建，此处不自动建表——表缺失时返回错误由调用方致命退出。
// 应在数据库初始化完成后、任何业务消费之前调用（bootstrap）
func (h *SysConfigHelper) Init() error {
	list := models.NewSysConfigList()
	if err := list.LoadAll(context.Background()); err != nil {
		return err
	}
	created, err := h.seedMissing(list)
	if err != nil {
		return err
	}
	if created {
		if err := list.LoadAll(context.Background()); err != nil {
			return err
		}
	}

	values := make(map[string]string, len(list))
	for _, row := range list {
		values[row.Code] = row.Value
	}
	h.applyValues(values)
	return nil
}

// seedMissing 按 items 清单补种数据库中缺失的配置行，初值取 config.yml 现值
// （键缺失时为类型零值），返回是否发生了补种
func (h *SysConfigHelper) seedMissing(list models.SysConfigList) (created bool, err error) {
	existing := make(map[string]bool, len(list))
	for _, row := range list {
		existing[row.Code] = true
	}
	err = app.DB().Transaction(func(tx *gorm.DB) error {
		for _, it := range items {
			if existing[it.code] {
				continue
			}
			row := models.NewSysConfig()
			row.Code = it.code
			row.Value = readFromYml(it)
			row.Description = it.desc
			if err := tx.Create(row).Error; err != nil {
				return err
			}
			created = true
		}
		return nil
	})
	return
}

// readFromYml 按 配置项声明 的类型从 config.yml 读取初始值并转为字符串
// （键缺失时 viper 返回类型零值）
func readFromYml(it configItem) string {
	switch it.typ {
	case typeBool:
		return strconv.FormatBool(app.ConfigYml.GetBool(it.code))
	case typeInt:
		return strconv.Itoa(app.ConfigYml.GetInt(it.code))
	default:
		return app.ConfigYml.GetString(it.code)
	}
}

// Update 批量更新配置：忽略未知键，事务逐项 upsert 后刷新内存缓存
func (h *SysConfigHelper) Update(values map[string]string) error {
	updates := make([]models.SysConfig, 0, len(values))
	for _, it := range items {
		if v, ok := values[it.code]; ok {
			updates = append(updates, models.SysConfig{Code: it.code, Value: v, Description: it.desc})
		}
	}
	if len(updates) == 0 {
		return nil
	}
	err := app.DB().Transaction(func(tx *gorm.DB) error {
		for i := range updates {
			if err := updates[i].UpsertValue(tx); err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return err
	}
	h.mu.Lock()
	for i := range updates {
		h.values[updates[i].Code] = updates[i].Value
	}
	h.mu.Unlock()
	return nil
}

// applyValues 整体替换内存缓存（Init 与测试用）
func (h *SysConfigHelper) applyValues(values map[string]string) {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.values = make(map[string]string, len(values))
	for k, v := range values {
		h.values[k] = v
	}
}

// GetString 读取字符串配置，缓存缺失时返回空串
func (h *SysConfigHelper) GetString(code string) string {
	h.mu.RLock()
	defer h.mu.RUnlock()
	return h.values[code]
}

// GetInt 读取整型配置
func (h *SysConfigHelper) GetInt(code string) int {
	return cast.ToInt(h.GetString(code))
}

// GetBool 读取布尔配置
func (h *SysConfigHelper) GetBool(code string) bool {
	return cast.ToBool(h.GetString(code))
}
