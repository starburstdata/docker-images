# Presto
           
Docker image of Presto with Oracle JDK 8 installed.

## Running Presto

    docker pull starburstdata/presto
    docker run -d --name presto starburstdata/presto

## Running Presto cli client

While Presto is started you can

    docker exec -it presto java -jar /presto-cli.jar

## Oracle license

By using this image, you accept the Oracle Binary Code License Agreement for Java SE available here:
[http://www.oracle.com/technetwork/java/javase/terms/license/index.html](http://www.oracle.com/technetwork/java/javase/terms/license/index.html)
