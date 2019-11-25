# Presto

Docker image of Presto with OpenJDK 11 installed.

## Running Presto

    docker run -d -p 127.0.0.1:8080:8080 --name presto starburstdata/presto

## Presto connectors

Presto docker container is started with following connectors:
* tpch
* tpcds
* memory
* blackhole
* jmx
* system

## Running Presto cli client

While Presto is started you can

    docker exec -it presto /presto-cli

## Presto cluster overview

Presto cluster overview webpage is available at [localhost:8080](http://localhost:8080)

## Custom build

To build a container using RPM and CLI that are not publicly downloadable from the Internet run:
```bash
presto_rpm=<location of presto-server-rpm fil>
presto_cli=<location of presto-cli executable jar>
presto_version=<presto version>
./build-image.sh --rpm "${presto_rpm}" --cli "${presto_cli}" --version "${presto_version}"
```

## Custom build (incremetal) FOR DEVELOPMENT PURPOSES ONLY

During development cycle you can reduce build time and last layer size using `--incremetal` flag:
```bash
./build-image.sh --incremental --rpm "${presto_rpm}" --cli "${presto_cli}" --version "${presto_version}"
```
This way each consecutive build with reuse previously created docker image and create a layer with differences on top of it.

## OpenJDK license

By using this image, you accept the OpenJDK License Agreement for Java SE available here:
[https://openjdk.java.net/legal/gplv2+ce.html](https://openjdk.java.net/legal/gplv2+ce.html)
