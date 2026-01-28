package imagehelper

import (
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"os"
	"path/filepath"
	"strings"

	_ "golang.org/x/image/webp"
)

// GenerateThumbnail 生成缩略图
// srcPath: 原图路径
// dstPath: 缩略图保存路径
// width: 缩略图宽度
// height: 缩略图高度
func GenerateThumbnail(srcPath, dstPath string, width, height int) error {
	// 打开原图文件
	srcFile, err := os.Open(srcPath)
	if err != nil {
		return fmt.Errorf("打开原图失败: %v", err)
	}
	defer srcFile.Close()

	// 解码图片
	img, format, err := image.Decode(srcFile)
	if err != nil {
		return fmt.Errorf("解码图片失败: %v", err)
	}

	// 创建缩略图
	thumbnail := resizeImage(img, width, height)

	// 确保目标目录存在
	dstDir := filepath.Dir(dstPath)
	if err := os.MkdirAll(dstDir, 0755); err != nil {
		return fmt.Errorf("创建目标目录失败: %v", err)
	}

	// 创建目标文件
	dstFile, err := os.Create(dstPath)
	if err != nil {
		return fmt.Errorf("创建缩略图文件失败: %v", err)
	}
	defer dstFile.Close()

	// 根据格式编码保存
	switch strings.ToLower(format) {
	case "jpeg", "jpg":
		err = jpeg.Encode(dstFile, thumbnail, &jpeg.Options{Quality: 85})
	case "png":
		err = png.Encode(dstFile, thumbnail)
	default:
		// 默认使用JPEG格式
		err = jpeg.Encode(dstFile, thumbnail, &jpeg.Options{Quality: 85})
	}

	if err != nil {
		return fmt.Errorf("保存缩略图失败: %v", err)
	}

	return nil
}

// resizeImage 调整图片大小
// 使用简单的缩放算法，保持宽高比
func resizeImage(src image.Image, width, height int) image.Image {
	srcBounds := src.Bounds()
	srcW := srcBounds.Dx()
	srcH := srcBounds.Dy()

	// 计算缩放比例
	scaleX := float64(width) / float64(srcW)
	scaleY := float64(height) / float64(srcH)
	scale := scaleX
	if scaleY < scaleX {
		scale = scaleY
	}

	// 计算实际缩放后的尺寸
	dstW := int(float64(srcW) * scale)
	dstH := int(float64(srcH) * scale)

	// 如果目标尺寸大于原图尺寸，直接返回原图
	if dstW >= srcW && dstH >= srcH {
		return src
	}

	// 创建目标图片
	dst := image.NewRGBA(image.Rect(0, 0, width, height))

	// 计算居中偏移量
	offsetX := (width - dstW) / 2
	offsetY := (height - dstH) / 2

	// 使用最近邻插值算法进行缩放
	for y := 0; y < dstH; y++ {
		for x := 0; x < dstW; x++ {
			// 计算原图中的对应坐标
			srcX := int(float64(x) / scale)
			srcY := int(float64(y) / scale)

			// 确保坐标在原图范围内
			if srcX >= srcW {
				srcX = srcW - 1
			}
			if srcY >= srcH {
				srcY = srcH - 1
			}

			// 获取像素并复制到目标图片
			dst.Set(x+offsetX, y+offsetY, src.At(srcX, srcY))
		}
	}

	return dst
}

// GenerateThumbnailName 生成缩略图文件名
// originalName: 原文件名
// width: 缩略图宽度
// height: 缩略图高度
// 返回: 缩略图文件名，如 w120_h120_test.jpg
func GenerateThumbnailName(originalName string, width, height int) string {
	ext := filepath.Ext(originalName)
	nameWithoutExt := strings.TrimSuffix(originalName, ext)
	return fmt.Sprintf("w%d_h%d_%s%s", width, height, nameWithoutExt, ext)
}

// IsImageFile 判断文件是否为图片
// filename: 文件名
// 返回: 是否为图片文件
func IsImageFile(filename string) bool {
	ext := strings.ToLower(filepath.Ext(filename))
	imageExts := []string{".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"}
	for _, imgExt := range imageExts {
		if ext == imgExt {
			return true
		}
	}
	return false
}
