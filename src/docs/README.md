# DashBoard 统一登录集成系统

[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> 数据可视化平台，集成统一登录（SSO）功能，支持与统一登录系统无缝对接。

## 📋 项目概述

本项目是一个基于Node.js + Express + MySQL的数据可视化平台，专门为西安城乡融合要素交易市场设计。项目已完整集成（测试）统一登录（SSO）功能，支持与统一登录系统进行对接，为用户提供安全、便捷的单点登录体验。

### 🎯 主要特性

- **📊 数据可视化**: 基于ECharts的交互式数据图表展示
- **🔐 统一登录**: 完整的SSO集成，支持token验证和用户信息同步
- **👥 用户管理**: 基于角色的用户权限管理
- **📱 响应式设计**: 适配各种设备和屏幕尺寸
- **🔄 实时数据**: WebSocket实时数据推送
- **📤 数据导出**: 支持Excel格式数据导出
- **🧪 测试环境**: 完整的模拟统一登录测试环境

## 🏗️ 技术架构

### 前端技术栈
- **HTML5 + CSS3**: 现代化页面布局和样式
- **JavaScript ES6+**: 原生JavaScript开发
- **ECharts 5.4.3**: 数据可视化图表库
- **WebSocket**: 实时数据通信

### 后端技术栈
- **Node.js**: 服务器运行环境
- **Express.js**: Web应用框架
- **MySQL**: 关系型数据库
- **Axios**: HTTP客户端
- **ws**: WebSocket服务器

### 数据库设计
- **sys_article**: 文章数据表
- **sys_organization**: 组织机构表
- **pt_pro_tenders**: 项目投标表
- **pt_pro_cq_type**: 项目成交类型表
- **sys_role**: 角色管理表
- **sys_user**: 用户管理表

## 🚀 快速开始

### 环境要求

- **Node.js**: 18.0 或更高版本
- **MySQL**: 8.0 或更高版本
- **npm**: 包管理器

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/zxidd24/subsystem-integration.git
   cd subsystem-integration
   ```

2. **安装依赖**
   ```bash
   npm install
   ```

3. **配置数据库**
   ```bash
   # 启动MySQL服务
   mysql.server start
   
   # 创建数据库
   mysql -u root -p
   CREATE DATABASE my_database;
   USE my_database;
   
   # 导入数据库结构
   mysql -u root -p my_database < sql_files/create_tables_structure.sql
   mysql -u root -p my_database < sql_files/create_sys_role_table.sql
   ```

4. **修改配置**
   
   编辑 `config/sso-config.js` 文件：
   ```javascript
   module.exports = {
       appkey: 'dashboard_system',           // 子系统身份标识
       appsecret: 'dashboard_secret_2024',   // 子系统密钥
       ssoTokenUrl: 'http://localhost:3000/mock-sso/token', // 统一登录验证地址
       // ... 其他配置
   };
   ```

5. **启动服务**
   ```bash
   # 使用启动脚本（推荐）
   ./start.sh
   
   # 或手动启动
   node app.js
   ```

6. **访问应用**
   - 主页面: http://localhost:3000/index-test2.html
   - 模拟统一登录: http://localhost:3000/test-sso.html
   - SSO拦截页面: http://localhost:3000/sso/index.html

## 🔧 功能模块

### 1. 统一登录集成

#### SSO验证流程
```
用户访问 → 统一登录系统 → 生成token → 跳转子系统 → 验证token → 显示用户信息
```

#### 核心接口
- `POST /api/sso/validate`: Token验证接口
- `GET /api/sso/logout`: 退出登录接口
- `GET /api/sso/user-info`: 用户信息获取接口
- `POST /api/roles/getRolesList`: 角色获取接口

#### 配置文件
- `config/sso-config.js`: SSO配置文件
- `public/sso/index.html`: SSO拦截页面
- `routes/sso.js`: SSO相关接口

### 2. 数据可视化

#### 图表类型
- **柱状图**: 成交金额和成交笔数统计
- **饼图**: 项目类别分布
- **地图**: 行政区划数据展示

#### 数据源
- 实时数据库查询
- WebSocket实时推送
- 定时数据更新（每小时）

### 3. 用户管理

#### 角色系统
- **管理员**: 完整系统权限
- **普通用户**: 数据查看权限
- **查看用户**: 只读权限

#### 用户信息
- 用户名和昵称
- 角色ID和权限
- 行政区划代码
- 登录时间记录

## 📖 使用指南

### 测试SSO功能

1. **启动服务**
   ```bash
   node app.js
   ```

2. **访问模拟统一登录**
   ```
   http://localhost:3000/test-sso.html
   ```

3. **点击"数据可视化平台"**
   - 系统自动生成测试token
   - 跳转到SSO拦截页面
   - 验证成功后显示用户信息

4. **查看主页面**
   - 右上角显示用户信息
   - 数据图表正常展示
   - 测试退出登录功能

### 生产环境部署

1. **修改SSO配置**
   ```javascript
   // config/sso-config.js
   ssoTokenUrl: 'http://your-sso-server/api/sso/token'
   ```

2. **配置数据库连接**
   ```javascript
   // app.js
   const db = mysql.createConnection({
       host: 'your-db-host',
       user: 'your-db-user',
       password: 'your-db-password',
       database: 'your-database'
   });
   ```

3. **设置环境变量**
   ```bash
   export NODE_ENV=production
   export PORT=3000
   ```

4. **使用PM2部署**
   ```bash
   npm install -g pm2
   pm2 start app.js --name dashboard
   pm2 startup
   pm2 save
   ```

## 🔍 API文档

### SSO验证接口

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

### 角色获取接口

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

## 📁 项目结构

```
DashBoard/
├── app.js                          # 主服务器文件
├── config/
│   └── sso-config.js              # SSO配置文件
├── routes/
│   ├── sso.js                     # SSO相关接口
│   ├── roles.js                   # 角色获取接口
│   └── mock-sso.js               # 模拟统一登录
├── public/
│   ├── sso/
│   │   └── index.html            # SSO拦截页面
│   └── test-sso.html             # 模拟统一登录
├── sql_files/
│   ├── create_sys_role_table.sql # 角色用户表
│   └── create_tables_structure.sql # 基础表结构
├── echarts/
│   ├── Data/                     # 地图数据
│   ├── index.html               # 图表展示页面
│   └── main.js                  # 图表逻辑
├── index-test2.html             # 主页面
├── start.sh                     # 启动脚本
├── demo.sh                      # 演示脚本
├── test-sso.js                  # 接口测试
├── package.json                 # 项目配置
└── README.md                    # 项目说明
```

## 🛠️ 开发指南

### 本地开发

1. **安装开发依赖**
   ```bash
   npm install
   ```

2. **启动开发服务器**
   ```bash
   npm run dev
   ```

3. **运行测试**
   ```bash
   node test-sso.js
   ```

### 代码规范

- 使用ES6+语法
- 遵循JavaScript标准规范
- 添加适当的注释
- 保持代码简洁可读

### 调试技巧

1. **查看日志**
   ```bash
   tail -f logs/app.log
   ```

2. **数据库调试**
   ```bash
   mysql -u root -p my_database
   ```

3. **接口测试**
   ```bash
   curl -X POST http://localhost:3000/api/sso/validate \
        -H "Content-Type: application/json" \
        -d '{"code":"test_token"}'
   ```

## 🐛 故障排除

### 常见问题

1. **数据库连接失败**
   - 检查MySQL服务是否启动
   - 验证数据库连接配置
   - 确认数据库用户权限

2. **SSO验证失败**
   - 检查appkey和appsecret配置
   - 验证统一登录系统地址
   - 查看网络连接状态

3. **页面无法访问**
   - 确认Node.js服务已启动
   - 检查端口是否被占用
   - 验证防火墙设置

### 日志查看

```bash
# 查看应用日志
tail -f logs/app.log

# 查看错误日志
tail -f logs/error.log

# 查看访问日志
tail -f logs/access.log
```

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📞 联系方式

- **项目维护者**: 张哲溪
- **GitHub**: [https://github.com/zxidd24](https://github.com/zxidd24)
- **邮箱**: [z1124340034@sina.com]