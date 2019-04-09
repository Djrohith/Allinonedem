docker build -t raj/ansible:1.0 .
docker run -d --name ansible-tower -p 8443:443 raj/ansible:1.0
Ansible-tower can be accessed at https://<IP>:8443
Username/password - admin/password
