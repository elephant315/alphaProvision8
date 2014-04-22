-- MySQL dump 10.13  Distrib 5.1.63, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: isoft_config
-- ------------------------------------------------------
-- Server version	5.1.63-0+squeeze1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `params`
--

DROP TABLE IF EXISTS `params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device` varchar(60) DEFAULT NULL,
  `nice` tinyint(4) NOT NULL DEFAULT '0',
  `type` varchar(60) DEFAULT NULL,
  `typedescr` text,
  `param` varchar(60) DEFAULT NULL,
  `paramdescr` text,
  `defval` varchar(60) DEFAULT NULL,
  `dependency` varchar(255) DEFAULT NULL,
  `rgexp` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `params`
--

LOCK TABLES `params` WRITE;
/*!40000 ALTER TABLE `params` DISABLE KEYS */;
INSERT INTO `params` VALUES (1,'sip-phone',1,'basic','','enabled','Включена или выключена учетная запись 1','0','2;3;4','^[0-1]{1}+$'),(2,'sip-phone',1,'basic-readonly',NULL,'label','Имя абонента, отображается на экране телефона и при определении номера при звонке другим абонентам','','1;3;4','^[0-9-a-zA-Zа-яА-Я ]{1,40}+$'),(3,'sip-phone',1,'basic-readonly',NULL,'username','Имя пользователя SIP сервера','','1;2;4','^[0-9-a-zA-Z]{1,40}+$'),(4,'sip-phone',1,'basic',NULL,'password','Пароль SIP аккаунта','','1;2;3','^[0-9-a-zA-Z]{1,40}+$'),(5,'sip-phone',1,'basic',NULL,'serverhost','Адрес SIP сервера','','6','^[0-9-a-zA-Z .]{1,40}+$'),(6,'sip-phone',1,'basic',NULL,'serverport','Порт  SIP сервера','','5','^[0-9]{1,6}+$'),(7,'sip-phone',2,'sip-additional',NULL,'useproxy','Использование SIP прокси для звонков, не используется по умолчанию (0), включить (1)','0','8;9','^[0-1]{1}+$'),(8,'sip-phone',2,'sip-additional',NULL,'proxyhost','Адрес прокси сервера','','7;9','^[0-9-a-zA-Z .]{1,40}+$'),(9,'sip-phone',2,'sip-additional',NULL,'proxyport','Порт прокси сервера','','7;8','^[0-9]{1,6}+$'),(10,'sip-phone',2,'sip-additional',NULL,'transport','Используемый протокол по умолчанию UDP (0), TCP (1), TLS (2)','0','','^[0-1]{1}+$'),(11,'sip-phone',2,'sip-additional',NULL,'expire','Срок регистрации на сервере по умолчанию 3600 секунд','3600','','^[0-9]{1,5}+$'),(12,'sip-phone',2,'sip-additional',NULL,'listenport','Порт для входящих соединений, по умолчанию 5060','5060','','^[0-9]{1,5}+$'),(13,'sip-phone',4,'sip-additional',NULL,'rtpencrypt','Использовать шифрование голосового трафика, выключено по умолчанию (0), включить (1)','0','','^[0-1]{1}+$'),(14,'sip-phone',2,'phone',NULL,'autoanswer','Автоматически поднимать трубку при звонке, выключено по умолчанию (0), включить (1)','0','','^[0-1]{1}+$'),(15,'sip-phone',1,'dtmf',NULL,'dtmftype','Тип DTMF по умолчанию RFC2833 (1), INBAND (0), SIP INFO (2), Автоматически + SIP INFO (3)','1','16;17','^[0-3]{1}+$'),(16,'sip-phone',1,'dtmf',NULL,'dtmfinfo','Значение DTMF Info по умолчанию выключено (0), DTMF-Relay (1), DTMF (2), Событие телефона (3)','0','15;17','^[0-3]{1}+$'),(17,'sip-phone',1,'dtmf',NULL,'dtmfpayload','DTMF Payload по умолчанию 101, можно устанавливать от 96 до 255','101','15;16','^[0-9]{1,3}+$'),(18,'sip-phone',3,'nat',NULL,'nattraversal','Использовать NAT Traversal выключено по умолчанию (0), ипользовать STUN (1)','0','19;20','^[0-1]{1}+$'),(19,'sip-phone',3,'nat',NULL,'stunserver','Имя STUN сервера','','18;20','^[0-9-a-zA-Z .]{1,40}+$'),(20,'sip-phone',3,'nat',NULL,'stunport','Порт STUN сервера','','18;19','^[0-9]{1,6}+$'),(21,'sip-phone',2,'phone',NULL,'ringtype','Мелодия звонка по умолчанию common , можно устанавливать от Ring1.wav до 8ми если не закачаны свои мелодии','common','','^[0-9-a-zA-Z .]{1,40}+$'),(22,'sip-phone',4,'wan',NULL,'wantype','Использовать по умолчанию DHCP (0), PPPoE (1), Статичный IP (2)','0','23;24;25','^[0-2]{1}+$'),(23,'sip-phone',4,'wan',NULL,'wanstaticip','Статичный IP (пример: 192.168.1.40)','','22;24;25','^[0-9-a-zA-Z .]{1,40}+$'),(24,'sip-phone',4,'wan',NULL,'wanmask','Маска сети если используется статичный IP','','22;23;25','^[0-9-a-zA-Z .]{1,40}+$'),(25,'sip-phone',4,'wan',NULL,'wangw','Шлюз если используется статичный IP','','22;23;24','^[0-9-a-zA-Z .]{1,40}+$'),(26,'sip-phone',4,'wan',NULL,'primarydns','Первичный DNS  если используется статичный IP','','27','^[0-9-a-zA-Z .]{1,40}+$'),(27,'sip-phone',4,'wan',NULL,'secondarydns','Вторичный DNS  если используется статичный IP','','26','^[0-9-a-zA-Z .]{1,40}+$'),(28,'sip-phone',3,'lan',NULL,'lantype','По умолчанию порт LAN (PC) работает как мост (1), маршрутизатор (0)','1','','^[0-1]{1}+$'),(29,'sip-phone',3,'lan',NULL,'langatewayip','IP адрес когда порт LAN в режиме маршрутизатора','','','^[0-9-a-zA-Z .]{1,40}+$'),(30,'sip-phone',3,'lan',NULL,'lansubnet','Маска сети когда порт LAN в режиме маршрутизатора','','','^[0-9-a-zA-Z .]{1,40}+$'),(31,'sip-phone',3,'lan',NULL,'enabledhcp','Включить раздачу DHCP  когда порт LAN в режиме маршрутизатора','','','^[0-1]{1}+$'),(32,'sip-phone',3,'lan',NULL,'dhcpstart','Диапазон выдачи IP по умолчанию 10.0.0.10','','','^[0-9-a-zA-Z .]{1,40}+$'),(33,'sip-phone',3,'lan',NULL,'dhcpend','Диапазон выдачи IP по умолчанию 10.0.0.100','','','^[0-9-a-zA-Z .]{1,40}+$'),(34,'sip-phone',3,'vlan',NULL,'vlanwan','Поддержка VLAN на порту WAN выключена по умолчанию (0), включить (1)','0','35','^[0-1]{1}+$'),(35,'sip-phone',3,'vlan',NULL,'vlanvid','ID порта VLAN по умолчанию 0','0','34','^[0-9]{1,2}+$'),(36,'sip-phone',3,'qos',NULL,'rtpqos','Настройки QOS для голосового траффика. По умолчанию 40 (от 0-63)','40','37','^[0-9]{1,2}+$'),(37,'sip-phone',3,'qos',NULL,'signaltos','Настройки QOS для SIP трафика. По умолчанию 40 (от 0-63)','40','36','^[0-9]{1,2}+$'),(38,'sip-phone',3,'rtp',NULL,'rtpmax','Использование UDP портов для RTP трафика, максимальный порт по умолчанию 11800','11800','39','^[0-9]{1,6}+$'),(39,'sip-phone',3,'rtp',NULL,'rtpmin','Использование UDP портов для RTP трафика, минимальный порт по умолчанию 11780','11780','38','^[0-9]{1,6}+$'),(40,'sip-phone',2,'phone',NULL,'contrast','Контраст дисплея от 1-10','6','','^[0-9]{1,2}+$'),(41,'sip-phone',2,'phone',NULL,'backlight','Яркость подсветки 1-10','2','','^[0-9]{1,2}+$'),(42,'sip-phone',2,'phone',NULL,'ringvol','Громкость звонка 1-15','15','','^[0-9]{1,2}+$'),(46,'sip-device',4,'asterisk','Параметры Asterisk для настроек PBX','asterisk_userhost','Тип или IP клиента','dynamic','','^[0-9-a-zA-Z .]{1,40}+$'),(43,'sip-t3x',2,'T3X series',NULL,'backgroundpng','T3X series only, background PNG image, default:Resource:pictures (01).png,  custom: Config:IMG_3156.png','Resource:pictures (01).png','44;45','^[0-9-a-zA-Z .():_ ]{1,40}+$'),(44,'sip-t3x',2,'T3X series',NULL,'screensaverpngurl','PNG file url',NULL,'43;44','^[0-9-a-zA-Z .:/]{1,40}+$'),(45,'sip-t3x',2,'T3X series',NULL,'backgroundpngurl','PNG file url',NULL,'43;45','^[0-9-a-zA-Z .:/]{1,40}+$'),(47,'sip-device',4,'asterisk','Параметры Asterisk для настроек PBX','asterisk_context','Контекст для диал-плана Asterisk','default_context','','^[0-9-a-zA-Z .]{1,40}+$'),(48,'sip-device',2,'phone','','ntpserver1','NTP сервер для синхронизации времени','172.16.17.222','','^[0-9-a-zA-Z .]{1,40}+$');
/*!40000 ALTER TABLE `params` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-04-22 21:08:39
