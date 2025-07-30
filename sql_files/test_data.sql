-- 测试数据SQL文件
-- 创建订单表
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    total_price DECIMAL(10,2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'paid', 'shipped', 'delivered') DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 创建分类表
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入分类数据
INSERT INTO categories (name, description) VALUES 
('电子产品', '各种电子设备和配件'),
('服装', '男装、女装、童装'),
('家居', '家具、装饰品、生活用品');

-- 插入订单数据
INSERT INTO orders (user_id, product_id, quantity, total_price, status) VALUES 
(1, 1, 1, 5999.00, 'paid'),
(2, 2, 2, 5998.00, 'shipped'),
(3, 3, 1, 299.00, 'delivered'),
(1, 2, 1, 2999.00, 'pending');

-- 查询示例
SELECT 
    u.username,
    p.name as product_name,
    o.quantity,
    o.total_price,
    o.status,
    o.order_date
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p ON o.product_id = p.id
ORDER BY o.order_date DESC;

-- 统计每个用户的订单总金额
SELECT 
    u.username,
    COUNT(o.id) as order_count,
    SUM(o.total_price) as total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.username; 