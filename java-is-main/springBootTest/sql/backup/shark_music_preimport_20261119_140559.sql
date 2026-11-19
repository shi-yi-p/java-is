-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: shark_music
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audiobook`
--

DROP TABLE IF EXISTS `audiobook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audiobook` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '作品标题',
  `author` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主播/作者',
  `intro` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '一句话介绍',
  `tab` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类：热门/小说/儿童/相声/情感',
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面图标(emoji)',
  `tone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'p1' COMMENT '封面渐变配色编号 p1~p8',
  `listens` bigint NOT NULL DEFAULT '0' COMMENT '收听量',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '展示顺序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_title` (`title`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='听书精选';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audiobook`
--

LOCK TABLES `audiobook` WRITE;
/*!40000 ALTER TABLE `audiobook` DISABLE KEYS */;
INSERT INTO `audiobook` VALUES (1,'深海博物馆奇谈','主播·阿鲸','每晚一件海底展品背后的奇闻','热门','🌊','p3',8600000,1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(2,'睡前三分半','主播·糖糖','今天也辛苦了，听我讲个故事','热门','🌙','p1',12000000,2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(3,'午夜怪谈收容所','主播·夜巡','胆小勿入的都市传说合集','热门','🕯️','p7',7200000,3,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(4,'孤岛灯塔看守日志','老船长','守灯人二十年的风浪手记','热门','🗺️','p4',5300000,4,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(5,'蓝鲸座城市悬案','无名侦探社','水下都市的三桩离奇密室','小说','🔍','p2',3900000,1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(6,'荒野生存十二夜','铁与木','不带一根火柴的野外实录','小说','🏕️','p6',1800000,2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(7,'深海来信','慢速铁轨','沉船邮袋里打捞出的旧信件','小说','📜','p8',2400000,3,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(8,'小鲨鱼成长记','珊瑚姐姐','适合 3-8 岁的海洋睡前故事','儿童','🦈','p6',6700000,1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(9,'咕噜咕噜海底幼儿园','泡泡老师','和小鱼们一起学礼貌好习惯','儿童','🫧','p8',2100000,2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(10,'码头相声大会','铁嘴老周','抖包袱不断更新的直播剪辑','相声','🎙️','p5',4400000,1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(11,'茶馆夜话·单口集','醒木先生','一块醒木，半城旧事','相声','🍵','p7',1900000,2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(12,'晚风情感电台','主播·岛屿她','深夜来电：把心事说给海风听','情感','💌','p4',9800000,1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(13,'写给灯塔的一百封信','主播·暖洋','一百个听众投稿的真实故事','情感','✉️','p3',2600000,2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(14,'漂流瓶树洞','主播·拾贝','捡到的每一个瓶子都有一段心事','情感','🍀','p5',1500000,3,'2026-11-05 13:53:11','2026-11-05 13:53:11',0);
/*!40000 ALTER TABLE `audiobook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel`
--

DROP TABLE IF EXISTS `channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `channel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '频道名称',
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '频道图标(emoji)',
  `tone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'p1' COMMENT '图标底色渐变编号 p1~p8',
  `listeners` bigint NOT NULL DEFAULT '0' COMMENT '当前在听人数',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '展示顺序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='热门频道';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel`
--

LOCK TABLES `channel` WRITE;
/*!40000 ALTER TABLE `channel` DISABLE KEYS */;
INSERT INTO `channel` VALUES (1,'早安海底电台','☀️','p3',860000,1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(2,'深夜故事馆','🌙','p1',620000,2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(3,'白噪音专注舱','🎧','p8',1200000,3,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(4,'民谣小馆','🪕','p7',450000,4,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(5,'古典音乐沙龙','🎻','p5',380000,5,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(6,'影视原声站','🎬','p2',540000,6,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(7,'国风雅集','🏮','p4',720000,7,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(8,'儿童故事堡','🏰','p6',290000,8,'2026-11-05 13:53:11','2026-11-05 13:53:11',0);
/*!40000 ALTER TABLE `channel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chart`
--

DROP TABLE IF EXISTS `chart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '榜单名称',
  `tone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'blue' COMMENT '榜单头配色：orange/blue/purple/teal',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '展示顺序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='热门榜单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart`
--

LOCK TABLES `chart` WRITE;
/*!40000 ALTER TABLE `chart` DISABLE KEYS */;
INSERT INTO `chart` VALUES (1,'飙升榜','orange',1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(2,'新歌榜','teal',2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(3,'TOP500','blue',3,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(4,'原创榜','purple',4,'2026-11-05 13:53:11','2026-11-05 13:53:11',0);
/*!40000 ALTER TABLE `chart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chart_song`
--

DROP TABLE IF EXISTS `chart_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chart_song` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `chart_id` bigint NOT NULL COMMENT '所属榜单 id',
  `rank_no` int NOT NULL COMMENT '名次(从 1 开始)',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌曲名',
  `artist` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌手/乐队',
  `trend` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'flat' COMMENT '趋势：up升 down降 flat持平 new新进',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_chart_rank` (`chart_id`,`rank_no`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='榜单歌曲';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart_song`
--

LOCK TABLES `chart_song` WRITE;
/*!40000 ALTER TABLE `chart_song` DISABLE KEYS */;
INSERT INTO `chart_song` VALUES (1,1,1,'潮汐信号','蓝鲸乐队','up',0),(2,1,2,'凌晨三点的灯塔','岛屿她','new',0),(3,1,3,'逆流而上','风暴少年','up',0),(4,1,4,'环礁日落','Coral·珊瑚','flat',0),(5,1,5,'咸鱼翻身进行曲','打工人合唱团','down',0),(6,2,1,'夏天的最后一天','南屿风','new',0),(7,2,2,'北极星快车','星野次郎','up',0),(8,2,3,'薄荷味晚风','薄雾人声','new',0),(9,2,4,'无人区漫游指南','荒原旅人','flat',0),(10,2,5,'发光的碎片','萤火虫计划','down',0),(11,3,1,'深海回响','鲸落Koi','flat',0),(12,3,2,'把海风装进口袋','海盐汽水','up',0),(13,3,3,'灯塔与船','老船长','flat',0),(14,3,4,'月光泳者','夜巡乐队','up',0),(15,3,5,'泡沫巡逻艇','泡泡糖少女','down',0),(16,4,1,'齿轮与向日葵','独立计划','up',0),(17,4,2,'修船厂情歌','铁与木','new',0),(18,4,3,'候鸟备忘录','迁徙图书馆','flat',0),(19,4,4,'蒸汽波渔港','VR镇渔民','up',0),(20,4,5,'后巷口琴师','口琴老周','flat',0);
/*!40000 ALTER TABLE `chart_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_message`
--

DROP TABLE IF EXISTS `chat_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_message` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '发送用户 id',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_chat_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='聊天室消息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_message`
--

LOCK TABLES `chat_message` WRITE;
/*!40000 ALTER TABLE `chat_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `chat_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `douyin_hot_song`
--

DROP TABLE IF EXISTS `douyin_hot_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `douyin_hot_song` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rank_no` int NOT NULL COMMENT '名次(从 1 开始)',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌曲名',
  `artist` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌手/乐队',
  `album` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属专辑',
  `duration` int NOT NULL DEFAULT '0' COMMENT '时长（秒）',
  `hot_value` bigint NOT NULL DEFAULT '0' COMMENT '热度值（用于展示排序）',
  `trend` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'flat' COMMENT '趋势：up升 down降 flat持平 new新进',
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '真实音源直链（可选，存在则优先播放）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  `song_id` bigint DEFAULT NULL COMMENT '鍏宠仈涓绘洸搴?song.id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_rank` (`rank_no`) USING BTREE,
  KEY `idx_hot` (`hot_value`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='抖音热歌榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `douyin_hot_song`
--

LOCK TABLES `douyin_hot_song` WRITE;
/*!40000 ALTER TABLE `douyin_hot_song` DISABLE KEYS */;
INSERT INTO `douyin_hot_song` VALUES (1,1,'晚风告白','陈亦楠','晚风告白',215,128000000,'up',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,124),(2,2,'若月亮没来','于适','若月亮没来',232,115000000,'up',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,125),(3,3,'小美满','周深','小美满',224,98000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,126),(4,4,'苹果香','汪苏泷','苹果香',201,91000000,'up',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,127),(5,5,'APT.','Rosé & Bruno Mars','APT.',173,88000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,128),(6,6,'青花','周传雄','青花',286,76000000,'up',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,129),(7,7,'落日与晚风','林忆莲','落日与晚风',248,69000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,130),(8,8,'向云端','刀郎','山歌寥哉',265,64000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,131),(9,9,'罗刹海市','刀郎','山歌寥哉',315,61000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,132),(10,10,'海阔天空','Beyond','乐与怒',326,57000000,'up',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,104),(11,11,'一路生花','温奕心','一路生花',228,52000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,133),(12,12,'我记得','赵雷','署前街少年',294,48000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,134),(13,13,'起风了','买辣椒也用券','起风了',259,45000000,'up',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,31),(14,14,'我会等','张杰','我会等',236,43000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,135),(15,15,'孤勇者','陈奕迅','孤勇者',271,41000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,136),(16,16,'笼','林俊杰','笼',243,38000000,'up',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,137),(17,17,'心动','王菲','王菲同名专辑',217,35000000,'new',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,138),(18,18,'如愿','王菲','如愿',274,33000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,139),(19,19,'人世间','雷佳','人世间',288,31000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,140),(20,20,'无名的人','毛不易','无名的人',256,29000000,'new',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,141),(21,21,'送你一朵小红花','赵英俊','送你一朵小红花',240,27000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,142),(22,22,'这世界那么多人','莫文蔚','这世界那么多人',262,25000000,'up',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,143),(23,23,'笼中鸟','李荣浩','笼中鸟',231,23000000,'new',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,144),(24,24,'大梦归','周深','兰香如故 影视原声带',245,21000000,'new',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,145),(25,25,'成都','赵雷','赵小雷',312,19000000,'up',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,34),(26,26,'鼓楼','赵雷','无法长大',258,17000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,146),(27,27,'茶汤','郁可唯','微加幸福',223,15000000,'new',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,147),(28,28,'态度','田栩宁','X',208,13000000,'new',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,148),(29,29,'雨终曲','宋雨琦','雨终曲',219,11000000,'new',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,149),(30,30,'我记得','房东的猫','New Boy',204,9000000,'flat',NULL,'2026-11-05 14:24:04','2026-11-12 14:07:39',0,150);
/*!40000 ALTER TABLE `douyin_hot_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_comment`
--

DROP TABLE IF EXISTS `forum_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forum_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '所属帖子 id',
  `user_id` bigint NOT NULL COMMENT '评论用户 id',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `likes` bigint NOT NULL DEFAULT '0' COMMENT '点赞数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_comment_post` (`post_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='论坛评论';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_comment`
--

LOCK TABLES `forum_comment` WRITE;
/*!40000 ALTER TABLE `forum_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_post`
--

DROP TABLE IF EXISTS `forum_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forum_post` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '发帖用户 id',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '帖子标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '帖子正文',
  `category` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'music' COMMENT '帖子板块：music闲聊/song歌单/sing唱歌/story听歌故事/help求助',
  `likes` bigint NOT NULL DEFAULT '0' COMMENT '点赞数',
  `comments` bigint NOT NULL DEFAULT '0' COMMENT '评论数',
  `views` bigint NOT NULL DEFAULT '0' COMMENT '浏览数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_post_user` (`user_id`) USING BTREE,
  KEY `idx_post_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='论坛帖子';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_post`
--

LOCK TABLES `forum_post` WRITE;
/*!40000 ALTER TABLE `forum_post` DISABLE KEYS */;
INSERT INTO `forum_post` VALUES (4,1,'宿敌','这首歌真好听','music',2,0,2,'2026-11-16 09:08:07',0);
/*!40000 ALTER TABLE `forum_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kugou_hot_song`
--

DROP TABLE IF EXISTS `kugou_hot_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kugou_hot_song` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rank_no` int NOT NULL COMMENT '名次(从 1 开始)',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌曲名',
  `artist` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌手/乐队',
  `album` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属专辑',
  `duration` int NOT NULL DEFAULT '0' COMMENT '时长（秒）',
  `hot_value` bigint NOT NULL DEFAULT '0' COMMENT '热度值（用于展示排序）',
  `trend` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'flat' COMMENT '趋势：up升 down降 flat持平 new新进',
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '真实音源直链（可选，存在则优先播放）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  `song_id` bigint DEFAULT NULL COMMENT '鍏宠仈涓绘洸搴?song.id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_rank` (`rank_no`) USING BTREE,
  KEY `idx_hot` (`hot_value`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='酷狗热歌榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kugou_hot_song`
--

LOCK TABLES `kugou_hot_song` WRITE;
/*!40000 ALTER TABLE `kugou_hot_song` DISABLE KEYS */;
INSERT INTO `kugou_hot_song` VALUES (1,1,'晴天','周杰伦','叶惠美',269,156000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,93),(2,2,'稻香','周杰伦','魔杰座',223,138000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,94),(3,3,'青花瓷','周杰伦','我很忙',239,121000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,95),(4,4,'江南','林俊杰','第二天堂',267,132000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,96),(5,5,'演员','薛之谦','意外',261,108000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,64),(6,6,'十年','陈奕迅','黑·白·灰',246,98000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,97),(7,7,'浮夸','陈奕迅','U87',267,92000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,98),(8,8,'富士山下','陈奕迅','What\'s Going On...?',285,85000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,99),(9,9,'吻别','张学友','吻别',278,88000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,100),(10,10,'一千个伤心的理由','张学友','真爱新曲+精选',269,76000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,101),(11,11,'泡沫','G.E.M.邓紫棋','Xposed',271,82000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,102),(12,12,'光年之外','G.E.M.邓紫棋','光年之外',235,74000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,103),(13,13,'海阔天空','Beyond','乐与怒',326,79000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,104),(14,14,'光辉岁月','Beyond','命运派对',302,71000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,105),(15,15,'素颜','许嵩、何曼婷','寻雾启示',238,66000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,106),(16,16,'南山南','马頔','孤鸟的歌',305,58000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,107),(17,17,'成都','赵雷','赵小雷',312,61000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,34),(18,18,'小幸运','田馥甄','小幸运',267,56000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,108),(19,19,'倔强','五月天','神的孩子都在跳舞',258,53000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,109),(20,20,'突然好想你','五月天','后青春期的诗',271,51000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,110),(21,21,'告白气球','周杰伦','周杰伦的床边故事',255,62000000,'new',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,111),(22,22,'七里香','周杰伦','七里香',299,54000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,112),(23,23,'不为谁而作的歌','林俊杰','和自己对话',280,49000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,113),(24,24,'她说','林俊杰','她说 概念自选辑',258,46000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,114),(25,25,'红豆','王菲','唱游',264,44000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,115),(26,26,'容易受伤的女人','王菲','Coming Home',259,41000000,'new',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,116),(27,27,'不将就','李荣浩','有理想',302,39000000,'up',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,117),(28,28,'年少有为','李荣浩','年少有为',276,37000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,118),(29,29,'体面','于文文','体面',265,35000000,'new',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,82),(30,30,'往后余生','马良','往后余生',249,33000000,'flat',NULL,'2026-11-05 14:40:59','2026-11-12 14:07:39',0,45);
/*!40000 ALTER TABLE `kugou_hot_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_history`
--

DROP TABLE IF EXISTS `login_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户 id（关联 user.id）',
  `account` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账户（手机号/邮箱/用户名）',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '登录时昵称快照',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '登录来源 IP',
  `login_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_login_time` (`login_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='登录历史表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_history`
--

LOCK TABLES `login_history` WRITE;
/*!40000 ALTER TABLE `login_history` DISABLE KEYS */;
INSERT INTO `login_history` VALUES (1,4,'111','111','127.0.0.1','2026-11-16 08:59:11',0),(2,1,'123','十一','127.0.0.1','2026-11-16 09:02:54',0),(3,1,'123','十一','127.0.0.1','2026-11-16 09:14:11',0),(4,1,'123','十一','127.0.0.1','2026-11-16 09:14:23',0),(5,4,'111','111','127.0.0.1','2026-11-16 09:14:34',0),(6,1,'123','十一','127.0.0.1','2026-11-16 09:15:16',0),(7,1,'123','十一','127.0.0.1','2026-11-16 09:16:07',0),(8,1,'123','十一','127.0.0.1','2026-11-16 09:18:25',0),(9,1,'123','十一','127.0.0.1','2026-11-16 09:19:02',0),(10,1,'123','十一','127.0.0.1','2026-11-16 09:19:37',0),(11,1,'123','十一','127.0.0.1','2026-11-16 09:20:01',0),(12,4,'111','111','127.0.0.1','2026-11-16 09:20:25',0),(13,1,'123','十一','127.0.0.1','2026-11-16 09:24:58',0),(14,1,'123','十一','127.0.0.1','2026-11-16 09:25:44',0),(15,4,'111','111','127.0.0.1','2026-11-16 09:43:50',0),(16,14,'GAY','GAY','127.0.0.1','2026-11-16 09:49:16',0);
/*!40000 ALTER TABLE `login_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netease_hot_song`
--

DROP TABLE IF EXISTS `netease_hot_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `netease_hot_song` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rank_no` int NOT NULL COMMENT '名次(从 1 开始)',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌曲名',
  `artist` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌手/乐队',
  `album` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属专辑',
  `duration` int NOT NULL DEFAULT '0' COMMENT '时长（秒）',
  `hot_value` bigint NOT NULL DEFAULT '0' COMMENT '热度值（用于展示排序）',
  `trend` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'flat' COMMENT '趋势：up升 down降 flat持平 new新进',
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '真实音源直链（可选，存在则优先播放）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  `song_id` bigint DEFAULT NULL COMMENT '鍏宠仈涓绘洸搴?song.id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_rank` (`rank_no`) USING BTREE,
  KEY `idx_hot` (`hot_value`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='网易云热歌榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netease_hot_song`
--

LOCK TABLES `netease_hot_song` WRITE;
/*!40000 ALTER TABLE `netease_hot_song` DISABLE KEYS */;
INSERT INTO `netease_hot_song` VALUES (1,1,'起风了','买辣椒也用券','起风了',259,152000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,31),(2,2,'安和桥','宋冬野','安和桥北',272,143000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,32),(3,3,'理想','赵雷','无法长大',324,136000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,33),(4,4,'成都','赵雷','赵小雷',312,129000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,34),(5,5,'小半','陈粒','小梦大半',275,122000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,35),(6,6,'易燃易爆炸','陈粒','如也',254,116000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,36),(7,7,'妙龄童','陈粒','如也',241,109000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,37),(8,8,'云烟成雨','房东的猫','房东的猫',251,103000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,38),(9,9,'美好事物','房东的猫','美好事物',262,98000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,39),(10,10,'水星记','郭顶','飞行器的执行周期',285,94000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,40),(11,11,'凄美地','郭顶','飞行器的执行周期',289,90000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,41),(12,12,'不染','毛不易','香蜜沉沉烬如霜',273,86000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,42),(13,13,'消愁','毛不易','平凡的一天',294,83000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,43),(14,14,'像我这样的人','毛不易','平凡的一天',262,80000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,44),(15,15,'往后余生','马良','往后余生',249,76000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,45),(16,16,'理想三旬','陈鸿宇','浓烟下的诗歌电台',302,73000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,46),(17,17,'借我','谢春花','算云烟',256,70000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,47),(18,18,'春风十里','鹿先森乐队','所有的酒，都不如你',265,67000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,48),(19,19,'鸽子','宋冬野','安和桥北',261,64000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,49),(20,20,'董小姐','宋冬野','安和桥北',278,61000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,50),(21,21,'像我这样的年纪','一支榴莲','像我这样的年纪',249,58000000,'new',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,51),(22,22,'出现又离开','梁博','梁博',324,55000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,52),(23,23,'男孩','梁博','梁博',291,52000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,53),(24,24,'刻在我心底的名字','卢广仲','刻在我心底的名字',288,49000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,54),(25,25,'归途有风','海来阿木','归途有风',246,46000000,'new',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,55),(26,26,'醒不来的梦','回小仙','醒不来的梦',258,43000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,56),(27,27,'错位时空','艾辰','错位时空',268,40000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,57),(28,28,'我会等','承桓','我会等',251,37000000,'new',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,58),(29,29,'善变','王靖雯','善变',247,34000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,59),(30,30,'就忘了吧','1K','就忘了吧',253,31000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,60);
/*!40000 ALTER TABLE `netease_hot_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `play_history`
--

DROP TABLE IF EXISTS `play_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `play_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户 id',
  `song_id` bigint NOT NULL COMMENT '歌曲 id',
  `duration` int NOT NULL DEFAULT '0' COMMENT '本次收听的秒数',
  `played_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '播放时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_time` (`user_id`,`played_at`) USING BTREE,
  KEY `idx_song` (`song_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户播放历史表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `play_history`
--

LOCK TABLES `play_history` WRITE;
/*!40000 ALTER TABLE `play_history` DISABLE KEYS */;
INSERT INTO `play_history` VALUES (4,1,11,284,'2026-11-12 14:03:31',0),(5,1,3,185,'2026-11-12 14:04:07',0),(6,1,130,248,'2026-11-12 14:12:59',0),(7,4,31,259,'2026-11-12 14:15:57',0),(9,4,135,236,'2026-11-12 14:20:18',0),(10,4,136,271,'2026-11-12 14:24:15',0),(14,4,137,243,'2026-11-12 14:28:47',0),(16,1,93,269,'2026-11-12 14:37:38',0),(17,1,94,223,'2026-11-12 14:42:08',0),(18,1,95,239,'2026-11-12 14:45:52',0),(19,1,96,267,'2026-11-12 14:49:52',0),(20,1,64,261,'2026-11-12 14:54:21',0),(21,1,97,246,'2026-11-12 14:58:43',0),(22,4,64,261,'2026-11-16 08:59:22',0),(23,4,126,224,'2026-11-16 08:59:30',0),(24,4,63,320,'2026-11-16 08:59:37',0),(25,1,100,278,'2026-11-16 09:03:03',0),(26,1,66,264,'2026-11-16 09:03:17',0),(27,1,101,269,'2026-11-16 09:07:42',0),(28,1,67,276,'2026-11-16 09:07:42',0),(29,1,102,271,'2026-11-16 09:12:12',0),(30,1,68,260,'2026-11-16 09:12:20',0),(31,1,69,260,'2026-11-16 09:16:41',0),(32,1,103,235,'2026-11-16 09:16:45',0),(33,4,66,264,'2026-11-16 09:20:39',0),(34,1,66,264,'2026-11-16 09:20:45',0),(35,1,66,264,'2026-11-16 09:24:02',0),(36,1,67,276,'2026-11-16 09:25:09',0),(37,1,100005,0,'2026-11-16 09:28:26',0),(38,1,68,260,'2026-11-16 09:29:45',0),(39,1,66,264,'2026-11-16 09:29:46',0),(40,1,66,264,'2026-11-16 09:29:46',0),(41,1,66,264,'2026-11-16 09:29:48',0),(42,1,66,264,'2026-11-16 09:29:48',0),(43,1,69,260,'2026-11-16 09:34:05',0),(44,1,68,260,'2026-11-16 09:34:12',0),(45,1,70,273,'2026-11-16 09:38:25',0),(46,1,67,276,'2026-11-16 09:38:33',0),(47,1,71,225,'2026-11-16 09:42:58',0),(48,1,103,235,'2026-11-16 09:43:09',0),(49,1,72,271,'2026-11-16 09:46:45',0),(50,1,69,260,'2026-11-16 09:47:04',0),(51,14,124,215,'2026-11-16 09:49:24',0);
/*!40000 ALTER TABLE `play_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist`
--

DROP TABLE IF EXISTS `playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌单标题',
  `subtitle` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '副标题/一句话介绍',
  `tag` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分类标签',
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面装饰图标(emoji)',
  `tone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'p1' COMMENT '封面渐变配色编号 p1~p8',
  `plays` bigint NOT NULL DEFAULT '0' COMMENT '播放量',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '展示顺序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_title` (`title`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='精选歌单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist`
--

LOCK TABLES `playlist` WRITE;
/*!40000 ALTER TABLE `playlist` DISABLE KEYS */;
INSERT INTO `playlist` VALUES (1,'深海午夜电台','深夜循环的 60 首氛围感神游曲','睡前','🎧','p1',32860000,1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(2,'冲浪摇滚现场','把音量拧到最大，跟着浪尖起跳','摇滚','🎸','p2',9720000,2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(3,'自习室白噪音','高效专注 · 图书馆盖章款 BGM','专注','🎹','p3',187300000,3,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(4,'华语新声捞星','每周五更新，捞一捞刚冒头的好声音','华语','🎤','p4',45210000,4,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(5,'落日爵士酒馆','微醺时刻的萨克斯与旧钢琴','爵士','🎷','p5',6310000,5,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(6,'健身暴汗燃料','180BPM 起步，多巴胺拉满','运动','🥁','p6',21090000,6,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(7,'民谣与远方','木吉他、旧火车和慢慢的生活','民谣','🎻','p7',15840000,7,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(8,'海底两万里','电子合成器潜入深蓝的听觉旅行','电子','📻','p8',8470000,8,'2026-11-05 13:53:11','2026-11-05 13:53:11',0);
/*!40000 ALTER TABLE `playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qq_hot_song`
--

DROP TABLE IF EXISTS `qq_hot_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qq_hot_song` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rank_no` int NOT NULL COMMENT '名次(从 1 开始)',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌曲名',
  `artist` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌手/乐队',
  `album` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属专辑',
  `duration` int NOT NULL DEFAULT '0' COMMENT '时长（秒）',
  `hot_value` bigint NOT NULL DEFAULT '0' COMMENT '热度值（用于展示排序）',
  `trend` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'flat' COMMENT '趋势：up升 down降 flat持平 new新进',
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '真实音源直链（可选，存在则优先播放）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  `song_id` bigint DEFAULT NULL COMMENT '鍏宠仈涓绘洸搴?song.id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_rank` (`rank_no`) USING BTREE,
  KEY `idx_hot` (`hot_value`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='QQ音乐热歌榜';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qq_hot_song`
--

LOCK TABLES `qq_hot_song` WRITE;
/*!40000 ALTER TABLE `qq_hot_song` DISABLE KEYS */;
INSERT INTO `qq_hot_song` VALUES (1,1,'发如雪','周杰伦','十一月的萧邦',299,168000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,62),(2,2,'我不难过','孙燕姿','未完成',320,152000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,63),(3,3,'演员','薛之谦','意外',261,145000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,64),(4,4,'我怀念的','孙燕姿','逆光',289,138000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,65),(5,5,'天龙八部之宿敌','许嵩','苏格拉没有底',264,131000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,66),(6,6,'季候风','王菲','讨好自己',276,124000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,67),(7,7,'雨爱','杨丞琳','半熟宣言',260,118000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,68),(8,8,'情歌','梁静茹','静茹&情歌',260,112000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,69),(9,9,'幻听','许嵩','寻雾启示',273,106000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,70),(10,10,'Always Online','林俊杰','JJ陆',225,101000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,71),(11,11,'开始懂了','孙燕姿','我要的幸福',271,98000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,72),(12,12,'爱错','王力宏','改变自己',238,94000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,73),(13,13,'春娇与志明','街道办GDC、欧阳耀莹','春娇与志明',204,90000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,74),(14,14,'自由的你','G.E.M.邓紫棋','自由的你',296,88000000,'new',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,75),(15,15,'恋人','李荣浩','恋人',275,84000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,76),(16,16,'甲乙丙丁','李佳薇','甲乙丙丁',210,80000000,'new',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,77),(17,17,'我好像在哪见过你','薛之谦','怪咖',279,77000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,78),(18,18,'特别的人','方大同','危险世界',259,73000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,79),(19,19,'泪海','许茹芸','如果云知道',298,69000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,80),(20,20,'天亮了','韩红','天亮了',274,65000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,81),(21,21,'体面','于文文','体面',265,62000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,82),(22,22,'凉凉','杨宗纬、张碧晨','三生三世十里桃花',320,59000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,83),(23,23,'夜空中最亮的星','逃跑计划','世界',276,56000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,84),(24,24,'追光者','岑宁儿','追光者',238,53000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,85),(25,25,'平凡之路','朴树','猎户星座',315,50000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,86),(26,26,'那些年','胡夏','那些年',316,47000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,87),(27,27,'一次就好','杨宗纬','一次就好',267,44000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,88),(28,28,'斑马斑马','宋冬野','安和桥北',257,41000000,'new',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,89),(29,29,'南方姑娘','赵雷','赵小雷',304,38000000,'flat',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,90),(30,30,'理想','赵雷','无法长大',324,35000000,'up',NULL,'2026-11-05 14:47:56','2026-11-12 14:07:39',0,33);
/*!40000 ALTER TABLE `qq_hot_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `singer`
--

DROP TABLE IF EXISTS `singer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `singer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌手/乐队名',
  `tab` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '地区分类：华语/欧美/日韩',
  `fans` bigint NOT NULL DEFAULT '0' COMMENT '粉丝数',
  `tone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'p1' COMMENT '头像渐变配色编号 p1~p8',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '展示顺序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='热门歌手';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `singer`
--

LOCK TABLES `singer` WRITE;
/*!40000 ALTER TABLE `singer` DISABLE KEYS */;
INSERT INTO `singer` VALUES (1,'鲸落Koi','华语',9800000,'p1',1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(2,'岛屿她','华语',7600000,'p4',2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(3,'蓝鲸乐队','华语',5400000,'p2',3,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(4,'海盐汽水','华语',4200000,'p3',4,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(5,'午夜DJ鲨','华语',3100000,'p7',5,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(6,'星野次郎','日韩',3500000,'p8',1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(7,'波浪少女组','日韩',2200000,'p6',2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(8,'Luna Tide','欧美',2800000,'p5',1,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(9,'Ocean Kids','欧美',1900000,'p3',2,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(10,'Vinyl Brothers','欧美',1300000,'p2',3,'2026-11-05 13:53:11','2026-11-05 13:53:11',0);
/*!40000 ALTER TABLE `singer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌曲名',
  `artist` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌手/乐队',
  `album` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属专辑',
  `duration` int NOT NULL DEFAULT '0' COMMENT '时长（秒）',
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '真实音源直链（可选，存在则优先播放）',
  `plays` bigint NOT NULL DEFAULT '0' COMMENT '播放量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_title_artist` (`title`,`artist`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='曲库歌曲';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,'潮汐信号','蓝鲸乐队','深海电台',222,NULL,982000,'2026-11-05 13:53:11','2026-11-05 14:12:36',0),(2,'凌晨三点的灯塔','岛屿她','夜航船',255,NULL,745000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(3,'逆流而上','风暴少年','冲浪手册',185,NULL,512000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(4,'环礁日落','Coral·珊瑚','环礁日志',238,NULL,388000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(5,'咸鱼翻身进行曲','打工人合唱团','格子间战歌',178,NULL,1250000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(6,'夏天的最后一天','南屿风','夏末备忘录',272,NULL,654000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(7,'北极星快车','星野次郎','夜行列车',227,NULL,421000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(8,'薄荷味晚风','薄雾人声','雾中风景',243,NULL,366000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(9,'无人区漫游指南','荒原旅人','公路片原声',312,NULL,233000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(10,'发光的碎片','萤火虫计划','夏夜观测',206,NULL,305000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(11,'深海回响','鲸落Koi','深海回响',284,NULL,9870000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(12,'把海风装进口袋','海盐汽水','盐汽水',213,NULL,1520000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(13,'灯塔与船','老船长','水手歌谣',249,NULL,876000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(14,'月光泳者','夜巡乐队','夜巡',231,NULL,402000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(15,'泡沫巡逻艇','泡泡糖少女','泡泡糖星球',167,NULL,289000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(16,'齿轮与向日葵','独立计划','车间抒情诗',258,NULL,512000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(17,'修船厂情歌','铁与木','铁与木',281,NULL,358000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(18,'候鸟备忘录','迁徙图书馆','飞行日志',219,NULL,275000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(19,'蒸汽波渔港','VR镇渔民','电子渔港',194,NULL,447000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(20,'后巷口琴师','口琴老周','旧城十二巷',303,NULL,198000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(21,'深海午夜电台','午夜DJ鲨','凌晨零点',296,NULL,620000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(22,'环岛慢车','慢速铁轨','慢速铁轨',202,NULL,234000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(23,'冲浪第一课','风暴少年','冲浪手册',180,NULL,189000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(24,'鲨鱼晚安曲','岛屿她','夜航船',228,NULL,933000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(25,'盐雾吉他','铁与木','铁与木',252,NULL,176000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(26,'城市潜水员','夜巡乐队','夜巡',235,NULL,268000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(27,'珊瑚色的梦','Coral·珊瑚','环礁日志',268,NULL,315000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(28,'平流层放风筝','星野次郎','夜行列车',216,NULL,154000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(29,'自习室摇椅','打工人合唱团','格子间战歌',171,NULL,426000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(30,'蓝色隧道','鲸落Koi','深海回响',321,NULL,702000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(31,'起风了','买辣椒也用券','起风了',259,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(32,'安和桥','宋冬野','安和桥北',272,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(33,'理想','赵雷','无法长大',324,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(34,'成都','赵雷','赵小雷',312,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(35,'小半','陈粒','小梦大半',275,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(36,'易燃易爆炸','陈粒','如也',254,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(37,'妙龄童','陈粒','如也',241,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(38,'云烟成雨','房东的猫','房东的猫',251,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(39,'美好事物','房东的猫','美好事物',262,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(40,'水星记','郭顶','飞行器的执行周期',285,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(41,'凄美地','郭顶','飞行器的执行周期',289,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(42,'不染','毛不易','香蜜沉沉烬如霜',273,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(43,'消愁','毛不易','平凡的一天',294,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(44,'像我这样的人','毛不易','平凡的一天',262,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(45,'往后余生','马良','往后余生',249,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(46,'理想三旬','陈鸿宇','浓烟下的诗歌电台',302,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(47,'借我','谢春花','算云烟',256,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(48,'春风十里','鹿先森乐队','所有的酒，都不如你',265,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(49,'鸽子','宋冬野','安和桥北',261,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(50,'董小姐','宋冬野','安和桥北',278,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(51,'像我这样的年纪','一支榴莲','像我这样的年纪',249,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(52,'出现又离开','梁博','梁博',324,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(53,'男孩','梁博','梁博',291,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(54,'刻在我心底的名字','卢广仲','刻在我心底的名字',288,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(55,'归途有风','海来阿木','归途有风',246,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(56,'醒不来的梦','回小仙','醒不来的梦',258,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(57,'错位时空','艾辰','错位时空',268,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(58,'我会等','承桓','我会等',251,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(59,'善变','王靖雯','善变',247,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(60,'就忘了吧','1K','就忘了吧',253,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(62,'发如雪','周杰伦','十一月的萧邦',299,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(63,'我不难过','孙燕姿','未完成',320,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(64,'演员','薛之谦','意外',261,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(65,'我怀念的','孙燕姿','逆光',289,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(66,'天龙八部之宿敌','许嵩','苏格拉没有底',264,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(67,'季候风','王菲','讨好自己',276,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(68,'雨爱','杨丞琳','半熟宣言',260,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(69,'情歌','梁静茹','静茹&情歌',260,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(70,'幻听','许嵩','寻雾启示',273,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(71,'Always Online','林俊杰','JJ陆',225,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(72,'开始懂了','孙燕姿','我要的幸福',271,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(73,'爱错','王力宏','改变自己',238,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(74,'春娇与志明','街道办GDC、欧阳耀莹','春娇与志明',204,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(75,'自由的你','G.E.M.邓紫棋','自由的你',296,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(76,'恋人','李荣浩','恋人',275,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(77,'甲乙丙丁','李佳薇','甲乙丙丁',210,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(78,'我好像在哪见过你','薛之谦','怪咖',279,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(79,'特别的人','方大同','危险世界',259,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(80,'泪海','许茹芸','如果云知道',298,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(81,'天亮了','韩红','天亮了',274,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(82,'体面','于文文','体面',265,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(83,'凉凉','杨宗纬、张碧晨','三生三世十里桃花',320,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(84,'夜空中最亮的星','逃跑计划','世界',276,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(85,'追光者','岑宁儿','追光者',238,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(86,'平凡之路','朴树','猎户星座',315,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(87,'那些年','胡夏','那些年',316,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(88,'一次就好','杨宗纬','一次就好',267,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(89,'斑马斑马','宋冬野','安和桥北',257,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(90,'南方姑娘','赵雷','赵小雷',304,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(93,'晴天','周杰伦','叶惠美',269,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(94,'稻香','周杰伦','魔杰座',223,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(95,'青花瓷','周杰伦','我很忙',239,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(96,'江南','林俊杰','第二天堂',267,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(97,'十年','陈奕迅','黑·白·灰',246,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(98,'浮夸','陈奕迅','U87',267,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(99,'富士山下','陈奕迅','What\'s Going On...?',285,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(100,'吻别','张学友','吻别',278,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(101,'一千个伤心的理由','张学友','真爱新曲+精选',269,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(102,'泡沫','G.E.M.邓紫棋','Xposed',271,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(103,'光年之外','G.E.M.邓紫棋','光年之外',235,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(104,'海阔天空','Beyond','乐与怒',326,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(105,'光辉岁月','Beyond','命运派对',302,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(106,'素颜','许嵩、何曼婷','寻雾启示',238,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(107,'南山南','马頔','孤鸟的歌',305,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(108,'小幸运','田馥甄','小幸运',267,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(109,'倔强','五月天','神的孩子都在跳舞',258,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(110,'突然好想你','五月天','后青春期的诗',271,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(111,'告白气球','周杰伦','周杰伦的床边故事',255,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(112,'七里香','周杰伦','七里香',299,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(113,'不为谁而作的歌','林俊杰','和自己对话',280,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(114,'她说','林俊杰','她说 概念自选辑',258,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(115,'红豆','王菲','唱游',264,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(116,'容易受伤的女人','王菲','Coming Home',259,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(117,'不将就','李荣浩','有理想',302,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(118,'年少有为','李荣浩','年少有为',276,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(124,'晚风告白','陈亦楠','晚风告白',215,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(125,'若月亮没来','于适','若月亮没来',232,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(126,'小美满','周深','小美满',224,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(127,'苹果香','汪苏泷','苹果香',201,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(128,'APT.','Rosé & Bruno Mars','APT.',173,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(129,'青花','周传雄','青花',286,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(130,'落日与晚风','林忆莲','落日与晚风',248,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(131,'向云端','刀郎','山歌寥哉',265,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(132,'罗刹海市','刀郎','山歌寥哉',315,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(133,'一路生花','温奕心','一路生花',228,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(134,'我记得','赵雷','署前街少年',294,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(135,'我会等','张杰','我会等',236,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(136,'孤勇者','陈奕迅','孤勇者',271,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(137,'笼','林俊杰','笼',243,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(138,'心动','王菲','王菲同名专辑',217,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(139,'如愿','王菲','如愿',274,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(140,'人世间','雷佳','人世间',288,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(141,'无名的人','毛不易','无名的人',256,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(142,'送你一朵小红花','赵英俊','送你一朵小红花',240,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(143,'这世界那么多人','莫文蔚','这世界那么多人',262,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(144,'笼中鸟','李荣浩','笼中鸟',231,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(145,'大梦归','周深','兰香如故 影视原声带',245,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(146,'鼓楼','赵雷','无法长大',258,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(147,'茶汤','郁可唯','微加幸福',223,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(148,'态度','田栩宁','X',208,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(149,'雨终曲','宋雨琦','雨终曲',219,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(150,'我记得','房东的猫','New Boy',204,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0);
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账户（手机号/邮箱/用户名）',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码（BCrypt 哈希密文）',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '头像（URL 或 emoji 标识，空则用昵称首字母）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_account` (`account`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'123','$2a$10$8l6XelQnMQTA9imAdbu6vuue4h7kyQNiUWBzx1nS/G/KXTLHqrgTe','十一','🐟','2026-11-05 14:04:12','2026-11-05 14:04:12',0),(4,'111','$2a$10$D9Qx/qGr2u.xYIz5QJ2/COZ8bZJZcoOFGavgQpvAsIQ2BN/2MSs7K','111',NULL,'2026-11-12 14:05:16','2026-11-12 14:05:16',0),(14,'GAY','$2a$10$zZSAnh6u5goZYFCVdh5W.Oiz4I3zhX93QibwFDhRkWZBBEKUeyz.q','GAY',NULL,'2026-11-16 09:49:16','2026-11-16 09:49:16',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_favorite`
--

DROP TABLE IF EXISTS `user_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户 id',
  `song_id` bigint NOT NULL COMMENT '歌曲 id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_fav` (`user_id`,`song_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户收藏歌曲表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_favorite`
--

LOCK TABLES `user_favorite` WRITE;
/*!40000 ALTER TABLE `user_favorite` DISABLE KEYS */;
INSERT INTO `user_favorite` VALUES (1,1,1,'2026-11-06 14:32:04',1),(2,1,2,'2026-11-06 14:32:04',1),(3,1,11,'2026-11-12 14:03:39',1),(5,1,3,'2026-11-12 14:04:16',1),(9,4,31,'2026-11-12 14:15:58',0),(10,1,31,'2026-11-12 14:16:07',0),(11,1,104,'2026-11-12 14:16:10',0),(12,1,129,'2026-11-12 14:16:12',1),(13,1,95,'2026-11-12 14:16:24',0),(14,1,93,'2026-11-12 14:16:25',0),(15,1,94,'2026-11-12 14:16:27',0),(16,1,66,'2026-11-16 09:07:23',0),(17,14,124,'2026-11-16 09:49:27',0);
/*!40000 ALTER TABLE `user_favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_follow`
--

DROP TABLE IF EXISTS `user_follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_follow` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `follower_id` bigint NOT NULL COMMENT '关注者用户 id（粉丝）',
  `followee_id` bigint NOT NULL COMMENT '被关注用户 id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '关注时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_follow` (`follower_id`,`followee_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户关注关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_follow`
--

LOCK TABLES `user_follow` WRITE;
/*!40000 ALTER TABLE `user_follow` DISABLE KEYS */;
INSERT INTO `user_follow` VALUES (7,1,4,'2026-11-12 15:01:48',0),(8,4,1,'2026-11-16 08:59:50',0);
/*!40000 ALTER TABLE `user_follow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_moment`
--

DROP TABLE IF EXISTS `user_moment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_moment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户 id',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'listen' COMMENT '动态类型',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '动态文本',
  `song_id` bigint DEFAULT NULL COMMENT '关联歌曲 id（可选）',
  `playlist_id` bigint DEFAULT NULL COMMENT '关联歌单 id（可选）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_time` (`user_id`,`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户动态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_moment`
--

LOCK TABLES `user_moment` WRITE;
/*!40000 ALTER TABLE `user_moment` DISABLE KEYS */;
INSERT INTO `user_moment` VALUES (1,1,'favorite','收藏了歌曲「潮汐信号」',1,NULL,'2026-11-06 14:32:04',0),(2,1,'favorite','收藏了歌曲「凌晨三点的灯塔」',2,NULL,'2026-11-06 14:32:04',0),(8,1,'listen','正在听「深海回响」',11,NULL,'2026-11-12 14:03:30',0),(9,1,'favorite','收藏了歌曲「深海回响」',11,NULL,'2026-11-12 14:03:39',0),(10,1,'listen','正在听「逆流而上」',3,NULL,'2026-11-12 14:04:06',0),(11,1,'favorite','收藏了歌曲「逆流而上」',3,NULL,'2026-11-12 14:04:16',0),(13,1,'listen','正在听「落日与晚风」',130,NULL,'2026-11-12 14:12:58',0),(14,4,'listen','正在听「起风了」',31,NULL,'2026-11-12 14:15:57',0),(15,4,'favorite','收藏了歌曲「起风了」',31,NULL,'2026-11-12 14:15:58',0),(16,1,'favorite','收藏了歌曲「起风了」',31,NULL,'2026-11-12 14:16:07',0),(17,1,'favorite','收藏了歌曲「海阔天空」',104,NULL,'2026-11-12 14:16:10',0),(18,1,'favorite','收藏了歌曲「青花」',129,NULL,'2026-11-12 14:16:12',0),(19,1,'favorite','收藏了歌曲「青花瓷」',95,NULL,'2026-11-12 14:16:24',0),(20,1,'favorite','收藏了歌曲「晴天」',93,NULL,'2026-11-12 14:16:25',0),(21,1,'favorite','收藏了歌曲「稻香」',94,NULL,'2026-11-12 14:16:27',0),(22,4,'listen','正在听「我会等」',135,NULL,'2026-11-12 14:20:17',0),(23,4,'listen','正在听「孤勇者」',136,NULL,'2026-11-12 14:24:14',0),(29,4,'listen','正在听「笼」',137,NULL,'2026-11-12 14:28:46',0),(33,1,'listen','正在听「晴天」',93,NULL,'2026-11-12 14:37:38',0),(34,1,'listen','正在听「稻香」',94,NULL,'2026-11-12 14:42:08',0),(35,1,'listen','正在听「青花瓷」',95,NULL,'2026-11-12 14:45:52',0),(36,1,'listen','正在听「江南」',96,NULL,'2026-11-12 14:49:52',0),(37,1,'listen','正在听「演员」',64,NULL,'2026-11-12 14:54:20',0),(38,1,'listen','正在听「十年」',97,NULL,'2026-11-12 14:58:42',0),(39,1,'follow','关注了 111',NULL,NULL,'2026-11-12 15:01:48',0),(40,4,'listen','正在听「演员」',64,NULL,'2026-11-16 08:59:21',0),(41,4,'listen','正在听「小美满」',126,NULL,'2026-11-16 08:59:30',0),(42,4,'listen','正在听「我不难过」',63,NULL,'2026-11-16 08:59:36',0),(43,4,'follow','关注了 十一',NULL,NULL,'2026-11-16 08:59:50',0),(44,1,'listen','正在听「吻别」',100,NULL,'2026-11-16 09:03:03',0),(45,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:03:17',0),(46,1,'favorite','收藏了歌曲「天龙八部之宿敌」',66,NULL,'2026-11-16 09:07:23',0),(47,1,'listen','正在听「一千个伤心的理由」',101,NULL,'2026-11-16 09:07:42',0),(48,1,'listen','正在听「季候风」',67,NULL,'2026-11-16 09:07:42',0),(49,1,'listen','正在听「泡沫」',102,NULL,'2026-11-16 09:12:12',0),(50,1,'listen','正在听「雨爱」',68,NULL,'2026-11-16 09:12:19',0),(51,1,'listen','正在听「情歌」',69,NULL,'2026-11-16 09:16:40',0),(52,1,'listen','正在听「光年之外」',103,NULL,'2026-11-16 09:16:44',0),(53,4,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:20:38',0),(54,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:20:44',0),(55,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:24:01',0),(56,1,'listen','正在听「季候风」',67,NULL,'2026-11-16 09:25:09',0),(57,1,'listen','正在听「」',100005,NULL,'2026-11-16 09:28:26',0),(58,1,'listen','正在听「雨爱」',68,NULL,'2026-11-16 09:29:45',0),(59,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:29:46',0),(60,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:29:46',0),(61,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:29:48',0),(62,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:29:48',0),(63,1,'listen','正在听「情歌」',69,NULL,'2026-11-16 09:34:05',0),(64,1,'listen','正在听「雨爱」',68,NULL,'2026-11-16 09:34:12',0),(65,1,'listen','正在听「幻听」',70,NULL,'2026-11-16 09:38:25',0),(66,1,'listen','正在听「季候风」',67,NULL,'2026-11-16 09:38:32',0),(67,1,'listen','正在听「Always Online」',71,NULL,'2026-11-16 09:42:58',0),(68,1,'listen','正在听「光年之外」',103,NULL,'2026-11-16 09:43:08',0),(69,1,'listen','正在听「开始懂了」',72,NULL,'2026-11-16 09:46:44',0),(70,1,'listen','正在听「情歌」',69,NULL,'2026-11-16 09:47:03',0),(71,14,'listen','正在听「晚风告白」',124,NULL,'2026-11-16 09:49:24',0),(72,14,'favorite','收藏了歌曲「晚风告白」',124,NULL,'2026-11-16 09:49:27',0);
/*!40000 ALTER TABLE `user_moment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_playlist`
--

DROP TABLE IF EXISTS `user_playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_playlist` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '所属用户 id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌单名',
  `cover_tone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'p1' COMMENT '封面配色 p1~p8',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='个人歌单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_playlist`
--

LOCK TABLES `user_playlist` WRITE;
/*!40000 ALTER TABLE `user_playlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'shark_music'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-19 14:05:59
