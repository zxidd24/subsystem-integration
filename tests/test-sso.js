const axios = require('axios');

// 测试SSO接口
async function testSSO() {
    console.log('开始测试SSO接口...\n');
    
    try {
        // 测试1: 验证接口（模拟统一登录传递的code）
        console.log('1. 测试SSO验证接口...');
        const validateResponse = await axios.post('http://localhost:3000/api/sso/validate', {
            code: 'test_code_123'
        });
        console.log('验证接口响应:', validateResponse.data);
        console.log('✅ 验证接口测试完成\n');
        
    } catch (error) {
        console.log('❌ 验证接口测试失败:', error.response?.data || error.message);
        console.log('这是正常的，因为我们没有真实的统一登录系统\n');
    }
    
    try {
        // 测试2: 角色获取接口
        console.log('2. 测试角色获取接口...');
        const rolesResponse = await axios.post('http://localhost:3000/api/roles/getRolesList', {
            pageNo: 1,
            pageSize: 10,
            xzqhdm: '610100'
        });
        console.log('角色获取接口响应:', rolesResponse.data);
        console.log('✅ 角色获取接口测试完成\n');
        
    } catch (error) {
        console.log('❌ 角色获取接口测试失败:', error.response?.data || error.message);
        console.log('这可能是因为数据库连接问题或表不存在\n');
    }
    
    try {
        // 测试3: 用户信息接口
        console.log('3. 测试用户信息接口...');
        const userInfoResponse = await axios.get('http://localhost:3000/api/sso/user-info');
        console.log('用户信息接口响应:', userInfoResponse.data);
        console.log('✅ 用户信息接口测试完成\n');
        
    } catch (error) {
        console.log('❌ 用户信息接口测试失败:', error.response?.data || error.message);
    }
    
    try {
        // 测试4: 退出登录接口
        console.log('4. 测试退出登录接口...');
        const logoutResponse = await axios.get('http://localhost:3000/api/sso/logout');
        console.log('退出登录接口响应:', logoutResponse.data);
        console.log('✅ 退出登录接口测试完成\n');
        
    } catch (error) {
        console.log('❌ 退出登录接口测试失败:', error.response?.data || error.message);
    }
    
    console.log('🎉 SSO接口测试完成！');
    console.log('\n📝 测试说明:');
    console.log('- 验证接口失败是正常的，因为我们没有真实的统一登录系统');
    console.log('- 角色获取接口可能失败，因为需要数据库连接和相应的表结构');
    console.log('- 其他接口应该正常工作');
    console.log('\n🌐 访问地址:');
    console.log('- 主页面: http://localhost:3000/index-test2.html');
    console.log('- SSO拦截页面: http://localhost:3000/sso/index.html');
    console.log('- 退出页面: http://localhost:3000/logout');
}

// 运行测试
testSSO().catch(console.error); 