-- 创建角色表
CREATE TABLE IF NOT EXISTS `sys_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '角色名称',
  `code` varchar(50) DEFAULT NULL COMMENT '角色编码',
  `description` varchar(255) DEFAULT NULL COMMENT '角色描述',
  `xzqh` varchar(20) DEFAULT NULL COMMENT '行政区划代码',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_xzqh` (`xzqh`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统角色表';

-- 插入示例角色数据
INSERT INTO `sys_role` (`name`, `code`, `description`, `xzqh`, `status`) VALUES
('超级管理员', 'SUPER_ADMIN', '拥有所有权限的超级管理员', '610100', 1),
('管理员', 'ADMIN', '系统管理员，拥有大部分权限', '610100', 1),
('普通用户', 'USER', '普通用户，拥有基本查看权限', '610100', 1),
('查看用户', 'VIEWER', '只读用户，只能查看数据', '610100', 1),
('新城区管理员', 'ADMIN_610102', '新城区管理员', '610102', 1),
('碑林区管理员', 'ADMIN_610103', '碑林区管理员', '610103', 1),
('莲湖区管理员', 'ADMIN_610104', '莲湖区管理员', '610104', 1),
('灞桥区管理员', 'ADMIN_610111', '灞桥区管理员', '610111', 1),
('未央区管理员', 'ADMIN_610112', '未央区管理员', '610112', 1),
('雁塔区管理员', 'ADMIN_610113', '雁塔区管理员', '610113', 1);

-- 创建用户表（用于存储SSO用户信息）
CREATE TABLE IF NOT EXISTS `sys_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ssousername` varchar(100) NOT NULL COMMENT '统一登录用户名',
  `username` varchar(100) DEFAULT NULL COMMENT '真实用户名',
  `nickname` varchar(100) DEFAULT NULL COMMENT '昵称',
  `roleid` varchar(20) DEFAULT NULL COMMENT '角色ID',
  `xzqh` varchar(20) DEFAULT NULL COMMENT '行政区划代码',
  `tel` varchar(20) DEFAULT NULL COMMENT '电话号码',
  `isBindUser` tinyint(1) DEFAULT 0 COMMENT '是否绑定用户',
  `last_login_time` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ssousername` (`ssousername`),
  KEY `idx_username` (`username`),
  KEY `idx_roleid` (`roleid`),
  KEY `idx_xzqh` (`xzqh`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表（SSO用户信息）'; 