package models

import "github.com/gookit/validate"

// ConfigValidation 将菜单地址规则接入 Check 使用的结构体校验机制。
func (r SysMenuAddRequest) ConfigValidation(v *validate.Validation) {
	configureMenuLinkValidation(v, r.Type, r.IsLink, r.Iframe)
}

func (r SysMenuUpdateRequest) ConfigValidation(v *validate.Validation) {
	configureMenuLinkValidation(v, r.Type, r.IsLink, r.Iframe)
}

func configureMenuLinkValidation(v *validate.Validation, menuType, isLink, iframe int8) {
	v.FilterRule("Link", "trim")
	rule := v.AddRule("Link", "menuLink")
	// 空地址也需检查，由共用规则根据菜单类型及开关决定是否必填。
	rule.SetSkipEmpty(false)
	rule.SetCheckFunc(func(link string) bool {
		if err := validateMenuLink(menuType, isLink, iframe, link); err != nil {
			rule.SetMessage(err.Error())
			return false
		}
		return true
	})
}
