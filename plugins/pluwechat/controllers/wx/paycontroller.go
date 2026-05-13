package wx

import (
	"gin-fast/app/controllers"
	"gin-fast/app/global/app"
	"gin-fast/plugins/pluwechat/constant"
	"gin-fast/plugins/pluwechat/event"
	"gin-fast/plugins/pluwechat/middleware"
	"gin-fast/plugins/pluwechat/models"
	"gin-fast/plugins/pluwechat/service/wx"
	"gin-fast/plugins/pluwechat/utils"
	"gin-fast/plugins/pluwechat/utils/timing"
	"gin-fast/plugins/pluwechat/utils/wxhelper"
	"time"

	payModels "github.com/ArtisanCloud/PowerWeChat/v3/src/kernel/models"
	"go.uber.org/zap"
	"gorm.io/gorm"

	"github.com/ArtisanCloud/PowerWeChat/v3/src/payment/notify/request"
	"github.com/gin-gonic/gin"
)

type PayController struct {
	controllers.Common
	payService *wx.PayService
}

func NewPayController() *PayController {
	return &PayController{
		payService: wx.NewPayService(),
	}
}

// 创建订单
func (pc *PayController) DemoCreateOrder(ctx *gin.Context) {
	// 绑定请求参数
	var req models.WxDemoCreateOrderRequest
	// 验证请求参数
	if err := req.Validate(ctx); err != nil {
		pc.FailAndAbort(ctx, err.Error(), err)
	}

	// 从上下文获取会员信息
	claims := middleware.GetWxMemberClaims(ctx)
	if claims == nil {
		pc.FailAndAbort(ctx, "未认证", nil)
	}

	// 根据用户ID查询会员信息
	member := models.NewMember()
	err := member.GetByID(ctx, claims.UserID)
	if err != nil {
		pc.FailAndAbort(ctx, "查询会员信息失败", err)
	}
	req.Openid = member.OpenID
	// 创建订单
	res, err := pc.payService.DemoCreateOrder(ctx, &req)
	if err != nil {
		pc.FailAndAbort(ctx, "创建订单失败", err)
	}
	pc.Success(ctx, res)
}

// 查询订单支付结果
func (pc *PayController) DemoQueryOrder(ctx *gin.Context) {
	// 绑定请求参数
	var req models.WxDemoQueryOrderRequest
	// 验证请求参数
	if err := req.Validate(ctx); err != nil {
		pc.FailAndAbort(ctx, "参数验证失败", err)
	}

	// 查询订单支付结果
	res, err := pc.payService.DemoQueryOrder(ctx, &req)
	if err != nil {
		pc.FailAndAbort(ctx, "查询订单支付结果失败", err)
	}
	pc.Success(ctx, res)
}

// 退款(订单金额直接原路返回,这里只是演示,实际业务中可能需要走审核流程)
func (pc *PayController) DemoApplyRefund(ctx *gin.Context) {
	// 绑定请求参数
	var req models.WxDemoApplyRefundRequest
	// 验证请求参数
	if err := req.Validate(ctx); err != nil {
		pc.FailAndAbort(ctx, "参数验证失败", err)
	}

	// 申请退款
	res, err := pc.payService.DemoApplyRefund(ctx, &req)
	if err != nil {
		pc.FailAndAbort(ctx, "申请退款失败", err)
	}
	pc.Success(ctx, res)
}

// 查询退款结果
func (pc *PayController) DemoQueryRefund(ctx *gin.Context) {
	// 绑定请求参数
	var req models.WxDemoQueryRefundRequest
	// 验证请求参数
	if err := req.Validate(ctx); err != nil {
		pc.FailAndAbort(ctx, "参数验证失败", err)
	}

	// 查询退款结果
	res, err := pc.payService.DemoQueryRefund(ctx, &req)
	if err != nil {
		pc.FailAndAbort(ctx, "查询退款结果失败", err)
	}
	pc.Success(ctx, res)
}

// 支付通知回调
func (pc *PayController) DemoPayNotify(ctx *gin.Context) {
	payment, err := wxhelper.GetPayment()
	if err != nil {
		app.ZapLog.Error("获取支付实例失败", zap.Error(err))
		return
	}

	res, err := payment.HandlePaidNotify(ctx.Request, func(message *request.RequestNotify, transaction *payModels.Transaction, fail func(message string)) interface{} {
		app.ZapLog.Info("支付通知回调", zap.Any("transaction", transaction))
		// 看下支付通知事件状态
		// 这里可能是微信支付失败的通知，所以可能需要在数据库做一些记录，然后告诉微信我处理完成了。
		if message.EventType != "TRANSACTION.SUCCESS" {
			app.ZapLog.Warn("支付未成功", zap.String("eventType", message.EventType))
			return true
		}
		if transaction.OutTradeNo != "" {
			// 测试模拟延时通知
			//time.Sleep(5 * time.Second)
			// 移除订单过期通知
			timing.GetSingletonCron().RemoveByFn(func(payload interface{}) bool {
				return payload.(string) == transaction.OutTradeNo
			})
			// 检查是否已存在相同的NotifyInsideID
			count, _ := models.NewPaymentNotify().CountByInsideID(ctx, message.ID)
			if count > 0 {
				app.ZapLog.Warn("重复支付通知", zap.String("notifyInsideID", message.ID))
				return true
			}
			// 使用事务处理支付通知
			err = app.DB().Transaction(func(tx *gorm.DB) error {
				// 记录支付通知
				paymentNotify := &models.PaymentNotify{
					NotifyOutTradeNo:     transaction.OutTradeNo,
					NotifyAmountTotal:    int(transaction.Amount.Total),
					NotifyPayerOpenid:    transaction.Payer.OpenID,
					NotifyInsideID:       message.ID,
					NotifyCreateTime:     message.CreateTime.String(),
					NotifyEventType:      message.EventType,
					NotifySummary:        message.Summary,
					NotifyTransactionID:  transaction.TransactionID,
					NotifyTradeType:      transaction.TradeType,
					NotifyTradeState:     transaction.TradeState,
					NotifyTradeStateDesc: transaction.TradeStateDesc,
					NotifyBankType:       transaction.BankType,
					NotifySuccessTime:    transaction.SuccessTime,
				}
				if err := tx.Create(paymentNotify).Error; err != nil {
					return err
				}
				// 支付状态改变
				order := models.NewPaymentOrder()
				order.GetByOutTradeNo(ctx, transaction.OutTradeNo)
				if !order.IsEmpty() {
					order.PaymentNotifyID = paymentNotify.ID
					order.NotifyTransactionID = transaction.TransactionID
					order.NotifyTradeType = transaction.TradeType
					order.NotifyTradeState = transaction.TradeState
					order.NotifySuccessTime = utils.ParseWxTime(transaction.SuccessTime)
					order.NotifyTradeStateDesc = transaction.TradeStateDesc
					err := tx.Save(order).Error
					if err != nil {
						return err
					}
				}
				// 通知查询请求
				cacheKey := constant.NotifyPaymentPrefix + transaction.OutTradeNo
				if event.GetPaymentEvent().HasCallbackOrderNumNotify(transaction.OutTradeNo) {
					// 发布订单号通知
					event.GetPaymentEvent().PublishOrderNumNotify(transaction.OutTradeNo, paymentNotify.Copy())
				} else {
					// 缓存支付通知结果，设置过期时间3分钟
					exp := time.Minute * 3
					// test
					//exp := time.Second * 5
					app.Cache.Set(ctx, cacheKey, paymentNotify.JsonString(), exp)
				}

				// 发布支付消息通知
				event.GetPaymentEvent().PublishPayNotify(paymentNotify)
				return nil
			})

			if err != nil {
				app.ZapLog.Error("支付通知回调事务失败", zap.Error(err))
				return nil
			}
		} else {
			// 因为微信这个回调不存在订单号，所以可以告诉微信我还没处理成功，等会它会重新发起通知
			// 如果不需要，直接返回true即可
			app.ZapLog.Warn("支付通知回调订单号为空", zap.Any("transaction", transaction))
			fail("payment fail")
			return nil
		}
		return true
	})
	if err != nil {
		app.ZapLog.Error("支付通知回调失败", zap.Error(err))
		return
	}
	// 这里根据之前返回的是true或者fail，框架这边自动会帮你回复微信
	err = res.Write(ctx.Writer)
	if err != nil {
		app.ZapLog.Error("支付通知回调回复微信失败", zap.Error(err))
	}
}

// 退款通知回调
func (pc *PayController) DemoRefundNotify(ctx *gin.Context) {
	payment, err := wxhelper.GetPayment()
	if err != nil {
		app.ZapLog.Error("获取支付实例失败", zap.Error(err))
		return
	}

	res, err := payment.HandleRefundedNotify(ctx.Request, func(message *request.RequestNotify, transaction *payModels.Refund, fail func(message string)) interface{} {
		app.ZapLog.Info("退款通知回调", zap.Any("transaction", transaction))
		if message.EventType != "REFUND.SUCCESS" {
			app.ZapLog.Warn("退款未成功", zap.String("eventType", message.EventType))
			return true
		}
		if transaction.OutTradeNo != "" {
			// 检查是否已存在相同的NotifyInsideID
			count, _ := models.NewPaymentNotifyRefund().CountByInsideID(ctx, message.ID)
			if count > 0 {
				app.ZapLog.Warn("重复退款通知", zap.String("notifyInsideID", message.ID))
				return true
			}

			err := app.DB().Transaction(func(tx *gorm.DB) error {
				// 记录退款通知
				paymentNotifyRefund := &models.PaymentNotifyRefund{
					NotifyInsideID:      message.ID,
					NotifyCreateTime:    message.CreateTime,
					NotifyEventType:     message.EventType,
					NotifySummary:       message.Summary,
					MchID:               transaction.MchID,
					TransactionID:       transaction.TransactionID,
					OutTradeNo:          transaction.OutTradeNo,
					RefundID:            transaction.RefundID,
					OutRefundNo:         transaction.OutRefundNo,
					RefundStatus:        transaction.RefundStatus,
					SuccessTime:         transaction.SuccessTime,
					UserReceivedAccount: transaction.UserReceivedAccount,
					AmountTotal:         int(transaction.Amount.Total),
					AmountRefund:        int(transaction.Amount.Refund),
					AmountPayerTotal:    int(transaction.Amount.PayerTotal),
					AmountPayerRefund:   int(transaction.Amount.PayerRefund),
				}
				if err := tx.Create(paymentNotifyRefund).Error; err != nil {
					return err
				}
				// 修改订单状态
				order := models.NewPaymentOrder()
				order.GetByOutTradeNo(ctx, transaction.OutTradeNo)
				if !order.IsEmpty() {
					order.RefundNotifyID = paymentNotifyRefund.ID                     //关联的退款通知ID
					order.RefundRefundID = transaction.RefundID                       //微信支付退款单号
					order.RefundStatus = transaction.RefundStatus                     //退款状态
					order.RefundSuccessTime = transaction.SuccessTime                 //退款成功时间
					order.RefundPayerRefund = transaction.Amount.PayerRefund          //实际退款给用户的金额
					order.RefundUserReceivedAccount = transaction.UserReceivedAccount //退款单的退款入账方
					err := tx.Save(order).Error
					if err != nil {
						return err
					}
				}

				// 通知查询请求
				cacheKey := constant.NotifyRefundPrefix + transaction.OutTradeNo
				if event.GetPaymentEvent().HasCallbackRefundNumNotify(transaction.OutTradeNo) {
					// 发布订单号通知
					event.GetPaymentEvent().PublishRefundNumNotify(transaction.OutTradeNo, paymentNotifyRefund.Copy())
				} else {
					// 缓存退款通知结果，设置过期时间3分钟
					exp := time.Minute * 3
					// test
					//exp := time.Second * 5
					app.Cache.Set(ctx, cacheKey, paymentNotifyRefund.JsonString(), exp)
				}
				// 发布退款消息通知
				event.GetPaymentEvent().PublishRefundNotify(paymentNotifyRefund)
				return nil
			})

			if err != nil {
				app.ZapLog.Error("退款通知回调事务失败", zap.Error(err))
				return nil
			}
		} else {
			app.ZapLog.Warn("退款通知回调订单号为空", zap.Any("transaction", transaction))
			fail("payment fail")
			return nil
		}
		return true
	})
	if err != nil {
		app.ZapLog.Error("退款通知回调失败", zap.Error(err))
		return
	}
	// 这里根据之前返回的是true或者fail，框架这边自动会帮你回复微信
	err = res.Write(ctx.Writer)
	if err != nil {
		app.ZapLog.Error("退款通知回调回复微信失败", zap.Error(err))
		return
	}

}

// 订单列表
func (pc *PayController) DemoOrderList(ctx *gin.Context) {
	req := &models.WxDemoOrderListRequest{}
	if err := req.Validate(ctx); err != nil {
		app.ZapLog.Error("订单列表参数校验失败", zap.Error(err))
		return
	}
	// 查询订单列表
	list := models.NewPaymentOrderList()
	if err := list.Find(ctx, req.Paginate(), req.Handle()); err != nil {
		app.ZapLog.Error("订单列表查询失败", zap.Error(err))
		return
	}
	// 获取总数
	total, err := list.GetTotal(ctx, req.Handle())
	if err != nil {
		pc.FailAndAbort(ctx, "获取订单总数失败", err)
	}
	// 返回分页数据
	pc.Success(ctx, map[string]interface{}{
		"list":  list,
		"total": total,
	})
}
