#!/bin/bash
set -e

yum update -y
amazon-linux-extras enable java-openjdk11
yum install -y java-11-openjdk wget tar ruby

# Tomcat 설치
cd /opt
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.107/bin/apache-tomcat-9.0.107.tar.gz
tar -xzf apache-tomcat-9.0.107.tar.gz
mv apache-tomcat-9.0.107 tomcat9
chmod -R +x /opt/tomcat9/bin
chown -R ec2-user:ec2-user /opt/tomcat9

# CodeDeploy Agent 설치
cd /home/ec2-user
wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
chmod +x ./install
./install auto
systemctl start codedeploy-agent
systemctl enable codedeploy-agent


# 로그 경로 확인용 디렉토리 생성
mkdir -p /opt/codedeploy-app
chown ec2-user:ec2-user /opt/codedeploy-app

