-- ============================================================
-- 增量迁移：给 song 表添加 lyric 字段（LRC 歌词，可选）
-- 背景：Song 实体含 lyric 字段，但 song_data.sql 建表时漏了该列，
--       导致按全字段查询 song 的接口（歌手主页、搜索等）报
--       "Unknown column 'lyric' in 'field list'"。
-- 幂等：若列已存在则跳过，可重复执行。
-- 执行：mysql -uroot -p123456 --default-character-set=utf8mb4 shark_music < sql/alter_song_add_lyric.sql
-- ============================================================

USE shark_music;

SET @col_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'shark_music'
    AND TABLE_NAME = 'song'
    AND COLUMN_NAME = 'lyric'
);

SET @sql = IF(@col_exists = 0,
  'ALTER TABLE `song` ADD COLUMN `lyric` TEXT NULL COMMENT ''LRC 歌词（原创，带时间戳，空则前端无歌词）'' AFTER `url`;',
  'SELECT ''song.lyric 列已存在，跳过'' AS info;'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
