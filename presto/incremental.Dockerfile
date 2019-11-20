# Warning: This is for development purposes only.

ARG BASE_IMAGE
FROM ${BASE_IMAGE}
LABEL maintainer="https://www.starburstdata.com/"

ARG presto_version
ARG dist_location

COPY ./installdir /installdir

RUN set -xeu && \
    yum -y install rsync && \
    mkdir /tmp/presto && cd /tmp/presto && rpm2cpio "${dist_location}/presto-server-rpm-${presto_version}.x86_64.rpm" | cpio -idm && \
    rsync -ir --checksum /tmp/presto/ / && \
    cli_location="${dist_location}/presto-cli-${presto_version}-executable.jar" && \
    rsync -i --checksum "${cli_location}" /usr/local/bin/presto-cli && \
    chmod -v +x /usr/local/bin/presto-cli && \
    ln -fvs /usr/local/bin/presto-cli / `# backwards compatibility ` && \
    yum clean all && \
    rm -vr /installdir && \
    rm -r /tmp/presto && \
    echo OK
