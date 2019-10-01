################################################################################
# Copyright (c) 2018 Starburst Data, Inc. All rights reserved.
#
# All information herein is owned by Starburst Data Inc. and its licensors
# ("Starburst"), if any.  This software and the concepts it embodies are
# proprietary to Starburst, are protected by trade secret and copyright law,
# and may be covered by patents in the U.S. and abroad.  Distribution,
# reproduction, and relicensing are strictly forbidden without Starburst's prior
# written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED.  THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
# AND NONINFRINGEMENT ARE EXPRESSLY DISCLAIMED. IN NO EVENT SHALL STARBURST BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR ITS USE
# EVEN IF STARBURST HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Please refer to your agreement(s) with Starburst for further information.
################################################################################

FROM starburstdata/centos:7.5.1804

RUN yum -y install \
        java-1.8.0-openjdk \
        net-tools \
        wget \
        && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    echo OK

RUN wget -nv http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.6.3.0/hdp.repo -P /etc/yum.repos.d && \
    yum -y install hive-metastore && \
    rpm -qa 'atlas*' 'qt*' 'pig*' 'ranger*' 'spark*' 'tez*' | xargs rpm -e --nodeps && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    rm -r /etc/hadoop/conf/* && \
    rm -r /etc/hive/conf/* && \
    echo OK

ENV JAVA_HOME=/usr/lib/jvm/jre

RUN yum -y install mysql mysql-connector-java postgresql postgresql-jdbc && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    ln -s /usr/share/java/postgresql-jdbc.jar /usr/hdp/current/hive-metastore/lib/ && \
    ln -s /usr/share/java/mysql-connector-java.jar /usr/hdp/current/hive-metastore/lib/ && \
    echo OK

# Replace AWS SDK 1.10.6 with 1.11.234 as it is required by Minio
RUN find / -name aws-java*jar | xargs rm
COPY ./lib/* /usr/hdp/2.6.3.0-235/hadoop/lib/

COPY ./files /

EXPOSE 9083

CMD /opt/bin/start-hive-metastore.sh
