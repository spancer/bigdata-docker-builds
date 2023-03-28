FROM flink:1.16.1-scala_2.12-java11

ENV HADOOP_VERSION 3.2.3
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN set -x \
    && curl -fSL $HADOOP_URL -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
ENV PATH $HADOOP_HOME/bin/:$PATH

# Optional env variables
ENV FLINK_HOME=${FLINK_HOME:-"/opt/flink"}
ENV FLINK_PLUGIN_ICEBERG=${FLINK_PLUGIN_ICEBERG:-"/opt/flink/plugins/s3"}
RUN mkdir -p ${FLINK_PLUGIN_ICEBERG}  
ENV PATH=$FLINK_HOME/bin:$PATH
WORKDIR $FLINK_HOME

RUN wget -P ${FLINK_PLUGIN_ICEBERG}/ https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-hive-3.1.2_2.12/1.16.1/flink-sql-connector-hive-3.1.2_2.12-1.16.1.jar; \
    wget -P ${FLINK_PLUGIN_ICEBERG}/ https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-1.16/1.1.0/iceberg-flink-runtime-1.16-1.1.0.jar; \
    wget -P ${FLINK_PLUGIN_ICEBERG}/ https://repo1.maven.org/maven2/org/apache/flink/flink-connector-kafka/1.16.1/flink-connector-kafka-1.16.1.jar; \
    wget -P ${FLINK_PLUGIN_ICEBERG}/ https://repo1.maven.org/maven2/org/apache/flink/flink-connector-jdbc/1.16.1/flink-connector-jdbc-1.16.1.jar; \
    wget -P ${FLINK_PLUGIN_ICEBERG}/ https://jdbc.postgresql.org/download/postgresql-42.5.0.jar; \
    wget -P ${FLINK_PLUGIN_ICEBERG}/ https://repo1.maven.org/maven2/com/ververica/flink-sql-connector-mysql-cdc/2.3.0/flink-sql-connector-mysql-cdc-2.3.0.jar; \
    wget -P ${FLINK_PLUGIN_ICEBERG}/ https://repo1.maven.org/maven2/org/apache/thrift/libfb303/0.9.3/libfb303-0.9.3.jar; \
    wget -P ${FLINK_PLUGIN_ICEBERG}/ https://repository.cloudera.com/artifactory/cloudera-repos/org/apache/flink/flink-shaded-hadoop-3/3.1.1.7.2.9.0-173-9.0/flink-shaded-hadoop-3-3.1.1.7.2.9.0-173-9.0.jar; \
    wget -P ${FLINK_PLUGIN_ICEBERG}/ https://repo1.maven.org/maven2/org/apache/hive/hive-exec/3.1.2/hive-exec-3.1.2.jar; \
    wget -P ${FLINK_PLUGIN_ICEBERG}/ https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.17.257/bundle-2.17.257.jar; \
    wget -P ${FLINK_PLUGIN_ICEBERG}/ https://repo1.maven.org/maven2/software/amazon/awssdk/url-connection-client/2.17.257/url-connection-client-2.17.257.jar;

RUN cp  ${FLINK_HOME}/opt/flink-s3-fs-hadoop-1.16.1.jar ${FLINK_PLUGIN_ICEBERG}/

ADD config.sh ${FLINK_HOME}/bin/
ADD flink-conf.yaml  $FLINK_HOME/conf/
ADD sql-client-defaults.yaml  $FLINK_HOME/conf/
RUN chown -R flink:flink .