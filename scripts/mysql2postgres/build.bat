@echo off
echo ========================================
echo MySQL to PostgreSQL SQL Converter Build
echo ========================================
echo.

REM Set Go environment variables
set GO111MODULE=on
set CGO_ENABLED=0

echo Building...
go build -o mysql2postgres.exe main.go

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Build successful! Output: mysql2postgres.exe
    echo ========================================
    echo.
    echo Usage:
    echo   mysql2postgres.exe -input ^<MySQL file path^> -output ^<PostgreSQL output file path^>
    echo.
    echo Example:
    echo   mysql2postgres.exe -input resource/database/gin-fast-tenant.sql -output resource/database/postgresql_converted.sql
    echo.
) else (
    echo.
    echo ========================================
    echo Build failed!
    echo ========================================
    exit /b 1
)

pause
