# 数据可视化展示平台 Realtime Deal Dashboard

## 项目简介

本项目为“西安城乡融合要素交易市场数据可视化展示平台”，实现了MySQL数据库大数据批量导入、表结构适配、数据可视化、前后端联动、自动化脚本、可视化地图联动等功能。支持通过WebSocket实时推送数据，支持区域与街道多级联动筛选。

---

## 技术栈

- **前端**：HTML5、CSS3、原生JavaScript、ECharts、Font Awesome
- **后端**：Node.js、Express、WebSocket（ws）、MySQL2
- **数据库**：MySQL 8.0+
- **可视化**：ECharts（区县/街道地图联动与高亮等）
- **自动化脚本**：Shell（备份、恢复、批量导入）
- **可视化管理**：Sequel Ace
- **版本管理**：Git、GitHub

---

## 目录结构与文件说明

```
Database/
├── index-test2.html           # 前端主页面（数据大屏+地图+表格+与Echarts图联动）
├── mysql-test2.js             # 后端服务（Node.js+WebSocket+MySQL）
├── echarts/                   # ECharts地图及相关数据
│   ├── index.html             # ECharts地图单页演示
│   ├── main.js                # ECharts地图渲染逻辑
│   └── Data/
│       ├── 陕西街道.geojson   # 西安市区/街道GeoJSON地图数据
│       └── 陕西街道.qmd       # 地图数据说明/辅助
├── sql_files/                 # SQL建表、结构、数据、测试等（本地部署时可以删除）
│   ├── create_tables_structure.sql
│   ├── update_sys_article_structure.sql
│   ├── update_sys_organization_structure.sql
│   ├── update_pt_pro_tenders_structure.sql
│   ├── ...                    # 其他结构/数据/模板/测试SQL
├── node_modules/              # Node.js依赖
├── package.json               # Node.js依赖声明
├── package-lock.json          # 依赖锁定
├── backups/                   # 数据库备份文件夹
│   └── my_database_backup_*.sql
├── restore_database.sh        # 数据库恢复脚本
├── backup_database.sh         # 数据库备份脚本
├── run_sql.sh                 # 批量导入SQL脚本
├── README.md                  # 项目说明文档（本文件）
├── sequel_ace_queries.sql     # Sequel Ace常用SQL集合
├── sequel_ace_connection.json # Sequel Ace连接配置示例
├── .git/                      # Git版本管理
├── .vscode/                   # VSCode开发配置
```

---

## 主要功能

- MySQL数据库批量导入、表结构自动适配、主键/字段冲突修复
- 支持大体量SQL数据导入与清理
- 后端定时（每小时）查询数据库，通过WebSocket推送数据
- 前端页面美观简洁易读，支持区域（区）筛选、街道联动高亮、表格/地图/统计卡片联动等
- ECharts地图支持区县下钻街道、返回、地图高亮等，提高易读性
- 自动化备份、恢复、批量导入脚本
- 完善的本地部署与开源支持

## 待完成开发任务
1. **服务器资源：**
    - 服务器 IP 或域名：
    - 可用端口：
    - 服务器访问权限：
2. **数据库资源：**
    - 数据库连接信息：
    - 数据库访问权限：
    - 数据导入权限：
3. **网络资源：**
    - 域名解析：
    - SSL 证书：
    - 防火墙配置：
4. **运维支持：**
    - 服务器维护：
    - 数据库备份：
    - 监控告警：

---

## 依赖安装

1. 安装Node.js（建议v16+）和npm
2. 安装MySQL 8.0+
3. 安装依赖：
   ```bash
   npm install
   ```

---

## 数据库配置与连接

- 默认数据库名：`my_database`
- 默认MySQL用户：`root`，密码：`Root@123456`
- 连接配置在`mysql-test2.js`：
  ```js
  const db = mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: 'Root@123456',
      database: 'my_database'
  });
  ```
- 如需修改数据库名、用户、密码，请同步修改`mysql-test2.js`和相关脚本

---

## 数据批量导入与表结构适配

- 所有建表、结构、数据SQL均在`sql_files/`目录
- 推荐使用`run_sql.sh`批量导入：
  ```bash
  bash run_sql.sh
  ```
- 可用`backup_database.sh`、`restore_database.sh`进行备份/恢复

---

## 启动后端服务

```bash
node mysql-test2.js
```
- 启动后会监听3000端口，WebSocket推送数据，Express静态服务支持前端页面访问

---

## 启动前端页面

- 直接用浏览器打开`index-test2.html`，或访问：
  ```
  http://localhost:3000/index-test2.html
  ```
---

## ECharts地图说明

- 地图数据位于`echarts/Data/陕西街道.geojson`
- 支持区县下钻街道，街道高亮（有交易）、灰色（无交易）等
- 右下角显示高亮街道数量与灰色区域说明

---

## Sequel Ace可视化管理
### 开发时使用的数据库可视化软件，仅用于提高我对数据库内容的了解，可使用其他类似软件或忽略
- `sequel_ace_connection.json`为连接示例
- `sequel_ace_queries.sql`为常用SQL集合

---

## 本地部署与常见问题

1. 克隆项目：
   ```bash
   git clone https://github.com/zxidd24/realtime-deal-dashboard.git
   cd realtime-deal-dashboard
   ```
2. 安装依赖、导入数据库、启动服务（见上文）
3. 如遇端口占用、依赖缺失、数据库连接失败等，请检查：
   - MySQL服务是否启动
   - 端口（默认3000）是否被占用
   - 数据库名、用户、密码是否一致
   - 依赖是否安装完整
4. 地图不显示请检查`echarts/Data/陕西街道.geojson`是否存在


---

## 联系方式
- 作者：张哲溪
- 作者邮箱：z1124340034@sina.com
- 作者GitHub: [zxidd24](https://github.com/zxidd24)
- 项目地址: https://github.com/zxidd24/realtime-deal-dashboard 