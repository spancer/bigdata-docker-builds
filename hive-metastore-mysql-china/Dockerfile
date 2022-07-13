FROM openjdk:8-jre-slim-buster

WORKDIR /opt

ENV HADOOP_VERSION=3.2.3
ENV HIVE_METASTORE_VERSION=3.1.2

RUN apt-get update && apt-get install -y netcat curl

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${HIVE_METASTORE_VERSION}-bin

RUN curl -L https://repo1.maven.org/maven2/org/apache/hive/hive-standalone-metastore/${HIVE_METASTORE_VERSION}/hive-standalone-metastore-${HIVE_METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/core/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz | tar zxf - && \
    cp mysql-connector-java-8.0.19/mysql-connector-java-8.0.19.jar ${HIVE_HOME}/lib/ && \
    rm -rf  mysql-connector-java-8.0.19

COPY entrypoint.sh /entrypoint.sh

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive /entrypoint.sh && chmod +x /entrypoint.sh

USER hive
EXPOSE 9083

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
