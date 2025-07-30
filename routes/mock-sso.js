const express = require('express');
const router = express.Router();

// 模拟统一登录验证接口
router.post('/token', (req, res) => {
    const { appkey, appsecret, code } = req.body;
    
    console.log('模拟统一登录收到验证请求:', { appkey, appsecret, code });
    
    // 验证appkey和appsecret
    if (appkey !== 'dashboard_system' || appsecret !== 'dashboard_secret_2024') {
        return res.json({
            error: 'invalid_client',
            error_description: '无效的客户端凭证'
        });
    }
    
    // 验证code（模拟token验证）
    if (!code || !code.startsWith('mock_token_')) {
        return res.json({
            error: 'invalid_grant',
            error_description: '无效的授权码'
        });
    }
    
    // 模拟返回用户信息
    const mockUserInfo = {
        access_token: 'mock_access_token_' + Date.now(),
        expires_in: 3600,
        values: {
            ssousername: 'mock_user_' + Date.now(),
            nickname: '测试用户',
            roleid: '1',
            isBindUser: 'true',
            username: 'testuser',
            xzqh: '610100',
            tel: '13800138000',
            ssotoken: 'mock_sso_token_' + Date.now()
        }
    };
    
    console.log('模拟统一登录返回用户信息:', mockUserInfo);
    
    res.json(mockUserInfo);
});

module.exports = router; 