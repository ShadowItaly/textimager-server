# textimager-server

## Prerequirement
* Docker: https://docs.docker.com/installation/#installation

## Installation
* Checkout this repository
* cd /path/to/textimager-server
* mkdir 
* Build image:
```shell
cd /path/to/textimager-server
mkdir duccDataContainer
docker-compose build
```
* Run server:
```shell
docker-compose up
```
or as deamon
```shell
docker-compose up -d
```

* Inspect server startup log:
```shell
docker exec -it textimager-server tail -f '/home/ducc/ducc_startup.log'
```
Startup will take about 5 min. As soon as the startup log prints 'All threads returned', the startup was successful.
## Add Service
Every class implementing the [AnalysisComponent](https://uima.apache.org/d/uimaj-2.7.0/apidocs/org/apache/uima/analysis_component/AnalysisComponent.html) can be distributed as a service.
Jars containing the class and all its dependencies have to be exported.
* Add service:
```shell
sh addService.sh [classpath] [classname]
```
Example:
```shell
sh addService.sh testService/ de.tudarmstadt.ukp.dkpro.core.tokit.BreakIteratorSegmenter
```

An instance of BreakIteratorSegmenter will be added to the Server.
Call http://localhost:42133/services.jsp to see if service has been deployed.
