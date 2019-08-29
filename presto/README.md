# Presto

Docker image of Presto with OpenJDK 8 installed.

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

To build a container using rpm and CLI that are not publicly downloadable from the Internet, follow these steps.

1. put the rpm and CLI executable jar in `installdir/` dir.
2. run something like:
   ```bash
   VERSION=312-e.7
   docker build . --build-arg "presto_version=$VERSION" --build-arg dist_location=/installdir -t "starburstdata/presto:$VERSION" --squash
   docker push "starburstdata/presto:$VERSION"
   ```

## OpenJDK license

By using this image, you accept the OpenJDK License Agreement for Java SE available here:
[https://openjdk.java.net/legal/gplv2+ce.html](https://openjdk.java.net/legal/gplv2+ce.html)
