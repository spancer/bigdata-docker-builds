FROM flink:1.14.0-scala_2.11-java8

ENV FLINK_HOME /opt/flink

ADD 3rd-libs/*.jar $FLINK_HOME/lib/
ADD conf/flink-conf/*.yaml  $FLINK_HOME/conf/
ADD conf/hive-conf/*.xml  /opt/hive-conf/
		
ENV HADOOP_VERSION 3.2.2
ENV HADOOP_URL http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
RUN wget  $HADOOP_URL && \
        tar -xzvf hadoop-$HADOOP_VERSION.tar.gz -C /opt && \
        rm hadoop-$HADOOP_VERSION.tar.gz && \
		ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
ENV PATH $HADOOP_HOME/bin/:$PATH
ADD bin/config.sh $FLINK_HOME/bin
ADD conf/hdp-conf/*.xml /opt/hadoop-$HADOOP_VERSION/etc/hadoop/

