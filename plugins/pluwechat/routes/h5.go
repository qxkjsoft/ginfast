package routes

import (
	"gin-fast/app/utils/ginhelper"
	"gin-fast/plugins/pluwechat/controllers/h5"
	"gin-fast/plugins/pluwechat/middleware"

	"github.com/gin-gonic/gin"
)

func init() {
	ginhelper.RegisterPluginRoutes(func(engine *gin.Engine) {
		indexController := h5.NewIndexController()

		wx := engine.Group("/pluwechat/h5")
		{
			// 公开的路由组
			public := wx.Group("")
			{
				// 网页授权
				public.GET("/h5Callback", indexController.H5Callback)
				// 验证token是否有效
				public.GET("/validateToken", indexController.ValidateToken)
				// 支付通知回调
				public.POST("/demoNotify", indexController.DemoPayNotify)
				// 退款通知回调
				public.POST("/demoRefundNotify", indexController.DemoRefundNotify)
			}
			// 需要认证的路由组
			protected := wx.Group("")
			protected.Use(middleware.WxMemberJWT())
			{
				member := protected.Group("/member")
				{
					// 注销登录
					member.POST("/logout", indexController.Logout)
					// 获取用户信息
					member.GET("/userInfo", indexController.UserInfo)

				}

				demo := protected.Group("/demo")
				{
					// 创建订单
					demo.POST("/createOrder", indexController.DemoCreateOrder)
					// 查询订单支付结果
					demo.GET("/queryOrder", indexController.DemoQueryOrder)
					// 退款(订单金额直接原路返回)
					demo.POST("/applyRefund", indexController.DemoApplyRefund)
					// 查询退款结果
					demo.GET("/queryRefund", indexController.DemoQueryRefund)
				}
			}
		}
	})
}
