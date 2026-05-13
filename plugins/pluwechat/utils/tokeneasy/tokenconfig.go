package tokeneasy

import (
	"gin-fast/app/global/app"
	"gin-fast/app/utils/ymlconfig"
	"sync"
)

var (
	tokenConfig app.YmlConfigInterf
	configOnce  sync.Once
)

// GetTokenConfig 获取token配置实例
func GetTokenConfig() app.YmlConfigInterf {
	configOnce.Do(func() {
		tokenConfig = ymlconfig.CreateYamlFactory("./config/wxconfig", "wxconfigtoken")
		// 监听配置文件变化
		tokenConfig.ConfigFileChangeListen(func() {
			// 配置文件变化时的回调，比如清除模板缓存
		})
	})
	return tokenConfig
}
