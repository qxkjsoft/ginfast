package captchahelper

import (
	"gin-fast/app/utils/sysconfighelper"
	"sync"

	"github.com/mojocn/base64Captcha"
)

type CaptchaHelper struct {
	mu           sync.Mutex
	driver       *base64Captcha.Captcha
	driverString *base64Captcha.DriverString // 持有样式指针，Length 每次生成前按 sys_config 刷新
	store        base64Captcha.Store
}

var (
	captchaHelperInstance *CaptchaHelper
	captchaHelperOnce     sync.Once
)

// GetCaptchaHelper 获取CaptchaHelper单例
func GetCaptchaHelper() *CaptchaHelper {
	captchaHelperOnce.Do(func() {
		captchaHelperInstance = NewCaptchaHelper()
	})
	return captchaHelperInstance
}

// NewCaptchaHelper 创建CaptchaHelper实例
func NewCaptchaHelper() *CaptchaHelper {
	store := base64Captcha.DefaultMemStore
	ds := &base64Captcha.DriverString{
		Height:          32,                                // 验证码高度
		Width:           150,                               // 验证码宽度
		NoiseCount:      20,                                // 验证码干扰点数量
		ShowLineOptions: 10,                                // 验证码干扰线数量
		Length:          4,                                 // 验证码字符长度（实际以每次生成时读取的 sys_config 为准）
		Source:          "abcdefghjkmnpqrstuvwxyz23456789", // 验证码字符源
		Fonts:           []string{"chromohv.ttf"},          // 验证码字体
	}
	// ConvertFonts 返回同一指针（原地加载字体），driver 与 driverString 共享样式
	driverString := ds.ConvertFonts()
	return &CaptchaHelper{
		driver:       base64Captcha.NewCaptcha(driverString, store),
		driverString: driverString,
		store:        store,
	}
}

// GetVerifyImgString 获取验证码图片字符串
func (ch *CaptchaHelper) GetVerifyImgString() (idKeyC string, base64stringC string, err error) {
	// 长度每次生成时读取（存于 sys_config 表），后台修改后无需重启即生效；
	// 加锁串行化 Length 写入与 DrawCaptcha 内部读取，避免并发生成时的数据竞争
	ch.mu.Lock()
	defer ch.mu.Unlock()
	ch.driverString.Length = sysconfighelper.Instance().GetInt(sysconfighelper.CodeCaptchaLength)
	idKeyC, base64stringC, _, err = ch.driver.Generate()
	return
}

// VerifyVerifyImgString 验证验证码图片字符串
func (ch *CaptchaHelper) VerifyVerifyImgString(idKeyC string, verifyValueC string) bool {
	return ch.store.Verify(idKeyC, verifyValueC, true)
}
