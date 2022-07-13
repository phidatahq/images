FROM phidata/airflow:2.3.2

ARG SCALA_VERSION=2.13.8
ARG SCALA_VERSION_MAJOR=2.13
ARG SCALA_TAR=scala-${SCALA_VERSION}.tgz
ARG SCALA_HOME_DIR=/opt/scala
ARG SCALA_HOME=${SCALA_HOME_DIR}/scala-${SCALA_VERSION}
ARG SCALA_URL=https://downloads.lightbend.com/scala/${SCALA_VERSION}/${SCALA_TAR}

ARG SPARK_VERSION=3.2.0
ARG SPARK_TAR=spark-${SPARK_VERSION}-bin-hadoop3.2-scala2.13.tgz
ARG SPARK_HOME_DIR=/opt/spark
ARG SPARK_HOME=${SPARK_HOME_DIR}/spark-${SPARK_VERSION}-bin-hadoop3.2-scala2.13
ARG APACHE_MIRROR=https://archive.apache.org
ARG SPARK_URL=${APACHE_MIRROR}/dist/spark/spark-${SPARK_VERSION}/${SPARK_TAR}

RUN mkdir -p ${SCALA_HOME_DIR} ${SPARK_HOME_DIR}

RUN wget ${SCALA_URL} -O ${TMP_DIR}/${SCALA_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${SCALA_TAR} -C ${SCALA_HOME_DIR} \
  && rm ${TMP_DIR}/${SCALA_TAR}
ENV PATH=${SCALA_HOME}/bin:$PATH

RUN wget ${SPARK_URL} -O ${TMP_DIR}/${SPARK_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${SPARK_TAR} -C ${SPARK_HOME_DIR} \
  && rm ${TMP_DIR}/${SPARK_TAR}
ENV PATH=${SPARK_HOME}/bin:${SPARK_HOME}/sbin:$PATH

ENV SCALA_HOME=${SCALA_HOME}
ENV SPARK_HOME=${SPARK_HOME}