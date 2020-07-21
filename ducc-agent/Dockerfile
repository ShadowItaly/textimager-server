# Dockerfile to set up Apache UIMA DUCC agent
# most of installation of UIMA DUCC deferred to run.sh script
#  see https://github.com/aleksey-hariton/uima-ducc-docker/blob/master/ducc-head/Dockerfile

FROM openjdk:8-jdk

# install needed software
RUN apt-get update && apt-get install -y make gcc net-tools openssh-server less dnsutils vim sshfs

# add local ducc user
RUN useradd -m ducc -s /bin/bash -d /home/ducc

# copy ssh key
# TODO this needs to be the same for head node and agents at the moment
COPY ./id_rsa* /home/ducc/.ssh/

# allow login using this key
RUN cp /home/ducc/.ssh/id_rsa.pub /home/ducc/.ssh/authorized_keys

# disable required user input at first connect
RUN echo "StrictHostKeyChecking=no" > /home/ducc/.ssh/config

# modify access rights
RUN chmod 700 /home/ducc/.ssh
RUN chmod 600 /home/ducc/.ssh/id_rsa
RUN chmod +r /home/ducc/.ssh/id_rsa.pub
RUN chown -Rf ducc.ducc /home/ducc/.ssh/

# use the same key for root user
RUN cp -Rf /home/ducc/.ssh/ /root/
RUN chown -Rf root.root /root/.ssh/

# env vars needed by the agent
# some of these will be automatically filled in by the "add-agent.sh" script
# hostname of the DUCC head node
ENV TI_DOCKER_HEAD_HOST "textimager-server-head"
# ip of the DUCC head node
ENV TI_DOCKER_HEAD_IP "1.2.3.4"
# ssh port of the DUCC head node
ENV TI_DOCKER_HEAD_PORT "2222"
# hostname of this DUCC agent
ENV TI_DOCKER_AGENT_HOST "textimager-agent-1"
# ip of this DUCC agent
ENV TI_DOCKER_AGENT_IP "1.2.3.4"
# ssh port of this DUCC agent
ENV TI_DOCKER_AGENT_PORT "2223"
# memory limit
ENV TI_DOCKER_AGENT_MEMORY_LIMIT="1"

# run script: finishes initialization and starts DUCC agent
COPY ./run.sh /home/ducc/

# initialize
USER root
CMD /home/ducc/run.sh
