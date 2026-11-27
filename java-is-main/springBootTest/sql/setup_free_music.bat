@echo off
chcp 65001 >nul
REM ============================================================
REM  鲨鱼音乐：下载免费授权音源 + 写入曲库 url
REM  音源：SoundHelix 公开示例音乐（仅用于开发/测试，非商业发行）
REM  deps: curl (Win10 1803+), mysql.exe
REM  run: double-click this file
REM ============================================================
setlocal enabledelayedexpansion
set "MUSIC_DIR=%~dp0..\..\shayu\public\music"
set "MYSQL_EXE=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
if not exist "%MYSQL_EXE%" set "MYSQL_EXE=C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
if not exist "%MYSQL_EXE%" set "MYSQL_EXE=mysql"

echo [1/3] download free music to  %MUSIC_DIR%
if not exist "%MUSIC_DIR%" mkdir "%MUSIC_DIR%"
for /L %%i in (1,1,6) do (
    if not exist "%MUSIC_DIR%\track-%%i.mp3" (
        echo   下载 track-%%i.mp3 ...
        curl -sL -o "%MUSIC_DIR%\track-%%i.mp3" "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-%%i.mp3"
    )
)
echo [2/3] update database url (song + 4 charts)
"%MYSQL_EXE%" -uroot -p123456 --default-character-set=utf8mb4 -D shark_music -e "UPDATE song SET url=CONCAT('/music/track-',((id-1)%%6)+1,'.mp3'); UPDATE kugou_hot_song SET url=CONCAT('/music/track-',((song_id-1)%%6)+1,'.mp3') WHERE song_id IS NOT NULL; UPDATE netease_hot_song SET url=CONCAT('/music/track-',((song_id-1)%%6)+1,'.mp3') WHERE song_id IS NOT NULL; UPDATE qq_hot_song SET url=CONCAT('/music/track-',((song_id-1)%%6)+1,'.mp3') WHERE song_id IS NOT NULL; UPDATE douyin_hot_song SET url=CONCAT('/music/track-',((song_id-1)%%6)+1,'.mp3') WHERE song_id IS NOT NULL;"
echo [3/3] done! restart backend for /music/** mapping.
pause
