#!/bin/sh
#
#
## SSH 
service ssh start
chmod 700 /home/ducc/.ssh
chmod 600 /home/ducc/.ssh/id_rsa
chmod +r /home/ducc/.ssh/id_rsa.pub
cp /home/ducc/.ssh/id_rsa.pub /home/ducc/.ssh/authorized_keys
echo "StrictHostKeyChecking=no" > /home/ducc/.ssh/config

## The same for root user
cp -Rf /home/ducc/.ssh/ /root/
chown -Rf root.root /home/ducc/.ssh/

printf "==Ducc installation==\n\n"
# UIMA DUCC installation
cd /home/ducc/ && tar xzf uima-ducc-2.2.2-bin.tar.gz && mv apache-uima-ducc-2.2.2/* /home/ducc/apache-uima-ducc/
rm -Rf /home/ducc/apache-uima-ducc-2.2.2/


printf "==chown==\n\n"
cd /home/ducc/apache-uima-ducc/admin/
chown ducc.ducc -Rf /home/ducc/
chown ducc.ducc -Rf /tmp/res/


printf "==ducc_post_install==\n\n"
export LOGNAME="ducc"
cd /home/ducc/apache-uima-ducc/admin/
su - ducc -c "cd /home/ducc/apache-uima-ducc/admin/ && printf '\n\n' | /home/ducc/apache-uima-ducc/admin/ducc_post_install"

#Anonymous login to DUCC. Modify in future release
mv /home/ducc/activemq-ducc.xml /home/ducc/apache-uima-ducc/apache-uima/apache-activemq/conf/activemq-ducc.xml

#printf "==ducc_ling==\n\n"
# Prepare ducc_ling file
#chown root.ducc /home/ducc/apache-uima-ducc/admin/ducc_ling
#chmod 700 /home/ducc/apache-uima-ducc/admin/
#chmod 4750 /home/ducc/apache-uima-ducc/admin/ducc_ling

printf "==check_ducc==\n\n"
su - ducc -c "/home/ducc/apache-uima-ducc/admin/check_ducc"

printf "==start_ducc==\n\n"
su - ducc -c "/home/ducc/apache-uima-ducc/admin/start_ducc"

# Daemonize Docker container
while true; do sleep 1; done
