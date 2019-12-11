FROM openjdk:8u222-jre-slim
LABEL maintainer="https://www.starburstdata.com/"

ARG configuration_file="application-default.yaml"
ARG benchto_driver_executable
ARG sql_location
ARG benchmarks_location

COPY "${benchto_driver_executable}" /benchto_driver_executable.jar
COPY "${sql_location}" /sql
COPY "${benchmarks_location}" /benchmarks
COPY "${configuration_file}" /application-presto.yaml

ENTRYPOINT ["java", "-Xmx1g", "-jar", "/benchto_driver_executable.jar", "--sql", "/sql", "--benchmarks", "/benchmarks", "--profile", "presto"]
