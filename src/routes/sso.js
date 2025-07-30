const express = require('express');
const router = express.Router();
const axios = require('axios');
const ssoConfig = require('../config/sso-config');

// SSO token验证接口
router.post('/validate', async (req, res) => {
    try {
        const { code } = req.body;
        
        if (!code) {
            return res.json({
                success: false,
                message: '缺少必要的验证参数'
            });
        }

        // 调用统一登录系统验证token
        const tokenResponse = await validateWithSSO(code);
        
        if (tokenResponse.success) {
            // 验证成功，处理用户信息
            const userInfo = processUserInfo(tokenResponse.data);
            
            // 同步用户信息到数据库
            try {
                await syncUserToDatabase(userInfo);
            } catch (error) {
                console.error('同步用户信息到数据库失败:', error);
                // 即使同步失败，也不影响登录流程
            }
            
            res.json({
                success: true,
                message: '验证成功',
                data: userInfo
            });
        } else {
            res.json({
                success: false,
                message: tokenResponse.message || '统一登录验证失败'
            });
        }
    } catch (error) {
        console.error('SSO验证失败:', error);
        res.json({
            success: false,
            message: '验证过程中发生错误'
        });
    }
});

// 退出登录接口
router.get('/logout', (req, res) => {
    try {
        // 清除本地存储的用户信息
        res.json({
            success: true,
            message: '退出成功',
            redirectUrl: req.query.redirect || '/'
        });
    } catch (error) {
        console.error('退出登录失败:', error);
        res.json({
            success: false,
            message: '退出失败'
        });
    }
});

// 获取当前用户信息接口
router.get('/user-info', (req, res) => {
    try {
        // 这里应该从session或token中获取用户信息
        // 暂时返回模拟数据
        res.json({
            success: true,
            data: {
                username: '测试用户',
                nickname: '测试昵称',
                roleid: '1',
                xzqh: '610100'
            }
        });
    } catch (error) {
        console.error('获取用户信息失败:', error);
        res.json({
            success: false,
            message: '获取用户信息失败'
        });
    }
});

// 调用统一登录系统验证token
async function validateWithSSO(code) {
    try {
        const response = await axios.post(ssoConfig.ssoTokenUrl, {
            appkey: ssoConfig.appkey,
            appsecret: ssoConfig.appsecret,
            code: code
        }, {
            headers: {
                'Content-Type': 'application/json'
            },
            timeout: 10000 // 10秒超时
        });

        const data = response.data;
        
        if (data.access_token) {
            return {
                success: true,
                data: data.values || data
            };
        } else {
            return {
                success: false,
                message: data.error_description || '统一登录返回错误'
            };
        }
    } catch (error) {
        console.error('统一登录验证请求失败:', error);
        
        if (error.response) {
            // 服务器返回了错误状态码
            return {
                success: false,
                message: `统一登录验证失败: ${error.response.status}`
            };
        } else if (error.request) {
            // 请求发送失败
            return {
                success: false,
                message: '无法连接到统一登录系统，请检查网络连接'
            };
        } else {
            // 其他错误
            return {
                success: false,
                message: '验证过程中发生未知错误'
            };
        }
    }
}

// 处理用户信息
function processUserInfo(userData) {
    const processedUser = {};
    
    // 映射用户信息字段
    Object.keys(ssoConfig.userFields).forEach(key => {
        processedUser[key] = userData[ssoConfig.userFields[key]] || '';
    });
    
    // 添加额外的处理逻辑
    processedUser.loginTime = new Date().toISOString();
    processedUser.source = 'sso';
    
    return processedUser;
}

// 同步用户信息到数据库
async function syncUserToDatabase(userInfo) {
    const mysql = require('mysql2/promise');
    
    // 数据库连接配置
    const dbConfig = {
        host: 'localhost',
        user: 'root',
        password: 'Root@123456',
        database: 'my_database'
    };
    
    const connection = await mysql.createConnection(dbConfig);
    
    try {
        // 构建SQL语句：如果用户存在则更新，不存在则插入
        const sql = `
            INSERT INTO sys_user (
                ssousername, username, roleid, xzqh, nickname, tel, isBindUser, last_login_time, created_at, updated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW(), NOW())
            ON DUPLICATE KEY UPDATE
                username = VALUES(username),
                roleid = VALUES(roleid),
                xzqh = VALUES(xzqh),
                nickname = VALUES(nickname),
                tel = VALUES(tel),
                isBindUser = VALUES(isBindUser),
                last_login_time = NOW(),
                updated_at = NOW()
        `;
        
        const params = [
            userInfo.ssousername || '',
            userInfo.username || '',
            userInfo.roleid || '',
            userInfo.xzqh || '',
            userInfo.nickname || '',
            userInfo.tel || '',
            userInfo.isBindUser ? 1 : 0
        ];
        
        await connection.execute(sql, params);
        console.log('用户信息同步到数据库成功:', userInfo.ssousername);
        
    } catch (error) {
        console.error('同步用户信息到数据库失败:', error);
        throw error;
    } finally {
        await connection.end();
    }
}

module.exports = router; 