package uploadhelper

import (
	"fmt"
	"net"
	"net/url"
)

// ValidateRemoteImageURL 校验远程图片 URL 的安全性，防 SSRF：
//   - 仅允许 http/https 协议
//   - 解析目标主机的全部 IP，环回/私网/链路本地/组播/未指定地址任一命中即拒绝
//
// resolver 参数注入域名解析函数（生产传 net.LookupIP，单测可注入 mock）。
// 局限说明：不做 DNS rebinding 深度防护（本校验与实际请求是两次独立解析）。
func ValidateRemoteImageURL(rawURL string, resolver func(host string) ([]net.IP, error)) error {
	u, err := url.Parse(rawURL)
	if err != nil {
		return fmt.Errorf("URL 解析失败: %v", err)
	}
	if u.Scheme != "http" && u.Scheme != "https" {
		return fmt.Errorf("仅允许 http/https 协议: %s", u.Scheme)
	}
	host := u.Hostname()
	if host == "" {
		return fmt.Errorf("URL 缺少主机地址")
	}

	ips, err := resolver(host)
	if err != nil {
		return fmt.Errorf("解析主机地址失败: %v", err)
	}
	if len(ips) == 0 {
		return fmt.Errorf("主机无可用地址: %s", host)
	}
	for _, ip := range ips {
		if ip.IsLoopback() || ip.IsPrivate() || ip.IsLinkLocalUnicast() ||
			ip.IsLinkLocalMulticast() || ip.IsMulticast() || ip.IsUnspecified() {
			return fmt.Errorf("主机解析到不允许的地址: %s", ip.String())
		}
	}
	return nil
}
