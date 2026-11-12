-- ============================================================
-- 鲨鱼音乐（shark_music）个人主页社交数据表
-- 数据库：MySQL 8.x
-- 说明：为个人主页提供真实的关注/粉丝/收藏/播放历史/动态数据。
--       执行方式见文件末尾。
-- ============================================================

USE shark_music;

-- 1) 关注关系表 user_follow
--    follower_id：发起关注的用户（粉丝）
--    followee_id：被关注的用户
--    关注关系唯一约束：同一个人不能重复关注同一对象
CREATE TABLE IF NOT EXISTS `user_follow` (
  `id`          BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
  `follower_id` BIGINT   NOT NULL                COMMENT '关注者用户 id（粉丝）',
  `followee_id` BIGINT   NOT NULL                COMMENT '被关注用户 id',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '关注时间',
  `deleted`     TINYINT  NOT NULL DEFAULT 0       COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_follow` (`follower_id`, `followee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户关注关系表';

-- 2) 收藏歌曲表 user_favorite
CREATE TABLE IF NOT EXISTS `user_favorite` (
  `id`          BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`     BIGINT   NOT NULL                COMMENT '用户 id',
  `song_id`     BIGINT   NOT NULL                COMMENT '歌曲 id',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  `deleted`     TINYINT  NOT NULL DEFAULT 0       COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_fav` (`user_id`, `song_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户收藏歌曲表';

-- 3) 播放历史表 play_history
--    每次播放插入一条记录，用于计算听歌排行和听歌时长
CREATE TABLE IF NOT EXISTS `play_history` (
  `id`         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`    BIGINT   NOT NULL                COMMENT '用户 id',
  `song_id`    BIGINT   NOT NULL                COMMENT '歌曲 id',
  `played_at`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '播放时间',
  `deleted`    TINYINT  NOT NULL DEFAULT 0       COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  KEY `idx_user_time` (`user_id`, `played_at`),
  KEY `idx_song` (`song_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户播放历史表';

-- 4) 用户动态表 user_moment
--    type：listen 播放 / favorite 收藏 / create_playlist 创建歌单 / follow 关注
CREATE TABLE IF NOT EXISTS `user_moment` (
  `id`          BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`     BIGINT        NOT NULL                  COMMENT '用户 id',
  `type`        VARCHAR(32)   NOT NULL DEFAULT 'listen' COMMENT '动态类型',
  `content`     VARCHAR(255)  NULL                      COMMENT '动态文本',
  `song_id`     BIGINT        NULL                      COMMENT '关联歌曲 id（可选）',
  `playlist_id` BIGINT        NULL                      COMMENT '关联歌单 id（可选）',
  `create_time` DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `deleted`     TINYINT       NOT NULL DEFAULT 0         COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  KEY `idx_user_time` (`user_id`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户动态表';

-- 5) 个人歌单表 user_playlist
--    每个用户自建、互不可见（按 user_id 隔离），区别于全站公用的精选歌单 playlist
CREATE TABLE IF NOT EXISTS `user_playlist` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`     BIGINT       NOT NULL                COMMENT '所属用户 id',
  `name`        VARCHAR(64)  NOT NULL                COMMENT '歌单名',
  `cover_tone`  VARCHAR(16)  NOT NULL DEFAULT 'p1'   COMMENT '封面配色 p1~p8',
  `sort_order`  INT          NOT NULL DEFAULT 0      COMMENT '排序(小在前)',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='个人歌单表';

-- ============================================================
-- 执行方式（Windows，本地 MySQL root / 123456）：
--   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -p123456 --default-character-set=utf8mb4 < sql/profile_social.sql
-- 注意：--default-character-set=utf8mb4 必须带上，否则中文注释按 GBK 误读、入库即乱码
-- ============================================================
