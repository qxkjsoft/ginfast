package models

// ServerConfig 服务器配置参数
type SystemConfig struct {
	SystemLogo      string `json:"systemLogo" yaml:"SystemLogo"`
	SystemIcon      string `json:"systemIcon" yaml:"SystemIcon"`
	SystemName      string `json:"systemName" yaml:"SystemName"`
	SystemCopyright string `json:"systemCopyright" yaml:"SystemCopyright"`
	SystemRecordNo  string `json:"systemRecordNo" yaml:"SystemRecordNo"`
}

type SafeConfig struct {
	LoginLockThreshold int  `json:"loginLockThreshold" yaml:"LoginLockThreshold"`
	LoginLockExpire    int  `json:"loginLockExpire" yaml:"LoginLockExpire"`
	LoginLockDuration  int  `json:"loginLockDuration" yaml:"LoginLockDuration"`
	MinPasswordLength  int  `json:"minPasswordLength" yaml:"MinPasswordLength"`
	RequireSpecialChar bool `json:"requireSpecialChar" yaml:"RequireSpecialChar"`
}

// CaptchaConfig 验证码配置参数
type CaptchaConfig struct {
	Open   bool `json:"open" yaml:"open"`
	Length int  `json:"length" yaml:"length"`
}

// ConfigRequest 配置请求参数
type ConfigRequest struct {
	System  SystemConfig  `json:"system" yaml:"System"`
	Safe    SafeConfig    `json:"safe" yaml:"Safe"`
	Captcha CaptchaConfig `json:"captcha" yaml:"Captcha"`
}
