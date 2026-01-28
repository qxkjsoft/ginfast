package captchahelper

import (
	"gin-fast/app/global/app"
	"sync"

	"github.com/mojocn/base64Captcha"
)

type CaptchaHelper struct {
	driver *base64Captcha.Captcha
	store  base64Captcha.Store
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
		Height:          32,                                     // 验证码高度
		Width:           150,                                    // 验证码宽度
		NoiseCount:      20,                                     // 验证码干扰点数量
		ShowLineOptions: 10,                                     // 验证码干扰线数量
		Length:          app.ConfigYml.GetInt("captcha.length"), // 验证码字符长度
		Source:          "abcdefghjkmnpqrstuvwxyz23456789",      // 验证码字符源
		Fonts:           []string{"chromohv.ttf"},               // 验证码字体
	}
	return &CaptchaHelper{
		driver: base64Captcha.NewCaptcha(ds.ConvertFonts(), store),
		store:  store,
	}
}

// GetVerifyImgString 获取验证码图片字符串
func (ch *CaptchaHelper) GetVerifyImgString() (idKeyC string, base64stringC string, err error) {
	idKeyC, base64stringC, _, err = ch.driver.Generate()
	return
}

// VerifyVerifyImgString 验证验证码图片字符串
func (ch *CaptchaHelper) VerifyVerifyImgString(idKeyC string, verifyValueC string) bool {
	return ch.store.Verify(idKeyC, verifyValueC, true)
}
