package event

import (
	"gin-fast/plugins/pluwechat/constant"
	"gin-fast/plugins/pluwechat/models"
	"sync"

	"github.com/asaskevich/EventBus"
)

var instancePayment *PaymentEvent
var onceInstancePayment sync.Once

type PaymentEvent struct {
	EventBus.Bus
}

func GetPaymentEvent() *PaymentEvent {
	onceInstancePayment.Do(func() {
		instancePayment = &PaymentEvent{
			Bus: EventBus.New(),
		}
	})
	return instancePayment
}

// 根据订单号通知支付情况
func (evt *PaymentEvent) SubscribeOrderNumNotify(outTradeNo string, fn func(data *models.PaymentNotify)) func() {
	_ = evt.SubscribeAsync(constant.NotifyPaymentPrefix+outTradeNo, fn, false)
	return func() {
		evt.Unsubscribe(constant.NotifyPaymentPrefix+outTradeNo, fn)
	}
}

func (evt *PaymentEvent) PublishOrderNumNotify(outTradeNo string, data *models.PaymentNotify) {
	evt.Publish(constant.NotifyPaymentPrefix+outTradeNo, data)
}

func (evt *PaymentEvent) HasCallbackOrderNumNotify(outTradeNo string) bool {
	return evt.HasCallback(constant.NotifyPaymentPrefix + outTradeNo)
}

// 根据订单号通知退款情况
func (evt *PaymentEvent) SubscribeRefundNumNotify(outTradeNo string, fn func(data *models.PaymentNotifyRefund)) func() {
	_ = evt.SubscribeAsync(constant.NotifyRefundPrefix+outTradeNo, fn, false)
	return func() {
		evt.Unsubscribe(constant.NotifyRefundPrefix+outTradeNo, fn)
	}
}

func (evt *PaymentEvent) PublishRefundNumNotify(outTradeNo string, data *models.PaymentNotifyRefund) {
	evt.Publish(constant.NotifyRefundPrefix+outTradeNo, data)
}

func (evt *PaymentEvent) HasCallbackRefundNumNotify(outTradeNo string) bool {
	return evt.HasCallback(constant.NotifyRefundPrefix + outTradeNo)
}

// 支付消息通知
func (evt *PaymentEvent) SubscribePayNotify(fn func(data *models.PaymentNotify)) {
	_ = evt.SubscribeAsync("PayNotify", fn, false)
}

func (evt *PaymentEvent) PublishPayNotify(data *models.PaymentNotify) {
	evt.Publish("PayNotify", data)
}

// 退款消息通知
func (evt *PaymentEvent) SubscribeRefundNotify(fn func(data *models.PaymentNotifyRefund)) {
	_ = evt.SubscribeAsync("RefundNotify", fn, false)
}

func (evt *PaymentEvent) PublishRefundNotify(data *models.PaymentNotifyRefund) {
	evt.Publish("RefundNotify", data)
}

// 订单过期通知
func (evt *PaymentEvent) SubscribeExpire(fn func(data *models.PaymentOrder)) {
	_ = evt.SubscribeAsync("OrderExpire", fn, false)
}

func (evt *PaymentEvent) PublishExpire(data *models.PaymentOrder) {
	evt.Publish("OrderExpire", data)
}
