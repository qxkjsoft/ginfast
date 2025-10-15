#!/bin/bash

# Linux平台构建脚本

echo "正在构建Linux平台下的可执行文件..."

# 设置Go环境变量
export GO111MODULE=on
export CGO_ENABLED=0
export GOOS=linux
export GOARCH=amd64

# 构建Linux可执行文件
go build -o gin-fast-linux main.go

if [ $? -eq 0 ]; then
    echo "Linux平台构建成功！"
    echo "可执行文件: gin-fast-linux"
else
    echo "Linux平台构建失败！"
    exit 1
fi