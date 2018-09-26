FROM prestodb/centos6-oj8:2
LABEL maintainer="https://www.starburstdata.com/"

ARG presto_version=0.195-e.0.6
ARG dist_location=""

COPY ./installdir /installdir

RUN set -xeu && \
    yum install -y util-linux `# uuidgen; TODO remove after https://github.com/prestodb/presto/pull/10670` && \
    dist="$(/installdir/find-dist-location.sh "${dist_location}" "${presto_version}")" && \
    yum -y localinstall "${dist}/presto-server-rpm-${presto_version}.x86_64.rpm" && \
    rpm -qa | grep -q presto-server && \
    cli_location="${dist}/presto-cli-${presto_version}-executable.jar" && \
    if test -f "${cli_location}"; then \
        cp -a "${cli_location}" /usr/local/bin/presto-cli; \
    else \
        curl -fsSL "${cli_location}" -o /usr/local/bin/presto-cli; \
    fi && \
    chmod -v +x /usr/local/bin/presto-cli && \
    ln -vs /usr/local/bin/presto-cli / `# backwards compatibility ` && \
    yum clean all && \
    rm -vr /installdir && \
    echo OK

COPY etc /usr/lib/presto/etc

CMD /usr/lib/presto/bin/launcher run
