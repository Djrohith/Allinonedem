docker build -t raj/jenkins:1.0 .
docker run -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock --name jenkins raj/jenkins:1.0
jenkins can be accessed at http://<IP>:8080
username/password - admin/admin

