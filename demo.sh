#!/bin/bash

# DashBoard SSO 功能演示脚本

echo "🎉 DashBoard 统一登录集成演示"
echo "=================================="
echo ""

# 检查服务是否运行
echo "🔍 检查服务状态..."
if curl -s http://localhost:3000/ > /dev/null; then
    echo "✅ 服务正在运行"
else
    echo "❌ 服务未运行，请先启动服务："
    echo "   node app.js"
    echo ""
    exit 1
fi

echo ""
echo "📋 功能演示清单："
echo "1. 模拟统一登录系统"
echo "2. SSO跳转和验证"
echo "3. 用户信息显示"
echo "4. 退出登录功能"
echo "5. 接口测试"
echo ""

echo "🌐 访问地址："
echo "   模拟统一登录: http://localhost:3000/test-sso.html"
echo "   主页面: http://localhost:3000/index-test2.html"
echo "   SSO拦截页面: http://localhost:3000/sso/index.html"
echo "   退出页面: http://localhost:3000/logout"
echo ""

echo "🧪 接口测试："
echo "   运行: node test-sso.js"
echo ""

echo "📚 文档："
echo "   详细说明: README-SSO.md"
echo "   项目总结: PROJECT_SUMMARY.md"
echo ""

echo "🚀 开始演示："
echo "   1. 打开浏览器访问: http://localhost:3000/test-sso.html"
echo "   2. 点击'数据可视化平台'模块"
echo "   3. 观察SSO验证和跳转过程"
echo "   4. 查看主页面右上角的用户信息"
echo "   5. 测试退出登录功能"
echo ""

echo "✨ 演示完成！"
echo ""
echo "💡 提示："
echo "   - 这是一个完整的SSO集成演示"
echo "   - 所有功能都按照文档要求实现"
echo "   - 支持生产环境部署"
echo "   - 包含完整的测试和文档" 