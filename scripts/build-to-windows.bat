@echo off
chcp 65001 >nul
echo ========================================
echo 开始编译 Windows 可执行文件...
echo ========================================

set GO111MODULE=on
set CGO_ENABLED=0
set GOOS=windows
set GOARCH=amd64

set OUTPUT_DIR=dist
set OUTPUT_NAME=gin-fast-windows.exe

if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
    echo 创建输出目录: %OUTPUT_DIR%
)

echo.
echo 编译参数:
echo   GOOS=%GOOS%
echo   GOARCH=%GOARCH%
echo   CGO_ENABLED=%CGO_ENABLED%
echo.

go build -o "%OUTPUT_DIR%/%OUTPUT_NAME%" -ldflags="-s -w" main.go

if %ERRORLEVEL% EQU 0 (
    call :build_success
) else (
    call :build_failure
)
goto :eof

:build_success
echo.
echo ========================================
echo 编译成功！
echo 输出文件: %OUTPUT_DIR%\%OUTPUT_NAME%
echo ========================================
goto :eof

:build_failure
echo.
echo ========================================
echo 编译失败！
echo ========================================
goto :eof

pause
