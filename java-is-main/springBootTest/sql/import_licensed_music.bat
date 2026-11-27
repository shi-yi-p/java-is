@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
set "SQL_DIR=%~dp0"
set "PY=python"
where python >nul 2>&1 || set "PY=C:\Users\Administrator\.workbuddy\binaries\python\versions\3.13.12\python.exe"
set "MYSQL_EXE=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
if not exist "%MYSQL_EXE%" set "MYSQL_EXE=C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
if not exist "%MYSQL_EXE%" set "MYSQL_EXE=mysql"
set "SRC_DIR=%~dp0..\..\licensed-music"
if not "%~1"=="" set "SRC_DIR=%~1"

echo [1/3] scan %SRC_DIR%
"%PY%" "%SQL_DIR%import_licensed_music.py" "%SRC_DIR%" "%SQL_DIR%import_licensed_music.sql"
if errorlevel 1 goto :fail

echo [2/3] write database
"%MYSQL_EXE%" -uroot -p123456 --default-character-set=utf8mb4 -D shark_music < "%SQL_DIR%import_licensed_music.sql"
if errorlevel 1 goto :fail

echo [3/3] done. refresh the page to see real lyrics.
pause
exit /b 0

:fail
echo import failed. check messages above.
pause
exit /b 1
