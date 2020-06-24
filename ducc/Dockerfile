FROM openjdk:8-jdk


RUN apt-get update && apt-get install -y make gcc net-tools openssh-server less dnsutils


# UIMA DUCC preparation
# Installation of UIMA DUCC implemented in run.sh script
# because for some reasons Docker doesnt allow unprivileged user to 
# do any changes with files had 600 permissions during image creation
# For example ./admin/ and ./resources.private/ not accesable by ducc user
RUN useradd -m ducc -s /bin/bash
RUN mkdir /home/ducc/.ssh/
COPY ./id_rsa* /home/ducc/.ssh/

RUN wget http://ftp.halifax.rwth-aachen.de/apache//uima//uima-ducc-3.0.0/uima-ducc-3.0.0-bin.tar.gz -P /home/ducc
COPY ./run.sh /home/ducc/apache-uima-ducc/
COPY ./activemq-ducc.xml /home/ducc/
COPY ./DUCCServiceCreator.jar /home/ducc/
COPY ./serviceScripts /home/ducc/serviceScripts
COPY ./testService/textimager-uima-deploy-0.2.6-mini-deploy.jar /home/ducc/apache-uima-ducc/jars/textimager-uima-deploy-0.2.6-mini-deploy.jar

USER root
CMD /home/ducc/apache-uima-ducc/run.sh >> /home/ducc/ducc_startup.log
