#!/bin/bash

set -e

# update ssh key access rights
chown -Rf ducc.ducc /home/ducc/.ssh
chmod 700 /home/ducc/.ssh
chmod 600 /home/ducc/.ssh/id_rsa
chmod 644 /home/ducc/.ssh/id_rsa.pub

chown -Rf root.root /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/id_rsa
chmod 644 /root/.ssh/id_rsa.pub

# ssh
service ssh start

DUCC_AGENT_INSTALLED="/home/ducc/.ducc_agent_installed"
if [ ! -e $DUCC_AGENT_INSTALLED ]; then
	# wait for ducc head to be installed...
	DUCC_INSTALLED="/home/ducc/ducc/.ducc_installed"
	echo "checking if ducc head is ready..."
	while [ ! -e $DUCC_INSTALLED ]
	do
		echo "waiting for ducc head to be ready..."
		sleep 30
	done
	sleep $[ ( $RANDOM % 30 )  + 1 ]s
	
	echo "installing ducc agent..."
	echo "ducc head host: $TI_DOCKER_HEAD_HOST"
	echo "ducc agent memory limit: $TI_DOCKER_AGENT_MEMORY_LIMIT"

	# add this agent to head
	LOCAL_HOSTNAME=$(hostname)
	su - ducc -c "ssh ducc@$TI_DOCKER_HEAD_HOST \"bash /home/ducc/ducc/add-node.sh $LOCAL_HOSTNAME $TI_DOCKER_AGENT_MEMORY_LIMIT\""
	
	touch $DUCC_AGENT_INSTALLED
	echo "finished installing ducc agent"
else
	echo "ducc agent already installed"
fi

# daemonize Docker container
while true; do sleep 1; done
