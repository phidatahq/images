FROM phidata/python:3.9.12
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

# Create user and home dir
ARG USER=airflow
ARG HOME_DIR=${USER_LOCAL_DIR}/${USER}
ARG AIRFLOW_HOME=${HOME_DIR}

RUN groupadd -g 61000 ${USER} \
  && useradd -g 61000 -u 61000 -ms /bin/bash -d ${HOME_DIR} ${USER}

ENV HOME_DIR=${HOME_DIR}
ENV AIRFLOW_HOME=${AIRFLOW_HOME}

# Install base libraries
ENV DEBIAN_FRONTEND=noninteractive
RUN set -x \
  && airflowBuildDeps=' \
  freetds-bin \
  krb5-user \
  ldap-utils \
  libffi6 \
  libsasl2-2 \
  libsasl2-modules \
  libssl1.1 \
  locales  \
  lsb-release \
  sasl2-bin \
  sqlite3 \
  unixodbc ' \
  && apt-get update \
  && apt-get install -y \
  postgresql-client \
  $airflowBuildDeps \
  # Needed for airflow: https://airflow.apache.org/docs/apache-airflow/stable/installation.html#installation-tools
  && pip install -U pip pip-tools setuptools wheel

# Install airflow
ARG AIRFLOW_VERSION=2.3.3
ENV AIRFLOW_VERSION=${AIRFLOW_VERSION}
ARG PYTHON_VERSION_ARG=3.9
ENV PYTHON_VERSION_ARG=${PYTHON_VERSION_ARG}
ARG CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION_ARG}.txt"
# Example: https://raw.githubusercontent.com/apache/airflow/constraints-2.2.4/constraints-3.9.txt
# Details: https://airflow.apache.org/docs/apache-airflow/stable/installation/installing-from-pypi.html#constraints-files
ARG AIRFLOW_EXTRAS="celery,redis,postgres,google_auth"
ENV AIRFLOW_EXTRAS=${AIRFLOW_EXTRAS}
RUN pip install -U "apache-airflow[${AIRFLOW_EXTRAS}]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Install java 11
ARG CORETTO_TAR=amazon-corretto-11-x64-linux-jdk.tar.gz
ARG CORETTO_URL=https://corretto.aws/downloads/latest/${CORETTO_TAR}

RUN wget ${CORETTO_URL} -O ${TMP_DIR}/${CORETTO_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${CORETTO_TAR} -C ${BIN_DIR} \
  && rm ${TMP_DIR}/${CORETTO_TAR}

ENV PATH=${PATH}:${BIN_DIR}/amazon-corretto-11.0.15.9.1-linux-x64/bin
ENV JAVA_HOME=${BIN_DIR}/amazon-corretto-11.0.15.9.1-linux-x64

# Clean
RUN apt-get autoremove -y --purge \
  && apt-get clean \
  && rm -rf \
  /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/* \
  /usr/share/man \
  /usr/share/doc \
  /usr/share/doc-base

COPY scripts ${SCRIPTS_DIR}

EXPOSE 8080 5555
WORKDIR /

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]
