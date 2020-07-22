#!/bin/bash

# finishes the initialization of DUCC agent and starts it
echo "ducc head host: $TI_DOCKER_HEAD_HOST"
echo "ducc head ip: $TI_DOCKER_HEAD_IP"
echo "ducc head port: $TI_DOCKER_HEAD_PORT"
echo "ducc agent host: $TI_DOCKER_AGENT_HOST"
echo "ducc agent ip: $TI_DOCKER_AGENT_IP"
echo "ducc agent port: $TI_DOCKER_AGENT_PORT"
echo "ducc agent memory limit: $TI_DOCKER_AGENT_MEMORY_LIMIT"

# ssh
service ssh start

DUCC_AGENT_INSTALLED="/home/ducc/.ducc_agent_installed"
if [ ! -e $DUCC_AGENT_INSTALLED ]; then
	echo "installing ducc agent..."
	
	# add head node ip to local hosts file
	# TODO better manage with docker parameter?
	echo $TI_DOCKER_HEAD_IP $TI_DOCKER_HEAD_HOST >> /etc/hosts
	#echo $TI_DOCKER_AGENT_IP $TI_DOCKER_AGENT_HOST >> /etc/hosts
	
	# remove own local docker ip and replace with external
	#sed --in-place=backup "s/${TI_DOCKER_AGENT_HOST}/d" /etc/hosts
	#echo $TI_DOCKER_AGENT_IP $TI_DOCKER_AGENT_HOST >> /etc/hosts
	
	# add head node to local ssh config to enable login on different port
	echo "Host $TI_DOCKER_HEAD_HOST" >> /home/ducc/.ssh/config
	echo "    HostName $TI_DOCKER_HEAD_IP" >> /home/ducc/.ssh/config
	echo "    Port $TI_DOCKER_HEAD_PORT" >> /home/ducc/.ssh/config
	echo "    IdentityFile ~/.ssh/id_rsa" >> /home/ducc/.ssh/config
	chown -Rf ducc.ducc /home/ducc/.ssh/

	# mount shared folder using sshfs
	su - ducc -c "mkdir -p /home/ducc/ducc"
	su - ducc -c "sshfs ducc@$TI_DOCKER_HEAD_HOST:/home/ducc/ducc /home/ducc/ducc"

	# add this agent to head
	ssh -p $TI_DOCKER_HEAD_PORT root@$TI_DOCKER_HEAD_IP "bash /home/ducc/ducc/add-node.sh $TI_DOCKER_AGENT_HOST $TI_DOCKER_AGENT_IP $TI_DOCKER_AGENT_PORT $TI_DOCKER_AGENT_MEMORY_LIMIT"
	
	touch $DUCC_AGENT_INSTALLED
else
	echo "ducc agent already installed"
fi

# daemonize Docker container
while true; do sleep 1; done
