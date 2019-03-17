#!/bin/bash

#wget -N http://apache.40b.nl/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz -o ./submodules/apache-drill/apache-drill-1.15.0.tar.gz

if ! [ -f submodules/apache-drill/apache-drill-1.15.0.tar.gz ]; then
  curl http://apache.40b.nl/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz -o submodules/apache-drill/apache-drill-1.15.0.tar.gz
fi

docker build -t data2services-download ./submodules/data2services-download
docker build -t apache-drill ./submodules/apache-drill
docker build -t autor2rml ./submodules/AutoR2RML
docker build -t r2rml ./submodules/r2rml
docker build -t xml2rdf ./submodules/xml2rdf
docker build -t rdf-upload ./submodules/RdfUpload
docker build -t pyshex ./submodules/PyShEx/docker
docker build -t graphdb ./submodules/graphdb
docker build -t lodestar ./submodules/lodestar
docker build -t rdf2hdt ./submodules/rdf2hdt
docker build -t ldf-server ./submodules/Server.js
docker build -t rdf4j-sparql-operations ./submodules/rdf4j-sparql-operations
docker pull comunica/actor-init-sparql
docker pull erikap/yasgui
docker pull stain/jena-fuseki