package initialize

import (
	"gin-fast/plugins/pluwechat/event"
	"gin-fast/plugins/pluwechat/models"
)

func init() {
	// 处理订单过期逻辑
	event.GetPaymentEvent().SubscribeExpire(func(order *models.PaymentOrder) {

	})
	// 处理退款消息通知
	event.GetPaymentEvent().SubscribeRefundNotify(func(refund *models.PaymentNotifyRefund) {

	})

	// 处理支付消息通知
	event.GetPaymentEvent().SubscribePayNotify(func(notify *models.PaymentNotify) {

	})
}
