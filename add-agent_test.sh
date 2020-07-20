# startup new agent for ducc

LOCAL_HOSTNAME=$(hostname)
LOCAL_IP=$(ip addr show |grep 'inet '|grep -v 127.0.0.1 |awk '{print $2}'| cut -d/ -f1 | head -1)

TI_DOCKER_HEAD_HOST="alba2"
TI_DOCKER_HEAD_IP="141.2.89.20"
TI_DOCKER_HEAD_PORT="2222"

TI_DOCKER_AGENT_HOST="${LOCAL_HOSTNAME}-1"
TI_DOCKER_AGENT_IP="$LOCAL_IP"
TI_DOCKER_AGENT_PORT="2223"

echo "building docker image for agent..."
docker build -t textimager-agent ducc-agent/

echo "ducc head host: $TI_DOCKER_HEAD_HOST"
echo "ducc head ip: $TI_DOCKER_HEAD_IP"
echo "ducc head port: $TI_DOCKER_HEAD_PORT"
echo "ducc agent host: $TI_DOCKER_AGENT_HOST"
echo "ducc agent ip: $TI_DOCKER_AGENT_IP"
echo "ducc agent port: $TI_DOCKER_AGENT_PORT"

docker run \
	-d \
	-p $TI_DOCKER_AGENT_PORT:22 \
	--name "textimager-agent-$TI_DOCKER_AGENT_HOST" \
	--hostname "$TI_DOCKER_AGENT_HOST" \
	-e TI_DOCKER_HEAD_HOST="$TI_DOCKER_HEAD_HOST" \
	-e TI_DOCKER_HEAD_IP="$TI_DOCKER_HEAD_IP" \
	-e TI_DOCKER_HEAD_PORT="$TI_DOCKER_HEAD_PORT" \
	-e TI_DOCKER_AGENT_HOST="$TI_DOCKER_AGENT_HOST" \
	-e TI_DOCKER_AGENT_IP="$TI_DOCKER_AGENT_IP" \
	-e TI_DOCKER_AGENT_PORT="$TI_DOCKER_AGENT_PORT" \
	--cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined \
	textimager-agent

