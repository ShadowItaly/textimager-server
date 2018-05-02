# textimager-server

##Prerequirement
* Docker: https://docs.docker.com/installation/#installation

##Installation
docker build -t ducc ducc/
docker run -t -i -p 61617:61617 -p 42133:42133 -p 42155:42155 -p 2222:22 -d --name textimager-server ducc

##Add Service
Every class implementing the [AnalysisComponent](https://uima.apache.org/d/uimaj-2.7.0/apidocs/org/apache/uima/analysis_component/AnalysisComponent.html) can be distributed as a service.

