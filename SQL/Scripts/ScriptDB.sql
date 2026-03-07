-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: api_crud_taller
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

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
-- Table structure for table `api_users`
--

DROP TABLE IF EXISTS `api_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_users` (
  `Api_user_id` int NOT NULL AUTO_INCREMENT,
  `Api_user` varchar(60) DEFAULT NULL,
  `Api_password` varchar(255) DEFAULT NULL,
  `Api_role` enum('Admin','Read-only') DEFAULT NULL,
  `Api_status` enum('Active','Inactive') DEFAULT NULL,
  `Created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `api_token` char(64) NOT NULL,
  PRIMARY KEY (`Api_user_id`),
  UNIQUE KEY `uq_api_users_token` (`api_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_users`
--

LOCK TABLES `api_users` WRITE;
/*!40000 ALTER TABLE `api_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `country_id` int unsigned NOT NULL AUTO_INCREMENT,
  `country_name` varchar(100) NOT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE KEY `uq_countries_name` (`country_name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (4,'Argentina'),(12,'Bolivia'),(9,'Brasil'),(5,'Chile'),(1,'Colombia'),(13,'Costa Rica'),(7,'Ecuador'),(3,'España'),(15,'Guatemala'),(2,'México'),(14,'Panamá'),(11,'Paraguay'),(6,'Perú'),(10,'Uruguay'),(8,'Venezuela');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_logs`
--

DROP TABLE IF EXISTS `login_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_logs` (
  `log_id` int unsigned NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `User_fk` int unsigned NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `fk_login_logs_user` (`User_fk`),
  CONSTRAINT `fk_login_logs_user` FOREIGN KEY (`User_fk`) REFERENCES `users` (`User_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_logs`
--

LOCK TABLES `login_logs` WRITE;
/*!40000 ALTER TABLE `login_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modules`
--

DROP TABLE IF EXISTS `modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modules` (
  `Modules_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Modules_name` varchar(30) DEFAULT NULL,
  `Modules_description` varchar(300) DEFAULT NULL,
  `Modules_route` varchar(80) DEFAULT NULL,
  `Modules_icon` varchar(30) DEFAULT NULL,
  `Modules_submodule` tinyint DEFAULT NULL,
  `Modules_parent_module` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Modules_id`),
  KEY `fk_modules_parent` (`Modules_parent_module`),
  CONSTRAINT `fk_modules_parent` FOREIGN KEY (`Modules_parent_module`) REFERENCES `modules` (`Modules_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modules`
--

LOCK TABLES `modules` WRITE;
/*!40000 ALTER TABLE `modules` DISABLE KEYS */;
INSERT INTO `modules` VALUES (1,'Dashboard','Panel principal','/dashboard','home',0,NULL,'2026-03-07 03:35:05','2026-03-07 03:35:05'),(2,'Ventas','Gestión de ventas','/ventas','cart',0,NULL,'2026-03-07 03:35:05','2026-03-07 03:35:05'),(3,'Inventario','Control de inventario','/inventario','box',0,NULL,'2026-03-07 03:35:05','2026-03-07 03:35:05'),(4,'RRHH','Recursos humanos','/rrhh','people',0,NULL,'2026-03-07 03:35:05','2026-03-07 03:35:05'),(5,'Configuración','Configuración del sistema','/config','settings',0,NULL,'2026-03-07 03:35:05','2026-03-07 03:35:05');
/*!40000 ALTER TABLE `modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profiles` (
  `Profile_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Profile_name` varchar(30) DEFAULT NULL,
  `Profile_photo` varchar(255) DEFAULT NULL,
  `User_id_fk` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `country_fk` int unsigned DEFAULT NULL,
  `profile_bio` text,
  PRIMARY KEY (`Profile_id`),
  KEY `User_id_fk` (`User_id_fk`),
  KEY `fk_profiles_country` (`country_fk`),
  CONSTRAINT `fk_profiles_country` FOREIGN KEY (`country_fk`) REFERENCES `countries` (`country_id`),
  CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`User_id_fk`) REFERENCES `users` (`User_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (1,'Super Admin','photos/superadmin.jpg',1,'2026-03-07 03:33:57','2026-03-07 03:33:57',1,'Administrador principal del sistema.'),(2,'John Pérez','photos/john.jpg',2,'2026-03-07 03:33:57','2026-03-07 03:33:57',1,'Administrador con 5 años de experiencia.'),(3,'Ana Gómez','photos/ana.jpg',3,'2026-03-07 03:33:57','2026-03-07 03:33:57',2,'Auditora certificada en seguridad.'),(4,'Luis Torres','photos/luis.jpg',4,'2026-03-07 03:33:57','2026-03-07 03:33:57',3,'Ejecutivo de ventas región norte.'),(5,'María Ruiz','photos/mar.jpg',5,'2026-03-07 03:33:57','2026-03-07 03:33:57',4,'Especialista en soporte técnico.'),(6,'Carlos Mora','photos/carlos.jpg',6,'2026-03-07 03:33:57','2026-03-07 03:33:57',5,'Moderador de contenido y comunidad.'),(7,'Sofía Vargas','photos/sofia.jpg',7,'2026-03-07 03:33:57','2026-03-07 03:33:57',6,'Editora de contenidos digitales.'),(8,'Pedro Díaz','photos/pedro.jpg',8,'2026-03-07 03:33:57','2026-03-07 03:33:57',7,'Analista de datos y reportes.'),(9,'Laura Méndez','photos/laura.jpg',9,'2026-03-07 03:33:57','2026-03-07 03:33:57',8,'Desarrolladora fullstack.'),(10,'Miguel Castro','photos/miguel.jpg',10,'2026-03-07 03:33:57','2026-03-07 03:33:57',9,'Contador con enfoque en finanzas digitales.'),(11,'Diana Flores','photos/diana.jpg',11,'2026-03-07 03:33:57','2026-03-07 03:33:57',10,'Gestora de recursos humanos.'),(12,'Roberto Silva','photos/roberto.jpg',12,'2026-03-07 03:33:57','2026-03-07 03:33:57',11,'Especialista en marketing digital.'),(13,'Carmen López','photos/carmen.jpg',13,'2026-03-07 03:33:57','2026-03-07 03:33:57',12,'Coordinadora de logística.'),(14,'Jorge Ramírez','photos/jorge.jpg',14,'2026-03-07 03:33:57','2026-03-07 03:33:57',13,'Supervisor de operaciones.'),(15,'María Invitada','photos/maria.jpg',15,'2026-03-07 03:33:57','2026-03-07 03:33:57',14,'Usuario invitado con acceso limitado.'),(16,'Nuevo Usuario','photos/nuevo.jpg',16,'2026-03-07 04:43:41','2026-03-07 04:43:41',1,'Bio del usuario.');
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_modules`
--

DROP TABLE IF EXISTS `role_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_modules` (
  `RoleModules_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Modules_fk` int unsigned DEFAULT NULL,
  `Roles_fk` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`RoleModules_id`),
  KEY `Modules_fk` (`Modules_fk`),
  KEY `Roles_fk` (`Roles_fk`),
  CONSTRAINT `role_modules_ibfk_1` FOREIGN KEY (`Modules_fk`) REFERENCES `modules` (`Modules_id`),
  CONSTRAINT `role_modules_ibfk_2` FOREIGN KEY (`Roles_fk`) REFERENCES `roles` (`Roles_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_modules`
--

LOCK TABLES `role_modules` WRITE;
/*!40000 ALTER TABLE `role_modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `role_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `Roles_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Roles_name` varchar(30) NOT NULL,
  `Roles_description` varchar(300) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Roles_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'SuperAdmin','Acceso total sin restricciones','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(2,'Admin','Administrador general del sistema','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(3,'Auditor','Revisión y control de operaciones','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(4,'Ventas','Gestión de ventas y clientes','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(5,'Soporte','Atención y soporte técnico','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(6,'Moderador','Moderación de contenido','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(7,'Editor','Creación y edición de contenido','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(8,'Analista','Análisis de datos y reportes','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(9,'Desarrollador','Desarrollo y mantenimiento','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(10,'Contador','Gestión financiera y contable','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(11,'RRHH','Gestión de recursos humanos','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(12,'Marketing','Estrategias de mercadeo','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(13,'Logística','Coordinación de operaciones','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(14,'Supervisor','Supervisión de equipos','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL),(15,'Invitado','Acceso limitado de solo lectura','2026-03-07 03:28:15','2026-03-07 03:28:15',NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status_catalog`
--

DROP TABLE IF EXISTS `status_catalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_catalog` (
  `User_status_id` int unsigned NOT NULL AUTO_INCREMENT,
  `User_status_name` varchar(30) NOT NULL,
  `User_status_description` varchar(300) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`User_status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status_catalog`
--

LOCK TABLES `status_catalog` WRITE;
/*!40000 ALTER TABLE `status_catalog` DISABLE KEYS */;
INSERT INTO `status_catalog` VALUES (1,'Activo','Usuario con acceso completo al sistema','2026-03-07 03:26:32','2026-03-07 03:26:32'),(2,'Inactivo','Usuario sin actividad reciente','2026-03-07 03:26:32','2026-03-07 03:26:32'),(3,'Bloqueado','Usuario bloqueado por seguridad','2026-03-07 03:26:32','2026-03-07 03:26:32'),(4,'Pendiente','Usuario pendiente de aprobación','2026-03-07 03:26:32','2026-03-07 03:26:32'),(5,'Suspendido','Usuario suspendido temporalmente','2026-03-07 03:26:32','2026-03-07 03:26:32'),(6,'En revisión','Usuario en proceso de verificación','2026-03-07 03:26:32','2026-03-07 03:26:32'),(7,'Eliminado','Usuario eliminado lógicamente','2026-03-07 03:26:32','2026-03-07 03:26:32'),(8,'Sin verificar','Usuario sin confirmar correo','2026-03-07 03:26:32','2026-03-07 03:26:32'),(9,'Verificado','Usuario con correo confirmado','2026-03-07 03:26:32','2026-03-07 03:26:32'),(10,'Expirado','Sesión o cuenta expirada','2026-03-07 03:26:32','2026-03-07 03:26:32'),(11,'En espera','Usuario en lista de espera','2026-03-07 03:26:32','2026-03-07 03:26:32'),(12,'Rechazado','Solicitud de acceso rechazada','2026-03-07 03:26:32','2026-03-07 03:26:32'),(13,'Aprobado','Usuario aprobado por administrador','2026-03-07 03:26:32','2026-03-07 03:26:32'),(14,'Archivado','Usuario archivado sin acceso','2026-03-07 03:26:32','2026-03-07 03:26:32'),(15,'Temporal','Usuario con acceso temporal','2026-03-07 03:26:32','2026-03-07 03:26:32');
/*!40000 ALTER TABLE `status_catalog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `User_id` int unsigned NOT NULL AUTO_INCREMENT,
  `User_user` varchar(255) NOT NULL,
  `User_email` varchar(256) NOT NULL,
  `User_password` varchar(255) NOT NULL,
  `Roles_fk` int unsigned DEFAULT NULL,
  `User_status_fk` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_verified` tinyint(1) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`User_id`),
  UNIQUE KEY `uq_users_user_user` (`User_user`),
  KEY `Roles_fk` (`Roles_fk`),
  KEY `User_status_fk` (`User_status_fk`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`Roles_fk`) REFERENCES `roles` (`Roles_id`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`User_status_fk`) REFERENCES `status_catalog` (`User_status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'superadmin','superadmin@mail.com','e495c8e1d6723467c5c840b71744533eae94e9ca4b68823178e8a2df150f1121',1,1,'2026-03-07 03:33:32','2026-03-07 03:33:32',1,NULL),(2,'admin_john','john@mail.com','9c0cdeb1dad83648e3674bc4835a65a6e398ae4b5bee7c72cd3e68e5b7ccbe47',2,1,'2026-03-07 03:33:32','2026-03-07 03:33:32',1,NULL),(3,'auditor_ana','ana@mail.com','31e0377d72256fa00da681f58bdc01778989cc7855f159cdc03841d3e37760d2',3,1,'2026-03-07 03:33:32','2026-03-07 03:33:32',1,NULL),(4,'ventas_luis','luis@mail.com','0a8f421b8c7c448ac9591487670488491b963573d4292e72dc96d477752a3665',4,1,'2026-03-07 03:33:32','2026-03-07 03:33:32',1,NULL),(5,'soporte_mar','mar@mail.com','42fc98b7d2c8537ace34d207a389fd149be0809913f1fd90c8d356eb392a3ccb',5,2,'2026-03-07 03:33:32','2026-03-07 03:33:32',0,NULL),(6,'mod_carlos','carlos@mail.com','70dbe3bf25b7e5442988012e0b2d31c919baa208b73bf9d4a3b4c4489f46bd01',6,1,'2026-03-07 03:33:32','2026-03-07 03:33:32',1,NULL),(7,'editor_sofia','sofia@mail.com','4885c3e2969f513158d8a161bf95be6d293df67e695fab9ec5a906ed144517d7',7,3,'2026-03-07 03:33:32','2026-03-07 03:33:32',0,NULL),(8,'analista_pedro','pedro@mail.com','40bd682b462ca6dcebd6f45ae04dcc287fedf10fdd4e3558f7aa842f8249373a',8,1,'2026-03-07 03:33:32','2026-03-07 03:33:32',1,NULL),(9,'dev_laura','laura@mail.com','d8cb9ab2dc74fd7c592909084a364b6fd2243427633f06456f6317237d374c88',9,4,'2026-03-07 03:33:32','2026-03-07 03:33:32',0,NULL),(10,'cont_miguel','miguel@mail.com','d8e935eb1eafecd0d66463861b067dfc6e098cca210bcc615a0b71d0939bd662',10,1,'2026-03-07 03:33:32','2026-03-07 03:33:32',1,NULL),(11,'rrhh_diana','diana@mail.com','e107c6c1dc4110d5a24e5f0e6fe0308f1156b0aa26837a80f3221997a7f187e5',11,5,'2026-03-07 03:33:32','2026-03-07 03:33:32',1,NULL),(12,'mkt_roberto','roberto@mail.com','1c6b4f2278067b875faa584b186908eb8c93289fbcb1ae3b057f66fc3c48853a',12,1,'2026-03-07 03:33:32','2026-03-07 03:33:32',0,NULL),(13,'log_carmen','carmen@mail.com','c4784f5f6210bd6e79d2193d482e84ddc28d5e5cd4903e99ec2fd83bddef9c8b',13,3,'2026-03-07 03:33:32','2026-03-07 03:33:32',1,NULL),(14,'sup_jorge','jorge@mail.com','b2dc644fb6abbbf84d02da443d96f396c685a0f2592ffdbef6fc85dbf1badebf',14,1,'2026-03-07 03:33:32','2026-03-07 03:33:32',1,NULL),(15,'guest_maria','maria@mail.com','cc4718e76e5206265e5fbddeac7dcff655d41f7cce76bfa8f0ee3677660e78da',15,8,'2026-03-07 03:33:32','2026-03-07 03:33:32',0,NULL),(16,'nuevo_user','nuevo@mail.com','ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',2,1,'2026-03-07 04:43:41','2026-03-07 04:43:41',0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_active_admins`
--

DROP TABLE IF EXISTS `vw_active_admins`;
/*!50001 DROP VIEW IF EXISTS `vw_active_admins`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_active_admins` AS SELECT 
 1 AS `User_id`,
 1 AS `Usuario`,
 1 AS `Email`,
 1 AS `Rol`,
 1 AS `Estado`,
 1 AS `Verificado`,
 1 AS `Fecha registro`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_active_admins`
--

/*!50001 DROP VIEW IF EXISTS `vw_active_admins`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`kevinsrdev`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_active_admins` AS select `users`.`User_id` AS `User_id`,`users`.`User_user` AS `Usuario`,`users`.`User_email` AS `Email`,`roles`.`Roles_name` AS `Rol`,`status_catalog`.`User_status_name` AS `Estado`,`users`.`is_verified` AS `Verificado`,`users`.`created_at` AS `Fecha registro` from ((`users` join `roles` on((`users`.`Roles_fk` = `roles`.`Roles_id`))) join `status_catalog` on((`users`.`User_status_fk` = `status_catalog`.`User_status_id`))) where ((`roles`.`Roles_name` = 'Admin') and (`status_catalog`.`User_status_name` = 'Activo')) */;
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

-- Dump completed on 2026-03-07 10:28:58
