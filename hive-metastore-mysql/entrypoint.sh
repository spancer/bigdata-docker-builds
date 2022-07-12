#!/bin/sh

export JAVA_HOME=/usr/local/openjdk-8
export HADOOP_HOME=/opt/hadoop-3.2.2
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.563.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.2.2.jar
export MYSQL_DB_HOSTNAME=${MYSQL_DB_HOSTNAME:-localhost}

echo "Waiting for database on ${MYSQL_DB_HOSTNAME} to launch on 3306 ..."

while ! nc -z ${MYSQL_DB_HOSTNAME} 3306; do
  sleep 1
done

echo "Database on ${MYSQL_DB_HOSTNAME}:3306 started"
echo "Init apache hive metastore on ${MYSQL_DB_HOSTNAME}:3306"

/opt/apache-hive-metastore-3.1.2-bin/bin/schematool -initSchema -dbType mysql
/opt/apache-hive-metastore-3.1.2-bin/bin/start-metastore