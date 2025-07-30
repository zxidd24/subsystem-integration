-- 完整演示SQL文件
-- 这个文件演示了各种数据库操作，可以在Sequel Ace中导入和执行

-- ========================================
-- 1. 创建新表
-- ========================================

-- 创建员工表
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建项目表
CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    status ENUM('planning', 'in_progress', 'completed', 'cancelled') DEFAULT 'planning',
    budget DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建员工项目关联表
CREATE TABLE IF NOT EXISTS employee_projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    project_id INT NOT NULL,
    role VARCHAR(50),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    FOREIGN KEY (project_id) REFERENCES projects(id),
    UNIQUE KEY unique_employee_project (employee_id, project_id)
);

-- ========================================
-- 2. 插入示例数据
-- ========================================

-- 插入员工数据
INSERT INTO employees (name, email, department, salary, hire_date) VALUES 
('张三', 'zhangsan@company.com', '技术部', 8000.00, '2023-01-15'),
('李四', 'lisi@company.com', '市场部', 7000.00, '2023-02-20'),
('王五', 'wangwu@company.com', '技术部', 9000.00, '2022-11-10'),
('赵六', 'zhaoliu@company.com', '人事部', 6000.00, '2023-03-05'),
('钱七', 'qianqi@company.com', '财务部', 7500.00, '2023-01-08');

-- 插入项目数据
INSERT INTO projects (name, description, start_date, end_date, status, budget) VALUES 
('电商平台开发', '开发一个全新的电商平台', '2023-04-01', '2023-12-31', 'in_progress', 500000.00),
('移动应用开发', '开发iOS和Android应用', '2023-06-01', '2024-02-28', 'planning', 300000.00),
('数据分析系统', '构建数据分析平台', '2023-03-01', '2023-08-31', 'completed', 200000.00),
('客户管理系统', '升级客户管理系统', '2023-05-01', '2023-10-31', 'in_progress', 150000.00);

-- 插入员工项目关联数据
INSERT INTO employee_projects (employee_id, project_id, role, start_date, end_date) VALUES 
(1, 1, '前端开发', '2023-04-01', '2023-12-31'),
(3, 1, '后端开发', '2023-04-01', '2023-12-31'),
(1, 2, '移动开发', '2023-06-01', '2024-02-28'),
(3, 3, '数据分析师', '2023-03-01', '2023-08-31'),
(2, 4, '项目经理', '2023-05-01', '2023-10-31'),
(5, 4, '财务顾问', '2023-05-01', '2023-10-31');

-- ========================================
-- 3. 创建索引
-- ========================================

-- 为常用查询字段创建索引
CREATE INDEX idx_employees_department ON employees(department);
CREATE INDEX idx_employees_salary ON employees(salary);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_budget ON projects(budget);
CREATE INDEX idx_employee_projects_role ON employee_projects(role);

-- ========================================
-- 4. 创建视图
-- ========================================

-- 员工项目视图
CREATE OR REPLACE VIEW employee_project_view AS
SELECT 
    e.name as employee_name,
    e.department,
    p.name as project_name,
    p.status as project_status,
    ep.role,
    p.budget,
    e.salary
FROM employees e
JOIN employee_projects ep ON e.id = ep.employee_id
JOIN projects p ON ep.project_id = p.id;

-- 部门统计视图
CREATE OR REPLACE VIEW department_stats_view AS
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    SUM(salary) as total_salary,
    MIN(hire_date) as earliest_hire,
    MAX(hire_date) as latest_hire
FROM employees
GROUP BY department;

-- 项目统计视图
CREATE OR REPLACE VIEW project_stats_view AS
SELECT 
    p.name as project_name,
    p.status,
    p.budget,
    COUNT(ep.employee_id) as team_size,
    AVG(e.salary) as avg_team_salary,
    SUM(e.salary) as total_team_salary
FROM projects p
LEFT JOIN employee_projects ep ON p.id = ep.project_id
LEFT JOIN employees e ON ep.employee_id = e.id
GROUP BY p.id, p.name, p.status, p.budget;

-- ========================================
-- 5. 查询示例
-- ========================================

-- 查看所有表
SELECT 'Tables in database:' as info;
SHOW TABLES;

-- 查看员工信息
SELECT 'Employee Information:' as info;
SELECT * FROM employees;

-- 查看项目信息
SELECT 'Project Information:' as info;
SELECT * FROM projects;

-- 查看员工项目关联
SELECT 'Employee-Project Relationships:' as info;
SELECT * FROM employee_project_view;

-- 部门统计
SELECT 'Department Statistics:' as info;
SELECT * FROM department_stats_view;

-- 项目统计
SELECT 'Project Statistics:' as info;
SELECT * FROM project_stats_view;

-- 复杂查询：高薪员工参与的项目
SELECT 'High-salary employees and their projects:' as info;
SELECT 
    e.name,
    e.salary,
    p.name as project_name,
    p.budget,
    ep.role
FROM employees e
JOIN employee_projects ep ON e.id = ep.employee_id
JOIN projects p ON ep.project_id = p.id
WHERE e.salary > (SELECT AVG(salary) FROM employees)
ORDER BY e.salary DESC;

-- 项目预算分析
SELECT 'Project Budget Analysis:' as info;
SELECT 
    p.name,
    p.budget,
    COUNT(ep.employee_id) as team_size,
    p.budget / COUNT(ep.employee_id) as budget_per_person
FROM projects p
LEFT JOIN employee_projects ep ON p.id = ep.project_id
GROUP BY p.id, p.name, p.budget
HAVING team_size > 0
ORDER BY budget_per_person DESC;

-- ========================================
-- 6. 存储过程示例
-- ========================================

-- 创建存储过程：获取部门员工信息
DELIMITER //
CREATE PROCEDURE GetDepartmentEmployees(IN dept_name VARCHAR(50))
BEGIN
    SELECT 
        name,
        email,
        salary,
        hire_date,
        DATEDIFF(CURDATE(), hire_date) as days_employed
    FROM employees 
    WHERE department = dept_name
    ORDER BY salary DESC;
END //
DELIMITER ;

-- 创建存储过程：获取项目团队成员
DELIMITER //
CREATE PROCEDURE GetProjectTeam(IN project_name VARCHAR(200))
BEGIN
    SELECT 
        e.name as employee_name,
        e.department,
        ep.role,
        e.salary
    FROM employees e
    JOIN employee_projects ep ON e.id = ep.employee_id
    JOIN projects p ON ep.project_id = p.id
    WHERE p.name = project_name
    ORDER BY e.salary DESC;
END //
DELIMITER ;

-- ========================================
-- 7. 触发器示例
-- ========================================

-- 创建触发器：更新员工时记录日志
CREATE TABLE IF NOT EXISTS employee_audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    action VARCHAR(20),
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER employee_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary != NEW.salary THEN
        INSERT INTO employee_audit_log (employee_id, action, old_salary, new_salary)
        VALUES (NEW.id, 'SALARY_UPDATE', OLD.salary, NEW.salary);
    END IF;
END //
DELIMITER ;

-- ========================================
-- 8. 测试数据完整性
-- ========================================

-- 检查外键约束
SELECT 'Foreign Key Check:' as info;
SELECT 
    'employee_projects.employee_id' as foreign_key,
    COUNT(*) as total_records,
    COUNT(e.id) as valid_references,
    COUNT(*) - COUNT(e.id) as invalid_references
FROM employee_projects ep
LEFT JOIN employees e ON ep.employee_id = e.id

UNION ALL

SELECT 
    'employee_projects.project_id' as foreign_key,
    COUNT(*) as total_records,
    COUNT(p.id) as valid_references,
    COUNT(*) - COUNT(p.id) as invalid_references
FROM employee_projects ep
LEFT JOIN projects p ON ep.project_id = p.id;

-- 数据完整性检查
SELECT 'Data Integrity Check:' as info;
SELECT 
    'employees' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT email) as unique_emails,
    COUNT(DISTINCT department) as unique_departments
FROM employees

UNION ALL

SELECT 
    'projects' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT name) as unique_names,
    COUNT(DISTINCT status) as unique_statuses
FROM projects;

-- ========================================
-- 9. 性能优化查询
-- ========================================

-- 使用EXPLAIN分析查询性能
SELECT 'Query Performance Analysis:' as info;
EXPLAIN SELECT 
    e.name,
    p.name as project_name,
    ep.role
FROM employees e
JOIN employee_projects ep ON e.id = ep.employee_id
JOIN projects p ON ep.project_id = p.id
WHERE e.salary > 7000 AND p.status = 'in_progress';

-- ========================================
-- 10. 完成信息
-- ========================================

SELECT 'SQL文件执行完成！' as message, NOW() as completion_time;
SELECT '数据库包含以下内容:' as info;
SELECT 'Tables: employees, projects, employee_projects, employee_audit_log' as tables;
SELECT 'Views: employee_project_view, department_stats_view, project_stats_view' as views;
SELECT 'Procedures: GetDepartmentEmployees, GetProjectTeam' as procedures;
SELECT 'Triggers: employee_salary_update' as triggers; 