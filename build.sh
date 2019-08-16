#!/bin/bash

#wget -N http://apache.40b.nl/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz -o ./submodules/apache-drill/apache-drill-1.15.0.tar.gz

if ! [ -f submodules/apache-drill/apache-drill-1.15.0.tar.gz ]; then
  curl http://apache.40b.nl/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz -o submodules/apache-drill/apache-drill-1.15.0.tar.gz
fi

docker pull vemonet/rdf4j-sparql-operations
docker pull vemonet/apache-drill
docker pull vemonet/autor2rml
docker pull vemonet/r2rml
docker pull vemonet/xml2rdf
docker pull vemonet/rdf-upload
docker pull vemonet/data2services-download
docker pull comunica/actor-init-sparql
docker build -t pyshex ./submodules/PyShEx/docker
docker build -t graphdb ./submodules/graphdb

#docker pull erikap/yasgui
#docker pull stain/jena-fuseki
#docker build -t lodestar ./submodules/lodestar
#docker build -t rdf2hdt ./submodules/rdf2hdt
#docker build -t ldf-server ./submodules/Server.js