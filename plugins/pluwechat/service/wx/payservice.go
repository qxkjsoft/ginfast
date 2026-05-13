package wx

import (
	"context"
	"encoding/json"
	"errors"
	"gin-fast/app/global/app"
	"gin-fast/plugins/pluwechat/constant"
	"gin-fast/plugins/pluwechat/event"
	"gin-fast/plugins/pluwechat/models"
	"gin-fast/plugins/pluwechat/utils"

	"gin-fast/plugins/pluwechat/utils/timing"
	"gin-fast/plugins/pluwechat/utils/wxhelper"
	"time"

	"github.com/ArtisanCloud/PowerLibs/v3/object"
	request2 "github.com/ArtisanCloud/PowerWeChat/v3/src/payment/order/request"
	request3 "github.com/ArtisanCloud/PowerWeChat/v3/src/payment/refund/request"
	"github.com/ArtisanCloud/PowerWeChat/v3/src/payment/refund/response"
	"go.uber.org/zap"
)

type PayService struct {
}

func NewPayService() *PayService {
	return &PayService{}
}

// 创建订单
func (ps *PayService) DemoCreateOrder(ctx context.Context, req *models.WxDemoCreateOrderRequest) (res *models.WxDemoCreateOrderResponse, err error) {
	// 生成支付订单号
	orderNumber := utils.GeneratePaymentOrderNo()
	payment, err := wxhelper.GetPayment()
	if err != nil {
		return
	}
	// 订单失效时间
	timeExpire := time.Now().Add(15 * time.Minute)
	options := &request2.RequestJSAPIPrepay{
		Amount: &request2.JSAPIAmount{
			Total:    req.AmountTotal,
			Currency: "CNY",
		},
		Description: req.Description,
		OutTradeNo:  orderNumber, // 这里是商户订单号，不能重复提交给微信
		Payer: &request2.JSAPIPayer{
			OpenID: req.Openid,
		},
		TimeExpire: timeExpire.Format(time.RFC3339),
	}
	// 创建订单
	response, err := payment.Order.JSAPITransaction(ctx, options)
	if err != nil {
		return
	}
	// 生成支付配置
	payConf, err := payment.JSSDK.BridgeConfig(response.PrepayID, false)
	if err != nil {
		return
	}
	res = &models.WxDemoCreateOrderResponse{}
	res.OrderNumber = orderNumber
	res.PayConf = payConf.(*object.StringMap)

	//  写入订单数据
	order := &models.PaymentOrder{
		AppID:       wxhelper.GetConfig().Payment.AppID,
		MchID:       wxhelper.GetConfig().Payment.MchID,
		Description: req.Description,
		OutTradeNo:  orderNumber,
		TimeExpire:  &timeExpire,
		AmountTotal: req.AmountTotal,
		PayerOpenID: req.Openid,
		PayConf:     res.PayConfString(),
	}
	err = order.Create(ctx)
	if err != nil {
		return
	}
	timing.GetSingletonCron().AddFunc(timeExpire, func(payload interface{}) {
		app.ZapLog.Info("订单过期，关闭订单", zap.String("orderNumber", orderNumber))
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, e := payment.Order.Close(ctx, orderNumber)
		if e != nil {
			app.ZapLog.Error("关闭订单失败", zap.Error(e))
		}
		// 发布订单过期事件
		event.GetPaymentEvent().PublishExpire(order)
	}, orderNumber)
	return
}

// 查询订单支付结果
func (ps *PayService) DemoQueryOrder(ctx context.Context, req *models.WxDemoQueryOrderRequest) (res *models.WxDemoQueryOrderResponse, err error) {
	// 查询缓存中订单支付状态
	cacheKey := constant.NotifyPaymentPrefix + req.OrderNumber
	cacheData, _ := app.Cache.Get(ctx, cacheKey)
	if cacheData != "" {
		// 解析缓存数据
		var paymentNotify models.PaymentNotify
		err = json.Unmarshal([]byte(cacheData), &paymentNotify)
		if err != nil {
			return nil, err
		}
		app.ZapLog.Info("缓存订单支付结果", zap.Any("data", paymentNotify))
		res = &models.WxDemoQueryOrderResponse{
			NotifyOutTradeNo:     paymentNotify.NotifyOutTradeNo,
			NotifyAmountTotal:    paymentNotify.NotifyAmountTotal,
			NotifyTradeState:     paymentNotify.NotifyTradeState,
			NotifyTradeStateDesc: paymentNotify.NotifyTradeStateDesc,
			NotifyTradeType:      paymentNotify.NotifyTradeType,
			NotifySuccessTime:    paymentNotify.NotifySuccessTime,
		}
		// 删除缓存
		app.Cache.Del(ctx, cacheKey)
		return
	}
	// 订阅订单支付结果通知
	done := make(chan *models.WxDemoQueryOrderResponse)
	stop := make(chan struct{})
	defer close(stop)
	cancel := event.GetPaymentEvent().SubscribeOrderNumNotify(req.OrderNumber, func(data *models.PaymentNotify) {
		select {
		case done <- &models.WxDemoQueryOrderResponse{
			NotifyOutTradeNo:     data.NotifyOutTradeNo,     // 商户订单号
			NotifyAmountTotal:    data.NotifyAmountTotal,    // 订单总金额(单位为分)
			NotifyTradeState:     data.NotifyTradeState,     // 交易状态
			NotifyTradeStateDesc: data.NotifyTradeStateDesc, // 交易状态描述
			NotifyTradeType:      data.NotifyTradeType,      // 交易类型
			NotifySuccessTime:    data.NotifySuccessTime,    // 交易成功时间
		}:
			app.ZapLog.Info("订阅订单支付结果通知", zap.Any("data", data))
		case <-stop:
			return
		}
	})
	defer cancel()

	//查询数据库的订单支付状态
	go func() {
		paymentOrder := models.NewPaymentOrder()
		err = paymentOrder.GetByOutTradeNo(ctx, req.OrderNumber)
		if err != nil {
			app.ZapLog.Error("查询数据库订单支付结果失败", zap.Error(err))
		}
		if !paymentOrder.IsEmpty() && paymentOrder.NotifyTradeState != "" {
			select {
			case done <- &models.WxDemoQueryOrderResponse{
				NotifyOutTradeNo:     paymentOrder.OutTradeNo,
				NotifyAmountTotal:    paymentOrder.AmountTotal,
				NotifyTradeState:     paymentOrder.NotifyTradeState,
				NotifyTradeStateDesc: paymentOrder.NotifyTradeStateDesc,
				NotifyTradeType:      paymentOrder.NotifyTradeType,
				NotifySuccessTime:    paymentOrder.NotifySuccessTime.Format(time.RFC3339),
			}:
				app.ZapLog.Info("数据库订单支付结果", zap.Any("data", paymentOrder))
			case <-stop:
				return
			}
		}
	}()
	// 等待通知结果
	select {
	case res = <-done:
	case <-ctx.Done():
		return nil, ctx.Err()
	case <-time.After(15 * time.Second):
		return nil, errors.New("查询订单支付结果超时")
	}
	return
}

// 查询退款结果
func (ps *PayService) DemoQueryRefund(ctx context.Context, req *models.WxDemoQueryRefundRequest) (res *models.PaymentNotifyRefund, err error) {
	// 查询缓存中退款结果
	cacheKey := constant.NotifyRefundPrefix + req.OrderNumber
	cacheData, _ := app.Cache.Get(ctx, cacheKey)
	if cacheData != "" {
		// 解析缓存数据
		var paymentNotifyRefund models.PaymentNotifyRefund
		err = json.Unmarshal([]byte(cacheData), &paymentNotifyRefund)
		if err != nil {
			return nil, err
		}
		app.ZapLog.Info("缓存退款结果", zap.Any("data", paymentNotifyRefund))
		res = &paymentNotifyRefund
		// 删除缓存
		app.Cache.Del(ctx, cacheKey)
		return
	}
	// 订阅退款结果通知
	done := make(chan *models.PaymentNotifyRefund)
	stop := make(chan struct{})
	defer close(stop)
	cancel := event.GetPaymentEvent().SubscribeRefundNumNotify(req.OrderNumber, func(data *models.PaymentNotifyRefund) {
		select {
		case done <- data:
			app.ZapLog.Info("订阅退款结果通知", zap.Any("data", data))
		case <-stop:
			return
		}
	})
	defer cancel()

	// 查询数据库的退款状态
	go func() {
		paymentNotifyRefund := models.NewPaymentNotifyRefund()
		err = paymentNotifyRefund.GetByOutTradeNo(ctx, req.OrderNumber)
		if err != nil {
			app.ZapLog.Error("查询数据库退款结果失败", zap.Error(err))
		}
		if !paymentNotifyRefund.IsEmpty() {
			select {
			case done <- paymentNotifyRefund:
				app.ZapLog.Info("数据库退款结果", zap.Any("data", paymentNotifyRefund))
			case <-stop:
				return
			}
		}
	}()
	// 等待通知结果
	select {
	case res = <-done:
	case <-ctx.Done():
		return nil, ctx.Err()
	case <-time.After(30 * time.Second):
		return nil, errors.New("查询退款结果超时")
	}
	return
}

// 申请退款(订单金额直接原路返回)
func (ps *PayService) DemoApplyRefund(ctx context.Context, req *models.WxDemoApplyRefundRequest) (res *response.ResponseRefund, err error) {
	paymentOrder := models.NewPaymentOrder()
	paymentOrder.GetByOutTradeNo(ctx, req.OutTradeNo)
	if paymentOrder.IsEmpty() {
		return res, errors.New("订单不存在")
	}
	// 检查是否退款成功
	if paymentOrder.IsRefundSuccess() {
		return res, errors.New("订单已退款")
	}
	// 生成退款订单号
	refundOutRefundNo := utils.GenerateRefundOrderNo()
	paymentOrder.RefundOutRefundNo = refundOutRefundNo
	// 写入订单数据
	err = paymentOrder.Update(ctx)
	if err != nil {
		return res, err
	}
	refundNotifyURL := wxhelper.GetConfig().Payment.RefundNotifyURL
	payment, err := wxhelper.GetPayment()
	if err != nil {
		return res, err
	}
	options := &request3.RequestRefund{
		OutTradeNo:   paymentOrder.OutTradeNo,
		OutRefundNo:  refundOutRefundNo,
		Reason:       paymentOrder.RefundReason, //退款原因
		NotifyUrl:    refundNotifyURL,           // 异步接收微信支付退款结果通知的回调地址
		FundsAccount: "",
		Amount: &request3.RefundAmount{
			Refund:   paymentOrder.AmountTotal, // 退款金额，单位：分
			Total:    paymentOrder.AmountTotal, // 订单总金额，单位：分
			Currency: "CNY",
			From:     []*request3.RefundAmountFrom{}, // 退款出资账户及金额。不传仍然需要这个空数组防止微信报错
		},
		GoodsDetail: nil,
	}

	res, err = payment.Refund.Refund(ctx, options)
	return
}
