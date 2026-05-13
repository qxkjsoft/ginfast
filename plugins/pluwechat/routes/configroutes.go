package routes

import (
	"gin-fast/app/middleware"
	"gin-fast/app/utils/ginhelper"
	"gin-fast/plugins/pluwechat/controllers/admin"

	"github.com/gin-gonic/gin"
)

func init() {
	configController := admin.NewConfigController()
	ginhelper.RegisterPluginRoutes(func(engine *gin.Engine) {
		configGroup := engine.Group("/api/plugins/pluwechat/config")
		configGroup.Use(middleware.JWTAuthMiddleware())     // 认证中间件
		configGroup.Use(middleware.DemoAccountMiddleware()) // 添加演示账号中间件
		configGroup.Use(middleware.CasbinMiddleware())      // 权限中间件
		{
			// 获取微信配置
			configGroup.GET("/wxconfig", configController.GetWxConfig)
			// 编辑小程序配置
			configGroup.PUT("/miniprogram", configController.UpdateMiniProgramConfig)
			// 编辑支付配置
			configGroup.PUT("/payment", configController.UpdatePaymentConfig)
			// 编辑微信公众号配置
			configGroup.PUT("/officialaccount", configController.UpdateOfficialAccountConfig)
			// 上传文件
			configGroup.POST("/upload", configController.UploadFile)
		}
	})
}
