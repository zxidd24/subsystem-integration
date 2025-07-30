-- 删除除pt_pro_cq_type、pt_pro_tenders、sys_article、sys_organization以外的所有表和视图
DROP VIEW IF EXISTS demo_view, department_stats_view, employee_project_view, project_stats_view;
DROP TABLE IF EXISTS categories, demo_table, employee_audit_log, employee_projects, employees, orders, products, projects, users; 