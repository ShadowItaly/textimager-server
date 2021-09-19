# Dockerfile to set up Apache UIMA DUCC agent
# most of installation of UIMA DUCC deferred to run.sh script
#  see https://github.com/aleksey-hariton/uima-ducc-docker/blob/master/ducc-head/Dockerfile

FROM nvidia/cuda:11.3.0-devel-ubuntu20.04
# install needed software
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests make gcc net-tools openssh-server less dnsutils vim

# add local ducc user
RUN useradd -m ducc -s /bin/bash -d /home/ducc

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl unzip python3 python3-pip
RUN pip3 install --upgrade pip

RUN pip3 install wheel setuptools
RUN pip3 install cython

RUN pip3 install torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;
    
# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# copy ssh key
# TODO this needs to be the same for head node and agents at the moment
COPY ./id_rsa* /home/ducc/.ssh/

# allow login using this key
RUN cp /home/ducc/.ssh/id_rsa.pub /home/ducc/.ssh/authorized_keys

# disable required user input at first connect
RUN echo "StrictHostKeyChecking=no" > /home/ducc/.ssh/config

# use the same key for root user
RUN cp -Rf /home/ducc/.ssh/ /root/
RUN chown -Rf root.root /root/.ssh/

# env vars needed by the agent:
# hostname of the DUCC head node
ENV TI_DOCKER_HEAD_HOST "textimager-server"
# memory limit
ENV TI_DOCKER_AGENT_MEMORY_LIMIT="1"

# run script: finishes initialization and starts DUCC agent
COPY ./run.sh /home/ducc/

# set permission of copied files
RUN chown -Rf ducc.ducc /home/ducc/

CMD ["/bin/bash", "/home/ducc/run.sh"]
