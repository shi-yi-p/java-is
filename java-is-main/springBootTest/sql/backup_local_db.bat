@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ============================================================
REM 鲨鱼音乐（shark_music）本地数据库备份脚本
REM 双击本文件：把本地库完整导出为 SQL 备份文件
REM 备份位置：本脚本同级的 backup 目录，文件名带日期时间，可重复执行
REM ============================================================

set "MYSQL_HOST=localhost"
set "MYSQL_PORT=3306"
set "MYSQL_USER=root"
set "MYSQL_PASS=123456"
set "MYSQL_DB=shark_music"

set "BACKUP_DIR=%~dp0backup"

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

if not exist "%DUMP_BIN%" (
  echo [错误] 未找到 mysqldump.exe（预期路径：%DUMP_BIN%）
  echo        请确认 MySQL 客户端工具已安装，或手动修改 MYSQL_BIN_DIR。
  pause
  exit /b 1
)

REM ---- 生成时间戳：年月日_时分秒 ----
set "TS_DATE=%date:~0,4%%date:~5,2%%date:~8,2%"
set "TS_HOUR=%time:~0,2%"
set "TS_HOUR=%TS_HOUR: =0%"
set "TS=%TS_DATE%_%TS_HOUR%%time:~3,2%%time:~6,2%"

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
set "BACKUP_FILE=%BACKUP_DIR%\shark_music_%TS%.sql"

echo ============================================================
echo   鲨鱼音乐数据库备份开始
echo   来源 : %MYSQL_HOST%:%MYSQL_PORT% / %MYSQL_DB%
echo   输出 : %BACKUP_FILE%
echo ============================================================
echo.

"%DUMP_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% --default-character-set=utf8mb4 --single-transaction --routines --triggers --events --hex-blob %MYSQL_DB% > "%BACKUP_FILE%"
if errorlevel 1 (
  echo.
  echo [失败] 备份出错，请确认 MySQL 服务已启动且账号密码正确。
  pause
  exit /b 1
)

for %%F in ("%BACKUP_FILE%") do set "SIZE=%%~zF"

echo.
echo ============================================================
echo   备份完成！
echo   文件 : %BACKUP_FILE%
echo   大小 : %SIZE% 字节
echo   恢复 : mysql -uroot -p123456 shark_music ^< 该备份文件
echo ============================================================
echo.
pause
exit /b 0
