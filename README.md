# Data2Services ecosystem

[Docker](https://docs.docker.com/install/) is required to run the modules.

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

```shell
./build.sh
```



## Data processing

#### Argo

To manage Kubernetes containers workflows

* Install Kubernetes: https://kubernetes.io/docs/tasks/tools/install-kubectl/

* Setup local Kubernetes: https://kubernetes.io/docs/setup/minikube/

------

#### xml2rdf

Streams XML to a generic RDF representing the structure of the file. 

https://github.com/MaastrichtU-IDS/xml2rdf

```shell
docker run --rm -it -v /data:/data xml2rdf  \
	-i "/data/data2services/file.xml.gz" -o "/data/data2services/file.nq.gz" \
	-b "http://data2services/" -g "http://data2services/graph"
```

------

#### Apache Drill

Exposes text files (CSV, TSV, PSV) as SQL, and enables queries on large datasets: 

https://github.com/amalic/apache-drill

```shell
docker run -dit --rm -p 8047:8047 -p 31010:31010 --name drill -v /data:/data:ro apache-drill
```

Access on http://localhost:8047/

------

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

------

#### R2RML

Convert Relational Databases to RDF using the R2RML mapping language. Can be combined with Apache Drill.

https://github.com/amalic/r2rml

```shell
docker run -it --rm --link drill:drill --link postgres:postgres -v /data:/data \
	r2rml /data/config.properties
```

------

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

#### Halyard

https://github.com/Merck/Halyard

*TODO*

### Graphs

#### SPARQL

##### LODEstar

*Work in progress*

https://github.com/EBISPOT/lodestar

```shell
docker run -d -p 8080:8080 lodestar
docker run -d -p 8080:8080 -v /data/config:/data lodestar
```

Access on http://localhost:8080/lodestar

#### Neo4J

#### GraphQL