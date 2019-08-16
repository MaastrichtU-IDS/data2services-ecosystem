#!/bin/bash

#wget -N http://apache.40b.nl/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz -o ./submodules/apache-drill/apache-drill-1.15.0.tar.gz

if ! [ -f submodules/apache-drill/apache-drill-1.15.0.tar.gz ]; then
  curl http://apache.40b.nl/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz -o submodules/apache-drill/apache-drill-1.15.0.tar.gz
fi

docker pull vemonet/rdf4j-sparql-operations:latest
docker pull vemonet/apache-drill:latest
docker pull vemonet/autor2rml:latest
docker pull vemonet/r2rml:latest
docker pull vemonet/xml2rdf:latest
docker pull vemonet/rdf-upload:latest
docker pull vemonet/data2services-download:latest
docker pull comunica/actor-init-sparql:latest
docker build -t pyshex ./submodules/PyShEx/docker
docker build -t graphdb ./submodules/graphdb

#docker pull erikap/yasgui
#docker pull stain/jena-fuseki
#docker build -t lodestar ./submodules/lodestar
#docker build -t rdf2hdt ./submodules/rdf2hdt
#docker build -t ldf-server ./submodules/Server.js