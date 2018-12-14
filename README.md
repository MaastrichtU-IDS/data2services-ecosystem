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

#### xml2rdf

Streams XML to a generic RDF representing the structure of the file. 

https://github.com/MaastrichtU-IDS/xml2rdf

#### Apache Drill

Exposes text files (CSV, TSV, PSV) as SQL, and enables queries on large datasets: 

https://github.com/amalic/apache-drill

#### AutoR2RML

Automatically generate R2RML files from Relational databases (SQL, Postgresql). Can be combined with Apache Drill.

https://github.com/amalic/AutoR2RML

#### R2RML

Convert Relational Databases to RDF using the R2RML mapping language. Can be combined with Apache Drill.

https://github.com/amalic/r2rml

#### RdfUpload

Upload RDF files to a triplestore. Only tested on GraphDB at the moment. 

https://github.com/MaastrichtU-IDS/RdfUpload



## Services

### Triplestores

#### GraphDB

https://github.com/MaastrichtU-IDS/graphdb

#### Halyard

https://github.com/Merck/Halyard

TODO

### Graphs

#### SPARQL

##### LODEstar

https://github.com/EBISPOT/lodestar

TODO

#### Neo4J

#### GraphQL