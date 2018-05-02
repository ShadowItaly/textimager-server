echo $1
echo $2
echo docker cp $1 textimager-server:/home/ducc/apache-uima-ducc/jars
docker cp $1 textimager-server:/home/ducc/apache-uima-ducc/jars
echo docker exec -ti textimager-server bash -c "su - ducc -c 'cd /home/ducc/ && java -cp DUCCServiceCreator.jar:/home/ducc/apache-uima-ducc/jars/* main.MainComandline $2 localhost'" 
docker exec -ti textimager-server bash -c "su - ducc -c 'cd /home/ducc/ && java -cp DUCCServiceCreator.jar:/home/ducc/apache-uima-ducc/jars/* main.MainComandline $2 localhost'" 
# name vom service = $(echo $2 | sed -e 's?.*\.??')
echo docker exec -ti textimager-server bash -c "su - ducc -c 'export DUCC_HOME=/home/ducc/apache-uima-ducc/ && cd /home/ducc/serviceScripts/$(echo $2 | sed -e 's?.*\.??') && sh /home/ducc/serviceScripts/$(echo $2 | sed -e 's?.*\.??')/$(echo $2 | sed -e 's?.*\.??').xml.sh'"
docker exec -ti textimager-server bash -c "su - ducc -c 'export DUCC_HOME=/home/ducc/apache-uima-ducc/ && cd /home/ducc/serviceScripts/$(echo $2 | sed -e 's?.*\.??') && sh /home/ducc/serviceScripts/$(echo $2 | sed -e 's?.*\.??')/$(echo $2 | sed -e 's?.*\.??').xml.sh'"
