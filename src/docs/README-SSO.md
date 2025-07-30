# DashBoard 统一登录集成说明

## 概述

本项目已集成统一登录（SSO）功能，支持与统一登录系统进行对接。用户可以通过统一登录系统访问本数据可视化平台。

## 功能特性

- ✅ 统一登录跳转拦截
- ✅ Token验证接口
- ✅ 用户信息同步
- ✅ 角色获取接口
- ✅ 退出登录功能
- ✅ 用户信息显示

## 文件结构

```
DashBoard/
├── app.js                          # 主服务器文件
├── config/
│   └── sso-config.js              # SSO配置文件
├── routes/
│   ├── sso.js                     # SSO相关接口
│   └── roles.js                   # 角色获取接口
├── public/
│   └── sso/
│       └── index.html             # SSO拦截页面
├── index-test2.html               # 主页面（已集成用户信息显示）
└── package.json                   # 项目依赖
```

## 配置说明

### 1. SSO配置文件 (`config/sso-config.js`)

```javascript
module.exports = {
    // 子系统身份标识（需要与统一登录系统提前约定）
    appkey: 'dashboard_system',
    appsecret: 'dashboard_secret_2024',
    
    // 统一登录回调地址（验证token的接口地址）
    ssoTokenUrl: 'http://localhost:10019/api/sso/token',
    
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
```

### 2. 统一登录系统配置

在统一登录系统中需要配置以下信息：

#### 站点管理配置
- **跳转地址**: `http://your-domain:3000/sso/index.html?code=%s&exiturl=%s`
- **退出地址**: `http://your-domain:3000/api/sso/logout`
- **appkey**: `dashboard_system`
- **appsecret**: `dashboard_secret_2024`
- **角色获取方式**: 手动录入（或自动获取）

#### 角色配置
如果选择手动录入角色，需要在统一登录系统中录入以下角色：
- 角色ID: 1, 角色名: 管理员
- 角色ID: 2, 角色名: 普通用户
- 角色ID: 3, 角色名: 查看用户

## 部署步骤

### 1. 安装依赖

```bash
npm install
```

### 2. 配置数据库

确保MySQL数据库已启动，并创建了相应的表结构。

### 3. 修改配置

根据实际环境修改以下配置：

- `config/sso-config.js` 中的数据库连接信息
- `config/sso-config.js` 中的统一登录回调地址
- `routes/sso.js` 中的数据库连接信息

### 4. 启动服务

```bash
# 开发模式
npm run dev

# 生产模式
npm start
```

### 5. 访问地址

- 主页面: `http://localhost:3000/index-test2.html`
- SSO拦截页面: `http://localhost:3000/sso/index.html`
- 退出页面: `http://localhost:3000/logout`
- 模拟统一登录: `http://localhost:3000/test-sso.html`

### 6. 测试SSO功能

1. 启动服务后，访问 `http://localhost:3000/test-sso.html`
2. 点击"数据可视化平台"模块
3. 系统会自动跳转到SSO拦截页面进行验证
4. 验证成功后会自动跳转到主页面
5. 主页面右上角会显示用户信息

## API接口说明

### 1. SSO验证接口

**POST** `/api/sso/validate`

验证统一登录传递的token。

**请求参数:**
```json
{
    "code": "统一登录传递的token"
}
```

**响应格式:**
```json
{
    "success": true,
    "message": "验证成功",
    "data": {
        "ssousername": "统一登录用户名",
        "username": "真实用户名",
        "roleid": "角色ID",
        "xzqh": "行政区划代码",
        "nickname": "昵称",
        "tel": "电话号码",
        "isBindUser": "是否绑定用户"
    }
}
```

### 2. 角色获取接口

**POST** `/api/roles/getRolesList`

供统一登录系统调用，获取子系统角色列表。

**请求参数:**
```json
{
    "pageNo": 1,
    "pageSize": 10,
    "xzqhdm": "行政区划代码"
}
```

**响应格式:**
```json
{
    "success": true,
    "msg": "查询成功",
    "data": [
        {
            "id": "角色ID",
            "rolename": "角色名称"
        }
    ],
    "totalcount": "总数量"
}
```

### 3. 退出登录接口

**GET** `/api/sso/logout`

退出登录，清除用户信息。

## 使用流程

### 1. 用户访问流程

1. 用户在统一登录系统中点击本系统模块
2. 统一登录系统跳转到 `http://your-domain:3000/sso/index.html?code=xxx&exiturl=xxx`
3. SSO拦截页面自动验证token
4. 验证成功后跳转到主页面
5. 主页面显示用户信息和数据

### 2. 退出流程

1. 用户点击退出按钮
2. 清除本地存储的用户信息
3. 跳转到统一登录系统

## 注意事项

1. **网络配置**: 确保子系统能够访问统一登录系统的内网地址
2. **appkey/appsecret**: 必须与统一登录系统配置一致
3. **角色配置**: 如果选择自动获取角色，需要确保角色接口正常工作
4. **数据库**: 确保数据库连接正常，相关表结构已创建
5. **HTTPS**: 生产环境建议使用HTTPS协议

## 故障排除

### 1. 跳转失败

- 检查appkey、appsecret是否配置正确
- 检查统一登录回调地址是否正确
- 检查网络连接是否正常

### 2. 验证失败

- 检查统一登录系统是否正常运行
- 检查token是否有效
- 检查网络连接是否正常

### 3. 角色获取失败

- 检查数据库连接是否正常
- 检查角色表是否存在
- 检查角色数据是否正确

## 联系支持

如有问题，请联系：
- 北京：凌树峰
- 威海：于新义
- 技术支持：银农直连项目组 