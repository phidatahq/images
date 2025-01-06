FROM phidata/python:3.11.5
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
  libffi8 \
  libsasl2-2 \
  libsasl2-modules \
  libssl3 \
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
ARG AIRFLOW_VERSION=2.8.3
ENV AIRFLOW_VERSION=${AIRFLOW_VERSION}
ARG PYTHON_VERSION_ARG=3.11
ENV PYTHON_VERSION_ARG=${PYTHON_VERSION_ARG}
ARG CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION_ARG}.txt"
# Example: https://raw.githubusercontent.com/apache/airflow/constraints-2.4.2/constraints-3.9.txt
# Details: https://airflow.apache.org/docs/apache-airflow/stable/installation/installing-from-pypi.html#constraints-files
ARG AIRFLOW_EXTRAS="celery,redis,google_auth"
ENV AIRFLOW_EXTRAS=${AIRFLOW_EXTRAS}
RUN pip install -U "apache-airflow[${AIRFLOW_EXTRAS}]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

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
WORKDIR ${AIRFLOW_HOME}

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]
