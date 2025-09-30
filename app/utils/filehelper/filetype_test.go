package filehelper

import (
	"gin-fast/app/global/consts"
	"testing"
)

func TestGetFileTypeBySuffix(t *testing.T) {
	// 测试图片类型
	if fileType := GetFileTypeBySuffix(".jpg"); fileType != consts.UploadFileTypeImage {
		t.Errorf("Expected image type for .jpg, got %s", fileType)
	}

	if fileType := GetFileTypeBySuffix("png"); fileType != consts.UploadFileTypeImage {
		t.Errorf("Expected image type for png, got %s", fileType)
	}

	// 测试视频类型
	if fileType := GetFileTypeBySuffix(".mp4"); fileType != consts.UploadFileTypeVideo {
		t.Errorf("Expected video type for .mp4, got %s", fileType)
	}

	// 测试音频类型
	if fileType := GetFileTypeBySuffix(".mp3"); fileType != consts.UploadFileTypeAudio {
		t.Errorf("Expected audio type for .mp3, got %s", fileType)
	}

	// 测试文档类型
	if fileType := GetFileTypeBySuffix(".pdf"); fileType != consts.UploadFileTypeDocument {
		t.Errorf("Expected document type for .pdf, got %s", fileType)
	}

	// 测试压缩文件类型
	if fileType := GetFileTypeBySuffix(".zip"); fileType != "archive" {
		t.Errorf("Expected archive type for .zip, got %s", fileType)
	}

	// 测试未知类型
	if fileType := GetFileTypeBySuffix(".xyz"); fileType != consts.UploadFileTypeOther {
		t.Errorf("Expected other type for .xyz, got %s", fileType)
	}
}
