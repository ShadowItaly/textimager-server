# Dockerfile to set up Apache UIMA DUCC agent
# most of installation of UIMA DUCC deferred to run.sh script
#  see https://github.com/aleksey-hariton/uima-ducc-docker/blob/master/ducc-head/Dockerfile

FROM openjdk:8-jdk

# install needed software
RUN apt-get update && apt-get install -y make gcc net-tools openssh-server less dnsutils vim

# add local ducc user
RUN useradd -m ducc -s /bin/bash -d /home/ducc

# copy ssh key
# TODO this needs to be the same for head node and agents at the moment
RUN mkdir /home/ducc/.ssh/
COPY ./id_rsa* /home/ducc/.ssh/

# run script: finishes initialization and starts DUCC agent
COPY ./run.sh /home/ducc/

# env vars needed by the agent
# some of these will be automatically filled in by the "add-agent.sh" script
# hostname of the DUCC head node
ENV TI_DOCKER_HEAD_HOST "headtest"
# ip of the DUCC head node
ENV TI_DOCKER_HEAD_IP "127.0.0.1"
# ssh port of the DUCC head node
ENV TI_DOCKER_HEAD_PORT "2222"
# hostname of this DUCC agent
ENV TI_DOCKER_AGENT_HOST "agenttest"
# ip of this DUCC agent
ENV TI_DOCKER_AGENT_IP "127.0.0.1"
# ssh port of this DUCC agent
ENV TI_DOCKER_AGENT_PORT "2223"

# initialize
USER root
CMD /home/ducc/run.sh
