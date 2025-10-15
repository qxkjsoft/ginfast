@echo off
REM Linux平台构建脚本 (Windows环境下构建Linux可执行文件)

echo 正在构建Linux平台下的可执行文件...

REM 设置Go环境变量
set GO111MODULE=on
set CGO_ENABLED=0
set GOOS=linux
set GOARCH=amd64

REM 构建Linux可执行文件
go build -o gin-fast-linux main.go

if %errorlevel% == 0 (
    echo Linux平台构建成功！
    echo 可执行文件: gin-fast-linux
) else (
    echo Linux平台构建失败！
    exit /b 1
)