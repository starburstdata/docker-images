FROM centos:7.5.1804
LABEL maintainer="https://www.starburstdata.com/"

ARG presto_version=332-e.0
ARG presto_arch=""
ARG dist_location=""

RUN yum -y install java-11-openjdk less && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    echo OK

COPY ./installdir /installdir

RUN set -xeu && \
    dist="$(/installdir/find-dist-location.sh "${dist_location}" "${presto_version}")" && \
    if [[ -z "${presto_arch}" ]]; then \
      presto_rpm="${dist}/trino-server-rpm-${presto_version}.rpm"; \
    else \
      presto_rpm="${dist}/trino-server-rpm-${presto_version}.${presto_arch}.rpm"; \
    fi && \
    yum -y localinstall "${presto_rpm}" && \
    rpm -qa | grep -q trino-server && \
    cli_location="${dist}/trino-cli-${presto_version}-executable.jar" && \
    if test -f "${cli_location}"; then \
        cp -a "${cli_location}" /usr/local/bin/trino-cli; \
    else \
        curl -fsSL "${cli_location}" -o /usr/local/bin/trino-cli; \
    fi && \
    chmod -v +x /usr/local/bin/trino-cli && \
    ln -vs /usr/local/bin/trino-cli / `# backwards compatibility ` && \
    yum clean all && \
    rm -vr /var/tmp && \
    rm -vr /installdir && \
    echo OK

COPY etc /usr/lib/trino/etc

CMD /usr/lib/trino/bin/launcher run
