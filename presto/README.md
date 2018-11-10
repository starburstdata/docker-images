# Presto
           
Docker image of Presto with Oracle JDK 8 installed.

## Running Presto

    docker pull starburstdata/presto
    docker run -d --name presto starburstdata/presto

## Running Presto cli client

While Presto is started you can

    docker exec -it presto /presto-cli

## Custom build

To build a container using rpm and CLI that are not publicly downloadable from the Internet, follow these steps.

1. put the rpm and CLI executable jar in `installdir/` dir.
2. run something like:
   ```bash
   VERSION=0.208-e.0.1-SNAPSHOT
   docker build . --build-arg "presto_version=$VERSION" --build-arg dist_location=/installdir -t "starburstdata/presto:$VERSION" --squash
   docker push "starburstdata/presto:$VERSION"
   ```

## Oracle license

By using this image, you accept the Oracle Binary Code License Agreement for Java SE available here:
[http://www.oracle.com/technetwork/java/javase/terms/license/index.html](http://www.oracle.com/technetwork/java/javase/terms/license/index.html)
