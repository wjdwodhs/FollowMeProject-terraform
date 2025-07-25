#!/bin/bash
set -e

# 시스템 업데이트 및 필수 패키지 설치
yum update -y
amazon-linux-extras enable java-openjdk11
amazon-linux-extras enable epel
yum install -y epel-release
yum install -y java-11-openjdk wget tar ruby jq aws-cli stress

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

# 로그 디렉토리 생성
mkdir -p /opt/codedeploy-app
chown ec2-user:ec2-user /opt/codedeploy-app

# CloudWatch Agent 설정 파일 생성
cat <<EOF > /opt/cloudwatch-config.json
{
  "metrics": {
    "append_dimensions": {
      "InstanceId": "\${aws:InstanceId}",
      "AutoScalingGroupName": "\${aws:AutoScalingGroupName}"
    },
    "namespace": "CWAgent",
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent",
          "mem_used",
          "mem_available",
          "mem_total"
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          "used_percent",
          "used",
          "total"
        ],
        "resources": ["/"],
        "metrics_collection_interval": 60
      },
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 60,
        "totalcpu": true
      }
    }
  }
}
EOF

# CloudWatch Agent 시작
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/cloudwatch-config.json \
  -s
