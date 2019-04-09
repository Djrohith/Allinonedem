docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

docker run -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock --name jenkins cicdpipeline/jenkins:1.0
docker run -d --name arti -p 8081:8081 cicdpipeline/artifactory:1.0
docker run -d --name nginx -p 80:80 -p 443:443 -p 8088:8088 cicdpipeline/nginx:1.0
docker run -d --name ansible-tower -p 8443:443 cicdpipeline/ansible:1.0

