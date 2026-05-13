package constant

// 交易状态
const (
	TradeStateSuccess    = "SUCCESS"    // 支付成功
	TradeStateRefund     = "REFUND"     // 转入退款
	TradeStateNotPay     = "NOTPAY"     // 未支付
	TradeStateClosed     = "CLOSED"     // 已关闭
	TradeStateRevoked    = "REVOKED"    // 已撤销（付款码支付）
	TradeStateUserPaying = "USERPAYING" // 用户支付中（付款码支付）
	TradeStatePayError   = "PAYERROR"   // 支付失败(其他原因，如银行返回失败)
)

// 退款状态
const (
	RefundStatusSuccess  = "SUCCESS"  // 退款成功
	RefundStatusAbnormal = "ABNORMAL" // 退款异常
	RefundStatusClosed   = "CLOSED"   // 退款关闭
)

// 微信小程序支付通知及退款通知事件前缀
const (
	NotifyPaymentPrefix = "pluwechat_notify_payment_" // 支付通知事件前缀
	NotifyRefundPrefix  = "pluwechat_notify_refund_"  // 退款通知事件前缀
)

// H5支付通知及退款通知事件前缀
const (
	NotifyPaymentH5Prefix = "pluwechat_notify_payment_h5_" // 支付通知事件前缀
	NotifyRefundH5Prefix  = "pluwechat_notify_refund_h5_"  // 退款通知事件前缀
)
