#!/bin/bash

# MySQL数据库执行脚本
# 使用方法: ./run_sql.sh [数据库名] [SQL文件路径]

DB_NAME=${1:-my_database}
SQL_FILE=${2:-sql_files/example.sql}

echo "正在执行SQL文件: $SQL_FILE"
echo "目标数据库: $DB_NAME"

# 检查SQL文件是否存在
if [ ! -f "$SQL_FILE" ]; then
    echo "错误: SQL文件 $SQL_FILE 不存在"
    exit 1
fi

# 执行SQL文件
mysql -u root -pRoot@123456 "$DB_NAME" < "$SQL_FILE"

if [ $? -eq 0 ]; then
    echo "SQL文件执行成功！"
else
    echo "SQL文件执行失败！"
    exit 1
fi 