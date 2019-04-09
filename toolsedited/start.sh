#!/bin/bash -ex
yum install docker git python-pip -y
service docker start
pip install docker-py
touch /etc/docker/daemon.json
cat >/etc/docker/daemon.json <<EOL
{
  "insecure-registries" : ["$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4):8088"]
}
EOL
service docker restart
usermod -aG docker ec2-user
docker build -t cicdpipeline/jenkins:1.0 jenkins/
docker run -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock --name jenkins cicdpipeline/jenkins:1.0
docker build -t cicdpipeline/artifactory:1.0 artifactory/
docker build -t cicdpipeline/nginx:1.0 -f artifactory/nginx-docker artifactory/
docker run -d --name arti -p 8081:8081 cicdpipeline/artifactory:1.0
docker run -d --name nginx -p 80:80 -p 443:443 -p 8088:8088 cicdpipeline/nginx:1.0
docker build -t cicdpipeline/ansible:1.0 ansible-tower/
docker run -d --name ansible-tower -p 8443:443 cicdpipeline/ansible:1.0
sleep 8
docker cp ansible-tower:/opt/keypair.pub /home/ec2-user/.ssh/
cat /home/ec2-user/.ssh/keypair.pub >> /home/ec2-user/.ssh/authorized_keys
