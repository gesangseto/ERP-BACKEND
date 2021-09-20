-- MariaDB dump 10.18  Distrib 10.4.17-MariaDB, for osx10.10 (x86_64)
--
-- Host: 151.106.112.32    Database: serialization
-- ------------------------------------------------------
-- Server version	5.7.32-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_config` (
  `config_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `config_app_name` varchar(30) DEFAULT '',
  `config_serial_length` int(2) DEFAULT NULL,
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'SERIALIZATION',8);
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu_child`
--

DROP TABLE IF EXISTS `sys_menu_child`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_menu_child` (
  `menu_child_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `menu_parent_id` int(11) unsigned NOT NULL,
  `menu_child_name` varchar(50) NOT NULL DEFAULT '',
  `menu_child_url` varchar(50) NOT NULL DEFAULT '',
  `menu_child_icon` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  PRIMARY KEY (`menu_child_id`),
  UNIQUE KEY `menu_child_url` (`menu_child_url`),
  KEY `menu_parent_id` (`menu_parent_id`),
  CONSTRAINT `sys_menu_child_ibfk_1` FOREIGN KEY (`menu_parent_id`) REFERENCES `sys_menu_parent` (`menu_parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu_child`
--

LOCK TABLES `sys_menu_child` WRITE;
/*!40000 ALTER TABLE `sys_menu_child` DISABLE KEYS */;
INSERT INTO `sys_menu_child` VALUES (1,1,'User','/user',NULL,NULL,'2021-07-06 12:26:50',NULL,1),(2,1,'Role','/Role',NULL,NULL,'2021-07-06 12:26:52',NULL,1),(3,2,'Rack','/rack',NULL,NULL,'2021-07-06 12:26:53',NULL,1);
/*!40000 ALTER TABLE `sys_menu_child` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu_parent`
--

DROP TABLE IF EXISTS `sys_menu_parent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_menu_parent` (
  `menu_parent_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `menu_parent_name` varchar(50) NOT NULL DEFAULT '',
  `menu_parent_url` varchar(50) NOT NULL DEFAULT '',
  `menu_parent_icon` varchar(50) DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  PRIMARY KEY (`menu_parent_id`),
  UNIQUE KEY `menu_parent_url` (`menu_parent_url`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu_parent`
--

LOCK TABLES `sys_menu_parent` WRITE;
/*!40000 ALTER TABLE `sys_menu_parent` DISABLE KEYS */;
INSERT INTO `sys_menu_parent` VALUES (1,'Administrator','/administrator','',NULL,'2021-07-06 12:26:45',NULL,1),(2,'Gudang','/gd','',NULL,'2021-07-06 12:26:47',NULL,1);
/*!40000 ALTER TABLE `sys_menu_parent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_section`
--

DROP TABLE IF EXISTS `sys_role_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_role_section` (
  `menu_role_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `menu_child_id` int(11) unsigned NOT NULL,
  `section_id` int(11) unsigned NOT NULL,
  `flag_read` int(1) DEFAULT NULL,
  `flag_create` int(1) DEFAULT NULL,
  `flag_update` int(1) DEFAULT NULL,
  `flag_delete` int(1) DEFAULT NULL,
  `flag_print` int(1) DEFAULT NULL,
  `flag_download` int(1) DEFAULT NULL,
  `menu_role_type` int(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `status` int(1) DEFAULT '0',
  PRIMARY KEY (`menu_role_id`),
  UNIQUE KEY `menu_child_id` (`menu_child_id`,`section_id`),
  KEY `section_id` (`section_id`),
  CONSTRAINT `sys_role_section_ibfk_1` FOREIGN KEY (`menu_child_id`) REFERENCES `sys_menu_child` (`menu_child_id`),
  CONSTRAINT `sys_role_section_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `user_section` (`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_section`
--

LOCK TABLES `sys_role_section` WRITE;
/*!40000 ALTER TABLE `sys_role_section` DISABLE KEYS */;
INSERT INTO `sys_role_section` VALUES (1,1,1,1,1,1,1,1,1,1,NULL,'2021-07-06 12:26:31',1),(2,2,1,1,1,1,1,1,1,1,NULL,'2021-07-06 12:26:33',1);
/*!40000 ALTER TABLE `sys_role_section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_status_information`
--

DROP TABLE IF EXISTS `sys_status_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_status_information` (
  `status_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `status` int(2) NOT NULL,
  `status_description` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_status_information`
--

LOCK TABLES `sys_status_information` WRITE;
/*!40000 ALTER TABLE `sys_status_information` DISABLE KEYS */;
INSERT INTO `sys_status_information` VALUES (1,0,'DRAFT'),(2,1,'ACTIVE'),(3,-1,'INACTIVE'),(4,-9,'REJECT'),(5,9,'APPROVE');
/*!40000 ALTER TABLE `sys_status_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) DEFAULT NULL,
  `user_email` varchar(20) NOT NULL DEFAULT '',
  `user_password` varchar(20) NOT NULL DEFAULT '',
  `section_id` int(11) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_email` (`user_email`),
  KEY `section_id` (`section_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `user_section` (`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (2,'gesang','gesangseto@gmail.com','p@ssw0rd',1,NULL,'2021-07-06 12:25:43',NULL,1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_department`
--

DROP TABLE IF EXISTS `user_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_department` (
  `department_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `department_name` varchar(50) DEFAULT NULL,
  `department_code` varchar(20) NOT NULL DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_code` (`department_code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_department`
--

LOCK TABLES `user_department` WRITE;
/*!40000 ALTER TABLE `user_department` DISABLE KEYS */;
INSERT INTO `user_department` VALUES (1,'Information Technology','IT',NULL,'2021-07-06 12:25:47',NULL,1);
/*!40000 ALTER TABLE `user_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_section`
--

DROP TABLE IF EXISTS `user_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_section` (
  `section_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `department_id` int(11) unsigned NOT NULL,
  `section_name` varchar(50) DEFAULT NULL,
  `section_code` varchar(20) NOT NULL DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  PRIMARY KEY (`section_id`),
  UNIQUE KEY `section_code` (`section_code`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `user_section_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `user_department` (`department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_section`
--

LOCK TABLES `user_section` WRITE;
/*!40000 ALTER TABLE `user_section` DISABLE KEYS */;
INSERT INTO `user_section` VALUES (1,1,'Development','DEV',NULL,'2021-07-06 12:25:52',NULL,1),(4,1,'Testing','TEST',NULL,'2021-07-06 12:26:02',NULL,1);
/*!40000 ALTER TABLE `user_section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'serialization'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-09-17 20:22:14
