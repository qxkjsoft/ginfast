package routes

import (
	"gin-fast/app/utils/ginhelper"
	"gin-fast/plugins/pluwechat/controllers/wx"
	"gin-fast/plugins/pluwechat/middleware"

	"github.com/gin-gonic/gin"
)

func init() {
	ginhelper.RegisterPluginRoutes(func(engine *gin.Engine) {
		wxMemberController := wx.NewMemberController()
		wxPayController := wx.NewPayController()
		wx := engine.Group("/pluwechat/wx")
		{
			// 公开的路由组
			public := wx.Group("")
			{
				// 手机号快捷登录
				public.POST("/login", wxMemberController.Login)
				// 根据code快速登录
				public.POST("/loginByCode", wxMemberController.LoginByCode)
				// 验证token是否有效
				public.GET("/validateToken", wxMemberController.ValidateToken)
				// 支付通知回调
				public.POST("/demoPayNotify", wxPayController.DemoPayNotify)
				// 退款通知回调
				public.POST("/demoRefundNotify", wxPayController.DemoRefundNotify)
			}

			// 需要认证的路由组
			protected := wx.Group("")
			protected.Use(middleware.WxMemberJWT())
			{
				member := protected.Group("/member")
				{
					// 注销登录
					member.POST("/logout", wxMemberController.Logout)
					// 更新用户信息
					member.PUT("/updateProfile", wxMemberController.UpdateProfile)
					// 获取用户信息
					member.GET("/userInfo", wxMemberController.UserInfo)
					// 上传文件
					member.POST("/upload", wxMemberController.Upload)
				}
				// 支付相关路由
				pay := protected.Group("/pay")
				{
					// 创建订单
					pay.POST("/demoCreateOrder", wxPayController.DemoCreateOrder)
					// 查询订单支付结果
					pay.GET("/demoQueryOrder", wxPayController.DemoQueryOrder)
					// 退款(订单金额直接原路返回)
					pay.POST("/demoApplyRefund", wxPayController.DemoApplyRefund)
					// 查询退款结果
					pay.GET("/demoQueryRefund", wxPayController.DemoQueryRefund)
					// 订单列表
					pay.GET("/demoOrderList", wxPayController.DemoOrderList)
				}
			}
		}
	})
}
