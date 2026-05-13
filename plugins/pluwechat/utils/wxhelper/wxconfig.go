package wxhelper

import (
	"fmt"
	"gin-fast/app/global/app"
	"sync"
	"time"

	"github.com/fsnotify/fsnotify"
	"github.com/spf13/viper"
	"go.uber.org/zap"
)

const (
	// ConfigName 配置文件名称（无扩展名）
	ConfigName = "wxconfig"
	// ConfigType 配置文件类型
	ConfigType = "yml"
	// ConfigPath 配置文件路径
	ConfigPath = "./config/wxconfig"
)

var (
	configOnce     sync.Once
	wxConfig       *Configuration // 全局配置实例
	wxViper        *viper.Viper
	configMu       sync.RWMutex
	lastChangeTime time.Time

	// 配置变更回调相关
	callbackMu      sync.Mutex
	configCallbacks []func(*Configuration)
)

func init() {
	lastChangeTime = time.Now()
}

type Configuration struct {
	MiniProgram     MiniProgramConfig     `mapstructure:"miniprogram" json:"miniprogram"`         // 小程序配置
	Payment         PaymentConfig         `mapstructure:"payment" json:"payment"`                 //	支付配置
	OfficialAccount OfficialAccountConfig `mapstructure:"officialaccount" json:"officialaccount"` // 公众号配置
}

// GetConfig 获取当前配置的副本
func GetConfig() *Configuration {
	configOnce.Do(func() {
		wxViper = viper.New()
		wxViper.SetConfigName(ConfigName) // 配置文件名称 (无扩展名)
		wxViper.SetConfigType(ConfigType) // 配置文件类型
		wxViper.AddConfigPath(ConfigPath) // 查找配置文件的路径
		wxConfig = new(Configuration)
		// 读取配置文件
		if err := wxViper.ReadInConfig(); err != nil {
			app.ZapLog.Panic("读取配置文件失败", zap.Error(err))
		}
		// 将配置绑定到 struct
		if err := wxViper.Unmarshal(wxConfig); err != nil {
			app.ZapLog.Panic("解析配置到 struct 失败", zap.Error(err))
		}
		// 监听配置文件变化
		wxViper.OnConfigChange(func(changeEvent fsnotify.Event) {
			// 配置文件变化时的回调

			app.ZapLog.Info("配置文件变化", zap.String("file", changeEvent.Name))
			if time.Since(lastChangeTime).Seconds() >= 1 {
				if changeEvent.Op.String() == "WRITE" {
					handleConfigChange()
				}
			}
		})
		wxViper.WatchConfig()
	})
	configMu.RLock()
	defer configMu.RUnlock()
	// 返回一个副本以避免数据竞争
	copy := *wxConfig
	return &copy
}

// GetLastChangeTime 返回配置最后修改时间
func GetLastChangeTime() time.Time {
	configMu.RLock()
	defer configMu.RUnlock()
	return lastChangeTime
}

// RegisterConfigChangeCallback 注册一个回调函数，当配置文件发生变化并成功重新加载后调用
// 回调函数接收新配置作为参数
func RegisterConfigChangeCallback(callback func(*Configuration)) {
	if callback == nil {
		return
	}
	callbackMu.Lock()
	defer callbackMu.Unlock()
	configCallbacks = append(configCallbacks, callback)
}

// getViper 获取 viper 实例
func getViper() *viper.Viper {
	// 先调用 GetConfig() 确保 viper 实例已初始化
	GetConfig()
	return wxViper
}

// handleConfigChange 处理配置变更，确保配置重载的安全性
func handleConfigChange() {
	// 1. 保存旧配置副本用于回滚
	configMu.RLock()
	oldConfig := *wxConfig
	configMu.RUnlock()

	// 2. 创建临时viper读取新配置
	tempViper := viper.New()
	tempViper.SetConfigName(ConfigName)
	tempViper.SetConfigType(ConfigType)
	tempViper.AddConfigPath(ConfigPath)

	if err := tempViper.ReadInConfig(); err != nil {
		app.ZapLog.Error("重新读取配置文件失败", zap.Error(err))
		return
	}

	// 3. 先解析到临时变量验证
	tempConfig := new(Configuration)
	if err := tempViper.Unmarshal(tempConfig); err != nil {
		app.ZapLog.Error("重新解析配置失败", zap.Error(err))
		return
	}

	// 4. 验证配置有效性
	if err := validateConfig(tempConfig); err != nil {
		app.ZapLog.Error("配置验证失败", zap.Error(err))
		return
	}

	// 5. 更新配置（获取写锁）
	configMu.Lock()
	*wxConfig = *tempConfig
	lastChangeTime = time.Now()
	configMu.Unlock()
	app.ZapLog.Info("配置文件重新加载成功")

	// 6. 获取回调函数副本和新配置副本（在锁外执行回调，避免死锁）
	configMu.RLock()
	newConfig := *wxConfig
	configMu.RUnlock()

	callbackMu.Lock()
	callbacks := make([]func(*Configuration), len(configCallbacks))
	copy(callbacks, configCallbacks)
	callbackMu.Unlock()

	// 7. 执行回调函数（不持有 configMu，避免死锁）
	for _, cb := range callbacks {
		if cb != nil {
			// 使用recover保护每个回调
			func() {
				defer func() {
					if r := recover(); r != nil {
						app.ZapLog.Error("配置变更回调panic", zap.Any("panic", r))
						// 回滚配置（需要获取写锁）
						configMu.Lock()
						*wxConfig = oldConfig
						configMu.Unlock()
					}
				}()
				cb(&newConfig)
			}()
		}
	}
}

// validateConfig 验证配置的有效性
func validateConfig(conf *Configuration) error {
	// 验证小程序配置必填字段
	if conf.MiniProgram.AppID != "" {
		if conf.MiniProgram.Secret == "" {
			return fmt.Errorf("小程序Secret不能为空")
		}
	}

	// 验证支付配置必填字段
	if conf.Payment.AppID != "" {
		if conf.Payment.MchID == "" {
			return fmt.Errorf("支付MchID不能为空")
		}
		if conf.Payment.CertPath == "" {
			return fmt.Errorf("支付CertPath不能为空")
		}
		if conf.Payment.KeyPath == "" {
			return fmt.Errorf("支付KeyPath不能为空")
		}
		if conf.Payment.SerialNo == "" {
			return fmt.Errorf("支付SerialNo不能为空")
		}
		if conf.Payment.NotifyURL == "" {
			return fmt.Errorf("支付NotifyURL不能为空")
		}
		if conf.Payment.RefundNotifyURL == "" {
			return fmt.Errorf("支付RefundNotifyURL不能为空")
		}

		// MchApiV3Key 和 Key 二选一必填
		if conf.Payment.MchApiV3Key == "" && conf.Payment.Key == "" {
			return fmt.Errorf("支付MchApiV3Key和Key必须至少填写一个")
		}
	}

	// 验证微信公众账号配置必填字段
	if conf.OfficialAccount.AppID != "" {
		if conf.OfficialAccount.AppSecret == "" {
			return fmt.Errorf("微信公众账号Secret不能为空")
		}
	}

	return nil
}

// SetPaymentConfig 设置支付配置
func SetPaymentConfig(config PaymentConfig) error {
	v := getViper()

	// 设置值并写入配置文件（会触发 handleConfigChange 更新内存配置）
	v.Set("payment.appid", config.AppID)
	v.Set("payment.mchid", config.MchID)
	v.Set("payment.certpath", config.CertPath)
	v.Set("payment.keypath", config.KeyPath)
	v.Set("payment.serialno", config.SerialNo)
	v.Set("payment.certificatekeypath", config.CertificateKeyPath)
	v.Set("payment.wechatpayserial", config.WechatPaySerial)
	v.Set("payment.rsapublickeypath", config.RSAPublicKeyPath)
	v.Set("payment.mchapiv3key", config.MchApiV3Key)
	v.Set("payment.key", config.Key)
	v.Set("payment.responsetype", config.ResponseType)
	v.Set("payment.notifyurl", config.NotifyURL)
	v.Set("payment.refundnotifyurl", config.RefundNotifyURL)
	v.Set("payment.submchid", config.SubMchID)
	v.Set("payment.subappid", config.SubAppID)
	v.Set("payment.httpdebug", config.HttpDebug)
	v.Set("payment.redisaddr", config.RedisAddr)
	v.Set("payment.redispassword", config.RedisPassword)
	v.Set("payment.redisdb", config.RedisDB)

	return v.WriteConfig()
}

// SetMiniProgramConfig 设置小程序配置
func SetMiniProgramConfig(config MiniProgramConfig) error {
	v := getViper()

	// 设置值并写入配置文件（会触发 handleConfigChange 更新内存配置）
	v.Set("miniprogram.appid", config.AppID)
	v.Set("miniprogram.secret", config.Secret)
	v.Set("miniprogram.redisaddr", config.RedisAddr)
	v.Set("miniprogram.messagetoken", config.MessageToken)
	v.Set("miniprogram.messageaeskey", config.MessageAesKey)
	v.Set("miniprogram.virtualpayappkey", config.VirtualPayAppKey)
	v.Set("miniprogram.virtualpayofferid", config.VirtualPayOfferID)
	v.Set("miniprogram.redispassword", config.RedisPassword)
	v.Set("miniprogram.redisdb", config.RedisDB)

	return v.WriteConfig()
}

// SetOfficialAccountConfig 设置微信公众号配置
func SetOfficialAccountConfig(config OfficialAccountConfig) error {
	v := getViper()

	// 设置值并写入配置文件（会触发 handleConfigChange 更新内存配置）
	v.Set("officialaccount.appid", config.AppID)
	v.Set("officialaccount.secret", config.AppSecret)
	v.Set("officialaccount.redisaddr", config.RedisAddr)
	v.Set("officialaccount.redispassword", config.RedisPassword)
	v.Set("officialaccount.redisdb", config.RedisDB)
	v.Set("officialaccount.messagetoken", config.MessageToken)
	v.Set("officialaccount.messageaeskey", config.MessageAesKey)

	return v.WriteConfig()
}
