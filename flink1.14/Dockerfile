FROM flink:1.14.0-scala_2.11-java8

ENV FLINK_HOME /opt/flink

ENV HADOOP_VERSION 3.2.2
ENV HADOOP_URL http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
RUN wget  $HADOOP_URL && \
        tar -xzvf hadoop-$HADOOP_VERSION.tar.gz -C /opt && \
        rm hadoop-$HADOOP_VERSION.tar.gz && \
		ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
ENV PATH $HADOOP_HOME/bin/:$PATH

ADD conf/hdp-conf/*.xml /opt/hadoop-$HADOOP_VERSION/etc/hadoop/
RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

ADD alluxio-lib/alluxio-2.7.1-client.jar /opt/alluxio/client/
RUN echo "export HADOOP_CLASSPATH=/opt/alluxio/client/alluxio-*-client.jar:\${HADOOP_CLASSPATH}" >> /opt/hadoop-$HADOOP_VERSION/etc/hadoop/hadoop-env.sh
ADD iceberg-lib/*.jar $FLINK_HOME/lib/
ADD conf/hive-conf/*.xml  /opt/hive-conf/
ADD conf/flink-conf/*.yaml  $FLINK_HOME/conf/
ADD bin/config.sh $FLINK_HOME/bin

