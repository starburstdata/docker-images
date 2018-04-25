FROM ubuntu:16.04
LABEL maintainer="https://www.starburstdata.com/"

RUN apt-get update && apt-get -y install squid

EXPOSE 3128

CMD service squid start && tail -F /var/log/squid/access.log
