#!/bin/bash

TI_DOCKER_AGENT_HOST="$1"
TI_DOCKER_AGENT_MEMORY_LIMIT="$2"

# adds a new node to this DUCC head
echo "adding node:"
echo "  agent host: $TI_DOCKER_AGENT_HOST"
echo "  agent memory limit: $TI_DOCKER_AGENT_MEMORY_LIMIT"

# add this agent to DUCC nodes list
if grep -Fxq "$TI_DOCKER_AGENT_HOST" /home/ducc/ducc/apache-uima-ducc/resources/ducc.nodes
then
	echo "agent $TI_DOCKER_AGENT_HOST already in ducc nodes file"
else
	echo "" >> /home/ducc/ducc/apache-uima-ducc/resources/ducc.nodes
	echo "$TI_DOCKER_AGENT_HOST" >> /home/ducc/ducc/apache-uima-ducc/resources/ducc.nodes
fi

# add this agent to DUCC max memory list
if grep -Fxq "$TI_DOCKER_AGENT_HOST" /home/ducc/ducc/apache-uima-ducc/resources/ducc.memory_limits
then
	echo "agent $TI_DOCKER_AGENT_HOST already in ducc memory limit file"
else
	echo "" >> /home/ducc/ducc/apache-uima-ducc/resources/ducc.memory_limits
	echo "${TI_DOCKER_AGENT_HOST}=${TI_DOCKER_AGENT_MEMORY_LIMIT}" >> /home/ducc/ducc/apache-uima-ducc/resources/ducc.memory_limits
fi

echo "added agent node"
