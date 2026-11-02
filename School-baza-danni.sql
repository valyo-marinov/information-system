-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия на сървъра:            8.4.3 - MySQL Community Server - GPL
-- ОС на сървъра:                Win64
-- HeidiSQL Версия:              12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Дъмп на структурата на БД school_hrms
CREATE DATABASE IF NOT EXISTS `school_hrms` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `school_hrms`;

-- Дъмп структура за таблица school_hrms.attendance_records
CREATE TABLE IF NOT EXISTS `attendance_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `date` date NOT NULL,
  `check_in` time DEFAULT NULL,
  `check_out` time DEFAULT NULL,
  `status` enum('OFFICE','REMOTE','ABSENT','LATE') DEFAULT 'OFFICE',
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `attendance_records_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.attendance_records: ~4 rows (приблизителен брой)
INSERT INTO `attendance_records` (`id`, `employee_id`, `date`, `check_in`, `check_out`, `status`) VALUES
	(1, 1, '2026-10-19', '07:45:00', '16:00:00', 'OFFICE'),
	(2, 2, '2026-10-19', '08:00:00', '14:30:00', 'OFFICE'),
	(3, 3, '2026-10-19', '07:50:00', '15:15:00', 'OFFICE'),
	(4, 4, '2026-10-19', '08:00:00', '17:00:00', 'OFFICE');

-- Дъмп структура за таблица school_hrms.audit_logs
CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `details` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.audit_logs: ~1 rows (приблизителен брой)
INSERT INTO `audit_logs` (`id`, `user_id`, `action`, `details`, `created_at`) VALUES
	(1, 1, 'LOGIN', 'Вход в училищната система', '2026-11-02 21:53:32');

-- Дъмп структура за таблица school_hrms.departments
CREATE TABLE IF NOT EXISTS `departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) DEFAULT NULL,
  `manager_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `fk_dept_manager` (`manager_id`),
  CONSTRAINT `fk_dept_manager` FOREIGN KEY (`manager_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.departments: ~4 rows (приблизителен брой)
INSERT INTO `departments` (`id`, `name`, `code`, `manager_id`) VALUES
	(1, '8А клас (Системно програмиране)', '8A', 2),
	(2, '10Б клас (Киберсигурност)', '10B', 3),
	(3, '11В клас (Приложна информатика)', '11V', 1),
	(4, 'Учителска колегия', 'TEACHERS', 4);

-- Дъмп структура за таблица school_hrms.employees
CREATE TABLE IF NOT EXISTS `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `egn_encrypted` varchar(255) NOT NULL,
  `hire_date` date NOT NULL,
  `department_id` int DEFAULT NULL,
  `position_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `department_id` (`department_id`),
  KEY `position_id` (`position_id`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.employees: ~4 rows (приблизителен брой)
INSERT INTO `employees` (`id`, `first_name`, `surname`, `last_name`, `egn_encrypted`, `hire_date`, `department_id`, `position_id`) VALUES
	(1, 'Николай', 'Йорданов', 'Стоянов', 'ENC_EGN_8001011234', '2018-09-15', 4, 1),
	(2, 'Калоян', 'Станислав', 'Станев', 'ENC_EGN_8505124321', '2020-09-15', 1, 3),
	(3, 'Боян', 'Стефанов', 'Илиев', 'ENC_EGN_7808209988', '2015-09-15', 2, 3),
	(4, 'Мария', 'Калоянова', 'Георгиева', 'ENC_EGN_8211051122', '2012-09-15', 4, 4);

-- Дъмп структура за таблица school_hrms.employee_trainings
CREATE TABLE IF NOT EXISTS `employee_trainings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `training_id` int NOT NULL,
  `status` enum('REGISTERED','COMPLETED','CANCELLED') DEFAULT 'REGISTERED',
  `completion_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  KEY `training_id` (`training_id`),
  CONSTRAINT `employee_trainings_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `employee_trainings_ibfk_2` FOREIGN KEY (`training_id`) REFERENCES `trainings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.employee_trainings: ~2 rows (приблизителен брой)
INSERT INTO `employee_trainings` (`id`, `employee_id`, `training_id`, `status`, `completion_date`) VALUES
	(1, 1, 1, 'REGISTERED', NULL),
	(2, 3, 2, 'COMPLETED', '2026-05-10');

-- Дъмп структура за таблица school_hrms.leave_balances
CREATE TABLE IF NOT EXISTS `leave_balances` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `leave_type_id` int NOT NULL,
  `year` int NOT NULL,
  `remaining_days` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  KEY `leave_type_id` (`leave_type_id`),
  CONSTRAINT `leave_balances_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `leave_balances_ibfk_2` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.leave_balances: ~4 rows (приблизителен брой)
INSERT INTO `leave_balances` (`id`, `employee_id`, `leave_type_id`, `year`, `remaining_days`) VALUES
	(1, 1, 1, 2026, 40),
	(2, 2, 1, 2026, 45),
	(3, 3, 1, 2026, 48),
	(4, 4, 1, 2026, 35);

-- Дъмп структура за таблица school_hrms.leave_requests
CREATE TABLE IF NOT EXISTS `leave_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `leave_type_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
  `reason` text,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  KEY `leave_type_id` (`leave_type_id`),
  CONSTRAINT `leave_requests_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `leave_requests_ibfk_2` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.leave_requests: ~2 rows (приблизителен брой)
INSERT INTO `leave_requests` (`id`, `employee_id`, `leave_type_id`, `start_date`, `end_date`, `status`, `reason`) VALUES
	(1, 1, 4, '2026-11-10', '2026-11-12', 'APPROVED', 'Обучение за интерактивни дъски'),
	(2, 2, 2, '2026-10-25', '2026-10-28', 'PENDING', 'Болничен лист');

-- Дъмп структура за таблица school_hrms.leave_types
CREATE TABLE IF NOT EXISTS `leave_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `default_days_per_year` int DEFAULT '20',
  `is_paid` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.leave_types: ~4 rows (приблизителен брой)
INSERT INTO `leave_types` (`id`, `name`, `default_days_per_year`, `is_paid`) VALUES
	(1, 'Платен годишен отпуск (Ваканция)', 48, 1),
	(2, 'Болничен', 30, 1),
	(3, 'Неплатен отпуск', 30, 0),
	(4, 'Квалификационен курс / Конференция', 10, 1);

-- Дъмп структура за таблица school_hrms.performance_reviews
CREATE TABLE IF NOT EXISTS `performance_reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `reviewer_id` int NOT NULL,
  `review_date` date NOT NULL,
  `rating` int DEFAULT NULL,
  `feedback` text,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  KEY `reviewer_id` (`reviewer_id`),
  CONSTRAINT `performance_reviews_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `performance_reviews_ibfk_2` FOREIGN KEY (`reviewer_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `performance_reviews_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.performance_reviews: ~2 rows (приблизителен брой)
INSERT INTO `performance_reviews` (`id`, `employee_id`, `reviewer_id`, `review_date`, `rating`, `feedback`) VALUES
	(1, 1, 4, '2026-01-15', 5, 'Отлични резултати на учениците на олимпиади.'),
	(2, 2, 4, '2026-01-16', 5, 'Отлично водене на документацията на 8А клас.');

-- Дъмп структура за таблица school_hrms.positions
CREATE TABLE IF NOT EXISTS `positions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `min_salary` decimal(10,2) DEFAULT NULL,
  `max_salary` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.positions: ~4 rows (приблизителен брой)
INSERT INTO `positions` (`id`, `title`, `min_salary`, `max_salary`) VALUES
	(1, 'Учител по Информатика и ИТ', 2000.00, 3000.00),
	(2, 'Учител по Математика', 2000.00, 3000.00),
	(3, 'Класен ръководител', 2200.00, 3200.00),
	(4, 'Директор', 3500.00, 5000.00);

-- Дъмп структура за таблица school_hrms.trainings
CREATE TABLE IF NOT EXISTS `trainings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `provider` varchar(100) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.trainings: ~2 rows (приблизителен брой)
INSERT INTO `trainings` (`id`, `title`, `provider`, `start_date`, `end_date`, `cost`) VALUES
	(1, 'Дигитални умения в училище', 'РУО / МОН', '2026-11-15', '2026-11-18', 0.00),
	(2, 'Защита на личните данни (GDPR) за учители', 'МОН', '2026-12-01', '2026-12-03', 0.00);

-- Дъмп структура за таблица school_hrms.user_accounts
CREATE TABLE IF NOT EXISTS `user_accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('ADMIN','MANAGER','EMPLOYEE') DEFAULT 'EMPLOYEE',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `user_accounts_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Дъмп данни за таблица school_hrms.user_accounts: ~2 rows (приблизителен брой)
INSERT INTO `user_accounts` (`id`, `employee_id`, `username`, `password_hash`, `role`, `is_active`) VALUES
	(1, 4, 'director', '$2y$12$eImiTXuWVxfM37uY4JANjO2B.B4uS6eKzK33Y3x8yG.4.', 'ADMIN', 1),
	(2, 1, 'n_stoyanov', '$2y$12$eImiTXuWVxfM37uY4JANjO2B.B4uS6eKzK33Y3x8yG.4.', 'EMPLOYEE', 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
