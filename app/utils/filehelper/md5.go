package filehelper

import (
	"crypto/md5"
	"encoding/hex"
	"io"
	"os"
)

// CalculateFileMD5 流式计算文件内容的 MD5，返回 32 位小写十六进制字符串。
// 用于分片上传完整性校验与秒传复核；文件不存在或读取失败时返回错误
func CalculateFileMD5(path string) (string, error) {
	f, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer f.Close()

	hasher := md5.New()
	if _, err := io.Copy(hasher, f); err != nil {
		return "", err
	}
	return hex.EncodeToString(hasher.Sum(nil)), nil
}
