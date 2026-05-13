package models

import (
	"encoding/json"
	"gin-fast/app/models"

	"github.com/ArtisanCloud/PowerLibs/v3/object"
	"github.com/gin-gonic/gin"
)

// WxH5CallbackRequest 网页授权回调请求参数
type WxH5CallbackRequest struct {
	models.Validator
	Code   string `form:"code" validate:"required" message:"code不能为空" json:"code"`
	Scopes string `form:"scopes" validate:"required" message:"scopes不能为空" json:"scopes"` // 授权范围 snsapi_base 或 snsapi_userinfo
}

func (r *WxH5CallbackRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// WxH5CallbackResponse 网页授权回调响应
type WxH5CallbackResponse struct {
	Token              string               `json:"token"`
	AccessTokenExpires int64                `json:"accessTokenExpires"`
	User               WxMemberInfoResponse `json:"user"`
}

// 创建订单
type WxH5DemoCreateOrderRequest struct {
	models.Validator
	AmountTotal int    `form:"amountTotal" validate:"required" message:"金额不能为空"`
	Description string `form:"description" validate:"required" message:"订单描述不能为空"`
	Openid      string
}

func (r *WxH5DemoCreateOrderRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

type WxH5DemoCreateOrderResponse struct {
	PayConf     *object.StringMap `json:"payConf"`
	OrderNumber string            `json:"orderNumber"`
}

func (r *WxH5DemoCreateOrderResponse) PayConfString() string {
	if r.PayConf == nil {
		return ""
	}
	b, err := json.Marshal(r.PayConf)
	if err != nil {
		return ""
	}
	return string(b)
}

// 查询订单支付结果测试
// 查询订单支付结果
type WxH5DemoQueryOrderRequest struct {
	models.Validator
	OrderNumber string `form:"orderNumber"  validate:"required" message:"订单号不能为空"`
}

func (r *WxH5DemoQueryOrderRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

type WxH5DemoQueryOrderResponse struct {
	NotifyOutTradeNo     string `json:"notifyOutTradeNo"`     // 商户订单号
	NotifyAmountTotal    int    `json:"notifyAmountTotal"`    // 订单总金额(单位为分)
	NotifyTradeState     string `json:"notifyTradeState"`     // 交易状态
	NotifyTradeStateDesc string `json:"notifyTradeStateDesc"` // 交易状态描述
	NotifyTradeType      string `json:"notifyTradeType"`      // 交易类型
	NotifySuccessTime    string `json:"notifySuccessTime"`    // 交易成功时间
}

// 申请退款(订单金额直接原路返回)
type WxH5DemoApplyRefundRequest struct {
	models.Validator
	OutTradeNo string `form:"outTradeNo" validate:"required" message:"商户订单号不能为空"`
}

func (r *WxH5DemoApplyRefundRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}

// 查询退款结果
type WxH5DemoQueryRefundRequest struct {
	models.Validator
	OrderNumber string `form:"orderNumber" validate:"required" message:"订单号不能为空"`
}

func (r *WxH5DemoQueryRefundRequest) Validate(c *gin.Context) error {
	return r.Validator.Check(c, r)
}
