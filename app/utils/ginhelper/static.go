package ginhelper

import (
	"net/http"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/gin-gonic/gin"
)

// SecureStatic 安全地注册静态文件服务（替代 engine.Static）：
//   - 所有响应追加 X-Content-Type-Options: nosniff
//   - uploads 子路径下的 .svg 追加禁执行脚本的 CSP（<img> 引用正常显示，直接在浏览器打开无法执行脚本）
//   - uploads 子路径下的 .html/.htm/.xml/.xhtml 强制下载（防内联渲染存储型 XSS）
//   - 关闭目录列表（目录请求返回 404）
//
// 参数：
//   - engine:   gin 引擎实例
//   - rootPath: URL 前缀（如 "/public"，来自 httpserver.serverrootpath 配置）
//   - rootDir:  磁盘根目录（如 "./resource/public"，来自 httpserver.serverroot 配置）
//
// 对应关系举例：请求 GET /public/uploads/2026-09-17/a.png → 返回磁盘文件 ./resource/public/uploads/2026-09-17/a.png
func SecureStatic(engine *gin.Engine, rootPath, rootDir string) {
	// 组装标准库静态文件处理器，只需创建一次（无状态，注册时构建，避免每个请求重复分配）。
	// 由内向外拆解：
	//   http.Dir(rootDir)        把磁盘目录 rootDir 抽象成文件系统（fs.FS 语义，天然限制只能访问该目录子树）
	//   http.FileServer(...)     标准库文件服务器：按请求路径在该文件系统中找文件并写出，
	//                            自动处理 Content-Type（按扩展名）、Last-Modified/If-Modified-Since 协商缓存
	//   http.StripPrefix(rootPath, ...)  把 URL 里的 rootPath 前缀剥掉再交给 FileServer：
	//                            请求 /public/uploads/a.png → 剥成 /uploads/a.png → FileServer 到 rootDir/uploads/a.png 找文件
	fileServer := http.StripPrefix(rootPath, http.FileServer(http.Dir(rootDir)))

	// 每个请求的实际处理逻辑：先做安全加头/校验，再委托给上面的标准库 FileServer 输出文件内容
	handler := func(c *gin.Context) {
		// 防 MIME 嗅探：要求浏览器严格按响应头里的 Content-Type 处理内容，
		// 不许"猜"（否则文本类响应可能被嗅探成 html/script 执行）
		c.Header("X-Content-Type-Options", "nosniff")

		// 取通配路由参数：路由注册为 /public/*filepath，此处拿到的是通配部分（自带前导 /，如 "/uploads/a.png"）
		// 前面再补一个 "/" 是防御参数为空的边界情况（此时变成 "/"，即根路径）；
		// path.Clean 做规范化：合并连续斜杠、消解 "." 与 ".."，输出保证以 / 开头的纯 URL 风格路径。
		// 注意这里用 path（URL 空间，恒为正斜杠）而不是 filepath（随操作系统变化，Windows 下是反斜杠）
		relPath := path.Clean("/" + c.Param("filepath"))

		// 把 URL 风格路径换算成磁盘路径用于存在性检查：
		// filepath.FromSlash 把 "/" 转成当前系统的分隔符（Windows 下 / → \），filepath.Join 拼接时还会再做一次清洗。
		// 前面 relPath 已规范化，这里 Join 不会逃出 rootDir（双重防护，FileServer 内部也有 ".." 拦截）
		fullPath := filepath.Join(rootDir, filepath.FromSlash(relPath))

		// 关闭目录列表：os.Stat 出错（文件/目录不存在）或目标是目录时一律 404。
		// 必须主动拦：标准库 FileServer 对目录请求默认会输出整个目录的索引页（文件清单泄露），
		// 这里把根路径 /public/、/public/uploads/ 之类的目录浏览全部打死
		if info, err := os.Stat(fullPath); err != nil || info.IsDir() {
			c.Status(http.StatusNotFound)
			return
		}

		// 内容型安全响应头只针对上传文件直出区（/uploads/ 前缀）；
		// resource/public 下的其他内容（如插件主题静态资源）不受影响
		if strings.HasPrefix(relPath, "/uploads/") {
			// 扩展名统一转小写后匹配（忽略 URL 中的大小写变化）
			switch strings.ToLower(path.Ext(relPath)) {
			case ".svg":
				// SVG 是可内嵌 <script> 的文本格式：直接在浏览器打开该 URL 时禁掉脚本与插件执行；
				// 通过 <img src="...svg"> 引用时浏览器本就不执行 svg 内脚本，因此 Logo 等存量引用显示不受影响
				c.Header("Content-Security-Policy", "script-src 'none'; object-src 'none'")
			case ".html", ".htm", ".xml", ".xhtml":
				// 这类文档型文件若被浏览器内联渲染，内嵌脚本会在站点域名下执行（存储型 XSS），
				// 强制浏览器下载而不是打开
				c.Header("Content-Disposition", "attachment")
			}
		}

		// 安头与校验都完成后，交给标准库 FileServer 完成真正的文件读取与响应输出
		fileServer.ServeHTTP(c.Writer, c.Request)
	}

	// 注册路由：通配参数名必须与上面 c.Param("filepath") 一致。
	// engine.Static 原本就同时注册 GET 和 HEAD，这里保持一致（HEAD 用于不拉取响应体的探测请求）
	engine.GET(rootPath+"/*filepath", handler)
	engine.HEAD(rootPath+"/*filepath", handler)
}
