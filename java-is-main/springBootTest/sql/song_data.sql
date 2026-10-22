-- ============================================================
-- 鲨鱼音乐：曲库表 song 建表 + 种子数据（供首页搜索栏调用）
-- 数据库：MySQL 8.x（需先执行过 init.sql 建好库 shark_music）
-- 执行方式（Windows，本地 MySQL root / 123456）：
--   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -p123456 --default-character-set=utf8mb4 < sql/song_data.sql
-- 注意：--default-character-set=utf8mb4 必须带上，否则中文按 GBK 误读、入库即乱码
-- ============================================================

USE shark_music;

-- 1) 曲库表 song
CREATE TABLE IF NOT EXISTS `song` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title`       VARCHAR(128) NOT NULL                COMMENT '歌曲名',
  `artist`      VARCHAR(64)  NOT NULL                COMMENT '歌手/乐队',
  `album`       VARCHAR(64)  NULL                    COMMENT '所属专辑',
  `duration`    INT          NOT NULL DEFAULT 0      COMMENT '时长（秒）',
  `plays`       BIGINT       NOT NULL DEFAULT 0      COMMENT '播放量',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_title_artist` (`title`, `artist`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='曲库歌曲';

-- 2) 种子数据（30 首，与榜单数据同世界观，重复执行不会产生重复行）
INSERT IGNORE INTO `song` (`id`, `title`, `artist`, `album`, `duration`, `plays`) VALUES
  ( 1, '潮汐信号',       '蓝鲸乐队',     '深海电台',     222,  982000),
  ( 2, '凌晨三点的灯塔', '岛屿她',       '夜航船',       255,  745000),
  ( 3, '逆流而上',       '风暴少年',     '冲浪手册',     185,  512000),
  ( 4, '环礁日落',       'Coral·珊瑚',  '环礁日志',     238,  388000),
  ( 5, '咸鱼翻身进行曲', '打工人合唱团', '格子间战歌',   178, 1250000),
  ( 6, '夏天的最后一天', '南屿风',       '夏末备忘录',   272,  654000),
  ( 7, '北极星快车',     '星野次郎',     '夜行列车',     227,  421000),
  ( 8, '薄荷味晚风',     '薄雾人声',     '雾中风景',     243,  366000),
  ( 9, '无人区漫游指南', '荒原旅人',     '公路片原声',   312,  233000),
  (10, '发光的碎片',     '萤火虫计划',   '夏夜观测',     206,  305000),
  (11, '深海回响',       '鲸落Koi',      '深海回响',     284, 9870000),
  (12, '把海风装进口袋', '海盐汽水',     '盐汽水',       213, 1520000),
  (13, '灯塔与船',       '老船长',       '水手歌谣',     249,  876000),
  (14, '月光泳者',       '夜巡乐队',     '夜巡',         231,  402000),
  (15, '泡沫巡逻艇',     '泡泡糖少女',   '泡泡糖星球',   167,  289000),
  (16, '齿轮与向日葵',   '独立计划',     '车间抒情诗',   258,  512000),
  (17, '修船厂情歌',     '铁与木',       '铁与木',       281,  358000),
  (18, '候鸟备忘录',     '迁徙图书馆',   '飞行日志',     219,  275000),
  (19, '蒸汽波渔港',     'VR镇渔民',     '电子渔港',     194,  447000),
  (20, '后巷口琴师',     '口琴老周',     '旧城十二巷',   303,  198000),
  (21, '深海午夜电台',   '午夜DJ鲨',     '凌晨零点',     296,  620000),
  (22, '环岛慢车',       '慢速铁轨',     '慢速铁轨',     202,  234000),
  (23, '冲浪第一课',     '风暴少年',     '冲浪手册',     180,  189000),
  (24, '鲨鱼晚安曲',     '岛屿她',       '夜航船',       228,  933000),
  (25, '盐雾吉他',       '铁与木',       '铁与木',       252,  176000),
  (26, '城市潜水员',     '夜巡乐队',     '夜巡',         235,  268000),
  (27, '珊瑚色的梦',     'Coral·珊瑚',  '环礁日志',     268,  315000),
  (28, '平流层放风筝',   '星野次郎',     '夜行列车',     216,  154000),
  (29, '自习室摇椅',     '打工人合唱团', '格子间战歌',   171,  426000),
  (30, '蓝色隧道',       '鲸落Koi',      '深海回响',     321,  702000);
