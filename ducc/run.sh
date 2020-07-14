#!/bin/sh

# finishes the initialization of DUCC and starts the service

# ssh 
service ssh start

# modify access rights
chmod 700 /home/ducc/.ssh
chmod 600 /home/ducc/.ssh/id_rsa
chmod +r /home/ducc/.ssh/id_rsa.pub
chown -Rf ducc.ducc /home/ducc/.ssh/

# allow login using this key
cp /home/ducc/.ssh/id_rsa.pub /home/ducc/.ssh/authorized_keys

# disable required user input at first connect
echo "StrictHostKeyChecking=no" > /home/ducc/.ssh/config

# use the same key for root user
cp -Rf /home/ducc/.ssh/ /root/
chown -Rf root.root /root/.ssh/

# unpack UIMA DUCC
mkdir /home/ducc/ducc/
mkdir /home/ducc/ducc/apache-uima-ducc/
cd /home/ducc/
tar xzf uima-ducc-3.0.0-bin.tar.gz 
mv apache-uima-ducc-3.0.0/* /home/ducc/ducc/apache-uima-ducc/
rm -Rf /home/ducc/apache-uima-ducc-3.0.0/
chown ducc.ducc -Rf /home/ducc/

# DUCC post installation scripts
export LOGNAME="ducc"
cd /home/ducc/ducc/apache-uima-ducc/admin/
INTERNAL_HOSTNAME=$(hostname)
su - ducc -c "cd /home/ducc/ducc/apache-uima-ducc/admin/ && /home/ducc/ducc/apache-uima-ducc/admin/ducc_post_install --head-node \"$INTERNAL_HOSTNAME\" --jvm \"/usr/local/openjdk-8/bin/java\""

# allow anonymous login to DUCC
# TODO modify in future release
mv /home/ducc/activemq-ducc.xml /home/ducc/ducc/apache-uima-ducc/apache-uima/apache-activemq/conf/activemq-ducc.xml

# move other files...
mv /home/ducc/add-node.sh /home/ducc/ducc/
mv /home/ducc/DUCCServiceCreator.jar /home/ducc/ducc/
mv /home/ducc/serviceScripts /home/ducc/ducc/
mv /home/ducc/jars /home/ducc/ducc/

# TODO ducc_ling
#chown root.ducc /home/ducc/apache-uima-ducc/admin/ducc_ling
#chmod 700 /home/ducc/apache-uima-ducc/admin/
#chmod 4750 /home/ducc/apache-uima-ducc/admin/ducc_ling

# finish installation
su - ducc -c "/home/ducc/ducc/apache-uima-ducc/admin/check_ducc"
su - ducc -c "/home/ducc/ducc/apache-uima-ducc/admin/start_ducc"

# daemonize Docker container
while true; do sleep 1; done
