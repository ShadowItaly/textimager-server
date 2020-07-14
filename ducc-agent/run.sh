#!/bin/sh

# finishes the initialization of DUCC agent and starts it
echo "ducc head host: $TI_DOCKER_HEAD_HOST"
echo "ducc head ip: $TI_DOCKER_HEAD_IP"
echo "ducc head port: $TI_DOCKER_HEAD_PORT"
echo "ducc agent host: $TI_DOCKER_AGENT_HOST"
echo "ducc agent ip: $TI_DOCKER_AGENT_IP"
echo "ducc agent port: $TI_DOCKER_AGENT_PORT"

# ssh
service ssh start

# allow login with this key
cp /home/ducc/.ssh/id_rsa.pub /home/ducc/.ssh/authorized_keys

# disable required user input at first connect
echo "StrictHostKeyChecking=no" > /home/ducc/.ssh/config

# add head node to local ssh config to enable login on different port
echo "Host $TI_DOCKER_HEAD_HOST" >> /home/ducc/.ssh/config
echo "    HostName $TI_DOCKER_HEAD_IP" >> /home/ducc/.ssh/config
echo "    Port $TI_DOCKER_HEAD_PORT" >> /home/ducc/.ssh/config
echo "    IdentityFile ~/.ssh/id_rsa" >> /home/ducc/.ssh/config

# modify access rights
chmod 700 /home/ducc/.ssh
chmod 600 /home/ducc/.ssh/id_rsa
chmod +r /home/ducc/.ssh/id_rsa.pub
chown -Rf ducc.ducc /home/ducc/.ssh/

# use the same key for root user
cp -Rf /home/ducc/.ssh/ /root/
chown -Rf root.root /root/.ssh/

# add head node ip to local hosts file
# TODO better manage with docker parameter?
echo $TI_DOCKER_HEAD_IP $TI_DOCKER_HEAD_HOST >> /etc/hosts

# add this agent to head
su - root -c "ssh -p $TI_DOCKER_HEAD_PORT root@$TI_DOCKER_HEAD_IP 'bash /home/ducc/ducc/add-node.sh $TI_DOCKER_AGENT_HOST $TI_DOCKER_AGENT_IP $TI_DOCKER_AGENT_PORT'"

# daemonize Docker container
while true; do sleep 1; done
