-- 删除旧的sys_organization表并重新创建
DROP TABLE IF EXISTS `sys_organization`;

CREATE TABLE `sys_organization` (
    `id` INT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `code` VARCHAR(100) DEFAULT NULL,
    `name1` VARCHAR(255) DEFAULT NULL,
    `portal_title` VARCHAR(255) DEFAULT NULL,
    `portal_url` VARCHAR(255) DEFAULT NULL,
    `archived` TINYINT DEFAULT 0,
    `pid` VARCHAR(100) DEFAULT '0',
    `jb` VARCHAR(50) DEFAULT NULL,
    `remark` TEXT DEFAULT NULL,
    `order_code` VARCHAR(100) DEFAULT NULL,
    `create_by` VARCHAR(100) DEFAULT NULL,
    `create_time` DATETIME DEFAULT NULL,
    `update_by` VARCHAR(100) DEFAULT NULL,
    `update_time` DATETIME DEFAULT NULL,
    `full_name` VARCHAR(500) DEFAULT NULL,
    `dept_code` VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统组织表'; 