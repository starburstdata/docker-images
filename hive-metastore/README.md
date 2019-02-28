# Hive Metastore

Docker image of Hive metastore with OpenJDK 8 installed.

## Configuring Kerberos

This is required step to use Hive Metastore docker-compose cluster.

1. Please generate Hive Metastore keytab file and principal. Place keytab file as `hive-metastore.keytab`
    to the same directory where `docker-compose.yml` is stored.
   export HIVE_METASTORE_KERBEROS_PRINCIPAL=...

2. Put a `krb5.conf` file to the same directory where `docker-compose.yml` is stored.

### Example with MIT KDC

Generating Kerberos principal and keytab (notice that Hive Metastore node is named metastore in docker-compose cluster):

    /usr/sbin/kadmin.local -q "addprinc -randkey hive-metastore/metastore@LABS.STARBURSTDATA.COM"
    /usr/sbin/kadmin.local -q "xst -norandkey -k /tmp/hive-metastore.keytab hive-metastore/metastore"

Then file hive-metastore.keytab was copied and below was exported:

    export HIVE_METASTORE_KERBEROS_PRINCIPAL=hive-metastore/metastore@LABS.STARBURSTDATA.COM

Then `krb5.conf` was used with following content:

	[logging]
	 default = FILE:/var/log/krb5libs.log

	[libdefaults]
	 default_realm = LABS.STARBURSTDATA.COM
	 dns_lookup_realm = false
	 dns_lookup_kdc = false
	 ticket_lifetime = 24h
	 renew_lifetime = 7d
	 forwardable = true

	[realms]
	 LABS.STARBURSTDATA.COM = {
	  kdc = hadoop-master:88
	  admin_server = hadoop-master
	 }

## Running standalone Hive Metastore

    export HIVE_METASTORE_JDBC_URL=jdbc:postgresql://postgres.docker.starburstdata.com/hivemetastore
    export HIVE_METASTORE_DRIVER="org.postgresql.Driver"
    export HIVE_METASTORE_USER=hivemetastore
    export HIVE_METASTORE_PASSWORD=hivemetastore
    docker-compose up metastore postgres

Notice that Postgres data is stored locally on host machine (outside of docker).
In order to drop the data you need to:

    docker-compose down --volumes

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

## OpenJDK license

By using this image, you accept the OpenJDK License Agreement for Java SE available here:
[https://openjdk.java.net/legal/gplv2+ce.html](https://openjdk.java.net/legal/gplv2+ce.html)
