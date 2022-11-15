# syntax=docker/dockerfile:1
FROM python:3.9-bullseye

ENV TRINO_HOME=/opt/trino
ENV BIN_DIR=/usr/bin

ENV TRINO_DATA_DIR=/var/lib/trino/data
ENV INSTALL_DIR=/tmp/install

RUN mkdir -p ${TRINO_HOME} ${TRINO_DATA_DIR} ${INSTALL_DIR}

# install core packages 
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      sudo \
      curl \
      unzip \
      make \
      openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${INSTALL_DIR}

# Install python deps
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt \
    && rm requirements.txt

RUN curl https://repo1.maven.org/maven2/io/trino/trino-server/395/trino-server-395.tar.gz -Lo trino-server-395.tar.gz \
    && tar xvzf trino-server-395.tar.gz --directory ${TRINO_HOME} --strip-components 1 \
    && rm trino-server-395.tar.gz 

WORKDIR ${TRINO_HOME}

RUN mkdir ${TRINO_HOME}/plugin/udfs/ 
ADD plugin/udfs/trino-udf-395.jar ${TRINO_HOME}/plugin/udfs/
COPY etc/ ${TRINO_HOME}/etc

RUN chmod u+x ${TRINO_HOME}/bin/* 

EXPOSE 8080
EXPOSE 8083

CMD ["/opt/trino/bin/launcher", "run"]