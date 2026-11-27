#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
导入用户自备的有版权音源 + 真实 LRC 歌词。

配对规则（放在 java-is-main/licensed-music/ 下）：
    31.mp3      + 31.lrc
  或 31 - 起风了.mp3 + 31.lrc

脚本会：
  1. 复制 mp3 -> shayu/public/music/licensed-{id}.mp3
  2. 生成 SQL：更新 song.url / song.lyric，以及四大榜单 url
  3. 由同目录 import_licensed_music.bat 调用 mysql.exe 执行 SQL

不会从网络下载任何音乐文件；请只导入你有权使用的音频与歌词。
"""
import re
import shutil
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent          # java-is-main
DEFAULT_SRC = PROJECT_ROOT / "licensed-music"
MUSIC_DIR = PROJECT_ROOT / "shayu" / "public" / "music"
DEFAULT_SQL = SCRIPT_DIR / "import_licensed_music.sql"

MP3_RE = re.compile(r"^(\d+)(?:[^.]*)?\.mp3$", re.I)
LRC_TIME_RE = re.compile(r"^\s*\[\d{1,2}:\d{1,2}", re.M)
HOT_TABLES = ("kugou_hot_song", "netease_hot_song", "qq_hot_song", "douyin_hot_song")


def sql_str(value: str) -> str:
    """转义为 MySQL 单引号字符串，保留真实换行。"""
    v = value.replace("\\", "\\\\").replace("'", "\\'")
    v = v.replace("\r\n", "\n").replace("\r", "\n").replace("\n", "\\n")
    return "'" + v + "'"


def read_lrc(path: Path) -> str:
    for enc in ("utf-8-sig", "utf-8", "gbk", "gb18030"):
        try:
            return path.read_text(encoding=enc)
        except UnicodeDecodeError:
            continue
    raise RuntimeError("无法识别 LRC 编码：" + str(path))


def main() -> int:
    src = Path(sys.argv[1]).expanduser().resolve() if len(sys.argv) > 1 else DEFAULT_SRC.resolve()
    sql_path = Path(sys.argv[2]).expanduser().resolve() if len(sys.argv) > 2 else DEFAULT_SQL.resolve()

    print("[1/3] 扫描目录:", src)
    if not src.is_dir():
        print("ERROR: 目录不存在。请把自备音源放到该目录，或把目录作为参数传给 bat。")
        return 1

    MUSIC_DIR.mkdir(parents=True, exist_ok=True)
    pairs = []
    for mp3 in sorted(src.glob("*.mp3")):
        m = MP3_RE.match(mp3.name)
        if not m:
            print("  SKIP", mp3.name, "- 文件名需以数字歌曲 id 开头，如 31.mp3")
            continue
        sid = m.group(1)

        lrc = src / (sid + ".lrc")
        if not lrc.exists():
            lrc = mp3.with_suffix(".lrc")
        if not lrc.exists():
            print("  SKIP", mp3.name, "- 找不到配对 LRC（" + sid + ".lrc）")
            continue

        text = read_lrc(lrc)
        if not LRC_TIME_RE.search(text):
            print("  SKIP", mp3.name, "- LRC 里没有 [mm:ss] 时间戳行")
            continue
        pairs.append((sid, mp3, text))

    if not pairs:
        sql_path.write_text("-- 没有可导入的 mp3+lrc 配对\n", encoding="utf-8")
        print("[2/3] 未找到可导入的配对文件，SQL 已置空。")
        return 0

    sql_lines = [
        "-- 由 import_licensed_music.py 生成；仅导入用户自备的有版权音源",
        "SET NAMES utf8mb4;",
    ]
    print("[2/3] 开始导入", len(pairs), "首：")
    for sid, mp3, lrc_text in pairs:
        url = "/music/licensed-" + sid + ".mp3"
        target = MUSIC_DIR / ("licensed-" + sid + ".mp3")
        shutil.copy2(mp3, target)

        sql_lines.append(
            "UPDATE song SET url=" + sql_str(url) + ", lyric=" + sql_str(lrc_text)
            + " WHERE id=" + sid + ";"
        )
        for table in HOT_TABLES:
            sql_lines.append(
                "UPDATE " + table + " SET url=" + sql_str(url)
                + " WHERE song_id=" + sid + ";"
            )
        print("  id=" + sid + " -> " + target.name
              + " (" + str(mp3.stat().st_size) + " bytes), LRC " + str(len(lrc_text)) + " chars")

    sql_path.write_text("\n".join(sql_lines) + "\n", encoding="utf-8")
    print("[3/3] SQL 已生成:", sql_path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
