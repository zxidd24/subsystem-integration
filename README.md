# DashBoard 统一登录集成系统

## 📁 项目结构

```
DashBoard/
├── src/                          # 源代码目录
│   ├── server/                   # 服务器端代码
│   │   └── app.js               # 主服务器文件
│   ├── routes/                   # 路由文件
│   │   ├── sso.js              # SSO相关接口
│   │   ├── roles.js            # 角色获取接口
│   │   └── mock-sso.js         # 模拟统一登录接口
│   ├── config/                   # 配置文件
│   │   └── sso-config.js       # SSO配置文件
│   ├── public/                   # 前端文件
│   │   ├── components/         # 组件文件
│   │   │   └── index-test2.html # 主页面
│   │   ├── assets/             # 静态资源
│   │   │   ├── index.html     # 图表展示页面
│   │   │   ├── main.js        # 图表逻辑
│   │   │   └── Data/          # 地图数据
│   │   ├── sso/               # SSO相关页面
│   │   │   └── index.html     # SSO拦截页面
│   │   └── test-sso.html      # 模拟统一登录页面
│   ├── database/                # 数据库脚本
│   │   ├── create_tables_structure.sql    # 基础表结构
│   │   ├── create_sys_role_table.sql     # 角色用户表
│   │   ├── complete_demo.sql             # 演示数据
│   │   └── update_*.sql                  # 表结构更新脚本
│   ├── scripts/                  # 脚本文件
│   │   ├── start.sh            # 启动脚本
│   │   └── demo.sh             # 演示脚本
│   └── docs/                    # 文档文件
│       ├── README.md           # 项目文档
│       ├── README-SSO.md       # SSO说明文档
│       ├── PROJECT_SUMMARY.md  # 项目总结
│       └── document_content.md # 需求文档
├── tests/                        # 测试文件
│   └── test-sso.js             # SSO接口测试
├── examples/                     # 示例文件
│   └── 子系统接入统一登录步骤v1.3(1).docx
├── package.json                  # 项目配置
├── package-lock.json            # 依赖锁定
└── .gitignore                   # Git忽略文件
```

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
   mysql -u root -p my_database < src/database/create_tables_structure.sql
   mysql -u root -p my_database < src/database/create_sys_role_table.sql
   ```

4. **启动服务**
   ```bash
   # 使用启动脚本（推荐）
   chmod +x src/scripts/start.sh
   ./src/scripts/start.sh
   
   # 或使用npm命令
   npm start
   ```

5. **访问应用**
   - 主页面: http://localhost:3000/components/index-test2.html
   - 模拟统一登录: http://localhost:3000/test-sso.html
   - SSO拦截页面: http://localhost:3000/sso/index.html

## 🔧 功能模块

### 1. 统一登录集成
- **SSO验证**: 完整的token验证和用户信息同步
- **角色管理**: 支持角色获取和权限管理
- **退出登录**: 完整的退出流程和清理机制

### 2. 数据可视化
- **ECharts图表**: 交互式数据图表展示
- **地图展示**: 西安市区/街道地图数据
- **实时数据**: WebSocket实时数据推送

### 3. 用户管理
- **用户信息显示**: 在页面右上角显示用户信息
- **权限控制**: 基于角色的权限管理
- **会话管理**: 完整的登录状态管理

## 📖 使用指南

### 测试SSO功能

1. **启动服务**
   ```bash
   npm start
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

### 运行测试

```bash
# 运行SSO接口测试
npm test

# 或直接运行
node tests/test-sso.js
```

## 🛠️ 开发指南

### 项目结构说明

- **src/server/**: 服务器端代码，包含主应用和数据库连接
- **src/routes/**: API路由文件，处理各种HTTP请求
- **src/config/**: 配置文件，包含SSO和其他系统配置
- **src/public/**: 前端文件，包含HTML、CSS、JavaScript
- **src/database/**: 数据库脚本，包含表结构和数据
- **src/scripts/**: 部署和运维脚本
- **src/docs/**: 项目文档

### 开发命令

```bash
# 开发模式（自动重启）
npm run dev

# 生产模式
npm start

# 运行测试
npm test
```

## 📄 许可证

本项目采用 MIT 许可证。

## 📞 联系方式

- **项目维护者**: 张哲溪
- **GitHub**: [https://github.com/zxidd24](https://github.com/zxidd24)
- **邮箱**: [z1124340034@sina.com]

---