package uploadhelper

import (
	"fmt"
	"io"
	"mime/multipart"
	"path/filepath"
	"strings"

	"github.com/gabriel-vasile/mimetype"
)

// mimeExpectation 扩展名对应的内容类型期望
type mimeExpectation struct {
	exact    []string // 精确 MIME 匹配
	prefix   string   // 主类型前缀匹配（用于检测精度随库版本波动的格式，宽松防误杀）
	contains string   // 包含子串匹配
}

// extMimeExpectations 扩展名 → 期望内容类型（magic bytes 嗅探比对表）。
// 未列入的扩展名不做内容校验（扩展名白名单仍是第一道门）；
// .ico 为二进制图像容器、无脚本执行面，且检测精度有限，刻意不校验防误杀系统图标上传。
var extMimeExpectations = map[string]mimeExpectation{
	".jpg":  {exact: []string{"image/jpeg"}},
	".jpeg": {exact: []string{"image/jpeg"}},
	".png":  {exact: []string{"image/png"}},
	".gif":  {exact: []string{"image/gif"}},
	".bmp":  {exact: []string{"image/bmp"}},
	".webp": {exact: []string{"image/webp"}},
	".pdf":  {exact: []string{"application/pdf"}},
	".zip":  {exact: []string{"application/zip"}},
	".docx": {exact: []string{"application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/zip"}},
	".xlsx": {exact: []string{"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/zip"}},
	".rar":  {contains: "rar"},
	".txt":  {prefix: "text/"},
	".mp4":  {exact: []string{"video/mp4", "application/mp4"}},
	".avi":  {exact: []string{"video/x-msvideo"}, prefix: "video/"},
	".doc":  {prefix: "application/"},
	".xls":  {prefix: "application/"},
}

// rasterImageExts 位图扩展名集合：这些扩展名之间允许内容类型交叉（见 VerifyMagicNumber）
var rasterImageExts = map[string]bool{
	".jpg": true, ".jpeg": true, ".png": true, ".gif": true, ".bmp": true, ".webp": true,
}

// rasterImageMimes 真实位图内容类型集合（嗅探结果属于此集合即确认为无害位图）
var rasterImageMimes = map[string]bool{
	"image/jpeg": true, "image/png": true, "image/gif": true, "image/bmp": true, "image/webp": true,
}

// VerifyMagicNumber 校验文件内容的实际类型（magic bytes 嗅探）与扩展名声明是否一致，
// 防止伪造扩展名上传（如把 HTML/脚本伪装成图片）。比对表外的扩展名直接放行
func VerifyMagicNumber(ext string, r io.Reader) error {
	extLower := strings.ToLower(ext)
	expect, ok := extMimeExpectations[extLower]
	if !ok {
		return nil
	}

	m, err := mimetype.DetectReader(r)
	if err != nil {
		return fmt.Errorf("读取文件内容失败: %v", err)
	}
	// 剥离 "; charset=..." 等参数部分
	detected := strings.TrimSpace(strings.SplitN(m.String(), ";", 2)[0])

	// 位图扩展名之间交叉放行（如 PNG 内容存为 .jpg 的改名文件、前端裁剪导出场景）：
	// 威胁面是 HTML/脚本/SVG 等伪装图片，非位图内容不在此集合，仍走下方比对被拒绝
	if rasterImageExts[extLower] && rasterImageMimes[detected] {
		return nil
	}

	if expect.contains != "" && strings.Contains(detected, expect.contains) {
		return nil
	}
	if expect.prefix != "" && strings.HasPrefix(detected, expect.prefix) {
		return nil
	}
	for _, e := range expect.exact {
		if detected == e {
			return nil
		}
	}
	return fmt.Errorf("文件内容与扩展名不符（实际类型: %s）", detected)
}

// VerifyFileMagic 打开上传文件进行内容嗅探（multipart.FileHeader 每次 Open 均为独立句柄，不影响后续保存读取）
func VerifyFileMagic(file *multipart.FileHeader) error {
	f, err := file.Open()
	if err != nil {
		return fmt.Errorf("打开文件失败: %v", err)
	}
	defer f.Close()
	return VerifyMagicNumber(filepath.Ext(file.Filename), f)
}
