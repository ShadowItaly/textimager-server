#!/bin/bash

JARS_DIR="$1"
SERVICE_CLASS="$2"

# get service name from classname
SERVICE_NAME=$(echo $2 | sed -e 's?.*\.??')

# copy needed jars
# TODO
#docker cp "$JARS_DIR/" textimager-server:/home/ducc/ducc/jars/${SERVICE_NAME}/

# generate config files
# TODO
#docker exec -ti textimager-server bash -c "su - ducc -c 'cd /home/ducc/ducc/ && /usr/local/openjdk-8/bin/java -cp DUCCServiceCreator.jar:/home/ducc/ducc/jars/${SERVICE_NAME}/* main.MainComandline $SERVICE_CLASS localhost'" 


# start service
docker exec -ti textimager-server bash -c "su - ducc -c 'export DUCC_HOME=/home/ducc/ducc/apache-uima-ducc/ && cd /home/ducc/ducc/serviceScripts/${SERVICE_NAME} && sh /home/ducc/ducc/serviceScripts/${SERVICE_NAME}/${SERVICE_NAME}.xml.sh'"
