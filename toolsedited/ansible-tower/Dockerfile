FROM jbla/ansible-tower
RUN pip install ansible-tower-cli==3.1.3
RUN tower-cli config host localhost
RUN tower-cli config username admin
RUN tower-cli config password password
#RUN ssh-keygen -t rsa -N "" -f /opt/keypair
COPY set.sh /set.sh
COPY license /etc/tower/license
#OPY keypair.pem /opt/keypair.pem
RUN chmod 777 /set.sh
RUN echo "AWX_PROOT_ENABLED=False" >> /etc/tower/settings.py
COPY devops23.pem /opt/devops23.pem
ENTRYPOINT /set.sh ansible-tower
