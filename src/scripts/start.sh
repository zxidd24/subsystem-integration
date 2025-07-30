#!/bin/bash

# DashBoard SSO 启动脚本

echo "🚀 启动 DashBoard SSO 系统..."

# 检查Node.js是否安装
if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安装，请先安装 Node.js"
    exit 1
fi

# 检查npm是否安装
if ! command -v npm &> /dev/null; then
    echo "❌ npm 未安装，请先安装 npm"
    exit 1
fi

# 检查MySQL是否运行
echo "🔍 检查MySQL连接..."
if ! mysql -h localhost -u root -pRoot@123456 -e "SELECT 1;" &> /dev/null; then
    echo "⚠️  MySQL连接失败，请确保MySQL服务正在运行"
    echo "   数据库配置: localhost:3306, 用户: root, 密码: Root@123456"
    echo "   如果配置不同，请修改相关配置文件"
fi

# 安装依赖
echo "📦 安装项目依赖..."
npm install

# 检查是否需要初始化数据库
echo "🗄️  检查数据库表结构..."
if mysql -h localhost -u root -pRoot@123456 -e "USE my_database; SHOW TABLES LIKE 'sys_role';" 2>/dev/null | grep -q "sys_role"; then
    echo "✅ 数据库表已存在"
else
    echo "📋 初始化数据库表结构..."
    if [ -f "src/database/create_sys_role_table.sql" ]; then
        mysql -h localhost -u root -pRoot@123456 my_database < src/database/create_sys_role_table.sql
        echo "✅ 数据库表初始化完成"
    else
        echo "❌ 数据库初始化脚本不存在: src/database/create_sys_role_table.sql"
    fi
fi

# 启动服务
echo "🌐 启动Web服务..."
echo "   主页面: http://localhost:3000/components/index-test2.html"
echo "   SSO拦截页面: http://localhost:3000/sso/index.html"
echo "   退出页面: http://localhost:3000/logout"
echo ""
echo "按 Ctrl+C 停止服务"
echo ""

# 启动应用
node src/server/app.js 