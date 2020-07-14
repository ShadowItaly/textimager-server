# Dockerfile to set up Apache UIMA DUCC head node
# most of installation of UIMA DUCC deferred to run.sh script
#  see https://github.com/aleksey-hariton/uima-ducc-docker/blob/master/ducc-head/Dockerfile

FROM openjdk:8-jdk

# install needed software
RUN apt-get update && apt-get install -y make gcc net-tools openssh-server less dnsutils vim

# add ducc user
RUN useradd -m ducc -s /bin/bash

# download uima ducc
RUN wget http://ftp.halifax.rwth-aachen.de/apache/uima/uima-ducc-3.0.0/uima-ducc-3.0.0-bin.tar.gz -P /home/ducc

# copy ssh key
# TODO this needs to be the same for head node and agents at the moment
RUN mkdir /home/ducc/.ssh/
COPY ./id_rsa* /home/ducc/.ssh/

# run script: finishes initialization and starts DUCC head
COPY ./run.sh /home/ducc/

# modified to allow anonymous login to DUCC
# TODO modify in future release
COPY ./activemq-ducc.xml /home/ducc/

# add-node script: adds a new node to the DUCC head
COPY ./add-node.sh /home/ducc/

# tool to generate service data
COPY ./DUCCServiceCreator.jar /home/ducc/

# basic test services
# TODO remove later
COPY ./serviceScripts /home/ducc/serviceScripts/
COPY ./testService/textimager-uima-deploy-0.2.6-mini-deploy.jar /home/ducc/jars/textimager-uima-deploy-0.2.6-mini-deploy.jar

# initialize
USER root
CMD /home/ducc/run.sh
