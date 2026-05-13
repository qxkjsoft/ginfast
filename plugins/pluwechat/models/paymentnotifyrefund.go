package models

import (
	"context"
	"encoding/json"
	"gin-fast/app/global/app"

	"time"

	"gorm.io/gorm"
)

// PaymentNotifyRefund 退款通知
type PaymentNotifyRefund struct {
	ID                  uint           `gorm:"column:id;primaryKey;autoIncrement;comment:主键ID" json:"id"`
	CreatedAt           time.Time      `gorm:"column:created_at;autoCreateTime;comment:创建时间" json:"createdAt"`
	UpdatedAt           time.Time      `gorm:"column:updated_at;autoUpdateTime;comment:更新时间" json:"updatedAt"`
	DeletedAt           gorm.DeletedAt `gorm:"column:deleted_at;index;comment:删除时间" json:"-"`
	MchID               string         `gorm:"column:mchid;size:100;default:'';comment:商户订单号" json:"mchId"`
	TransactionID       string         `gorm:"column:transaction_id;size:100;default:'';comment:微信支付交易订单号" json:"transactionId"`
	OutTradeNo          string         `gorm:"column:out_trade_no;size:100;default:'';comment:原支付交易对应的商户订单号" json:"outTradeNo"`
	RefundID            string         `gorm:"column:refund_id;size:100;default:'';comment:微信支付退款号" json:"refundId"`
	OutRefundNo         string         `gorm:"column:out_refund_no;size:100;default:'';comment:商户系统内部的退款单号" json:"outRefundNo"`
	RefundStatus        string         `gorm:"column:refund_status;size:100;default:'';comment:退款状态" json:"refundStatus"`
	SuccessTime         *time.Time     `gorm:"column:success_time;comment:退款成功时间" json:"successTime"`
	UserReceivedAccount string         `gorm:"column:user_received_account;size:255;default:'';comment:取当前退款单的退款入账方" json:"userReceivedAccount"`
	AmountTotal         int            `gorm:"column:amount_total;default:0;comment:订单总金额" json:"amountTotal"`
	AmountRefund        int            `gorm:"column:amount_refund;default:0;comment:退款标价金额" json:"amountRefund"`
	AmountPayerTotal    int            `gorm:"column:amount_payer_total;default:0;comment:现金支付金额" json:"amountPayerTotal"`
	AmountPayerRefund   int            `gorm:"column:amount_payer_refund;default:0;comment:退款给用户的金额" json:"amountPayerRefund"`
	NotifyInsideID      string         `gorm:"column:notify_inside_id;size:100;default:'';comment:通知的唯一ID" json:"notifyInsideId"`
	NotifyCreateTime    *time.Time     `gorm:"column:notify_create_time;comment:通知创建的时间" json:"notifyCreateTime"`
	NotifyEventType     string         `gorm:"column:notify_event_type;size:100;default:'';comment:通知的类型" json:"notifyEventType"`
	NotifySummary       string         `gorm:"column:notify_summary;size:255;default:'';comment:回调摘要" json:"notifySummary"`
}

// TableName 设置表名
func (PaymentNotifyRefund) TableName() string {
	return "plu_wx_payment_notify_refund"
}

// NewPaymentNotifyRefund 创建新的退款通知实例
func NewPaymentNotifyRefund() *PaymentNotifyRefund {
	return &PaymentNotifyRefund{}
}

// IsEmpty 判断退款通知是否为空
func (n *PaymentNotifyRefund) IsEmpty() bool {
	return n == nil || n.ID == 0
}

// 根据NotifyInsideID统计
// CountByInsideID 根据NotifyInsideID统计退款通知记录数
func (n *PaymentNotifyRefund) CountByInsideID(ctx context.Context, insideID string) (int64, error) {
	var count int64
	err := app.DB().WithContext(ctx).Model(&PaymentNotifyRefund{}).
		Where("notify_inside_id = ?", insideID).
		Count(&count).Error
	return count, err
}

// 条件统计
func (n *PaymentNotifyRefund) Count(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(ctx).Scopes(funcs...).Model(&PaymentNotifyRefund{}).Count(&count).Error
	return count, err
}

// 基础CRUD方法
func (n *PaymentNotifyRefund) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Find(n).Error
}

func (n *PaymentNotifyRefund) Create(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Create(n).Error
}

func (n *PaymentNotifyRefund) Update(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Save(n).Error
}

// Delete 软删除退款通知记录
func (n *PaymentNotifyRefund) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(n).Error
}

// 查询方法
func (n *PaymentNotifyRefund) GetByID(ctx context.Context, id uint) error {
	return n.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("id = ?", id)
	})
}

func (n *PaymentNotifyRefund) GetByOutRefundNo(ctx context.Context, outRefundNo string) error {
	return n.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("out_refund_no = ?", outRefundNo)
	})
}

func (n *PaymentNotifyRefund) GetByRefundID(ctx context.Context, refundID string) error {
	return n.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("refund_id = ?", refundID)
	})
}

func (n *PaymentNotifyRefund) GetByOutTradeNo(ctx context.Context, outTradeNo string) error {
	return n.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("out_trade_no = ?", outTradeNo)
	})
}

func (n *PaymentNotifyRefund) GetByNotifyInsideID(ctx context.Context, insideID string) error {
	return n.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("notify_inside_id = ?", insideID)
	})
}

func (n *PaymentNotifyRefund) JsonString() string {
	if n == nil {
		return ""
	}
	jsonStr, _ := json.Marshal(n)
	return string(jsonStr)
}

// copy
func (n *PaymentNotifyRefund) Copy() *PaymentNotifyRefund {
	if n == nil {
		return nil
	}
	data, err := json.Marshal(n)
	if err != nil {
		return nil
	}
	var copy PaymentNotifyRefund
	if err := json.Unmarshal(data, &copy); err != nil {
		return nil
	}
	return &copy
}

// 列表类型
type PaymentNotifyRefundList []*PaymentNotifyRefund

// NewPaymentNotifyRefundList 创建新的退款通知列表实例
func NewPaymentNotifyRefundList() PaymentNotifyRefundList {
	return PaymentNotifyRefundList{}
}

func (list *PaymentNotifyRefundList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

// GetTotal 获取退款通知总数
func (list *PaymentNotifyRefundList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(c).Model(&PaymentNotifyRefund{}).Scopes(query...).Count(&count).Error
	return count, err
}
