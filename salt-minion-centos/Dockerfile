FROM centos:7.4.1708
MAINTAINER Starburstdata

# install salt packages
RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm && \
 yum clean expire-cache && \
 yum install -y salt-minion

# install supervisor
RUN yum install -y epel-release && \
 yum install -y python-pip && \
 pip install --upgrade pip && \
 pip install supervisor

# cleanup
RUN yum -y clean all && rm -rf /tmp/* /var/tmp/*

# copy configuration files
COPY ./files /

CMD supervisord -c /etc/supervisord.conf
