#!/bin/bash

echo "========================================"
echo "开始编译 Linux 可执行文件..."
echo "========================================"

# 设置Go环境变量
export GO111MODULE=on
export CGO_ENABLED=0
export GOOS=linux
export GOARCH=amd64

OUTPUT_DIR="dist"
OUTPUT_NAME="gin-fast-linux"

# 创建输出目录
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
    echo "创建输出目录: $OUTPUT_DIR"
fi

echo ""
echo "编译参数:"
echo "  GOOS=$GOOS"
echo "  GOARCH=$GOARCH"
echo "  CGO_ENABLED=$CGO_ENABLED"
echo ""

# 构建Linux可执行文件
go build -o "$OUTPUT_DIR/$OUTPUT_NAME" -ldflags="-s -w" main.go

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "编译成功！"
    echo "输出文件: $OUTPUT_DIR/$OUTPUT_NAME"
    echo "========================================"
else
    echo ""
    echo "========================================"
    echo "编译失败！"
    echo "========================================"
    exit 1
fi
