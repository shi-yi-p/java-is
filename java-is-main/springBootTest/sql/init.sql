-- ============================================================
-- 鲨鱼音乐（shark-music）建库建表脚本
-- 数据库：MySQL 8.x
-- 说明：本脚本同时被保留在项目中作为建库建表依据。
--       执行方式见文件末尾。
-- ============================================================

-- 1) 创建数据库（若不存在）
CREATE DATABASE IF NOT EXISTS shark_music
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

-- 2) 使用数据库
USE shark_music;

-- 3) 创建用户表 user
--    account：账户，支持手机号/邮箱/用户名，唯一约束用于注册查重
--    password：存储 BCrypt 哈希后的密文
--    create_time / update_time：由数据库默认值填充
--    deleted：MyBatis-Plus 逻辑删除字段（0-未删 1-已删）
CREATE TABLE IF NOT EXISTS `user` (
  `id`          BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account`     VARCHAR(64)   NOT NULL                COMMENT '账户（手机号/邮箱/用户名）',
  `password`    VARCHAR(100)  NOT NULL                COMMENT '密码（BCrypt 哈希密文）',
  `nickname`    VARCHAR(32)   NULL                    COMMENT '昵称',
  `create_time` DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP                 COMMENT '创建时间',
  `update_time` DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`     TINYINT       NOT NULL DEFAULT 0       COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户表';

-- ============================================================
-- 执行方式（Windows，本地 MySQL root / 123456）：
--   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -p123456 --default-character-set=utf8mb4 < sql/init.sql
-- 或在已登录的 MySQL 客户端中直接 source 本文件。
-- 注意：--default-character-set=utf8mb4 必须带上，否则中文注释按 GBK 误读、入库即乱码
-- ============================================================
