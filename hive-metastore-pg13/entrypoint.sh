#!/bin/sh

export JAVA_HOME=/usr/local/openjdk-8
export HADOOP_HOME=/opt/hadoop-3.2.3
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.901.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.2.3.jar
export RDB_HOSTNAME=${RDB_HOSTNAME:-localhost}

echo "Waiting for database on ${RDB_HOSTNAME} to launch on 5432 ..."

while ! nc -z ${RDB_HOSTNAME} 5432; do
  sleep 1
done

echo "Database on ${RDB_HOSTNAME}:5432 started"
echo "Init apache hive metastore on ${RDB_HOSTNAME}:5432"

/opt/apache-hive-metastore-3.1.2-bin/bin/schematool -initSchema -dbType postgres
/opt/apache-hive-metastore-3.1.2-bin/bin/start-metastore