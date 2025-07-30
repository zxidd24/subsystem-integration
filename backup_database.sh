#!/bin/bash

# 数据库备份脚本
# 使用方法: ./backup_database.sh [数据库名]

DB_NAME=${1:-my_database}
BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_backup_${TIMESTAMP}.sql"

echo "开始备份数据库: $DB_NAME"
echo "备份文件: $BACKUP_FILE"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 备份数据库
mysqldump -u root -pRoot@123456 "$DB_NAME" > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "数据库备份成功！"
    echo "备份文件大小: $(du -h "$BACKUP_FILE" | cut -f1)"
    echo "备份文件位置: $BACKUP_FILE"
else
    echo "数据库备份失败！"
    exit 1
fi

# 显示最近的备份文件
echo ""
echo "最近的备份文件:"
ls -la "$BACKUP_DIR"/*.sql 2>/dev/null | tail -5 