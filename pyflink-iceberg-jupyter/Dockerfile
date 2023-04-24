# 使用 Python 基础镜像
FROM python:3.9-bullseye

# 更新软件包列表并安装依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      sudo \
      curl \
      vim \
      unzip \
      openjdk-11-jdk \
      build-essential \
      software-properties-common \
      ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 安装 Jupyter
RUN pip install --no-cache-dir jupyter

# 下载并安装 IJava 内核
RUN wget https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip \
    && unzip ijava-1.3.0.zip -d /ijava \
    && rm ijava-1.3.0.zip

# 为 Jupyter 配置 IJava 内核
RUN python /ijava/install.py --sys-prefix

# 将工作目录设置为 /workspace
WORKDIR /workspace

# 安装 Flink 和 Iceberg 需要的依赖和库
ENV FLINK_VERSION=1.16.1
ENV FLINK_INSTALL_PATH=/opt/flink
RUN mkdir -p ${FLINK_INSTALL_PATH} \
 && curl -L -o /tmp/flink.tgz https://archive.apache.org/dist/flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-scala_2.12.tgz \
 && tar xfz /tmp/flink.tgz -C ${FLINK_INSTALL_PATH} --strip-components=1 \
 && rm -f /tmp/flink.tgz

RUN curl -L https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-1.16/1.2.1/iceberg-flink-runtime-1.16-1.2.1.jar --output ${FLINK_INSTALL_PATH}/lib/iceberg-flink-runtime-1.16-1.2.1.jar && \
    curl -L https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.18/postgresql-42.2.18.jar --output ${FLINK_INSTALL_PATH}/lib/postgresql-42.2.18.jar && \
    curl -L https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.17.257/bundle-2.17.257.jar --output ${FLINK_INSTALL_PATH}/lib/bundle-2.17.257.jar && \
    curl -L https://repo1.maven.org/maven2/software/amazon/awssdk/url-connection-client/2.17.257/url-connection-client-2.17.257.jar --output ${FLINK_INSTALL_PATH}/lib/url-connection-client-2.17.257.jar

RUN cp  ${FLINK_INSTALL_PATH}/opt/flink-s3-fs-hadoop-1.16.1.jar ${FLINK_INSTALL_PATH}/lib/

# Install PyFlink
RUN pip install apache-flink==1.16.1

# Set environment variables
ENV FLINK_HOME=${FLINK_INSTALL_PATH}
ENV PATH=${PATH}:${FLINK_HOME}/bin

RUN pip install --no-cache-dir apache-flink

# Configure Iceberg to use Minio and PostgreSQL for metadata management
COPY iceberg-catalog.properties $FLINK_HOME/conf/iceberg-catalog.properties

# 暴露 Jupyter 的默认端口
EXPOSE 8888

# 启动 Jupyter 服务器
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
