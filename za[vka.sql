CREATE DATABASE IF NOT EXISTS school_hrms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE school_hrms;

-- Временно изключваме проверките за външни ключове
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Длъжности (positions)
INSERT INTO positions (title, min_salary, max_salary) VALUES
('SOC Analyst Level 1', 2500.00, 4000.00),
('Senior Ethical Hacker', 6000.00, 10000.00),
('Secure Code Developer', 3500.00, 6500.00),
('HR Specialist', 2200.00, 3800.00);

-- 2. Отдели (departments)
INSERT INTO departments (name, code, manager_id) VALUES
('Cyber Security & SOC', 'SOC', NULL),
('Penetration Testing & Auditing', 'PENTEST', NULL),
('Secure Software Development', 'DEV', NULL),
('Human Resources', 'HR', NULL);

-- 3. Служители (employees)
INSERT INTO employees (first_name, last_name, egn_encrypted, hire_date, department_id, position_id) VALUES
('Иван', 'Иванов', 'ENC_EGN_8801011234', '2022-03-15', 1, 1),
('Георги', 'Петров', 'ENC_EGN_9005124321', '2021-06-01', 2, 2),
('Мария', 'Георгиева', 'ENC_EGN_9308209988', '2023-01-10', 4, 4),
('Димитър', 'Тодоров', 'ENC_EGN_9511051122', '2023-09-01', 3, 3);

-- Задаване на мениджъри
UPDATE departments SET manager_id = 1 WHERE code = 'SOC';
UPDATE departments SET manager_id = 2 WHERE code = 'PENTEST';
UPDATE departments SET manager_id = 3 WHERE code = 'HR';

-- 4. Видове отпуск (leave_types)
INSERT INTO leave_types (name, default_days_per_year, is_paid) VALUES
('Платен годишен отпуск', 20, 1),
('Болничен', 30, 1),
('Неплатен отпуск', 30, 0),
('Обучение и Сертификация', 10, 1);

-- 5. Баланс на отпуските (leave_balances)
INSERT INTO leave_balances (employee_id, leave_type_id, year, remaining_days) VALUES
(1, 1, 2026, 15),
(2, 1, 2026, 18),
(3, 1, 2026, 20),
(4, 1, 2026, 12);

-- 6. Заявки за отпуск (leave_requests)
INSERT INTO leave_requests (employee_id, leave_type_id, start_date, end_date, status, reason) VALUES
(1, 1, '2026-11-10', '2026-11-15', 'APPROVED', 'Годишна почивка'),
(2, 4, '2026-11-20', '2026-11-22', 'APPROVED', 'Курс за CEH v12'),
(4, 2, '2026-10-25', '2026-10-28', 'PENDING', 'Простуда');

-- 7. Присъствия (attendance_records)
INSERT INTO attendance_records (employee_id, date, check_in, check_out, status) VALUES
(1, '2026-10-19', '09:00:00', '18:00:00', 'OFFICE'),
(2, '2026-10-19', '08:30:00', '17:30:00', 'REMOTE'),
(3, '2026-10-19', '09:15:00', '18:15:00', 'OFFICE'),
(4, '2026-10-19', '09:00:00', '18:00:00', 'REMOTE');

-- 8. Обучения (trainings)
INSERT INTO trainings (title, provider, start_date, end_date, cost) VALUES
('Certified Ethical Hacker (CEH)', 'EC-Council', '2026-11-20', '2026-11-22', 1200.00),
('AWS Certified Security - Specialty', 'Amazon Web Services', '2026-12-01', '2026-12-05', 800.00);

-- 9. Участия в обучения (employee_trainings)
INSERT INTO employee_trainings (employee_id, training_id, status, completion_date) VALUES
(2, 1, 'REGISTERED', NULL),
(4, 2, 'COMPLETED', '2026-05-10');

-- 10. Атестации / Оценки (performance_reviews)
INSERT INTO performance_reviews (employee_id, reviewer_id, review_date, rating, feedback) VALUES
(1, 3, '2026-01-15', 5, 'Отлично справяне с инциденти в SOC.'),
(2, 3, '2026-01-16', 5, 'Успешни пентестове на ключови клиенти.');

-- 11. Потребителски акаунти (user_accounts)
INSERT INTO user_accounts (employee_id, username, password_hash, role, is_active) VALUES
(3, 'hr_admin', '$2y$12$eImiTXuWVxfM37uY4JANjO2B.B4uS6eKzK33Y3x8yG.4.', 'ADMIN', 1),
(1, 'i_ivanov', '$2y$12$eImiTXuWVxfM37uY4JANjO2B.B4uS6eKzK33Y3x8yG.4.', 'EMPLOYEE', 1);

-- 12. Системен одит (audit_logs)
INSERT INTO audit_logs (user_id, action, details, ip_address) VALUES
(1, 'LOGIN', 'Потребителят влезе в системата', '127.0.0.1'),
(1, 'APPROVE_LEAVE', 'Одобрена молба за отпуск ID: 1', '127.0.0.1');

SET FOREIGN_KEY_CHECKS = 1;