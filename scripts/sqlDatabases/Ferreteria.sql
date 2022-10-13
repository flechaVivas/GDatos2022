-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: Ferreteria
-- ------------------------------------------------------
-- Server version	8.0.29-0ubuntu0.22.04.2

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
-- Table structure for table `Categoria`
--

DROP TABLE IF EXISTS `Categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categoria` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categoria`
--

LOCK TABLES `Categoria` WRITE;
/*!40000 ALTER TABLE `Categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `Categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Localidad`
--

DROP TABLE IF EXISTS `Localidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Localidad` (
  `cod_postal` int NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `cod_provincia` int NOT NULL,
  PRIMARY KEY (`cod_postal`),
  KEY `cod_prov_idx` (`cod_provincia`),
  CONSTRAINT `cod_prov` FOREIGN KEY (`cod_provincia`) REFERENCES `Provincia` (`cod_prov`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Localidad`
--

LOCK TABLES `Localidad` WRITE;
/*!40000 ALTER TABLE `Localidad` DISABLE KEYS */;
/*!40000 ALTER TABLE `Localidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pedido`
--

DROP TABLE IF EXISTS `Pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pedido` (
  `nro_pedido` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `cuit_cliente` int unsigned NOT NULL,
  PRIMARY KEY (`nro_pedido`),
  KEY `cuit_cliente_idx` (`cuit_cliente`),
  CONSTRAINT `cuit_cliente` FOREIGN KEY (`cuit_cliente`) REFERENCES `Persona` (`cuit`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pedido`
--

LOCK TABLES `Pedido` WRITE;
/*!40000 ALTER TABLE `Pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `Pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pedido_Prod_Prov`
--

DROP TABLE IF EXISTS `Pedido_Prod_Prov`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pedido_Prod_Prov` (
  `nro_pedido` int NOT NULL,
  `id_producto` int NOT NULL,
  `cuit_prov` int unsigned DEFAULT NULL,
  `cantidad` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`nro_pedido`,`id_producto`),
  KEY `id_prod_pedido_idx` (`id_producto`),
  KEY `cuit_prov_pedido_idx` (`cuit_prov`),
  CONSTRAINT `cuit_prov_pedido` FOREIGN KEY (`cuit_prov`) REFERENCES `Producto_Proveedor` (`cuit_proveedor`),
  CONSTRAINT `id_prod_pedido` FOREIGN KEY (`id_producto`) REFERENCES `Producto_Proveedor` (`id_producto`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `nro_pedido_prod` FOREIGN KEY (`nro_pedido`) REFERENCES `Pedido` (`nro_pedido`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pedido_Prod_Prov`
--

LOCK TABLES `Pedido_Prod_Prov` WRITE;
/*!40000 ALTER TABLE `Pedido_Prod_Prov` DISABLE KEYS */;
/*!40000 ALTER TABLE `Pedido_Prod_Prov` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Persona`
--

DROP TABLE IF EXISTS `Persona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Persona` (
  `cuit` int unsigned NOT NULL,
  `razon_social` varchar(45) NOT NULL,
  `telefono` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `pagina_web` varchar(45) DEFAULT NULL,
  `calle` varchar(45) NOT NULL,
  `nro_calle` varchar(45) NOT NULL,
  `cod_postal` int NOT NULL,
  PRIMARY KEY (`cuit`),
  KEY `cod_postal_idx` (`cod_postal`),
  CONSTRAINT `cod_postal` FOREIGN KEY (`cod_postal`) REFERENCES `Localidad` (`cod_postal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Persona`
--

LOCK TABLES `Persona` WRITE;
/*!40000 ALTER TABLE `Persona` DISABLE KEYS */;
/*!40000 ALTER TABLE `Persona` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Precio`
--

DROP TABLE IF EXISTS `Precio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Precio` (
  `id_producto` int NOT NULL,
  `cuit_proveedor` int unsigned NOT NULL,
  `fecha` date NOT NULL,
  `valor` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id_producto`,`cuit_proveedor`,`fecha`),
  KEY `cuit_prov_idx` (`cuit_proveedor`),
  KEY `cuit_prod_prov_idx` (`cuit_proveedor`),
  CONSTRAINT `cuit_prod_prov` FOREIGN KEY (`cuit_proveedor`) REFERENCES `Producto_Proveedor` (`cuit_proveedor`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `id_prod_prov` FOREIGN KEY (`id_producto`) REFERENCES `Producto_Proveedor` (`id_producto`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Precio`
--

LOCK TABLES `Precio` WRITE;
/*!40000 ALTER TABLE `Precio` DISABLE KEYS */;
/*!40000 ALTER TABLE `Precio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Producto`
--

DROP TABLE IF EXISTS `Producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Producto` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) NOT NULL,
  `stock` decimal(10,0) DEFAULT NULL,
  `id_categoria` int NOT NULL,
  PRIMARY KEY (`id_producto`),
  KEY `id_categoria_idx` (`id_categoria`),
  CONSTRAINT `id_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `Categoria` (`id_categoria`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Producto`
--

LOCK TABLES `Producto` WRITE;
/*!40000 ALTER TABLE `Producto` DISABLE KEYS */;
/*!40000 ALTER TABLE `Producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Producto_Proveedor`
--

DROP TABLE IF EXISTS `Producto_Proveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Producto_Proveedor` (
  `id_producto` int NOT NULL,
  `cuit_proveedor` int unsigned NOT NULL,
  PRIMARY KEY (`id_producto`,`cuit_proveedor`),
  KEY `cuit_proveedor_idx` (`cuit_proveedor`),
  CONSTRAINT `cuit_prov` FOREIGN KEY (`cuit_proveedor`) REFERENCES `Persona` (`cuit`) ON UPDATE RESTRICT,
  CONSTRAINT `id_producto_prov` FOREIGN KEY (`id_producto`) REFERENCES `Producto` (`id_producto`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Producto_Proveedor`
--

LOCK TABLES `Producto_Proveedor` WRITE;
/*!40000 ALTER TABLE `Producto_Proveedor` DISABLE KEYS */;
/*!40000 ALTER TABLE `Producto_Proveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Provincia`
--

DROP TABLE IF EXISTS `Provincia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Provincia` (
  `cod_prov` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`cod_prov`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Provincia`
--

LOCK TABLES `Provincia` WRITE;
/*!40000 ALTER TABLE `Provincia` DISABLE KEYS */;
/*!40000 ALTER TABLE `Provincia` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-29 20:35:33
