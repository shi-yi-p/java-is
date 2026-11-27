@echo off
chcp 65001 >nul
title 鲨鱼音乐-前端

cd /d "%~dp0"

echo ============================================
echo   鲨鱼音乐 · 前端 Vite :5173
echo   目录：%CD%
echo ============================================
echo.

npm run dev

echo.
echo 前端已退出，按任意键关闭窗口...
pause >nul
