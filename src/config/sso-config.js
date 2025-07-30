// SSO统一登录配置
module.exports = {
    // 子系统身份标识（需要与统一登录系统提前约定）
    appkey: 'dashboard_system',
    appsecret: 'dashboard_secret_2024',
    
    // 统一登录回调地址（验证token的接口地址）
    // 注意：此地址最好写内网地址，如果与统一登录部署在同一机器上，一般为localhost
    // 测试模式：使用模拟的统一登录接口
    ssoTokenUrl: 'http://localhost:3000/mock-sso/token',
    
    // 生产环境统一登录地址（需要时修改）
    // ssoTokenUrl: 'http://localhost:10019/api/sso/token',
    
    // 子系统退出地址
    logoutUrl: '/api/user/logout',
    
    // 子系统拦截页面地址
    ssoIndexUrl: '/sso/index.html',
    
    // 用户信息字段映射
    userFields: {
        ssousername: 'ssousername',    // 统一登录用户名
        username: 'username',          // 真实用户名
        roleid: 'roleid',              // 角色id
        xzqh: 'xzqh',                  // 行政区划代码
        nickname: 'nickname',          // 昵称
        tel: 'tel',                    // 电话号码
        isBindUser: 'isBindUser'       // 是否绑定用户
    }
}; 