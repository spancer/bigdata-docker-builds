FROM coomia/flink:1.14

MAINTAINER spancer.ray<spancer.roc.ray@gmail.com>

ENV HADOOP_VERSION 3.2.2
ENV HADOOP_HOME /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop

#Install zeppelin
RUN apt-get update && apt-get install -y wget procps && \
	wget https://dlcdn.apache.org/zeppelin/zeppelin-0.10.1/zeppelin-0.10.1-bin-all.tgz && \
	tar -xzvf zeppelin-0.10.1-bin-all.tgz -C /opt/ && \
	mv /opt/zeppelin-* /opt/zeppelin && \
	mkdir /opt/zeppelin/logs && \
	apt-get --purge remove -y wget && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ADD conf/zeppelin-env.sh /opt/zeppelin/conf/
ADD conf/zeppelin-site.xml /opt/zeppelin/conf/

WORKDIR /opt/zeppelin

CMD ["/opt/zeppelin/bin/zeppelin.sh"]