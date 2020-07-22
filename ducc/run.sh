#!/bin/bash

# resore backup if available
if [ -e "/home/ducc/ducc/backup/etc_hosts" ]; then
	echo "restoring /etc/hosts file..."
	cp /home/ducc/ducc/backup/etc_hosts /etc/hosts
fi
if [ -e "/home/ducc/ducc/backup/ducc_ssh_config" ]; then
	echo "restoring ducc shh config..."
	cp /home/ducc/ducc/backup/ducc_ssh_config /home/ducc/.ssh/config
fi

# ssh
chown -Rf ducc.ducc /home/ducc/.ssh
chmod 700 /home/ducc/.ssh
chmod 600 /home/ducc/.ssh/id_rsa
chmod +r /home/ducc/.ssh/id_rsa.pub

service ssh start

# ducc install
DUCC_INSTALLED="/home/ducc/ducc/.ducc_installed"
if [ ! -e $DUCC_INSTALLED ]; then
	echo "installing ducc..."
		
	# remove own local docker ip and replace with external
	#cp /etc/hosts /etc/hosts_backup
	#sed --in-place=.bak "/$TI_DOCKER_HEAD_HOST/d" /etc/hosts
	#sed --in-place=.bak "/alba2/d" /etc/hosts
	#echo $TI_DOCKER_HEAD_IP $TI_DOCKER_HEAD_HOST >> /etc/hosts
	
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
echo "ducc startup done."

# daemonize Docker container
while true; do sleep 1; done
