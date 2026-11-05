-- ============================================================
-- 增量迁移：给 song 表添加 url 字段（真实音源直链，可选）
-- 幂等：若列已存在则跳过
-- 执行：mysql -uroot -p123456 --default-character-set=utf8mb4 shark_music < sql/alter_song_add_url.sql
-- ============================================================

USE shark_music;

-- 仅当 url 列不存在时才添加
SET @col_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'shark_music'
    AND TABLE_NAME = 'song'
    AND COLUMN_NAME = 'url'
);

SET @sql = IF(@col_exists = 0,
  'ALTER TABLE `song` ADD COLUMN `url` VARCHAR(512) NULL COMMENT ''真实音源直链（可选，存在则优先播放）'' AFTER `duration`;',
  'SELECT ''song.url 列已存在，跳过'' AS info;'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
