@echo off
echo ========================================
echo MySQL to SQL Server SQL Converter Build
echo ========================================
echo.

REM Set Go environment variables
set GO111MODULE=on
set CGO_ENABLED=0

echo Building...
go build -o mysql2sqlserver.exe main.go

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Build successful! Output: mysql2sqlserver.exe
    echo ========================================
    echo.
    echo Usage:
    echo   mysql2sqlserver.exe -input ^<MySQL file path^> -output ^<SQL Server output file path^>
    echo.
    echo Example:
    echo   mysql2sqlserver.exe -input resource/database/gin-fast-tenant.sql -output resource/database/sqlserver_converted.sql
    echo.
) else (
    echo.
    echo ========================================
    echo Build failed!
    echo ========================================
    exit /b 1
)

pause