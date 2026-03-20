#!/bin/bash

# ログ出力
exec > /var/log/userdata.log 2>&1
set -x

echo "===== START USER DATA ====="

dnf update -y

echo "===== Create Swap ====="

fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

dnf install -y git
dnf install -y java-21-amazon-corretto-devel
dnf install -y curl

# MySQL client
dnf install https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm -y
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
dnf install -y mysql mysql-community-client

cd /home/ec2-user

echo "===== Clone Repository ====="

git clone https://github.com/koujienami/aws-study.git

chown -R ec2-user:ec2-user aws-study

cd aws-study

chmod +x gradlew

#echo "===== Build SpringBoot ====="

#./gradlew build -x test

echo "===== Configure application.properties ====="

PROPERTIES_FILE="src/main/resources/application.properties"

sed -i "s|spring.datasource.url=.*|spring.datasource.url=jdbc:mysql://${rds_endpoint}:3306/awsstudy|" $PROPERTIES_FILE
sed -i "s|spring.datasource.username=.*|spring.datasource.username=${db_username}|" $PROPERTIES_FILE
sed -i "s|spring.datasource.password=.*|spring.datasource.password=${db_password}|" $PROPERTIES_FILE

echo "===== Wait for RDS ====="

for i in {1..60}; do

  if mysql -h ${rds_endpoint} -u ${db_username} -p${db_password} -e "SELECT 1" >/dev/null 2>&1; then
    echo "RDS is ready"
    break
  fi

  echo "Waiting for RDS..."
  sleep 10

done

echo "===== Initialize Database ====="

mysql -h ${rds_endpoint} -u ${db_username} -p${db_password} <<EOF
CREATE DATABASE IF NOT EXISTS awsstudy;
USE awsstudy;
CREATE TABLE IF NOT EXISTS student (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL
);
INSERT INTO student (name) VALUES ('Kouji Enami');
EOF

echo "===== Create systemd service ====="

cat <<EOF > /etc/systemd/system/springboot.service
[Unit]
Description=Spring Boot Application
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/aws-study
ExecStart=/home/ec2-user/aws-study/gradlew bootRun
SuccessExitStatus=143
Restart=always
RestartSec=10
StandardOutput=append:/var/log/app.log
StandardError=append:/var/log/app.log

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable springboot
systemctl start springboot

sleep 20
echo "===== Wait for SpringBoot ====="

for i in {1..60}; do

  if curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "SpringBoot started"
    break
  fi

  echo "Waiting for SpringBoot..."
  sleep 5

done

echo "===== USER DATA FINISHED ====="