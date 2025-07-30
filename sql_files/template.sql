-- SQL文件模板
-- 文件名: template.sql
-- 描述: 这是一个SQL文件模板，您可以基于此模板创建自己的SQL文件
-- 使用方法: ./run_sql.sh my_database sql_files/your_file.sql

-- ========================================
-- 1. 创建表结构
-- ========================================

-- 示例：创建客户表
CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 示例：创建商品表
CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- 2. 插入数据
-- ========================================

-- 插入客户数据
INSERT INTO customers (name, email, phone, address) VALUES 
('客户A', 'customer_a@example.com', '13800138001', '北京市朝阳区'),
('客户B', 'customer_b@example.com', '13800138002', '上海市浦东新区'),
('客户C', 'customer_c@example.com', '13800138003', '广州市天河区');

-- 插入商品数据
INSERT INTO items (name, category, price, stock, description) VALUES 
('商品1', '电子产品', 999.00, 100, '这是商品1的描述'),
('商品2', '服装', 299.00, 50, '这是商品2的描述'),
('商品3', '家居', 599.00, 30, '这是商品3的描述');

-- ========================================
-- 3. 查询示例
-- ========================================

-- 查看所有客户
SELECT * FROM customers;

-- 查看所有商品
SELECT * FROM items;

-- 按类别统计商品数量
SELECT category, COUNT(*) as count, AVG(price) as avg_price 
FROM items 
GROUP BY category;

-- ========================================
-- 4. 索引创建（可选）
-- ========================================

-- 为常用查询字段创建索引
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_items_category ON items(category);
CREATE INDEX idx_items_price ON items(price);

-- ========================================
-- 5. 视图创建（可选）
-- ========================================

-- 创建商品库存视图
CREATE OR REPLACE VIEW item_stock_view AS
SELECT 
    id,
    name,
    category,
    price,
    stock,
    CASE 
        WHEN stock > 50 THEN '充足'
        WHEN stock > 10 THEN '一般'
        ELSE '不足'
    END as stock_status
FROM items;

-- 查看视图
SELECT * FROM item_stock_view; 