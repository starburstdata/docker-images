FROM prestodb/centos6-oj8:2
MAINTAINER Grzegorz Kokosiński <grzegorz.kokosinksi@starburstdata.com>

RUN yum install -y tar

RUN curl -SL http://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-cli/0.188/presto-cli-0.188-executable.jar -o presto-cli.jar

# TODO use starburst release
RUN curl -SL http://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/0.188/presto-server-0.188.tar.gz \
      | tar xz \
      && mv $(find -type d -name 'presto-server*') presto-server

RUN mkdir /presto-server/etc 

COPY etc /presto-server/etc/

CMD /presto-server/bin/launcher run
