package app

import (
	"time"
)

// YmlConfigInterf 配置文件接口
// 定义了配置文件操作的标准接口，支持多种数据类型的配置读取和写入
type YmlConfigInterf interface {
	// ConfigFileChangeListen 监听配置文件变化
	ConfigFileChangeListen(fns ...func())

	// Get 获取配置值（任意类型）
	Get(keyName string) interface{}

	// GetString 获取字符串类型配置值
	GetString(keyName string) string

	// GetBool 获取布尔类型配置值
	GetBool(keyName string) bool

	// GetInt 获取整型配置值
	GetInt(keyName string) int

	// GetInt32 获取32位整型配置值
	GetInt32(keyName string) int32

	// GetInt64 获取64位整型配置值
	GetInt64(keyName string) int64

	// GetFloat64 获取64位浮点型配置值
	GetFloat64(keyName string) float64

	// GetDuration 获取时间段类型配置值
	GetDuration(keyName string) time.Duration

	// GetStringSlice 获取字符串切片类型配置值
	GetStringSlice(keyName string) []string

	// GetUintSlice 获取无符号整型切片类型配置值
	GetUintSlice(keyName string) []uint

	// Set 设置配置值（任意类型）
	Set(keyName string, value interface{})

	// SaveConfig 保存配置到文件
	SaveConfig() error
}
