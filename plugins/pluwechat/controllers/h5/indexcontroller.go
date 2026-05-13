package h5

import (
	"gin-fast/app/controllers"
	"gin-fast/app/global/app"
	"gin-fast/app/utils/common"
	"gin-fast/plugins/pluwechat/constant"
	"gin-fast/plugins/pluwechat/event"
	"gin-fast/plugins/pluwechat/middleware"
	"gin-fast/plugins/pluwechat/models"
	"gin-fast/plugins/pluwechat/service/h5"
	"gin-fast/plugins/pluwechat/utils"
	"gin-fast/plugins/pluwechat/utils/timing"
	"gin-fast/plugins/pluwechat/utils/tokeneasy"
	"gin-fast/plugins/pluwechat/utils/wxhelper"
	"time"

	payModels "github.com/ArtisanCloud/PowerWeChat/v3/src/kernel/models"
	"github.com/ArtisanCloud/PowerWeChat/v3/src/payment/notify/request"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type IndexController struct {
	controllers.Common
	indexService *h5.IndexService
}

func NewIndexController() *IndexController {
	return &IndexController{
		indexService: h5.NewIndexService(),
	}
}

// 网页授权
func (c *IndexController) H5Callback(ctx *gin.Context) {
	// 获取请求参数
	var req models.WxH5CallbackRequest
	// 验证请求参数
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, "参数验证失败", err)
		return
	}
	// 调用服务层处理
	res, err := c.indexService.H5Callback(ctx, &req)
	if err != nil {
		c.FailAndAbort(ctx, "处理失败", err)
		return
	}

	// 返回响应
	c.Success(ctx, res)
}

// UserInfo 获取当前登录会员的信息
func (c *IndexController) UserInfo(ctx *gin.Context) {
	// 从上下文获取会员信息
	claims := middleware.GetWxMemberClaims(ctx)
	if claims == nil {
		c.FailAndAbort(ctx, "未认证", nil)
		return
	}

	// 根据用户ID查询会员信息
	member := models.NewMember()
	err := member.GetByID(ctx, claims.UserID)
	if err != nil {
		c.FailAndAbort(ctx, "查询会员信息失败", err)
		return
	}

	// 检查会员是否存在
	if member.IsEmpty() {
		c.FailAndAbort(ctx, "会员不存在", nil)
		return
	}

	// 检查会员状态
	if member.Status != 1 {
		c.FailAndAbort(ctx, "会员已被禁用", nil)
		return
	}

	// 返回会员信息
	c.Success(ctx, map[string]interface{}{
		"user": models.WxMemberInfoResponse{
			ID:       member.ID,
			Username: member.Username,
			NickName: member.NickName,
			Avatar:   member.Avatar,
			Phone:    member.Phone,
		},
	})
}

// Logout 注销登录
func (c *IndexController) Logout(ctx *gin.Context) {
	// 撤销 access token
	tokenString, err := common.GetAccessToken(ctx)
	if err == nil && tokenString != "" {
		// 尝试撤销access token，即使失败也继续执行
		tokeneasy.GetTokenService().RevokeTokenWithCache(tokenString)
	}

	c.Success(ctx, gin.H{
		"message": "登出成功",
	})
}

// ValidateToken 验证token是否有效
func (c *IndexController) ValidateToken(ctx *gin.Context) {
	tokenString, err := common.GetAccessToken(ctx)
	if err != nil {
		c.FailAndAbort(ctx, "获取token失败", err)
		return
	}

	// 验证token
	claims, err := tokeneasy.GetTokenService().ValidateTokenWithCache(tokenString)
	if err != nil {
		c.FailAndAbort(ctx, "token无效", err)
		return
	}

	// 返回验证结果和用户信息
	c.Success(ctx, map[string]interface{}{
		"valid": true,
		"user": map[string]interface{}{
			"userID":   claims.UserID,
			"username": claims.Username,
		},
	})
}

// DemoCreateOrder 创建订单测试
func (c *IndexController) DemoCreateOrder(ctx *gin.Context) {
	// 获取请求参数
	var req models.WxH5DemoCreateOrderRequest
	// 验证请求参数
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, "参数验证失败", err)
	}
	// 从上下文获取会员信息
	claims := middleware.GetWxMemberClaims(ctx)
	if claims == nil {
		c.FailAndAbort(ctx, "未认证", nil)
	}
	// 设置openid
	member := models.NewMember()
	err := member.GetByID(ctx, claims.UserID)
	if err != nil {
		c.FailAndAbort(ctx, "查询会员信息失败", err)
	}
	req.Openid = member.OpenID
	// 调用服务层处理
	res, err := c.indexService.DemoCreateOrder(ctx, &req)
	if err != nil {
		c.FailAndAbort(ctx, "处理失败", err)
	}

	// 返回响应
	c.Success(ctx, res)
}

// 退款通知回调
func (c *IndexController) DemoRefundNotify(ctx *gin.Context) {
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
				cacheKey := constant.NotifyRefundH5Prefix + transaction.OutTradeNo
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

// 支付通知回调
func (c *IndexController) DemoPayNotify(ctx *gin.Context) {
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
				cacheKey := constant.NotifyPaymentH5Prefix + transaction.OutTradeNo
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

// 查询订单支付结果测试
func (c *IndexController) DemoQueryOrder(ctx *gin.Context) {
	// 绑定请求参数
	var req models.WxH5DemoQueryOrderRequest
	// 验证请求参数
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, "参数验证失败", err)
	}

	// 查询订单支付结果
	res, err := c.indexService.DemoQueryOrder(ctx, &req)
	if err != nil {
		c.FailAndAbort(ctx, "查询订单支付结果失败", err)
	}
	c.Success(ctx, res)
}

// 申请退款(订单金额直接原路返回,这里只是演示,实际业务中可能需要走审核流程)
func (c *IndexController) DemoApplyRefund(ctx *gin.Context) {
	// 绑定请求参数
	var req models.WxH5DemoApplyRefundRequest
	// 验证请求参数
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, "参数验证失败", err)
		return
	}

	// 申请退款
	res, err := c.indexService.DemoApplyRefund(ctx, &req)
	if err != nil {
		c.FailAndAbort(ctx, "申请退款失败", err)
		return
	}
	c.Success(ctx, res)
}

// 查询退款结果
func (c *IndexController) DemoQueryRefund(ctx *gin.Context) {
	// 绑定请求参数
	var req models.WxH5DemoQueryRefundRequest
	// 验证请求参数
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, "参数验证失败", err)
		return
	}

	// 查询退款结果
	res, err := c.indexService.DemoQueryRefund(ctx, &req)
	if err != nil {
		c.FailAndAbort(ctx, "查询退款结果失败", err)
		return
	}
	c.Success(ctx, res)
}
