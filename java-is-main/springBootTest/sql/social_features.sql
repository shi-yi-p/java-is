-- ============================================================
-- 鲨鱼音乐 · 社交互动与听歌时长统计
-- 1) play_history 增加 duration 字段（收听秒数），用于统计听歌时长/等级/总排名
-- 2) 新建论坛帖子表 forum_post
-- 3) 新建论坛评论表 forum_comment
-- 4) 新建聊天室消息表 chat_message
-- ============================================================

USE shark_music;

-- ---------- 1) 播放历史加时长字段（幂等：列已存在则跳过） ----------
SET @col_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'shark_music'
    AND TABLE_NAME = 'play_history'
    AND COLUMN_NAME = 'duration'
);
SET @sql = IF(@col_exists = 0,
  'ALTER TABLE play_history ADD COLUMN duration INT NOT NULL DEFAULT 0 COMMENT ''本次收听的秒数'' AFTER song_id;',
  'SELECT ''play_history.duration 列已存在，跳过'' AS info;'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------- 2) 论坛帖子表 ----------
CREATE TABLE IF NOT EXISTS forum_post (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    user_id     BIGINT       NOT NULL COMMENT '发帖用户 id',
    title       VARCHAR(128) NOT NULL COMMENT '帖子标题',
    content     TEXT         NOT NULL COMMENT '帖子正文',
    category    VARCHAR(32)  NOT NULL DEFAULT 'music' COMMENT '帖子板块',
    province    VARCHAR(32)  NOT NULL DEFAULT '' COMMENT '发帖省份',
    likes       BIGINT       NOT NULL DEFAULT 0 COMMENT '点赞数',
    comments    BIGINT       NOT NULL DEFAULT 0 COMMENT '评论数',
    views       BIGINT       NOT NULL DEFAULT 0 COMMENT '浏览数',
    create_time DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     TINYINT      NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_post_user (user_id),
    KEY idx_post_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='论坛帖子';

-- 兼容旧版 forum_post：幂等补齐 category / province 列
SET @col_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'shark_music' AND TABLE_NAME = 'forum_post' AND COLUMN_NAME = 'category'
);
SET @sql = IF(@col_exists = 0,
  'ALTER TABLE forum_post ADD COLUMN category VARCHAR(32) NOT NULL DEFAULT ''music'' COMMENT ''帖子板块'' AFTER content;',
  'SELECT ''forum_post.category 列已存在，跳过'' AS info;'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'shark_music' AND TABLE_NAME = 'forum_post' AND COLUMN_NAME = 'province'
);
SET @sql = IF(@col_exists = 0,
  'ALTER TABLE forum_post ADD COLUMN province VARCHAR(32) NOT NULL DEFAULT '''' COMMENT ''发帖省份'' AFTER category;',
  'SELECT ''forum_post.province 列已存在，跳过'' AS info;'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------- 3) 论坛评论表 ----------
CREATE TABLE IF NOT EXISTS forum_comment (
    id          BIGINT      NOT NULL AUTO_INCREMENT,
    post_id     BIGINT      NOT NULL COMMENT '所属帖子 id',
    user_id     BIGINT      NOT NULL COMMENT '评论用户 id',
    content     TEXT        NOT NULL COMMENT '评论内容',
    likes       BIGINT      NOT NULL DEFAULT 0 COMMENT '点赞数',
    create_time DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     TINYINT     NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_comment_post (post_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='论坛评论';

-- ---------- 4) 聊天室消息表 ----------
CREATE TABLE IF NOT EXISTS chat_message (
    id          BIGINT      NOT NULL AUTO_INCREMENT,
    user_id     BIGINT      NOT NULL COMMENT '发送用户 id',
    content     VARCHAR(500) NOT NULL COMMENT '消息内容',
    create_time DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     TINYINT     NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_chat_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='聊天室消息';
