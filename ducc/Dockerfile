# Dockerfile to set up Apache UIMA DUCC head node
# most of installation of UIMA DUCC deferred to run.sh script
#  see https://github.com/aleksey-hariton/uima-ducc-docker/blob/master/ducc-head/Dockerfile

FROM openjdk:8-jdk

# install needed software
RUN apt-get update && apt-get install -y make gcc net-tools openssh-server less dnsutils vim

# add ducc user
RUN useradd -m ducc -s /bin/bash

# copy ssh key
# TODO this needs to be the same for head node and agents at the moment
COPY ./id_rsa* /home/ducc/.ssh/

# allow login using this key
RUN cp /home/ducc/.ssh/id_rsa.pub /home/ducc/.ssh/authorized_keys

# disable required user input at first connect
RUN echo "StrictHostKeyChecking=no" > /home/ducc/.ssh/config

# modify access rights
#RUN chmod 700 /home/ducc/.ssh
#RUN chmod 600 /home/ducc/.ssh/id_rsa
#RUN chmod +r /home/ducc/.ssh/id_rsa.pub

# use the same key for root user
RUN cp -Rf /home/ducc/.ssh/ /root/
RUN chown -Rf root.root /root/.ssh/

# continue rest of installation as ducc user
USER ducc
RUN mkdir /home/ducc/ducc/
RUN mkdir /home/ducc/ducc/apache-uima-ducc/

# download and unpack uima ducc
RUN wget http://ftp.halifax.rwth-aachen.de/apache/uima/uima-ducc-3.0.0/uima-ducc-3.0.0-bin.tar.gz -P /home/ducc
RUN cd /home/ducc/ && tar xzf uima-ducc-3.0.0-bin.tar.gz --strip=1 -C /home/ducc/ducc/apache-uima-ducc/

# allow anonymous login to DUCC
# TODO modify in future release
COPY ./activemq-ducc.xml /home/ducc/ducc/apache-uima-ducc/apache-uima/apache-activemq/conf/activemq-ducc.xml

# add modified ducc.py to enable fake memory limits in resources/ducc.memory_limits
COPY ./ducc_3.0.0.py /home/ducc/ducc/apache-uima-ducc/admin/ducc.py

# add-node script: adds a new node to the DUCC head
COPY ./add-node.sh /home/ducc/ducc/

# tool to generate service data
COPY ./DUCCServiceCreator.jar /home/ducc/ducc/

# basic test services
# TODO remove later
COPY ./serviceScripts /home/ducc/ducc/serviceScripts/
COPY ./texte /home/ducc/ducc/texte/
COPY ./testService/textimager-uima-deploy-0.2.6-mini-deploy.jar /home/ducc/ducc/jars/textimager-uima-deploy-0.2.6-mini-deploy.jar

# TODO ducc_ling
#chown root.ducc /home/ducc/apache-uima-ducc/admin/ducc_ling
#chmod 700 /home/ducc/apache-uima-ducc/admin/
#chmod 4750 /home/ducc/apache-uima-ducc/admin/ducc_ling

# ducc head hostname / ip
ENV TI_DOCKER_HEAD_HOST "textimager-server-head"
ENV TI_DOCKER_HEAD_IP "1.2.3.4"

# run script: finishes initialization and starts DUCC
COPY ./run.sh /home/ducc/

USER root
RUN chown -Rf ducc.ducc /home/ducc/
CMD ["/bin/bash", "/home/ducc/run.sh"]
