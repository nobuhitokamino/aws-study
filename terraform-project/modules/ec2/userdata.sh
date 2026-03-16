#!/bin/bash

# ログ出力
exec > /var/log/userdata.log 2>&1
set -x

echo "=== START USERDATA ==="

dnf update -y
dnf install git -y
dnf install java-21-amazon-corretto-devel -y

dnf install https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm -y
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
dnf install mysql mysql-community-client -y

cd /home/ec2-user

echo "Clone repository"
git clone https://github.com/koujienami/aws-study.git

chown -R ec2-user:ec2-user aws-study
cd aws-study
chmod +x gradlew

PROPERTIES_FILE="src/main/resources/application.properties"

sed -i "s|spring.datasource.url=.*|spring.datasource.url=jdbc:mysql://${rds_endpoint}:3306/awsstudy|" $PROPERTIES_FILE
sed -i "s|spring.datasource.username=.*|spring.datasource.username=${db_username}|" $PROPERTIES_FILE
sed -i "s|spring.datasource.password=.*|spring.datasource.password=${db_password}|" $PROPERTIES_FILE

# sleep 30
echo "Waiting for RDS..."

# until mysql -h ${rds_endpoint} -u ${db_username} -p${db_password} -e "SELECT 1" >/dev/null 2>&1; do

# 最大10分待つ
for i in {1..60}; do
  if mysql -h ${rds_endpoint} -u ${db_username} -p${db_password} -e "SELECT 1" >/dev/null 2>&1; then
    echo "RDS is ready"
    break
  fi

  echo "RDS not ready yet..."
  sleep 10
done

echo "Create database"

mysql -h ${rds_endpoint} -u ${db_username} -p${db_password} <<EOF
CREATE DATABASE IF NOT EXISTS awsstudy;
USE awsstudy;
CREATE TABLE IF NOT EXISTS student (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL
);
INSERT INTO student (name) VALUES ('Kouji Enami');
EOF

# ./gradlew bootRun > /var/log/app.log 2>&1 &

# -------------------------
# systemd service 作成
# -------------------------
echo "Create systemd service"

cat <<'EOF' > /etc/systemd/system/springboot.service
[Unit]
Description=Spring Boot Application
After=network-online.target
Wants=network-online.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/aws-study
ExecStart=/home/ec2-user/aws-study/gradlew bootRun
Restart=always
RestartSec=10
StandardOutput=append:/var/log/app.log
StandardError=append:/var/log/app.log

[Install]
WantedBy=multi-user.target
EOF

# systemd 設定反映
systemctl daemon-reload

# 自動起動設定
systemctl enable springboot

# サービス起動
systemctl start springboot

echo "Waiting for SpringBoot..."

# SpringBoot起動待機（ALB対策）
for i in {1..60}; do
  if curl -s http://localhost:8080 >/dev/null; then
    echo "SpringBoot started"
    break
  fi

  echo "SpringBoot not ready yet..."
  sleep 5
done

echo "=== USERDATA FINISHED ==="