# Hive Metastore (unsecured) 
           
Docker image of Hive metastore with OpenJDK 8 installed.

## Running standalone Hive Metastore (with Postgres)

    export HIVE_METASTORE_JDBC_URL=jdbc:postgresql://postgres.docker.starburstdata.com/hivemetastore
    export HIVE_METASTORE_DRIVER="org.postgresql.Driver"
    export HIVE_METASTORE_USER=hivemetastore
    export HIVE_METASTORE_PASSWORD=hivemetastore
    docker-compose up metastore postgres

Notice that Postgres data is stored locally on host machine (outside of docker). 
In order to drop the data you need to:

    docker-compose down --volumes

## Running standalone Hive Metastore (with Mysql)

    export HIVE_METASTORE_JDBC_URL=jdbc:postgresql://postgres.docker.starburstdata.com/hivemetastore
    export HIVE_METASTORE_DRIVER="org.postgresql.Driver"
    export HIVE_METASTORE_USER=hivemetastore
    export HIVE_METASTORE_PASSWORD=hivemetastore
    docker-compose up metastore mysql

## Accessing S3 data

In order to access S3 from Hive Metastore (needed to create or drop tables with S3 data) please use:

    export S3_ENDPOINT="???"
    export S3_ACCESS_KEY="???"
    export S3_SECRET_KEY="???"
    export HIVE_METASTORE_JDBC_URL=...
    export HIVE_METASTORE_DRIVER=...
    export HIVE_METASTORE_USER=...
    export HIVE_METASTORE_PASSWORD=...
    docker-compose up metastore ...

## Stopping the Hive Metastore 

    docker-compose down 

    docker-compose down --volumes

## Running standalone Hive CLI

While Metastore is started you can start standalone Hive CLI with:

    docker-compose exec metastore hive

Notice that is not a fully-fledged Hive cluster installation (single node without HDFS), 
however it is very useful to run basic select or DDL queries.

## Running standalone Presto 

Running standalone Presto is useful to verify the cluster state. To see if everything is up and running.

    docker-compose up presto
   
Then you can run Presto CLI

    docker-compose exec presto presto-cli

Notice that currently Presto does not support access to data placed on S3.

## OpenJDK license

By using this image, you accept the OpenJDK License Agreement for Java SE available here:
[https://openjdk.java.net/legal/gplv2+ce.html](https://openjdk.java.net/legal/gplv2+ce.html)
