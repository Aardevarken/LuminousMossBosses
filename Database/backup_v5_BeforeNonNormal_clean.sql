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
-- Table structure for table `detection_objects`
--

DROP TABLE IF EXISTS `detection_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `detection_objects` (
  `ObjectID` int(11) NOT NULL AUTO_INCREMENT,
  `ParentImageID` int(11) NOT NULL,
  `XCord` int(11) NOT NULL,
  `YCord` int(11) NOT NULL,
  `Radius` int(11) NOT NULL,
  `IsPosDetect` tinyint(1) DEFAULT NULL,
  `IsUserDetected` tinyint(1) DEFAULT NULL,
  `FileName` varchar(128) DEFAULT NULL,
  `Location` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ObjectID`),
  KEY `ParentImageID` (`ParentImageID`),
  CONSTRAINT `detection_objects_ibfk_1` FOREIGN KEY (`ParentImageID`) REFERENCES `images` (`ImageID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `observations`
--

DROP TABLE IF EXISTS `observations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `observations` (
  `ObsID` int(11) NOT NULL AUTO_INCREMENT,
  `Time` time DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `Latitude` float(9,4) DEFAULT NULL,
  `Longitude` float(9,6) DEFAULT NULL,
  `ImageURL` varchar(50) DEFAULT NULL,
  `DiskLoction` varchar(128) DEFAULT NULL,
  `ImageID` int(11) NOT NULL DEFAULT '0',
  `Username` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`ObsID`),
  KEY `ImageID` (`ImageID`),
  KEY `user_obs` (`Username`),
  CONSTRAINT `observations_ibfk_1` FOREIGN KEY (`ImageID`) REFERENCES `images` (`ImageID`),
  CONSTRAINT `user_obs` FOREIGN KEY (`Username`) REFERENCES `users` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `testresults`
--

DROP TABLE IF EXISTS `testresults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `testresults` (
  `TestID` int(11) NOT NULL AUTO_INCREMENT,
  `XMLID` int(11) NOT NULL,
  `ProbCorrectID` float(6,5) DEFAULT NULL,
  `PerFalsePos` float(6,5) DEFAULT NULL,
  `PerFalseNeg` float(6,5) DEFAULT NULL,
  `PerUnknowns` float(6,5) DEFAULT NULL,
  PRIMARY KEY (`TestID`),
  KEY `XMLID` (`XMLID`),
  CONSTRAINT `testresults_ibfk_1` FOREIGN KEY (`XMLID`) REFERENCES `xmldata` (`XMLID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `training`
--

DROP TABLE IF EXISTS `training`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `training` (
  `ObjectID` int(11) NOT NULL,
  `XMLID` int(11) NOT NULL,
  KEY `ObjectID` (`ObjectID`),
  KEY `XMLID` (`XMLID`),
  CONSTRAINT `training_ibfk_1` FOREIGN KEY (`ObjectID`) REFERENCES `detection_objects` (`ObjectID`),
  CONSTRAINT `training_ibfk_2` FOREIGN KEY (`XMLID`) REFERENCES `xmldata` (`XMLID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `validplants`
--

DROP TABLE IF EXISTS `validplants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `validplants` (
  `ScientificName` varchar(32) NOT NULL,
  `PlantName` varchar(32) DEFAULT NULL,
  `Description` blob,
  PRIMARY KEY (`ScientificName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xmldata`
--

DROP TABLE IF EXISTS `xmldata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xmldata` (
  `XMLID` int(11) NOT NULL AUTO_INCREMENT,
  `FileName` varchar(20) NOT NULL,
  `CreationDate` date DEFAULT NULL,
  `CreationTime` time DEFAULT NULL,
  `TestName` varchar(20) NOT NULL,
  `AppVersion` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`XMLID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-16 18:04:12
