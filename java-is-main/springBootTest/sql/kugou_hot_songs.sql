-- ============================================================
-- 鲨鱼音乐：酷狗热歌榜表 kugou_hot_song 建表 + 种子数据
-- 数据库：MySQL 8.x（需先执行过 init.sql 建好库 shark_music）
-- 执行方式（Windows，本地 MySQL root / 123456）：
--   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -p123456 --default-character-set=utf8mb4 < sql/kugou_hot_songs.sql
-- 注意：--default-character-set=utf8mb4 必须带上，否则中文按 GBK 误读、入库即乱码
--
-- 说明：
--   歌名 / 歌手 / 专辑 / 时长为真实经典流行金曲的元数据（仅作曲库展示、学习演示）。
--   音源走合成兜底（/api/stream?id=），不扒取任何受版权保护的真实音频，零版权风险。
-- ============================================================

USE shark_music;

-- 1) 酷狗热歌表 kugou_hot_song
CREATE TABLE IF NOT EXISTS `kugou_hot_song` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='酷狗热歌榜';

-- 2) 种子数据（30 首经典+流行金曲元数据，重复执行不会产生重复行）
INSERT IGNORE INTO `kugou_hot_song`
  (`id`, `rank_no`, `title`, `artist`, `album`, `duration`, `hot_value`, `trend`) VALUES
  ( 1,  1, '晴天',         '周杰伦',     '叶惠美',           269, 156000000, 'up'),
  ( 2,  2, '稻香',         '周杰伦',     '魔杰座',           223, 138000000, 'flat'),
  ( 3,  3, '青花瓷',       '周杰伦',     '我很忙',           239, 121000000, 'up'),
  ( 4,  4, '江南',         '林俊杰',     '第二天堂',         267, 132000000, 'flat'),
  ( 5,  5, '演员',         '薛之谦',     '意外',             261, 108000000, 'up'),
  ( 6,  6, '十年',         '陈奕迅',     '黑·白·灰',        246,  98000000, 'flat'),
  ( 7,  7, '浮夸',         '陈奕迅',     'U87',             267,  92000000, 'up'),
  ( 8,  8, '富士山下',     '陈奕迅',     'What''s Going On...?', 285, 85000000, 'flat'),
  ( 9,  9, '吻别',         '张学友',     '吻别',             278,  88000000, 'up'),
  (10, 10, '一千个伤心的理由', '张学友', '真爱新曲+精选',    269,  76000000, 'flat'),
  (11, 11, '泡沫',         'G.E.M.邓紫棋', 'Xposed',        271,  82000000, 'up'),
  (12, 12, '光年之外',     'G.E.M.邓紫棋', '光年之外',       235,  74000000, 'flat'),
  (13, 13, '海阔天空',     'Beyond',     '乐与怒',           326,  79000000, 'up'),
  (14, 14, '光辉岁月',     'Beyond',     '命运派对',         302,  71000000, 'flat'),
  (15, 15, '素颜',         '许嵩、何曼婷', '寻雾启示',       238,  66000000, 'up'),
  (16, 16, '南山南',       '马頔',       '孤鸟的歌',         305,  58000000, 'flat'),
  (17, 17, '成都',         '赵雷',       '赵小雷',           312,  61000000, 'up'),
  (18, 18, '小幸运',       '田馥甄',     '小幸运',           267,  56000000, 'flat'),
  (19, 19, '倔强',         '五月天',     '神的孩子都在跳舞', 258,  53000000, 'up'),
  (20, 20, '突然好想你',   '五月天',     '后青春期的诗',     271,  51000000, 'flat'),
  (21, 21, '告白气球',     '周杰伦',     '周杰伦的床边故事', 255,  62000000, 'new'),
  (22, 22, '七里香',       '周杰伦',     '七里香',           299,  54000000, 'up'),
  (23, 23, '不为谁而作的歌', '林俊杰',   '和自己对话',       280,  49000000, 'flat'),
  (24, 24, '她说',         '林俊杰',     '她说 概念自选辑', 258,  46000000, 'up'),
  (25, 25, '红豆',         '王菲',       '唱游',             264,  44000000, 'flat'),
  (26, 26, '容易受伤的女人', '王菲',      'Coming Home',     259,  41000000, 'new'),
  (27, 27, '不将就',       '李荣浩',     '有理想',           302,  39000000, 'up'),
  (28, 28, '年少有为',     '李荣浩',     '年少有为',         276,  37000000, 'flat'),
  (29, 29, '体面',         '于文文',     '体面',             265,  35000000, 'new'),
  (30, 30, '往后余生',     '马良',       '往后余生',         249,  33000000, 'flat');
