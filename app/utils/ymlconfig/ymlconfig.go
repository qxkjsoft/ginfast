package ymlconfig

import (
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

func CreateYamlFactory(path string, fileName ...string) YmlConfigInterf {

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

	if err := yamlConfig.ReadInConfig(); err != nil {
		log.Fatal("ReadInConfig err: " + err.Error())
	}

	return &ymlConfig{
		viper: yamlConfig,
		mu:    new(sync.Mutex),
	}
}

type ymlConfig struct {
	viper *viper.Viper
	mu    *sync.Mutex
}

// ConfigFileChangeListen 监听文件变化
func (y *ymlConfig) ConfigFileChangeListen(fns ...func()) {

	y.viper.OnConfigChange(func(changeEvent fsnotify.Event) {
		if time.Since(lastChangeTime).Seconds() >= 1 {
			if changeEvent.Op.String() == "WRITE" {
				// 做点什么
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
	value := y.viper.Get(keyName)
	return value
}

func (y *ymlConfig) GetString(keyName string) string {
	value := y.viper.GetString(keyName)
	return value
}

func (y *ymlConfig) GetBool(keyName string) bool {
	value := y.viper.GetBool(keyName)
	return value
}

func (y *ymlConfig) GetInt(keyName string) int {
	value := y.viper.GetInt(keyName)
	return value

}

func (y *ymlConfig) GetInt32(keyName string) int32 {
	value := y.viper.GetInt32(keyName)
	return value
}

func (y *ymlConfig) GetInt64(keyName string) int64 {
	value := y.viper.GetInt64(keyName)
	return value
}

func (y *ymlConfig) GetFloat64(keyName string) float64 {
	value := y.viper.GetFloat64(keyName)
	return value

}

func (y *ymlConfig) GetDuration(keyName string) time.Duration {
	value := y.viper.GetDuration(keyName)
	return value

}

func (y *ymlConfig) GetStringSlice(keyName string) []string {
	value := y.viper.GetStringSlice(keyName)
	return value
}
