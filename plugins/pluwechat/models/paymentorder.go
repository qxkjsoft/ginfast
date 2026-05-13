package models

import (
	"context"
	"gin-fast/app/global/app"
	"gin-fast/plugins/pluwechat/constant"

	"time"

	"gorm.io/gorm"
)

// PaymentOrder 微信支付订单
type PaymentOrder struct {
	ID                        uint           `gorm:"column:id;primaryKey;autoIncrement;comment:主键ID" json:"id"`
	CreatedAt                 time.Time      `gorm:"column:created_at;autoCreateTime;comment:创建时间" json:"createdAt"`
	UpdatedAt                 time.Time      `gorm:"column:updated_at;autoUpdateTime;comment:更新时间" json:"updatedAt"`
	DeletedAt                 gorm.DeletedAt `gorm:"column:deleted_at;index;comment:删除时间" json:"-"`
	AppID                     string         `gorm:"column:appid;size:100;comment:appid" json:"appId"`
	MchID                     string         `gorm:"column:mchid;size:100;default:'';comment:商户号" json:"mchId"`
	Description               string         `gorm:"column:description;size:255;comment:商品描述" json:"description"`
	OutTradeNo                string         `gorm:"column:out_trade_no;size:100;default:'';comment:商户订单号" json:"outTradeNo"`
	TimeExpire                *time.Time     `gorm:"column:time_expire;comment:订单失效时间" json:"timeExpire"`
	AmountTotal               int            `gorm:"column:amount_total;default:0;comment:订单总金额，单位为分" json:"amountTotal"`
	PayerOpenID               string         `gorm:"column:payer_openid;size:100;default:'';comment:支付者" json:"payerOpenId"`
	NotifyTransactionID       string         `gorm:"column:notify_transaction_id;size:100;default:'';comment:微信支付系统生成的订单号" json:"notifyTransactionId"`
	NotifyTradeType           string         `gorm:"column:notify_trade_type;size:100;default:'';comment:交易类型" json:"notifyTradeType"`
	NotifyTradeState          string         `gorm:"column:notify_trade_state;size:100;default:'';comment:交易状态" json:"notifyTradeState"`
	NotifySuccessTime         *time.Time     `gorm:"column:notify_success_time;comment:支付完成时间" json:"notifySuccessTime"`
	NotifyTradeStateDesc      string         `gorm:"column:notify_trade_state_desc;size:255;comment:交易状态描述" json:"notifyTradeStateDesc"`
	PaymentNotifyID           uint           `gorm:"column:payment_notify_id;default:0;comment:关联的通知ID" json:"paymentNotifyId"`
	PayConf                   string         `gorm:"column:pay_conf;type:text;comment:支付配置" json:"payConf"`
	UserRemark                string         `gorm:"column:user_remark;size:500;comment:用户备注" json:"userRemark"`
	UserID                    uint           `gorm:"column:user_id;default:0;comment:微信用户ID" json:"userId"`
	IsSysClose                int            `gorm:"column:is_sys_close;default:0;comment:系统关闭订单 0-否 1-是" json:"isSysClose"`
	IsRefund                  int            `gorm:"column:is_refund;default:0;comment:用户申请退款" json:"isRefund"`
	RefundReason              string         `gorm:"column:refund_reason;size:255;default:'';comment:退款理由" json:"refundReason"`
	RefundAudit               int            `gorm:"column:refund_audit;default:0;comment:退款审核状态 0-待审 1-通过 2-拒绝" json:"refundAudit"`
	RefundRemark              string         `gorm:"column:refund_remark;size:255;comment:审核备注" json:"refundRemark"`
	RefundNotifyID            uint           `gorm:"column:refund_notify_id;default:0;comment:关联的退款通知ID" json:"refundNotifyId"`
	RefundOutRefundNo         string         `gorm:"column:refund_out_refund_no;size:100;default:'';comment:商户退款单号" json:"refundOutRefundNo"`
	RefundRefundID            string         `gorm:"column:refund_refund_id;size:100;comment:微信支付退款单号" json:"refundRefundId"`
	RefundStatus              string         `gorm:"column:refund_status;size:100;comment:退款状态" json:"refundStatus"`
	RefundSuccessTime         *time.Time     `gorm:"column:refund_success_time;comment:退款成功时间" json:"refundSuccessTime"`
	RefundPayerRefund         int64          `gorm:"column:refund_payer_refund;default:0;comment:实际退款给用户的金额(分)" json:"refundPayerRefund"`
	RefundUserReceivedAccount string         `gorm:"column:refund_user_received_account;size:255;comment:退款单的退款入账方" json:"refundUserReceivedAccount"`
}

// TableName 设置表名
func (PaymentOrder) TableName() string {
	return "plu_wx_payment_order"
}

// NewPaymentOrder 创建新的订单实例
func NewPaymentOrder() *PaymentOrder {
	return &PaymentOrder{}
}

// IsEmpty 判断订单是否为空
func (o *PaymentOrder) IsEmpty() bool {
	return o == nil || o.ID == 0
}

// 是否退款成功
func (o *PaymentOrder) IsRefundSuccess() bool {
	return o.RefundStatus == constant.RefundStatusSuccess
}

// 基础CRUD方法
func (o *PaymentOrder) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Find(o).Error
}

func (o *PaymentOrder) Create(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Create(o).Error
}

func (o *PaymentOrder) Update(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Save(o).Error
}

// Delete 软删除订单记录
func (o *PaymentOrder) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(o).Error
}

// 查询方法
func (o *PaymentOrder) GetByID(ctx context.Context, id uint) error {
	return o.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("id = ?", id)
	})
}

func (o *PaymentOrder) GetByOutTradeNo(ctx context.Context, outTradeNo string) error {
	return o.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("out_trade_no = ?", outTradeNo)
	})
}

func (o *PaymentOrder) GetByNotifyTransactionID(ctx context.Context, transactionID string) error {
	return o.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("notify_transaction_id = ?", transactionID)
	})
}

// 列表类型
type PaymentOrderList []*PaymentOrder

// NewPaymentOrderList 创建新的订单列表实例
func NewPaymentOrderList() PaymentOrderList {
	return PaymentOrderList{}
}

func (list *PaymentOrderList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

// GetTotal 获取订单总数
func (list *PaymentOrderList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(c).Model(&PaymentOrder{}).Scopes(query...).Count(&count).Error
	return count, err
}
