#!/usr/bin/env bash

set -xeuo pipefail

test $# -eq 1
maven_creds="$1"

yum -y install \
    gcc \
    jq \
    maven

tee pom.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.starburstdata.presto</groupId>
    <artifactId>starburst-download-rpm</artifactId>
    <version>0.1</version>
    <repositories>
        <repository>
            <id>starburstdata.snapshots</id>
            <url>https://maven.starburstdata.net/starburstdata-artifacts/snapshots</url>
            <snapshots>
                <enabled>true</enabled>
            </snapshots>
        </repository>
        <repository>
            <id>starburstdata.releases</id>
            <url>https://maven.starburstdata.net/starburstdata-artifacts/releases</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
        </repository>
    </repositories>
</project>
EOF

if [[ -z "${maven_creds}" ]]; then
  secret_string=$(aws --region us-east-2 secretsmanager get-secret-value --secret-id starburstdata/cft/maven_credentials | jq -r '.SecretString')
  username=$(echo "${secret_string}" | jq -r .username)
  password=$(echo "${secret_string}" | jq -r .password)
else
  IFS=':' read -r -a array <<< "${maven_creds}"
  username="${array[0]}"
  password="${array[1]}"
fi

mkdir -p "$HOME/.m2"
tee "$HOME/.m2/settings.xml" <<EOF
<settings>
  <servers>
    <server>
      <id>starburstdata.snapshots</id>
      <username>$username</username>
      <password>$password</password>
      <configuration>
        <httpConfiguration>
          <all>
            <usePreemptive>true</usePreemptive>
          </all>
        </httpConfiguration>
      </configuration>
    </server>
    <server>
      <id>starburstdata.releases</id>
      <username>$username</username>
      <password>$password</password>
      <configuration>
        <httpConfiguration>
          <all>
            <usePreemptive>true</usePreemptive>
          </all>
        </httpConfiguration>
      </configuration>
    </server>
  </servers>
</settings>
EOF
