FROM phidata/java:11

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
# Default settings for Spark
ENV SPARK_LOGS_DIR=${SPARK_HOME}/logs
ENV SPARK_DRIVER_LOG=${SPARK_LOGS_DIR}/spark-driver.out
ENV SPARK_WORKER_LOG=${SPARK_LOGS_DIR}/spark-worker.out

RUN mkdir -p $SPARK_LOGS_DIR && \
  touch $SPARK_DRIVER_LOG && \
  touch $SPARK_WORKER_LOG && \
  ln -sf /dev/stdout $SPARK_DRIVER_LOG && \
  ln -sf /dev/stdout $SPARK_WORKER_LOG

EXPOSE 8080 7077

COPY scripts ${SCRIPTS_DIR}
ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]