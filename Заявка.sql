DROP DATABASE IF EXISTS school_hrms;
CREATE DATABASE school_hrms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE school_hrms;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Училищни роли / Длъжности
CREATE TABLE positions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Паралелки / Отдели
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE,
    manager_id INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Учители и Училищен персонал
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    egn_encrypted VARCHAR(255) NOT NULL,
    hire_date DATE NOT NULL,
    department_id INT NULL,
    position_id INT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,
    FOREIGN KEY (position_id) REFERENCES positions(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE departments ADD CONSTRAINT fk_dept_manager FOREIGN KEY (manager_id) REFERENCES employees(id) ON DELETE SET NULL;

-- 4. Видове отсъствия / Молби
CREATE TABLE leave_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    default_days_per_year INT DEFAULT 20,
    is_paid BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Баланс на отпуските / отсъствията
CREATE TABLE leave_balances (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    year INT NOT NULL,
    remaining_days INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Заявки за отпуск / Извинения
CREATE TABLE leave_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    reason TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Присъствия в училище (Дневен дневник)
CREATE TABLE attendance_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    date DATE NOT NULL,
    check_in TIME,
    check_out TIME,
    status ENUM('OFFICE', 'REMOTE', 'ABSENT', 'LATE') DEFAULT 'OFFICE',
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Кръжоци / Извънкласни дейности / Курсове
CREATE TABLE trainings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    provider VARCHAR(100),
    start_date DATE,
    end_date DATE,
    cost DECIMAL(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. Записани в кръжоци
CREATE TABLE employee_trainings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    training_id INT NOT NULL,
    status ENUM('REGISTERED', 'COMPLETED', 'CANCELLED') DEFAULT 'REGISTERED',
    completion_date DATE NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (training_id) REFERENCES trainings(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. Годишни атестации / Оценки на персонала
CREATE TABLE performance_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    review_date DATE NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedback TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES employees(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11. Потребителски акаунти
CREATE TABLE user_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'MANAGER', 'EMPLOYEE') DEFAULT 'EMPLOYEE',
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 12. Системен одит
CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================================
-- ВКАРВАНЕ НА УЧИЛИЩНИ ДАННИ
-- ========================================================

-- 1. Длъжности в училище
INSERT INTO positions (title, min_salary, max_salary) VALUES
('Учител по Информатика и ИТ', 2000.00, 3000.00),
('Учител по Математика', 2000.00, 3000.00),
('Класен ръководител', 2200.00, 3200.00),
('Директор', 3500.00, 5000.00);

-- 2. Паралелки / Отдели
INSERT INTO departments (name, code, manager_id) VALUES
('8А клас (Системно програмиране)', '8A', NULL),
('10Б клас (Киберсигурност)', '10B', NULL),
('11В клас (Приложна информатика)', '11V', NULL),
('Учителска колегия', 'TEACHERS', NULL);

-- 3. Преподаватели / Персонал
INSERT INTO employees (first_name,surname , last_name, egn_encrypted, hire_date, department_id, position_id) VALUES
('Николай','Йорданов' , 'Стоянов', 'ENC_EGN_8001011234', '2018-09-15', 4, 1),
('Калоян','Станислав', 'Станев', 'ENC_EGN_8505124321', '2020-09-15', 1, 3),-- по Изобразително изкуство
('Боян','Стефанов', 'Илиев', 'ENC_EGN_7808209988', '2015-09-15', 2, 3),
('Мария','Калоянова', 'Георгиева', 'ENC_EGN_8211051122', '2012-09-15', 4, 4);
	
-- Задаване на класни ръководители и Директор
UPDATE departments SET manager_id = 2 WHERE code = '8A';
UPDATE departments SET manager_id = 3 WHERE code = '10B';
UPDATE departments SET manager_id = 1 WHERE CODE = '11V';
UPDATE departments SET manager_id = 4 WHERE code = 'TEACHERS';

-- 4. Видове отпуски / отсъствия
INSERT INTO leave_types (name, default_days_per_year, is_paid) VALUES
('Платен годишен отпуск (Ваканция)', 48, 1),
('Болничен', 30, 1),
('Неплатен отпуск', 30, 0),
('Квалификационен курс / Конференция', 10, 1);

-- 5. Баланс на отпуските
INSERT INTO leave_balances (employee_id, leave_type_id, year, remaining_days) VALUES
(1, 1, 2026, 40),
(2, 1, 2026, 45),
(3, 1, 2026, 48),
(4, 1, 2026, 35);

-- 6. Заявки за отпуск
INSERT INTO leave_requests (employee_id, leave_type_id, start_date, end_date, status, reason) VALUES
(1, 4, '2026-11-10', '2026-11-12', 'APPROVED', 'Обучение за интерактивни дъски'),
(2, 2, '2026-10-25', '2026-10-28', 'PENDING', 'Болничен лист');

-- 7. Дневен регистър
INSERT INTO attendance_records (employee_id, date, check_in, check_out, status) VALUES
(1, '2026-10-19', '07:45:00', '16:00:00', 'OFFICE'),
(2, '2026-10-19', '08:00:00', '14:30:00', 'OFFICE'),
(3, '2026-10-19', '07:50:00', '15:15:00', 'OFFICE'),
(4, '2026-10-19', '08:00:00', '17:00:00', 'OFFICE');

-- 8. Извънкласни квалификации
INSERT INTO trainings (title, provider, start_date, end_date, cost) VALUES
('Дигитални умения в училище', 'РУО / МОН', '2026-11-15', '2026-11-18', 0.00),
('Защита на личните данни (GDPR) за учители', 'МОН', '2026-12-01', '2026-12-03', 0.00);

-- 9. Участие в курсове
INSERT INTO employee_trainings (employee_id, training_id, status, completion_date) VALUES
(1, 1, 'REGISTERED', NULL),
(3, 2, 'COMPLETED', '2026-05-10');

-- 10. Атестация на преподаватели
INSERT INTO performance_reviews (employee_id, reviewer_id, review_date, rating, feedback) VALUES
(1, 4, '2026-01-15', 5, 'Отлични резултати на учениците на олимпиади.'),
(2, 4, '2026-01-16', 5, 'Отлично водене на документацията на 8А клас.');

-- 11. Акаунти
INSERT INTO user_accounts (employee_id, username, password_hash, role, is_active) VALUES
(4, 'director', '$2y$12$eImiTXuWVxfM37uY4JANjO2B.B4uS6eKzK33Y3x8yG.4.', 'ADMIN', 1),
(1, 'n_stoyanov', '$2y$12$eImiTXuWVxfM37uY4JANjO2B.B4uS6eKzK33Y3x8yG.4.', 'EMPLOYEE', 1);

-- 12. Системен одит
INSERT INTO audit_logs (user_id, action, details) VALUES
(1, 'LOGIN', 'Вход в училищната система');

SET FOREIGN_KEY_CHECKS = 1;