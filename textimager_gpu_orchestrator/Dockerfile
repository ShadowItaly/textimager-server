FROM nvidia/cuda:11.2.0-devel-ubuntu20.04
# install needed software
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests make gcc net-tools openssh-server less dnsutils vim

# add local ducc user
RUN useradd -m ducc -s /bin/bash -d /home/ducc

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl unzip python3 python3-pip
RUN pip3 install --upgrade pip

RUN pip3 install wheel setuptools
RUN pip3 install cython docker

RUN pip3 install torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html

COPY . .
CMD [ "python3", "./main.py" ]
