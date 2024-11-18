-- MySQL dump 10.13  Distrib 9.0.1, for macos14.4 (x86_64)
--
-- Host: localhost    Database: dbname
-- ------------------------------------------------------
-- Server version	8.2.0

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
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Admin`
--

LOCK TABLES `Admin` WRITE;
/*!40000 ALTER TABLE `Admin` DISABLE KEYS */;
INSERT INTO `Admin` VALUES (1,'Maria FD. Gomes','password%100','fatima.d.gomes@azores.gov.pt','2024-09-25 14:33:50','2024-09-25 14:33:50'),(2,'Daniela MBA. Gomes','password%100','daniela.mb.gomes@azores.gov.pt','2024-09-25 14:33:50','2024-09-25 14:33:50'),(3,'Rafael B. Pereira','scrypt:32768:8:1$JzPdfqhk2ZfUTWSE$ae2f53902aa761734619bd53993cc23d543fd67267aeaca4cc6457c10d5920b46505805d90bafba9e49cdbe6ce507e2372bbd95b86e357eb79c9d0b9a686cede','rafael.b.pereira@azores.gov.pt','2024-09-25 14:33:50','2024-09-25 15:31:44');
/*!40000 ALTER TABLE `Admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Bolsa`
--

DROP TABLE IF EXISTS `Bolsa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Bolsa` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bolsa`
--

LOCK TABLES `Bolsa` WRITE;
/*!40000 ALTER TABLE `Bolsa` DISABLE KEYS */;
INSERT INTO `Bolsa` VALUES (1,'Bolsa de Ilha São Miguel'),(2,'Bolsa de Ilha Terceira'),(3,'Bolsa de Ilha Santa Maria'),(4,'Bolsa de Ilha Faial'),(5,'Bolsa de Ilha Pico'),(6,'Bolsa de Ilha São Jorge'),(7,'Bolsa de Ilha Graciosa'),(8,'Bolsa de Ilha Flores'),(9,'Bolsa de Ilha Corvo');
/*!40000 ALTER TABLE `Bolsa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Bolsa_Escola`
--

DROP TABLE IF EXISTS `Bolsa_Escola`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Bolsa_Escola` (
  `bolsa_id` int NOT NULL,
  `escola_id` int NOT NULL,
  PRIMARY KEY (`bolsa_id`,`escola_id`),
  KEY `escola_id` (`escola_id`),
  CONSTRAINT `bolsa_escola_ibfk_1` FOREIGN KEY (`bolsa_id`) REFERENCES `Bolsa` (`id`),
  CONSTRAINT `bolsa_escola_ibfk_2` FOREIGN KEY (`escola_id`) REFERENCES `Escola` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bolsa_Escola`
--

LOCK TABLES `Bolsa_Escola` WRITE;
/*!40000 ALTER TABLE `Bolsa_Escola` DISABLE KEYS */;
INSERT INTO `Bolsa_Escola` VALUES (1,43),(1,44),(1,45),(1,46),(1,47),(1,48),(1,49),(1,50),(1,51),(1,52),(1,53),(1,54),(1,55),(1,56),(1,57),(1,58),(1,59),(1,60),(1,61),(1,63),(2,64),(2,65),(2,66),(2,67),(2,68),(2,69),(2,70),(3,71),(4,72),(4,73),(5,74),(5,75),(5,76),(6,77),(6,78),(6,79),(7,80),(8,81),(9,83);
/*!40000 ALTER TABLE `Bolsa_Escola` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colocados`
--

DROP TABLE IF EXISTS `colocados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `colocados` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `bolsa_id` int NOT NULL,
  `escola_nome` varchar(255) NOT NULL,
  `contrato_id` int NOT NULL,
  `escola_priority_id` int NOT NULL,
  `placement_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `bolsa_id` (`bolsa_id`),
  KEY `contrato_id` (`contrato_id`),
  CONSTRAINT `colocados_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`),
  CONSTRAINT `colocados_ibfk_2` FOREIGN KEY (`bolsa_id`) REFERENCES `userbolsas` (`Bolsa_id`),
  CONSTRAINT `colocados_ibfk_3` FOREIGN KEY (`contrato_id`) REFERENCES `contrato` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=976 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colocados`
--

LOCK TABLES `colocados` WRITE;
/*!40000 ALTER TABLE `colocados` DISABLE KEYS */;
/*!40000 ALTER TABLE `colocados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contrato`
--

DROP TABLE IF EXISTS `contrato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contrato` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo` enum('indeterminado','termo resolutivo','ambos') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contrato`
--

LOCK TABLES `contrato` WRITE;
/*!40000 ALTER TABLE `contrato` DISABLE KEYS */;
INSERT INTO `contrato` VALUES (1,'indeterminado'),(2,'termo resolutivo'),(3,'ambos');
/*!40000 ALTER TABLE `contrato` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `upload_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (22,41,'Formulario_Candidatura (1).pdf','2024-10-10 10:04:38');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Escola`
--

DROP TABLE IF EXISTS `Escola`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Escola` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Escola`
--

LOCK TABLES `Escola` WRITE;
/*!40000 ALTER TABLE `Escola` DISABLE KEYS */;
INSERT INTO `Escola` VALUES (43,'EBS NORDESTE'),(44,'EBI DA RIBEIRA GRANDE'),(45,'EBI DA MAIA'),(46,'EBI DE VILA DE CAPELAS'),(47,'ES LARANJEIRAS'),(48,'EBI DE ARRIFES'),(49,'Conservatório Regional de Ponta Delgada'),(50,'EBI ÁGUA DE PAU'),(51,'ES DA LAGOA'),(52,'ES ANTERO QUENTAL'),(53,'EBI ROBERTO IVENS'),(54,'ES DA RIBEIRA GRANDE'),(55,'EBI RABO DE PEIXE'),(56,'EBI PONTA GARÇA'),(57,'EBI DA LAGOA'),(58,'ES DOMINGOS REBELO'),(59,'EBI CANTO DA MAIA'),(60,'EBI DE GINETES'),(61,'EBS POVOAÇÃO'),(63,'EBS ARMANDO CÔRTES-RODRIGUES'),(64,'ES JERÓNIMO EMILIANO ANDRADE'),(65,'EBI DOS BISCOITOS'),(66,'ES VITORINO NEMÉSIO'),(67,'EBI DA PRAIA DA VITÓRIA'),(68,'EBS TOMÁS DE BORBA'),(69,'EBI DE ANGRA DO HEROÍSMO'),(70,'EBI FRANCISCO FERREIRA DRUMMOND'),(71,'EBS de Santa Maria'),(72,'EBI HORTA'),(73,'ES Manuel Arriaga'),(74,'EBS Lajes do Pico'),(75,'EBS S.Roque do Pico'),(76,'EBS da Madalena'),(77,'EBS das Velas'),(78,'EBS da Calheta'),(79,'EBI Topo'),(80,'EBS da Graciosa'),(81,'EBS das Flores'),(83,'EBS Mouzinho Silveira');
/*!40000 ALTER TABLE `Escola` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listas`
--

DROP TABLE IF EXISTS `listas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bolsa_id` int NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `upload_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_bolsa` (`bolsa_id`),
  CONSTRAINT `fk_bolsa` FOREIGN KEY (`bolsa_id`) REFERENCES `bolsa` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listas`
--

LOCK TABLES `listas` WRITE;
/*!40000 ALTER TABLE `listas` DISABLE KEYS */;
INSERT INTO `listas` VALUES (18,1,'teste_bolsas.pdf','2024-10-11 16:10:11');
/*!40000 ALTER TABLE `listas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `user_bolsa_data`
--

DROP TABLE IF EXISTS `user_bolsa_data`;
/*!50001 DROP VIEW IF EXISTS `user_bolsa_data`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `user_bolsa_data` AS SELECT 
 1 AS `user_name`,
 1 AS `avaliacao_curricular`,
 1 AS `prova_de_conhecimentos`,
 1 AS `nota_final`,
 1 AS `bolsa_id`,
 1 AS `escola_nome`,
 1 AS `escola_priority_id`,
 1 AS `contrato_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_escola`
--

DROP TABLE IF EXISTS `user_escola`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_escola` (
  `user_id` int NOT NULL,
  `escola_id` int NOT NULL,
  `escola_priority_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`escola_id`),
  KEY `escola_id` (`escola_id`),
  KEY `idx_user_escola_user_id` (`user_id`),
  KEY `idx_user_escola_escola_id` (`escola_id`),
  CONSTRAINT `user_escola_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`),
  CONSTRAINT `user_escola_ibfk_2` FOREIGN KEY (`escola_id`) REFERENCES `Escola` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_escola`
--

LOCK TABLES `user_escola` WRITE;
/*!40000 ALTER TABLE `user_escola` DISABLE KEYS */;
INSERT INTO `user_escola` VALUES (35,43,1),(35,44,3),(35,45,2),(35,46,4),(36,43,1),(36,44,3),(36,45,2),(36,46,4),(36,48,5),(37,43,5),(37,44,3),(37,45,4),(37,46,2),(37,48,1),(38,43,1),(38,44,3),(38,45,2),(38,46,4),(38,48,5),(39,43,2),(39,44,1),(39,45,3),(40,43,2),(40,44,4),(40,45,1),(40,46,3),(41,43,3),(41,44,1),(41,45,2),(41,46,4),(42,43,4),(42,44,3),(42,45,5),(42,46,2),(42,48,1),(43,43,2),(43,44,4),(43,45,3),(43,46,5),(43,48,1),(44,43,2),(44,44,4),(44,45,3),(44,46,5),(44,48,1),(46,43,1),(46,44,3),(46,45,2),(46,46,5),(46,47,4),(46,48,6),(47,43,1),(47,44,3),(47,45,4),(47,46,5),(47,47,2),(48,43,2),(48,44,3),(48,46,4),(48,47,1),(49,43,1),(49,44,3),(49,47,2),(50,43,1),(50,44,3),(50,45,2),(50,46,4),(50,64,5),(50,66,6),(51,47,1),(52,43,5),(52,44,7),(52,45,6),(52,46,8),(52,64,3),(52,68,1),(52,69,4),(52,70,2),(53,44,6),(53,45,4),(53,47,5),(53,64,1),(53,68,2),(53,69,3),(54,43,9),(54,44,5),(54,45,8),(54,46,6),(54,48,7),(54,64,1),(54,66,2),(54,68,3),(54,70,4),(55,43,8),(55,44,19),(55,45,9),(55,46,20),(55,47,10),(55,48,21),(55,49,11),(55,50,22),(55,51,12),(55,52,23),(55,53,13),(55,54,24),(55,55,14),(55,56,25),(55,57,16),(55,58,26),(55,59,15),(55,60,27),(55,61,17),(55,63,18),(55,64,1),(55,65,5),(55,66,2),(55,67,6),(55,68,3),(55,69,7),(55,70,4),(55,71,29),(55,72,30),(55,73,31),(55,74,32),(55,75,34),(55,76,33),(55,77,35),(55,78,37),(55,79,36),(55,80,38),(55,81,39),(55,83,41),(56,43,8),(56,44,19),(56,45,9),(56,46,20),(56,47,10),(56,48,21),(56,49,11),(56,50,22),(56,51,12),(56,52,23),(56,53,13),(56,54,24),(56,55,14),(56,56,25),(56,57,15),(56,58,26),(56,59,16),(56,60,27),(56,61,17),(56,63,18),(56,64,1),(56,65,5),(56,66,2),(56,67,6),(56,68,3),(56,69,7),(56,70,4),(56,71,29),(56,72,30),(56,73,31),(56,74,32),(56,75,34),(56,76,33),(56,77,35),(56,78,37),(56,79,36),(56,80,38),(56,81,39),(56,83,41);
/*!40000 ALTER TABLE `user_escola` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userbolsas`
--

DROP TABLE IF EXISTS `userbolsas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userbolsas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `Bolsa_id` int DEFAULT NULL,
  `contrato_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `Bolsa_id` (`Bolsa_id`),
  KEY `idx_userbolsas_user_id` (`user_id`),
  KEY `idx_userbolsas_bolsa_id` (`Bolsa_id`),
  CONSTRAINT `userbolsas_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`),
  CONSTRAINT `userbolsas_ibfk_2` FOREIGN KEY (`Bolsa_id`) REFERENCES `Bolsa` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userbolsas`
--

LOCK TABLES `userbolsas` WRITE;
/*!40000 ALTER TABLE `userbolsas` DISABLE KEYS */;
INSERT INTO `userbolsas` VALUES (41,35,1,3),(42,36,1,3),(43,37,1,3),(44,38,1,3),(45,39,1,3),(46,40,1,3),(47,41,1,3),(48,42,1,3),(49,43,1,3),(50,44,1,3),(54,46,1,3),(55,47,1,3),(56,48,1,3),(57,49,1,3),(58,50,1,3),(59,50,2,3),(60,51,1,3),(61,52,1,3),(62,52,2,3),(63,53,1,3),(64,53,2,3),(65,54,1,3),(66,54,2,3),(67,55,1,3),(68,55,2,3),(69,55,3,3),(70,55,4,3),(71,55,5,3),(72,55,6,3),(73,55,7,3),(74,55,8,3),(75,55,9,3),(76,56,1,3),(77,56,2,3),(78,56,3,3),(79,56,4,3),(80,56,5,3),(81,56,6,3),(82,56,7,3),(83,56,8,3),(84,56,9,3);
/*!40000 ALTER TABLE `userbolsas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `contacto` varchar(50) DEFAULT NULL,
  `deficiencia` varchar(255) DEFAULT NULL,
  `avaliacao_curricular` varchar(255) DEFAULT NULL,
  `prova_de_conhecimentos` varchar(255) DEFAULT NULL,
  `nota_final` decimal(5,2) DEFAULT NULL,
  `estado` enum('livre','a aguardar resposta','negado','aceite') DEFAULT NULL,
  `observacoes` text,
  `distribuicao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_users_nota_final` (`nota_final`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (35,'João Rodrigues','0910923','nao','15','15',15.00,'livre','.','https://sgc123'),(36,'António Flores','123','nao','17','14',15.50,'livre','.','https://sgc123'),(37,'Diogo Reis','000','nao','18','11',14.50,'livre','.','3'),(38,'Paula Pires','05','sim','15','11',13.00,'livre','.','https://sgc123'),(39,'Rodrigo Pires','2','nao','14','14',14.00,'livre','.','3'),(40,'Ana Melo','3','nao','15.5','12',13.75,'livre','.','3'),(41,'carlos lopes','0123','nao','14','18',16.00,'livre','.','https://sgc123'),(42,'Pedro Santos','91919','sim','12','12',12.00,'livre','.','3'),(43,'luis miguel','21','nao','12','12',13.50,'livre','.','3'),(44,'Mateus Silva','3','nao','14','14.5',14.25,'livre','nada','3'),(46,'Rita Arruda','2','nao','16','16',16.00,'livre','.','https://sgc123'),(47,'Pedro Pires','1','nao','14','15',14.50,'livre','.','https://sgc123'),(48,'Rogério','3','nao','15','12',13.50,'livre','.','https://sgc123'),(49,'Laura ','1234','nao','12','12',12.00,'livre','.','https://sgc1234'),(50,'Marta Silva','4','nao','14','14',14.00,'livre','.','https://sgc123'),(51,'Joao Jose','1234','sim','14.5','17',11.50,'livre','.','https://sgc123'),(52,'Lara Martins','1','nao','14.4','14',14.20,'livre','.','https://sgc123'),(53,'Fátima Sousa','123','nao','18','17',17.50,'livre','.','https://sgc123'),(54,'Renata Veiga','10923','nao','12','12',12.00,'livre','.','https://sgc123'),(55,'Lucio ','1092','sim','9.6','10',9.80,'livre','.','https://sgc123'),(56,'Miguel ','1092','nao','9.80','9.80',9.80,'livre','.','https://sgc123');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `user_bolsa_data`
--

/*!50001 DROP VIEW IF EXISTS `user_bolsa_data`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_bolsa_data` AS select `u`.`nome` AS `user_name`,`u`.`avaliacao_curricular` AS `avaliacao_curricular`,`u`.`prova_de_conhecimentos` AS `prova_de_conhecimentos`,`u`.`nota_final` AS `nota_final`,`ub`.`Bolsa_id` AS `bolsa_id`,`e`.`nome` AS `escola_nome`,`ue`.`escola_priority_id` AS `escola_priority_id`,`ub`.`contrato_id` AS `contrato_id` from ((((`users` `u` join `userbolsas` `ub` on((`u`.`id` = `ub`.`user_id`))) join `user_escola` `ue` on((`u`.`id` = `ue`.`user_id`))) join `escola` `e` on((`ue`.`escola_id` = `e`.`id`))) join `bolsa_escola` `be` on(((`be`.`bolsa_id` = `ub`.`Bolsa_id`) and (`be`.`escola_id` = `e`.`id`)))) order by `u`.`nome`,`ue`.`escola_priority_id` */;
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

-- Dump completed on 2024-10-28 10:03:17
