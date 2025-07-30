-- 示例SQL文件
-- 创建用户表
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建产品表
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入示例数据
INSERT INTO users (username, email) VALUES 
('张三', 'zhangsan@example.com'),
('李四', 'lisi@example.com'),
('王五', 'wangwu@example.com');

INSERT INTO products (name, price, description) VALUES 
('笔记本电脑', 5999.00, '高性能笔记本电脑'),
('智能手机', 2999.00, '最新款智能手机'),
('无线耳机', 299.00, '蓝牙无线耳机');

-- 查询示例
SELECT * FROM users;
SELECT * FROM products; 