@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ============================================================
REM 鲨鱼音乐（shark_music）本地数据库工具
REM 连接信息取自 springBootTest/src/main/resources/application-dev.properties
REM ============================================================

set "MYSQL_HOST=localhost"
set "MYSQL_PORT=3306"
set "MYSQL_USER=root"
set "MYSQL_PASS=123456"
set "MYSQL_DB=shark_music"

set "MYSQL_BIN_DIR="
if exist "%ProgramFiles%\MySQL\MySQL Server 8.4\bin\mysql.exe" set "MYSQL_BIN_DIR=%ProgramFiles%\MySQL\MySQL Server 8.4\bin\"
if not defined MYSQL_BIN_DIR if exist "%ProgramFiles%\MySQL\MySQL Server 8.0\bin\mysql.exe" set "MYSQL_BIN_DIR=%ProgramFiles%\MySQL\MySQL Server 8.0\bin\"
if not defined MYSQL_BIN_DIR if exist "%ProgramFiles%\MySQL\MySQL Server 5.7\bin\mysql.exe" set "MYSQL_BIN_DIR=%ProgramFiles%\MySQL\MySQL Server 5.7\bin\"
if not defined MYSQL_BIN_DIR if exist "%ProgramFiles(x86)%\MySQL\MySQL Server 8.0\bin\mysql.exe" set "MYSQL_BIN_DIR=%ProgramFiles(x86)%\MySQL\MySQL Server 8.0\bin\"
if not defined MYSQL_BIN_DIR (
  for /f "delims=" %%i in ('where mysql 2^>nul') do if not defined MYSQL_BIN_DIR set "MYSQL_BIN_DIR=%%~dpi"
)

if not defined MYSQL_BIN_DIR (
  echo [错误] 未找到 mysql.exe，请手动修改本脚本顶部的 MYSQL_BIN_DIR 路径。
  pause
  exit /b 1
)

set "MYSQL_BIN=%MYSQL_BIN_DIR%mysql.exe"
set "DUMP_BIN=%MYSQL_BIN_DIR%mysqldump.exe"

echo ============================================================
echo   鲨鱼音乐本地数据库 - 连接中
echo   主机   : %MYSQL_HOST%:%MYSQL_PORT%
echo   账号   : %MYSQL_USER%
echo   数据库 : %MYSQL_DB%
echo ============================================================
echo.

REM 先执行一次 SHOW TABLES，把当前库的表清单显示出来
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% --default-character-set=utf8mb4 %MYSQL_DB% -e "SHOW TABLES;"
if errorlevel 1 (
  echo.
  echo [失败] 连接出错。请确认：MySQL 服务已启动、账号密码正确、
  echo        且数据库 %MYSQL_DB% 已存在（可先双击 init_db.bat 初始化）。
  pause
  exit /b 1
)

echo.
echo ------------------------------------------------------------
echo   已进入 MySQL 交互模式，可继续输入 SQL。
echo   输入 exit; 并按回车，或按 Ctrl+C 退出。
echo ------------------------------------------------------------
echo.

REM 再启动交互式会话并停留，用户可继续敲 SQL
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% --default-character-set=utf8mb4 %MYSQL_DB%
