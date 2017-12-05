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

# install docker
RUN yum install -y yum-utils device-mapper-persistent-data lvm2 && \
 yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
 yum install -y docker-ce

# install OpenJDK
RUN yum install -y java-1.8.0-openjdk-devel

# install net-tools
RUN yum -y install net-tools

# cleanup
RUN yum -y clean all && rm -rf /tmp/* /var/tmp/*

# copy configuration and 'systemctl' replacement file
COPY ./files/ /

# For minions that are also test nodes make systemctl replacement executable
# and fake systemd for salt, see: https://github.com/gdraheim/docker-systemctl-replacement
RUN chmod +x /usr/bin/systemctl && touch /run/systemd/system

CMD supervisord -c /etc/supervisord.conf
