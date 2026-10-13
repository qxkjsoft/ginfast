package models

import (
	"mime/multipart"
	"strings"
	"testing"

	"github.com/gookit/validate"
	"github.com/stretchr/testify/assert"
)

func validChunkUploadRequest(uploadId string) *ChunkUploadRequest {
	return &ChunkUploadRequest{
		File:        &multipart.FileHeader{},
		UploadId:    uploadId,
		ChunkIndex:  1,
		TotalChunks: 3,
	}
}

func TestChunkUploadRequestUploadIdFormat(t *testing.T) {
	tests := []struct {
		name     string
		uploadId string
		want     bool
	}{
		{"服务端生成的标准格式", "upload_1725000000_ab12cd34", true},
		{"纯UUID", "5f2c9a7b-1e4d-4c3a-9b8e-2a7f6d5c4b3a", true},
		{"字母数字下划线", "abcDEF_012-xyz", true},
		{"路径穿越", "../../..", false},
		{"含斜杠", "a/b", false},
		{"Windows反斜杠", "..\\..\\x", false},
		{"含空格", "abc def", false},
		{"超长", strings.Repeat("a", 65), false},
		{"空串", "", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			v := validate.Struct(validChunkUploadRequest(tt.uploadId))
			assert.Equal(t, tt.want, v.Validate())
		})
	}
}

func TestChunkMergeRequestUploadIdFormat(t *testing.T) {
	req := &ChunkMergeRequest{
		UploadId:    "../../..",
		FileMd5:     "d41d8cd98f00b204e9800998ecf8427e",
		FileName:    "test.zip",
		FileSize:    1024,
		TotalChunks: 2,
	}
	v := validate.Struct(req)
	assert.False(t, v.Validate(), "路径穿越的 uploadId 应校验失败")

	req.UploadId = "upload_1725000000_ab12cd34"
	v = validate.Struct(req)
	assert.True(t, v.Validate())
}

func TestChunkCancelRequestUploadIdFormat(t *testing.T) {
	req := &ChunkCancelRequest{UploadId: "a/b"}
	v := validate.Struct(req)
	assert.False(t, v.Validate(), "含路径分隔符的 uploadId 应校验失败")

	req.UploadId = "upload_1725000000_ab12cd34"
	v = validate.Struct(req)
	assert.True(t, v.Validate())
}

// TestChunkUploadRequestMd5Format 分片上传的可选 MD5 字段：空值合法，非空必须为 32 位十六进制
func TestChunkUploadRequestMd5Format(t *testing.T) {
	validMd5 := "d41d8cd98f00b204e9800998ecf8427e"
	tests := []struct {
		name     string
		chunkMd5 string
		fileMd5  string
		want     bool
	}{
		{"均为空_合法", "", "", true},
		{"标准32位小写", validMd5, validMd5, true},
		{"32位大写合法", strings.ToUpper(validMd5), strings.ToUpper(validMd5), true},
		{"chunkMd5为31位", validMd5[:31], "", false},
		{"fileMd5含非hex字符", "", "g41d8cd98f00b204e9800998ecf8427", false},
		{"fileMd5超长", validMd5 + "ff", "", false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			req := validChunkUploadRequest("upload_1725000000_ab12cd34")
			req.ChunkMd5 = tt.chunkMd5
			req.FileMd5 = tt.fileMd5
			v := validate.Struct(req)
			assert.Equal(t, tt.want, v.Validate())
		})
	}
}

// TestChunkInitRequestMd5AndRange 初始化请求的 FileMd5 格式与 TotalChunks/ChunkIndex 下界校验
func TestChunkInitRequestMd5AndRange(t *testing.T) {
	validMd5 := "d41d8cd98f00b204e9800998ecf8427e"
	req := &ChunkInitRequest{
		FileMd5:     validMd5,
		FileName:    "test.zip",
		FileSize:    1024,
		ChunkSize:   5 * 1024 * 1024,
		TotalChunks: 2,
	}
	assert.True(t, validate.Struct(req).Validate())

	// FileMd5 非法格式
	req.FileMd5 = "not-md5"
	assert.False(t, validate.Struct(req).Validate(), "非法 FileMd5 应校验失败")

	// TotalChunks 为 0
	req.FileMd5 = validMd5
	req.TotalChunks = 0
	assert.False(t, validate.Struct(req).Validate(), "TotalChunks 为 0 应校验失败")

	// ChunkIndex 为 0 / 负数
	upload := validChunkUploadRequest("upload_1725000000_ab12cd34")
	upload.ChunkIndex = 0
	assert.False(t, validate.Struct(upload).Validate(), "ChunkIndex 为 0 应校验失败")
	upload.ChunkIndex = -1
	assert.False(t, validate.Struct(upload).Validate(), "ChunkIndex 为负数应校验失败")
}
