# Data2Services ecosystem

Modules available for the Data2Services framework. Enabling data processing and services exposure.

Only [Docker](https://docs.docker.com/install/) is required to run the modules.

## Clone

```shell
# WARNING: for Windows execute it before cloning to fix bugs with newlines
git config --global core.autocrlf false
# HTTPS
git clone --recursive https://github.com/MaastrichtU-IDS/data2services-ecosystem.git
# SSH
git clone --recursive git@github.com:MaastrichtU-IDS/data2services-ecosystem.git

cd data2services-ecosystem

# Or pull the submodule after a normal git clone
git submodule update --init --recursive
```

## Build

Download [GraphDB](http://graphdb.ontotext.com/) and [Apache Drill](https://drill.apache.org/), then build docker images.

```shell
./build.sh
```



## Data processing

#### Argo

*TODO*. Kubernetes containers workflows orchestrator

https://github.com/argoproj/argo/

* Install Kubernetes: https://kubernetes.io/docs/tasks/tools/install-kubectl/

* Setup local Kubernetes
  * https://kubernetes.io/docs/tasks/tools/install-minikube/
  * https://kubernetes.io/docs/setup/minikube/

---

#### data2services-download

Download datasets using Shell scripts.

https://github.com/MaastrichtU-IDS/data2services-download

```shell
docker run -it --rm -v /data/data2services:/data data2services-download \
	--download-datasets aeolus,pharmgkb,ctd \
	--username my_login --password my_password
```

---

#### xml2rdf

Streams XML to a generic RDF representing the structure of the file. 

https://github.com/MaastrichtU-IDS/xml2rdf

```shell
docker run --rm -it -v /data:/data xml2rdf  \
	-i "/data/data2services/file.xml.gz" -o "/data/data2services/file.nq.gz" \
	-g "http://data2services/graph"
```

---

#### Apache Drill

Exposes text files (CSV, TSV, PSV) as SQL, and enables queries on large datasets.

https://github.com/amalic/apache-drill

```shell
docker run -dit --rm -p 8047:8047 -p 31010:31010 --name drill -v /data:/data:ro apache-drill
```

Access on http://localhost:8047/

---

#### AutoR2RML

Automatically generate R2RML files from Relational databases (SQL, Postgresql). Can be combined with Apache Drill.

https://github.com/amalic/AutoR2RML

```shell
docker run -it --rm --link drill:drill --link postgres:postgres -v /data:/data \
	autor2rml -j "jdbc:drill:drillbit=drill:31010" -r \
	-o "/data/data2services/mapping.ttl" -d "/data/data2services" \
	-u "postgres" -p "pwd" \
	-b "http://data2services/" -g "http://data2services/graph"
```

---

#### R2RML

Convert Relational Databases to RDF using the R2RML mapping language. Can be combined with Apache Drill.

https://github.com/amalic/r2rml

```shell
docker run -it --rm --link drill:drill --link postgres:postgres -v /data:/data \
	r2rml /data/config.properties
```

---

#### RdfUpload

Upload RDF files to a triplestore. Only tested on GraphDB at the moment. 

https://github.com/MaastrichtU-IDS/RdfUpload

```shell
docker run -it --rm --link graphdb:graphdb -v /data/data2services:/data \
	rdf-upload -m "HTTP" -if "/data" \
	-url "http://graphdb:7200" -rep "test" -un "username" -pw "password"
```



## Services

### Triplestores

#### GraphDB

https://github.com/MaastrichtU-IDS/graphdb

```shell
docker run -d --rm --name graphdb -p 7200:7200 -v /data/graphdb:/opt/graphdb/home -v /data/graphdb-import:/root/graphdb-import graphdb
```

Access on http://localhost:7200/

---

#### Halyard

*TODO*.

https://github.com/Merck/Halyard

---

#### rdf2hdt

Convert RDF to HDT files.

https://github.com/vemonet/rdf2hdt

```shell
docker run -it -v /data/data2services:/data rdf2hdt /data/input.nt /data/output.hdt
```

---

#### Linked Data Fragments Server

Server supporting the Memento protocol to query over datasets (can be HDT or SPARQL).

https://github.com/LinkedDataFragments/Server.js

```shell
docker run -p 3000:3000 -t -i --rm -v /data/data2services:/data -v $(pwd)/config.json:/tmp/config.json ldf-server /tmp/config.json

# Query it
curl -IL -H "Accept-Datetime: Wed, 15 Apr 2013 00:00:00 GMT" http://localhost:3000/timegate/dbpedia?subject=http%3A%2F%2Fdata2services%2Fmodel%2Fgo-category%2Fprocess
```

---

#### Ostrich

*TODO*. For temporal querying, using HDT and supporting SPARQL.

https://github.com/rdfostrich/ostrich/

---

### Graphs

#### SPARQL

##### LODEstar

SPARQL query and URI resolution.

https://github.com/EBISPOT/lodestar

```shell
docker run -d -rm --name lodestar -p 8080:8080

# Not working:
docker run -d -rm --name lodestar -p 8080:8080 -v /path/tolodestar/config-docker/lode.properties:/usr/local/tomcat/webapps/lodestar/WEB-INF/classes/lode.properties lodestar
```

Access on http://localhost:8080/lodestar.

Change SPARQL endpoint before docker build in `config-docker/lode.properties`

---

##### YASGUI

*TODO*. SPARQL UI. NOT WORKING

https://github.com/OpenTriply/YASGUI.server

```shell
docker run -it -rm --name yasgui -p 4545:4545 yasgui
```

---

##### Comunica

Framework to perform federated query over a lot of different stores (triplestores, TPF, HDT)

https://github.com/vemonet/comunica.git

```shell
docker run -it comunica-sparql http://fragments.dbpedia.org/2015-10/en "CONSTRUCT WHERE { ?s ?p ?o } LIMIT 100"
```

---

#### Neo4J

#### GraphQL