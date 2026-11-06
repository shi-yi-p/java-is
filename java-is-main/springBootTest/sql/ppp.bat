@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ============================================================
REM 鲨鱼音乐（shark_music）一键导入完整数据库脚本
REM 双击本文件：删除旧库 -> 重建 -> 导入 shark_music.sql 完整备份
REM 作用：恢复全部数据（含已注册账号，如 123），彻底解决"每次都要重新注册"问题
REM 注意：本脚本会清空并重建 shark_music 库，请确认无误后再执行
REM ============================================================

set "MYSQL_HOST=localhost"
set "MYSQL_PORT=3306"
set "MYSQL_USER=root"
set "MYSQL_PASS=123456"
set "MYSQL_DB=shark_music"
set "SQL_DIR=%~dp0"

REM ---------- 自动探测 mysql.exe 路径 ----------
set "MYSQL_BIN_DIR="
if exist "%ProgramFiles%\MySQL\MySQL Server 8.4\bin\mysql.exe" set "MYSQL_BIN_DIR=%ProgramFiles%\MySQL\MySQL Server 8.4\bin\"
if not defined MYSQL_BIN_DIR if exist "%ProgramFiles%\MySQL\MySQL Server 8.0\bin\mysql.exe" set "MYSQL_BIN_DIR=%ProgramFiles%\MySQL\MySQL Server 8.0\bin\"
if not defined MYSQL_BIN_DIR if exist "%ProgramFiles%\MySQL\MySQL Server 5.7\bin\mysql.exe" set "MYSQL_BIN_DIR=%ProgramFiles%\MySQL\MySQL Server 5.7\bin\"
if not defined MYSQL_BIN_DIR if exist "%ProgramFiles(x86)%\MySQL\MySQL Server 8.0\bin\mysql.exe" set "MYSQL_BIN_DIR=%ProgramFiles(x86)%\MySQL\MySQL Server 8.0\bin\"
if not defined MYSQL_BIN_DIR (
  for /f "delims=" %%i in ('where mysql 2^>nul') do if not defined MYSQL_BIN_DIR set "MYSQL_BIN_DIR=%%~dpi"
)
if not defined MYSQL_BIN_DIR (
  echo [错误] 未找到 mysql.exe，请确认已安装 MySQL 并加入 PATH。
  pause
  exit /b 1
)
set "MYSQL_BIN=%MYSQL_BIN_DIR%mysql.exe"

echo ============================================================
echo   鲨鱼音乐数据库一键导入
echo ============================================================
echo.
echo   主机   : %MYSQL_HOST%:%MYSQL_PORT%
echo   账号   : %MYSQL_USER%
echo   数据库 : %MYSQL_DB%
echo   备份源 : %SQL_DIR%shark_music.sql
echo.

REM ---------- 检查备份文件是否存在 ----------
if not exist "%SQL_DIR%shark_music.sql" (
  echo [错误] 未找到 %SQL_DIR%shark_music.sql
  echo        请确认该完整备份文件与本脚本位于同一目录。
  pause
  exit /b 1
)

REM ---------- 二次确认（因会清空重建） ----------
set /p CONFIRM=警告：将删除并重建 %MYSQL_DB% 库！确认继续？(输入 Y 继续，其他键取消)：
if /i not "%CONFIRM%"=="Y" (
  echo 已取消，未做任何改动。
  pause
  exit /b 0
)

echo.
echo [1/3] 测试 MySQL 连接 ...
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% -e "select 1;" >nul 2>&1
if errorlevel 1 (
  echo [1/3] 连接失败，请确认 MySQL 服务已启动、账号密码正确。
  goto :fail
)
echo [1/3] 连接正常

echo [2/3] 删除旧库 %MYSQL_DB% ...
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% -e "DROP DATABASE IF EXISTS %MYSQL_DB%;" 2>nul
if errorlevel 1 ( echo [2/3] 失败 & goto :fail )
echo [2/3] 旧库已删除

echo [2.5/3] 新建数据库 %MYSQL_DB% ...
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% -e "CREATE DATABASE %MYSQL_DB% DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;" 2>nul
if errorlevel 1 ( echo [2.5/3] 失败 & goto :fail )
echo [2.5/3] 数据库已创建

echo [3/3] 导入完整备份 shark_music.sql ...
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% --default-character-set=utf8mb4 %MYSQL_DB% < "%SQL_DIR%shark_music.sql" 2>nul
if errorlevel 1 ( echo [3/3] 导入失败 & goto :fail )
echo [3/3] 导入完成

echo.
echo ============================================================
echo   导入成功！
echo   已恢复全部数据（含已注册账号，如 123 / 12345678）。
echo   双击 connect_local_db.bat 可登录查看。
echo ============================================================
echo.
pause
exit /b 0

:fail
echo.
echo [错误] 导入中断。请检查：MySQL 服务状态、账号密码、备份文件完整性。
pause
exit /b 1
