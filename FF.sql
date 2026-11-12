INSERT INTO `users` (`id`, `name`, `email`, `password`, `created_at`, `updated_at`)
SELECT 
    `id`, 
    COALESCE(`username`, `first_name`, 'User') AS `name`, 
    `email`, 
    -- Задава стандартна криптирана парола '123456' за всички прехвърлени потребители
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' AS `password`,
    NOW(), 
    NOW()
FROM `user_account`
ON DUPLICATE KEY UPDATE `email` = VALUES(`email`);