@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

REM ============================================================
REM   鲨鱼音乐 · 一键安装脚本
REM   本脚本放 java-is-main 根目录或 shayu 目录下均可运行
REM   步骤：MySQL 建库导入 - 前端依赖 - 后端编译
REM ============================================================
echo.
echo ============================================
echo   鲨鱼音乐 · 一键安装脚本
echo   步骤：MySQL 建库导入 - 前端依赖 - 后端编译
echo ============================================
echo.

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
REM 1/4 定位 mysql.exe（按常见安装路径自动探测）
REM ============================================
set "MYSQL_EXE="
if exist "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" set "MYSQL_EXE=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
if exist "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" set "MYSQL_EXE=C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
if not defined MYSQL_EXE (
    where mysql >nul 2>&1 && set "MYSQL_EXE=mysql"
)
if not defined MYSQL_EXE (
    echo [错误] 未找到 mysql.exe，请确认已安装 MySQL 并加入 PATH。
    echo        或修改本脚本顶部的 MYSQL_EXE 为你的实际路径。
    pause
    exit /b 1
)
echo [1/4] MySQL 客户端：!MYSQL_EXE!
echo.

REM ============================================
REM 2/4 测试数据库连接（账号 root / 123456）
REM ============================================
"!MYSQL_EXE!" -uroot -p123456 -e "select version();" >nul 2>&1
if errorlevel 1 (
    echo [错误] MySQL 连接失败（root/123456）。请确认 MySQL 服务已启动、密码正确。
    pause
    exit /b 1
)
echo [2/4] MySQL 连接正常
echo.

REM ============================================
REM 3/4 依次导入三个 SQL（必须带 utf8mb4，否则中文乱码）
REM ============================================
for %%F in (init.sql home_data.sql song_data.sql) do (
    echo        正在导入 sql\%%F ...
    "!MYSQL_EXE!" -uroot -p123456 --default-character-set=utf8mb4 < "!BACKEND!\sql\%%F" 2>nul
    if errorlevel 1 (
        echo [错误] 导入 %%F 失败，请检查 MySQL 版本或手动执行该文件。
        pause
        exit /b 1
    )
)
"!MYSQL_EXE!" -uroot -p123456 --default-character-set=utf8mb4 -e "use shark_music; show tables;" 2>nul
echo [3/4] 数据库 shark_music 就绪（表结构 + 种子数据）
echo.

REM ============================================
REM 4/4 前端依赖安装 + 后端编译验证
REM ============================================
echo        正在安装前端依赖（npm install）...
pushd "!SHAYU!"
call npm install
if errorlevel 1 (
    echo [错误] npm install 失败，请确认已安装 Node.js（16 以上）。
    popd
    pause
    exit /b 1
)
popd
echo        前端依赖 OK
echo.

echo        正在编译后端（Maven）...
pushd "!BACKEND!"
call mvnw.cmd -q compile -DskipTests
if errorlevel 1 (
    echo [错误] 后端编译失败，请查看上方 Maven 报错。
    popd
    pause
    exit /b 1
)
popd
echo [4/4] 后端编译 OK（首次运行会自动下载 Maven，属正常现象）
echo.
echo ============================================
echo   安装完成！双击 start.bat 即可一键启动
echo   测试账号：testuser01 / abc12345
echo ============================================
pause
