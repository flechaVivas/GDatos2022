CREATE DATABASE  IF NOT EXISTS `role_play_events` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `role_play_events`;
-- MySQL dump 10.13  Distrib 8.0.31, for Linux (x86_64)
--
-- Host: localhost    Database: role_play_events
-- ------------------------------------------------------
-- Server version	8.0.31-0ubuntu2

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
-- Table structure for table `actividad`
--

DROP TABLE IF EXISTS `actividad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actividad` (
  `codigo_locacion` int unsigned NOT NULL,
  `nro` int unsigned NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `equipamiento` varchar(255) NOT NULL,
  PRIMARY KEY (`codigo_locacion`,`nro`),
  CONSTRAINT `fk_actividad_locacion` FOREIGN KEY (`codigo_locacion`) REFERENCES `locacion` (`codigo`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actividad`
--

LOCK TABLES `actividad` WRITE;
/*!40000 ALTER TABLE `actividad` DISABLE KEYS */;
INSERT INTO `actividad` VALUES (3523,5,'Almuerzo en cantina Mos Eisley','Indumentaria adecuada'),(3523,6,'Presentar tributo a Jabba','Disfraz Jabba'),(3524,3,'Great Tomb of Nazarick Raid','Cosplay Anime, Peluca de colores'),(3525,4,'Battle of Carmen Village','Indumentaria guerrillera, espadas, escudos'),(3526,7,'Robar la calavera de cristal','Indumentaria Indiana Jones, replica de calavera'),(3526,8,'Beber del Santo Grial','Caliz'),(3527,1,'Cocina de Metanfetamina','Matraz Erlenmeyer, Sal Yodada, Embudo, Pseudoefedrina '),(3528,2,'Jucio Oral vs Charles McGill','Telefono, Bateria, Indumentaria formal'),(404040,111,'The struggle for Trost','Equipo de maniobras tridimensionales'),(414141,222,'Raid on Liberio','Equipo de maniobras tridimensionales'),(414141,333,'Almuerzo','Cuchillo, tenedor y plato');
/*!40000 ALTER TABLE `actividad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asistente`
--

DROP TABLE IF EXISTS `asistente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asistente` (
  `dni` int unsigned NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `telefono` varchar(45) NOT NULL,
  PRIMARY KEY (`dni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asistente`
--

LOCK TABLES `asistente` WRITE;
/*!40000 ALTER TABLE `asistente` DISABLE KEYS */;
INSERT INTO `asistente` VALUES (28323881,'Eliana','Lopez','346577612'),(29988432,'Ramona','Martinez','341256577'),(30142098,'Gabriel','Hernandez','346587898'),(30675431,'Josefa','Rodriguez','345620987'),(32678876,'Martina','Sanchez','341665187'),(33546786,'Augusto','Garcia','346578912'),(34567876,'Juan','Pirez','341626276'),(41009812,'Federico','Sanchez','341545990'),(95959595,'Shinichi','Kudo','+959-59595959');
/*!40000 ALTER TABLE `asistente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asistente_contrato`
--

DROP TABLE IF EXISTS `asistente_contrato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asistente_contrato` (
  `dni_asistente` int unsigned NOT NULL,
  `nro_tour` int unsigned NOT NULL,
  `cuil_cliente` bigint unsigned NOT NULL,
  `fecha_hora` datetime NOT NULL,
  PRIMARY KEY (`dni_asistente`,`nro_tour`,`cuil_cliente`,`fecha_hora`),
  KEY `fk_asistente_contrato_contrata_idx` (`nro_tour`,`cuil_cliente`),
  KEY `fk_asistente_contrato_contrata_idx1` (`nro_tour`,`cuil_cliente`,`fecha_hora`),
  CONSTRAINT `fk_asistente_contrato_asistente` FOREIGN KEY (`dni_asistente`) REFERENCES `asistente` (`dni`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asistente_contrato_contrata` FOREIGN KEY (`nro_tour`, `cuil_cliente`, `fecha_hora`) REFERENCES `contrata` (`nro_tour`, `cuil_cliente`, `fecha_hora`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asistente_contrato`
--

LOCK TABLES `asistente_contrato` WRITE;
/*!40000 ALTER TABLE `asistente_contrato` DISABLE KEYS */;
INSERT INTO `asistente_contrato` VALUES (30675431,1,27200938477,'2022-06-30 17:32:09'),(32678876,1,27200938477,'2022-06-30 17:32:09'),(29988432,3,30693156315,'2022-05-10 11:23:13'),(30675431,3,30693156315,'2022-05-10 11:23:13'),(33546786,3,30693156315,'2022-05-10 11:23:13'),(41009812,3,30693156315,'2022-05-10 11:23:13'),(33546786,5,20268394082,'2021-11-13 22:22:22'),(41009812,5,20268394082,'2021-11-13 22:22:22'),(30142098,6,30707003304,'2021-07-22 12:03:32'),(32678876,6,30707003304,'2021-07-22 12:03:32'),(30142098,9,30710055455,'2020-05-30 11:13:07'),(30675431,9,30710055455,'2020-05-30 11:13:07'),(32678876,9,30710055455,'2020-05-30 11:13:07'),(41009812,9,30710055455,'2020-05-30 11:13:07'),(95959595,5555,99999999999,'2022-09-12 11:30:00'),(95959595,5757,99999999999,'2022-09-19 13:30:00');
/*!40000 ALTER TABLE `asistente_contrato` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `cuil` bigint unsigned NOT NULL,
  `denom` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `telefono` varchar(45) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `tipo` varchar(45) NOT NULL,
  PRIMARY KEY (`cuil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (20173845495,'Hector Conde','CondeH@hotmail.com ','3467829776','3 de febrero 3987','Particular'),(20184625789,'Omar Ortiz','Omarcito@gmail.com','3464920359','Moreno 4789','Particular'),(20210983874,'Timoteo Garello','Timoteo982@hotmail.com','3462820428','Lavalle 2394','Revendedor'),(20268394082,'Roman Benincasa','Robenin@gmail.com','3489274859','Alsina 182','Revendedor'),(20338574901,'Marcelo Toledo','Marcelo001@gmail.com','3459601234','Rioja 2934','Particular'),(20388747749,'Walter Funez','WalterFunez@gmail.com','3458201084','Rodriguez 2034','Revendedor'),(20408768897,'Fabricio Derico','Fabrideri@hotmail.com','3462893048','Brown 2455','Particular'),(20433652384,'Valentin Molina','Valen@gmail.com','3464634330','San Juan 332','Particular'),(27193048788,'Juana Pieli','Juanita999@gmail.com','3459203948','Oro????????o 495','Particular'),(27193846783,'Patricia Mercanti','PatriTur@gmai.com','3448920487','Callao 3909','Revendedor'),(27200938477,'Catalina Pace','Catapace@hotmail.com','3462891099','Montevideo 2366','Particular'),(27304859672,'Antonia Ferrer','AntoFerrer@gmail.com','3405821993','San Juan 2945','Particular'),(30693156315,'Turismo Puelo','Puelotur@gmail.com','3459528930','Rioja 55 bis','Empresa de turismo'),(30707003304,'Didactica Turismo','Didactur@hotmail.com','3450359821','Santa Fe 2019','Empresa de turismo'),(30710055455,'Turismo Argentina','TuriArg@gmail.com','3456219589','Roca 4358','Empresa de turismo'),(30713487208,'Turismo Roleo','Turiroleo@gmail.com','3465689087','Sarmiento 899','Empresa de turismo'),(99999999999,'SG-1','sgc@usaf.com','+999-999999999','Cheyene Mountain 1997','Empresa de turismo');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contrata`
--

DROP TABLE IF EXISTS `contrata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contrata` (
  `nro_tour` int unsigned NOT NULL,
  `cuil_cliente` bigint unsigned NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `importe` decimal(10,3) DEFAULT NULL,
  `cant_entradas` int unsigned NOT NULL,
  `codigo_idioma` int unsigned DEFAULT NULL,
  PRIMARY KEY (`nro_tour`,`cuil_cliente`,`fecha_hora`),
  KEY `fk_contrata_cliente_idx` (`cuil_cliente`),
  KEY `fk_contrata_idioma_idx` (`codigo_idioma`),
  CONSTRAINT `fk_contrata_cliente` FOREIGN KEY (`cuil_cliente`) REFERENCES `cliente` (`cuil`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_contrata_idioma` FOREIGN KEY (`codigo_idioma`) REFERENCES `idioma` (`codigo`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_contrata_tour` FOREIGN KEY (`nro_tour`) REFERENCES `tour` (`nro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contrata`
--

LOCK TABLES `contrata` WRITE;
/*!40000 ALTER TABLE `contrata` DISABLE KEYS */;
INSERT INTO `contrata` VALUES (1,27200938477,'2022-06-30 17:32:09',6500.000,1,2),(1,27304859672,'2022-07-14 20:47:18',32500.000,5,6),(1,30693156315,'2022-06-15 09:32:56',87750.000,15,2),(1,30713487208,'2022-07-03 08:25:45',97500.000,15,2),(2,27304859672,'2022-06-24 00:10:13',22000.000,4,2),(2,30710055455,'2022-03-16 19:17:43',41250.000,10,1),(2,30713487208,'2022-05-27 13:58:40',44550.000,9,1),(3,27193846783,'2022-05-18 07:09:47',13000.000,2,5),(3,30693156315,'2022-05-10 11:23:13',143000.000,22,5),(4,30710055455,'2021-12-15 10:45:20',117000.000,15,2),(4,30713487208,'2021-11-30 09:10:32',54600.000,7,2),(5,20268394082,'2021-11-13 22:22:22',5000.000,1,2),(5,20338574901,'2021-11-15 15:49:31',10000.000,2,2),(5,20408768897,'2021-11-15 13:13:13',5000.000,1,2),(6,20338574901,'2021-07-20 19:31:57',25500.000,3,6),(6,20388747749,'2021-08-01 17:37:21',17000.000,2,2),(6,30707003304,'2021-07-22 12:03:32',187000.000,22,1),(7,30710055455,'2018-08-18 12:12:12',170500.000,31,1),(8,20388747749,'2021-09-22 18:35:30',23400.000,3,6),(8,30707003304,'2021-09-27 13:22:16',140400.000,18,6),(8,30710055455,'2021-10-03 10:18:56',296400.000,38,2),(9,20433652384,'2020-09-18 15:13:18',8500.000,1,1),(9,27193048788,'2020-09-22 16:59:56',17000.000,2,2),(9,30707003304,'2020-09-11 09:11:32',297500.000,35,2),(9,30710055455,'2020-05-30 11:13:07',140250.000,22,1),(10,20268394082,'2017-03-14 04:50:21',5500.000,1,7),(10,20433652384,'2017-03-15 11:40:54',16500.000,3,5),(10,27200938477,'2017-03-17 20:20:53',16500.000,3,2),(10,30693156315,'2016-11-29 12:25:09',144375.000,35,2),(5555,99999999999,'2022-09-12 11:30:00',1996.000,5,323232),(5757,99999999999,'2022-09-19 13:30:00',2010.000,15,333333);
/*!40000 ALTER TABLE `contrata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `costo`
--

DROP TABLE IF EXISTS `costo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `costo` (
  `codigo_locacion` int unsigned NOT NULL,
  `nro_actividad` int unsigned NOT NULL,
  `fecha_desde` date NOT NULL,
  `valor` decimal(10,3) NOT NULL,
  PRIMARY KEY (`codigo_locacion`,`nro_actividad`,`fecha_desde`),
  CONSTRAINT `fk_costo_actividad` FOREIGN KEY (`codigo_locacion`, `nro_actividad`) REFERENCES `actividad` (`codigo_locacion`, `nro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `costo`
--

LOCK TABLES `costo` WRITE;
/*!40000 ALTER TABLE `costo` DISABLE KEYS */;
INSERT INTO `costo` VALUES (3523,5,'2021-12-12',3200.000),(3523,6,'2022-07-22',5000.000),(3524,3,'2022-08-03',1200.000),(3525,4,'2022-02-12',1700.000),(3526,7,'2021-09-12',3300.000),(3526,8,'2021-09-12',4000.000),(3527,1,'2020-09-13',2700.000),(3527,1,'2021-06-22',4000.000),(3527,1,'2021-12-12',4900.000),(3527,1,'2022-03-10',5250.000),(3527,1,'2022-08-03',7000.000),(3528,2,'2022-01-22',3000.000),(3528,2,'2022-05-11',4000.000);
/*!40000 ALTER TABLE `costo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `descuento`
--

DROP TABLE IF EXISTS `descuento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `descuento` (
  `dias_anticipacion` int unsigned NOT NULL,
  `porcentaje_descuento` decimal(10,3) NOT NULL,
  PRIMARY KEY (`dias_anticipacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `descuento`
--

LOCK TABLES `descuento` WRITE;
/*!40000 ALTER TABLE `descuento` DISABLE KEYS */;
INSERT INTO `descuento` VALUES (30,10.000),(90,25.000);
/*!40000 ALTER TABLE `descuento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleado`
--

DROP TABLE IF EXISTS `empleado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleado` (
  `cuil` bigint unsigned NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `telefono` varchar(45) DEFAULT NULL,
  `categoria` varchar(255) NOT NULL,
  `tipo` varchar(255) NOT NULL,
  PRIMARY KEY (`cuil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleado`
--

LOCK TABLES `empleado` WRITE;
/*!40000 ALTER TABLE `empleado` DISABLE KEYS */;
INSERT INTO `empleado` VALUES (20387642839,'Miguel','Sosa','346578992','Sr','Encargado'),(20412430982,'Javier','Gomez','341567874','Jr','Guia'),(20448765928,'Roberto','Ruiz','346483920','Trainee','Guia'),(27384578941,'Fernanda','Torres','346489019','Sr','Encargado'),(27395068782,'Sol','Gomez','347589023','Ssr','Encargado'),(27421498784,'Maria','Diaz','342987264','Ssr','Guia'),(86868686868,'Gon','Freeks','+868-686868686','hunter','guia'),(87878787878,'Inosuke','Hashibira','+878-787878787','kouhai','guia'),(88888888888,'Erwin','Smith','+888-888888888','comander','encargado'),(89898989898,'Bertolt','Hoover','+898-898989898','traitor','encargado');
/*!40000 ALTER TABLE `empleado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escala`
--

DROP TABLE IF EXISTS `escala`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `escala` (
  `nro_tour` int unsigned NOT NULL,
  `fecha_hora_ini` datetime NOT NULL,
  `fecha_hora_fin` datetime NOT NULL,
  `codigo_locacion` int unsigned NOT NULL,
  `nro_actividad` int unsigned NOT NULL,
  `cuil_encargado` bigint unsigned NOT NULL,
  PRIMARY KEY (`nro_tour`,`fecha_hora_ini`),
  KEY `fk_escala_actividad_idx` (`codigo_locacion`,`nro_actividad`),
  KEY `fk_escala_ecnargado_idx` (`cuil_encargado`),
  CONSTRAINT `fk_escala_actividad` FOREIGN KEY (`codigo_locacion`, `nro_actividad`) REFERENCES `actividad` (`codigo_locacion`, `nro`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_escala_ecnargado` FOREIGN KEY (`cuil_encargado`) REFERENCES `empleado` (`cuil`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_escala_tour` FOREIGN KEY (`nro_tour`) REFERENCES `tour` (`nro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escala`
--

LOCK TABLES `escala` WRITE;
/*!40000 ALTER TABLE `escala` DISABLE KEYS */;
INSERT INTO `escala` VALUES (2,'2018-09-03 09:00:00','2018-09-03 12:00:00',3528,2,27384578941),(2,'2022-06-27 09:00:00','2022-06-28 12:00:00',3528,2,27395068782),(3,'2022-05-30 08:30:00','2022-02-12 12:30:00',3527,1,27395068782),(5,'2021-11-29 12:00:00','2021-11-30 15:30:00',3524,3,27384578941),(6,'2019-08-05 16:30:00','2019-08-05 21:30:00',3523,6,20387642839),(8,'2021-10-10 17:00:00','2021-10-10 21:00:00',3523,6,20387642839),(9,'2020-09-30 16:30:00','2020-09-30 21:30:00',3526,7,27395068782),(9,'2022-07-15 12:00:00','2022-07-15 15:00:00',3526,7,20387642839),(10,'2017-03-27 09:00:00','2017-03-27 09:00:00',3527,1,27395068782),(11,'2022-09-12 12:00:00','2022-09-13 15:00:00',3524,3,27384578941),(5555,'2022-10-28 09:00:00','2022-10-28 14:30:00',404040,111,88888888888),(5555,'2022-10-28 15:00:00','2022-10-28 16:00:00',414141,333,88888888888),(5757,'2022-10-29 09:30:00','2022-10-29 14:00:00',414141,222,88888888888),(5858,'2023-01-04 13:00:00','2023-01-04 18:30:00',404040,111,89898989898);
/*!40000 ALTER TABLE `escala` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `idioma`
--

DROP TABLE IF EXISTS `idioma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `idioma` (
  `codigo` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=333334 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `idioma`
--

LOCK TABLES `idioma` WRITE;
/*!40000 ALTER TABLE `idioma` DISABLE KEYS */;
INSERT INTO `idioma` VALUES (1,'Ingles'),(2,'Espanol'),(3,'Frances'),(4,'Aleman'),(5,'Ruso'),(6,'Italiano'),(7,'Chino'),(303030,'Ingles'),(313131,'Frances'),(323232,'Japones'),(333333,'Aleman');
/*!40000 ALTER TABLE `idioma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `idioma_guia`
--

DROP TABLE IF EXISTS `idioma_guia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `idioma_guia` (
  `cuil_guia` bigint unsigned NOT NULL,
  `codigo_idioma` int unsigned NOT NULL,
  PRIMARY KEY (`cuil_guia`,`codigo_idioma`),
  KEY `fk_idioma_guia_idioma_idx` (`codigo_idioma`),
  CONSTRAINT `fk_idioma_guia_empleado` FOREIGN KEY (`cuil_guia`) REFERENCES `empleado` (`cuil`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_idioma_guia_idioma` FOREIGN KEY (`codigo_idioma`) REFERENCES `idioma` (`codigo`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `idioma_guia`
--

LOCK TABLES `idioma_guia` WRITE;
/*!40000 ALTER TABLE `idioma_guia` DISABLE KEYS */;
INSERT INTO `idioma_guia` VALUES (20412430982,1),(20448765928,1),(27421498784,1),(20412430982,2),(20448765928,2),(27421498784,2),(27421498784,5),(20412430982,6),(27421498784,7);
/*!40000 ALTER TABLE `idioma_guia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locacion`
--

DROP TABLE IF EXISTS `locacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locacion` (
  `codigo` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `ambientacion` varchar(255) NOT NULL,
  `ubicacion_gps` point DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=414142 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locacion`
--

LOCK TABLES `locacion` WRITE;
/*!40000 ALTER TABLE `locacion` DISABLE KEYS */;
INSERT INTO `locacion` VALUES (3523,'Edificio Molteni','Star Wars',NULL,'Salta 1200'),(3524,'Universidad Tecnologica Nacional','Shingeki no Kyojin',NULL,'Zeballos 1352'),(3525,'Casona Yiro','LFN',NULL,'Salta 1200'),(3526,'Parque Urquiza','Indiana Jones',NULL,'Av Pellegrini 200'),(3527,'Universidad Tecnologica Nacional','Breaking Bad',NULL,'Zeballos 1352'),(3528,'Facultad de Derecho','Better Call Saul',NULL,'C????rdoba 2020'),(3529,'Plaza Sarmiento','Pokemon',NULL,'San Juan 1335'),(3530,'Edificio Molteni','Star Wars',NULL,'Salta 1200'),(3531,'Centro Cultural Nestor Kirchner','D&D',NULL,'Sarmiento 151');
/*!40000 ALTER TABLE `locacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salario_hora`
--

DROP TABLE IF EXISTS `salario_hora`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salario_hora` (
  `cuil_empleado` bigint unsigned NOT NULL,
  `fecha_desde` date NOT NULL,
  `valor` decimal(10,3) NOT NULL,
  PRIMARY KEY (`cuil_empleado`,`fecha_desde`),
  CONSTRAINT `fk_salario_hora_empleado` FOREIGN KEY (`cuil_empleado`) REFERENCES `empleado` (`cuil`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salario_hora`
--

LOCK TABLES `salario_hora` WRITE;
/*!40000 ALTER TABLE `salario_hora` DISABLE KEYS */;
INSERT INTO `salario_hora` VALUES (20387642839,'2022-05-12',75000.000),(20412430982,'2021-07-31',65000.000),(20412430982,'2021-10-03',60000.000),(27384578941,'2022-12-12',85000.000),(27395068782,'2022-12-12',85000.000),(27421498784,'2022-06-06',80000.000);
/*!40000 ALTER TABLE `salario_hora` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tour`
--

DROP TABLE IF EXISTS `tour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tour` (
  `nro` int unsigned NOT NULL,
  `fecha_hora_salida` datetime NOT NULL,
  `fecha_hora_regreso` datetime NOT NULL,
  `lugar_salida` varchar(255) NOT NULL,
  `precio_unitario_sugerido` decimal(10,3) NOT NULL,
  `vehiculo` varchar(255) DEFAULT NULL,
  `tematica` varchar(255) NOT NULL,
  `cuil_guia` bigint unsigned NOT NULL,
  PRIMARY KEY (`nro`),
  KEY `fk_tour_empleado_idx` (`cuil_guia`),
  CONSTRAINT `fk_tour_empleado` FOREIGN KEY (`cuil_guia`) REFERENCES `empleado` (`cuil`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tour`
--

LOCK TABLES `tour` WRITE;
/*!40000 ALTER TABLE `tour` DISABLE KEYS */;
INSERT INTO `tour` VALUES (1,'2022-07-27 08:30:00','2022-07-27 12:30:00','Centro, Rosario,Santa F??',6500.000,'','D&D',20412430982),(2,'2022-06-27 09:00:00','2022-06-28 12:00:00','Centro, Rosario,Santa F??',5500.000,'Volkswagen Vento','BCS',20448765928),(3,'2022-05-30 08:30:00','2022-05-30 12:30:00','Centro, Rosario,Santa F??',6500.000,'Fleetwood Bounder RV 1986','BB',27421498784),(4,'2021-12-18 17:00:00','2021-12-18 21:00:00','Centro, Rosario,Santa F??',7800.000,'','Star Wars',20448765928),(5,'2021-11-29 12:00:00','2021-11-30 15:30:00','Centro, Rosario,Santa F??',5000.000,'Subaru Leone 1986','Shingeki no Kyojin',20448765928),(6,'2019-08-05 16:30:00','2019-08-05 21:30:00','Centro, Rosario,Santa F??',8500.000,'','Star Wars',20412430982),(7,'2018-09-03 09:00:00','2018-09-03 12:00:00','Centro, Rosario,Santa F??',5500.000,'Subaru Leone 1986','BCS',20412430982),(8,'2021-10-10 17:00:00','2021-10-10 21:00:00','Centro, Rosario,Santa F??',7800.000,'','Star Wars',20412430982),(9,'2020-09-30 16:30:00','2020-09-30 21:30:00','Centro, Rosario,Santa F??',8500.000,'','Indiana Jones',27421498784),(10,'2017-03-27 09:00:00','2017-03-27 09:00:00','Centro, Rosario,Santa F??',5500.000,'Pontiac Aztek 2005','BB',27421498784),(11,'2022-09-12 12:00:00','2022-09-13 15:00:00','Centro, Rosario,Santa F??',4500.000,'Subaru Leone','Shingeki no Kyojin',27421498784),(12,'2022-09-21 10:00:00','2022-09-21 14:30:00','Centro, Rosario,Santa F??',5000.000,'Land Rover Discovery','LFN',27421498784),(5555,'2022-10-27 10:00:00','2022-10-30 19:00:00','Tropical Land Park',1996.000,'Coaster','SNK',87878787878),(5656,'2022-11-03 11:00:00','2022-11-07 15:00:00','Whale Island',1998.000,'Kaijinmaru','Hunter X',86868686868),(5757,'2022-11-07 10:30:00','2022-11-13 17:30:00','Resembool',2001.000,'Mustang','SNK',87878787878),(5858,'2023-01-03 11:20:00','2022-01-07 12:00:00','Harvard',2008.000,'Lincoln','SNK',86868686868);
/*!40000 ALTER TABLE `tour` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-28 10:47:36
