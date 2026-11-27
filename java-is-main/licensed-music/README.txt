鲨鱼音乐：自有音源 + 真实 LRC 导入目录
========================================

只放你自己拥有版权、或已获授权可用于本项目的音频与歌词。
本目录不会被程序自动扫描到公网，也不会从网络下载任何文件。

【文件命名】
    31.mp3      + 31.lrc
  或 31 - 起风了.mp3 + 31.lrc

数字就是 song 表里的 id。查 id 的方法：
    mysql -uroot -p123456 -D shark_music -e "SELECT id,title,artist FROM song WHERE title LIKE '%关键词%';"

LRC 必须是标准格式，至少有一行：
    [00:12.34]歌词内容

【导入】
双击：
    springBootTest\sql\import_licensed_music.bat

脚本会：
  1. 复制 mp3 到 shayu\public\music\licensed-{id}.mp3
  2. 把 LRC 写入 song.lyric
  3. 把 song.url 和四大榜单 url 指向新音源

导入后刷新页面即可。旧的 track-1..6.mp3 仍作为无版权演示音源保留，
不会被自动删除；被导入的歌曲会优先使用这里的真实音源。
