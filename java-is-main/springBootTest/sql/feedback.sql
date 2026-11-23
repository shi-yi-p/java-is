-- ============================================================
-- 意见反馈表（幂等脚本，可重复执行）
-- 执行方式：
--   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -p123456 --default-character-set=utf8mb4 < sql/feedback.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS shark_music
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE shark_music;

CREATE TABLE IF NOT EXISTS `feedback` (
  `id`          BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`     BIGINT        NOT NULL                COMMENT '提交用户 id',
  `type`        VARCHAR(32)   NOT NULL DEFAULT 'other' COMMENT '反馈类型：bug-问题反馈 suggestion-功能建议 music-音乐内容 other-其他',
  `content`     TEXT          NOT NULL                COMMENT '反馈内容',
  `contact`     VARCHAR(128)  NULL                    COMMENT '联系方式（选填）',
  `status`      TINYINT       NOT NULL DEFAULT 0       COMMENT '处理状态：0-待处理 1-已处理',
  `reply`       TEXT          NULL                    COMMENT '官方回复（选填）',
  `create_time` DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `deleted`     TINYINT       NOT NULL DEFAULT 0       COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='意见反馈表';
