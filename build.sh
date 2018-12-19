#!/bin/bash

if ! [ -f apache-drill/apache-drill-1.13.0.tar.gz ]; then
  curl ftp://apache.proserve.nl/apache/drill/drill-1.13.0/apache-drill-1.13.0.tar.gz -o apache-drill/apache-drill-1.13.0.tar.gz
fi

if ! [ -f graphdb/graphdb-free-8.6.0-dist.zip ]; then
  curl http://go.pardot.com/e/45622/38-graphdb-free-8-6-0-dist-zip/5pyc3s/1295914437 -o graphdb/graphdb-free-8.6.0-dist.zip
fi

docker build -t data2services-download ./data2services-download
docker build -t apache-drill ./apache-drill
docker build -t autor2rml ./AutoR2RML
docker build -t r2rml ./r2rml
docker build -t xml2rdf ./xml2rdf
docker build -t rdf-upload ./RdfUpload
docker build -t graphdb ./graphdb
docker build -t lodestar ./lodestar
docker build -t rdf2hdt ./rdf2hdt
docker build -t ldf-server ./Server.js
docker build -t comunica-sparql ./comunica/packages/actor-init-sparql