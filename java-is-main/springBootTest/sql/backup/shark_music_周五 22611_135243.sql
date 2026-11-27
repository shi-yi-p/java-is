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
  `province` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '发帖省份',
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
INSERT INTO `forum_post` VALUES (4,1,'宿敌','这首歌真好听','music','',2,0,2,'2026-11-16 09:08:07',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户播放历史表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `play_history`
--

LOCK TABLES `play_history` WRITE;
/*!40000 ALTER TABLE `play_history` DISABLE KEYS */;
INSERT INTO `play_history` VALUES (4,1,11,284,'2026-11-12 14:03:31',0),(5,1,3,185,'2026-11-12 14:04:07',0),(6,1,130,248,'2026-11-12 14:12:59',0),(7,4,31,259,'2026-11-12 14:15:57',0),(9,4,135,236,'2026-11-12 14:20:18',0),(10,4,136,271,'2026-11-12 14:24:15',0),(14,4,137,243,'2026-11-12 14:28:47',0),(16,1,93,269,'2026-11-12 14:37:38',0),(17,1,94,223,'2026-11-12 14:42:08',0),(18,1,95,239,'2026-11-12 14:45:52',0),(19,1,96,267,'2026-11-12 14:49:52',0),(20,1,64,261,'2026-11-12 14:54:21',0),(21,1,97,246,'2026-11-12 14:58:43',0),(22,4,64,261,'2026-11-16 08:59:22',0),(23,4,126,224,'2026-11-16 08:59:30',0),(24,4,63,320,'2026-11-16 08:59:37',0),(25,1,100,278,'2026-11-16 09:03:03',0),(26,1,66,264,'2026-11-16 09:03:17',0),(27,1,101,269,'2026-11-16 09:07:42',0),(28,1,67,276,'2026-11-16 09:07:42',0),(29,1,102,271,'2026-11-16 09:12:12',0),(30,1,68,260,'2026-11-16 09:12:20',0),(31,1,69,260,'2026-11-16 09:16:41',0),(32,1,103,235,'2026-11-16 09:16:45',0),(33,4,66,264,'2026-11-16 09:20:39',0),(34,1,66,264,'2026-11-16 09:20:45',0),(35,1,66,264,'2026-11-16 09:24:02',0),(36,1,67,276,'2026-11-16 09:25:09',0),(37,1,100005,0,'2026-11-16 09:28:26',0),(38,1,68,260,'2026-11-16 09:29:45',0),(39,1,66,264,'2026-11-16 09:29:46',0),(40,1,66,264,'2026-11-16 09:29:46',0),(41,1,66,264,'2026-11-16 09:29:48',0),(42,1,66,264,'2026-11-16 09:29:48',0),(43,1,69,260,'2026-11-16 09:34:05',0),(44,1,68,260,'2026-11-16 09:34:12',0),(45,1,70,273,'2026-11-16 09:38:25',0),(46,1,67,276,'2026-11-16 09:38:33',0),(47,1,71,225,'2026-11-16 09:42:58',0),(48,1,103,235,'2026-11-16 09:43:09',0),(49,1,72,271,'2026-11-16 09:46:45',0),(50,1,69,260,'2026-11-16 09:47:04',0),(51,14,124,215,'2026-11-16 09:49:24',0),(52,1,104,326,'2026-11-19 14:11:20',0),(53,1,104,326,'2026-11-19 14:11:21',0),(54,1,113,280,'2026-11-19 14:15:02',0),(55,1,93,269,'2026-11-19 14:18:06',0),(56,1,95,239,'2026-11-19 14:21:45',0),(57,1,96,267,'2026-11-19 14:25:45',0),(58,1,64,261,'2026-11-19 14:30:13',0),(59,1,97,246,'2026-11-19 14:34:35',0),(60,1,98,267,'2026-11-19 14:38:42',0),(61,1,99,285,'2026-11-19 14:43:11',0),(62,1,100,278,'2026-11-19 14:47:57',0),(63,1,101,269,'2026-11-19 14:52:36',0),(64,4,64,261,'2026-11-19 14:55:42',0),(65,16,94,223,'2026-11-19 14:56:51',0),(66,1,102,271,'2026-11-19 14:57:06',0),(67,18,102,271,'2026-11-19 14:58:39',0),(68,18,82,265,'2026-11-19 14:58:54',0),(69,18,82,265,'2026-11-19 14:58:54',0),(70,16,124,215,'2026-11-19 15:00:01',0),(71,4,97,246,'2026-11-19 15:00:03',0),(72,1,103,235,'2026-11-19 15:01:38',0),(73,18,45,249,'2026-11-19 15:03:20',0),(74,16,125,232,'2026-11-19 15:03:37',0),(75,4,98,267,'2026-11-19 15:04:09',0),(76,1,104,326,'2026-11-19 15:05:34',0),(77,16,126,224,'2026-11-19 15:07:30',0);
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
  `lyric` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'LRC 歌词（原创，规避版权）',
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
INSERT INTO `song` VALUES (1,'潮汐信号','蓝鲸乐队','深海电台',222,NULL,NULL,982000,'2026-11-05 13:53:11','2026-11-05 14:12:36',0),(2,'凌晨三点的灯塔','岛屿她','夜航船',255,NULL,NULL,745000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(3,'逆流而上','风暴少年','冲浪手册',185,NULL,NULL,512000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(4,'环礁日落','Coral·珊瑚','环礁日志',238,NULL,NULL,388000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(5,'咸鱼翻身进行曲','打工人合唱团','格子间战歌',178,NULL,NULL,1250000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(6,'夏天的最后一天','南屿风','夏末备忘录',272,NULL,NULL,654000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(7,'北极星快车','星野次郎','夜行列车',227,NULL,NULL,421000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(8,'薄荷味晚风','薄雾人声','雾中风景',243,NULL,NULL,366000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(9,'无人区漫游指南','荒原旅人','公路片原声',312,NULL,NULL,233000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(10,'发光的碎片','萤火虫计划','夏夜观测',206,NULL,NULL,305000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(11,'深海回响','鲸落Koi','深海回响',284,NULL,NULL,9870000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(12,'把海风装进口袋','海盐汽水','盐汽水',213,NULL,NULL,1520000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(13,'灯塔与船','老船长','水手歌谣',249,NULL,NULL,876000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(14,'月光泳者','夜巡乐队','夜巡',231,NULL,NULL,402000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(15,'泡沫巡逻艇','泡泡糖少女','泡泡糖星球',167,NULL,NULL,289000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(16,'齿轮与向日葵','独立计划','车间抒情诗',258,NULL,NULL,512000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(17,'修船厂情歌','铁与木','铁与木',281,NULL,NULL,358000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(18,'候鸟备忘录','迁徙图书馆','飞行日志',219,NULL,NULL,275000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(19,'蒸汽波渔港','VR镇渔民','电子渔港',194,NULL,NULL,447000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(20,'后巷口琴师','口琴老周','旧城十二巷',303,NULL,NULL,198000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(21,'深海午夜电台','午夜DJ鲨','凌晨零点',296,NULL,NULL,620000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(22,'环岛慢车','慢速铁轨','慢速铁轨',202,NULL,NULL,234000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(23,'冲浪第一课','风暴少年','冲浪手册',180,NULL,NULL,189000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(24,'鲨鱼晚安曲','岛屿她','夜航船',228,NULL,NULL,933000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(25,'盐雾吉他','铁与木','铁与木',252,NULL,NULL,176000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(26,'城市潜水员','夜巡乐队','夜巡',235,NULL,NULL,268000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(27,'珊瑚色的梦','Coral·珊瑚','环礁日志',268,NULL,NULL,315000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(28,'平流层放风筝','星野次郎','夜行列车',216,NULL,NULL,154000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(29,'自习室摇椅','打工人合唱团','格子间战歌',171,NULL,NULL,426000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(30,'蓝色隧道','鲸落Koi','深海回响',321,NULL,NULL,702000,'2026-11-05 13:53:11','2026-11-05 13:53:11',0),(31,'起风了','买辣椒也用券','起风了',259,NULL,'[00:00.00]起风了 请记得加件衣裳\n[00:30.00]我要去往有你的方向\n[01:00.00]这城市的灯火明明灭灭\n[01:30.00]只有你的名字最亮\n[02:00.00]起风了 我仍在原地张望\n[02:30.00]等一场久别的相拥\n[03:00.00]就算世界天翻地覆\n[03:30.00]我的爱从未改变过',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(32,'安和桥','宋冬野','安和桥北',272,NULL,'[00:00.00]让我再看你一遍 从南到北\n[00:30.00]像是被五环路蒙住的双眼\n[01:00.00]我知道 那些夏天\n[01:30.00]就像你一样回不来\n[02:00.00]我也不会再对谁满怀期待\n[02:30.00]我知道 这个世界\n[03:00.00]每天都有太多遗憾\n[03:30.00]所以你好 再见',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(33,'理想','赵雷','无法长大',324,NULL,'[00:00.00]理想今年你几岁\n[00:30.00]你总是诱惑着年轻的朋友\n[01:00.00]你总是谢了又开 开又谢\n[01:30.00]如此循环往复\n[02:00.00]理想 你曾是少年的梦想\n[02:30.00]如今是否还在发光\n[03:00.00]别让生活磨平了棱角\n[03:30.00]别让理想 死在半路上',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(34,'成都','赵雷','赵小雷',312,NULL,'[00:00.00]成都的街头走一走\n[00:30.00]宽窄巷子到玉林路口\n[01:00.00]一碗茶 一首老歌\n[01:30.00]把时光慢慢熬煮\n[02:00.00]你牵着我的手穿过人流\n[02:30.00]仿佛一辈子都不够\n[03:00.00]如果有一天我要离开\n[03:30.00]最舍不得的 是你和成都',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(35,'小半','陈粒','小梦大半',275,NULL,'[00:00.00]不敢回看 左顾右盼 不自然的暗自喜欢\n[00:40.00]偷偷搭讪 总没完地坐立难安\n[01:20.00]试探说晚安 多空泛又心酸\n[02:00.00]低头呢喃 对你的偏爱太过于明目张胆\n[02:40.00]在原地打转的小丑 伤心不断\n[03:20.00]空空留遗憾 多难堪 又为难',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(36,'易燃易爆炸','陈粒','如也',254,NULL,'[00:00.00]盼我疯魔 还盼我孑孓不独活\n[00:40.00]想我冷艳 还想我轻佻又下贱\n[01:20.00]要我阳光 还要我风情不摇晃\n[02:00.00]戏我哭笑无主 还戏我心如枯木\n[02:40.00]赐我梦境 还赐我很快就清醒\n[03:20.00]与我沉睡 还与我蹉跎无慈悲',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(37,'妙龄童','陈粒','如也',241,NULL,'[00:00.00]你是妙龄童 我是过路人\n[00:40.00]在最好的年纪 遇见最美的你\n[01:20.00]可惜缘分太浅 时光太急\n[02:00.00]我们还没爱够 就要分离\n[02:40.00]愿你从此 前程似锦\n[03:20.00]有人疼你 有人懂你',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(38,'云烟成雨','房东的猫','房东的猫',251,NULL,'[00:00.00]云烟成雨 落在我的窗前\n[00:40.00]像你曾经 温柔的呢喃\n[01:20.00]那些誓言 都化成了雨\n[02:00.00]打湿了 我的思念\n[02:40.00]云烟散去 雨也停歇\n[03:20.00]只是心里的你 从未走远',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(39,'美好事物','房东的猫','美好事物',262,NULL,'[00:00.00]美好事物 总是短暂\n[00:34.00]像花开又谢 像月圆又缺\n[01:08.00]可我仍愿 用力去爱\n[01:42.00]哪怕结局 是场告别\n[02:17.00]因为曾经拥有\n[02:51.00]就已足够温暖\n[03:25.00]这人间 值得',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(40,'水星记','郭顶','飞行器的执行周期',285,NULL,'[00:00.00]环游的行星 怎么可以 拥有你\n[00:34.00]还要多远才能进入你的心\n[01:08.00]还要多久才能和你接近\n[01:42.00]咫尺远近却无法靠近的那个人\n[02:17.00]也等着和你相遇\n[02:51.00]环游的星际 也许有一天\n[03:25.00]能停靠在你的心里',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(41,'凄美地','郭顶','飞行器的执行周期',289,NULL,'[00:00.00]曾为我留下多少惊心动魄的美丽\n[00:48.00]凄美地 开满了不愿凋零的花\n[01:36.00]这世界太喧嚣 只有你懂我的孤独\n[02:24.00]如果我沉入这片凄美地\n[03:12.00]你会不会 来把我捞起',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(42,'不染','毛不易','香蜜沉沉烬如霜',273,NULL,'[00:00.00]不愿染是与非 怎料事与愿违\n[00:40.00]心中的花枯萎 时光它去不回\n[01:20.00]但愿洗去浮华 掸去一身尘灰\n[02:00.00]再与你一壶清酒 话一世沉醉\n[02:40.00]不染世俗 不染尘埃\n[03:20.00]只愿与你 简单相爱',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(43,'消愁','毛不易','平凡的一天',294,NULL,'[00:00.00]一杯敬朝阳 一杯敬月光\n[00:40.00]唤醒我的向往 温柔了寒窗\n[01:20.00]一杯敬故乡 一杯敬远方\n[02:00.00]守着我的善良 催着我成长\n[02:40.00]八杯酒敬完 我依旧迷茫\n[03:20.00]却不再害怕 前路的风霜',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(44,'像我这样的人','毛不易','平凡的一天',262,NULL,'[00:00.00]像我这样优秀的人 本该灿烂过一生\n[00:30.00]怎么二十多年到头来 还在人海里浮沉\n[01:00.00]像我这样聪明的人 早就告别了单纯\n[01:30.00]怎么还是用了一段情 去换一身伤痕\n[02:00.00]像我这样迷茫的人\n[02:30.00]像我这样寻找的人\n[03:00.00]像我这样碌碌无为的人\n[03:30.00]你还见过多少人',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(45,'往后余生','马良','往后余生',249,NULL,'[00:00.00]往后余生 风雪是你\n[00:34.00]平淡是你 清贫也是你\n[01:08.00]荣华是你 心底温柔是你\n[01:42.00]目光所至 也是你\n[02:17.00]想把所有的美好\n[02:51.00]都留给你\n[03:25.00]往后余生 只想是你',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(46,'理想三旬','陈鸿宇','浓烟下的诗歌电台',302,NULL,'[00:00.00]就老去吧 孤独别醒来\n[00:40.00]你渴望的离开 只是无处停摆\n[01:20.00]就歌唱吧 眼睛眯起来\n[02:00.00]而热泪的崩坏 只是没抵达的存在\n[02:40.00]青春又醉倒在 籍籍无名的怀\n[03:20.00]靠嬉笑来虚度 聚散得慷慨',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(47,'借我','谢春花','算云烟',256,NULL,'[00:00.00]借我十年 借我亡命天涯的勇敢\n[00:34.00]借我说得出口的旦旦誓言\n[01:08.00]借我孤绝如初见\n[01:42.00]借我不惧碾压的鲜活\n[02:17.00]借我生猛与莽撞不问明天\n[02:51.00]借我一束光照亮黯淡\n[03:25.00]借我笑颜灿烂如春天',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(48,'春风十里','鹿先森乐队','所有的酒，都不如你',265,NULL,'[00:00.00]我在二环路的里边 想着你\n[00:40.00]你在远方的山上 春风十里\n[01:20.00]今天的风吹向你 下了雨\n[02:00.00]我说所有的酒 都不如你\n[02:40.00]我在鼓楼的夜色中 为你唱花香自来\n[03:20.00]在别处 沉默相遇和期待',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(49,'鸽子','宋冬野','安和桥北',261,NULL,'[00:00.00]鸽子啊 你在蓝天上飞\n[00:30.00]替我看看远方的她\n[01:00.00]是否也像我 在每个夜晚\n[01:30.00]想念着从前的家\n[02:00.00]鸽子啊 你飞过千山万水\n[02:30.00]把我的心事带给她\n[03:00.00]告诉她 我在这里\n[03:30.00]等一个重逢的夏',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(50,'董小姐','宋冬野','安和桥北',278,NULL,'[00:00.00]董小姐 你从没忘记你的微笑\n[00:40.00]就算你和我一样 渴望着衰老\n[01:20.00]董小姐 你嘴角向下的时候很美\n[02:00.00]就像安和桥下 清澈的水\n[02:40.00]所以那些可能都不是真的 董小姐\n[03:20.00]你才不是一个没有故事的女同学',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(51,'像我这样的年纪','一支榴莲','像我这样的年纪',249,NULL,'[00:00.00]像我这样的年纪\n[00:34.00]本该安定下来\n[01:08.00]却还像个孩子 追逐着热爱\n[01:42.00]不羡慕别人的精彩\n[02:17.00]只想活出自己的姿态\n[02:51.00]像我这样的年纪\n[03:25.00]依然相信 未来可期',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(52,'出现又离开','梁博','梁博',324,NULL,'[00:00.00]你出现又离开 像一场意外\n[00:34.00]我还没来得及 好好爱你\n[01:08.00]你就已经不在\n[01:42.00]留下的只有 满地的思念\n[02:17.00]和再也回不去的从前\n[02:51.00]你出现又离开\n[03:25.00]而我 还在原地等待',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(53,'男孩','梁博','梁博',291,NULL,'[00:00.00]你像个小男孩 闯进我的世界\n[00:40.00]带着笑 带着光 带着热烈的爱\n[01:20.00]我愿做你的港湾\n[02:00.00]让你靠岸 让你依赖\n[02:40.00]就算未来风雨再大\n[03:20.00]我也陪你 一起面对',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(54,'刻在我心底的名字','卢广仲','刻在我心底的名字',288,NULL,'[00:00.00]刻在我心底的名字 忘了时间这回事\n[00:40.00]于是谎言说了一次就一辈子\n[01:20.00]曾顽固跟世界对峙\n[02:00.00]觉得连呼吸都是奢侈\n[02:40.00]刻在我心底的名字\n[03:20.00]是我青春里 最痛也最美的诗',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(55,'归途有风','海来阿木','归途有风',246,NULL,'[00:00.00]归途有风 吹散了疲惫\n[00:30.00]吹来了故乡的气息\n[01:00.00]漂泊的人 背起行囊\n[01:30.00]踏上回家的路\n[02:00.00]无论走多远\n[02:30.00]家永远在心头\n[03:00.00]归途有风 有月 有等候\n[03:30.00]是我最温柔的 向往',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(56,'醒不来的梦','回小仙','醒不来的梦',258,NULL,'[00:00.00]我做了一个醒不来的梦\n[00:40.00]梦里有你 还有我们的以后\n[01:20.00]可是闹钟响起 梦就该结束\n[02:00.00]你不在我身边 梦也不再有\n[02:40.00]多希望 能一直睡下去\n[03:20.00]不醒来 就不用面对失去',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(57,'错位时空','艾辰','错位时空',268,NULL,'[00:00.00]我们错位在 不同的时空\n[00:34.00]你的温柔 我的等候\n[01:08.00]像两条平行线 永远没有交点\n[01:42.00]如果时光能重叠\n[02:17.00]你会不会 也为我停留\n[02:51.00]错位的爱 只剩遗憾\n[03:25.00]和一声 无声的叹息',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(58,'我会等','承桓','我会等',251,NULL,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0),(59,'善变','王靖雯','善变',247,NULL,'[00:00.00]你总是善变 让我捉摸不定\n[00:34.00]今天说爱 明天就冷淡\n[01:08.00]我像个傻子 追着你的心情\n[01:42.00]起起落落 患得患失\n[02:17.00]如果爱要这样 让人疲惫\n[02:51.00]我宁愿 放手让你走\n[03:25.00]善变的你 我终究 留不住',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(60,'就忘了吧','1K','就忘了吧',253,NULL,'[00:00.00]就忘了吧 那些说过的话\n[00:30.00]就放了吧 那些犯过的傻\n[01:00.00]人生总要向前看\n[01:30.00]别再为过去挣扎\n[02:00.00]就忘了吧 那个不爱我的人\n[02:30.00]擦干眼泪 重新出发\n[03:00.00]我相信 会有更好的\n[03:30.00]在未来 等着我',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(62,'发如雪','周杰伦','十一月的萧邦',299,NULL,'[00:00.00]你发如雪 凄美了离别\n[00:30.00]我焚香感动了谁\n[01:00.00]邀明月 让回忆皎洁\n[01:30.00]爱在月光下完美\n[02:00.00]你若化成风 我幻化成雨\n[02:30.00]守护你身边 一笑为红颜\n[03:00.00]缘字诀 几番轮回\n[03:30.00]你锁眉 哭红颜唤不回',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(63,'我不难过','孙燕姿','未完成',320,NULL,'[00:00.00]我不难过 这不算什么\n[00:40.00]只是为什么眼泪会流\n[01:20.00]或许是我 太贪恋温柔\n[02:00.00]才没看透 你给的只是停留\n[02:40.00]我不难过 只是心会痛\n[03:20.00]痛过以后 我会学着放手',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(64,'演员','薛之谦','意外',261,NULL,'[00:00.00]该配合你演出的我 演视而不见\n[00:40.00]在你的剧本里做一个好演员\n[01:20.00]只是这戏越演越假\n[02:00.00]我越演越累\n[02:40.00]能不能放下假面\n[03:20.00]回到最初真实的从前',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(65,'我怀念的','孙燕姿','逆光',289,NULL,'[00:00.00]我怀念的是无话不说\n[00:30.00]我怀念的是一起做梦\n[01:00.00]我怀念的是争吵以后\n[01:30.00]还是想要爱你的冲动\n[02:00.00]我怀念的是你给的温柔\n[02:30.00]和那些回不去的以后\n[03:00.00]如今只剩我一个人\n[03:30.00]在回忆里慢慢走',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(66,'天龙八部之宿敌','许嵩','苏格拉没有底',264,NULL,'[00:00.00]刀光剑影里 谁是谁的宿敌\n[00:40.00]恩怨情仇 都写进这江湖\n[01:20.00]我策马扬鞭 只为再见你\n[02:00.00]哪怕与天下为敌\n[02:40.00]这一生 快意恩仇\n[03:20.00]只想与你 浪迹天涯',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(67,'季候风','王菲','讨好自己',276,NULL,'[00:00.00]季候风吹过 吹散了承诺\n[00:40.00]我们就像落叶 各自飘零\n[01:20.00]曾经的誓言 还留在风中\n[02:00.00]只是再没有 你的回应\n[02:40.00]等到下一个季节\n[03:20.00]我还会不会 遇见你',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(68,'雨爱','杨丞琳','半熟宣言',260,NULL,'[00:00.00]这场雨 淋湿了我的爱情\n[00:40.00]你撑伞走远 头也不回\n[01:20.00]雨水混着泪 分不清\n[02:00.00]哪一滴是伤心\n[02:40.00]雨停之后 天会放晴\n[03:20.00]只是我的爱 再也不会来',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(69,'情歌','梁静茹','静茹&情歌',260,NULL,'[00:00.00]你是我唱过最动听的情歌\n[00:40.00]一字一句都为你而作\n[01:20.00]只是这旋律 只剩我独和\n[02:00.00]你已经不在 我的生活\n[02:40.00]如果时光能倒流\n[03:20.00]我愿重新唱这首歌',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(70,'幻听','许嵩','寻雾启示',273,NULL,'[00:00.00]我听见你的声音 在耳边响起\n[00:40.00]明明你已经离去 却像还在原地\n[01:20.00]是我的幻听 还是太想你\n[02:00.00]分不清现实与回忆\n[02:40.00]如果这是病 我宁愿不治\n[03:20.00]就让我沉溺在有你的梦里',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(71,'Always Online','林俊杰','JJ陆',225,NULL,'[00:00.00]Always online 我一直都在\n[00:30.00]无论你在世界哪个角落\n[01:00.00]只要你需要 我就会回应\n[01:30.00]做你永远的后盾\n[02:00.00]我的爱从不离线\n[02:30.00]二十四小时为你守候\n[03:00.00]不管隔着多远\n[03:30.00]我的心 永远为你在线',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(72,'开始懂了','孙燕姿','我要的幸福',271,NULL,'[00:00.00]我开始懂了 你并不爱我\n[00:34.00]只是习惯了我的温柔\n[01:08.00]那些我以为的永远\n[01:42.00]不过是你的将就\n[02:17.00]我开始懂了 该放手\n[02:51.00]让你去找你的以后\n[03:25.00]只是懂了 心却更痛',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(73,'爱错','王力宏','改变自己',238,NULL,'[00:00.00]爱错 是我看走了眼\n[00:34.00]把你当成我的永远\n[01:08.00]付出了所有 换来的却是\n[01:42.00]你冷漠的走远\n[02:17.00]爱错 让我痛彻心扉\n[02:51.00]但我不后悔爱过这一回\n[03:25.00]至少我曾经 真心地爱过',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(74,'春娇与志明','街道办GDC、欧阳耀莹','春娇与志明',204,NULL,'[00:00.00]春娇和志明 平凡的爱情\n[00:40.00]像你和我 在城市里穿行\n[01:20.00]有争吵有甜蜜 有分分合合\n[02:00.00]却始终放不下彼此\n[02:40.00]这就是生活 这就是爱情\n[03:20.00]平平淡淡 却刻骨铭心',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(75,'自由的你','G.E.M.邓紫棋','自由的你',296,NULL,'[00:00.00]自由的你 像风一样无拘无束\n[00:40.00]我想追随 却怕困住你的脚步\n[01:20.00]那就让我做你的天空\n[02:00.00]任你翱翔 任你追逐\n[02:40.00]只要你回头 我就在原地\n[03:20.00]等你找到回家的路',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(76,'恋人','李荣浩','恋人',275,NULL,'[00:00.00]恋人 是清晨的第一缕光\n[00:40.00]是夜晚最温暖的归途\n[01:20.00]牵起你的手 就不想放开\n[02:00.00]这辈子的路 都要一起走\n[02:40.00]恋人是彼此最好的礼物\n[03:20.00]把平凡日子 过成诗',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(77,'甲乙丙丁','李佳薇','甲乙丙丁',210,NULL,'[00:00.00]在人海里 我只是甲乙丙丁\n[00:40.00]却想做你生命里 特别的那个人\n[01:20.00]平凡如我 也有不平凡的心\n[02:00.00]想给你 独一无二的爱情\n[02:40.00]也许我不是最好的\n[03:20.00]但我愿意 为你倾尽所有',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(78,'我好像在哪见过你','薛之谦','怪咖',279,NULL,'[00:00.00]我好像在哪见过你\n[00:30.00]在梦里 还是在回忆\n[01:00.00]你的眉眼那样熟悉\n[01:30.00]像等了很久的相遇\n[02:00.00]也许前世我们曾相守\n[02:30.00]今生才来续这份情\n[03:00.00]我好像在哪见过你\n[03:30.00]在每一次 心跳里',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(79,'特别的人','方大同','危险世界',259,NULL,'[00:00.00]你是特别的人 走进我的生命\n[00:40.00]让平凡的我 也有了光的投影\n[01:20.00]想用余生 好好守护你\n[02:00.00]把你捧在掌心 视若珍宝\n[02:40.00]这世界很大 而你最特别\n[03:20.00]是我唯一 想珍惜的人',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(80,'泪海','许茹芸','如果云知道',298,NULL,'[00:00.00]我的眼泪汇成海\n[00:30.00]把你淹没在回忆里\n[01:00.00]那些你说过的永远\n[01:30.00]都沉入这海底\n[02:00.00]我不怪你 只怪自己\n[02:30.00]太认真 太用力去爱\n[03:00.00]等到泪海干涸\n[03:30.00]我也就学会了 忘记',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(81,'天亮了','韩红','天亮了',274,NULL,'[00:00.00]天亮了 又是新的一天\n[00:34.00]昨夜的心碎 就留在昨天\n[01:08.00]擦干眼泪 继续向前\n[01:42.00]生活还要继续 不能停歇\n[02:17.00]天亮了 阳光会照进\n[02:51.00]心里最暗的角落\n[03:25.00]我相信 一切都会好起来',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(82,'体面','于文文','体面',265,NULL,'[00:00.00]分手应该体面 谁都不要说抱歉\n[00:40.00]何来亏欠 我敢给就敢心碎\n[01:20.00]爱过你 我不后悔\n[02:00.00]只是这次 让我先学会告别\n[02:40.00]再见不负遇见\n[03:20.00]我们都要 好好向前',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(83,'凉凉','杨宗纬、张碧晨','三生三世十里桃花',320,NULL,'[00:00.00]凉凉夜色为你思念成河\n[00:30.00]化作春泥呵护着我\n[01:00.00]浅浅岁月拂满爱人袖\n[01:30.00]片片芳菲入水流\n[02:00.00]凉凉天意潋滟一身花色\n[02:30.00]落入凡尘伤情着我\n[03:00.00]生劫易渡 情劫难了\n[03:30.00]折旧的心 还有几分前生的痴',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(84,'夜空中最亮的星','逃跑计划','世界',276,NULL,'[00:00.00]夜空中最亮的星\n[00:30.00]能否听清 那仰望的人\n[01:00.00]心底的孤独和叹息\n[01:30.00]夜空中最亮的星\n[02:00.00]能否记起 曾与我同行\n[02:30.00]消失在风里的身影\n[03:00.00]我祈祷拥有一颗透明的心灵\n[03:30.00]和会流泪的眼睛',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(85,'追光者','岑宁儿','追光者',238,NULL,'[00:00.00]我可以跟在你身后\n[00:30.00]像影子追着光梦游\n[01:00.00]我可以等在这路口\n[01:30.00]不管你会不会经过\n[02:00.00]每当我为你抬起头\n[02:30.00]连眼泪都觉得自由\n[03:00.00]有的爱像阳光倾落\n[03:30.00]边拥有 边失去着',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(86,'平凡之路','朴树','猎户星座',315,NULL,'[00:00.00]我曾经跨过山和大海\n[00:40.00]也穿过人山人海\n[01:20.00]我曾经拥有着一切\n[02:00.00]转眼都飘散如烟\n[02:40.00]我曾经失落失望 失掉所有方向\n[03:20.00]直到看见平凡 才是唯一的答案',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(87,'那些年','胡夏','那些年',316,NULL,'[00:00.00]那些年错过的大雨\n[00:34.00]那些年错过的爱情\n[01:08.00]好想拥抱你 拥抱错过的勇气\n[01:42.00]曾经想征服全世界\n[02:17.00]到最后回首才发现\n[02:51.00]这世界滴滴点点\n[03:25.00]全部都是你',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(88,'一次就好','杨宗纬','一次就好',267,NULL,'[00:00.00]一次就好 让我陪你去看天荒地老\n[00:40.00]在阳光灿烂的日子里开怀大笑\n[01:20.00]在自由自在的空气里吵吵闹闹\n[02:00.00]你可知道我唯一的想要\n[02:40.00]世界还小 我陪你去到天涯海角\n[03:20.00]在没有烦恼的角落里停止寻找',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(89,'斑马斑马','宋冬野','安和桥北',257,NULL,'[00:00.00]斑马斑马 你不要睡着啦\n[00:40.00]再给我看看你受伤的尾巴\n[01:20.00]我不想去触碰你伤口的疤\n[02:00.00]我只想掀起你的头发\n[02:40.00]斑马斑马 你回到了你的家\n[03:20.00]可我浪费着我寒冷的年华',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(90,'南方姑娘','赵雷','赵小雷',304,NULL,'[00:00.00]北方的村庄 住着一个南方的姑娘\n[00:48.00]她总是喜欢穿着带花的裙子站在路旁\n[01:36.00]她的话不多 但笑起来是那么平静悠扬\n[02:24.00]她柔弱的眼神里装的是什么 是思念的忧伤\n[03:12.00]南方姑娘 你是否习惯北方的秋凉',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(93,'晴天','周杰伦','叶惠美',269,NULL,'[00:00.00]故事的小黄花\n[00:30.00]从出生那年就飘着\n[01:00.00]你的笑容像晴天\n[01:30.00]驱散我所有的阴天\n[02:00.00]想回到从前 重新爱一遍\n[02:30.00]把错过的时间都补全\n[03:00.00]可惜我们再也回不去\n[03:30.00]只能把晴天藏在心里',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(94,'稻香','周杰伦','魔杰座',223,NULL,'[00:00.00]还记得你说家是唯一的城堡\n[00:30.00]随着稻香河流继续奔跑\n[01:00.00]童年的纸飞机飞回手里\n[01:30.00]故乡的月光那样明亮\n[02:00.00]受了伤就回家吧\n[02:30.00]这里永远有你的稻香\n[03:00.00]赤脚在田里追蜻蜓\n[03:30.00]那是回不去的时光',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(95,'青花瓷','周杰伦','我很忙',239,NULL,'[00:00.00]天青色等烟雨\n[00:30.00]而我在等你\n[01:00.00]炊烟袅袅升起隔江千万里\n[01:30.00]青花瓷上画着你的眉宇\n[02:00.00]一转身 一世纪\n[02:30.00]我守着这份温润如玉\n[03:00.00]等烟雨也等一个你\n[03:30.00]把故事写进窑烧的纹理',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(96,'江南','林俊杰','第二天堂',267,NULL,'[00:00.00]风到这里就是粘\n[00:30.00]粘住过客的思念\n[01:00.00]江南的雨打湿了从前\n[01:30.00]你的伞还停在桥边\n[02:00.00]圈圈圆圆圈圈\n[02:30.00]我在水乡把你念\n[03:00.00]愿得一人心 白首不分离\n[03:30.00]可惜我们隔着一整个江南',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(97,'十年','陈奕迅','黑·白·灰',246,NULL,'[00:00.00]十年之前你不认识我\n[00:30.00]我不属于你\n[01:00.00]我们还是一样\n[01:30.00]陪在一个陌生人左右\n[02:00.00]十年之后我们是朋友\n[02:30.00]还可以问候\n[03:00.00]只是那种温柔\n[03:30.00]再也找不到拥抱的理由',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(98,'浮夸','陈奕迅','U87',267,NULL,'[00:00.00]你当我是浮夸吧\n[00:30.00]夸张只因我很怕\n[01:00.00]怕你发现这世界\n[01:30.00]没有你想象的童话\n[02:00.00]我用夸张的表演\n[02:30.00]藏起所有的伤疤\n[03:00.00]若有人能看穿\n[03:30.00]我愿卸下这虚假',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(99,'富士山下','陈奕迅','What\'s Going On...?',285,NULL,'[00:00.00]拦路雨偏似雪花\n[00:26.00]饮泣的你冻吗\n[00:53.00]这风褛我给你磨到有襟花\n[01:20.00]为何你总要带走\n[01:46.00]我留下来的牵挂\n[02:13.00]若这一生只能送你到这里\n[02:40.00]请原谅我没说出的那句话\n[03:06.00]就让富士山的雪\n[03:33.00]替我陪你走过冬夏',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(100,'吻别','张学友','吻别',278,NULL,'[00:00.00]我和你吻别在无人的街\n[00:30.00]让风痴笑我不能拒绝\n[01:00.00]你要我答应你\n[01:30.00]不要难过\n[02:00.00]只是这告别\n[02:30.00]要我如何装作洒脱\n[03:00.00]吻别的那一刻\n[03:30.00]心碎成了雪',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(101,'一千个伤心的理由','张学友','真爱新曲+精选',269,NULL,'[00:00.00]我有一千个伤心的理由\n[00:30.00]却找不到一个留下的借口\n[01:00.00]爱情走到尽头\n[01:30.00]连挽留都显得多余\n[02:00.00]你转身就走\n[02:30.00]留我在原地泪流\n[03:00.00]如果这是结局\n[03:30.00]我认了 也放手',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(102,'泡沫','G.E.M.邓紫棋','Xposed',271,NULL,'[00:00.00]阳光下的泡沫 是彩色的\n[00:30.00]就像被骗的我 是幸福的\n[01:00.00]梦醒了才发现\n[01:30.00]一切不过是虚幻\n[02:00.00]爱情像泡沫 美丽又易碎\n[02:30.00]轻轻一碰 就散成空\n[03:00.00]我也曾真心相信\n[03:30.00]你是我的天长地久',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(103,'光年之外','G.E.M.邓紫棋','光年之外',235,NULL,'[00:00.00]缘分让我们相遇乱世以外\n[00:34.00]命运却要我们危难中相爱\n[01:08.00]也许未来遥远在光年之外\n[01:42.00]我也愿为你 等一个未来\n[02:17.00]宇宙再大 我的眼里只有你\n[02:51.00]就算隔着光年的距离\n[03:25.00]我也要穿越星辰 拥抱你',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(104,'海阔天空','Beyond','乐与怒',326,NULL,'[00:00.00]多少次跌倒又爬起\n[00:30.00]多少次夜里问过自己\n[01:00.00]这条路还要走多远\n[01:30.00]才能看到黎明\n[02:00.00]可我从未想过放弃\n[02:30.00]因为热血还在胸膛里\n[03:00.00]只要还相信天空海阔\n[03:30.00]就没有到不了的远方',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(105,'光辉岁月','Beyond','命运派对',302,NULL,'[00:00.00]钟声响起归家的讯号\n[00:30.00]在他生命里 仿佛带点唏嘘\n[01:00.00]黑色肌肤给他的意义\n[01:30.00]是一生奉献 为理想前行\n[02:00.00]可否不分肤色的界限\n[02:30.00]愿这土地里 不分你我高低\n[03:00.00]缤纷色彩闪出的美丽\n[03:30.00]是因它没有 分开每种色彩',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(106,'素颜','许嵩、何曼婷','寻雾启示',238,NULL,'[00:00.00]如果再看你一眼\n[00:30.00]是否还会有感觉\n[01:00.00]当年素面朝天\n[01:30.00]要多纯洁就有多纯洁\n[02:00.00]不化妆不伪装\n[02:30.00]那时的我们都简单\n[03:00.00]如今你在人海里发光\n[03:30.00]我却还在原地回想',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(107,'南山南','马頔','孤鸟的歌',305,NULL,'[00:00.00]你在南方的艳阳里大雪纷飞\n[00:34.00]我在北方的寒夜里四季如春\n[01:08.00]如果天黑之前来得及\n[01:42.00]我要忘了你的眼睛\n[02:17.00]穷极一生做不完一场梦\n[02:51.00]南山南 北海北\n[03:25.00]愿你我都各自安好',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(108,'小幸运','田馥甄','小幸运',267,NULL,'[00:00.00]原来你是我最想留住的幸运\n[00:34.00]原来我们和爱情曾经靠得那么近\n[01:08.00]那为我对抗世界的决定\n[01:42.00]那陪我淋的雨\n[02:17.00]一幕幕都是你 一尘不染的真心\n[02:51.00]谢谢你出现在我生命里\n[03:25.00]让我学会珍惜',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(109,'倔强','五月天','神的孩子都在跳舞',258,NULL,'[00:00.00]当我和世界不一样\n[00:34.00]那就让我不一样\n[01:08.00]坚持对我来说就是以刚克刚\n[01:42.00]逆风的方向更适合飞翔\n[02:17.00]我不怕千万人阻挡\n[02:51.00]只怕自己投降\n[03:25.00]就这一次 我和我的倔强',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(110,'突然好想你','五月天','后青春期的诗',271,NULL,'[00:00.00]突然好想你 你会在哪里\n[00:40.00]过得快乐或委屈\n[01:20.00]突然好想你 突然锋利的回忆\n[02:00.00]突然模糊的眼睛\n[02:40.00]我们那么甜那么美那么相信\n[03:20.00]如今却各自散落在人海里',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(111,'告白气球','周杰伦','周杰伦的床边故事',255,NULL,'[00:00.00]告白气球 风吹到对街\n[00:30.00]微笑在天上飞\n[01:00.00]你说你有点难追\n[01:30.00]想让我知难而退\n[02:00.00]可我的爱不会后退\n[02:30.00]你在我心里最珍贵\n[03:00.00]用这气球载着真心\n[03:30.00]飞到你的心里面',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(112,'七里香','周杰伦','七里香',299,NULL,'[00:00.00]窗外的麻雀 在电线杆上多嘴\n[00:40.00]你说这一句 很有夏天的感觉\n[01:20.00]手中的铅笔 在纸上来来回回\n[02:00.00]我用几行字 形容你是我的谁\n[02:40.00]秋刀鱼的滋味 猫跟你都想了解\n[03:20.00]初恋的香味就这样被我们寻回',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(113,'不为谁而作的歌','林俊杰','和自己对话',280,NULL,'[00:00.00]我不为谁而作这首歌\n[00:30.00]只想唱给疲惫的你听\n[01:00.00]那些熬过的夜 流过的泪\n[01:30.00]都会变成光\n[02:00.00]梦想或许还很远\n[02:30.00]但请你别放弃\n[03:00.00]因为平凡的人\n[03:30.00]也能创造奇迹',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(114,'她说','林俊杰','她说 概念自选辑',258,NULL,'[00:00.00]她说 不要等她\n[00:30.00]她说 忘了她吧\n[01:00.00]可我却放不下\n[01:30.00]那些说过的话\n[02:00.00]她说要好好生活\n[02:30.00]她说别太想她\n[03:00.00]可想念像野草\n[03:30.00]在心里疯长啊',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(115,'红豆','王菲','唱游',264,NULL,'[00:00.00]还没好好的感受 雪花绽放的气候\n[00:40.00]我们一起颤抖 会更明白什么是温柔\n[01:20.00]还没跟你牵着手 走过荒芜的沙丘\n[02:00.00]可能从此以后 学会珍惜天长和地久\n[02:40.00]相聚离开 都有时候\n[03:20.00]没有什么会永垂不朽',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(116,'容易受伤的女人','王菲','Coming Home',259,NULL,'[00:00.00]我这个容易受伤的女人\n[00:30.00]总是把真心付得太认真\n[01:00.00]明知会疼 还是奋不顾身\n[01:30.00]只为抓住那一点点温存\n[02:00.00]如果爱是一场修行\n[02:30.00]我愿用一生来虔诚\n[03:00.00]可为何真心的人\n[03:30.00]总是最容易受伤的人',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(117,'不将就','李荣浩','有理想',302,NULL,'[00:00.00]我不想将就 一段没有爱的以后\n[00:34.00]宁愿一个人 也不愿再迁就\n[01:08.00]那些敷衍的温柔\n[01:42.00]我不要\n[02:17.00]我要的是真心相守\n[02:51.00]哪怕等得久一点\n[03:25.00]也不愿将就',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(118,'年少有为','李荣浩','年少有为',276,NULL,'[00:00.00]假如我年少有为不自卑\n[00:34.00]懂得什么是珍贵\n[01:08.00]那些美梦 没给你 我一生有愧\n[01:42.00]假如我年少有为 知进退\n[02:17.00]才不会让你替我受罪\n[02:51.00]可是这世上 没有假如\n[03:25.00]只剩下 满身的疲惫',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(124,'晚风告白','陈亦楠','晚风告白',215,NULL,'[00:00.00]晚风替我捎一句话\n[00:30.00]穿过街角送到你窗下\n[01:00.00]路灯把影子拉得那么长\n[01:30.00]像我没说出口的牵挂\n[02:00.00]如果月亮愿意作证\n[02:30.00]就让今晚的星星替我回答\n[03:00.00]我想把余生都交给你啊\n[03:30.00]从这一阵晚风开始吧',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(125,'若月亮没来','于适','若月亮没来',232,NULL,'[00:00.00]若月亮今晚没有来\n[00:30.00]星星会不会替我道晚安\n[01:00.00]我把想念折进云朵里\n[01:30.00]飘到你睡着的窗台\n[02:00.00]别怕黑夜太长太安静\n[02:30.00]我在这里陪你数雨声\n[03:00.00]等到天边泛起鱼肚白\n[03:30.00]你就知道我从没离开',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(126,'小美满','周深','小美满',224,NULL,'[00:00.00]清晨的豆浆冒着热气\n[00:30.00]你的笑比阳光还暖\n[01:00.00]日子平平淡淡地过\n[01:30.00]也有细碎的甜\n[02:00.00]不求惊天动地一场\n[02:30.00]只想牵你的手慢慢走\n[03:00.00]这人间烟火寻常\n[03:30.00]就是我最想要的小美满',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(127,'苹果香','汪苏泷','苹果香',201,NULL,'[00:00.00]那一年苹果正熟透\n[00:30.00]香飘过整个秋天的街口\n[01:00.00]你递来一颗红红的果\n[01:30.00]甜到了我的心口\n[02:00.00]后来我们各自远走\n[02:30.00]只剩这味道还停留\n[03:00.00]每当秋风又吹过枝头\n[03:30.00]我就想起你温柔的问候',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(128,'APT.','Rosé & Bruno Mars','APT.',173,NULL,'[00:00.00]灯光亮起 心跳加速\n[00:30.00]这一刻谁也别想停住\n[01:00.00]音乐轰鸣 灵魂自由\n[01:30.00]跟着节拍 把烦恼放逐\n[02:00.00]夜还很长 梦还滚烫\n[02:30.00]我们跳舞到天亮\n[03:00.00]别再犹豫 别再回头\n[03:30.00]让这夜晚为我们疯狂',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(129,'青花','周传雄','青花',286,NULL,'[00:00.00]素胚勾勒出你的模样\n[00:30.00]一笔一画都藏着时光\n[01:00.00]青色的纹路蔓延成河\n[01:30.00]流过我们走散的巷\n[02:00.00]千年之后仍有人问起\n[02:30.00]那段未讲完的故事\n[03:00.00]我守着这只青花不语\n[03:30.00]因为答案都写在纹里',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(130,'落日与晚风','林忆莲','落日与晚风',248,NULL,'[00:00.00]落日的余晖洒在肩上\n[00:30.00]晚风轻轻吹过耳旁\n[01:00.00]我们并肩走在这路上\n[01:30.00]把白昼走成温柔的光\n[02:00.00]就算明天各奔东西\n[02:30.00]这一刻请别太匆忙\n[03:00.00]让落日和晚风记住\n[03:30.00]我们曾这样年轻过一场',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(131,'向云端','刀郎','山歌寥哉',265,NULL,'[00:00.00]我要向云端飞去\n[00:30.00]把烦恼都留在原地\n[01:00.00]翅膀掠过山川湖海\n[01:30.00]去找回自由的自己\n[02:00.00]别怕高处风太急\n[02:30.00]梦想本就逆风而起\n[03:00.00]只要心中有光不灭\n[03:30.00]再远的天也能抵达',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(132,'罗刹海市','刀郎','山歌寥哉',315,NULL,'[00:00.00]这世间光怪陆离\n[00:30.00]真假难辨像一场戏\n[01:00.00]有人颠倒黑与白\n[01:30.00]把丑的捧成了稀奇\n[02:00.00]我且守住心里那盏灯\n[02:30.00]不被喧嚣蒙住眼睛\n[03:00.00]任他风浪再大再急\n[03:30.00]我自有一片清明',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(133,'一路生花','温奕心','一路生花',228,NULL,'[00:00.00]这一路走来有风雨\n[00:30.00]也有阳光洒满的四季\n[01:00.00]每一步脚印都算数\n[01:30.00]都开成了花\n[02:00.00]谢谢你陪我走到这里\n[02:30.00]未来的路还要一起\n[03:00.00]愿我们一路生花\n[03:30.00]不负这滚烫的年纪',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(134,'我记得','赵雷','署前街少年',294,NULL,'[00:00.00]我记得那年夏天的蝉鸣\n[00:30.00]记得你笑起来的眼睛\n[01:00.00]记得操场边那棵老树\n[01:30.00]记得我们数过的星星\n[02:00.00]后来时光匆匆远行\n[02:30.00]有些话没来得及说明\n[03:00.00]但关于你的每一个细节\n[03:30.00]我都记得那么清',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(135,'我会等','张杰','我会等',236,NULL,'[00:00.00]我会等你到花开\n[00:30.00]也会等到雪落下\n[01:00.00]等到候鸟都飞回来\n[01:30.00]等到白发也长满\n[02:00.00]我不怕时间走得太慢\n[02:30.00]只怕错过你的呼唤\n[03:00.00]这一生我只有一个心愿\n[03:30.00]就是和你 再相见',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(136,'孤勇者','陈奕迅','孤勇者',271,NULL,'[00:00.00]谁说站在光里的才算英雄\n[00:34.00]那些在黑夜里奔跑的人\n[01:08.00]一样值得被歌颂\n[01:42.00]纵使前路没有掌声\n[02:17.00]我也要为自己冲锋\n[02:51.00]跌倒了就再站起来\n[03:25.00]做自己人生的孤勇者',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(137,'笼','林俊杰','笼',243,NULL,'[00:00.00]我被困在一只笼里\n[00:34.00]钥匙却握在自己手里\n[01:08.00]是我把翅膀收得太久\n[01:42.00]忘了还能飞翔\n[02:17.00]直到那天看见天空\n[02:51.00]才明白困住我的从不是牢笼\n[03:25.00]而是那颗不敢挣脱的心',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(138,'心动','王菲','王菲同名专辑',217,NULL,'[00:00.00]第一次见你就心动\n[00:30.00]像风吹过湖面的波光\n[01:00.00]你的名字落在心尖\n[01:30.00]荡起一圈圈的回响\n[02:00.00]不敢太靠近怕惊扰\n[02:30.00]又忍不住频频张望\n[03:00.00]原来爱来的时候\n[03:30.00]连呼吸都会发烫',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(139,'如愿','王菲','如愿',274,NULL,'[00:00.00]愿你所愿的都能成真\n[00:34.00]愿你的路都有人陪\n[01:08.00]愿这盛世如你所愿\n[01:42.00]山河无恙 岁月安宁\n[02:17.00]我把所有的祝福都酿成风\n[02:51.00]吹向你未来的每个清晨\n[03:25.00]愿你此生 万事如愿',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(140,'人世间','雷佳','人世间',288,NULL,'[00:00.00]这人世间 悲欢离合\n[00:30.00]都在烟火里慢慢说\n[01:00.00]有人哭着来有人笑着走\n[01:30.00]都是命运写的歌\n[02:00.00]我们不过是匆匆过客\n[02:30.00]却总想把日子过成诗\n[03:00.00]愿所有平凡的日子\n[03:30.00]都能开出温暖的花',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(141,'无名的人','毛不易','无名的人',256,NULL,'[00:00.00]我是一介无名的人\n[00:30.00]在城市的角落打拼\n[01:00.00]没有耀眼的光环\n[01:30.00]只有不肯低头的倔强\n[02:00.00]也许没人记得我名字\n[02:30.00]但我认真活过每一天\n[03:00.00]无名的人也有梦想\n[03:30.00]也在努力发光',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(142,'送你一朵小红花','赵英俊','送你一朵小红花',240,NULL,'[00:00.00]送你一朵小红花\n[00:30.00]开在昨天新长的枝丫\n[01:00.00]奖励你有勇气走过\n[01:30.00]那些难熬的冬与夏\n[02:00.00]这世界有时很冷\n[02:30.00]但总有人爱你啊\n[03:00.00]送你一朵小红花\n[03:30.00]愿你继续勇敢地开花',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(143,'这世界那么多人','莫文蔚','这世界那么多人',262,NULL,'[00:00.00]这世界有那么多的人\n[00:30.00]偏偏让我遇见了你\n[01:00.00]是命运的安排还是幸运\n[01:30.00]让我不再一个人\n[02:00.00]人海茫茫 我们相认\n[02:30.00]多幸运在这一生\n[03:00.00]往后余生 风雪共度\n[03:30.00]都不再怕孤独',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(144,'笼中鸟','李荣浩','笼中鸟',231,NULL,'[00:00.00]笼中鸟望着窗外天\n[00:30.00]翅膀记得飞翔的甜\n[01:00.00]它唱了一首又一首歌\n[01:30.00]都是对自由的思念\n[02:00.00]我也想有天推开窗\n[02:30.00]让心回到广袤的田野\n[03:00.00]不再做谁的笼中鸟\n[03:30.00]要飞就飞向自己的天',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(145,'大梦归','周深','兰香如故 影视原声带',245,NULL,'[00:00.00]梦里走了千山万水\n[00:30.00]醒来还在原地徘徊\n[01:00.00]那些追逐过的光\n[01:30.00]都化成了记忆的海\n[02:00.00]若人生不过一场大梦\n[02:30.00]愿梦醒时分无憾无悔\n[03:00.00]带着满身的风霜\n[03:30.00]也带着温柔的归来',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(146,'鼓楼','赵雷','无法长大',258,NULL,'[00:00.00]鼓楼的钟声敲过黄昏\n[00:30.00]敲醒了沉睡的古城\n[01:00.00]我坐在城墙下看行人\n[01:30.00]想着关于你的传闻\n[02:00.00]那年的约定还没兑现\n[02:30.00]如今只剩晚风轻吻\n[03:00.00]鼓楼还在 只是岁月\n[03:30.00]带走了我们的青春',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(147,'茶汤','郁可唯','微加幸福',223,NULL,'[00:00.00]一碗茶汤冒着热气\n[00:30.00]暖了掌心也暖了记忆\n[01:00.00]奶奶的故事就着茶香\n[01:30.00]讲了一个世纪\n[02:00.00]如今我独坐在灯下\n[02:30.00]茶汤凉了又续\n[03:00.00]原来思念最浓的时候\n[03:30.00]是想念那一口家的味',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(148,'态度','田栩宁','X',208,NULL,'[00:00.00]我有我的态度\n[00:30.00]不随波逐流不认输\n[01:00.00]就算全世界都不看好\n[01:30.00]我也要走自己的路\n[02:00.00]你笑我太倔强太固执\n[02:30.00]可这就是我的样子\n[03:00.00]用我最真实的活法\n[03:30.00]写下无悔的故事',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(149,'雨终曲','宋雨琦','雨终曲',219,NULL,'[00:00.00]雨下了一整夜\n[00:30.00]终于在天亮前停歇\n[01:00.00]你留下的那把伞\n[01:30.00]还挂在我的屋檐\n[02:00.00]等这场雨真正结束\n[02:30.00]等伤口慢慢结痂\n[03:00.00]我也该学会 一个人\n[03:30.00]走完剩下的季节',0,'2026-11-12 14:07:39','2026-11-19 14:17:51',0),(150,'我记得','房东的猫','New Boy',204,NULL,NULL,0,'2026-11-12 14:07:39','2026-11-12 14:07:39',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'123','$2a$10$8l6XelQnMQTA9imAdbu6vuue4h7kyQNiUWBzx1nS/G/KXTLHqrgTe','十一','🐟','2026-11-05 14:04:12','2026-11-05 14:04:12',0),(4,'111','$2a$10$D9Qx/qGr2u.xYIz5QJ2/COZ8bZJZcoOFGavgQpvAsIQ2BN/2MSs7K','111',NULL,'2026-11-12 14:05:16','2026-11-12 14:05:16',0),(14,'GAY','$2a$10$zZSAnh6u5goZYFCVdh5W.Oiz4I3zhX93QibwFDhRkWZBBEKUeyz.q','GAY',NULL,'2026-11-16 09:49:16','2026-11-16 09:49:16',0),(15,'testuser01','$2a$10$zK1H7QEf9zWMa95w9LxDvO2T5VZPJDBeaK40fGnmeY/Lk.M1/etY.','鲨鱼测试员',NULL,'2026-11-19 14:06:25','2026-11-19 14:06:25',0),(16,'18250458286','$2a$10$7NuzElHUIjBpIpOHRrAkkOwt5ihxzCVop.h6VjoYk73qhSotsqkke','18250458286',NULL,'2026-11-19 14:56:41','2026-11-19 14:56:41',0),(17,'1@qq.com','$2a$10$JTZVabWRFfPEdOL./eu3z.xQuQv4jVgY6i1p4QOJD/1jz280eDuum','1@qq.com',NULL,'2026-11-19 14:56:49','2026-11-19 14:56:49',0),(18,'555','$2a$10$mlLmS61REGtye9/u6jR2GesEPI3R4q.zKfZburi04Xw.OQPBZxngO','555',NULL,'2026-11-19 14:58:28','2026-11-19 14:58:28',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户收藏歌曲表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_favorite`
--

LOCK TABLES `user_favorite` WRITE;
/*!40000 ALTER TABLE `user_favorite` DISABLE KEYS */;
INSERT INTO `user_favorite` VALUES (1,1,1,'2026-11-06 14:32:04',1),(2,1,2,'2026-11-06 14:32:04',1),(3,1,11,'2026-11-12 14:03:39',1),(5,1,3,'2026-11-12 14:04:16',1),(9,4,31,'2026-11-12 14:15:58',0),(10,1,31,'2026-11-12 14:16:07',0),(11,1,104,'2026-11-12 14:16:10',0),(12,1,129,'2026-11-12 14:16:12',1),(13,1,95,'2026-11-12 14:16:24',0),(14,1,93,'2026-11-12 14:16:25',0),(15,1,94,'2026-11-12 14:16:27',0),(16,1,66,'2026-11-16 09:07:23',0),(17,14,124,'2026-11-16 09:49:27',0),(18,4,64,'2026-11-19 14:55:47',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户关注关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_follow`
--

LOCK TABLES `user_follow` WRITE;
/*!40000 ALTER TABLE `user_follow` DISABLE KEYS */;
INSERT INTO `user_follow` VALUES (7,1,4,'2026-11-12 15:01:48',0),(8,4,1,'2026-11-16 08:59:50',0),(9,4,14,'2026-11-19 14:56:27',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户动态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_moment`
--

LOCK TABLES `user_moment` WRITE;
/*!40000 ALTER TABLE `user_moment` DISABLE KEYS */;
INSERT INTO `user_moment` VALUES (1,1,'favorite','收藏了歌曲「潮汐信号」',1,NULL,'2026-11-06 14:32:04',0),(2,1,'favorite','收藏了歌曲「凌晨三点的灯塔」',2,NULL,'2026-11-06 14:32:04',0),(8,1,'listen','正在听「深海回响」',11,NULL,'2026-11-12 14:03:30',0),(9,1,'favorite','收藏了歌曲「深海回响」',11,NULL,'2026-11-12 14:03:39',0),(10,1,'listen','正在听「逆流而上」',3,NULL,'2026-11-12 14:04:06',0),(11,1,'favorite','收藏了歌曲「逆流而上」',3,NULL,'2026-11-12 14:04:16',0),(13,1,'listen','正在听「落日与晚风」',130,NULL,'2026-11-12 14:12:58',0),(14,4,'listen','正在听「起风了」',31,NULL,'2026-11-12 14:15:57',0),(15,4,'favorite','收藏了歌曲「起风了」',31,NULL,'2026-11-12 14:15:58',0),(16,1,'favorite','收藏了歌曲「起风了」',31,NULL,'2026-11-12 14:16:07',0),(17,1,'favorite','收藏了歌曲「海阔天空」',104,NULL,'2026-11-12 14:16:10',0),(18,1,'favorite','收藏了歌曲「青花」',129,NULL,'2026-11-12 14:16:12',0),(19,1,'favorite','收藏了歌曲「青花瓷」',95,NULL,'2026-11-12 14:16:24',0),(20,1,'favorite','收藏了歌曲「晴天」',93,NULL,'2026-11-12 14:16:25',0),(21,1,'favorite','收藏了歌曲「稻香」',94,NULL,'2026-11-12 14:16:27',0),(22,4,'listen','正在听「我会等」',135,NULL,'2026-11-12 14:20:17',0),(23,4,'listen','正在听「孤勇者」',136,NULL,'2026-11-12 14:24:14',0),(29,4,'listen','正在听「笼」',137,NULL,'2026-11-12 14:28:46',0),(33,1,'listen','正在听「晴天」',93,NULL,'2026-11-12 14:37:38',0),(34,1,'listen','正在听「稻香」',94,NULL,'2026-11-12 14:42:08',0),(35,1,'listen','正在听「青花瓷」',95,NULL,'2026-11-12 14:45:52',0),(36,1,'listen','正在听「江南」',96,NULL,'2026-11-12 14:49:52',0),(37,1,'listen','正在听「演员」',64,NULL,'2026-11-12 14:54:20',0),(38,1,'listen','正在听「十年」',97,NULL,'2026-11-12 14:58:42',0),(39,1,'follow','关注了 111',NULL,NULL,'2026-11-12 15:01:48',0),(40,4,'listen','正在听「演员」',64,NULL,'2026-11-16 08:59:21',0),(41,4,'listen','正在听「小美满」',126,NULL,'2026-11-16 08:59:30',0),(42,4,'listen','正在听「我不难过」',63,NULL,'2026-11-16 08:59:36',0),(43,4,'follow','关注了 十一',NULL,NULL,'2026-11-16 08:59:50',0),(44,1,'listen','正在听「吻别」',100,NULL,'2026-11-16 09:03:03',0),(45,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:03:17',0),(46,1,'favorite','收藏了歌曲「天龙八部之宿敌」',66,NULL,'2026-11-16 09:07:23',0),(47,1,'listen','正在听「一千个伤心的理由」',101,NULL,'2026-11-16 09:07:42',0),(48,1,'listen','正在听「季候风」',67,NULL,'2026-11-16 09:07:42',0),(49,1,'listen','正在听「泡沫」',102,NULL,'2026-11-16 09:12:12',0),(50,1,'listen','正在听「雨爱」',68,NULL,'2026-11-16 09:12:19',0),(51,1,'listen','正在听「情歌」',69,NULL,'2026-11-16 09:16:40',0),(52,1,'listen','正在听「光年之外」',103,NULL,'2026-11-16 09:16:44',0),(53,4,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:20:38',0),(54,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:20:44',0),(55,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:24:01',0),(56,1,'listen','正在听「季候风」',67,NULL,'2026-11-16 09:25:09',0),(57,1,'listen','正在听「」',100005,NULL,'2026-11-16 09:28:26',0),(58,1,'listen','正在听「雨爱」',68,NULL,'2026-11-16 09:29:45',0),(59,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:29:46',0),(60,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:29:46',0),(61,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:29:48',0),(62,1,'listen','正在听「天龙八部之宿敌」',66,NULL,'2026-11-16 09:29:48',0),(63,1,'listen','正在听「情歌」',69,NULL,'2026-11-16 09:34:05',0),(64,1,'listen','正在听「雨爱」',68,NULL,'2026-11-16 09:34:12',0),(65,1,'listen','正在听「幻听」',70,NULL,'2026-11-16 09:38:25',0),(66,1,'listen','正在听「季候风」',67,NULL,'2026-11-16 09:38:32',0),(67,1,'listen','正在听「Always Online」',71,NULL,'2026-11-16 09:42:58',0),(68,1,'listen','正在听「光年之外」',103,NULL,'2026-11-16 09:43:08',0),(69,1,'listen','正在听「开始懂了」',72,NULL,'2026-11-16 09:46:44',0),(70,1,'listen','正在听「情歌」',69,NULL,'2026-11-16 09:47:03',0),(71,14,'listen','正在听「晚风告白」',124,NULL,'2026-11-16 09:49:24',0),(72,14,'favorite','收藏了歌曲「晚风告白」',124,NULL,'2026-11-16 09:49:27',0),(73,1,'listen','正在听「海阔天空」',104,NULL,'2026-11-19 14:11:20',0),(74,1,'listen','正在听「海阔天空」',104,NULL,'2026-11-19 14:11:20',0),(75,1,'listen','正在听「不为谁而作的歌」',113,NULL,'2026-11-19 14:15:01',0),(76,1,'listen','正在听「晴天」',93,NULL,'2026-11-19 14:18:05',0),(77,1,'listen','正在听「青花瓷」',95,NULL,'2026-11-19 14:21:44',0),(78,1,'listen','正在听「江南」',96,NULL,'2026-11-19 14:25:45',0),(79,1,'listen','正在听「演员」',64,NULL,'2026-11-19 14:30:13',0),(80,1,'listen','正在听「十年」',97,NULL,'2026-11-19 14:34:35',0),(81,1,'listen','正在听「浮夸」',98,NULL,'2026-11-19 14:38:42',0),(82,1,'listen','正在听「富士山下」',99,NULL,'2026-11-19 14:43:10',0),(83,1,'listen','正在听「吻别」',100,NULL,'2026-11-19 14:47:56',0),(84,1,'listen','正在听「一千个伤心的理由」',101,NULL,'2026-11-19 14:52:35',0),(85,4,'listen','正在听「演员」',64,NULL,'2026-11-19 14:55:42',0),(86,4,'favorite','收藏了歌曲「演员」',64,NULL,'2026-11-19 14:55:47',0),(87,4,'follow','关注了 GAY',NULL,NULL,'2026-11-19 14:56:27',0),(88,16,'listen','正在听「稻香」',94,NULL,'2026-11-19 14:56:51',0),(89,1,'listen','正在听「泡沫」',102,NULL,'2026-11-19 14:57:06',0),(90,18,'listen','正在听「泡沫」',102,NULL,'2026-11-19 14:58:39',0),(91,18,'listen','正在听「体面」',82,NULL,'2026-11-19 14:58:53',0),(92,18,'listen','正在听「体面」',82,NULL,'2026-11-19 14:58:53',0),(93,16,'listen','正在听「晚风告白」',124,NULL,'2026-11-19 15:00:00',0),(94,4,'listen','正在听「十年」',97,NULL,'2026-11-19 15:00:03',0),(95,1,'listen','正在听「光年之外」',103,NULL,'2026-11-19 15:01:38',0),(96,18,'listen','正在听「往后余生」',45,NULL,'2026-11-19 15:03:20',0),(97,16,'listen','正在听「若月亮没来」',125,NULL,'2026-11-19 15:03:36',0),(98,4,'listen','正在听「浮夸」',98,NULL,'2026-11-19 15:04:09',0),(99,1,'listen','正在听「海阔天空」',104,NULL,'2026-11-19 15:05:34',0),(100,16,'listen','正在听「小美满」',126,NULL,'2026-11-19 15:07:29',0);
/*!40000 ALTER TABLE `user_moment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_moment_like`
--

DROP TABLE IF EXISTS `user_moment_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_moment_like` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `moment_id` bigint NOT NULL COMMENT '动态 id',
  `user_id` bigint NOT NULL COMMENT '点赞用户 id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '点赞时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_moment_user` (`moment_id`,`user_id`) USING BTREE,
  KEY `idx_user` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='动态点赞表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_moment_like`
--

LOCK TABLES `user_moment_like` WRITE;
/*!40000 ALTER TABLE `user_moment_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_moment_like` ENABLE KEYS */;
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
-- Table structure for table `user_playlist_song`
--

DROP TABLE IF EXISTS `user_playlist_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_playlist_song` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `playlist_id` bigint NOT NULL COMMENT '歌单 id',
  `song_id` bigint NOT NULL COMMENT '歌曲 id',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '歌曲在歌单中的排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_pl_song` (`playlist_id`,`song_id`) USING BTREE,
  KEY `idx_song` (`song_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='个人歌单歌曲关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_playlist_song`
--

LOCK TABLES `user_playlist_song` WRITE;
/*!40000 ALTER TABLE `user_playlist_song` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_playlist_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'shark_music'
--

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

-- Dump completed on 2026-11-27 13:52:43
