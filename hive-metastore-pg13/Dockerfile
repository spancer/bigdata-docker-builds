FROM openjdk:8-jre-slim-buster

WORKDIR /opt

ENV HADOOP_VERSION=3.2.3
ENV HIVE_METASTORE_VERSION=3.1.2

RUN apt-get update && apt-get install -y netcat curl

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${HIVE_METASTORE_VERSION}-bin

RUN curl -L https://repo1.maven.org/maven2/org/apache/hive/hive-standalone-metastore/${HIVE_METASTORE_VERSION}/hive-standalone-metastore-${HIVE_METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/core/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    curl -L https://jdbc.postgresql.org/download/postgresql-42.5.0.jar  -o $HIVE_HOME/lib/postgresql-jdbc.jar && \
    rm $HIVE_HOME/lib/guava-*.jar && \
    cp $HADOOP_HOME/share/hadoop/common/lib/guava-*.jar $HIVE_HOME/lib/

COPY entrypoint.sh /entrypoint.sh

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 9083

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
