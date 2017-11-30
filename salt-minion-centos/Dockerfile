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

# copy configuration and 'systemctl' replacement file
COPY ./files/ /

# For minions that are also test nodes make systemctl replacement executable
# and fake systemd for salt, see: https://github.com/gdraheim/docker-systemctl-replacement
RUN chmod +x /usr/bin/systemctl && touch /run/systemd/system

CMD supervisord -c /etc/supervisord.conf
