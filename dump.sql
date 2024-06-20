CREATE DATABASE  IF NOT EXISTS `course_chat` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `course_chat`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: course_chat
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `afkusers`
--

DROP TABLE IF EXISTS `afkusers`;
/*!50001 DROP VIEW IF EXISTS `afkusers`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `afkusers` AS SELECT 
 1 AS `id`,
 1 AS `username`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `password_hash`,
 1 AS `date_joined`,
 1 AS `date_password_changed`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `attachments`
--

DROP TABLE IF EXISTS `attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attachments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `media` bigint NOT NULL,
  `from_user` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_attachments_media_id_media` (`media`),
  KEY `fk_attachments_users_id_from_user` (`from_user`),
  CONSTRAINT `fk_attachments_media_id_media` FOREIGN KEY (`media`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_attachments_users_id_from_user` FOREIGN KEY (`from_user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attachments`
--

LOCK TABLES `attachments` WRITE;
/*!40000 ALTER TABLE `attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chats`
--

DROP TABLE IF EXISTS `chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chats` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `date_created` datetime NOT NULL,
  `avatar` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_chats_media_id_avatar` (`avatar`),
  CONSTRAINT `fk_chats_media_id_avatar` FOREIGN KEY (`avatar`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats`
--

LOCK TABLES `chats` WRITE;
/*!40000 ALTER TABLE `chats` DISABLE KEYS */;
/*!40000 ALTER TABLE `chats` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `chats_creation_timestamp` BEFORE INSERT ON `chats` FOR EACH ROW SET NEW.`date_created` = NOW() */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `chats_users`
--

DROP TABLE IF EXISTS `chats_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chats_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` bigint DEFAULT NULL,
  `chat` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_chats_users_users_user_id` (`user`),
  KEY `fk_chats_users_chats_chat_id` (`chat`),
  CONSTRAINT `fk_chats_users_chats_chat_id` FOREIGN KEY (`chat`) REFERENCES `chats` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_chats_users_users_user_id` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats_users`
--

LOCK TABLES `chats_users` WRITE;
/*!40000 ALTER TABLE `chats_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `chats_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `media_url` text NOT NULL,
  `type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `from_user` bigint DEFAULT NULL,
  `chat` bigint NOT NULL,
  `message` varchar(256) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_messages_users_id_from_user` (`from_user`),
  KEY `fk_messages_chats_id_chat` (`chat`),
  CONSTRAINT `fk_messages_chats_id_chat` FOREIGN KEY (`chat`) REFERENCES `chats` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_messages_users_id_from_user` FOREIGN KEY (`from_user`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `messages_creation_timestamp` BEFORE INSERT ON `messages` FOR EACH ROW SET NEW.`date_created` = NOW() */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `messages_attachments`
--

DROP TABLE IF EXISTS `messages_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages_attachments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `attachment` bigint DEFAULT NULL,
  `message` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_messages_attachments_attachments_attachment_id` (`attachment`),
  KEY `fk_messages_attachments_messages_message_id` (`message`),
  CONSTRAINT `fk_messages_attachments_attachments_attachment_id` FOREIGN KEY (`attachment`) REFERENCES `attachments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_messages_attachments_messages_message_id` FOREIGN KEY (`message`) REFERENCES `messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages_attachments`
--

LOCK TABLES `messages_attachments` WRITE;
/*!40000 ALTER TABLE `messages_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `password_hash` varchar(256) NOT NULL,
  `date_joined` datetime NOT NULL,
  `date_password_changed` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `users_registration_timestamp` BEFORE INSERT ON `users` FOR EACH ROW SET
	NEW.`date_joined` = NOW(), 
    NEW.`date_password_changed` = NOW() */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users_photos`
--

DROP TABLE IF EXISTS `users_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_photos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `media` bigint NOT NULL,
  `user` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_users_photos_media_id_media` (`media`),
  KEY `fk_users_photos_users_id_user` (`user`),
  CONSTRAINT `fk_users_photos_media_id_media` FOREIGN KEY (`media`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_users_photos_users_id_user` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_photos`
--

LOCK TABLES `users_photos` WRITE;
/*!40000 ALTER TABLE `users_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'course_chat'
--

--
-- Dumping routines for database 'course_chat'
--
/*!50003 DROP FUNCTION IF EXISTS `getChatMessagesCount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getChatMessagesCount`(chatId INT) RETURNS int
    READS SQL DATA
BEGIN
    RETURN (
        SELECT COUNT(*) FROM `messages`
        WHERE `messages`.`chat` = chatId
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteMessage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteMessage`(
  IN chatId BIGINT,
  IN messageId BIGINT,
  IN fromUserId BIGINT
)
BEGIN
    -- Объявление переменных
	DECLARE chatExists BOOL;
    DECLARE userInChat BOOL;
    DECLARE userExists BOOL;
    DECLARE messageExists BOOL;
    
    -- Проверка пользователя на существование в БД
    SELECT COUNT(`users`.`id`) > 0 INTO userExists
    FROM users WHERE id = fromUserId;
    
    -- Проверка чата на существование в БД
    SELECT COUNT(`chats`.`id`) > 0 INTO chatExists
    FROM chats WHERE id = chatIdTo;
    
    -- Проверка пользователя на наличие в участниках чата
    SELECT COUNT(`users`.`id`) > 0 INTO userInChat
    FROM `users`
    JOIN `chat_users` ON `user`.`id` = `chat_users`.`id`
    WHERE (
		`chat_users`.`chat` = chatIdTo 
        AND 
        `chat_users`.`user` = fromUserId
	);
    
    -- Проверка на наличие сообщения от указанного пользователя
    SELECT COUNT(`messages`.`id`) > 0 INTO messageExists
    FROM `messages`
    WHERE `from_user` = fromUserId AND `id` = messageId;
    
    -- Начало транзакции
    START TRANSACTION;
    
    -- Условие на существование пользователя
    -- Если пользователь не существует - отображает исключение
    IF NOT userExists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: пользователь не найден!';
        ROLLBACK;
	END IF;
    
    -- Условие на существование чата
    -- Если чат не существует - отображает исключение
    IF NOT chatExists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: данный чат не существует!';
        ROLLBACK;
    END IF;
    
    -- Условие на проверку пользователя в участниках чата
    -- Если пользователь не является участником чата - отображает исключение
    IF NOT userInChat THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: пользователь не находится в данном чате!';
        ROLLBACK;
	END IF;
    
    -- Условие на существование сообщение от указанного пользователя
    -- Если сообщение не существует - отображает исключение.
    IF NOT messageExists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: сообщение от данного отправителя не найдено!';
        ROLLBACK;
    END IF;
    
    -- Удаление сообщения по ID
	DELETE FROM messages WHERE id = messageId;

	COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sendMessage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sendMessage`(
  IN fromUserId BIGINT,
  IN chatIdTo BIGINT,
  IN message VARCHAR(255),
  OUT messageId BIGINT
)
BEGIN
    -- Объявление переменных
	DECLARE chatExists BOOL;
    DECLARE userInChat BOOL;
    DECLARE userExists BOOL;
    
	-- Проверка пользователя на существование в БД
    SELECT COUNT(`users`.`id`) > 0 INTO userExists
    FROM users WHERE id = fromUserId;
    
	-- Проверка чата на существование в БД
    SELECT COUNT(`chats`.`id`) > 0 INTO chatExists
    FROM chats WHERE id = chatIdTo;
    
	-- Проверка пользователя на наличие в участниках чата
    SELECT COUNT(`users`.`id`) > 0 INTO userInChat
    FROM `users`
    JOIN `chat_users` ON `user`.`id` = `chat_users`.`id`
    WHERE (
		`chat_users`.`chat` = chatIdTo 
        AND 
        `chat_users`.`user` = fromUserId
	);
    
    -- Начало транзакции
    START TRANSACTION;
    
	-- Условие на существование пользователя
    -- Если пользователь не существует - отображает исключение
    IF NOT userExists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: пользователь не найден!';
        ROLLBACK;
	END IF;
    
	-- Условие на существование чата
    -- Если чат не существует - отображает исключение
    IF NOT chatExists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: данный чат не существует!';
        ROLLBACK;
    END IF;
    
	-- Условие на проверку пользователя в участниках чата
    -- Если пользователь не является участником чата - отображает исключение
    IF NOT userInChat THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: пользователь не находится в данном чате!';
        ROLLBACK;
	END IF;
    
	-- Добавление данных в такблицу сообщений
    INSERT INTO messages (
		from_user,
        chat,
        message
    ) VALUES (
		fromUserId,
        chatIdTo,
        message
    );

    COMMIT;
    SELECT LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `afkusers`
--

/*!50001 DROP VIEW IF EXISTS `afkusers`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `afkusers` AS select `users`.`id` AS `id`,`users`.`username` AS `username`,`users`.`first_name` AS `first_name`,`users`.`last_name` AS `last_name`,`users`.`password_hash` AS `password_hash`,`users`.`date_joined` AS `date_joined`,`users`.`date_password_changed` AS `date_password_changed` from (`users` join `messages` on((`messages`.`from_user` = `users`.`id`))) where (`messages`.`date_created` <= cast((now() - interval 7 day) as date)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-20  0:59:44
