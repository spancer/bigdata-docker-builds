FROM flink:1.16.1-scala_2.12-java11

# Optional env variables
ENV FLINK_HOME=${FLINK_HOME:-"/opt/flink"}

RUN mkdir -p ${FLINK_HOME}  ${FLINK_HOME}/plugins/s3-fs-presto
ENV PATH=$FLINK_HOME/bin:$PATH
WORKDIR $FLINK_HOME

# Download flink iceberg related 
RUN curl https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-1.16/1.1.0/iceberg-flink-runtime-1.16-1.1.0.jar -Lo iceberg-flink-runtime-1.16-1.1.0.jar \
 && mv iceberg-flink-runtime-1.16-1.1.0.jar /opt/flink/opt/ \
 && cp  ${FLINK_HOME}/opt/flink-s3-fs-presto-1.16.1.jar ${FLINK_HOME}/plugins/s3-fs-presto/ \
 && curl https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar -Lo mysql-connector-java-8.0.30.jar \
 && mv mysql-connector-java-8.0.30.jar /opt/flink/opt/

ADD flink-conf.yaml  $FLINK_HOME/conf/

RUN chown -R flink:flink .