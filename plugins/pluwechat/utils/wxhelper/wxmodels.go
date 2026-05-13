package wxhelper

// MiniProgram  微信小程序配置
type MiniProgramConfig struct {
	AppID         string `mapstructure:"appid" json:"appId" form:"appId"`             // 必填
	Secret        string `mapstructure:"secret" json:"secret" form:"secret"`          // 必填
	RedisAddr     string `mapstructure:"redisaddr" json:"redisAddr" form:"redisAddr"` // 必填
	RedisPassword string `mapstructure:"redispassword" json:"redisPassword" form:"redisPassword"`
	RedisDB       int    `mapstructure:"redisdb" json:"redisDB" form:"redisDB"`
	MessageToken  string `mapstructure:"messagetoken" json:"messageToken" form:"messageToken"`
	MessageAesKey string `mapstructure:"messageaeskey" json:"messageAesKey" form:"messageAesKey"`

	VirtualPayAppKey  string `mapstructure:"virtualpayappkey" json:"virtualPayAppKey" form:"virtualPayAppKey"`
	VirtualPayOfferID string `mapstructure:"virtualpayofferid" json:"virtualPayOfferID" form:"virtualPayOfferID"`
}

// PaymentConfig  微信支付配置
type PaymentConfig struct {
	AppID              string `mapstructure:"appid" json:"appId" form:"appId"`          // 必填
	MchID              string `mapstructure:"mchid" json:"mchID" form:"mchID"`          // 必填
	CertPath           string `mapstructure:"certpath" json:"certPath" form:"certPath"` // 必填
	KeyPath            string `mapstructure:"keypath" json:"keyPath" form:"keyPath"`    // 必填
	SerialNo           string `mapstructure:"serialno" json:"serialNo" form:"serialNo"` // 必填
	CertificateKeyPath string `mapstructure:"certificatekeypath" json:"certificateKeyPath" form:"certificateKeyPath"`
	WechatPaySerial    string `mapstructure:"wechatpayserial" json:"wechatPaySerial" form:"wechatPaySerial"`
	RSAPublicKeyPath   string `mapstructure:"rsapublickeypath" json:"rsaPublicKeyPath" form:"rsaPublicKeyPath"`
	MchApiV3Key        string `mapstructure:"mchapiv3key" json:"mchApiV3Key" form:"mchApiV3Key"` // MchApiV3Key和Key二选一必填
	Key                string `mapstructure:"key" json:"key" form:"key"`                         // MchApiV3Key和Key二选一必填
	ResponseType       string `mapstructure:"responsetype" json:"responseType" form:"responseType"`
	NotifyURL          string `mapstructure:"notifyurl" json:"notifyURL" form:"notifyURL"`                   // 必填
	RefundNotifyURL    string `mapstructure:"refundnotifyurl" json:"refundNotifyURL" form:"refundNotifyURL"` // 必填
	SubMchID           string `mapstructure:"submchid" json:"subMchID" form:"subMchID"`
	SubAppID           string `mapstructure:"subappid" json:"subAppID" form:"subAppID"`
	HttpDebug          bool   `mapstructure:"httpdebug" json:"httpDebug" form:"httpDebug"`
	RedisAddr          string `mapstructure:"redisaddr" json:"redisAddr" form:"redisAddr"` // 必填
	RedisPassword      string `mapstructure:"redispassword" json:"redisPassword" form:"redisPassword"`
	RedisDB            int    `mapstructure:"redisdb" json:"redisDB" form:"redisDB"`
}

// 微信公众号配置
type OfficialAccountConfig struct {
	AppID         string `mapstructure:"appid" json:"appId" form:"appId"`    // 必填
	AppSecret     string `mapstructure:"secret" json:"secret" form:"secret"` // 必填
	RedisAddr     string `mapstructure:"redisaddr" json:"redisAddr" form:"redisAddr"`
	RedisPassword string `mapstructure:"redispassword" json:"redisPassword" form:"redisPassword"`
	RedisDB       int    `mapstructure:"redisdb" json:"redisDB" form:"redisDB"`
	MessageToken  string `mapstructure:"messagetoken" json:"messageToken" form:"messageToken"`
	MessageAesKey string `mapstructure:"messageaeskey" json:"messageAesKey" form:"messageAesKey"`
}
