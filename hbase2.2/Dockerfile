FROM alpine:latest
MAINTAINER spancer.ray<spancer.roc.ray@gmail.com>
RUN set -eux && \
    apk add --no-cache bash openjdk8-jre-base
      
ENV JAVA_HOME=/usr/

ARG HBASE_VERSION=2.2.6

ENV PATH $PATH:/opt/hbase/bin

LABEL Description="HBase" \
      "HBase Version"="$HBASE_VERSION"

WORKDIR /opt

# hadolint ignore=SC2039
RUN set -eux && \
    apk add --no-cache wget tar && \
    url="http://www.apache.org/dyn/closer.lua?filename=hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz&action=download" && \
    url_archive="http://archive.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz" && \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "hbase-$HBASE_VERSION-bin.tar.gz" "$url" || \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "hbase-$HBASE_VERSION-bin.tar.gz" "$url_archive" && \
    mkdir "hbase-$HBASE_VERSION" && \
    tar zxf "hbase-$HBASE_VERSION-bin.tar.gz" -C "hbase-$HBASE_VERSION" --strip 1 && \
    test -d "hbase-$HBASE_VERSION" && \
    ln -sv "hbase-$HBASE_VERSION" hbase && \
    rm -fv "hbase-$HBASE_VERSION-bin.tar.gz" && \
    rm -rf hbase/docs hbase/src && \
    mkdir /hbase-data && \
    apk del tar wget

# Needed for HBase 2.0+ hbase-shell
# asciidoctor solves 'NotImplementedError: fstat unimplemented unsupported or native support failed to load'
RUN bash -c ' \
    set -euxo pipefail && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache jruby jruby-irb asciidoctor && \
    echo exit | hbase shell \
    # jruby-maven jruby-minitest jruby-rdoc jruby-rake jruby-testunit && \
    '

VOLUME /hbase-data

COPY entrypoint.sh /
COPY conf/hbase-site.xml /opt/hbase/conf/
COPY profile.d/java.sh /etc/profile.d/

# Stargate  8080  / 8085
# Thrift    9090  / 9095
# HMaster   16000 / 16010
# RS        16201 / 16301
EXPOSE 2181 8080 8085 9090 9095 16000 16010 16030 16201 16301
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
