package snowflakehelper

import (
	"fmt"
	"sync"
	"time"

	"github.com/sony/sonyflake"
)

var (
	sf   *sonyflake.Sonyflake
	once sync.Once
)

// initSnowflake 初始化雪花ID生成器
func initSnowflake() {
	once.Do(func() {
		settings := sonyflake.Settings{
			StartTime: time.Date(2020, 1, 1, 0, 0, 0, 0, time.UTC),
			MachineID: func() (uint16, error) {
				// 使用环境变量或配置文件获取机器ID
				// 这里简化处理，实际使用时可以根据需要获取机器IP
				// 例如：从环境变量获取 MACHINE_ID
				// machineID := os.Getenv("MACHINE_ID")
				// if machineID != "" {
				// 	id, err := strconv.ParseUint(machineID, 10, 16)
				// 	if err != nil {
				// 		return 0, err
				// 	}
				// 	return uint16(id), nil
				// }
				// 默认返回1，实际部署时需要根据机器环境配置不同的ID
				return 1, nil
			},
			CheckMachineID: func(uint16) bool {
				return true
			},
		}
		sf = sonyflake.NewSonyflake(settings)
		if sf == nil {
			panic("failed to create sonyflake instance")
		}
	})
}

// GenerateID 生成雪花ID字符串
func GenerateID() (string, error) {
	initSnowflake()
	id, err := sf.NextID()
	if err != nil {
		return "", fmt.Errorf("failed to generate snowflake ID: %w", err)
	}
	return fmt.Sprintf("%d", id), nil
}

// GenerateIDUint64 生成雪花ID uint64
func GenerateIDUint64() (uint64, error) {
	initSnowflake()
	id, err := sf.NextID()
	if err != nil {
		return 0, fmt.Errorf("failed to generate snowflake ID: %w", err)
	}
	return id, nil
}
