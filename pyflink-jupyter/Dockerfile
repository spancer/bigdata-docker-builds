# 使用Apache Flink官方镜像作为基础镜像
FROM flink:1.14.0

# 安装所需的软件包
USER root
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install jupyter notebook pyflink

# 将Apache Iceberg Jar文件添加到Flink lib目录
ARG ICEBERG_VERSION=0.12.1
ADD https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime/${ICEBERG_VERSION}/iceberg-flink-runtime-${ICEBERG_VERSION}.jar /opt/flink/lib/

# 添加Jupyter Notebook配置文件
COPY jupyter_notebook_config.py /root/.jupyter/

# 设置工作目录
WORKDIR /workspace

# 设置启动命令，启动Jupyter Notebook
CMD ["jupyter", "notebook", "--ip='*'", "--port=8888", "--no-browser", "--allow-root"]

EXPOSE 8888
