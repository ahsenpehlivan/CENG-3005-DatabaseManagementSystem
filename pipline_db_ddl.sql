-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: pipline_db
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `accident_costs`
--

DROP TABLE IF EXISTS `accident_costs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accident_costs` (
  `CT_CostTypeID` int NOT NULL,
  `AR_ResultID` int NOT NULL,
  `Amount` decimal(14,2) DEFAULT NULL,
  PRIMARY KEY (`CT_CostTypeID`,`AR_ResultID`),
  KEY `AR_ResultID` (`AR_ResultID`),
  CONSTRAINT `accident_costs_ibfk_1` FOREIGN KEY (`CT_CostTypeID`) REFERENCES `cost_type` (`CostTypeID`),
  CONSTRAINT `accident_costs_ibfk_2` FOREIGN KEY (`AR_ResultID`) REFERENCES `accident_results` (`ResultID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM accident_costs LIMIT 1;
# CT_CostTypeID	AR_ResultID	  Amount
--     1	       1	     26000.00


--
-- Table structure for table `accident_impacts`
--

DROP TABLE IF EXISTS `accident_impacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accident_impacts` (
  `IT_ImpactTypeID` int NOT NULL,
  `AR_ResultID` int NOT NULL,
  `ImpactValue` int DEFAULT NULL,
  PRIMARY KEY (`IT_ImpactTypeID`,`AR_ResultID`),
  KEY `AR_ResultID` (`AR_ResultID`),
  CONSTRAINT `accident_impacts_ibfk_1` FOREIGN KEY (`IT_ImpactTypeID`) REFERENCES `impact_type` (`ImpactTypeID`),
  CONSTRAINT `accident_impacts_ibfk_2` FOREIGN KEY (`AR_ResultID`) REFERENCES `accident_results` (`ResultID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM accident_impacts LIMIT 1;
# IT_ImpactTypeID	AR_ResultID	ImpactValue
--        1	             656	     1


--
-- Table structure for table `accident_location`
--

DROP TABLE IF EXISTS `accident_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accident_location` (
  `AccidentLatitude` float NOT NULL,
  `AccidentLongitude` float NOT NULL,
  `CTCO_CityID` int NOT NULL,
  PRIMARY KEY (`AccidentLatitude`,`AccidentLongitude`),
  KEY `CTCO_CityID` (`CTCO_CityID`),
  CONSTRAINT `accident_location_ibfk_1` FOREIGN KEY (`CTCO_CityID`) REFERENCES `city_to_county` (`CityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM accident_location LIMIT 1;
# AccidentLatitude	AccidentLongitude	CTCO_CityID
--   40.622	            -97.5497	         1


--
-- Table structure for table `accident_report`
--

DROP TABLE IF EXISTS `accident_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accident_report` (
  `ReportNumber` int NOT NULL,
  `SupplementalNumber` int NOT NULL,
  `AccidentDateTime` datetime NOT NULL,
  `AL_AccidentLatitude` float NOT NULL,
  `AL_AccidentLongitude` float NOT NULL,
  `LN_LiquidID` int NOT NULL,
  `CS_CauseSubcategoryID` int NOT NULL,
  `PF_PiplineFacilityID` int NOT NULL,
  `PF_OP_OperatorID` int NOT NULL,
  `AR_ResultID` int NOT NULL,
  PRIMARY KEY (`ReportNumber`,`AR_ResultID`),
  KEY `AL_AccidentLatitude` (`AL_AccidentLatitude`,`AL_AccidentLongitude`),
  KEY `LN_LiquidID` (`LN_LiquidID`),
  KEY `CS_CauseSubcategoryID` (`CS_CauseSubcategoryID`),
  KEY `PF_PiplineFacilityID` (`PF_PiplineFacilityID`,`PF_OP_OperatorID`),
  KEY `AR_ResultID` (`AR_ResultID`),
  CONSTRAINT `accident_report_ibfk_1` FOREIGN KEY (`AL_AccidentLatitude`, `AL_AccidentLongitude`) REFERENCES `accident_location` (`AccidentLatitude`, `AccidentLongitude`),
  CONSTRAINT `accident_report_ibfk_2` FOREIGN KEY (`LN_LiquidID`) REFERENCES `liquid_name` (`LiquidID`),
  CONSTRAINT `accident_report_ibfk_3` FOREIGN KEY (`CS_CauseSubcategoryID`) REFERENCES `cause_subcategory` (`CauseSubcategoryID`),
  CONSTRAINT `accident_report_ibfk_4` FOREIGN KEY (`PF_PiplineFacilityID`, `PF_OP_OperatorID`) REFERENCES `pipeline_facility` (`PiplineFacilityID`, `OP_OperatorID`),
  CONSTRAINT `accident_report_ibfk_5` FOREIGN KEY (`AR_ResultID`) REFERENCES `accident_results` (`ResultID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM accident_report LIMIT 1;
# ReportNumber	SupplementalNumber	AccidentDateTime	AL_AccidentLatitude	AL_AccidentLongitude   LN_LiquidID	 CS_CauseSubcategoryID	PF_PiplineFacilityID	PF_OP_OperatorID	AR_ResultID
-- 20100001	          15751	      2010-02-16 07:42:00       	41.9435	           -88.2335	             4             	6	               2178	                 22610	            2682


--
-- Table structure for table `accident_results`
--

DROP TABLE IF EXISTS `accident_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accident_results` (
  `ResultID` int NOT NULL AUTO_INCREMENT,
  `Liquid_Ignition` tinyint(1) NOT NULL,
  `Liquid_Explosion` tinyint(1) NOT NULL,
  `Pipline_Shutdown` tinyint(1) DEFAULT NULL,
  `Shutdown_DateTime` datetime DEFAULT NULL,
  `Restart_DateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`ResultID`)
) ENGINE=InnoDB AUTO_INCREMENT=2796 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM accident_results LIMIT 1;
# ResultID	Liquid_Ignition	Liquid_Explosion	Pipline_Shutdown	Shutdown_DateTime	Restart_DateTime
--   1	           0	           0	               1	      2012-11-21 13:30:00	2012-11-22 20:00:00


--
-- Table structure for table `accident_spill_volume`
--

DROP TABLE IF EXISTS `accident_spill_volume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accident_spill_volume` (
  `AR_ResultID` int NOT NULL,
  `ST_SpillTypeID` int NOT NULL,
  `Barrel` int DEFAULT NULL,
  PRIMARY KEY (`AR_ResultID`,`ST_SpillTypeID`),
  KEY `ST_SpillTypeID` (`ST_SpillTypeID`),
  CONSTRAINT `accident_spill_volume_ibfk_1` FOREIGN KEY (`AR_ResultID`) REFERENCES `accident_results` (`ResultID`),
  CONSTRAINT `accident_spill_volume_ibfk_2` FOREIGN KEY (`ST_SpillTypeID`) REFERENCES `spill_type` (`SpillTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM accident_spill_volume LIMIT 1;
# AR_ResultID	ST_SpillTypeID	Barrel
--    1	             1	          60


--
-- Table structure for table `cause_category`
--

DROP TABLE IF EXISTS `cause_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cause_category` (
  `CauseCategoryID` int NOT NULL AUTO_INCREMENT,
  `CauseCategoryName` varchar(200) NOT NULL,
  PRIMARY KEY (`CauseCategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM cause_category LIMIT 1;
# CauseCategoryID	CauseCategoryName
--        1	      MATERIAL/WELD/EQUIP FAILURE


--
-- Table structure for table `cause_subcategory`
--

DROP TABLE IF EXISTS `cause_subcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cause_subcategory` (
  `CauseSubcategoryID` int NOT NULL AUTO_INCREMENT,
  `CauseSubcategoryName` varchar(200) NOT NULL,
  `CC_CauseCategoryID` int NOT NULL,
  PRIMARY KEY (`CauseSubcategoryID`),
  KEY `CC_CauseCategoryID` (`CC_CauseCategoryID`),
  CONSTRAINT `cause_subcategory_ibfk_1` FOREIGN KEY (`CC_CauseCategoryID`) REFERENCES `cause_category` (`CauseCategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM cause_subcategory LIMIT 1;
# CauseSubcategoryID	CauseSubcategoryName	CC_CauseCategoryID
--         1	        MANUFACTURING-RELATED	         1


--
-- Table structure for table `city_to_county`
--

DROP TABLE IF EXISTS `city_to_county`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city_to_county` (
  `CityID` int NOT NULL AUTO_INCREMENT,
  `AccidentCity` varchar(45) DEFAULT NULL,
  `COTS_CountyID` int NOT NULL,
  PRIMARY KEY (`CityID`),
  KEY `COTS_CountyID` (`COTS_CountyID`),
  CONSTRAINT `city_to_county_ibfk_1` FOREIGN KEY (`COTS_CountyID`) REFERENCES `county_to_state` (`CountyID`)
) ENGINE=InnoDB AUTO_INCREMENT=1320 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM city_to_county LIMIT 1;
# CityID	AccidentCity	COTS_CountyID
--  1	       FAIRMONT			1


--
-- Table structure for table `cost_type`
--

DROP TABLE IF EXISTS `cost_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_type` (
  `CostTypeID` int NOT NULL AUTO_INCREMENT,
  `CostTypeName` varchar(200) NOT NULL,
  PRIMARY KEY (`CostTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM cost_type LIMIT 1;
# CostTypeID	CostTypeName
--    1	      Property Damage



--
-- Table structure for table `county_to_state`
--

DROP TABLE IF EXISTS `county_to_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `county_to_state` (
  `CountyID` int NOT NULL AUTO_INCREMENT,
  `AccidentCounty` varchar(45) DEFAULT NULL,
  `ST_StateID` int NOT NULL,
  PRIMARY KEY (`CountyID`),
  KEY `ST_StateID` (`ST_StateID`),
  CONSTRAINT `county_to_state_ibfk_1` FOREIGN KEY (`ST_StateID`) REFERENCES `state` (`StateID`)
) ENGINE=InnoDB AUTO_INCREMENT=757 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM county_to_state LIMIT 1;
# CountyID	AccidentCounty	ST_StateID
--    1	       FILLMORE	       1


--
-- Table structure for table `impact_type`
--

DROP TABLE IF EXISTS `impact_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `impact_type` (
  `ImpactTypeID` int NOT NULL,
  `ImpactGroup` varchar(200) NOT NULL,
  `Party` varchar(200) NOT NULL,
  PRIMARY KEY (`ImpactTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM impact_type LIMIT 1;
# ImpactTypeID	ImpactGroup	Party
--      1	      Injury	Operator Employee


--
-- Table structure for table `liquid_class`
--

DROP TABLE IF EXISTS `liquid_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liquid_class` (
  `LiquidSubtypeID` int NOT NULL AUTO_INCREMENT,
  `LiquidSubtype` varchar(255) DEFAULT NULL,
  `LiquidType` varchar(255) NOT NULL,
  PRIMARY KEY (`LiquidSubtypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM liquid_class LIMIT 1;
# LiquidSubtypeID	LiquidSubtype	       LiquidType
--      1	   GASOLINE (NON-ETHANOL)	REFINED AND/OR PETROLEUM PRODUCT (NON-HVL), LIQUID



--
-- Table structure for table `liquid_name`
--

DROP TABLE IF EXISTS `liquid_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liquid_name` (
  `LiquidID` int NOT NULL AUTO_INCREMENT,
  `LiquidName` varchar(255) DEFAULT NULL,
  `LC_LiquidSubtypeID` int NOT NULL,
  PRIMARY KEY (`LiquidID`),
  KEY `LC_LiquidSubtypeID` (`LC_LiquidSubtypeID`),
  CONSTRAINT `liquid_name_ibfk_1` FOREIGN KEY (`LC_LiquidSubtypeID`) REFERENCES `liquid_class` (`LiquidSubtypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM liquid_name LIMIT 1;
# LiquidID	LiquidName	LC_LiquidSubtypeID
--   3	     ETHANE	         3


--
-- Table structure for table `operator`
--

DROP TABLE IF EXISTS `operator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operator` (
  `OperatorID` int NOT NULL,
  `OperatorName` varchar(255) NOT NULL,
  PRIMARY KEY (`OperatorID`),
  UNIQUE KEY `OperatorID_UNIQUE` (`OperatorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM operator LIMIT 1;
# OperatorID	OperatorName
--  300	       PLAINS PIPELINE, L.P.


--
-- Table structure for table `pipeline_facility`
--

DROP TABLE IF EXISTS `pipeline_facility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pipeline_facility` (
  `PiplineFacilityID` int NOT NULL AUTO_INCREMENT,
  `PipelineFacilityName` varchar(255) DEFAULT NULL,
  `PipelineLocation` varchar(255) NOT NULL,
  `PipelineType` varchar(255) DEFAULT NULL,
  `OP_OperatorID` int NOT NULL,
  PRIMARY KEY (`PiplineFacilityID`,`OP_OperatorID`),
  KEY `OP_OperatorID` (`OP_OperatorID`),
  CONSTRAINT `pipeline_facility_ibfk_1` FOREIGN KEY (`OP_OperatorID`) REFERENCES `operator` (`OperatorID`)
) ENGINE=InnoDB AUTO_INCREMENT=2270 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM pipeline_facility LIMIT 1;
# PiplineFacilityID	PipelineFacilityName	PipelineLocation	PipelineType	OP_OperatorID
--    1        	GENEVA TO NORFOLK - 8 INCH	    ONSHORE	        UNDERGROUND	        10012



--
-- Table structure for table `spill_type`
--

DROP TABLE IF EXISTS `spill_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spill_type` (
  `SpillTypeID` int NOT NULL AUTO_INCREMENT,
  `SpillTypeName` varchar(100) NOT NULL,
  PRIMARY KEY (`SpillTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM spill_type LIMIT 1;
# SpillTypeID	SpillTypeName
--     1	  Unintentional Release


--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `state` (
  `StateID` int NOT NULL AUTO_INCREMENT,
  `AccidentState` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`StateID`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SELECT * FROM state LIMIT 1;
# StateID	AccidentState
--  1         	NE


--
-- Temporary view structure for view `v_causecategory_accident_count`
--

DROP TABLE IF EXISTS `v_causecategory_accident_count`;
/*!50001 DROP VIEW IF EXISTS `v_causecategory_accident_count`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_causecategory_accident_count` AS SELECT 
 1 AS `CauseCategoryID`,
 1 AS `CauseCategory`,
 1 AS `AccidentCount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_operator_netloss_cost_summary`
--

DROP TABLE IF EXISTS `v_operator_netloss_cost_summary`;
/*!50001 DROP VIEW IF EXISTS `v_operator_netloss_cost_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_operator_netloss_cost_summary` AS SELECT 
 1 AS `OperatorID`,
 1 AS `OperatorName`,
 1 AS `TotalNetLoss_Barrels`,
 1 AS `TotalCost_USD`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_state_accident_summary`
--

DROP TABLE IF EXISTS `v_state_accident_summary`;
/*!50001 DROP VIEW IF EXISTS `v_state_accident_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_state_accident_summary` AS SELECT 
 1 AS `AccidentState`,
 1 AS `AccidentCount`,
 1 AS `TotalUnintentionalRelease_Barrels`,
 1 AS `TotalIntentionalRelease_Barrels`,
 1 AS `TotalRecovered_Barrels`,
 1 AS `TotalNetLoss_Barrels`,
 1 AS `TotalCost_USD`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_causecategory_accident_count`
--

/*!50001 DROP VIEW IF EXISTS `v_causecategory_accident_count`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_causecategory_accident_count` AS select `cc`.`CauseCategoryID` AS `CauseCategoryID`,`cc`.`CauseCategoryName` AS `CauseCategory`,count(0) AS `AccidentCount` from ((`accident_report` `ar` join `cause_subcategory` `cs` on((`ar`.`CS_CauseSubcategoryID` = `cs`.`CauseSubcategoryID`))) join `cause_category` `cc` on((`cs`.`CC_CauseCategoryID` = `cc`.`CauseCategoryID`))) group by `cc`.`CauseCategoryID`,`cc`.`CauseCategoryName` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_operator_netloss_cost_summary`
--

/*!50001 DROP VIEW IF EXISTS `v_operator_netloss_cost_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_operator_netloss_cost_summary` AS select `o`.`OperatorID` AS `OperatorID`,`o`.`OperatorName` AS `OperatorName`,((sum((case when (`st`.`SpillTypeName` like '%Unintentional%') then `asv`.`Barrel` else 0 end)) + sum((case when (`st`.`SpillTypeName` like '%Intentional%') then `asv`.`Barrel` else 0 end))) - sum((case when ((`st`.`SpillTypeName` like '%Recovery%') or (`st`.`SpillTypeName` like '%Recovered%')) then `asv`.`Barrel` else 0 end))) AS `TotalNetLoss_Barrels`,ifnull(sum(`ac`.`Amount`),0) AS `TotalCost_USD` from ((((`accident_report` `ar` join `operator` `o` on((`ar`.`PF_OP_OperatorID` = `o`.`OperatorID`))) left join `accident_spill_volume` `asv` on((`ar`.`AR_ResultID` = `asv`.`AR_ResultID`))) left join `spill_type` `st` on((`asv`.`ST_SpillTypeID` = `st`.`SpillTypeID`))) left join `accident_costs` `ac` on((`ar`.`AR_ResultID` = `ac`.`AR_ResultID`))) group by `o`.`OperatorID`,`o`.`OperatorName` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_state_accident_summary`
--

/*!50001 DROP VIEW IF EXISTS `v_state_accident_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_state_accident_summary` AS select `s`.`AccidentState` AS `AccidentState`,count(distinct `ar`.`ReportNumber`) AS `AccidentCount`,sum((case when (`st`.`SpillTypeName` like '%Unintentional%') then `asv`.`Barrel` else 0 end)) AS `TotalUnintentionalRelease_Barrels`,sum((case when (`st`.`SpillTypeName` like '%Intentional%') then `asv`.`Barrel` else 0 end)) AS `TotalIntentionalRelease_Barrels`,sum((case when ((`st`.`SpillTypeName` like '%Recovery%') or (`st`.`SpillTypeName` like '%Recovered%')) then `asv`.`Barrel` else 0 end)) AS `TotalRecovered_Barrels`,((sum((case when (`st`.`SpillTypeName` like '%Unintentional%') then `asv`.`Barrel` else 0 end)) + sum((case when (`st`.`SpillTypeName` like '%Intentional%') then `asv`.`Barrel` else 0 end))) - sum((case when ((`st`.`SpillTypeName` like '%Recovery%') or (`st`.`SpillTypeName` like '%Recovered%')) then `asv`.`Barrel` else 0 end))) AS `TotalNetLoss_Barrels`,ifnull(sum(`ac`.`Amount`),0) AS `TotalCost_USD` from (((((((`accident_report` `ar` join `accident_location` `al` on(((`ar`.`AL_AccidentLatitude` = `al`.`AccidentLatitude`) and (`ar`.`AL_AccidentLongitude` = `al`.`AccidentLongitude`)))) join `city_to_county` `ctc` on((`al`.`CTCO_CityID` = `ctc`.`CityID`))) join `county_to_state` `cts` on((`ctc`.`COTS_CountyID` = `cts`.`CountyID`))) join `state` `s` on((`cts`.`ST_StateID` = `s`.`StateID`))) left join `accident_spill_volume` `asv` on((`ar`.`AR_ResultID` = `asv`.`AR_ResultID`))) left join `spill_type` `st` on((`asv`.`ST_SpillTypeID` = `st`.`SpillTypeID`))) left join `accident_costs` `ac` on((`ar`.`AR_ResultID` = `ac`.`AR_ResultID`))) group by `s`.`AccidentState` */;
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

-- Dump completed on 2026-01-03 22:23:27
