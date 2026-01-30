#!/bin/bash

# ========= 配置区 =========
CF_API="https://api.xxx.cfapps.sap.hana.ondemand.com"
CF_USERNAME="your_email@example.com"
CF_PASSWORD="your_password"
CF_ORG="your_org"
CF_SPACE="your_space"
CF_APP="your_app_name"
# ==========================

LOG_FILE="/root/cf_keepalive.log"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "[$DATE] 开始检查 CF 应用状态" >> $LOG_FILE

# 设置 API 并登录
cf api "$CF_API" >> $LOG_FILE 2>&1
cf login -u "$CF_USERNAME" -p "$CF_PASSWORD" -o "$CF_ORG" -s "$CF_SPACE" >> $LOG_FILE 2>&1

# 设置健康检查（防止 SAP 休眠）
cf set-health-check "$CF_APP" process >> $LOG_FILE 2>&1

# 获取应用状态
STATUS=$(cf app "$CF_APP" | grep '#0' | awk '{print $2}')

echo "[$DATE] 当前状态: $STATUS" >> $LOG_FILE

if [ "$STATUS" != "running" ]; then
    echo "[$DATE] 应用未运行，执行 cf start" >> $LOG_FILE
    cf start "$CF_APP" >> $LOG_FILE 2>&1
else
    echo "[$DATE] 应用运行正常" >> $LOG_FILE
fi

echo "--------------------------------------" >> $LOG_FILE
