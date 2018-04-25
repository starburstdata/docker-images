FROM ubuntu:16.04
LABEL maintainer="https://www.starburstdata.com/"

# install salt packages
RUN apt-get update && \
 apt-get -y install wget && \
 wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add - && \
 echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main" > /etc/apt/sources.list.d/saltstack.list && \
 apt-get update && \
 apt-get -y install salt-master salt-ssh salt-cloud salt-api

# install supervisor
RUN apt-get -y install python-pip && \
 pip install --upgrade pip && \
 pip install supervisor

# cleanup
RUN apt-get clean && rm -rf /tmp/* /var/tmp/*

# copy configuration files
COPY ./files /

# salt-master
EXPOSE 4505
EXPOSE 4506

# salt-api
EXPOSE 8080

CMD supervisord -c /etc/supervisord.conf
