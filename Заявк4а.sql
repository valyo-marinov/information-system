

CREATE TABLE `employee_department_history` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `employee_id` INT NOT NULL,
  `department_id` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE DEFAULT NULL,
  `reason` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`employee_id`) REFERENCES `employees`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;