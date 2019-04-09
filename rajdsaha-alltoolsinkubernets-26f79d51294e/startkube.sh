#!/bin/bash -ex
yum install docker -y  
service docker start
kubectl create -f templates/artifactory-rs.yml
kubectl create -f templates/artifactory-service.yml
sed -i s/nodeip/$(kubectl get nodes | grep node | awk {'print $1'} | grep -o -P '(?<=ip-).*$' | awk -F . {'print $1'} | sed s/-/./g)/g artifactory/nginx-file
docker login --username cicdpipeline --password entersys1
docker build -t cicdpipeline/nginx:4.0 -f artifactory/nginx-file artifactory/
docker push cicdpipeline/nginx:4.0
kubectl create -f templates/nginx-rs.yml
kubectl create -f templates/nginx-service.yml
sleep 50
sed -i s/nodeip/$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=nodes.devops23.k8s.local" | jq -r '.Reservations[0].Instances[0].PublicIpAddress')/g inventory
/usr/local/bin/ansible-playbook -i inventory start.yml
sed -i s/nip/$(kubectl get nodes | grep node | awk {'print $1'} | grep -o -P '(?<=ip-).*$' | awk -F . {'print $1'} | sed s/-/./g)/g templates/jenkins-rs.yml
sed -i s/ndns/$(kubectl get svc | grep nginx | awk '{print $4}')/g templates/jenkins-rs.yml
kubectl create -f templates/jenkins-rs.yml
kubectl create -f templates/jenkins-service.yml
sed -i s/masterip/$(kubectl get nodes | grep master | awk {'print $1'} | grep -o -P '(?<=ip-).*$' | awk -F . {'print $1'}| sed s/-/./g | head -n 1)/g ansible-tower/set.sh
cp ../devops23.pem ansible-tower/
docker build -t cicdpipeline/ansible:2.0 ansible-tower/
docker push cicdpipeline/ansible:2.0
kubectl create -f templates/ansible-rs.yml
kubectl create -f templates/ansible-service.yml
