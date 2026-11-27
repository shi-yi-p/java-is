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
REM 自动获取本机局域网 IPv4（用于局域网访问）
REM 优先取 192.168.x / 10.x / 172.16-31.x 网段；取不到则回退 localhost
REM ============================================
set "LAN_IP="
set "IP_192="
set "IP_OTHER="
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do (
    for /f "tokens=1 delims= " %%b in ("%%a") do (
        set "CAND=%%b"
        if /i "!CAND!" neq "127.0.0.1" (
            REM 取第一个 192.168.x（ipconfig 中主网卡 WiFi/以太网排在虚拟网卡前）
            if not defined IP_192 (
                echo !CAND! | findstr /b "192.168." >nul && set "IP_192=!CAND!"
            )
            REM 其余私有网段（10.x / 172.16-31.x）作为备选
            if not defined IP_OTHER (
                echo !CAND! | findstr /b "10." >nul && set "IP_OTHER=!CAND!"
            )
            if not defined IP_OTHER (
                echo !CAND! | findstr /r /b "172\.[1-3][0-9]\." >nul && set "IP_OTHER=!CAND!"
            )
        )
    )
)
REM 优先级：192.168.x > 其他私有网段 > localhost
if defined IP_192 (
    set "LAN_IP=!IP_192!"
) else if defined IP_OTHER (
    set "LAN_IP=!IP_OTHER!"
) else (
    set "LAN_IP=localhost"
)
echo   局域网访问地址 = http://!LAN_IP!:5173
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
    REM 直接启动独立 bat，不依赖 bash，也不用 cmd /k 嵌套长命令
    start "鲨鱼音乐-后端" "!BACKEND!\start-backend.bat"
) else (
    echo [1/2] 后端已在 8081 运行，跳过
)

REM ============================================
REM 启动前端（独立窗口）
REM ============================================
if not defined FRONT_UP (
    echo [2/2] 启动前端 Vite :5173 ...
    start "鲨鱼音乐-前端" "!SHAYU!\start-frontend.bat"
) else (
    echo [2/2] 前端已在 5173 运行，跳过
)

REM ============================================
REM 等待后端就绪后打开浏览器（最多约 120 秒）
REM ============================================
echo.
echo        等待服务就绪（首次运行需下载依赖，可能要 1~2 分钟）...
set /a WAIT=0
:CHECK_LOOP
ping -n 2 127.0.0.1 >nul
set /a WAIT+=2
netstat -ano | findstr /c:":8081" | findstr /c:"LISTENING" >nul 2>&1
if errorlevel 1 (
    if !WAIT! LSS 120 goto CHECK_LOOP
    echo [警告] 120 秒内后端仍未监听 8081，请查看"鲨鱼音乐-后端"窗口日志。浏览器仍将打开前端页面。
)
echo        正在打开浏览器...
start http://!LAN_IP!:5173
echo.
echo ============================================
echo   已启动。关闭两个服务窗口即可停止前后端
echo   本机访问：http://localhost:5173
echo   局域网访问：http://!LAN_IP!:5173
echo   后端接口：http://localhost:8081/api
echo ============================================
echo 本窗口可安全关闭。
ping -n 3 127.0.0.1 >nul
