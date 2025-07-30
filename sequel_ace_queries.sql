-- Sequel Ace 常用查询集合
-- 在Sequel Ace的Query标签页中执行这些查询

-- ========================================
-- 1. 基础查询
-- ========================================

-- 查看所有表
SHOW TABLES;

-- 查看表结构
DESCRIBE users;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE categories;

-- 查看表数据
SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM categories;

-- ========================================
-- 2. 数据统计查询
-- ========================================

-- 统计每个表的记录数
SELECT 
    'users' as table_name, COUNT(*) as record_count FROM users
UNION ALL
SELECT 
    'products' as table_name, COUNT(*) as record_count FROM products
UNION ALL
SELECT 
    'orders' as table_name, COUNT(*) as record_count FROM orders
UNION ALL
SELECT 
    'categories' as table_name, COUNT(*) as record_count FROM categories;

-- 统计订单状态分布
SELECT 
    status,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) as percentage
FROM orders 
GROUP BY status;

-- 统计产品价格分布
SELECT 
    CASE 
        WHEN price < 1000 THEN '低价 (<1000)'
        WHEN price < 5000 THEN '中价 (1000-5000)'
        ELSE '高价 (>5000)'
    END as price_range,
    COUNT(*) as count,
    AVG(price) as avg_price
FROM products 
GROUP BY 
    CASE 
        WHEN price < 1000 THEN '低价 (<1000)'
        WHEN price < 5000 THEN '中价 (1000-5000)'
        ELSE '高价 (>5000)'
    END;

-- ========================================
-- 3. 复杂关联查询
-- ========================================

-- 查看用户订单详情（包含产品信息）
SELECT 
    u.username,
    u.email,
    p.name as product_name,
    p.price as unit_price,
    o.quantity,
    o.total_price,
    o.status,
    o.order_date
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p ON o.product_id = p.id
ORDER BY o.order_date DESC;

-- 用户消费统计
SELECT 
    u.username,
    u.email,
    COUNT(o.id) as total_orders,
    SUM(o.total_price) as total_spent,
    AVG(o.total_price) as avg_order_value,
    MAX(o.order_date) as last_order_date
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.username, u.email
ORDER BY total_spent DESC;

-- 产品销售统计
SELECT 
    p.name,
    p.price,
    COUNT(o.id) as times_ordered,
    SUM(o.quantity) as total_quantity_sold,
    SUM(o.total_price) as total_revenue
FROM products p
LEFT JOIN orders o ON p.id = o.product_id
GROUP BY p.id, p.name, p.price
ORDER BY total_revenue DESC;

-- ========================================
-- 4. 数据验证查询
-- ========================================

-- 检查外键约束
SELECT 
    'orders.user_id' as foreign_key,
    COUNT(*) as total_orders,
    COUNT(u.id) as valid_user_references,
    COUNT(*) - COUNT(u.id) as invalid_references
FROM orders o
LEFT JOIN users u ON o.user_id = u.id

UNION ALL

SELECT 
    'orders.product_id' as foreign_key,
    COUNT(*) as total_orders,
    COUNT(p.id) as valid_product_references,
    COUNT(*) - COUNT(p.id) as invalid_references
FROM orders o
LEFT JOIN products p ON o.product_id = p.id;

-- 检查数据完整性
SELECT 
    'users' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT username) as unique_usernames,
    COUNT(DISTINCT email) as unique_emails
FROM users

UNION ALL

SELECT 
    'products' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT name) as unique_names,
    COUNT(DISTINCT price) as unique_prices
FROM products;

-- ========================================
-- 5. 实用查询
-- ========================================

-- 查找最近7天的订单
SELECT 
    u.username,
    p.name as product_name,
    o.total_price,
    o.order_date
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p ON o.product_id = p.id
WHERE o.order_date >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY o.order_date DESC;

-- 查找高价值订单（金额大于平均订单金额）
SELECT 
    u.username,
    p.name as product_name,
    o.total_price,
    o.order_date
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p ON o.product_id = p.id
WHERE o.total_price > (SELECT AVG(total_price) FROM orders)
ORDER BY o.total_price DESC;

-- 查找待处理的订单
SELECT 
    u.username,
    u.email,
    p.name as product_name,
    o.quantity,
    o.total_price,
    o.order_date
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p ON o.product_id = p.id
WHERE o.status = 'pending'
ORDER BY o.order_date ASC; 