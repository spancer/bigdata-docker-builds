FROM apache/flink:1.16.0-scala_2.12-java11

ARG USERID=1000
ARG GROUPID=1000

WORKDIR /work

RUN groupadd --system --gid=$GROUPID jupyter && \ 
useradd -m -u $USERID -g $GROUPID -s /bin/bash -d /work/ jupyter

# Configure Flink
ENV FLINK_HOME="/opt/flink"
ENV PYFLINK_GATEWAY_ADDRESS="localhost"
ENV PYFLINK_GATEWAY_PORT="6123"
ENV PYFLINK_PLANNER="blink"

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    curl \
    gnupg \
    unzip \
    postgresql-client && \
    apt-get clean;

# Install Java 11
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get clean;

# Install iJava kernel
RUN apt-get update && apt-get install -y \
    python3  python3-pip && \
    apt-get clean && \
    pip3 install jupyter && \
    curl -sSL https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip --output ijava.zip && \
    unzip ijava.zip && \
    python3 install.py --sys-prefix && \
    rm -rf ijava.zip && \
    rm -rf java

# Install Iceberg runtime
RUN apt-get update && apt-get install -y \
    maven && \
    apt-get clean;
RUN curl -L https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-1.16/1.2.0/iceberg-flink-runtime-1.16-1.2.0.jar --output ${FLINK_HOME}/lib/iceberg-flink-runtime-1.16-1.2.0.jar && \
    curl -L https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.18/postgresql-42.2.18.jar --output ${FLINK_HOME}/lib/postgresql-42.2.18.jar

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Set Jupyter password and run Jupyter
RUN jupyter notebook --generate-config && \
    echo "c.NotebookApp.password = 'sha1:admin'" >> /root/.jupyter/jupyter_notebook_config.py
EXPOSE 8888
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser"]

# Start Flink in the background
CMD ["/opt/flink/bin/start-cluster.sh"]
