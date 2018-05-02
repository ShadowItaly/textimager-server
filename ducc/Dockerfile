FROM java


RUN apt-get update && apt-get install -y make gcc net-tools openssh-server less


# UIMA DUCC preparation
# Installation of UIMA DUCC implemented in run.sh script
# because for some reasons Docker doesnt allow unprivileged user to 
# do any changes with files had 600 permissions during image creation
# For example ./admin/ and ./resources.private/ not accesable by ducc user
RUN useradd -m ducc -s /bin/bash
RUN mkdir /home/ducc/.ssh/
COPY ./id_rsa* /home/ducc/.ssh/

RUN wget http://artfiles.org/apache.org//uima//uima-ducc-2.2.2/uima-ducc-2.2.2-bin.tar.gz -P /home/ducc
COPY ./run.sh /home/ducc/apache-uima-ducc/
COPY ./activemq-ducc.xml /home/ducc/
COPY ./DUCCServiceCreator.jar /home/ducc/

USER root
CMD /home/ducc/apache-uima-ducc/run.sh >> /home/ducc/ducc_startup.log
