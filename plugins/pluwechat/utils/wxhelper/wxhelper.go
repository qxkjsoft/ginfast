package wxhelper

import (
	"fmt"
	"gin-fast/app/global/app"
	"sync/atomic"

	"github.com/ArtisanCloud/PowerLibs/v3/logger/drivers"
	"github.com/ArtisanCloud/PowerWeChat/v3/src/kernel"
	"github.com/ArtisanCloud/PowerWeChat/v3/src/kernel/response"
	"github.com/ArtisanCloud/PowerWeChat/v3/src/miniProgram"
	"github.com/ArtisanCloud/PowerWeChat/v3/src/officialAccount"
	"github.com/ArtisanCloud/PowerWeChat/v3/src/payment"
	"go.uber.org/zap"
)

func init() {
	// 注册配置变更回调，当配置重新加载后重置实例
	RegisterConfigChangeCallback(resetInstance)
	// 初始化实例
	conf := GetConfig()
	mp, err := NewMiniProgramApp(conf)
	if err != nil {
		app.ZapLog.Error("微信相关实例初始化失败", zap.Error(err))
		return
	}
	instance.Store(mp)

}

var (
	instance atomic.Value // 存储 *MiniProgramApp
)

// GetMiniProgramApp 获取小程序单例实例
// 使用 atomic.Value 实现无锁读取，实例在 init 中初始化，配置变更通过回调更新
func GetMiniProgramApp() (*MiniProgramApp, error) {
	if v := instance.Load(); v != nil {
		return v.(*MiniProgramApp), nil
	}
	return nil, fmt.Errorf("小程序实例未初始化")
}

// GetMiniProgram 获取小程序实例
func GetMiniProgram() (*miniProgram.MiniProgram, error) {
	miniProgramApp, err := GetMiniProgramApp()
	if err != nil {
		return nil, err
	}
	return miniProgramApp.GetMiniProgram()
}

// GetPayment 获取支付实例
func GetPayment() (*payment.Payment, error) {
	miniProgramApp, err := GetMiniProgramApp()
	if err != nil {
		return nil, err
	}
	return miniProgramApp.GetPayment()
}

// GetOfficialAccount 获取公众号单例实例
// 使用 atomic.Value 实现无锁读取，实例在 init 中初始化，配置变更通过回调更新
func GetOfficialAccount() (*officialAccount.OfficialAccount, error) {
	miniProgramApp, err := GetMiniProgramApp()
	if err != nil {
		return nil, err
	}
	return miniProgramApp.GetOfficialAccount()
}

type MiniProgramApp struct {
	miniProgram     *miniProgram.MiniProgram         // 小程序实例
	payment         *payment.Payment                 // 支付实例
	officialAccount *officialAccount.OfficialAccount // 公众号实例
}

// GetMiniProgram 返回底层的小程序实例
func (mp *MiniProgramApp) GetMiniProgram() (*miniProgram.MiniProgram, error) {
	if mp.miniProgram == nil {
		return nil, fmt.Errorf("小程序实例未初始化")
	}
	return mp.miniProgram, nil
}

// GetPayment 返回底层的支付实例
func (mp *MiniProgramApp) GetPayment() (*payment.Payment, error) {
	if mp.payment == nil {
		return nil, fmt.Errorf("支付实例未初始化")
	}
	return mp.payment, nil
}

// GetOfficialAccount 返回底层的公众号实例
func (mp *MiniProgramApp) GetOfficialAccount() (*officialAccount.OfficialAccount, error) {
	if mp.officialAccount == nil {
		return nil, fmt.Errorf("公众号实例未初始化")
	}
	return mp.officialAccount, nil
}

// NewMiniProgramApp 创建微信相关实例
func NewMiniProgramApp(conf *Configuration) (*MiniProgramApp, error) {
	// 加载小程序实例
	mp, err1 := loadMiniProgram(conf)

	// 加载支付实例
	payment, err2 := loadPayment(conf)

	// 加载公众号实例
	officialAccount, err3 := loadOfficialAccount(conf)
	if err1 != nil && err2 != nil && err3 != nil {
		return nil, fmt.Errorf("创建小程序实例失败: %w, 创建支付实例失败: %w, 创建公众号实例失败: %w", err1, err2, err3)
	}
	// 至少有一个实例成功
	return &MiniProgramApp{
		miniProgram:     mp,
		payment:         payment,
		officialAccount: officialAccount,
	}, nil
}

// loadMiniProgram 根据配置创建小程序实例
func loadMiniProgram(conf *Configuration) (*miniProgram.MiniProgram, error) {
	var cache kernel.CacheInterface
	if conf.MiniProgram.RedisAddr != "" {
		cache = kernel.NewRedisClient(&kernel.UniversalOptions{
			Addrs:    []string{conf.MiniProgram.RedisAddr},
			Password: conf.MiniProgram.RedisPassword,
			DB:       conf.MiniProgram.RedisDB,
		})
	}
	app, err := miniProgram.NewMiniProgram(&miniProgram.UserConfig{
		AppID:        conf.MiniProgram.AppID,         // 小程序、公众号或者企业微信的appid
		Secret:       conf.MiniProgram.Secret,        // 小程序、公众号或者企业微信的appsecret
		ResponseType: response.TYPE_MAP,              // 响应类型，默认是 map 类型
		Token:        conf.MiniProgram.MessageToken,  // 消息加解密token
		AESKey:       conf.MiniProgram.MessageAesKey, // 消息加解密key

		AppKey:  conf.MiniProgram.VirtualPayAppKey,  // 虚拟支付appkey
		OfferID: conf.MiniProgram.VirtualPayOfferID, // 虚拟支付offerid
		Http:    miniProgram.Http{},
		Log: miniProgram.Log{
			Driver: &drivers.SimpleLogger{},       // 日志驱动，默认是 simple 驱动
			Level:  "debug",                       // 日志级别，默认是 debug 级别
			File:   "./resource/wechat/info.log",  // 日志文件路径，
			Error:  "./resource/wechat/error.log", // 错误日志文件路径
			Stdout: false,                         // 是否打印在终端
		},
		Cache:     cache,
		HttpDebug: true,
		Debug:     false,
	})

	return app, err
}

// loadPayment 根据配置创建支付实例
func loadPayment(conf *Configuration) (*payment.Payment, error) {
	var cache kernel.CacheInterface
	if conf.MiniProgram.RedisAddr != "" {
		cache = kernel.NewRedisClient(&kernel.UniversalOptions{
			Addrs:    []string{conf.MiniProgram.RedisAddr},
			Password: conf.MiniProgram.RedisPassword,
			DB:       conf.MiniProgram.RedisDB,
		})
	}

	app, err := payment.NewPayment(&payment.UserConfig{
		AppID:              conf.Payment.AppID,
		MchID:              conf.Payment.MchID,
		MchApiV3Key:        conf.Payment.MchApiV3Key,
		Key:                conf.Payment.Key,
		CertPath:           conf.Payment.CertPath,
		KeyPath:            conf.Payment.KeyPath,
		SerialNo:           conf.Payment.SerialNo,
		CertificateKeyPath: conf.Payment.CertificateKeyPath,
		WechatPaySerial:    conf.Payment.WechatPaySerial,
		RSAPublicKeyPath:   conf.Payment.RSAPublicKeyPath,
		NotifyURL:          conf.Payment.NotifyURL,
		SubMchID:           conf.Payment.SubMchID,
		SubAppID:           conf.Payment.SubAppID,
		ResponseType:       response.TYPE_MAP,

		Http: payment.Http{
			Timeout: 30.0,
			BaseURI: "https://api.mch.weixin.qq.com/sandboxnew",
		},
		Log: payment.Log{
			Driver: &drivers.SimpleLogger{},
			Level:  "debug",
			File:   "./resource/wechat/pay_info.log",
			Error:  "./resource/wechat/pay_error.log",
			Stdout: false,
		},
		Cache:     cache,
		HttpDebug: true,
		Debug:     false,
	})
	return app, err
}

// 创建微信公众账号实例
func loadOfficialAccount(conf *Configuration) (*officialAccount.OfficialAccount, error) {
	cache := kernel.NewRedisClient(&kernel.UniversalOptions{
		Addrs:    []string{conf.OfficialAccount.RedisAddr},
		Password: conf.OfficialAccount.RedisPassword,
		DB:       conf.OfficialAccount.RedisDB,
	})

	app, err := officialAccount.NewOfficialAccount(&officialAccount.UserConfig{
		AppID:  conf.OfficialAccount.AppID,
		Secret: conf.OfficialAccount.AppSecret,
		Log: officialAccount.Log{
			Level: "debug",
			// 可以重定向到你的目录下，如果未设置File和Error，默认会在当前目录下的wechat文件夹下生成日志
			File:   "/resource/wechat/official_account/info.log",
			Error:  "/resource/wechat/official_account/error.log",
			Stdout: false, //  是否打印在终端
		},
		Cache:     cache,
		HttpDebug: true,
		Debug:     false,
	})
	return app, err
}

// resetInstance 重置实例，用于配置变更后重新初始化
func resetInstance(conf *Configuration) {
	// 先创建新实例，验证成功后再替换
	newMp, err := NewMiniProgramApp(conf)
	if err != nil {
		app.ZapLog.Error("重新加载配置创建微信实例失败，保持使用旧实例", zap.Error(err))
		// 不替换实例，保持使用旧实例
		return
	}

	// 替换实例
	oldInstance := instance.Load()
	instance.Store(newMp)

	// 清理旧实例资源（如果有需要）
	if oldInstance != nil {
		// 如果MiniProgramApp有Close方法，可以在这里调用
		// oldInstance.(*MiniProgramApp).Close()
	}

	app.ZapLog.Info("微信实例重置成功")
}
