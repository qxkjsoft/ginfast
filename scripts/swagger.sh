#!/bin/bash
# Linux/Mac下的Swagger文档生成脚本

# 设置Go模块支持
export GO111MODULE=on

# 生成Swagger文档
swag init -g main.go -o docs/swagger

echo "Swagger文档生成完成！"