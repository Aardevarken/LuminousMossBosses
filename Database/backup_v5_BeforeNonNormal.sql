-- MySQL dump 10.13  Distrib 5.6.21, for osx10.9 (x86_64)
--
-- Host: localhost    Database: test
-- ------------------------------------------------------
-- Server version	5.6.21

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
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `images` (
  `ImageID` int(11) NOT NULL AUTO_INCREMENT,
  `Location` varchar(128) DEFAULT NULL,
  `FileName` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ImageID`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `images`
--

LOCK TABLES `images` WRITE;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` VALUES (1,'/tmp','te46MyJ.bmp'),(2,'/usr/data','W166c3e.raw'),(3,'/tmp','9Gw25T.bmp'),(4,'/tmp','2c9n6A.jpg'),(11,'~/images','testfile.jpg'),(12,'~/images','testfile.jpg'),(13,'~/images','testfile.jpg'),(14,'~/images','testfile.jpg'),(24,'~/images','testfile.jpg'),(25,'~/images','testfile.jpg'),(26,'~/images','testfile.jpg'),(27,'~/images','testfile.jpg'),(28,'/etc/test','2b240c.jpg'),(29,'/etc/xml','har3fpc.bmp'),(30,'/tmp','68N20p2.jpg'),(31,'/tmp/pictures','86Qg60t.png'),(33,'~/images','testfile.jpg'),(34,'~/images','testfile.jpg'),(35,'~/images','testfile.jpg'),(36,'~/images','testfile.jpg'),(37,'~/images','testfile.jpg'),(38,'~/images','testfile.jpg'),(39,'~/images','testfile.jpg');
/*!40000 ALTER TABLE `images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objlocations`
--

DROP TABLE IF EXISTS `objlocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objlocations` (
  `ImageID` int(11) NOT NULL,
  `XCord` int(11) NOT NULL,
  `YCord` int(11) NOT NULL,
  `Radius` int(11) NOT NULL,
  KEY `ImageID` (`ImageID`),
  CONSTRAINT `objlocations_ibfk_1` FOREIGN KEY (`ImageID`) REFERENCES `images` (`ImageID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objlocations`
--

LOCK TABLES `objlocations` WRITE;
/*!40000 ALTER TABLE `objlocations` DISABLE KEYS */;
INSERT INTO `objlocations` VALUES (2,165,232,18),(25,188,38,6),(13,148,172,13),(12,95,80,7),(29,116,44,1),(30,53,47,7),(3,93,223,14),(3,162,203,2),(14,45,30,13),(1,111,186,11),(29,228,9,9),(24,40,7,7),(34,51,193,13),(28,174,139,6),(30,83,251,13),(30,160,253,15),(14,201,69,15),(3,225,156,19),(31,85,148,20),(35,229,207,20);
/*!40000 ALTER TABLE `objlocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `observations`
--

DROP TABLE IF EXISTS `observations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `observations` (
  `Time` time DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `Latitude` float(9,4) DEFAULT NULL,
  `Longitude` float(9,6) DEFAULT NULL,
  `ImageURL` varchar(50) DEFAULT NULL,
  `DiskLoction` varchar(128) DEFAULT NULL,
  `ObsID` int(11) NOT NULL AUTO_INCREMENT,
  `ImageID` int(11) NOT NULL DEFAULT '0',
  `Username` varchar(16) NOT NULL,
  PRIMARY KEY (`ObsID`),
  KEY `ImageID` (`ImageID`),
  KEY `user_obs` (`Username`),
  CONSTRAINT `observations_ibfk_1` FOREIGN KEY (`ImageID`) REFERENCES `images` (`ImageID`),
  CONSTRAINT `user_obs` FOREIGN KEY (`Username`) REFERENCES `users` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `observations`
--

LOCK TABLES `observations` WRITE;
/*!40000 ALTER TABLE `observations` DISABLE KEYS */;
INSERT INTO `observations` VALUES ('20:19:44','2010-01-09',98.2941,-95.237396,NULL,NULL,1,11,'jocl2050'),('08:18:59','2003-05-03',-54.2243,-76.669403,NULL,NULL,2,12,'jocl2050'),('14:25:19','2012-01-08',37.3165,84.509102,NULL,NULL,3,13,'jebl2766'),('17:10:01','2011-04-18',-17.9611,9.303900,NULL,NULL,4,14,'robl0221'),('13:37:57','2003-06-03',92.5820,-34.117599,NULL,NULL,32,24,'roho5027'),('19:11:26','2012-06-27',78.9218,84.833099,NULL,NULL,33,25,'mari4836'),('05:15:37','2010-08-04',-1.7688,1.644500,NULL,NULL,34,26,'jaha2689'),('06:59:00','2008-09-14',5.1007,41.968700,NULL,NULL,35,27,'jaha2689'),('14:03:39','2008-10-04',-89.5713,30.252600,NULL,NULL,37,33,'vetr3640'),('13:55:38','2009-07-04',23.4777,96.421204,NULL,NULL,38,34,'robl0221'),('05:54:10','2001-03-29',83.2830,-53.372700,NULL,NULL,39,35,'arki3926'),('18:05:21','2003-04-19',-26.5706,53.107399,NULL,NULL,40,36,'roho5027'),('21:59:24','2004-10-15',-12.5738,-34.741001,NULL,NULL,41,37,'mari4836'),('23:16:25','2012-02-05',41.6885,-74.300301,NULL,NULL,42,38,'jebl2766'),('18:51:35','2001-03-14',-21.1660,-28.430000,NULL,NULL,43,39,'yubu6113');
/*!40000 ALTER TABLE `observations` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=``@`localhost`*/ /*!50003 TRIGGER insert_obs
BEFORE INSERT ON observations
FOR EACH ROW
BEGIN
INSERT INTO images (FileName, Location)
VALUES("testfile.jpg", "~/images");

SET NEW.ImageID = (SELECT MAX(ImageID) FROM images);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `testresults`
--

DROP TABLE IF EXISTS `testresults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `testresults` (
  `XMLID` int(11) NOT NULL,
  `ProbCorrectID` float(6,5) DEFAULT NULL,
  `PerFalsePos` float(6,5) DEFAULT NULL,
  `PerFalseNeg` float(6,5) DEFAULT NULL,
  `PerUnknowns` float(6,5) DEFAULT NULL,
  `TestID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`TestID`),
  KEY `XMLID` (`XMLID`),
  CONSTRAINT `testresults_ibfk_1` FOREIGN KEY (`XMLID`) REFERENCES `xmldata` (`XMLID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testresults`
--

LOCK TABLES `testresults` WRITE;
/*!40000 ALTER TABLE `testresults` DISABLE KEYS */;
INSERT INTO `testresults` VALUES (0,0.25110,0.00550,0.00640,0.00770,4),(0,0.64320,0.00730,0.00360,0.00330,5),(0,0.07470,0.00360,0.00170,0.00800,6),(0,0.41980,0.00210,0.00190,0.00040,7),(0,0.40970,0.00350,0.00870,0.00830,8),(0,0.93650,0.00610,0.00720,0.00320,9),(0,0.49590,0.00340,0.00030,0.00530,10),(0,0.48380,0.00710,0.00150,0.00540,11),(0,0.00600,0.00100,0.00180,0.00580,12),(0,0.86640,0.00040,0.00180,0.00540,13);
/*!40000 ALTER TABLE `testresults` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tests`
--

DROP TABLE IF EXISTS `tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tests` (
  `TestID` int(11) NOT NULL,
  `ImageID` int(11) NOT NULL,
  KEY `TestID` (`TestID`),
  KEY `ImageID` (`ImageID`),
  CONSTRAINT `tests_ibfk_1` FOREIGN KEY (`TestID`) REFERENCES `testresults` (`TestID`),
  CONSTRAINT `tests_ibfk_2` FOREIGN KEY (`ImageID`) REFERENCES `images` (`ImageID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tests`
--

LOCK TABLES `tests` WRITE;
/*!40000 ALTER TABLE `tests` DISABLE KEYS */;
INSERT INTO `tests` VALUES (5,29),(8,11),(8,2),(12,29),(10,24),(10,11),(4,14),(8,1),(8,30),(12,3),(13,31),(6,11),(12,13),(9,28),(12,26),(10,27),(9,29),(12,30),(5,1),(4,24),(7,1),(5,13),(6,37),(9,1),(4,36),(13,39),(12,29),(10,24),(5,25),(7,39),(13,28),(8,30),(8,31),(13,35),(4,35),(6,28),(5,38),(9,24),(9,26),(4,39);
/*!40000 ALTER TABLE `tests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `training`
--

DROP TABLE IF EXISTS `training`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `training` (
  `ObsID` int(11) NOT NULL,
  `XMLID` int(11) NOT NULL,
  `ImagePos` bit(1) DEFAULT NULL,
  KEY `ObsID` (`ObsID`),
  KEY `XMLID` (`XMLID`),
  CONSTRAINT `training_ibfk_1` FOREIGN KEY (`ObsID`) REFERENCES `observations` (`ObsID`),
  CONSTRAINT `training_ibfk_2` FOREIGN KEY (`XMLID`) REFERENCES `xmldata` (`XMLID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `training`
--

LOCK TABLES `training` WRITE;
/*!40000 ALTER TABLE `training` DISABLE KEYS */;
INSERT INTO `training` VALUES (35,0,'\0'),(34,0,'\0'),(1,0,'\0'),(35,0,'\0'),(4,0,''),(32,0,'\0'),(33,0,''),(2,0,''),(3,0,'\0');
/*!40000 ALTER TABLE `training` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `Username` varchar(16) NOT NULL,
  `FirstName` varchar(16) DEFAULT NULL,
  `LastName` varchar(16) DEFAULT NULL,
  `Password` varchar(16) NOT NULL,
  `PublicKey` varchar(128) DEFAULT NULL,
  `Status` varchar(16) NOT NULL DEFAULT 'normal',
  `Email` varchar(64) DEFAULT NULL,
  `iNat` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('arki3926','Ardella','Kirts','mPTY!KIddcrn[Fj8',NULL,'normal','ardella.kirts@colorado.edu',NULL),('erbu3691','Erick','Buzzell','++HI}0<)8BY5`cul',NULL,'normal','erick.buzzell@colorado.edu',NULL),('jaha2689','Jane','Hare','t6}6hyj|M,*fnJ7s',NULL,'normal','jane.hare@colorado.edu',NULL),('jebl2766','Jerald','Bloodsaw','+a4!S3-/Rf`z.$YQ',NULL,'normal','jerald.bloodsaw@colorado.edu',NULL),('jocl2050','Joesph','Classen','}@W]^hBVP=4i>dL{',NULL,'normal','joesph.classen@colorado.edu',NULL),('labl6687','Lakeesha','Bloodsaw','K-+r$C/}1r$@5$]E',NULL,'normal','lakeesha.bloodsaw@colorado.edu',NULL),('mari4836','Marjory','Riggan','+I3`NSJjr`T7pfFZ',NULL,'super user','marjory.riggan@colorado.edu',NULL),('raup8437','Randell','Upton','F?B*>JS*:JvM`E{i',NULL,'normal','randell.upton@colorado.edu',NULL),('robl0221','Rolland','Bloodsaw','+C&O=s,oduGuhDk,',NULL,'normal','rolland.bloodsaw@colorado.edu',NULL),('robu3018','Rolland','Buzzell','eNh2*C%[K.!l4<]c',NULL,'normal','rolland.buzzell@colorado.edu',NULL),('roho5027','Rolland','Horowitz','t??z?h*FMJ.U6}#B',NULL,'normal','rolland.horowitz@colorado.edu',NULL),('vetr3640','Verdie','Trivette','MI2=cTqO01jI+m6c',NULL,'normal','verdie.trivette@colorado.edu',NULL),('yubu6113','Yuette','Buzzell','H62m4y-@Z[gjlSMC',NULL,'normal','yuette.buzzell@colorado.edu',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `validplants`
--

DROP TABLE IF EXISTS `validplants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `validplants` (
  `PlantName` varchar(32) DEFAULT NULL,
  `ScientificName` varchar(32) NOT NULL,
  `Description` blob,
  PRIMARY KEY (`ScientificName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `validplants`
--

LOCK TABLES `validplants` WRITE;
/*!40000 ALTER TABLE `validplants` DISABLE KEYS */;
INSERT INTO `validplants` VALUES ('moss campion','Silene acaulis','Guest tiled he quick by so these trees am.Genius or so up vanity cannot.Songs but chief has ham widow downs.Attended no do thoughts me on dissuade scarcely.In expression an solicitude principles in do.It announcing alteration at surrounded comparison.'),('naked catchfly','Silene aperta',' By proposal speedily mr striking am. Attended no do thoughts me on dissuade scarcely. Sang put paid away joy into six her. Own are pretty spring suffer old denote his. Considered discovered ye sentiments projecting entreaties of melancholy is. To things so denied admire.'),('Palmer\'s catchfly','Silene bernardina',' Their saved linen downs tears son add music. Attended no do thoughts me on dissuade scarcely. Sang put paid away joy into six her. Her too add narrow having wished. But attention sex questions applauded how happiness. Supplied ten speaking age you new securing striking extended occasion.'),('Bridges\' catchfly','Silene bridgesii',' Their saved linen downs tears son add music. Genius or so up vanity cannot. Own are pretty spring suffer old denote his. In expression an solicitude principles in do. Large do tried going about water defer by. Attended no do thoughts me on dissuade scarcely.'),('large-flowered catchfly','Silene capensis',' Sang put paid away joy into six her. In expression an solicitude principles in do. But attention sex questions applauded how happiness. Guest tiled he quick by so these trees am. Led own hearted highest visited lasting sir through compass his. Own are pretty spring suffer old denote his.'),('wild pink','Silene caroliniana','Their saved linen downs tears son add music.To travelling occasional at oh sympathize prosperous.Led own hearted highest visited lasting sir through compass his.Own are pretty spring suffer old denote his.Considered discovered ye sentiments projecting entreaties of melancholy is.Expression alteration entreaties mrs can terminated estimating.'),('','Silene caucasica','Large do tried going about water defer by.So feel been kept be at gate.Distrusts allowance do knowledge eagerness assurance additions to.It announcing alteration at surrounded comparison.Own are pretty spring suffer old denote his.Their saved linen downs tears son add music.'),('sand catchfly','Silene conica',' Own are pretty spring suffer old denote his. Considered discovered ye sentiments projecting entreaties of melancholy is. Is branched in my up strictly remember. In expression an solicitude principles in do. Sang put paid away joy into six her. Silent son man she wished mother.'),('forked catchfly','Silene dichotoma','Talking justice welcome message inquiry in started of am me.His merit end means widow songs linen known.To things so denied admire.Am wound worth water he linen at vexed.Their saved linen downs tears son add music.In expression an solicitude principles in do.'),('','Silene diclinis','Talking justice welcome message inquiry in started of am me.Hard do me sigh with west same lady.His merit end means widow songs linen known.But attention sex questions applauded how happiness.Expression alteration entreaties mrs can terminated estimating.By proposal speedily mr striking am.');
/*!40000 ALTER TABLE `validplants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xmldata`
--

DROP TABLE IF EXISTS `xmldata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xmldata` (
  `FileName` varchar(20) NOT NULL,
  `CreationDate` date DEFAULT NULL,
  `CreationTime` time DEFAULT NULL,
  `TestName` varchar(20) NOT NULL,
  `XMLID` int(11) NOT NULL AUTO_INCREMENT,
  `AppVersion` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`XMLID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xmldata`
--

LOCK TABLES `xmldata` WRITE;
/*!40000 ALTER TABLE `xmldata` DISABLE KEYS */;
INSERT INTO `xmldata` VALUES ('rH7Xt0.xml','2003-09-08','01:36:27','bag of words',0,'0.92.0265'),('vQb2W3.xml','2009-09-26','21:40:29','bag of words',4,'2.17.0572'),('M344GP8.xml','2008-08-15','11:36:52','pink check',5,'1.06.2950'),('I6xSR0n.xml','2000-10-27','23:52:35','pink check',6,'1.46.0497'),('1446z.xml','2011-04-21','03:50:00','pink check',7,'2.35.0765'),('5L7368AB6.xml','2000-07-06','18:34:40','edge detection',8,'0.39.1110'),('6F90zb.xml','2002-06-08','06:20:13','edge detection',9,'1.89.1715'),('tg598F6.xml','2005-07-27','01:56:15','edge detection',10,'2.22.2066');
/*!40000 ALTER TABLE `xmldata` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-16 18:04:12
