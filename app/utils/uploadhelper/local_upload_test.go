package uploadhelper

import (
	"gin-fast/app/global/app"
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
)

// newLocalUploadServiceForTest 构造指向临时目录的本地上传服务（不依赖全局配置）
func newLocalUploadServiceForTest(t *testing.T) (*LocalUploadService, string) {
	t.Helper()
	root := t.TempDir()
	return &LocalUploadService{config: app.UploadConfig{LocalPath: root}}, root
}

func TestDeleteFile_AllowsFileInsideUploadRoot(t *testing.T) {
	svc, root := newLocalUploadServiceForTest(t)
	file := filepath.Join(root, "2025-09-18", "a.jpg")
	assert.NoError(t, os.MkdirAll(filepath.Dir(file), 0755))
	assert.NoError(t, os.WriteFile(file, []byte("x"), 0644))

	assert.NoError(t, svc.DeleteFile(file))
	_, err := os.Stat(file)
	assert.True(t, os.IsNotExist(err))
}

func TestDeleteFile_RejectsFileOutsideUploadRoot(t *testing.T) {
	svc, _ := newLocalUploadServiceForTest(t)
	// 根目录外另建一个真实存在的文件，删除请求必须被拒绝且文件保留
	outside := filepath.Join(t.TempDir(), "secret.txt")
	assert.NoError(t, os.WriteFile(outside, []byte("secret"), 0644))

	err := svc.DeleteFile(outside)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "上传目录之外")
	_, statErr := os.Stat(outside)
	assert.NoError(t, statErr)
}

func TestDeleteFile_RejectsTraversalPath(t *testing.T) {
	svc, root := newLocalUploadServiceForTest(t)
	// 在根目录父层真实放置文件，再经 ../ 穿越 pointing 它：os.Stat 命中后必须被根目录护栏拒绝
	outside := filepath.Join(filepath.Dir(root), "outside-secret.txt")
	assert.NoError(t, os.WriteFile(outside, []byte("secret"), 0644))
	t.Cleanup(func() { _ = os.Remove(outside) })

	err := svc.DeleteFile(filepath.Join(root, "..", "outside-secret.txt"))
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "上传目录之外")
	_, statErr := os.Stat(outside)
	assert.NoError(t, statErr)
}

func TestDeleteFile_RejectsRootItself(t *testing.T) {
	svc, root := newLocalUploadServiceForTest(t)
	err := svc.DeleteFile(root)
	assert.Error(t, err)
}

func TestDeleteFile_AllowsUrlFormInsideRoot(t *testing.T) {
	svc, root := newLocalUploadServiceForTest(t)
	// URL 形式走 getFilePathFromUrl 分支：日期文件夹+文件名需命中其提取正则
	file := filepath.Join(root, "2025-09-18", "20250918_uuid.jpg")
	assert.NoError(t, os.MkdirAll(filepath.Dir(file), 0755))
	assert.NoError(t, os.WriteFile(file, []byte("x"), 0644))

	assert.NoError(t, svc.DeleteFile("/api/uploads/2025-09-18/20250918_uuid.jpg"))
	_, err := os.Stat(file)
	assert.True(t, os.IsNotExist(err))
}
