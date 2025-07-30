const express = require('express');
const router = express.Router();
const mysql = require('mysql2/promise');

// 数据库连接配置
const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: 'Root@123456',
    database: 'my_database'
};

// 获取角色列表接口（供统一登录系统调用）
router.post('/getRolesList', async (req, res) => {
    try {
        const { pageNo = 1, pageSize = 10, xzqhdm } = req.body;
        
        // 验证必要参数
        if (!xzqhdm) {
            return res.json({
                success: false,
                msg: '缺少行政区划代码参数',
                data: [],
                totalcount: 0
            });
        }

        // 创建数据库连接
        const connection = await mysql.createConnection(dbConfig);
        
        try {
            // 简化的查询，不使用复杂的参数
            const [rows] = await connection.query(`
                SELECT 
                    id,
                    name as rolename
                FROM sys_role 
                WHERE xzqh = '${xzqhdm}' OR xzqh LIKE '${xzqhdm}%'
                LIMIT ${parseInt(pageSize)} OFFSET ${(parseInt(pageNo) - 1) * parseInt(pageSize)}
            `);
            
            const [countResult] = await connection.query(`
                SELECT COUNT(*) as total
                FROM sys_role 
                WHERE xzqh = '${xzqhdm}' OR xzqh LIKE '${xzqhdm}%'
            `);
            
            const totalcount = countResult[0].total;
            
            // 格式化返回数据
            const formattedData = rows.map(row => ({
                id: row.id.toString(),
                rolename: row.rolename
            }));
            
            res.json({
                success: true,
                msg: '查询成功',
                data: formattedData,
                totalcount: totalcount.toString()
            });
            
        } finally {
            await connection.end();
        }
        
    } catch (error) {
        console.error('获取角色列表失败:', error);
        res.json({
            success: false,
            msg: '查询失败: ' + error.message,
            data: [],
            totalcount: '0'
        });
    }
});

// 获取所有角色（不分页）
router.get('/all', async (req, res) => {
    try {
        const connection = await mysql.createConnection(dbConfig);
        
        try {
            const [rows] = await connection.execute(`
                SELECT 
                    id,
                    name as rolename,
                    xzqh,
                    description
                FROM sys_role 
                ORDER BY id
            `);
            
            const formattedData = rows.map(row => ({
                id: row.id.toString(),
                rolename: row.rolename,
                xzqh: row.xzqh,
                description: row.description
            }));
            
            res.json({
                success: true,
                data: formattedData
            });
            
        } finally {
            await connection.end();
        }
        
    } catch (error) {
        console.error('获取所有角色失败:', error);
        res.json({
            success: false,
            message: '获取角色失败: ' + error.message
        });
    }
});

module.exports = router; 