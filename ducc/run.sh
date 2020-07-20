#!/bin/sh

# ssh 
chmod 700 /home/ducc/.ssh
chmod 600 /home/ducc/.ssh/id_rsa
chmod +r /home/ducc/.ssh/id_rsa.pub

service ssh start


DUCC_INSTALLED="/home/ducc/ducc/.ducc_installed"
if [ ! -e $DUCC_INSTALLED ]; then
	echo "installing ducc..."
	
	# DUCC post installation scripts
	export LOGNAME="ducc"
	su - ducc -c "cd /home/ducc/ducc/apache-uima-ducc/admin/ && /home/ducc/ducc/apache-uima-ducc/admin/ducc_post_install --head-node \"${TI_DOCKER_HEAD_HOST}\" --jvm \"/usr/local/openjdk-8/bin/java\""
	
	touch $DUCC_INSTALLED
else
	echo "ducc already installed"
fi

# start ducc
echo "checking ducc......"
su - ducc -c "/home/ducc/ducc/apache-uima-ducc/admin/check_ducc"
echo "starting ducc......"
su - ducc -c "/home/ducc/ducc/apache-uima-ducc/admin/start_ducc"

# daemonize Docker container
while true; do sleep 1; done
