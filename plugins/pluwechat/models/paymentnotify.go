package models

import (
	"context"
	"encoding/json"
	"gin-fast/app/global/app"

	"time"

	"gorm.io/gorm"
)

// PaymentNotify 订单支付通知
type PaymentNotify struct {
	ID                   uint           `gorm:"column:id;primaryKey;autoIncrement;comment:主键ID" json:"id"`
	CreatedAt            time.Time      `gorm:"column:created_at;autoCreateTime;comment:创建时间" json:"createdAt"`
	UpdatedAt            time.Time      `gorm:"column:updated_at;autoUpdateTime;comment:更新时间" json:"updatedAt"`
	DeletedAt            gorm.DeletedAt `gorm:"column:deleted_at;index;comment:删除时间" json:"-"`
	NotifyOutTradeNo     string         `gorm:"column:notify_out_trade_no;size:100;default:'';comment:商户订单号" json:"notifyOutTradeNo"`
	NotifyAmountTotal    int            `gorm:"column:notify_amount_total;default:0;comment:订单总金额，单位为分" json:"notifyAmountTotal"`
	NotifyPayerOpenid    string         `gorm:"column:notify_payer_openid;size:100;default:'';comment:支付者" json:"notifyPayerOpenid"`
	NotifyInsideID       string         `gorm:"column:notify_inside_id;size:100;default:'';comment:通知的唯一ID" json:"notifyInsideId"`
	NotifyCreateTime     string         `gorm:"column:notify_create_time;size:100;default:'';comment:通知创建的时间" json:"notifyCreateTime"`
	NotifyEventType      string         `gorm:"column:notify_event_type;size:100;default:'';comment:通知的类型" json:"notifyEventType"`
	NotifySummary        string         `gorm:"column:notify_summary;size:255;default:'';comment:回调摘要" json:"notifySummary"`
	NotifyTransactionID  string         `gorm:"column:notify_transaction_id;size:100;default:'';comment:微信支付系统生成的订单号" json:"notifyTransactionId"`
	NotifyTradeType      string         `gorm:"column:notify_trade_type;size:100;default:'';comment:交易类型" json:"notifyTradeType"`
	NotifyTradeState     string         `gorm:"column:notify_trade_state;size:100;default:'';comment:交易状态" json:"notifyTradeState"`
	NotifyTradeStateDesc string         `gorm:"column:notify_trade_state_desc;size:255;default:'';comment:交易状态描述" json:"notifyTradeStateDesc"`
	NotifyBankType       string         `gorm:"column:notify_bank_type;size:100;comment:银行类型" json:"notifyBankType"`
	NotifySuccessTime    string         `gorm:"column:notify_success_time;size:100;default:'';comment:支付完成时间" json:"notifySuccessTime"`
}

// TableName 设置表名
func (PaymentNotify) TableName() string {
	return "plu_wx_payment_notify"
}

// NewPaymentNotify 创建新的支付通知实例
func NewPaymentNotify() *PaymentNotify {
	return &PaymentNotify{}
}

// IsEmpty 判断支付通知是否为空
func (n *PaymentNotify) IsEmpty() bool {
	return n == nil || n.ID == 0
}

// 根据NotifyInsideID统计
// CountByInsideID 根据NotifyInsideID统计支付通知记录数
func (n *PaymentNotify) CountByInsideID(ctx context.Context, insideID string) (int64, error) {
	var count int64
	err := app.DB().WithContext(ctx).Model(&PaymentNotify{}).
		Where("notify_inside_id = ?", insideID).
		Count(&count).Error
	return count, err
}

// 条件统计
func (n *PaymentNotify) Count(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(ctx).Scopes(funcs...).Model(&PaymentNotify{}).Count(&count).Error
	return count, err
}

// 基础CRUD方法
func (n *PaymentNotify) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Find(n).Error
}

func (n *PaymentNotify) Create(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Create(n).Error
}

func (n *PaymentNotify) Update(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Save(n).Error
}

// Delete 软删除支付通知记录
func (n *PaymentNotify) Delete(c context.Context) error {
	return app.DB().WithContext(c).Delete(n).Error
}

// 查询方法
func (n *PaymentNotify) GetByID(ctx context.Context, id uint) error {
	return n.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("id = ?", id)
	})
}

func (n *PaymentNotify) GetByOutTradeNo(ctx context.Context, outTradeNo string) error {
	return n.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("notify_out_trade_no = ?", outTradeNo)
	})
}

func (n *PaymentNotify) GetByTransactionID(ctx context.Context, transactionID string) error {
	return n.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("notify_transaction_id = ?", transactionID)
	})
}

func (n *PaymentNotify) GetByInsideID(ctx context.Context, insideID string) error {
	return n.Find(ctx, func(db *gorm.DB) *gorm.DB {
		return db.Where("notify_inside_id = ?", insideID)
	})
}

func (n *PaymentNotify) JsonString() string {
	if n == nil {
		return ""
	}
	jsonStr, _ := json.Marshal(n)
	return string(jsonStr)
}

func (n *PaymentNotify) Copy() *PaymentNotify {
	if n == nil {
		return nil
	}
	data, err := json.Marshal(n)
	if err != nil {
		return nil
	}
	var copy PaymentNotify
	if err := json.Unmarshal(data, &copy); err != nil {
		return nil
	}
	return &copy
}

// 列表类型
type PaymentNotifyList []*PaymentNotify

// NewPaymentNotifyList 创建新的支付通知列表实例
func NewPaymentNotifyList() PaymentNotifyList {
	return PaymentNotifyList{}
}

func (list *PaymentNotifyList) Find(ctx context.Context, funcs ...func(*gorm.DB) *gorm.DB) error {
	return app.DB().WithContext(ctx).Scopes(funcs...).Find(list).Error
}

// GetTotal 获取支付通知总数
func (list *PaymentNotifyList) GetTotal(c context.Context, query ...func(*gorm.DB) *gorm.DB) (int64, error) {
	var count int64
	err := app.DB().WithContext(c).Model(&PaymentNotify{}).Scopes(query...).Count(&count).Error
	return count, err
}
