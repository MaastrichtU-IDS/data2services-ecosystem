#!/bin/bash

if ! [ -f apache-drill/apache-drill-1.13.0.tar.gz ]; then
  curl ftp://apache.proserve.nl/apache/drill/drill-1.13.0/apache-drill-1.13.0.tar.gz -o apache-drill/apache-drill-1.13.0.tar.gz
fi

if ! [ -f graphdb/graphdb-free-8.6.0-dist.zip ]; then
  curl http://go.pardot.com/e/45622/38-graphdb-free-8-6-0-dist-zip/5pyc3s/1295914437 -o graphdb/graphdb-free-8.6.0-dist.zip
fi

docker build -t data2services-download ./submodules/data2services-download
docker build -t apache-drill ./submodules/apache-drill
docker build -t autor2rml ./submodules/AutoR2RML
docker build -t r2rml ./submodules/r2rml
docker build -t xml2rdf ./submodules/xml2rdf
docker build -t rdf-upload ./submodules/RdfUpload
docker build -t graphdb ./submodules/graphdb
docker build -t lodestar ./submodules/lodestar
docker build -t rdf2hdt ./submodules/rdf2hdt
docker build -t ldf-server ./submodules/Server.js
docker build -t rdf4j-sparql-operations ./submodules/rdf4j-sparql-operations
docker build -t comunica-sparql ./submodules/comunica/packages/actor-init-sparql