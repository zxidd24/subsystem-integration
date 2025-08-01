const express = require('express');
const WebSocket = require('ws');
const mysql = require("mysql2");
const path = require('path');

// 导入路由
const ssoRoutes = require('../routes/sso');
const rolesRoutes = require('../routes/roles');
const mockSsoRoutes = require('../routes/mock-sso');

const app = express();
const port = 3000;

// 中间件配置
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 主页面路由 - 必须在静态文件中间件之前
app.get('/', (req, res) => {
    res.redirect('/components/index-test2.html');
});

// 静态文件中间件
app.use(express.static(path.join(__dirname, '../public')));
app.use(express.static(path.join(__dirname, '../public/components')));
app.use(express.static(path.join(__dirname, '../public/assets')));

// 数据库连接配置
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Root@123456',
    database: 'my_database'
});

db.connect((err) => {
    if (err) {
        console.error('数据库连接失败:', err.message);
    } else {
        console.log('数据库连接成功');
    }
});

// 路由配置
app.use('/api/sso', ssoRoutes);
app.use('/api/roles', rolesRoutes);
app.use('/mock-sso', mockSsoRoutes); // 模拟统一登录接口



// 退出登录页面
app.get('/logout', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>退出登录</title>
            <style>
                body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
                .logout-container { max-width: 400px; margin: 0 auto; }
                .btn { padding: 10px 20px; margin: 10px; border: none; border-radius: 5px; cursor: pointer; }
                .btn-primary { background: #007bff; color: white; }
                .btn-secondary { background: #6c757d; color: white; }
            </style>
        </head>
        <body>
            <div class="logout-container">
                <h2>确认退出</h2>
                <p>您确定要退出系统吗？</p>
                <button class="btn btn-primary" onclick="logout()">确认退出</button>
                <button class="btn btn-secondary" onclick="cancel()">取消</button>
            </div>
            <script>
                function logout() {
                    // 清除本地存储
                    localStorage.removeItem('sso_user_info');
                    localStorage.removeItem('sso_login_time');
                    localStorage.removeItem('sso_exiturl');
                    
                    // 跳转到统一登录系统
                    const exiturl = localStorage.getItem('sso_exiturl');
                    if (exiturl) {
                        window.location.href = exiturl;
                    } else {
                        // 如果没有退出地址，跳转到模拟统一登录页面
                        window.location.href = '/test-sso.html';
                    }
                }
                
                function cancel() {
                    window.history.back();
                }
            </script>
        </body>
        </html>
    `);
});

// 数据查询SQL
const table_show = `
SELECT
    left(sys_article.village_code,6) as "区代码",
    sys_organization.name AS "街道",
    pt_pro_cq_type.name AS "项目类别", 
    sum(sys_article.amount) AS "成交金额",
    sum((SELECT count(pt_pro_tenders.pro_id) 
     from pt_pro_tenders 
     WHERE pt_pro_tenders.pro_id=sys_article.pro_id AND 
        pt_pro_tenders.status NOT IN (0,12) AND 
        pt_pro_tenders.loss_tenders_reason is NULL)) AS "成交笔数"
FROM
    sys_article
    LEFT JOIN
    (
        SELECT
            pt_pro_tenders.pro_id
        FROM
            pt_pro_tenders
        WHERE
            pt_pro_tenders.status <> 0 
        GROUP BY
            pt_pro_tenders.pro_id
    ) AS pt_pro_tenders
    ON 
        sys_article.pro_id = pt_pro_tenders.pro_id
    LEFT JOIN
    (
        SELECT
            *
        FROM
            pt_pro_cq_type
        WHERE
            pt_pro_cq_type.pid=0
    ) AS pt_pro_cq_type
    ON 
        sys_article.pro_type = pt_pro_cq_type.code
  left JOIN
  (
   SELECT 
    sys_organization.code,sys_organization.name,sys_organization.pid
   FROM
    sys_organization
   WHERE
    (LENGTH(sys_organization.code)=9 or 
    LENGTH(sys_organization.code)=6) AND
    sys_organization.code like '6101%'
  ) as sys_organization
  ON
   left(sys_article.village_code,9)=sys_organization.code
WHERE
    sys_article.article_title LIKE '%成交公示' AND
   sys_article.village_code like '6101%' 
GROUP BY
 left(sys_article.village_code,6) ,
 left(sys_article.village_code,9), 
 sys_organization.name,
 pt_pro_cq_type.name
 ORDER BY left(sys_article.village_code,6)
`;

// 启动服务器
const server = app.listen(port, () => {
    console.log(`SSO测试路径: http://localhost:${port}/test-sso.html`);
    console.log(`服务器运行在 http://localhost:${port}`);
    console.log(`SSO拦截页面: http://localhost:${port}/sso/index.html`);
    console.log(`主页面: http://localhost:${port}/index-test2.html`);
});

// WebSocket服务器
const wss = new WebSocket.Server({ server });

const dbConnectTime = new Date(); //记录数据库连接时间
let cachedResults = null; //缓存数据
let lastPushTime = null; //缓存上一次推送时间

//服务器启动时立即查询一次数据并缓存
function fetchAndCacheDataAndPush() {
    db.query(table_show, (err, results) => {
        if (err) {
            console.log("Query failed", err.message);
            return;
        }
        cachedResults = results;
        lastPushTime = new Date();
        console.log('定时/首次SQL查询成功，缓存记录数:', results.length);
        //输出下次推送时间
        const now = new Date();
        const next = new Date(now.getTime() + 60 * 60 * 1000);
        const pad = n => n.toString().padStart(2, '0');
        console.log(`下次推送时间为: ${pad(next.getHours())}:${pad(next.getMinutes())}:${pad(next.getSeconds())}`);
        //推送时带上上一次推送时间
        const payload = {
            data: results,
            dbConnectTime: lastPushTime.toISOString()
        };
        wss.clients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(JSON.stringify(payload));
            }
        });
    });
}

//启动时立即拉取一次
fetchAndCacheDataAndPush();

//每小时定时推送
setInterval(fetchAndCacheDataAndPush, 60 * 60 * 1000);

wss.on('connection', (ws) => {
    console.log('客户端连接');
    //新的连接只推送缓存数据
    if (cachedResults && lastPushTime) {
        //推送时附上一次推送时间
        const payload = {
            data: cachedResults,
            dbConnectTime: lastPushTime.toISOString()
        };
        ws.send(JSON.stringify(payload));
    }
    ws.on('close', () => {
        console.log('客户端断开连接');
    });
});

// 错误处理
process.on('uncaughtException', (err) => {
    console.error('未捕获的异常:', err);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('未处理的Promise拒绝:', reason);
}); 