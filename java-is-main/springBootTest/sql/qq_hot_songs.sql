-- ============================================================
-- 鲨鱼音乐：QQ音乐热歌榜表 qq_hot_song 建表 + 种子数据
-- 数据库：MySQL 8.x（需先执行过 init.sql 建好库 shark_music）
-- 执行方式（Windows，本地 MySQL root / 123456）：
--   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -p123456 --default-character-set=utf8mb4 < sql/qq_hot_songs.sql
-- 注意：--default-character-set=utf8mb4 必须带上，否则中文按 GBK 误读、入库即乱码
--
-- 说明：
--   歌名 / 歌手 / 专辑 / 时长为真实热歌元数据（仅作曲库展示、学习演示）。
--   音源走合成兜底（/api/stream?id=），不扒取任何受版权保护的真实音频，零版权风险。
-- ============================================================

USE shark_music;

-- 1) QQ音乐热歌表 qq_hot_song
CREATE TABLE IF NOT EXISTS `qq_hot_song` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='QQ音乐热歌榜';

-- 2) 种子数据（30 首真实热歌元数据，重复执行不会产生重复行）
INSERT IGNORE INTO `qq_hot_song`
  (`id`, `rank_no`, `title`, `artist`, `album`, `duration`, `hot_value`, `trend`) VALUES
  ( 1,  1, '发如雪',       '周杰伦',     '十一月的萧邦',     299, 168000000, 'up'),
  ( 2,  2, '我不难过',     '孙燕姿',     '未完成',           320, 152000000, 'up'),
  ( 3,  3, '演员',         '薛之谦',     '意外',             261, 145000000, 'flat'),
  ( 4,  4, '我怀念的',     '孙燕姿',     '逆光',             289, 138000000, 'up'),
  ( 5,  5, '天龙八部之宿敌', '许嵩',     '苏格拉没有底',     264, 131000000, 'flat'),
  ( 6,  6, '季候风',       '王菲',       '讨好自己',         276, 124000000, 'up'),
  ( 7,  7, '雨爱',         '杨丞琳',     '半熟宣言',         260, 118000000, 'flat'),
  ( 8,  8, '情歌',         '梁静茹',     '静茹&情歌',        260, 112000000, 'up'),
  ( 9,  9, '幻听',         '许嵩',       '寻雾启示',         273, 106000000, 'flat'),
  (10, 10, 'Always Online', '林俊杰',   'JJ陆',             225, 101000000, 'up'),
  (11, 11, '开始懂了',     '孙燕姿',     '我要的幸福',       271,  98000000, 'flat'),
  (12, 12, '爱错',         '王力宏',     '改变自己',         238,  94000000, 'up'),
  (13, 13, '春娇与志明',   '街道办GDC、欧阳耀莹', '春娇与志明', 204, 90000000, 'flat'),
  (14, 14, '自由的你',     'G.E.M.邓紫棋', '自由的你',       296,  88000000, 'new'),
  (15, 15, '恋人',         '李荣浩',     '恋人',             275,  84000000, 'up'),
  (16, 16, '甲乙丙丁',     '李佳薇',     '甲乙丙丁',         210,  80000000, 'new'),
  (17, 17, '我好像在哪见过你', '薛之谦',   '怪咖',           279,  77000000, 'flat'),
  (18, 18, '特别的人',     '方大同',     '危险世界',         259,  73000000, 'up'),
  (19, 19, '泪海',         '许茹芸',     '如果云知道',       298,  69000000, 'flat'),
  (20, 20, '天亮了',       '韩红',       '天亮了',           274,  65000000, 'up'),
  (21, 21, '体面',         '于文文',     '体面',             265,  62000000, 'flat'),
  (22, 22, '凉凉',         '杨宗纬、张碧晨', '三生三世十里桃花', 320, 59000000, 'up'),
  (23, 23, '夜空中最亮的星', '逃跑计划',   '世界',           276,  56000000, 'flat'),
  (24, 24, '追光者',       '岑宁儿',     '追光者',           238,  53000000, 'up'),
  (25, 25, '平凡之路',     '朴树',       '猎户星座',         315,  50000000, 'flat'),
  (26, 26, '那些年',       '胡夏',       '那些年',           316,  47000000, 'up'),
  (27, 27, '一次就好',     '杨宗纬',     '一次就好',         267,  44000000, 'flat'),
  (28, 28, '斑马斑马',     '宋冬野',     '安和桥北',         257,  41000000, 'new'),
  (29, 29, '南方姑娘',     '赵雷',       '赵小雷',           304,  38000000, 'flat'),
  (30, 30, '理想',         '赵雷',       '无法长大',         324,  35000000, 'up');
