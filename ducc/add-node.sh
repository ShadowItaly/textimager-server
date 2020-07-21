#!/bin/bash


TI_DOCKER_AGENT_HOST="$1"
TI_DOCKER_AGENT_IP="$2"
TI_DOCKER_AGENT_PORT="$3"
TI_DOCKER_AGENT_MEMOY_LIMIT="$4"

# adds a new node to this DUCC head
echo "adding node:"
echo "  agent host: $TI_DOCKER_AGENT_HOST"
echo "  agent ip: $TI_DOCKER_AGENT_IP"
echo "  agent port: $TI_DOCKER_AGENT_PORT"
echo "  agent memory limit: $TI_DOCKER_AGENT_MEMOY_LIMIT"

# add agent to hosts file of head node
# ...only if not already in there
if grep -Fxq "$TI_DOCKER_AGENT_HOST" /etc/hosts
then
	echo "agent $TI_DOCKER_AGENT_HOST already in hosts file"
else
	echo $TI_DOCKER_AGENT_IP $TI_DOCKER_AGENT_HOST >> /etc/hosts
fi

# add this agent to head nodes ssh config
if grep -Fxq "$TI_DOCKER_AGENT_HOST" /home/ducc/.ssh/config
then
	echo "agent $TI_DOCKER_AGENT_HOST already in ssh config file"
else
	su - ducc -c "echo \"Host $TI_DOCKER_AGENT_HOST\" >> /home/ducc/.ssh/config"
	su - ducc -c "echo \"    HostName $TI_DOCKER_AGENT_IP\" >> /home/ducc/.ssh/config"
	su - ducc -c "echo \"    Port $TI_DOCKER_AGENT_PORT\" >> /home/ducc/.ssh/config"
	su - ducc -c "echo \"    IdentityFile ~/.ssh/id_rsa\" >> /home/ducc/.ssh/config"
fi

# add this agent to DUCC nodes list
if grep -Fxq "$TI_DOCKER_AGENT_HOST" /home/ducc/ducc/apache-uima-ducc/resources/ducc.nodes
then
	echo "agent $TI_DOCKER_AGENT_HOST already in ducc nodes file"
else
	su - ducc -c "echo \"\" >> /home/ducc/ducc/apache-uima-ducc/resources/ducc.nodes"
	su - ducc -c "echo \"$TI_DOCKER_AGENT_HOST\" >> /home/ducc/ducc/apache-uima-ducc/resources/ducc.nodes"
fi

# add this agent to DUCC max memory list
if grep -Fxq "$TI_DOCKER_AGENT_HOST" /home/ducc/ducc/apache-uima-ducc/resources/ducc.memory_limits
then
	echo "agent $TI_DOCKER_AGENT_HOST already in ducc memory limit file"
else
	su - ducc -c "echo \"\" >> /home/ducc/ducc/apache-uima-ducc/resources/ducc.memory_limits"
	su - ducc -c "echo \"${TI_DOCKER_AGENT_HOST}=${TI_DOCKER_AGENT_MEMOY_LIMIT}\" >> /home/ducc/ducc/apache-uima-ducc/resources/ducc.memory_limits"
fi

# backup config for later
mkdir -p /home/ducc/ducc/backup
cp /etc/hosts /home/ducc/ducc/backup/etc_hosts
cp /home/ducc/.ssh/config /home/ducc/ducc/backup/ducc_ssh_config

# "start" ducc to startup this agent
su - ducc -c "/home/ducc/ducc/apache-uima-ducc/admin/start_ducc"
