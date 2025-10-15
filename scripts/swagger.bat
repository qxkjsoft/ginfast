@echo off
REM Windows下的Swagger文档生成脚本

REM 设置Go模块支持
set GO111MODULE=on

REM 生成Swagger文档
swag init -g main.go -o docs/swagger

echo Swagger文档生成完成！