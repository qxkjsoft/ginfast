# 设置Go环境变量
export GO111MODULE=on
export CGO_ENABLED=0
export GOOS=linux
export GOARCH=amd64

# 构建Linux可执行文件
go build -o gin-fast-linux main.go
