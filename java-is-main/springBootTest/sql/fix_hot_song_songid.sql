-- ============================================================
-- 修复「热歌榜歌曲无法收藏」问题
-- 根因：4 张热歌表（netease/qq/kugou/douyin_hot_song）的歌曲
--       未并入主曲库 song 表，导致后端 SongIdResolver 按
--       title+artist 反查失败，songId 全部为 null，
--       前端 songIdOf() 返回空 → 收藏静默失败。
-- 方案：把热歌并入 song 主曲库，给热歌表加 song_id 列并回填。
-- 执行前请先备份：见 sql/backup/ 目录。
-- ============================================================

USE shark_music;

-- ---------- 1. 给 4 张热歌表增加 song_id 关联列 ----------
ALTER TABLE netease_hot_song ADD COLUMN song_id bigint NULL COMMENT '关联主曲库 song.id' AFTER deleted;
ALTER TABLE qq_hot_song      ADD COLUMN song_id bigint NULL COMMENT '关联主曲库 song.id' AFTER deleted;
ALTER TABLE kugou_hot_song   ADD COLUMN song_id bigint NULL COMMENT '关联主曲库 song.id' AFTER deleted;
ALTER TABLE douyin_hot_song  ADD COLUMN song_id bigint NULL COMMENT '关联主曲库 song.id' AFTER deleted;

-- ---------- 2. 把 4 张热歌表歌曲并入主曲库 song 表 ----------
-- 利用 uk_title_artist 唯一键，重复则忽略（不覆盖已有数据）。
INSERT IGNORE INTO song (title, artist, album, duration, url)
SELECT title, artist, album, duration, url FROM netease_hot_song WHERE deleted = 0;

INSERT IGNORE INTO song (title, artist, album, duration, url)
SELECT title, artist, album, duration, url FROM qq_hot_song WHERE deleted = 0;

INSERT IGNORE INTO song (title, artist, album, duration, url)
SELECT title, artist, album, duration, url FROM kugou_hot_song WHERE deleted = 0;

INSERT IGNORE INTO song (title, artist, album, duration, url)
SELECT title, artist, album, duration, url FROM douyin_hot_song WHERE deleted = 0;

-- ---------- 3. 回填各热歌表的 song_id ----------
UPDATE netease_hot_song h JOIN song s
  ON TRIM(h.title) = TRIM(s.title) AND TRIM(h.artist) = TRIM(s.artist)
SET h.song_id = s.id;

UPDATE qq_hot_song h JOIN song s
  ON TRIM(h.title) = TRIM(s.title) AND TRIM(h.artist) = TRIM(s.artist)
SET h.song_id = s.id;

UPDATE kugou_hot_song h JOIN song s
  ON TRIM(h.title) = TRIM(s.title) AND TRIM(h.artist) = TRIM(s.artist)
SET h.song_id = s.id;

UPDATE douyin_hot_song h JOIN song s
  ON TRIM(h.title) = TRIM(s.title) AND TRIM(h.artist) = TRIM(s.artist)
SET h.song_id = s.id;

-- ---------- 4. 校验：应全部非空 ----------
SELECT 'netease' AS src, COUNT(*) AS total, COUNT(song_id) AS linked FROM netease_hot_song WHERE deleted = 0
UNION ALL SELECT 'qq', COUNT(*), COUNT(song_id) FROM qq_hot_song WHERE deleted = 0
UNION ALL SELECT 'kugou', COUNT(*), COUNT(song_id) FROM kugou_hot_song WHERE deleted = 0
UNION ALL SELECT 'douyin', COUNT(*), COUNT(song_id) FROM douyin_hot_song WHERE deleted = 0;
