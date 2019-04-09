FROM jenkins/jenkins:2.73.2
USER root
RUN apt-get update \
    && apt-get -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

# docker repos
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" >> /etc/apt/sources.list.d/additional-repositories.list \
    && echo "deb http://ftp-stud.hs-esslingen.de/ubuntu xenial main restricted universe multiverse" >> /etc/apt/sources.list.d/official-package-repositories.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 437D05B5 \
    && apt-get update

# docker
RUN apt-get -y install docker-ce
RUN usermod -aG docker jenkins
USER jenkins
ENV JAVA_OPTS="-Dhudson.Main.development=true -Djenkins.install.runSetupWizard=false"
RUN /usr/local/bin/install-plugins.sh matrix-auth job-dsl git maven-plugin artifactory kubernetes kubernetes-cd parameterized-trigger
USER root
COPY *.xml /var/jenkins_home/
COPY hudson.util.Secret /var/jenkins_home/secrets/
COPY master.key /var/jenkins_home/secrets/
COPY config /home/config
#RUN chmod -R 777 /var/jenkins_home/secrets/
#RUN chmod 766 /var/jenkins_home/secrets/hudson.util.Secret
#ADD setuser.groovy /var/jenkins_home/init.groovy.d/
#ADD setmatrix.groovy /var/jenkins_home/init.groovy.d/
#ADD jobs.groovy /var/jenkins_home/
#ADD create-job.groovy /var/jenkins_home/init.groovy.d/
#RUN chown jenkins:jenkins *.groovy
#RUN cp *.groovy /var/jenkins_home/init.groovy.d/
COPY *.groovy /var/jenkins_home/init.groovy.d/
USER jenkins
