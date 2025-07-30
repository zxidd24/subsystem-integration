-- 创建tables文件夹中SQL文件对应的表结构

-- 1. 创建 pt_pro_cq_type 表
CREATE TABLE IF NOT EXISTS `pt_pro_cq_type` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL COMMENT '类型名称',
    `code` VARCHAR(10) NOT NULL COMMENT '类型代码',
    `pid` INT DEFAULT 0 COMMENT '父级ID',
    `order_no` INT DEFAULT 0 COMMENT '排序号',
    `level` INT DEFAULT NULL COMMENT '层级',
    `create_by` VARCHAR(100) DEFAULT '' COMMENT '创建人',
    `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
    `update_by` VARCHAR(100) DEFAULT '' COMMENT '更新人',
    `update_time` DATETIME DEFAULT NULL COMMENT '更新时间',
    `model_type` VARCHAR(50) DEFAULT 'personal' COMMENT '模型类型',
    `show_type` VARCHAR(10) DEFAULT '1' COMMENT '显示类型',
    `deleted` VARCHAR(10) DEFAULT '0' COMMENT '删除标记',
    `cq_type` VARCHAR(50) DEFAULT NULL COMMENT '成交类型',
    `allow_direction` VARCHAR(50) DEFAULT '0' COMMENT '允许方向',
    `pay_party` VARCHAR(50) DEFAULT '0' COMMENT '支付方'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目成交类型表';

-- 2. 创建 sys_organization 表
CREATE TABLE IF NOT EXISTS `sys_organization` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL COMMENT '组织名称',
    `code` VARCHAR(100) DEFAULT NULL COMMENT '组织代码',
    `parent_id` INT DEFAULT 0 COMMENT '父级ID',
    `level` INT DEFAULT 1 COMMENT '层级',
    `order_no` INT DEFAULT 0 COMMENT '排序号',
    `status` TINYINT DEFAULT 1 COMMENT '状态',
    `create_by` VARCHAR(100) DEFAULT '' COMMENT '创建人',
    `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
    `update_by` VARCHAR(100) DEFAULT '' COMMENT '更新人',
    `update_time` DATETIME DEFAULT NULL COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标记'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统组织表';

-- 3. 创建 sys_article 表
CREATE TABLE IF NOT EXISTS `sys_article` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `article_title` VARCHAR(500) NOT NULL COMMENT '文章标题',
    `article_content` TEXT COMMENT '文章内容',
    `village_code` VARCHAR(20) DEFAULT NULL COMMENT '村代码',
    `pro_id` INT DEFAULT NULL COMMENT '项目ID',
    `pro_type` VARCHAR(10) DEFAULT NULL COMMENT '项目类型',
    `amount` DECIMAL(15,2) DEFAULT 0.00 COMMENT '金额',
    `status` TINYINT DEFAULT 1 COMMENT '状态',
    `create_by` VARCHAR(100) DEFAULT '' COMMENT '创建人',
    `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
    `update_by` VARCHAR(100) DEFAULT '' COMMENT '更新人',
    `update_time` DATETIME DEFAULT NULL COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标记'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统文章表';

-- 4. 创建 pt_pro_tenders 表
CREATE TABLE IF NOT EXISTS `pt_pro_tenders` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `pro_id` INT NOT NULL COMMENT '项目ID',
    `tender_name` VARCHAR(255) NOT NULL COMMENT '投标人名称',
    `tender_amount` DECIMAL(15,2) DEFAULT 0.00 COMMENT '投标金额',
    `status` TINYINT DEFAULT 0 COMMENT '状态',
    `create_by` VARCHAR(100) DEFAULT '' COMMENT '创建人',
    `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
    `update_by` VARCHAR(100) DEFAULT '' COMMENT '更新人',
    `update_time` DATETIME DEFAULT NULL COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标记'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目投标表';

-- 创建索引
CREATE INDEX idx_pt_pro_cq_type_pid ON pt_pro_cq_type(pid);
CREATE INDEX idx_pt_pro_cq_type_code ON pt_pro_cq_type(code);
CREATE INDEX idx_sys_organization_parent_id ON sys_organization(parent_id);
CREATE INDEX idx_sys_organization_code ON sys_organization(code);
CREATE INDEX idx_sys_article_pro_id ON sys_article(pro_id);
CREATE INDEX idx_sys_article_village_code ON sys_article(village_code);
CREATE INDEX idx_sys_article_pro_type ON sys_article(pro_type);
CREATE INDEX idx_pt_pro_tenders_pro_id ON pt_pro_tenders(pro_id);
CREATE INDEX idx_pt_pro_tenders_status ON pt_pro_tenders(status); 