-- ============================================================
-- 鲨鱼音乐：首页「精选歌单 + 热门榜单」建库建表 + 种子数据
-- 数据库：MySQL 8.x（需先执行过 init.sql 建好库 shark_music）
-- 说明：使用 INSERT IGNORE + 显式主键，重复执行不会产生重复数据
-- ============================================================

USE shark_music;

-- 1) 精选歌单表 playlist
CREATE TABLE IF NOT EXISTS `playlist` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title`       VARCHAR(64)  NOT NULL                COMMENT '歌单标题',
  `subtitle`    VARCHAR(128) NULL                   COMMENT '副标题/一句话介绍',
  `tag`         VARCHAR(24)  NULL                   COMMENT '分类标签',
  `icon`        VARCHAR(16)  NULL                   COMMENT '封面装饰图标(emoji)',
  `tone`        VARCHAR(16)  NOT NULL DEFAULT 'p1'   COMMENT '封面渐变配色编号 p1~p8',
  `plays`       BIGINT       NOT NULL DEFAULT 0      COMMENT '播放量',
  `sort_order`  INT          NOT NULL DEFAULT 0      COMMENT '展示顺序(小在前)',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='精选歌单';

-- 2) 榜单表 chart
CREATE TABLE IF NOT EXISTS `chart` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`        VARCHAR(32)  NOT NULL                COMMENT '榜单名称',
  `tone`        VARCHAR(16)  NOT NULL DEFAULT 'blue' COMMENT '榜单头配色：orange/blue/purple/teal',
  `sort_order`  INT          NOT NULL DEFAULT 0      COMMENT '展示顺序(小在前)',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='热门榜单';

-- 3) 榜单歌曲表 chart_song
CREATE TABLE IF NOT EXISTS `chart_song` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `chart_id`    BIGINT       NOT NULL                COMMENT '所属榜单 id',
  `rank_no`     INT          NOT NULL                COMMENT '名次(从 1 开始)',
  `title`       VARCHAR(128) NOT NULL                COMMENT '歌曲名',
  `artist`      VARCHAR(64)  NOT NULL                COMMENT '歌手/乐队',
  `trend`       VARCHAR(8)   NOT NULL DEFAULT 'flat' COMMENT '趋势：up升 down降 flat持平 new新进',
  `deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_chart_rank` (`chart_id`, `rank_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='榜单歌曲';

-- ============================================================
-- 种子数据
-- ============================================================

INSERT IGNORE INTO `playlist` (`id`, `title`, `subtitle`, `tag`, `icon`, `tone`, `plays`, `sort_order`) VALUES
  (1, '深海午夜电台', '深夜循环的 60 首氛围感神游曲', '睡前', '🎧', 'p1', 32860000, 1),
  (2, '冲浪摇滚现场', '把音量拧到最大，跟着浪尖起跳', '摇滚', '🎸', 'p2',  9720000, 2),
  (3, '自习室白噪音', '高效专注 · 图书馆盖章款 BGM', '专注', '🎹', 'p3', 187300000, 3),
  (4, '华语新声捞星', '每周五更新，捞一捞刚冒头的好声音', '华语', '🎤', 'p4', 45210000, 4),
  (5, '落日爵士酒馆', '微醺时刻的萨克斯与旧钢琴', '爵士', '🎷', 'p5',  6310000, 5),
  (6, '健身暴汗燃料', '180BPM 起步，多巴胺拉满', '运动', '🥁', 'p6', 21090000, 6),
  (7, '民谣与远方', '木吉他、旧火车和慢慢的生活', '民谣', '🎻', 'p7', 15840000, 7),
  (8, '海底两万里', '电子合成器潜入深蓝的听觉旅行', '电子', '📻', 'p8',  8470000, 8);

INSERT IGNORE INTO `chart` (`id`, `name`, `tone`, `sort_order`) VALUES
  (1, '飙升榜',   'orange', 1),
  (2, '新歌榜',   'teal',   2),
  (3, 'TOP500',  'blue',   3),
  (4, '原创榜',   'purple', 4);

INSERT IGNORE INTO `chart_song` (`id`, `chart_id`, `rank_no`, `title`, `artist`, `trend`) VALUES
  -- 飙升榜
  ( 1, 1, 1, '潮汐信号',       '蓝鲸乐队',     'up'),
  ( 2, 1, 2, '凌晨三点的灯塔', '岛屿她',       'new'),
  ( 3, 1, 3, '逆流而上',       '风暴少年',     'up'),
  ( 4, 1, 4, '环礁日落',       'Coral·珊瑚',   'flat'),
  ( 5, 1, 5, '咸鱼翻身进行曲', '打工人合唱团', 'down'),
  -- 新歌榜
  ( 6, 2, 1, '夏天的最后一天', '南屿风',       'new'),
  ( 7, 2, 2, '北极星快车',     '星野次郎',     'up'),
  ( 8, 2, 3, '薄荷味晚风',     '薄雾人声',     'new'),
  ( 9, 2, 4, '无人区漫游指南', '荒原旅人',     'flat'),
  (10, 2, 5, '发光的碎片',     '萤火虫计划',   'down'),
  -- TOP500
  (11, 3, 1, '深海回响',       '鲸落Koi',      'flat'),
  (12, 3, 2, '把海风装进口袋', '海盐汽水',     'up'),
  (13, 3, 3, '灯塔与船',       '老船长',       'flat'),
  (14, 3, 4, '月光泳者',       '夜巡乐队',     'up'),
  (15, 3, 5, '泡沫巡逻艇',     '泡泡糖少女',   'down'),
  -- 原创榜
  (16, 4, 1, '齿轮与向日葵',   '独立计划',     'up'),
  (17, 4, 2, '修船厂情歌',     '铁与木',       'new'),
  (18, 4, 3, '候鸟备忘录',     '迁徙图书馆',   'flat'),
  (19, 4, 4, '蒸汽波渔港',     'VR镇渔民',     'up'),
  (20, 4, 5, '后巷口琴师',     '口琴老周',     'flat');

-- ============================================================
-- 4) 听书精选表 audiobook
CREATE TABLE IF NOT EXISTS `audiobook` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title`       VARCHAR(64)  NOT NULL                COMMENT '作品标题',
  `author`      VARCHAR(32)  NOT NULL                COMMENT '主播/作者',
  `intro`       VARCHAR(128) NULL                    COMMENT '一句话介绍',
  `tab`         VARCHAR(16)  NOT NULL                COMMENT '分类：热门/小说/儿童/相声/情感',
  `icon`        VARCHAR(16)  NULL                    COMMENT '封面图标(emoji)',
  `tone`        VARCHAR(16)  NOT NULL DEFAULT 'p1'   COMMENT '封面渐变配色编号 p1~p8',
  `listens`     BIGINT       NOT NULL DEFAULT 0      COMMENT '收听量',
  `sort_order`  INT          NOT NULL DEFAULT 0      COMMENT '展示顺序(小在前)',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='听书精选';

INSERT IGNORE INTO `audiobook` (`id`, `title`, `author`, `intro`, `tab`, `icon`, `tone`, `listens`, `sort_order`) VALUES
  ( 1, '深海博物馆奇谈',     '主播·阿鲸',     '每晚一件海底展品背后的奇闻',   '热门', '🌊', 'p3',  8600000, 1),
  ( 2, '睡前三分半',         '主播·糖糖',     '今天也辛苦了，听我讲个故事',   '热门', '🌙', 'p1', 12000000, 2),
  ( 3, '午夜怪谈收容所',     '主播·夜巡',     '胆小勿入的都市传说合集',       '热门', '🕯️', 'p7', 7200000, 3),
  ( 4, '孤岛灯塔看守日志',   '老船长',        '守灯人二十年的风浪手记',       '热门', '🗺️', 'p4',  5300000, 4),
  ( 5, '蓝鲸座城市悬案',     '无名侦探社',    '水下都市的三桩离奇密室',       '小说', '🔍', 'p2',  3900000, 1),
  ( 6, '荒野生存十二夜',     '铁与木',        '不带一根火柴的野外实录',        '小说', '🏕️', 'p6',  1800000, 2),
  ( 7, '深海来信',           '慢速铁轨',      '沉船邮袋里打捞出的旧信件',     '小说', '📜', 'p8',  2400000, 3),
  ( 8, '小鲨鱼成长记',       '珊瑚姐姐',      '适合 3-8 岁的海洋睡前故事',    '儿童', '🦈', 'p6',  6700000, 1),
  ( 9, '咕噜咕噜海底幼儿园', '泡泡老师',      '和小鱼们一起学礼貌好习惯',     '儿童', '🫧', 'p8',  2100000, 2),
  (10, '码头相声大会',       '铁嘴老周',      '抖包袱不断更新的直播剪辑',     '相声', '🎙️', 'p5',  4400000, 1),
  (11, '茶馆夜话·单口集',    '醒木先生',      '一块醒木，半城旧事',           '相声', '🍵', 'p7',  1900000, 2),
  (12, '晚风情感电台',       '主播·岛屿她',   '深夜来电：把心事说给海风听',   '情感', '💌', 'p4',  9800000, 1),
  (13, '写给灯塔的一百封信', '主播·暖洋',     '一百个听众投稿的真实故事',     '情感', '✉️', 'p3',  2600000, 2),
  (14, '漂流瓶树洞',         '主播·拾贝',     '捡到的每一个瓶子都有一段心事', '情感', '🍀', 'p5',  1500000, 3);

-- ============================================================
-- 5) 热门频道表 channel
CREATE TABLE IF NOT EXISTS `channel` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`        VARCHAR(32)  NOT NULL                COMMENT '频道名称',
  `icon`        VARCHAR(16)  NULL                    COMMENT '频道图标(emoji)',
  `tone`        VARCHAR(16)  NOT NULL DEFAULT 'p1'   COMMENT '图标底色渐变编号 p1~p8',
  `listeners`   BIGINT       NOT NULL DEFAULT 0      COMMENT '当前在听人数',
  `sort_order`  INT          NOT NULL DEFAULT 0      COMMENT '展示顺序(小在前)',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='热门频道';

INSERT IGNORE INTO `channel` (`id`, `name`, `icon`, `tone`, `listeners`, `sort_order`) VALUES
  (1, '早安海底电台', '☀️', 'p3',  860000, 1),
  (2, '深夜故事馆',   '🌙', 'p1',  620000, 2),
  (3, '白噪音专注舱', '🎧', 'p8', 1200000, 3),
  (4, '民谣小馆',     '🪕', 'p7',  450000, 4),
  (5, '古典音乐沙龙', '🎻', 'p5',  380000, 5),
  (6, '影视原声站',   '🎬', 'p2',  540000, 6),
  (7, '国风雅集',     '🏮', 'p4',  720000, 7),
  (8, '儿童故事堡',   '🏰', 'p6',  290000, 8);

-- ============================================================
-- 6) 热门歌手表 singer
CREATE TABLE IF NOT EXISTS `singer` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`        VARCHAR(32)  NOT NULL                COMMENT '歌手/乐队名',
  `tab`         VARCHAR(8)   NOT NULL                COMMENT '地区分类：华语/欧美/日韩',
  `fans`        BIGINT       NOT NULL DEFAULT 0      COMMENT '粉丝数',
  `tone`        VARCHAR(16)  NOT NULL DEFAULT 'p1'   COMMENT '头像渐变配色编号 p1~p8',
  `sort_order`  INT          NOT NULL DEFAULT 0      COMMENT '展示顺序(小在前)',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='热门歌手';

INSERT IGNORE INTO `singer` (`id`, `name`, `tab`, `fans`, `tone`, `sort_order`) VALUES
  ( 1, '鲸落Koi',   '华语', 9800000, 'p1', 1),
  ( 2, '岛屿她',     '华语', 7600000, 'p4', 2),
  ( 3, '蓝鲸乐队',   '华语', 5400000, 'p2', 3),
  ( 4, '海盐汽水',   '华语', 4200000, 'p3', 4),
  ( 5, '午夜DJ鲨',   '华语', 3100000, 'p7', 5),
  ( 6, '星野次郎',   '日韩', 3500000, 'p8', 1),
  ( 7, '波浪少女组', '日韩', 2200000, 'p6', 2),
  ( 8, 'Luna Tide',   '欧美', 2800000, 'p5', 1),
  ( 9, 'Ocean Kids',  '欧美', 1900000, 'p3', 2),
  (10, 'Vinyl Brothers', '欧美', 1300000, 'p2', 3);

-- ============================================================
-- 执行方式（Windows，本地 MySQL root / 123456）：
--   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -p123456 --default-character-set=utf8mb4 < sql/home_data.sql
-- 注意：--default-character-set=utf8mb4 必须带上，否则中文按 GBK 误读、入库即乱码
-- ============================================================
