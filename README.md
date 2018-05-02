# textimager-server

## Prerequirement
* Docker: https://docs.docker.com/installation/#installation

## Installation
* Build image:
```shell
docker build -t ducc ducc/
```
* Run server:
```shell
docker run -t -i -p 61617:61617 -p 42133:42133 -p 42155:42155 -p 2222:22 -d --name textimager-server ducc
```
##Add Service
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
