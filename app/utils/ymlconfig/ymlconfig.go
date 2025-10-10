package ymlconfig

import (
	"gin-fast/app/global/app"

	"github.com/fsnotify/fsnotify"
	"github.com/spf13/viper"

	"log"
	"sync"
	"time"
)

var lastChangeTime time.Time

func init() {
	lastChangeTime = time.Now()
}

func CreateYamlFactory(path string, fileName ...string) app.YmlConfigInterf {

	yamlConfig := viper.New()
	// 配置文件所在目录
	yamlConfig.AddConfigPath(path)
	// 需要读取的文件名,默认为：config
	if len(fileName) == 0 {
		yamlConfig.SetConfigName("config")
	} else {
		yamlConfig.SetConfigName(fileName[0])
	}
	//设置配置文件类型(后缀)为 yml
	yamlConfig.SetConfigType("yml")

	// 读取配置文件
	if err := yamlConfig.ReadInConfig(); err != nil {
		log.Fatal("ReadInConfig err: " + err.Error())
	}

	return &ymlConfig{
		viper: yamlConfig,
		mu:    new(sync.RWMutex),
	}
}

type ymlConfig struct {
	viper *viper.Viper
	mu    *sync.RWMutex
}

// ConfigFileChangeListen 监听文件变化
func (y *ymlConfig) ConfigFileChangeListen(fns ...func()) {

	y.viper.OnConfigChange(func(changeEvent fsnotify.Event) {
		if time.Since(lastChangeTime).Seconds() >= 1 {
			if changeEvent.Op.String() == "WRITE" {

				// 重新读取配置文件（使用写锁保护）
				y.mu.Lock()
				if err := y.viper.ReadInConfig(); err != nil {
					log.Printf("重新读取配置文件失败: %v", err)
				} else {
					log.Println("配置文件重新加载成功")
				}
				y.mu.Unlock()
				// 执行自定义回调函数
				for _, f := range fns {
					f()
				}
				lastChangeTime = time.Now()
			}
		}
	})
	y.viper.WatchConfig()
}

func (y *ymlConfig) Get(keyName string) interface{} {
	y.mu.RLock()
	defer y.mu.RUnlock()
	value := y.viper.Get(keyName)
	return value
}

func (y *ymlConfig) GetString(keyName string) string {
	y.mu.RLock()
	defer y.mu.RUnlock()
	value := y.viper.GetString(keyName)
	return value
}

func (y *ymlConfig) GetBool(keyName string) bool {
	y.mu.RLock()
	defer y.mu.RUnlock()
	value := y.viper.GetBool(keyName)
	return value
}

func (y *ymlConfig) GetInt(keyName string) int {
	y.mu.RLock()
	defer y.mu.RUnlock()
	value := y.viper.GetInt(keyName)
	return value

}

func (y *ymlConfig) GetInt32(keyName string) int32 {
	y.mu.RLock()
	defer y.mu.RUnlock()
	value := y.viper.GetInt32(keyName)
	return value
}

func (y *ymlConfig) GetInt64(keyName string) int64 {
	y.mu.RLock()
	defer y.mu.RUnlock()
	value := y.viper.GetInt64(keyName)
	return value
}

func (y *ymlConfig) GetFloat64(keyName string) float64 {
	y.mu.RLock()
	defer y.mu.RUnlock()
	value := y.viper.GetFloat64(keyName)
	return value

}

func (y *ymlConfig) GetDuration(keyName string) time.Duration {
	y.mu.RLock()
	defer y.mu.RUnlock()
	value := y.viper.GetDuration(keyName)
	return value

}

func (y *ymlConfig) GetStringSlice(keyName string) []string {
	y.mu.RLock()
	defer y.mu.RUnlock()
	value := y.viper.GetStringSlice(keyName)
	return value
}

// Set 设置配置值
func (y *ymlConfig) Set(keyName string, value interface{}) {
	y.mu.Lock()
	defer y.mu.Unlock()
	y.viper.Set(keyName, value)
}

// SaveConfig 保存配置到文件
func (y *ymlConfig) SaveConfig() error {
	y.mu.Lock()
	defer y.mu.Unlock()
	// 保存当前的配置值
	currentSettings := y.viper.AllSettings()

	// 重新读取配置文件，确保所有原始配置项都被加载
	if err := y.viper.ReadInConfig(); err != nil {
		return err
	}

	// 将修改后的配置项重新设置到 viper 中
	for key, value := range currentSettings {
		y.viper.Set(key, value)
	}

	// 写入配置
	err := y.viper.WriteConfig()
	if err != nil {
		return err
	}
	return nil
}
