@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

REM ============================================================
REM   鲨鱼音乐 · 一键启动脚本
REM   本脚本放 java-is-main 根目录或 shayu 目录下均可运行
REM ============================================================
echo.
echo ============================================
echo   鲨鱼音乐 · 一键启动脚本
echo ============================================
echo.

REM 关键：清掉会劫持 Spring Boot 端口的环境变量（SERVER__PORT）
set "SERVER__PORT="
set "SERVER__HOST="
set "SERVER_PORT="

REM ---------- 自动定位项目根（兼容两种存放位置） ----------
set "SHAYU="
set "BACKEND="
if exist "%~dp0springBootTest" (
    set "SHAYU=%~dp0shayu"
    set "BACKEND=%~dp0springBootTest"
) else if exist "%~dp0..\springBootTest" (
    for %%i in ("%~dp0.") do set "SHAYU=%%~fi"
    for %%i in ("%~dp0..") do set "BACKEND=%%~fi\springBootTest"
) else (
    echo [错误] 未找到 springBootTest 后端目录。
    echo        请把本脚本放在 java-is-main 根目录或 shayu 目录下再运行。
    pause
    exit /b 1
)
echo   前端 shayu        = !SHAYU!
echo   后端 springBootTest = !BACKEND!
echo.

REM ============================================
REM 检查 8081 / 5173 是否已在监听
REM ============================================
set "BACK_UP="
netstat -ano | findstr /c:":8081" | findstr /c:"LISTENING" >nul 2>&1 && set "BACK_UP=1"
set "FRONT_UP="
netstat -ano | findstr /c:":5173" | findstr /c:"LISTENING" >nul 2>&1 && set "FRONT_UP=1"

REM ============================================
REM 启动后端（独立窗口，端口显式指定 8081）
REM ============================================
if not defined BACK_UP (
    echo [1/2] 启动后端 Spring Boot :8081 ...
    start "鲨鱼音乐-后端" cmd /k "chcp 65001 >nul && cd /d !BACKEND! && mvnw.cmd spring-boot:run -Dspring-boot.run.arguments=--server.port=8081"
) else (
    echo [1/2] 后端已在 8081 运行，跳过
)

REM ============================================
REM 启动前端（独立窗口）
REM ============================================
if not defined FRONT_UP (
    echo [2/2] 启动前端 Vite :5173 ...
    start "鲨鱼音乐-前端" cmd /k "chcp 65001 >nul && cd /d !SHAYU! && npm run dev"
) else (
    echo [2/2] 前端已在 5173 运行，跳过
)

REM ============================================
REM 等待后端就绪后打开浏览器（最多约 60 秒）
REM ============================================
echo.
echo        等待服务就绪（首次编译约需 20~40 秒）...
set /a WAIT=0
:CHECK_LOOP
ping -n 3 127.0.0.1 >nul
set /a WAIT+=3
netstat -ano | findstr /c:":8081" | findstr /c:"LISTENING" >nul 2>&1
if errorlevel 1 (
    if !WAIT! LSS 60 goto CHECK_LOOP
    echo [提示] 60 秒内后端未就绪，请查看后端窗口日志。浏览器仍将打开前端页面。
)
echo        正在打开浏览器...
start http://localhost:5173
echo.
echo ============================================
echo   已启动。关闭两个服务窗口即可停止前后端
echo   后端接口：http://localhost:8081/api
echo   测试账号：testuser01 / abc12345
echo ============================================
echo 本窗口可安全关闭。
ping -n 3 127.0.0.1 >nul
