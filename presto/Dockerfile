FROM prestodb/centos6-oj8:2
LABEL maintainer="https://www.starburstdata.com/"

ARG presto_version=0.195-e.0.6
ARG dist_location=https://s3.us-east-2.amazonaws.com/starburstdata/presto/starburst/195e/${presto_version}

RUN set -xeu && \
    yum install -y util-linux `# uuidgen` && \
    rpm -vi "${dist_location}/presto-server-rpm-${presto_version}.x86_64.rpm" && \
    curl -fsSL "${dist_location}/presto-cli-${presto_version}-executable.jar" -o /usr/local/bin/presto-cli && \
    chmod -v +x /usr/local/bin/presto-cli && \
    ln -vs /usr/local/bin/presto-cli / `# backwards compatibility ` && \
    yum clean all && \
    echo OK

COPY etc /usr/lib/presto/etc

CMD /usr/lib/presto/bin/launcher run
