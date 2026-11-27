@echo off
chcp 65001 >nul
title 鲨鱼音乐-后端

REM 清理会劫持 Spring Boot 端口的环境变量
set "SERVER__PORT="
set "SERVER__HOST="
set "SERVER_PORT="

cd /d "%~dp0"

echo ============================================
echo   鲨鱼音乐 · 后端 Spring Boot :8081
echo   目录：%CD%
echo   首次启动需下载依赖，可能要 1~2 分钟，请耐心等待
echo ============================================
echo.

call mvnw.cmd spring-boot:run -Dspring-boot.run.arguments=--server.port=8081

echo.
echo 后端已退出，按任意键关闭窗口...
pause >nul
