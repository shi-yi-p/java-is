-- ============================================================
-- 鲨鱼音乐：抖音热歌榜表 douyin_hot_song 建表 + 种子数据
-- 数据库：MySQL 8.x（需先执行过 init.sql 建好库 shark_music）
-- 执行方式（Windows，本地 MySQL root / 123456）：
--   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -p123456 --default-character-set=utf8mb4 < sql/douyin_hot_songs.sql
-- 注意：--default-character-set=utf8mb4 必须带上，否则中文按 GBK 误读、入库即乱码
--
-- 说明：
--   歌名 / 歌手 / 专辑 为真实抖音热歌的元数据（仅作曲库展示、学习演示）。
--   音源走合成兜底（/api/stream?id=），不扒取任何受版权保护的真实音频，
--   零版权风险。若日后需接正版授权音源，可 UPDATE 该表的 url 字段。
-- ============================================================

USE shark_music;

-- 1) 抖音热歌表 douyin_hot_song
CREATE TABLE IF NOT EXISTS `douyin_hot_song` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rank_no`     INT          NOT NULL                COMMENT '名次(从 1 开始)',
  `title`       VARCHAR(128) NOT NULL                COMMENT '歌曲名',
  `artist`      VARCHAR(64)  NOT NULL                COMMENT '歌手/乐队',
  `album`       VARCHAR(64)  NULL                    COMMENT '所属专辑',
  `duration`    INT          NOT NULL DEFAULT 0      COMMENT '时长（秒）',
  `hot_value`   BIGINT       NOT NULL DEFAULT 0      COMMENT '热度值（用于展示排序）',
  `trend`       VARCHAR(8)   NOT NULL DEFAULT 'flat' COMMENT '趋势：up升 down降 flat持平 new新进',
  `url`         VARCHAR(512) NULL                    COMMENT '真实音源直链（可选，存在则优先播放）',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_rank` (`rank_no`),
  KEY `idx_hot` (`hot_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='抖音热歌榜';

-- 2) 种子数据（30 首真实抖音热歌元数据，重复执行不会产生重复行）
INSERT IGNORE INTO `douyin_hot_song`
  (`id`, `rank_no`, `title`, `artist`, `album`, `duration`, `hot_value`, `trend`) VALUES
  ( 1,  1, '晚风告白',     '陈亦楠',     '晚风告白',         215, 128000000, 'up'),
  ( 2,  2, '若月亮没来',   '于适',       '若月亮没来',       232, 115000000, 'up'),
  ( 3,  3, '小美满',       '周深',       '小美满',           224,  98000000, 'flat'),
  ( 4,  4, '苹果香',       '汪苏泷',     '苹果香',           201,  91000000, 'up'),
  ( 5,  5, 'APT.',         'Rosé & Bruno Mars', 'APT.',     173,  88000000, 'flat'),
  ( 6,  6, '青花',         '周传雄',     '青花',             286,  76000000, 'up'),
  ( 7,  7, '落日与晚风',   '林忆莲',     '落日与晚风',       248,  69000000, 'flat'),
  ( 8,  8, '向云端',       '刀郎',       '山歌寥哉',         265,  64000000, 'flat'),
  ( 9,  9, '罗刹海市',     '刀郎',       '山歌寥哉',         315,  61000000, 'flat'),
  (10, 10, '海阔天空',     'Beyond',     '乐与怒',           326,  57000000, 'up'),
  (11, 11, '一路生花',     '温奕心',     '一路生花',         228,  52000000, 'flat'),
  (12, 12, '我记得',       '赵雷',       '署前街少年',       294,  48000000, 'flat'),
  (13, 13, '起风了',       '买辣椒也用券', '起风了',         259,  45000000, 'up'),
  (14, 14, '我会等',       '张杰',       '我会等',           236,  43000000, 'flat'),
  (15, 15, '孤勇者',       '陈奕迅',     '孤勇者',           271,  41000000, 'flat'),
  (16, 16, '笼',           '林俊杰',     '笼',               243,  38000000, 'up'),
  (17, 17, '心动',         '王菲',       '王菲同名专辑',     217,  35000000, 'new'),
  (18, 18, '如愿',         '王菲',       '如愿',             274,  33000000, 'flat'),
  (19, 19, '人世间',       '雷佳',       '人世间',           288,  31000000, 'flat'),
  (20, 20, '无名的人',     '毛不易',     '无名的人',         256,  29000000, 'new'),
  (21, 21, '送你一朵小红花', '赵英俊',   '送你一朵小红花',   240,  27000000, 'flat'),
  (22, 22, '这世界那么多人', '莫文蔚',    '这世界那么多人',   262,  25000000, 'up'),
  (23, 23, '笼中鸟',       '李荣浩',     '笼中鸟',           231,  23000000, 'new'),
  (24, 24, '大梦归',       '周深',       '兰香如故 影视原声带', 245, 21000000, 'new'),
  (25, 25, '成都',         '赵雷',       '赵小雷',           312,  19000000, 'up'),
  (26, 26, '鼓楼',         '赵雷',       '无法长大',         258,  17000000, 'flat'),
  (27, 27, '茶汤',         '郁可唯',     '微加幸福',         223,  15000000, 'new'),
  (28, 28, '态度',         '田栩宁',     'X',                208,  13000000, 'new'),
  (29, 29, '雨终曲',       '宋雨琦',     '雨终曲',           219,  11000000, 'new'),
  (30, 30, '我记得',       '房东的猫',   'New Boy',          204,   9000000, 'flat');
