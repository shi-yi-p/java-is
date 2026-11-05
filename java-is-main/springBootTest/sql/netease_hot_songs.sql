-- ============================================================
-- 鲨鱼音乐：网易云热歌榜表 netease_hot_song 建表 + 种子数据
-- 数据库：MySQL 8.x（需先执行过 init.sql 建好库 shark_music）
-- 执行方式（Windows，本地 MySQL root / 123456）：
--   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -p123456 --default-character-set=utf8mb4 < sql/netease_hot_songs.sql
-- 注意：--default-character-set=utf8mb4 必须带上，否则中文按 GBK 误读、入库即乱码
--
-- 说明：
--   歌名 / 歌手 / 专辑 / 时长为真实热歌元数据（仅作曲库展示、学习演示）。
--   侧重网易云特色：独立 / 民谣 / 网络热歌。
--   音源走合成兜底（/api/stream?id=），不扒取任何受版权保护的真实音频，零版权风险。
-- ============================================================

USE shark_music;

-- 1) 网易云热歌表 netease_hot_song
CREATE TABLE IF NOT EXISTS `netease_hot_song` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='网易云热歌榜';

-- 2) 种子数据（30 首真实热歌元数据，重复执行不会产生重复行）
INSERT IGNORE INTO `netease_hot_song`
  (`id`, `rank_no`, `title`, `artist`, `album`, `duration`, `hot_value`, `trend`) VALUES
  ( 1,  1, '起风了',       '买辣椒也用券', '起风了',         259, 152000000, 'up'),
  ( 2,  2, '安和桥',       '宋冬野',     '安和桥北',         272, 143000000, 'flat'),
  ( 3,  3, '理想',         '赵雷',       '无法长大',         324, 136000000, 'up'),
  ( 4,  4, '成都',         '赵雷',       '赵小雷',           312, 129000000, 'flat'),
  ( 5,  5, '小半',         '陈粒',       '小梦大半',         275, 122000000, 'up'),
  ( 6,  6, '易燃易爆炸',   '陈粒',       '如也',             254, 116000000, 'flat'),
  ( 7,  7, '妙龄童',       '陈粒',       '如也',             241, 109000000, 'up'),
  ( 8,  8, '云烟成雨',     '房东的猫',   '房东的猫',         251, 103000000, 'flat'),
  ( 9,  9, '美好事物',     '房东的猫',   '美好事物',         262,  98000000, 'up'),
  (10, 10, '水星记',       '郭顶',       '飞行器的执行周期', 285,  94000000, 'flat'),
  (11, 11, '凄美地',       '郭顶',       '飞行器的执行周期', 289,  90000000, 'up'),
  (12, 12, '不染',         '毛不易',     '香蜜沉沉烬如霜',   273,  86000000, 'flat'),
  (13, 13, '消愁',         '毛不易',     '平凡的一天',       294,  83000000, 'up'),
  (14, 14, '像我这样的人', '毛不易',     '平凡的一天',       262,  80000000, 'flat'),
  (15, 15, '往后余生',     '马良',       '往后余生',         249,  76000000, 'flat'),
  (16, 16, '理想三旬',     '陈鸿宇',     '浓烟下的诗歌电台', 302, 73000000, 'up'),
  (17, 17, '借我',         '谢春花',     '算云烟',           256,  70000000, 'flat'),
  (18, 18, '春风十里',     '鹿先森乐队', '所有的酒，都不如你', 265, 67000000, 'up'),
  (19, 19, '鸽子',         '宋冬野',     '安和桥北',         261,  64000000, 'flat'),
  (20, 20, '董小姐',       '宋冬野',     '安和桥北',         278,  61000000, 'up'),
  (21, 21, '像我这样的年纪', '一支榴莲',  '像我这样的年纪',   249, 58000000, 'new'),
  (22, 22, '出现又离开',   '梁博',       '梁博',             324,  55000000, 'up'),
  (23, 23, '男孩',         '梁博',       '梁博',             291,  52000000, 'flat'),
  (24, 24, '刻在我心底的名字', '卢广仲',   '刻在我心底的名字', 288, 49000000, 'up'),
  (25, 25, '归途有风',     '海来阿木',   '归途有风',         246,  46000000, 'new'),
  (26, 26, '醒不来的梦',   '回小仙',     '醒不来的梦',       258,  43000000, 'up'),
  (27, 27, '错位时空',     '艾辰',       '错位时空',         268,  40000000, 'flat'),
  (28, 28, '我会等',       '承桓',       '我会等',           251,  37000000, 'new'),
  (29, 29, '善变',         '王靖雯',     '善变',             247,  34000000, 'up'),
  (30, 30, '就忘了吧',     '1K',         '就忘了吧',         253,  31000000, 'flat');
