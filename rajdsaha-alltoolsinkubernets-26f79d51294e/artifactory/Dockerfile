From centos:centos7
USER root
RUN yum update -y && yum install java wget zip unzip -y
RUN wget https://bintray.com/jfrog/artifactory-pro-rpms/rpm -O bintray-jfrog-artifactory-pro-rpms.repo
RUN mv bintray-jfrog-artifactory-pro-rpms.repo /etc/yum.repos.d/
RUN yum install jfrog-artifactory-pro-5.3.1 -y

#RUN systemctl enable artifactory.service

RUN usermod -a -G root artifactory
COPY license.json /home/license.json 
COPY webserver.json /home/webserver.json
WORKDIR /home/

RUN nohup bash -c "/opt/jfrog/artifactory/bin/artifactory.sh 2>&1 &" && sleep 40s && curl -u admin:password -X POST -H "Content-Type:application/json" -d @license.json http://localhost:8081/artifactory/api/system/license &&  curl -u admin:password -H "Content-Type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -X PUT --data "{\"rclass\" : \"local\",\"packageType\": \"docker\"}" http://localhost:8081/artifactory/api/repositories/docker-dev && curl -u admin:password -X POST -H "Content-Type:application/json" -d @webserver.json http://localhost:8081/artifactory/api/system/configuration/webServer

CMD ["/opt/jfrog/artifactory/bin/artifactory.sh"]
