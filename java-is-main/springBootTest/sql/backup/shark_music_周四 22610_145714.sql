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
  `title` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '作品标题',
  `author` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主播/作者',
  `intro` varchar(128) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '一句话介绍',
  `tab` varchar(16) COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类：热门/小说/儿童/相声/情感',
  `icon` varchar(16) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面图标(emoji)',
  `tone` varchar(16) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'p1' COMMENT '封面渐变配色编号 p1~p8',
  `listens` bigint NOT NULL DEFAULT '0' COMMENT '收听量',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '展示顺序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='听书精选';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audiobook`
--

LOCK TABLES `audiobook` WRITE;
/*!40000 ALTER TABLE `audiobook` DISABLE KEYS */;
INSERT INTO `audiobook` VALUES (1,'深海博物馆奇谈','主播·阿鲸','每晚一件海底展品背后的奇闻','热门','🌊','p3',8600000,1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(2,'睡前三分半','主播·糖糖','今天也辛苦了，听我讲个故事','热门','🌙','p1',12000000,2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(3,'午夜怪谈收容所','主播·夜巡','胆小勿入的都市传说合集','热门','🕯️','p7',7200000,3,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(4,'孤岛灯塔看守日志','老船长','守灯人二十年的风浪手记','热门','🗺️','p4',5300000,4,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(5,'蓝鲸座城市悬案','无名侦探社','水下都市的三桩离奇密室','小说','🔍','p2',3900000,1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(6,'荒野生存十二夜','铁与木','不带一根火柴的野外实录','小说','🏕️','p6',1800000,2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(7,'深海来信','慢速铁轨','沉船邮袋里打捞出的旧信件','小说','📜','p8',2400000,3,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(8,'小鲨鱼成长记','珊瑚姐姐','适合 3-8 岁的海洋睡前故事','儿童','🦈','p6',6700000,1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(9,'咕噜咕噜海底幼儿园','泡泡老师','和小鱼们一起学礼貌好习惯','儿童','🫧','p8',2100000,2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(10,'码头相声大会','铁嘴老周','抖包袱不断更新的直播剪辑','相声','🎙️','p5',4400000,1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(11,'茶馆夜话·单口集','醒木先生','一块醒木，半城旧事','相声','🍵','p7',1900000,2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(12,'晚风情感电台','主播·岛屿她','深夜来电：把心事说给海风听','情感','💌','p4',9800000,1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(13,'写给灯塔的一百封信','主播·暖洋','一百个听众投稿的真实故事','情感','✉️','p3',2600000,2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(14,'漂流瓶树洞','主播·拾贝','捡到的每一个瓶子都有一段心事','情感','🍀','p5',1500000,3,'2026-10-22 14:49:31','2026-10-22 14:49:31',0);
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
  `name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '频道名称',
  `icon` varchar(16) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '频道图标(emoji)',
  `tone` varchar(16) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'p1' COMMENT '图标底色渐变编号 p1~p8',
  `listeners` bigint NOT NULL DEFAULT '0' COMMENT '当前在听人数',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '展示顺序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='热门频道';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel`
--

LOCK TABLES `channel` WRITE;
/*!40000 ALTER TABLE `channel` DISABLE KEYS */;
INSERT INTO `channel` VALUES (1,'早安海底电台','☀️','p3',860000,1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(2,'深夜故事馆','🌙','p1',620000,2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(3,'白噪音专注舱','🎧','p8',1200000,3,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(4,'民谣小馆','🪕','p7',450000,4,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(5,'古典音乐沙龙','🎻','p5',380000,5,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(6,'影视原声站','🎬','p2',540000,6,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(7,'国风雅集','🏮','p4',720000,7,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(8,'儿童故事堡','🏰','p6',290000,8,'2026-10-22 14:49:31','2026-10-22 14:49:31',0);
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
  `name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '榜单名称',
  `tone` varchar(16) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'blue' COMMENT '榜单头配色：orange/blue/purple/teal',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '展示顺序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='热门榜单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart`
--

LOCK TABLES `chart` WRITE;
/*!40000 ALTER TABLE `chart` DISABLE KEYS */;
INSERT INTO `chart` VALUES (1,'飙升榜','orange',1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(2,'新歌榜','teal',2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(3,'TOP500','blue',3,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(4,'原创榜','purple',4,'2026-10-22 14:49:31','2026-10-22 14:49:31',0);
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
  `title` varchar(128) COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌曲名',
  `artist` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌手/乐队',
  `trend` varchar(8) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'flat' COMMENT '趋势：up升 down降 flat持平 new新进',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_chart_rank` (`chart_id`,`rank_no`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='榜单歌曲';
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
-- Table structure for table `playlist`
--

DROP TABLE IF EXISTS `playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌单标题',
  `subtitle` varchar(128) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '副标题/一句话介绍',
  `tag` varchar(24) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分类标签',
  `icon` varchar(16) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面装饰图标(emoji)',
  `tone` varchar(16) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'p1' COMMENT '封面渐变配色编号 p1~p8',
  `plays` bigint NOT NULL DEFAULT '0' COMMENT '播放量',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '展示顺序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='精选歌单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist`
--

LOCK TABLES `playlist` WRITE;
/*!40000 ALTER TABLE `playlist` DISABLE KEYS */;
INSERT INTO `playlist` VALUES (1,'深海午夜电台','深夜循环的 60 首氛围感神游曲','睡前','🎧','p1',32860000,1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(2,'冲浪摇滚现场','把音量拧到最大，跟着浪尖起跳','摇滚','🎸','p2',9720000,2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(3,'自习室白噪音','高效专注 · 图书馆盖章款 BGM','专注','🎹','p3',187300000,3,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(4,'华语新声捞星','每周五更新，捞一捞刚冒头的好声音','华语','🎤','p4',45210000,4,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(5,'落日爵士酒馆','微醺时刻的萨克斯与旧钢琴','爵士','🎷','p5',6310000,5,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(6,'健身暴汗燃料','180BPM 起步，多巴胺拉满','运动','🥁','p6',21090000,6,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(7,'民谣与远方','木吉他、旧火车和慢慢的生活','民谣','🎻','p7',15840000,7,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(8,'海底两万里','电子合成器潜入深蓝的听觉旅行','电子','📻','p8',8470000,8,'2026-10-22 14:49:31','2026-10-22 14:49:31',0);
/*!40000 ALTER TABLE `playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `singer`
--

DROP TABLE IF EXISTS `singer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `singer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌手/乐队名',
  `tab` varchar(8) COLLATE utf8mb4_general_ci NOT NULL COMMENT '地区分类：华语/欧美/日韩',
  `fans` bigint NOT NULL DEFAULT '0' COMMENT '粉丝数',
  `tone` varchar(16) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'p1' COMMENT '头像渐变配色编号 p1~p8',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '展示顺序(小在前)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='热门歌手';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `singer`
--

LOCK TABLES `singer` WRITE;
/*!40000 ALTER TABLE `singer` DISABLE KEYS */;
INSERT INTO `singer` VALUES (1,'鲸落Koi','华语',9800000,'p1',1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(2,'岛屿她','华语',7600000,'p4',2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(3,'蓝鲸乐队','华语',5400000,'p2',3,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(4,'海盐汽水','华语',4200000,'p3',4,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(5,'午夜DJ鲨','华语',3100000,'p7',5,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(6,'星野次郎','日韩',3500000,'p8',1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(7,'波浪少女组','日韩',2200000,'p6',2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(8,'Luna Tide','欧美',2800000,'p5',1,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(9,'Ocean Kids','欧美',1900000,'p3',2,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(10,'Vinyl Brothers','欧美',1300000,'p2',3,'2026-10-22 14:49:31','2026-10-22 14:49:31',0);
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
  `title` varchar(128) COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌曲名',
  `artist` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌手/乐队',
  `album` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属专辑',
  `duration` int NOT NULL DEFAULT '0' COMMENT '时长（秒）',
  `plays` bigint NOT NULL DEFAULT '0' COMMENT '播放量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_title_artist` (`title`,`artist`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='曲库歌曲';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,'潮汐信号','蓝鲸乐队','深海电台',222,982000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(2,'凌晨三点的灯塔','岛屿她','夜航船',255,745000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(3,'逆流而上','风暴少年','冲浪手册',185,512000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(4,'环礁日落','Coral·珊瑚','环礁日志',238,388000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(5,'咸鱼翻身进行曲','打工人合唱团','格子间战歌',178,1250000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(6,'夏天的最后一天','南屿风','夏末备忘录',272,654000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(7,'北极星快车','星野次郎','夜行列车',227,421000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(8,'薄荷味晚风','薄雾人声','雾中风景',243,366000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(9,'无人区漫游指南','荒原旅人','公路片原声',312,233000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(10,'发光的碎片','萤火虫计划','夏夜观测',206,305000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(11,'深海回响','鲸落Koi','深海回响',284,9870000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(12,'把海风装进口袋','海盐汽水','盐汽水',213,1520000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(13,'灯塔与船','老船长','水手歌谣',249,876000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(14,'月光泳者','夜巡乐队','夜巡',231,402000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(15,'泡沫巡逻艇','泡泡糖少女','泡泡糖星球',167,289000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(16,'齿轮与向日葵','独立计划','车间抒情诗',258,512000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(17,'修船厂情歌','铁与木','铁与木',281,358000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(18,'候鸟备忘录','迁徙图书馆','飞行日志',219,275000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(19,'蒸汽波渔港','VR镇渔民','电子渔港',194,447000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(20,'后巷口琴师','口琴老周','旧城十二巷',303,198000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(21,'深海午夜电台','午夜DJ鲨','凌晨零点',296,620000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(22,'环岛慢车','慢速铁轨','慢速铁轨',202,234000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(23,'冲浪第一课','风暴少年','冲浪手册',180,189000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(24,'鲨鱼晚安曲','岛屿她','夜航船',228,933000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(25,'盐雾吉他','铁与木','铁与木',252,176000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(26,'城市潜水员','夜巡乐队','夜巡',235,268000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(27,'珊瑚色的梦','Coral·珊瑚','环礁日志',268,315000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(28,'平流层放风筝','星野次郎','夜行列车',216,154000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(29,'自习室摇椅','打工人合唱团','格子间战歌',171,426000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0),(30,'蓝色隧道','鲸落Koi','深海回响',321,702000,'2026-10-22 14:49:31','2026-10-22 14:49:31',0);
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
  `account` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '账户（手机号/邮箱/用户名）',
  `password` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码（BCrypt 哈希密文）',
  `nickname` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '昵称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删 1-已删',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
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

-- Dump completed on 2026-10-22 14:57:14
