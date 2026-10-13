package uploadhelper

import (
	"net"
	"testing"

	"github.com/stretchr/testify/assert"
)

// mockResolver 构造注入用的域名解析函数
func mockResolver(addrs ...string) func(host string) ([]net.IP, error) {
	ips := make([]net.IP, 0, len(addrs))
	for _, a := range addrs {
		ips = append(ips, net.ParseIP(a))
	}
	return func(host string) ([]net.IP, error) {
		return ips, nil
	}
}

// TestValidateRemoteImageURL 远程图片 URL 的 SSRF 校验（表驱动）
func TestValidateRemoteImageURL(t *testing.T) {
	tests := []struct {
		name     string
		url      string
		resolver func(string) ([]net.IP, error)
		wantErr  bool
	}{
		{"https公网IP", "https://8.8.8.8/avatar.jpg", nil, false},
		{"http公网IP", "http://8.8.8.8/a.jpg", nil, false},
		{"ftp协议拒绝", "ftp://8.8.8.8/a.jpg", nil, true},
		{"file协议拒绝", "file:///etc/passwd", nil, true},
		{"环回地址拒绝", "http://127.0.0.1:8080/a.jpg", nil, true},
		{"IPv6环回拒绝", "http://[::1]/a.jpg", nil, true},
		{"私网地址拒绝", "http://192.168.0.14:8080/a.jpg", nil, true},
		{"内网地址拒绝", "http://10.0.0.5/a.jpg", nil, true},
		{"链路本地拒绝", "http://169.254.169.254/latest/meta-data", nil, true},
		{"域名解析公网放行", "https://wx.qlogo.cn/a.jpg", mockResolver("8.8.8.8"), false},
		{"域名解析私网拒绝", "https://evil.example.com/a.jpg", mockResolver("192.168.1.1"), true},
		{"多IP任一私网拒绝", "https://rebind.example.com/a.jpg", mockResolver("8.8.8.8", "127.0.0.1"), true},
		{"解析失败拒绝", "https://nx.example.com/a.jpg", func(string) ([]net.IP, error) { return nil, assert.AnError }, true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			resolver := tt.resolver
			if resolver == nil {
				resolver = net.LookupIP
			}
			err := ValidateRemoteImageURL(tt.url, resolver)
			if tt.wantErr {
				assert.Error(t, err)
			} else {
				assert.NoError(t, err)
			}
		})
	}
}
