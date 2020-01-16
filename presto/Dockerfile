FROM centos:7.5.1804
LABEL maintainer="https://www.starburstdata.com/"

ARG presto_archive
ARG presto_cli

ENV JAVA_HOME /usr/lib/jvm/java-11
RUN \
    set -xeu && \
    yum -y -q update && \
    yum -y -q install java-11-openjdk-devel less && \
    yum -q clean all && \
    rm -rf /var/cache/yum && \
    rm -rf /tmp/* /var/tmp/* && \
    groupadd presto --gid 1000 && \
    useradd presto --uid 1000 --gid 1000 && \
    mkdir -p /usr/lib/presto /data/presto && \
    chown -R "presto:presto" /usr/lib/presto /data/presto

COPY --chown=presto:presto ${presto_cli} /usr/local/bin/presto-cli
COPY --chown=presto:presto ${presto_archive} /usr/lib/presto
COPY etc /usr/lib/presto/etc

RUN \
    set -xeu && \
    chmod -v +x /usr/local/bin/presto-cli && \
    ln -vs /usr/local/bin/presto-cli / `# backwards compatibility `

EXPOSE 8080
USER presto:presto
ENV LANG en_US.UTF-8
CMD ["/usr/lib/presto/bin/run-presto"]
