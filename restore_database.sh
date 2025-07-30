#!/bin/bash

# 数据库恢复脚本
# 使用方法: ./restore_database.sh [数据库名] [备份文件路径]

DB_NAME=${1:-my_database}
BACKUP_FILE=${2:-backups/my_database_backup_20250714_103019.sql}

echo "开始恢复数据库: $DB_NAME"
echo "备份文件: $BACKUP_FILE"

# 检查备份文件是否存在
if [ ! -f "$BACKUP_FILE" ]; then
    echo "错误: 备份文件 $BACKUP_FILE 不存在"
    echo "可用的备份文件:"
    ls -la backups/*.sql 2>/dev/null || echo "没有找到备份文件"
    exit 1
fi

# 确认操作
echo "警告: 这将覆盖数据库 $DB_NAME 中的所有数据！"
read -p "确定要继续吗？(y/N): " confirm

if [[ $confirm != [yY] ]]; then
    echo "操作已取消"
    exit 0
fi

# 恢复数据库
mysql -u root -pRoot@123456 "$DB_NAME" < "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "数据库恢复成功！"
    echo "恢复文件: $BACKUP_FILE"
    
    # 显示恢复后的表
    echo ""
    echo "恢复后的表:"
    mysql -u root -pRoot@123456 "$DB_NAME" -e "SHOW TABLES;"
else
    echo "数据库恢复失败！"
    exit 1
fi 