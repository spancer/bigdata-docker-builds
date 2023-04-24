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

# 安装 Flink 和 Iceberg 需要的依赖
RUN pip install --no-cache-dir apache-flink==1.16.1 \
    && pip install --no-cache-dir pyiceberg==0.3.0 \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

# 设置 PyFlink 环境变量
ENV PYFLINK_PYTHON=python \
    PYFLINK_GATEWAY_PORT=8081 \
    PYFLINK_JAVA=/usr/bin/java \
    PYFLINK_HOME=/opt/flink \
    PATH=$PATH:/opt/flink/bin

# 下载并解压 Flink
RUN curl -O https://archive.apache.org/dist/flink/flink-1.16.1/flink-1.16.1-bin-scala_2.12.tgz \
    && tar -xzf flink-1.16.1-bin-scala_2.12.tgz \
    && rm flink-1.16.1-bin-scala_2.12.tgz \
    && mv flink-1.16.1 /opt/flink

# 配置 SSH，方便远程调试
RUN echo "root:root" | chpasswd \
    && mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config \
    && echo "export VISIBLE=now" >> /etc/profile

# 配置 Jupyter Notebook
RUN mkdir -p /root/.jupyter/ && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.notebook_dir = '/workspace'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py

# 暴露端口号
EXPOSE 8888 8081 22

# 启动 SSH 和 Jupyter Notebook
CMD ["/usr/sbin/sshd", "-D"] && jupyter notebook --allow-root