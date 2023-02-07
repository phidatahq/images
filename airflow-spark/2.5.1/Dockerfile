FROM phidata/airflow:2.5.1

# Spark runs on Java 8/11/17, Scala 2.12/2.13, Python 3.7+
# Install Java 11 from https://github.com/corretto/corretto-11/releases
ARG JAVA_FOLDER=java-11
ARG CORRETO_VERSION=11.0.18.10.1
RUN set -x && \
  # Get arch
  arch=$(uname -m) && \
  if [ "${arch}" = "aarch64" ]; then \
  arch="aarch64"; \
  else arch="x64"; \
  fi \
  && CORETTO_ARTIFACT=amazon-corretto-${CORRETO_VERSION}-linux-${arch} \
  && CORETTO_TAR=${CORETTO_ARTIFACT}.tar.gz \
  && CORETTO_URL=https://corretto.aws/downloads/resources/${CORRETO_VERSION}/${CORETTO_TAR} \
  && wget ${CORETTO_URL} -O ${TMP_DIR}/${CORETTO_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${CORETTO_TAR} -C ${BIN_DIR} \
  && mv ${BIN_DIR}/${CORETTO_ARTIFACT} ${BIN_DIR}/${JAVA_FOLDER} \
  && rm ${TMP_DIR}/${CORETTO_TAR}
ENV PATH=${PATH}:${BIN_DIR}/${JAVA_FOLDER}/bin
ENV JAVA_HOME=${BIN_DIR}/${JAVA_FOLDER}

# Scala 2.13.10
ARG SCALA_VERSION=2.13.10
ENV SPARK_SCALA_VERSION=2.13
ARG SCALA_TAR=scala-${SCALA_VERSION}.tgz
ARG SCALA_HOME_DIR=/opt/scala
ARG SCALA_HOME=${SCALA_HOME_DIR}/scala-${SCALA_VERSION}
ARG SCALA_URL=https://downloads.lightbend.com/scala/${SCALA_VERSION}/${SCALA_TAR}

# Spark 3.3.1
ARG SPARK_VERSION=3.3.1
ARG SPARK_TAR=spark-${SPARK_VERSION}-bin-hadoop3-scala2.13
ARG SPARK_HOME_DIR=/opt/spark
ARG SPARK_HOME=${SPARK_HOME_DIR}/${SPARK_TAR}
ARG APACHE_MIRROR=https://archive.apache.org
ARG SPARK_URL=${APACHE_MIRROR}/dist/spark/spark-${SPARK_VERSION}/${SPARK_TAR}.tgz

RUN mkdir -p ${SCALA_HOME_DIR} ${SPARK_HOME_DIR}

# Install Scala 2.13.10
RUN wget ${SCALA_URL} -O ${TMP_DIR}/${SCALA_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${SCALA_TAR} -C ${SCALA_HOME_DIR} \
  && rm ${TMP_DIR}/${SCALA_TAR}

# Set scala environment variables
ENV PATH=${SCALA_HOME}/bin:$PATH
ENV SCALA_HOME=${SCALA_HOME}
ENV SCALA_VERSION=${SCALA_VERSION}

# Install Spark 3.3.1
RUN wget ${SPARK_URL} -O ${TMP_DIR}/${SPARK_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${SPARK_TAR} -C ${SPARK_HOME_DIR} \
  && rm ${TMP_DIR}/${SPARK_TAR}

# Set spark environment variables
ENV PATH=${SPARK_HOME}/bin:${SPARK_HOME}/sbin:$PATH
ENV SPARK_HOME=${SPARK_HOME}
ENV SPARK_VERSION=${SPARK_VERSION}
ENV HADOOP_VERSION=3.3
# Fix the value of PYTHONHASHSEED
ENV PYTHONHASHSEED=1
