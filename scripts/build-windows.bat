
set GO111MODULE=on
set CGO_ENABLED=0
set GOOS=linux
set GOARCH=amd64

go build -o gin-fast-linux main.go

