@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ============================================================
REM 鲨鱼音乐（shark_music）一键初始化脚本
REM 双击本文件：建库 + 建表 + 导入种子数据
REM 顺序：init.sql -> song_data.sql -> home_data.sql
REM 注意：SQL 文件须与本脚本位于同一目录（即 sql 文件夹）
REM ============================================================

set "MYSQL_HOST=localhost"
set "MYSQL_PORT=3306"
set "MYSQL_USER=root"
set "MYSQL_PASS=123456"
set "SQL_DIR=%~dp0"

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
echo   鲨鱼音乐数据库初始化开始
echo ============================================================
echo.
echo [1/3] 执行 init.sql      （建库 shark_music + user 表）
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% --default-character-set=utf8mb4 < "%SQL_DIR%init.sql"
if errorlevel 1 ( echo [1/3] 失败 & goto :fail )

echo [2/3] 执行 song_data.sql （song 表 + 30 首歌曲）
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% --default-character-set=utf8mb4 < "%SQL_DIR%song_data.sql"
if errorlevel 1 ( echo [2/3] 失败 & goto :fail )

echo [3/3] 执行 home_data.sql （playlist / chart 等表 + 数据）
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% --default-character-set=utf8mb4 < "%SQL_DIR%home_data.sql"
if errorlevel 1 ( echo [3/3] 失败 & goto :fail )

echo.
echo ============================================================
echo   初始化完成！已建表并导入种子数据。
echo   双击 connect_local_db.bat 即可登录查看。
echo ============================================================
echo.
pause
exit /b 0

:fail
echo.
echo [错误] 初始化中断，请检查 MySQL 服务状态和 SQL 文件是否齐全。
pause
exit /b 1
