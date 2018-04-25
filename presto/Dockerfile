FROM prestodb/centos6-oj8:2
LABEL maintainer="https://www.starburstdata.com/"

RUN yum install -y tar util-linux

RUN curl -SL https://s3.us-east-2.amazonaws.com/starburstdata/releases/0.188-e.0.1/presto_server_pkg.0.188-e.0.1.tar.gz | tar xz \
      && rpm -i /presto_server_pkg.*/*rpm \
      && mv -v /presto_server_pkg.*/presto-cli*-executable.jar /presto-cli \
      && rm -rf /presto_server_pkg.*

COPY etc /usr/lib/presto/etc

CMD /usr/lib/presto/bin/launcher run
