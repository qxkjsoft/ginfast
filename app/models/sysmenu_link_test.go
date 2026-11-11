package models

import (
	"encoding/json"
	"net/http/httptest"
	"net/url"
	"strings"
	"testing"

	"github.com/gin-gonic/gin"
)

func TestMenuRequestLinkValidation(t *testing.T) {
	tests := []struct {
		name    string
		isLink  int8
		iframe  int8
		link    string
		wantErr bool
	}{
		{"普通菜单允许空地址", 0, 0, "", false},
		{"普通菜单允许空白地址", 0, 0, " \t　", false},
		{"关闭开关仍拒绝脚本协议", 0, 0, "javascript:alert(1)", true},
		{"关闭开关仍拒绝数据协议", 0, 0, "data:text/html,test", true},
		{"关闭开关仍拒绝相对路径", 0, 0, "/page", true},
		{"关闭开关允许有效地址", 0, 0, " https://example.com/page ", false},
		{"外链拒绝空地址", 1, 0, "", true},
		{"内嵌拒绝空地址", 1, 1, "", true},
		{"内嵌标记单独开启也校验", 0, 1, "", true},
		{"拒绝纯空白", 1, 1, " \t\n　", true},
		{"拒绝缺少协议", 1, 0, "www.baidu.com", true},
		{"拒绝相对路径", 1, 1, "/page", true},
		{"拒绝脚本协议", 1, 0, "javascript:alert(1)", true},
		{"拒绝缺少主机", 1, 1, "https:///page", true},
		{"接受有效地址并去除空白", 1, 1, " https://example.com/page ", false},
	}
	for _, tt := range tests {
		for _, operation := range []string{"add", "edit"} {
			t.Run(operation+"/"+tt.name, func(t *testing.T) {
				body, err := json.Marshal(map[string]any{
					"id": 1, "title": "链接测试", "type": 2,
					"isLink": tt.isLink, "iframe": tt.iframe, "link": tt.link,
				})
				if err != nil {
					t.Fatal(err)
				}
				c, _ := gin.CreateTestContext(httptest.NewRecorder())
				c.Request = httptest.NewRequest("POST", "/", strings.NewReader(string(body)))
				c.Request.Header.Set("Content-Type", "application/json")
				var link string
				if operation == "add" {
					var req SysMenuAddRequest
					err = req.Validate(c)
					link = req.Link
				} else {
					var req SysMenuUpdateRequest
					err = req.Validate(c)
					link = req.Link
				}
				if (err != nil) != tt.wantErr {
					t.Fatalf("wantErr=%v, got %v", tt.wantErr, err)
				}
				if err == nil && link != strings.TrimSpace(tt.link) {
					t.Fatalf("地址未去除首尾空白: %q", link)
				}
			})
		}
	}
}

func TestMenuCheckFormLinkValidation(t *testing.T) {
	tests := []struct {
		name    string
		fields  url.Values
		wantErr string
	}{
		{"普通菜单未提供地址", nil, ""},
		{"外链未提供地址", url.Values{"isLink": {"1"}}, "外链地址不能为空"},
		{"内嵌未提供地址", url.Values{"iframe": {"1"}}, "外链地址不能为空"},
		{"目录不能绕过地址校验", url.Values{"type": {"1"}, "link": {"javascript:alert(1)"}}, "外链地址需以http:// 或 https:// 开头"},
		{"按钮不能绕过地址校验", url.Values{"type": {"3"}, "link": {"/page"}}, "外链地址需以http:// 或 https:// 开头"},
		{"有效地址去除空白", url.Values{"isLink": {"1"}, "link": {" \t　https://example.com/page　 "}}, ""},
		{"保留标题必填校验", url.Values{"title": {""}}, "标题"},
		{"保留类型范围校验", url.Values{"type": {"4"}}, "类型"},
	}
	for _, tt := range tests {
		for _, operation := range []string{"add", "edit"} {
			t.Run(operation+"/"+tt.name, func(t *testing.T) {
				fields := url.Values{"id": {"1"}, "title": {"链接测试"}, "type": {"2"}}
				for key, values := range tt.fields {
					fields[key] = values
				}
				c, _ := gin.CreateTestContext(httptest.NewRecorder())
				c.Request = httptest.NewRequest("POST", "/", strings.NewReader(fields.Encode()))
				c.Request.Header.Set("Content-Type", "application/x-www-form-urlencoded")
				var err error
				var link string
				if operation == "add" {
					var req SysMenuAddRequest
					err = req.Check(c, &req)
					link = req.Link
				} else {
					var req SysMenuUpdateRequest
					err = req.Check(c, &req)
					link = req.Link
				}
				if tt.wantErr != "" {
					if err == nil || !strings.Contains(err.Error(), tt.wantErr) {
						t.Fatalf("want error containing %q, got %v", tt.wantErr, err)
					}
					return
				}
				if err != nil {
					t.Fatal(err)
				}
				if link != strings.TrimSpace(fields.Get("link")) {
					t.Fatalf("地址未去除首尾空白: %q", link)
				}
			})
		}
	}
}

func TestImportedMenuLinkValidationPreservesValues(t *testing.T) {
	const data = `[
		{"id":1,"parentId":0,"type":1,"link":" \t\u3000", "children":[
			{"id":2,"parentId":1,"type":2,"iframe":1,"link":" \t\u3000https://example.com/embedded\u3000 "}
		]},
		{"id":3,"parentId":0,"type":2,"isLink":1,"link":" \thttps://example.com/external\n "}
	]`
	var list SysMenuList
	if err := json.Unmarshal([]byte(data), &list); err != nil {
		t.Fatal(err)
	}
	if errors := list.ValidateTree(); !errors.IsEmpty() {
		t.Fatalf("有效导入地址应通过校验: %v", errors)
	}
	// 树形校验只检查合法性，保留 JSON 中的地址原值。
	if got := list[0].Link; got != " \t\u3000" {
		t.Fatalf("普通目录地址被校验修改: %q", got)
	}
	if got := list[0].Children[0].Link; got != " \t\u3000https://example.com/embedded\u3000 " {
		t.Fatalf("嵌套内嵌地址被校验修改: %q", got)
	}
	if got := list[1].Link; got != " \thttps://example.com/external\n " {
		t.Fatalf("根级外链地址被校验修改: %q", got)
	}
}

func TestImportedMenuLinkValidation(t *testing.T) {
	child := &SysMenu{
		BaseModel: BaseModel{ID: 2}, ParentID: 1,
		Type: 2, IsLink: 1, Iframe: 1, Link: " \t",
	}
	list := SysMenuList{&SysMenu{
		BaseModel: BaseModel{ID: 1}, Type: 1,
		Children: SysMenuList{child},
	}}
	if list.ValidateTree().IsEmpty() {
		t.Fatal("嵌套导入的内嵌菜单应拒绝空白地址")
	}
	child.Link = "https://example.com/page"
	if errors := list.ValidateTree(); !errors.IsEmpty() {
		t.Fatalf("有效内嵌地址应通过校验: %v", errors)
	}
	child.IsLink, child.Iframe, child.Link = 0, 0, ""
	if errors := list.ValidateTree(); !errors.IsEmpty() {
		t.Fatalf("普通菜单空地址应通过校验: %v", errors)
	}
	child.Link = "javascript:alert(1)"
	if list.ValidateTree().IsEmpty() {
		t.Fatal("JSON 导入不能通过关闭开关绕过地址校验")
	}
	child.Link = ""
	list[0].Link = "javascript:alert(1)"
	if list.ValidateTree().IsEmpty() {
		t.Fatal("目录上的非空地址也必须校验")
	}
}
