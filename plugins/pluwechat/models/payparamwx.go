package models

import (
	"encoding/json"
	"gin-fast/app/models"

	"github.com/ArtisanCloud/PowerLibs/v3/object"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// 创建订单
type WxDemoCreateOrderRequest struct {
	models.Validator
	AmountTotal int    `form:"amountTotal" validate:"required" message:"金额不能为空"`
	Description string `form:"description" validate:"required" message:"订单描述不能为空"`
	Openid      string
}

func (r *WxDemoCreateOrderRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

type WxDemoCreateOrderResponse struct {
	PayConf     *object.StringMap `json:"payConf"`
	OrderNumber string            `json:"orderNumber"`
}

func (r *WxDemoCreateOrderResponse) PayConfString() string {
	if r.PayConf == nil {
		return ""
	}
	b, err := json.Marshal(r.PayConf)
	if err != nil {
		return ""
	}
	return string(b)
}

// 查询订单支付结果
type WxDemoQueryOrderRequest struct {
	models.Validator
	OrderNumber string `form:"orderNumber"  validate:"required" message:"订单号不能为空"`
}

func (r *WxDemoQueryOrderRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

type WxDemoQueryOrderResponse struct {
	NotifyOutTradeNo     string `json:"notifyOutTradeNo"`     // 商户订单号
	NotifyAmountTotal    int    `json:"notifyAmountTotal"`    // 订单总金额(单位为分)
	NotifyTradeState     string `json:"notifyTradeState"`     // 交易状态
	NotifyTradeStateDesc string `json:"notifyTradeStateDesc"` // 交易状态描述
	NotifyTradeType      string `json:"notifyTradeType"`      // 交易类型
	NotifySuccessTime    string `json:"notifySuccessTime"`    // 交易成功时间
}

// 申请退款(订单金额直接原路返回)
type WxDemoApplyRefundRequest struct {
	models.Validator
	//PaymentOrderId uint   `form:"paymentOrderId" validate:"required" message:"支付订单ID不能为空"`
	OutTradeNo string `form:"outTradeNo" validate:"required" message:"商户订单号不能为空"`
}

func (r *WxDemoApplyRefundRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// 查询退款结果
type WxDemoQueryRefundRequest struct {
	models.Validator
	OrderNumber string `form:"orderNumber" validate:"required" message:"订单号不能为空"`
}

func (r *WxDemoQueryRefundRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// 订单列表
type WxDemoOrderListRequest struct {
	models.Validator
	models.BasePaging
	OrderNumber string `form:"orderNumber"`
}

func (r *WxDemoOrderListRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

func (r *WxDemoOrderListRequest) Handle() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		if r.OrderNumber != "" {
			db = db.Where("order_number like ?", "%"+r.OrderNumber+"%")
		}
		return db
	}
}
