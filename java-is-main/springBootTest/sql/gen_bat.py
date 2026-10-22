# -*- coding: utf-8 -*-
"""生成三个双击即用脚本：connect_local_db.bat / init_db.bat / backup_local_db.bat
以 UTF-8 BOM 写出，保证 cmd 下中文正常显示。
连接信息取自 application-dev.properties：root / 123456 / localhost:3306 / shark_music
"""
import io, os

SQL_DIR = os.path.dirname(os.path.abspath(__file__))

# 公共：定位 MySQL 的 bin 目录（MYSQL_BIN_DIR 末尾带反斜杠），据此得到 mysql.exe / mysqldump.exe
DETECT = r'''
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
'''

HEADER = r'''@echo off
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
'''

# ---------- 1) 连接脚本：先 SHOW TABLES，再进入交互模式停留 ----------
CONNECT_BAT = HEADER + DETECT + r'''
echo ============================================================
echo   鲨鱼音乐本地数据库 - 连接中
echo   主机   : %MYSQL_HOST%:%MYSQL_PORT%
echo   账号   : %MYSQL_USER%
echo   数据库 : %MYSQL_DB%
echo ============================================================
echo.

REM 先执行一次 SHOW TABLES，把当前库的表清单显示出来
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% --default-character-set=gbk %MYSQL_DB% -e "SHOW TABLES;"
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
"%MYSQL_BIN%" -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% --default-character-set=gbk %MYSQL_DB%
'''

# ---------- 2) 初始化脚本 ----------
INIT_BAT = r'''@echo off
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
''' + DETECT + r'''
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
'''

# ---------- 3) 备份脚本：导出本地库为 SQL 文件 ----------
BACKUP_BAT = r'''@echo off
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
''' + DETECT + r'''
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
'''


def write_utf8_nobom(path, content):
    # 关键点：必须 UTF-8【无 BOM】。
    # 带 BOM 时 cmd 会按 GBK 误读 BOM 字节，导致首行 @echo off 失效、中文变乱码。
    # 无 BOM 时前几行（ASCII）可正常解析，随后 chcp 65001 切到 UTF-8，中文即正确显示。
    with io.open(path, "w", encoding="utf-8", newline="\r\n") as f:
        f.write(content)


write_utf8_nobom(os.path.join(SQL_DIR, "connect_local_db.bat"), CONNECT_BAT)
write_utf8_nobom(os.path.join(SQL_DIR, "init_db.bat"), INIT_BAT)
write_utf8_nobom(os.path.join(SQL_DIR, "backup_local_db.bat"), BACKUP_BAT)
print("OK: connect_local_db.bat / init_db.bat / backup_local_db.bat 已生成于", SQL_DIR)
