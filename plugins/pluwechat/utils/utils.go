package utils

import (
	"fmt"
	"time"

	"github.com/bwmarrin/snowflake"
)

var (
	// 雪花算法节点
	node *snowflake.Node
)

func init() {
	// 初始化雪花算法节点，机器ID为1
	// 可根据实际情况修改机器ID
	var err error
	node, err = snowflake.NewNode(1)
	if err != nil {
		panic(err)
	}
}

// GeneratePaymentOrderNo 生成支付订单号
// 使用 bwmarrin/snowflake 库生成全局唯一的纯数字订单号
// 格式: 19位数字
// 例如: 1234567890123456789
// 保证绝对唯一，且长度控制在32位以内
func GeneratePaymentOrderNo() string {
	id := node.Generate()
	return id.String()
}

// 生产退款单号
// GenerateRefundOrderNo 生成退款订单号
func GenerateRefundOrderNo() string {
	return fmt.Sprintf("%s_%s", "RE", GeneratePaymentOrderNo())
}

// MaskPhone 手机号脱敏，保留前3位和后4位，中间用星号代替
// 例如: 13812345678 -> 138****5678
func MaskPhone(phone string) string {
	if len(phone) < 11 {
		return phone
	}
	return phone[:3] + "****" + phone[7:]
}

// ParseWxTime 解析微信时间字符串为 *time.Time
// 微信返回的时间格式为 RFC3339，例如: "2024-01-01T12:00:00+08:00"
// 如果解析失败或字符串为空，返回 nil
func ParseWxTime(timeStr string) *time.Time {
	if timeStr == "" {
		return nil
	}
	t, err := time.Parse(time.RFC3339, timeStr)
	if err != nil {
		return nil
	}
	return &t
}
