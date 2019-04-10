# Get started

This repository lists modules available for the **Data2Services framework**, enabling data processing to [RDF](https://www.w3.org/RDF/) and services exposure. 

Feel free to propose new modules using [pull requests](https://github.com/MaastrichtU-IDS/data2services-ecosystem/pulls). The list of modules we are planning to work on can be found in the [Wiki](https://github.com/MaastrichtU-IDS/data2services-ecosystem/wiki/Modules-to-develop).

Only [Docker](https://docs.docker.com/install/) is required to run the modules. A typical module should only require a few arguments to be run, making it easy to combine them.

#### Clone

```shell
git clone --recursive https://github.com/MaastrichtU-IDS/data2services-ecosystem.git

# Update submodules
git submodule update --recursive --remote
```

#### Build

Convenience script to build and pull all Docker images. You **need to download** the [Apache Drill installation bundle](https://drill.apache.org/download/) and the [GraphDB standalone zip](https://www.ontotext.com/products/graphdb/) (register to get an email with download URL).

```shell
./build.sh
```

* Every [Docker](https://docs.docker.com/install/) images can also be built independently



# Convert to RDF

#### [data2services-download](https://github.com/MaastrichtU-IDS/data2services-download)

Download datasets using [Shell scripts](https://github.com/MaastrichtU-IDS/data2services-download/blob/master/datasets/TEMPLATE/download.sh).

```shell
docker build -t data2services-download ./submodules/data2services-download
docker run -it --rm -v /data/data2services:/data data2services-download \
	--download-datasets aeolus,pharmgkb,ctd \
	--username my_login --password my_password
```

---

#### [xml2rdf](https://github.com/MaastrichtU-IDS/xml2rdf)

Streams XML to a [generic RDF](https://github.com/MaastrichtU-IDS/xml2rdf#rdf-model) representing the structure of the file. 

```shell
docker build -t xml2rdf ./submodules/xml2rdf
docker run --rm -it -v /data:/data xml2rdf  \
	-i "/data/data2services/file.xml.gz" \
	-o "/data/data2services/file.nq.gz" \
	-g "https://w3id.org/data2services/graph"
```

---

#### [Apache Drill](https://github.com/amalic/apache-drill)

Exposes tabular text files (CSV, TSV, PSV) as SQL, and enables queries on large datasets.

```shell
wget -N http://apache.40b.nl/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz -o ./submodules/apache-drill/apache-drill-1.15.0.tar.gz
docker-compose up drill
docker build -t apache-drill ./submodules/apache-drill
docker run -dit --rm -p 8047:8047 -p 31010:31010 \
	--name drill -v /data:/data:ro apache-drill
```

* Download [Apache Drill install bundle](http://apache.40b.nl/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz)
* Access at [http://localhost:8047/](http://localhost:8047/)
* Used by [AutoR2RML](https://github.com/amalic/AutoR2RML) and [R2RML](https://github.com/amalic/r2rml) to convert tabular files to a generic RDF representation

---

#### [AutoR2RML](https://github.com/amalic/AutoR2RML)

Automatically generate [R2RML](https://www.w3.org/TR/r2rml/) files from Relational databases (SQL, Postgresql).

```shell
docker build -t autor2rml ./submodules/AutoR2RML
docker run -it --rm --link drill:drill --link postgres:postgres -v /data:/data \
	autor2rml -j "jdbc:drill:drillbit=drill:31010" -r \
	-o "/data/data2services/mapping.trig" \
	-d "/data/data2services" \
	-u "postgres" -p "pwd" \
	-b "https://w3id.org/data2services/" \
	-g "https://w3id.org/data2services/graph"
```

* Can be combined with [Apache Drill](https://github.com/amalic/apache-drill) to process tabular files.

---

#### [R2RML](https://github.com/amalic/r2rml)

Convert Relational Databases to RDF using the [R2RML](https://www.w3.org/TR/r2rml/) mapping language.

```shell
docker build -t r2rml ./submodules/r2rml
docker run -it --rm --link drill:drill --link postgres:postgres \
	-v /data:/data r2rml /data/config.properties
```

* Require a [config.properties](https://github.com/amalic/r2rml/blob/master/example/config.properties) file
* Can be combined with [Apache Drill](https://github.com/amalic/apache-drill) to process tabular files.

---

#### [RdfUpload](https://github.com/MaastrichtU-IDS/RdfUpload)

Upload RDF files to a triplestore.

```shell
docker build -t rdf-upload ./submodules/RdfUpload
docker run -it --rm --link graphdb:graphdb -v /data/data2services:/data \
	rdf-upload -m "HTTP" -if "/data" \
	-url "http://graphdb:7200" -rep "test" \
	-un "username" -pw "password"
```

* Only tested on [GraphDB](https://github.com/MaastrichtU-IDS/graphdb) at the moment

---

#### [PyShEx](https://github.com/hsolbrig/PyShEx)

Validate RDF from a SPARQL endpoint against a [ShEx](http://shex.io/) file.

```shell
docker build -t pyshex ./submodules/PyShEx/docker
docker run --rm -it pyshex -gn '' -ss -ut -pr \
	-sq 'select ?item where{?item a <http://w3id.org/biolink/vocab/Gene>} LIMIT 1' \
    http://graphdb.dumontierlab.com/repositories/ncats-red-kg \
    https://github.com/biolink/biolink-model/raw/master/shex/biolink-modelnc.shex
```

---

#### [BridgeDb](https://github.com/bridgedb/BridgeDb)

[BridgeDb](https://www.bridgedb.org/) links URI identifiers from various datasets (Uniprot, PubMed).

```shell
docker pull bigcatum/bridgedb
docker run -p 8183:8183 bigcatum/bridgedb
```

---

# Store RDF

#### [GraphDB](https://github.com/MaastrichtU-IDS/graphdb)

[Ontotext](https://www.ontotext.com/) GraphDB triplestore including GUI and multiple repositories.

```shell
docker-compose up graphdb
docker build -t graphdb ./submodules/graphdb
docker run -d --rm --name graphdb -p 7200:7200 \
	-v /data/graphdb:/opt/graphdb/home \
	-v /data/graphdb-import:/root/graphdb-import \
	graphdb
```

* Download [standalone zip file](https://www.ontotext.com/products/graphdb/) and place it in `submodules/graphdb` before *docker build*
* Access at [http://localhost:7200/](http://localhost:7200/)

---

#### [Virtuoso](https://github.com/tenforce/docker-virtuoso)

[Virtuoso](https://virtuoso.openlinksw.com/) triplestore.

```shell
docker-compose up virtuoso
docker pull tenforce/virtuoso
docker run --name virtuoso \
    -p 8890:8890 -p 1111:1111 \
    -e DBA_PASSWORD=password \
    -e SPARQL_UPDATE=true \
    -e DEFAULT_GRAPH=https://w3id.org/data2services/graph \
    -v /data/virtuoso:/data \
    -d tenforce/virtuoso
```

* Access at [http://localhost:8890/](http://localhost:8890/)
* Admin login: `dba`

---

#### [Linked Data Fragments Server](https://github.com/LinkedDataFragments/Server.js)

Server supporting the [Memento](https://mementoweb.org/guide/rfc/) protocol to query over datasets (can be [HDT](http://www.rdfhdt.org/) or [SPARQL](https://www.w3.org/TR/sparql11-query/)).

```shell
docker-compose up ldf-server
docker build -t ldf-server ./submodules/Server.js
docker run -p 3000:3000 -t -i --rm \
	-v /data/data2services:/data \
	-v $(pwd)/config.json:/tmp/config.json \
	ldf-server /tmp/config.json

# Query example
curl -IL -H "Accept-Datetime: Wed, 15 Apr 2013 00:00:00 GMT" http://localhost:3000/timegate/dbpedia?subject=http%3A%2F%2Fdata2services%2Fmodel%2Fgo-category%2Fprocess
```

* Require a [config.json](https://github.com/LinkedDataFragments/Server.js/blob/develop/config/config-example-memento.json) file
* Access at [http://localhost:3000](http://localhost:3000)

---

#### [rdf2hdt](https://github.com/vemonet/rdf2hdt)

Convert RDF to [HDT](http://www.rdfhdt.org/) files. *Header, Dictionary, Triples* is a binary serialization format for RDF  that keeps big datasets compressed while maintaining search and browse operations without prior decompression.

```shell
docker build -t rdf2hdt ./submodules/rdf2hdt
docker run -it -v /data/data2services:/data \
	rdf2hdt /data/input.nt /data/output.hdt
```

---

# Access RDF

#### [data2services-sparql-operations](https://github.com/MaastrichtU-IDS/data2services-sparql-operations)

Execute [SPARQL](https://www.w3.org/TR/sparql11-query/) queries from string, URL or multiple files using [RDF4J](http://rdf4j.org/).

```shell
docker build -t data2services-sparql-operations ./submodules/data2services-sparql-operations
docker run -it --rm data2services-sparql-operations -op select \
  -sp "select distinct ?Concept where {[] a ?Concept} LIMIT 10" \
  -ep "http://dbpedia.org/sparql"
```

------

#### [Comunica](https://github.com/vemonet/comunica.git)

Framework to perform [federated queries](https://www.w3.org/TR/sparql11-federated-query/) over a lot of different stores (triplestores, [TPF](http://linkeddatafragments.org/in-depth/), [HDT](http://www.rdfhdt.org/)).

```shell
docker pull comunica/actor-init-sparql
docker run -it comunica/actor-init-sparql \
	http://fragments.dbpedia.org/2015-10/en \
	"CONSTRUCT WHERE { ?s ?p ?o } LIMIT 100"
```

---

#### [YASGUI](https://github.com/OpenTriply/YASGUI.server)

[Yet Another Sparql GUI](http://doc.yasgui.org/).

```shell
docker-compose up yasgui
docker pull erikap/yasgui
docker run -it --rm --name yasgui -p 8080:80 \
	-e "DEFAULT_SPARQL_ENDPOINT=http://dbpedia.org/sparql" \
	-e "ENABLE_ENDPOINT_SELECTOR=true" \
	erikap/yasgui
```

- Require to [allow Cross-Origin Requests](https://addons.mozilla.org/fr/firefox/addon/cors-everywhere/)
- Access at [http://localhost:8080/](http://localhost:8080/)

#### [LODEstar](https://github.com/EBISPOT/lodestar)

[SPARQL](https://www.w3.org/TR/sparql11-query/) query and URI resolution.

```shell
docker-compose up lodestar
docker build -t lodestar ./submodules/lodestar
docker run -d --rm --name lodestar -p 8080:8080 lodestar
```

* Change SPARQL endpoint before *docker build* in `config-docker/lode.properties`

* Access at [http://localhost:8080/lodestar](http://localhost:8080/lodestar)

Table of Contents
=================

   * [Get started](#get-started)
      * [Clone](#clone)
      * [Build](#build)
   * [Convert to RDF](#convert-to-rdf)
      * [<a href="https://github.com/MaastrichtU-IDS/data2services-download">data2services-download</a>](#data2services-download)
      * [<a href="https://github.com/MaastrichtU-IDS/xml2rdf">xml2rdf</a>](#xml2rdf)
      * [<a href="https://github.com/amalic/apache-drill">Apache Drill</a>](#apache-drill)
      * [<a href="https://github.com/amalic/AutoR2RML">AutoR2RML</a>](#autor2rml)
      * [<a href="https://github.com/amalic/r2rml">R2RML</a>](#r2rml)
      * [<a href="https://github.com/MaastrichtU-IDS/RdfUpload">RdfUpload</a>](#rdfupload)
      * [<a href="https://github.com/hsolbrig/PyShEx">PyShEx</a>](#pyshex)
   * [Store RDF](#store-rdf)
      * [<a href="https://github.com/MaastrichtU-IDS/graphdb">GraphDB</a>](#graphdb)
      * [<a href="https://github.com/tenforce/docker-virtuoso">Virtuoso</a>](#virtuoso)
      * [<a href="https://github.com/LinkedDataFragments/Server.js">Linked Data Fragments Server</a>](#linked-data-fragments-server)
      * [<a href="https://github.com/vemonet/rdf2hdt">rdf2hdt</a>](#rdf2hdt)
   * [Access RDF](#access-rdf)
      * [<a href="http://github.com/MaastrichtU-IDS/data2services-sparql-operations">data2services-sparql-operations</a>](#rdf4j-sparql-operations)
      * [<a href="https://github.com/vemonet/comunica.git">Comunica</a>](#comunica)
      * [<a href="https://github.com/OpenTriply/YASGUI.server">YASGUI</a>](#yasgui)
      * [<a href="https://github.com/EBISPOT/lodestar">LODEstar</a>](#lodestar)
   * [Table of Contents](#table-of-contents)

