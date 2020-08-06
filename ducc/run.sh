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

# ducc install
DUCC_INSTALLED="/home/ducc/ducc/.ducc_installed"
if [ ! -e $DUCC_INSTALLED ]; then
	echo "installing ducc..."
	
	# create dirs...
	su - ducc -c "mkdir -p /home/ducc/ducc/apache-uima-ducc/"
	su - ducc -c "mkdir -p /home/ducc/ducc/jars/"
	
	# download and unpack uima ducc
	su - ducc -c "wget http://ftp.halifax.rwth-aachen.de/apache/uima/uima-ducc-3.0.0/uima-ducc-3.0.0-bin.tar.gz -P /home/ducc"
	su - ducc -c "tar xzf uima-ducc-3.0.0-bin.tar.gz --strip=1 -C /home/ducc/ducc/apache-uima-ducc/"
	
	# allow anonymous login to DUCC
	# TODO modify in future release
	su - ducc -c "mv /home/ducc/activemq-ducc.xml /home/ducc/ducc/apache-uima-ducc/apache-uima/apache-activemq/conf/activemq-ducc.xml"
	
	# add modified ducc.py to enable fake memory limits in resources/ducc.memory_limits
	su - ducc -c "mv /home/ducc/ducc_3.0.0.py /home/ducc/ducc/apache-uima-ducc/admin/ducc.py"
	
	# add modified db_util.py to wait for db init longer
	su - ducc -c "mv /home/ducc/db_util_3.0.0.py /home/ducc/ducc/apache-uima-ducc/admin/db_util.py"
	
	# add-node script: adds a new node to the DUCC head
	su - ducc -c "mv /home/ducc/add-node.sh /home/ducc/ducc/add-node.sh"

	# tool to generate service data
	su - ducc -c "mv /home/ducc/DUCCServiceCreator.jar /home/ducc/ducc/DUCCServiceCreator.jar"
	
	# basic test services
	# TODO remove later
	su - ducc -c "mv /home/ducc/serviceScripts /home/ducc/ducc/"
	su - ducc -c "mv /home/ducc/texte /home/ducc/ducc/"
	su - ducc -c "mv /home/ducc/textimager-uima-deploy-0.2.6-mini-deploy.jar /home/ducc/ducc/jars/textimager-uima-deploy-0.2.6-mini-deploy.jar"
	
	# DUCC post installation scripts
	LOCAL_HOSTNAME=$(hostname)
	export LOGNAME="ducc"	
	su - ducc -c "cd /home/ducc/ducc/apache-uima-ducc/admin/ && /home/ducc/ducc/apache-uima-ducc/admin/ducc_post_install --head-node \"${LOCAL_HOSTNAME}\" --jvm \"/usr/local/openjdk-8/bin/java\""
	
	touch $DUCC_INSTALLED
	echo "ducc finished installing"
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
