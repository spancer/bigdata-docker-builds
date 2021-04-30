FROM alpine:latest
MAINTAINER spancer.ray<spancer.roc.ray@gmail.com>

ARG ZOOKEEPER_VERSION=3.4.14
ARG TAR=zookeeper-${ZOOKEEPER_VERSION}.tar.gz

ENV PATH $PATH:/zookeeper/bin

LABEL Description="ZooKeeper" \
      "ZooKeeper Version"="$ZOOKEEPER_VERSION"

WORKDIR /

# bash => entrypoint.sh
# java => zookeeper
RUN set -eux && \
    apk add --no-cache bash openjdk8-jre-base
RUN set -eux && \
    apk add --no-cache wget tar && \
    url_archive="https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${TAR}" && \
    wget -t 5 --retry-connrefused -O "$TAR" "$url_archive" && \
    tar zxf "${TAR}" && \
    rm -fv "${TAR}" && \
    mv /zookeeper-${ZOOKEEPER_VERSION}  /zookeeper && \
    cp -av /zookeeper/conf/zoo_sample.cfg /zookeeper/conf/zoo.cfg && \
    rm -rf zookeeper/src zookeeper/docs && \
    apk del wget tar

EXPOSE 2181 3181 4181

COPY entrypoint.sh /
RUN chmod a+x /entrypoint.sh
CMD ["/entrypoint.sh"]
