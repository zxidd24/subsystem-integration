-- 演示导入SQL文件
-- 这个文件用于演示如何在Sequel Ace中导入SQL文件

-- 创建演示表
CREATE TABLE IF NOT EXISTS demo_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入演示数据
INSERT INTO demo_table (name, description) VALUES 
('演示项目1', '这是第一个演示项目'),
('演示项目2', '这是第二个演示项目'),
('演示项目3', '这是第三个演示项目');

-- 创建视图
CREATE OR REPLACE VIEW demo_view AS
SELECT 
    id,
    name,
    description,
    created_at,
    CASE 
        WHEN id <= 1 THEN '新项目'
        ELSE '常规项目'
    END as project_type
FROM demo_table;

-- 查询演示
SELECT * FROM demo_table;
SELECT * FROM demo_view;

-- 显示导入成功信息
SELECT 'SQL文件导入成功！' as message, NOW() as import_time; 